<?xml version="1.0"?>
<!--
    Title: MAP_function2component.xsl
    Purpose: An XSL stylesheet for mapping of appliction functions and one application component in the Archi.Archimate. Helper XSL for this mapping in case of nonexisting mapping

    Version:  February 11, 2013
	pro Archimate version 2.2.0
	
	Input: 
		1. XPath containing pattern for selecting the application functions in Archimate (folder, ...). Only top level will be considered.
		2. XPath containing pattern for selecting the existing Component
		3. XPath containing pattern for selecting the existing interface
		4. XPath containing pattern for selecting the existing relations between application functions
	Output:
		Script creates one Application Service for each top level Application Function ("block") and 
			a) assign component to the top level function: archimate:AssignmentRelationship
			b) assign this top level function to the service: archimate:RealisationRelationship
			c) assign this service to the existing interface: archimate:AssignmentRelationship
    
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:archimate="http://www.bolton.ac.uk/archimate" xmlns:uml="http://schema.omg.org/spec/UML/2.1" xmlns:xmi="http://schema.omg.org/spec/XMI/2.1" version="2.0" >
	<xsl:output method="xml" indent="yes"  omit-xml-declaration="yes"/>
		
		<xsl:variable name="interface" select="/archimate:model/folder[@name='Application']/folder[@name='Structure']/folder[@name='APP.LANDSCAPE.EA.COMMON']/element[@name='Intfc_BSL']"/>
		<xsl:variable name="_functions" select="/archimate:model/folder[@name='Application']/folder[@name='Behaviour']/folder[@name='BSLFncAnal']/element[@xsi:type='archimate:ApplicationFunction']"/>
		<xsl:variable name="component" select="/archimate:model/folder[@name='Application']/folder[@name='Structure']/folder[@name='APP.LANDSCAPE.EA.COMMON']/element[@name='BSL']"/>
		<xsl:variable name="relations" select="/archimate:model/folder[@name='Relations']/folder[@name='BSLFncAnal']/element[@xsi:type='archimate:CompositionRelationship']"/>
		
		<xsl:variable name="functions">
			<xroot>
				<xsl:for-each select="$_functions">
					<xsl:variable name="_id" select="./@id"/>
					<!-- <xsl:variable name="_relation" select="$relations[@source=$_id]"/> -->

					<!-- Top level function? i.e. without following-->
					<xsl:variable name="_cnt" select="count($relations[@target=$_id])"/>
					<xsl:if test="$_cnt=0">
						<!-- Component to Function-->
						<xsl:element name="element">
							<xsl:attribute name="xsi:type">archimate:AssignmentRelationship</xsl:attribute>
							<xsl:attribute name="id"><xsl:value-of  select="concat($_id,'FncCmpRel_')"/></xsl:attribute>
							<!--component-->
							<xsl:attribute name="source"><xsl:value-of select="$component/@id"/></xsl:attribute>
							<!--function-->
							<xsl:attribute name="target"><xsl:value-of select="$_id"/></xsl:attribute>
						</xsl:element>

						<!-- Create Service -->
						<xsl:element name="element">
							<xsl:attribute name="xsi:type">archimate:ApplicationService</xsl:attribute>
							<xsl:attribute name="id"><xsl:value-of  select="concat($_id,'Svc_')"/></xsl:attribute>
							<xsl:attribute name="name"><xsl:value-of  select="concat('Svc_',./@name)"/></xsl:attribute>
						</xsl:element>


						<!-- Service to Function-->
						<xsl:element name="element">
							<xsl:attribute name="xsi:type">archimate:RealisationRelationship</xsl:attribute>
							<xsl:attribute name="id"><xsl:value-of  select="concat($_id,'FncSvcRel_')"/></xsl:attribute>
							<!--function-->
							<xsl:attribute name="source"><xsl:value-of select="$_id"/></xsl:attribute>
							<!--service-->
							<xsl:attribute name="target"><xsl:value-of select="concat($_id,'Svc_')"/></xsl:attribute>
						</xsl:element>


						<!-- Service to Interface-->
						<xsl:element name="element">
							<xsl:attribute name="xsi:type">archimate:AssignmentRelationship</xsl:attribute>
							<xsl:attribute name="id"><xsl:value-of  select="concat($_id,'IntfcSvcRel_')"/></xsl:attribute>
							<!--interface-->
							<xsl:attribute name="source"><xsl:value-of select="$interface/@id"/></xsl:attribute>
							<!--service-->
							<xsl:attribute name="target"><xsl:value-of select="concat($_id,'Svc_')"/></xsl:attribute>
						</xsl:element>
					</xsl:if>
				</xsl:for-each>
			</xroot>
		</xsl:variable>
	


	
	<!-- Document Root -->
	<xsl:template match="/">
		<xroot>
		<xsl:copy-of select="$functions/xroot/element[@xsi:type='archimate:AssignmentRelationship']"/>
		<xsl:copy-of select="$functions/xroot/element[@xsi:type='archimate:RealisationRelationship']"/>
		<xsl:copy-of select="$functions/xroot/element[@xsi:type='archimate:ApplicationService']"/>
		</xroot>
	</xsl:template>


</xsl:stylesheet>
