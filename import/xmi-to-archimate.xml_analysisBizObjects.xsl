<?xml version="1.0"?>
<!--
    Title: xmi-to-archmate.xml_BizObjects.xsl
    Purpose: An XSL stylesheet for converting SParxs EA XMI Export to the Archi.Archimate for import business objects andtheir relationships

	Based on ArgoUML 0.80 XMI to HTML.Copyright (C) 1999-2001, Objects by Design, Inc. All Rights Reserved.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation.

    Version:  November 16, 2017
	pro XMI verze 2.1
    
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:uml="http://schema.omg.org/spec/UML/2.1" xmlns:xmi="http://schema.omg.org/spec/XMI/2.1" xmlns:thecustomprofile="http://www.sparxsystems.com/profiles/thecustomprofile/1.0" xmlns:Archimate2="http://www.sparxsystems.com/profiles/Archimate2/1.0" version="1.0">
	<xsl:output method="xml" indent="yes"  omit-xml-declaration="yes"/>
	<xsl:strip-space elements="*" />
	
	<xsl:template match="//uml:Model">
		<model>
			<objects>
				<xsl:apply-templates select="//uml:Model/packagedElement[1]/packagedElement[@xmi:type='uml:Class']"/>
			</objects>
			<relations>
				<xsl:apply-templates select="//uml:Model/packagedElement[1]/packagedElement[@xmi:type='uml:Association']"/>
			</relations>
		</model>
	</xsl:template>

	<xsl:template match="//uml:Model/packagedElement[1]/packagedElement[@xmi:type='uml:Class']">
		<xsl:variable name="object" select="@name"/>
		<xsl:variable name="guid" select="@xmi:id"/>
		<xsl:element name="element">
			<xsl:attribute name="xsi:type">archimate:BusinessObject</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of  select="$guid"/></xsl:attribute>
			<xsl:attribute name="name"><xsl:value-of  select="$object"/></xsl:attribute>
			<xsl:element name="property">
				<xsl:attribute name="key">GUID</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of  select="$guid"/></xsl:attribute>
			</xsl:element>
			
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="//uml:Model/packagedElement[1]/packagedElement[@xmi:type='uml:Association']">
		<xsl:variable name="relation" select="@name"/>
		<xsl:variable name="guid" select="@xmi:id"/>
		<xsl:variable name="dst" select="ownedEnd[@association=$guid][1]/type/@xmi:idref"/>
		<xsl:variable name="src" select="ownedEnd[@association=$guid][2]/type/@xmi:idref"/>
		<xsl:if test="//uml:Model/packagedElement[1]/packagedElement[@xmi:type='uml:Class'][@xmi:id=$dst] and //uml:Model/packagedElement[1]/packagedElement[@xmi:type='uml:Class'][@xmi:id=$src]">
			<xsl:element name="element">
				<xsl:attribute name="xsi:type">archimate:AssociationRelationship</xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of  select="$guid"/></xsl:attribute>
				<xsl:attribute name="name"><xsl:value-of  select="$relation"/></xsl:attribute>
				<xsl:attribute name="source"><xsl:value-of select="$src"/></xsl:attribute>
				<xsl:attribute name="target"><xsl:value-of select="$dst"/></xsl:attribute>
			</xsl:element>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
