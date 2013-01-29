<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:archimate="http://www.bolton.ac.uk/archimate" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:template match="/">
		<html>
			<head>
				<title>Archi Report</title>
				<style type="text/css">        table { border-collapse:collapse; }        table, td, th { border:1px solid black; }        </style>
			</head>
			<body style="font-family:Verdana; font-size:10pt;">
				<h1>Archi Report</h1>
				<br/>
				<table width="100%" border="0">
					<tr bgcolor="#F0F0F0">
						<td width="20%" valign="top">Name</td>
						<td width="80%" valign="top">
							<xsl:value-of select="archimate:model/@name"/>
						</td>
					</tr>
					<tr>
						<td valign="top">Date</td>
						<td valign="top" id="date">FIXME fake javascript date instead of fn:current-dateTime()<SCRIPT>e=document.getElementById('date');e.innerHTML=Date()</SCRIPT>
						</td>
					</tr>
					<tr>
						<td valign="top">Purpose</td>
						<td valign="top">
							<xsl:copy-of select="/archimate:model/purpose"/>
						</td>
					</tr>
				</table>
				<br/>
				<h2>Business Functions</h2>
				<xsl:apply-templates select="//element[@xsi:type='archimate:BusinessFunction']">
					<xsl:with-param name="color">#ffffb5</xsl:with-param>
					<xsl:with-param name="type">Business Function</xsl:with-param>
				</xsl:apply-templates>
				<h2>Business Products</h2>
				<xsl:apply-templates select="//element[@xsi:type='archimate:Contract']">
					<xsl:with-param name="color">#ffffb5</xsl:with-param>
					<xsl:with-param name="type">Contract</xsl:with-param>
				</xsl:apply-templates>
				<xsl:apply-templates select="//element[@xsi:type='archimate:Product']">
					<xsl:with-param name="color">#ffffb5</xsl:with-param>
					<xsl:with-param name="type">Product</xsl:with-param>
				</xsl:apply-templates>
				<xsl:apply-templates select="//element[@xsi:type='archimate:BusinessService']">
					<xsl:with-param name="color">#ffffb5</xsl:with-param>
					<xsl:with-param name="type">Business Service</xsl:with-param>
				</xsl:apply-templates>
				<xsl:apply-templates select="//element[@xsi:type='archimate:Value']">
					<xsl:with-param name="color">#ffffb5</xsl:with-param>
					<xsl:with-param name="type">Value</xsl:with-param>
				</xsl:apply-templates>
				<h2>Views</h2>
				<xsl:apply-templates select="//archimate:DiagramModel">
					<xsl:with-param name="color">#e0e4e6</xsl:with-param>
					<xsl:with-param name="type">Or Junction</xsl:with-param>
				</xsl:apply-templates>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="archimate:DiagramModel">
		<xsl:param name="color"/>
		<xsl:param name="type"/>
		<table width="100%" border="0">
			<tr bgcolor="{$color}">
				<td width="20%" valign="top">Name</td>
				<td width="80%" valign="top">
					<xsl:value-of select="./@name"/>
				</td>
			</tr>
			<tr>
				<td valign="top">Documentation</td>
				<td valign="top">
					<xsl:copy-of select="./documentation"/>
				</td>
			</tr>
			<xsl:for-each select="property">
				<tr>
					<td>
						<xsl:value-of select="./@key"/>
					</td>
					<td>
						<xsl:value-of select="./@value"/>
					</td>
				</tr>
			</xsl:for-each>
		</table>
		<img src="{./@id}.png"/>
		<br/>
		<br/>
		<br/>
		<br/>
	</xsl:template>
	<xsl:template match="element">
		<xsl:param name="color"/>
		<xsl:param name="type"/>
		<table width="100%" border="0">
			<tr bgcolor="{$color}">
				<td width="20%" valign="top">Name</td>
				<td width="80%" valign="top">
					<xsl:value-of select="./@name"/>
				</td>
			</tr>
			<tr>
				<td valign="top">Type</td>
				<td valign="top">
					<xsl:value-of select="$type"/>
				</td>
			</tr>
			<tr>
				<td valign="top">Documentation</td>
				<td valign="top">
					<xsl:copy-of select="./documentation"/>
				</td>
			</tr>
			<xsl:for-each select="property">
				<tr>
					<td>
						<xsl:value-of select="./@key"/>
					</td>
					<td>
						<xsl:value-of select="./@value"/>
					</td>
				</tr>
			</xsl:for-each>
		</table>
		<p/>
	</xsl:template>
</xsl:stylesheet>
