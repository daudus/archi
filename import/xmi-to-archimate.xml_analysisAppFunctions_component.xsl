<?xml version="1.0"?>
<!--
    Title: xmi-to-archmate.xml.analysisAppFunctions.xsl
    Purpose: An XSL stylesheet for converting SParxs EA XMI Export to the Archi.Archimate for import application functionalities

	 Based on ArgoUML 0.80 XMI to HTML.Copyright (C) 1999-2001, Objects by Design, Inc. All Rights Reserved.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation.

    Version:  February 1, 2013
	pro XMI verze 2.1
	EA Source: [BSL - EA] - Model.BSL.Analysis Model 
    
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:archimate="http://www.bolton.ac.uk/archimate" xmlns:uml="http://schema.omg.org/spec/UML/2.1" xmlns:xmi="http://schema.omg.org/spec/XMI/2.1" version="2.0" >
	<xsl:output method="xml" indent="yes"  omit-xml-declaration="yes"/>


	
		<xsl:variable name="_composite_functions">
			<cmp_functions>
				<!-- package level 1 = composite of functions -->
				<xsl:for-each select="//uml:Model/packagedElement[1]/packagedElement" >
					<xsl:sort select="./@name"/>

					<xsl:variable name="composite" select="@name"/>
					<xsl:variable name="guid" select="@xmi:id"/>
					
					<xsl:element name="element">
						<xsl:attribute name="xsi:type">archimate:ApplicationFunction</xsl:attribute>
						<xsl:attribute name="id"><xsl:value-of  select="generate-id($composite)"/></xsl:attribute>
						<xsl:attribute name="name"><xsl:value-of  select="$composite"/></xsl:attribute>
			
						<xsl:element name="property">
							<xsl:attribute name="key">GUID</xsl:attribute>
							<xsl:attribute name="value"><xsl:value-of  select="$guid"/></xsl:attribute>
						</xsl:element>
					</xsl:element>
					
					<!-- functions -->
					<xsl:for-each select="packagedElement">
						<xsl:sort select="./@name"/>
	
						<xsl:variable name="function" select="@name"/>
						<xsl:variable name="tid" select="@xmi:id"/>
						
						<!-- function -->
						<xsl:element name="element">
							<xsl:attribute name="xsi:type">archimate:ApplicationFunction</xsl:attribute>
							<xsl:attribute name="id"><xsl:value-of  select="generate-id($function)"/></xsl:attribute>
							<xsl:attribute name="name"><xsl:value-of  select="$function"/></xsl:attribute>
				
							<xsl:element name="property">
								<xsl:attribute name="key">GUID</xsl:attribute>
								<xsl:attribute name="value"><xsl:value-of  select="$tid"/></xsl:attribute>
							</xsl:element>
						</xsl:element>
						
						<!-- relation CmpIntfc--> 
						<xsl:element name="element">
							<xsl:attribute name="xsi:type">archimate:CompositionRelationship</xsl:attribute>
							<xsl:attribute name="id"><xsl:value-of  select="concat(generate-id($composite),'FceFceRel_')"/></xsl:attribute>
							<!--package-->
							<xsl:attribute name="source"><xsl:value-of select="generate-id($composite)"/></xsl:attribute>
							<!--function-->
							<xsl:attribute name="target"><xsl:value-of select="generate-id($function)"/></xsl:attribute>
						</xsl:element>
					</xsl:for-each>
				</xsl:for-each>	
			</cmp_functions>
		</xsl:variable>			


	
	<!-- Document Root -->
	<xsl:template match="/">
		<xroot>
			<cmp_functions>
				<xsl:copy-of select="$_composite_functions/cmp_functions/element[@xsi:type='archimate:ApplicationFunction']"/> 
			</cmp_functions>
			<cmp_relations>
				<xsl:copy-of select="$_composite_functions/cmp_functions/element[@xsi:type='archimate:CompositionRelationship']"/> 
			</cmp_relations>
		</xroot>	
	</xsl:template>


</xsl:stylesheet>
