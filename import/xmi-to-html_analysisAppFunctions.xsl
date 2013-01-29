<?xml version="1.0"?>
<!--
    Title: xmi-to-html.xsl
    Purpose: An XSL stylesheet for converting SParxs EA XMI Export to the HTML for overview relationships between application functionalities

	 Based on ArgoUML 0.80 XMI to HTML.Copyright (C) 1999-2001, Objects by Design, Inc. All Rights Reserved.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation.

    Version:  January 29, 2013
	pro XMI verze 2.1
	EA Source: [Common - EA] - Common for all countries -.Architecture.Group Architecture Concepts.Application landscape models.Copy of Reference model - Application landscape with Homer Select 
    
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"  xmlns:uml="http://schema.omg.org/spec/UML/2.1" version="2.0" exclude-result-prefixes="#default">
	<xsl:output method="xml" indent="yes" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"/>
	<xsl:key name="classifier" match="//uml:Model/packagedElement[1]/packagedElement" use="@xmi.id"/>
	
	<xsl:key name="dependency" match="//Foundation.Core.Dependency" use="@xmi.id"/>
	<xsl:key name="generalization" match="//Foundation.Core.Generalization" use="@xmi.id"/>
	<xsl:key name="abstraction" match="//Foundation.Core.Abstraction" use="@xmi.id"/>
	<xsl:key name="multiplicity" match="//Foundation.Data_Types.Multiplicity" use="@xmi.id"/>
	
	
	<!-- Document Root -->
	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
			<head>
				<!-- Model Name in window title -->
				<xsl:apply-templates select="//uml:Model" mode="head"/>
				<link href="xmi.css" rel="stylesheet" type="text/css"/>
			</head>
			<body>
				<!-- Model Name in document heading -->
				<xsl:apply-templates select="//uml:Model" mode="body"/>
				<!-- Components -->
				<xsl:apply-templates select="//uml:Model/packagedElement[1]/packagedElement" mode="top">
					<xsl:sort select="./@name"/>
				</xsl:apply-templates>

				<!-- Interfaces -->
				<!--<xsl:apply-templates select="//Foundation.Core.Interface[@xmi.id]">
					<xsl:sort select="Foundation.Core.ModelElement.name"/>
				</xsl:apply-templates>-->
				<!-- Classes -->
				<!--<xsl:apply-templates select="//Foundation.Core.Class[@xmi.id]">
					<xsl:sort select="Foundation.Core.ModelElement.name"/>
				</xsl:apply-templates>-->
			</body>
		</html>
	</xsl:template>
	
	<!-- Window Title -->
	<xsl:template match="uml:Model" mode="head">
		<title>
			<!-- Name of the model -->
			<xsl:value-of select="@name"/>
		</title>
	</xsl:template>
	<!-- Document Heading -->
	<xsl:template match="uml:Model" mode="body">
		<div align="center">
			<h1>
				<!-- Name of the model -->
				<xsl:value-of select="@name"/>
			</h1>
		</div>
	</xsl:template>

	<!-- Component -->
	<xsl:template match="packagedElement" mode="top">
		<xsl:variable name="element_name" select="@name"/>
		<xsl:variable name="xmi_id" select="@xmi.id"/>
		<div align="center">
			<table border="1" width="75%" cellpadding="2">
				<tr>
					<td class="class-title" width="20%"><span id="{$xmi_id}">Package</span></td>
					<!-- create a hyperlink target for the name -->
					<td class="class-name">
						<a name="{translate($element_name,' ?','..')}">
							<xsl:value-of select="$element_name"/>
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<table width="100%" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td colspan="2" bgcolor="#FFFFFF">
									<table width="100%" border="0" cellpadding="3" cellspacing="1">
										<xsl:call-template name="subfunctions">
											<xsl:with-param name="source" select="$xmi_id"/>
										</xsl:call-template>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
		<br/>
		<br/>
	</xsl:template>



	<!-- SubFunctions -->
	<xsl:template name="subfunctions">
		<xsl:param name="source"/>
		<xsl:variable name="subfunctions" select="packagedElement"/>
		<tr>
			<td width="20%" class="info-title">SubFunctions::</td>
			<td colspan="2" class="info">
				<xsl:if test="count($subfunctions) > 0">
					<xsl:for-each select="$subfunctions">
						<xsl:value-of select="@name"/>
						<xsl:if test="position() != last()">
							<xsl:text>,  </xsl:text>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
				<xsl:if test="count($subfunctions) = 0">
					<xsl:text>N/A</xsl:text>
				</xsl:if>
			</td>	
		</tr>		
	</xsl:template>
	

	<!-- Classification -->
	<xsl:template name="classify">
		<xsl:param name="target"/>
		<xsl:variable name="classifier" select="key('classifier', $target)"/>
		<xsl:variable name="classifier_name" select="$classifier/Foundation.Core.ModelElement.name"/>
		<xsl:variable name="type" select="name($classifier)"/>
		<!-- Get the type of the classifier (class, interface, datatype) -->
		<xsl:variable name="classifier_type">
			<xsl:choose>
				<xsl:when test="$type='Foundation.Core.Class'">classifier</xsl:when>
				<xsl:when test="$type='Foundation.Core.Interface'">interface</xsl:when>
				<xsl:when test="$type='Foundation.Core.DataType'">datatype</xsl:when>
				<xsl:otherwise>classifier</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<!-- Datatypes don't have hyperlinks -->
			<xsl:when test="$type='Foundation.Core.DataType'">
				<span class="datatype">
					<xsl:value-of select="$classifier_name"/>
				</span>
			</xsl:when>
			<!-- Classes and Interfaces have hyperlinks -->
			<!-- The classifier type is used to style appropriately -->
			<xsl:otherwise>
				<xsl:if test="string-length($classifier) > 0">
					<a class="{$classifier_type}" href="#{translate($classifier_name,' ?','..')}">
						<xsl:value-of select="$classifier_name"/>
					</a>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
