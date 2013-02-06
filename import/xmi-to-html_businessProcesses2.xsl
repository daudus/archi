<?xml version="1.0" encoding="UTF-8"?>
<!-- <!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]> -->
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp " ">]>

<!--Purpose: An XSL stylesheet for converting SParxs EA XMI Export to the HTML for overview relationships between business processes -->
<!-- The intent is to describe one hierarchy (taxonomy) of artefacts on the left side and the linked with another artifact (also with possible hierarchy) on the right side. For example: Let imagine the hierarchy of business "functions" (from domain, subdomain, areas, ..., functions) and you are interested in relationships between these functions and application services or business processes and so on with respect on depicting their hierarchies. Hierarchies are defined by directory/folder structure. 
    
    Version:  January 30, 2013
	pro XMI verze 2.1
	EA Source: [HS_BP - EA] - ????? 
     -->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:archimate="http://www.bolton.ac.uk/archimate" xmlns:dsk="http://www.d.eu" xmlns:n1="http://www.s.eu/schemas/archi" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:uml="http://schema.omg.org/spec/UML/2.1" xmlns:xmi="http://schema.omg.org/spec/XMI/2.1" >
	
	<xsl:output version="1.0" method="xml" indent="yes" encoding="UTF-8"/>
	<xsl:variable name="XML" select="xmi:XMI/uml:Model[@xmi:type='uml:Model']/packagedElement[@xmi:type='uml:Package']/packagedElement[@xmi:type='uml:Package']"/>
	<xsl:param name="mytab">&nbsp;&nbsp;&nbsp;&nbsp;</xsl:param>

	<xsl:param name="SV_OutputFormat" select="'HTML'"/>
	
	
	<xsl:template match="/" >
		<xsl:message>Production template "/"</xsl:message>
		<html>
			<head>
				<title>
					<xsl:value-of select="xmi:XMI/uml:Model[@xmi:type='uml:Model']/@name"/><xsl:text> - Business Processes</xsl:text>
				</title>
				<style type="text/css">
					<xsl:text>@import url(./matrice.css);</xsl:text>
				</style>
			</head>
			<body>
				<span class="nameOfModel">
					<xsl:value-of select="xmi:XMI/uml:Model[@xmi:type='uml:Model']/@name"/><xsl:text> - Business Processes</xsl:text><br/>
				</span>
				<!-- here is content TOC -->
				<dsk:toc dsk:name="toc"/>
				<!-- top level packages -->
				<xsl:for-each select="$XML">
					<dsk:level>
						<dsk:markerbookmark/>
						<dsk:marker dsk:name="toc">
							<xsl:attribute name="dsk:entrytext"><xsl:value-of select="@name"/></xsl:attribute>
						</dsk:marker>	
						<span class="TopLevel">
							<xsl:value-of select="@name"/>
							<xsl:text>&nbsp; </xsl:text>
							<xsl:text>( Subpackages: </xsl:text>
							<xsl:value-of select="count(child::packagedElement[@xmi:type='uml:Package'])"/>
							<xsl:text> )</xsl:text>
						</span>
						
						<!-- second level packages -->
						<table border="1" cellpadding="0" cellspacing="0" >
							<tbody>
								<xsl:for-each select="packagedElement[@xmi:type='uml:Package']"><xsl:sort select="@name" order="ascending" data-type="text"/>
									<dsk:level>
										<tr>
											<th><xsl:apply-templates select="."/></th>
										</tr>
									</dsk:level>
								</xsl:for-each>
							</tbody>
						</table>
					</dsk:level>
				</xsl:for-each>
			</body>
		</html>
<!--		<xsl:result-document href="temp_s1_user-defined.xml" method="xml" indent="yes">
            <xsl:copy-of select="$s1_user-defined"/>
        </xsl:result-document>		 -->
	</xsl:template>
						
	<xsl:template match="packagedElement[@xmi:type='uml:Package']">	
		<table border="1" cellpadding="0" cellspacing="0" >
			<xsl:variable name="subpackages" select="count(child::packagedElement[@xmi:type='uml:Package'])"/>
			<xsl:variable name="activities" select="count(child::packagedElement[@xmi:type='uml:Activity'])"/>
			<dsk:level>
				<tr>
					<td width="20%">
						<dsk:markerbookmark/>
						<dsk:marker dsk:name="toc">
							<xsl:attribute name="dsk:entrytext"><xsl:value-of select="@name"/></xsl:attribute>
						</dsk:marker>	
						<span class="SecondLevel">
							<xsl:value-of select="$mytab" disable-output-escaping="yes"/>
							<xsl:value-of select="@name"/>
							<xsl:text>&nbsp;</xsl:text>
							<!-- RQ 4 -->
						   <xsl:if test="$subpackages>0" >
								<xsl:text>( #Packages:&nbsp;</xsl:text>
								<xsl:value-of select="$subpackages"/>
								<xsl:text> )</xsl:text>
							</xsl:if>	
						   <xsl:if test="$activities>0" >
								<xsl:text>( #Activities:&nbsp;</xsl:text>
								<xsl:value-of select="$activities"/>
								<xsl:text> )</xsl:text>
							</xsl:if>	
						</span>
					</td>
					<td width="80%">	
						<!-- and Subpackages --> 
						<xsl:if test="$subpackages>0" >
							<xsl:for-each select="packagedElement[@xmi:type='uml:Package']"><xsl:sort select="@name" order="ascending" data-type="text"/>
								<dsk:level>
									<xsl:apply-templates select="."/>
								</dsk:level>
							</xsl:for-each>
						</xsl:if>	
						<!-- and Activities --> 
						<xsl:if test="$activities>0" >
							<xsl:for-each select="packagedElement[@xmi:type='uml:Activity']"><xsl:sort select="@name" order="ascending" data-type="text"/>
								<dsk:level>
									<xsl:apply-templates select="."/>
								</dsk:level>
							</xsl:for-each>
						</xsl:if>	
					</td>	
				</tr>
			</dsk:level>	
		</table>	
	</xsl:template>

	<xsl:template match="packagedElement[@xmi:type='uml:Activity']">	
		<table border="1" cellpadding="0" cellspacing="0" >
			<xsl:variable name="activities" select="count(child::packagedElement[@xmi:type='uml:Activity'])"/>
			<dsk:level>
				<tr>
					<td width="20%">
						<dsk:markerbookmark/>
						<dsk:marker dsk:name="toc">
							<xsl:attribute name="dsk:entrytext"><xsl:value-of select="@name"/></xsl:attribute>
						</dsk:marker>	
						<span class="SecondLevel">
							<xsl:value-of select="$mytab" disable-output-escaping="yes"/>
							<xsl:value-of select="@name"/>
							<xsl:text>&nbsp;</xsl:text>
							<!-- RQ 4 -->
						   <xsl:if test="$activities>0" >
								<xsl:text>( #Activities:&nbsp;</xsl:text>
								<xsl:value-of select="$activities"/>
								<xsl:text> )</xsl:text>
							</xsl:if>	
						</span>
					</td>
					<td width="80%">	
						<!-- and Activities --> 
						<xsl:if test="$activities>0" >
							<xsl:for-each select="packagedElement[@xmi:type='uml:Activity']"><xsl:sort select="@name" order="ascending" data-type="text"/>
								<dsk:level>
									<xsl:apply-templates select="."/>
								</dsk:level>
							</xsl:for-each>
						</xsl:if>	
					</td>	
				</tr>
			</dsk:level>	
		</table>	
	</xsl:template>								
	
	<xsl:template name="tableActivities">
		<dsk:level>
			<table border="1" cellpadding="3" cellspacing="0" width="100%">
			<thead bgcolor="#D2C8AE">
				<tr >
					<td align="center" rowspan="2" width="10%">
						<span class="headerOfTable">
							<xsl:text>Activity</xsl:text>
						</span>
					</td>
					<td align="center" rowspan="2" width="10%">
						<span class="headerOfTable">
							<xsl:text>Attributes</xsl:text>
						</span>
					</td>
					<td align="center" rowspan="2" width="10%">
						<span class="headerOfTable">
							<xsl:text>Documentation</xsl:text>
						</span>
					</td>
					<td align="center" colspan="2" width="16%">
						<span class="headerOfTable">
							<xsl:text>Lorem ipsum3</xsl:text>
						</span>
					</td>
				</tr>
				<tr>
					<td align="center" width="8%">
						<span class="headerOfTable">
							<xsl:text>....</xsl:text>
						</span>
					</td>
					<td align="center"  width="8%">
						<span class="headerOfTable">
							<xsl:text>....</xsl:text>
						</span>
					</td>
				</tr>
			</thead>
			<tfoot bgcolor="#F2F0E6">
				<tr>
					<td align="left" colspan="4" valign="top" width="23%">
						<span class="footerOfTable">
							<xsl:text>&nbsp; </xsl:text>
						</span>
					</td>
					<td align="left" colspan="1" valign="top" width="10%">
						<span class="footerOfTable">
							<xsl:text>&nbsp; </xsl:text>
						</span>
					</td>	
				</tr>
			</tfoot>
			<tbody>
				<xsl:for-each select="packagedElement[@xmi:type='uml:Activity']">
					<xsl:sort select="@name" data-type="text" order="ascending"/>
					<dsk:level>
						<tr bgcolor="{if ( position() mod 2 ) then &quot;antiquewhite&quot; else &quot;navajowhite&quot;}">
							<td>
								<dsk:markerbookmark/>
								<dsk:marker dsk:name="toc">
									<xsl:attribute name="dsk:entrytext"><xsl:value-of select="@name"/></xsl:attribute>
								</dsk:marker>
								<span class="ThirdLevel">
									<xsl:value-of select="@name"/>
								</span>
							</td>
							<td>
									<xsl:text>N/A</xsl:text>
							</td>
							<td>
								<span class="ThirdLevel">
									<xsl:text>N/A</xsl:text>
								</span>
							</td>
							<td>
								<span class="nameOfFolder2">
									<xsl:text>&nbsp;</xsl:text>
								</span>
							</td>
							<td>
								<span class="nameOfFolder2">
									<xsl:text>&nbsp;</xsl:text>
								</span>
							</td>
						</tr>
					</dsk:level>
				</xsl:for-each>
			</tbody>
		</table>
		</dsk:level>
		<br/><br/>
	</xsl:template>
	
	<xsl:template name="tableSubpackagies">
		<dsk:level>
			<table border="1" cellpadding="3" cellspacing="0" width="100%">
			<thead bgcolor="#D2C8AE">
				<tr >
					<td align="center" rowspan="2" width="10%">
						<span class="headerOfTable">
							<xsl:text>Package</xsl:text>
						</span>
					</td>
					<td align="center" rowspan="2" width="10%">
						<span class="headerOfTable">
							<xsl:text>Attributes</xsl:text>
						</span>
					</td>
					<td align="center" rowspan="2" width="10%">
						<span class="headerOfTable">
							<xsl:text>Documentation</xsl:text>
						</span>
					</td>
					<td align="center" colspan="2" width="16%">
						<span class="headerOfTable">
							<xsl:text>Lorem ipsum3</xsl:text>
						</span>
					</td>
				</tr>
				<tr>
					<td align="center" width="8%">
						<span class="headerOfTable">
							<xsl:text>....</xsl:text>
						</span>
					</td>
					<td align="center"  width="8%">
						<span class="headerOfTable">
							<xsl:text>....</xsl:text>
						</span>
					</td>
				</tr>
			</thead>
			<tfoot bgcolor="#F2F0E6">
				<tr>
					<td align="left" colspan="4" valign="top" width="23%">
						<span class="footerOfTable">
							<xsl:text>&nbsp; </xsl:text>
						</span>
					</td>
					<td align="left" colspan="1" valign="top" width="10%">
						<span class="footerOfTable">
							<xsl:text>&nbsp; </xsl:text>
						</span>
					</td>	
				</tr>
			</tfoot>
			<tbody>
				<xsl:for-each select="packagedElement[@xmi:type='uml:Package']">
					<xsl:sort select="@name" data-type="text" order="ascending"/>
					<dsk:level>
						<tr bgcolor="{if ( position() mod 2 ) then &quot;antiquewhite&quot; else &quot;navajowhite&quot;}">
							<td>
								<dsk:markerbookmark/>
								<dsk:marker dsk:name="toc">
									<xsl:attribute name="dsk:entrytext"><xsl:value-of select="@name"/></xsl:attribute>
								</dsk:marker>
								<span class="ThirdLevel">
									<xsl:value-of select="@name"/>
								</span>
							</td>
							<td>
									<xsl:text>N/A</xsl:text>
							</td>
							<td>
								<span class="ThirdLevel">
									<xsl:text>N/A</xsl:text>
								</span>
							</td>
							<td>
								<span class="nameOfFolder2">
									<xsl:text>&nbsp;</xsl:text>
								</span>
							</td>
							<td>
								<span class="nameOfFolder2">
									<xsl:text>&nbsp;</xsl:text>
								</span>
							</td>
						</tr>
					</dsk:level>
				</xsl:for-each>
			</tbody>
		</table>
		</dsk:level>
		<br/><br/>
	</xsl:template>
	
	<xsl:template match="folder" mode="csv">
		<xsl:for-each select="ancestor-or-self::*">
			<!-- Walking through ancestors named 'component'. By default, for-each traverses the nodes in document order -->
			<xsl:if test="position() &gt; 1">
				<!-- add a ';' delimiter in front of all steps but the  first one -->
				<xsl:text>;</xsl:text>
			</xsl:if>
			<xsl:text>"</xsl:text>
			<xsl:value-of select="@name"/>
			<xsl:text>"</xsl:text>
		</xsl:for-each>
		<xsl:text>&#xA;</xsl:text>
	</xsl:template>
</xsl:stylesheet>
