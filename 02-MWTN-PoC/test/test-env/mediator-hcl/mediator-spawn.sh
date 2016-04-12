#!/bin/bash
#
# mediator-spawn - Spawn HCL-MEDIATORS
#
# Copyright (C) 2016 HCL Technologies
#
# Author: Paolo Rovelli <paolo.rovelli@hcl.com>  
#

if [ $# -ne 1 ]
then
    echo "Usage: mediator-spawn <config.json>"
    exit 0
fi

MEDIATOR_IDX=-1
MEDIATOR_NUM=$(jq -r '.topology | length' ${1})
MEDIATOR_IMAGE=$(jq -r '.["mediator-hcl"]'.image ${1})
MEDIATOR_VERSION=$(jq -r '.["mediator-hcl"]'.version ${1})

MEDIATOR_SRC=/mnt/mediator
MEDIATOR_DST=/usr/local/etc/netopeer/cfgnetopeer
MEDIATOR_PATH=$(dirname $(readlink -f ${0}))

MODEL_SRC=/mnt/model
MODEL_DST=/usr/local/etc/netopeer/cfgnetopeer
MODEL_PATH=$(dirname $(readlink -f ${1}))/$(jq -r '.model.path' ${1})

while [ ${MEDIATOR_IDX} -lt ${MEDIATOR_NUM} ]; do

    MEDIATOR_IDX=$[${MEDIATOR_IDX}+1]
    MEDIATOR_TYPE=$(jq -r '.topology['${MEDIATOR_IDX}'].type' ${1})
    if [ "${MEDIATOR_TYPE}" != "mediator-hcl" ]; then
        continue
    fi
    MEDIATOR_NAME=$(jq -r '.topology['${MEDIATOR_IDX}'].name' ${1})

    # Clean any previously defined MEDIATOR container
    docker rm -f ${MEDIATOR_NAME} > /dev/null 2>&1

    # Spin up the MEDIATOR container
    echo -n "Spawn '${MEDIATOR_NAME}' ... "
    docker run --name ${MEDIATOR_NAME} \
        -v ${MODEL_PATH}:${MODEL_SRC} \
        -v ${MEDIATOR_PATH}:${MEDIATOR_SRC} \
        -dit ${MEDIATOR_IMAGE}${MEDIATOR_VERSION} \
        /bin/bash > /dev/null 2>&1
    docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${MEDIATOR_NAME}

    # Copy the MEDIATOR models and start-up datastores to the target
    for x in ${MODEL_PATH}/*.{yang,xml}; do
        docker exec ${MEDIATOR_NAME} cp \
            ${MODEL_SRC}/${x##*/} \
            ${MODEL_DST}/${x##*/}
    done

    # Translate the MEDIATOR models to YIN format
    MODEL_MAIN=$(jq -r .model.list[].main ${1})
    MODEL_DEPS=$(jq -r .model.list[].deps[] ${1})
    MODEL_DEPS=$(awk 'BEGIN{RS=ORS=" "}!a[$0]++' <<< ${MODEL_DEPS})
    for x in ${MODEL_MAIN} ${MODEL_DEPS}; do
        docker exec ${MEDIATOR_NAME} pyang \
            -f yin \
            -p ${MODEL_DST} \
            -o ${MODEL_DST}/${x}.yin \
            ${MODEL_DST}/${x}.yang
    done

    # Register the MEDIATOR main models and their imported modules
    MODEL_MAIN=($(jq -r .model.list[].main ${1}))
    for i in ${!MODEL_MAIN[@]}; do 
        echo " - install '${MODEL_MAIN[${i}]}'"
        docker exec ${MEDIATOR_NAME} netopeer-manager add \
            --name ${MODEL_MAIN[${i}]} \
            --model ${MODEL_DST}/${MODEL_MAIN[${i}]}.yin \
            --datastore ${MODEL_DST}/${MODEL_MAIN[${i}]}.xml
        MODEL_DEPS=($(jq -r .model.list[${i}].deps[] ${1}))
        for j in ${!MODEL_DEPS[@]}; do 
            echo "    - import '${MODEL_DEPS[${j}]}'"
            docker exec ${MEDIATOR_NAME} netopeer-manager add \
                --name ${MODEL_MAIN[${i}]} \
                --import ${MODEL_DST}/${MODEL_DEPS[${j}]}.yin
        done
    done

    # Start the MEDIATOR
    echo -n "Start '${MEDIATOR_NAME}' NETCONF server ..."
    docker exec ${MEDIATOR_NAME} netopeer-server -d
    echo " ok."
    echo ""

done

