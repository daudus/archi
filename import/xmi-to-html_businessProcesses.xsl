<?xml version="1.0"?>
<!--
    Title: xmi-to-html.xsl
    Purpose: An XSL stylesheet for converting SParxs EA XMI Export to the HTML for overview relationships between business processes

	 Based on ArgoUML 0.80 XMI to HTML.Copyright (C) 1999-2001, Objects by Design, Inc. All Rights Reserved.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation.

    Version:  January 30, 2013
	pro XMI verze 2.1
	EA Source: [HS_BP - EA] - ????? 
    
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"  xmlns:uml="http://schema.omg.org/spec/UML/2.1" version="2.0" xmlns:xmi="http://schema.omg.org/spec/XMI/2.1" exclude-result-prefixes="#default">
	<xsl:output method="xml" indent="yes" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"/>
	
	<!-- Document Root -->
	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
			<head>
				<!-- Model Name in window title -->
				<xsl:apply-templates select="xmi:XMI/uml:Model[@xmi:type='uml:Model']" mode="head"/>
				<link href="xmi.css" rel="stylesheet" type="text/css"/>
			</head>
			<body>
				<!-- Model Name in document heading -->
				<xsl:apply-templates select="xmi:XMI/uml:Model[@xmi:type='uml:Model']" mode="body"/>
				<!-- Packages; ignore first level -->
				<xsl:apply-templates select="xmi:XMI/uml:Model[@xmi:type='uml:Model']/packagedElement[@xmi:type='uml:Package']/packagedElement[@xmi:type='uml:Package']">
					<xsl:sort select="@name"/>
				</xsl:apply-templates>
			</body>
		</html>
	</xsl:template>
	
	<!-- Window Title -->
	<xsl:template match="uml:Model[@xmi:type='uml:Model']" mode="head">
		<title>
			<!-- Name of the model -->
			<xsl:value-of select="concat(@name,'  - Business Processes')"/>
		</title>
	</xsl:template>
	<!-- Document Heading -->
	<xsl:template match="uml:Model" mode="body">
		<div align="center">
			<h1>
				<!-- Name of the model -->
				<xsl:value-of select="concat(@name,'  - Business Processes')"/>
			</h1>
		</div>
	</xsl:template>

	<!-- packages -->
	<xsl:template match="packagedElement[@xmi:type='uml:Package']">
		<xsl:variable name="element_name" select="@name"/>
		<xsl:variable name="xmi_id" select="@xmi:id"/>
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
						<xsl:variable name="subpackages" select="packagedElement[@xmi:type='uml:Package']"/>
						<xsl:if test="count($subpackages)>0">
							<xsl:for-each select="$subpackages">
								<table width="100%" cellpadding="0" cellspacing="0" border="1">
									<tr>
										<td colspan="2" bgcolor="#FFFFFF">
											<table width="100%" border="1" cellpadding="3" cellspacing="1">
												<xsl:apply-templates select="packagedElement[@xmi:type='uml:Package']">
													<xsl:with-param name="source" select="$xmi_id"/>
												</xsl:apply-templates>
											</table>
										</td>
									</tr>
								</table>
							</xsl:for-each>	
						</xsl:if>
						<xsl:if test="count($subpackages)=0">
							<xsl:text>N/A</xsl:text>
						</xsl:if>	
					</td>
				</tr>
			</table>
		</div>
		<br/>
		<br/>
	</xsl:template>



	<!-- Activity -->
	<xsl:template match="packagedElement[@xmi:type='uml:Activity']">
		<xsl:param name="source"/>
		<xsl:message>Activity Template</xsl:message>
		<xsl:variable name="subfunctions" select="packagedElement"/>
		<tr>
			<td width="20%" class="info-title">Activities::</td>
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
	
</xsl:stylesheet>
