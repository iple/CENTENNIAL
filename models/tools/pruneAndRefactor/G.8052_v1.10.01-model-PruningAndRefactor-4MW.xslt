<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xmi="http://www.omg.org/spec/XMI/20131001" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ecore="http://www.eclipse.org/emf/2002/Ecore" xmlns:uml="http://www.eclipse.org/uml2/5.0.0/UML" xmlns:OpenModel_Profile="http:///schemas/OpenModel_Profile/_NDJbQJNqEeWP45fAG0gIqg/12">
	<!-- output defintions -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
	<!-- parameter -->
	<xsl:param name="tool">  p+r-mwim</xsl:param>
	<xsl:param name="showObsolete">false</xsl:param>
	<xsl:variable name="lookupDoc" select="fn:document('PriorityLookup.xml')"/>
	<!-- keys -->
	<xsl:key name="attributePriority" match="attribute" use="@id"/>
	<xsl:key name="classPriority" match="class" use="@id"/>
	<xsl:key name="attRef" match="ownedAttribute" use="@xmi:id"/>
	<xsl:key name="idRef" match="*" use="@xmi:id"/>
	<xsl:key name="obsoleteRefs" match="OpenModel_Profile:Obsolete" use="@base_Element"/>
    <!-- templates -->


    <xsl:template match="packagedElement[@xmi:type='uml:Class' and @name='G8052NetworkElement']"/>
    <xsl:template match="packagedElement[@xmi:type='uml:Class' and @name='###G8052GlobalClass']"/>
    <xsl:template match="packagedElement[@xmi:type='uml:Class' and @name='G8052LocalClass']"/>

    <xsl:template match="packagedElement[@xmi:type='uml:Class' and @name='EthernetNetworkElement']"/>
    <xsl:template match="packagedElement[@xmi:type='uml:Class' and @name='ETH_ConnectionFunction']"/>
    <xsl:template match="packagedElement[@xmi:type='uml:Class' and @name='ETH_CrossConnection']"/>
    <xsl:template match="packagedElement[@xmi:type='uml:Class' and @name='AddressTable']"/>
    <xsl:template match="packagedElement[@xmi:type='uml:Class' and @name='AggregationPort']"/>
    <xsl:template match="packagedElement[@xmi:type='uml:Class' and @name='ETH_SubNetworkConnectionProtectionGroup']"/>
    <xsl:template match="packagedElement[@xmi:type='uml:Class' and @name='ETH_PortGroup']"/>
    <xsl:template match="packagedElement[@xmi:type='uml:Class' and @name='ETH_RingAutomaticProtectionSwitchingGroup']"/>
    <xsl:template match="packagedElement[@xmi:type='uml:Class' and @name='PhysicalSubsystem']"/>
    <xsl:template match="packagedElement[@xmi:type='uml:Class' and @name='ThresholdProfile']"/>
    <xsl:template match="packagedElement[@xmi:type='uml:Class' and @name='ETH_TrailTerminationPointBidirectional']"/>
    <xsl:template match="packagedElement[@xmi:type='uml:Class' and @name='ETH_TrailTerminationPoint']"/>
    <xsl:template match="packagedElement[@xmi:type='uml:Class' and @name='ETH_TrailTerminationPointSource']"/>
    <xsl:template match="packagedElement[@xmi:type='uml:Class' and @name='ETH_TrailTerminationPointSink']"/>
    <xsl:template match="packagedElement[@xmi:type='uml:Class' and @name='EthServerTtpSource_Pac']"/>
    <xsl:template match="packagedElement[@xmi:type='uml:Class' and @name='EthServerTtpSink_Pac']"/>
    <xsl:template match="packagedElement[@xmi:type='uml:Class' and @name='ETH_ConnectionTerminationPointBidirectional']"/>
    <xsl:template match="packagedElement[@xmi:type='uml:Class' and @name='ETY_TrailTerminationPointBidirectional']"/>
    <xsl:template match="packagedElement[@xmi:type='uml:Class' and @name='MepBidirectional']"/>
    <xsl:template match="packagedElement[@xmi:type='uml:Class' and @name='MCC_ConnectionTerminationPointBidirectional']"/>
    <xsl:template match="packagedElement[@xmi:type='uml:Class' and @name='ETH_ConnectionTerminationPointPool']"/>



<!-- one currentProblemList to much -->
    <xsl:template match="ownedAttribute[@xmi:type='uml:Property' and @xmi:id='_rz0BMOxdEeGzwM2Uvwf5Xw']"/>







	<!-- generic -->
	<xsl:template match="* | @* | text()">
		<xsl:copy>
			<xsl:apply-templates select="* | @* | text()"/>
		</xsl:copy>
	</xsl:template>
	<!-- functions -->
	<xsl:template name="log">
		<xsl:param name="level">INFO </xsl:param>
		<xsl:param name="message"/>
		<xsl:message>
			<xsl:sequence select="fn:string(fn:adjust-dateTime-to-timezone(xs:dateTime( fn:current-dateTime() ), xs:dayTimeDuration('PT0H') ) )"/>
			<xsl:text> | </xsl:text>
			<xsl:value-of select="$tool"/>
			<xsl:text> | </xsl:text>
			<xsl:value-of select="$level"/>
			<xsl:text> | </xsl:text>
			<xsl:value-of select="$message"/>
		</xsl:message>
	</xsl:template>
</xsl:stylesheet>

