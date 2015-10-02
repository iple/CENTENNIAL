/*
 * Copyright 2014-2015 Open Networking Laboratory
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.onosproject.cli.net;

import org.apache.karaf.shell.commands.Argument;
import org.apache.karaf.shell.commands.Command;
import org.onosproject.net.Link;
import org.onosproject.net.link.LinkService;

import org.onosproject.net.ConnectPoint;
import org.onosproject.net.flow.TrafficSelector;
import org.onosproject.net.flow.TrafficTreatment;
import org.onosproject.net.intent.Constraint;
import org.onosproject.net.intent.Intent;
import org.onosproject.net.intent.IntentService;
import org.onosproject.net.intent.LinkCollectionIntent;

import com.google.common.collect.ImmutableSet;

import java.util.HashSet;
import java.util.List;

/**
 * Installs point-to-point connectivity extra intent.
 */
@Command(scope = "onos", name = "add-point-intent-ext",
         description = "Installs point-to-point connectivity extended intent")
public class AddPointToPointIntentExtendedCommand extends ConnectivityIntentCommand {

    @Argument(index = 0, name = "ingressDevice",
              description = "Ingress Device/Port Description",
              required = true, multiValued = false)
    private String ingressDeviceString = null;

    @Argument(index = 1, name = "egressDevice",
              description = "Egress Device/Port Description",
              required = true, multiValued = false)
    private String egressDeviceString = null;

    @Argument(index = 2, name = "ingressLink1Port",
              description = "Ingress Device/Port Description",
              required = true, multiValued = false)
    private String ingressLink1PortString = null;

    @Argument(index = 3, name = "egressLink1Port",
              description = "Egress Device/Port Description",
              required = true, multiValued = false)
    private String egressLink1PortString = null;

    @Argument(index = 4, name = "ingressLink2Port",
              description = "Ingress Device/Port Description",
              required = false, multiValued = false)
    private String ingressLink2PortString = null;

    @Argument(index = 5, name = "egressLink2Port",
              description = "Egress Device/Port Description",
              required = false, multiValued = false)
    private String egressLink2PortString = null;

    @Argument(index = 6, name = "ingressLink3Port",
              description = "Ingress Device/Port Description",
              required = false, multiValued = false)
    private String ingressLink3PortString = null;

    @Argument(index = 7, name = "egressLink3Port",
              description = "Egress Device/Port Description",
              required = false, multiValued = false)
    private String egressLink3PortString = null;

    @Argument(index = 8, name = "ingressLink4Port",
              description = "Ingress Device/Port Description",
              required = false, multiValued = false)
    private String ingressLink4PortString = null;

    @Argument(index = 9, name = "egressLink4Port",
              description = "Egress Device/Port Description",
              required = false, multiValued = false)
    private String egressLink4PortString = null;

    @Argument(index = 10, name = "ingressLink5Port",
              description = "Ingress Device/Port Description",
              required = false, multiValued = false)
    String ingressLink5PortString = null;

    @Argument(index = 11, name = "egressLink5Port",
              description = "Egress Device/Port Description",
              required = false, multiValued = false)
    String egressLink5PortString = null;

    @Override
    protected void execute() {
        IntentService intentService = get(IntentService.class);

        ConnectPoint ingressDev = ConnectPoint.deviceConnectPoint(ingressDeviceString);

        ConnectPoint egressDev = ConnectPoint.deviceConnectPoint(egressDeviceString);


        LinkService linkService = get(LinkService.class);

        final HashSet<Link> links = new HashSet<>();

        ConnectPoint ingressLink = ConnectPoint.deviceConnectPoint(ingressLink1PortString);

        ConnectPoint egressLink = ConnectPoint.deviceConnectPoint(egressLink1PortString);

        Link link = linkService.getLink(ingressLink, egressLink);
        links.add(link);

        if (ingressLink2PortString != null && egressLink2PortString != null) {
            ingressLink = ConnectPoint.deviceConnectPoint(ingressLink2PortString);
            egressLink = ConnectPoint.deviceConnectPoint(egressLink2PortString);

            link = linkService.getLink(ingressLink, egressLink);
            links.add(link);
        }

        if (ingressLink3PortString != null && egressLink3PortString != null) {
            ingressLink = ConnectPoint.deviceConnectPoint(ingressLink3PortString);
            egressLink = ConnectPoint.deviceConnectPoint(egressLink3PortString);

            link = linkService.getLink(ingressLink, egressLink);
            links.add(link);
        }

        if (ingressLink4PortString != null && egressLink4PortString != null) {
            ingressLink = ConnectPoint.deviceConnectPoint(ingressLink4PortString);
            egressLink = ConnectPoint.deviceConnectPoint(egressLink4PortString);

            link = linkService.getLink(ingressLink, egressLink);
            links.add(link);
        }

        if (ingressLink5PortString != null && egressLink5PortString != null) {
            ingressLink = ConnectPoint.deviceConnectPoint(ingressLink5PortString);
            egressLink = ConnectPoint.deviceConnectPoint(egressLink5PortString);

            link = linkService.getLink(ingressLink, egressLink);
            links.add(link);
        }


        TrafficSelector selector = buildTrafficSelector();
        TrafficTreatment treatment = buildTrafficTreatment();

        List<Constraint> constraints = buildConstraints();

        Intent intent = LinkCollectionIntent.builder()
                .appId(appId())
                .key(key())
                .selector(selector)
                .treatment(treatment)
                .links(links)
                .ingressPoints(ImmutableSet.of(ingressDev))
                .egressPoints(ImmutableSet.of(egressDev))
                .constraints(constraints)
                .priority(priority())
                .build();
        intentService.submit(intent);
        print("link intent submitted:\n%s", intent.toString());
    }
}
