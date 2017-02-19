<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xmi="http://www.omg.org/spec/XMI/20131001" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ecore="http://www.eclipse.org/emf/2002/Ecore" xmlns:uml="http://www.eclipse.org/uml2/5.0.0/UML" xmlns:OpenModel_Profile="http:///schemas/OpenModel_Profile/_NDJbQJNqEeWP45fAG0gIqg/12">
	<!-- output defintions -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
	<!-- parameter -->
	<xsl:param name="tool">  p+r-mwim</xsl:param>
	<xsl:param name="showObsolete">false</xsl:param>
	<xsl:variable name="lookupDoc" select="fn:document('PriorityLookup.xml')"/>
	<xsl:variable name="previousLookupDoc" select="fn:document('../input/previousMicrowaveModel.uml')"/>
	<!-- keys -->
	<xsl:key name="attributePriority" match="attribute" use="@id"/>
	<xsl:key name="classPriority" match="class" use="@id"/>
	<xsl:key name="attRef" match="ownedAttribute" use="@xmi:id"/>
	<xsl:key name="idRef" match="*" use="@xmi:id"/>
	<xsl:key name="obsoleteRefs" match="OpenModel_Profile:Obsolete" use="@base_Element"/>
    <!-- templates -->

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

