<?xml version="1.0" encoding="UTF-8"?>
<!-- <!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]> -->
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp " ">]>

<!--Template to transform ARCHI 2.2.0. XML model to the table form in CSV with semicolon -->
<!-- The intent is to describe one hierarchy (taxonomy) of artefacts on the left side and the linked with another artifact (also with possible hierarchy) on the right side. For example: Let imagine the hierarchy of business "functions" (from domain, subdomain, areas, ..., functions) and you are interested in relationships between these functions and application services or business processes and so on with respect on depicting their hierarchies. Hierarchies are defined by directory/folder structure.  -->
<!--Expected output is CSV : (example):-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:archimate="http://www.bolton.ac.uk/archimate" xmlns:dsk="http://www.d.eu" xmlns:n1="http://www.s.eu/schemas/archi" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<!--<xsl:output version="1.0" method="xhtml" indent="no" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>-->
	<xsl:output version="1.0" method="xml" indent="yes" encoding="UTF-8"/>
	<!--Top level hierarchy directory/folder-->
	<!-- methodologicaly suppose the required (fixed) logic of directories/folders: <model>/<folder>/<folder>. Next structure of levels as neededand is ignored  -->
	<!-- Note the use of Actor icons instead of “roles” that the ArchiMate specification encourages. I find the notion of “role” to be a little abstract for some people. That’s why I often skip it and depict actors instead. Everyone understands a stick figure.-->
	<!-- use Business Functions for higher level groupings of Business Processes (i.e finance management) that are closely associated with Organisation Units-->
	<xsl:variable name="XML" select="/archimate:model/folder[@type='business' or @type='application']"/>
	<xsl:variable name="ARCHIMATE_PREFIX" select="'archimate:'"/>
	<xsl:param name="mytab">&nbsp;&nbsp;&nbsp;&nbsp;</xsl:param>

	<xsl:param name="SV_OutputFormat" select="'HTML'"/>
	
	
	<xsl:template match="/" >
		<xsl:message>Production template "/"</xsl:message>
		<html>
			<head>
				<title>
					<xsl:value-of select="/archimate:model/@name"/>
				</title>
				<style type="text/css">
					<xsl:text>@import url(./matrice.css);</xsl:text>
				</style>
			</head>
			<body>
				<span class="nameOfModel">
					<xsl:value-of select="/archimate:model/@name"/>
				</span>
				<br/>
				<!-- here is content TOC -->
				<dsk:toc dsk:name="toc"/>
				<!-- top level category of ArchiMate: Business, Aplication, ...-->
				<xsl:for-each select="$XML">
					<dsk:level>
						<br/><br/>
						<dsk:markerbookmark/>
						<dsk:marker dsk:name="toc">
							<xsl:attribute name="dsk:entrytext"><xsl:value-of select="@name"/></xsl:attribute>
						</dsk:marker>	
						<span class="TopLevel">
							<xsl:value-of select="@name"/>
							<xsl:text>&nbsp; </xsl:text>
							<xsl:text>( </xsl:text>
							<xsl:value-of select="count(child::folder)"/>
							<xsl:text> )</xsl:text>
						</span>
						
						<!-- second level category of ArchiMate: Business/Functions and Actors, ..., Aplication/Applications, ...-->
						<xsl:for-each select="folder"><xsl:sort select="@name" order="ascending" data-type="text"/>
							<br/><br/>
							<dsk:level>
								<dsk:markerbookmark/>
								<dsk:marker dsk:name="toc">
									<xsl:attribute name="dsk:entrytext"><xsl:value-of select="@name"/></xsl:attribute>
								</dsk:marker>	
								<span class="SecondLevel">
									<xsl:value-of select="$mytab" disable-output-escaping="yes"/>
									<xsl:value-of select="@name"/>
									<xsl:text>&nbsp;</xsl:text>
									<!-- RQ 4 -->
									<xsl:text>( #Elements:&nbsp;</xsl:text>
									<xsl:value-of select="count(child::folder | child::element)"/>
									<xsl:text> )</xsl:text>
								</span>
								<br/><br/>
								<!-- each type in separate folder. For example <folder[@name='Actor's]/<element[@type]> -->
								<xsl:for-each-group select=".//element" group-by="@xsi:type">
									<xsl:sort select="current-grouping-key()"/>
									<dsk:level>
										<xsl:call-template name="table">
											<xsl:with-param name="group" select="current-group()"/>
											<xsl:with-param name="type" select="current-grouping-key()"/>
										</xsl:call-template>
									</dsk:level>	
								</xsl:for-each-group>
							</dsk:level>	
						</xsl:for-each>	
					</dsk:level>
				</xsl:for-each>
			</body>
		</html>
<!--		<xsl:result-document href="temp_s1_user-defined.xml" method="xml" indent="yes">
            <xsl:copy-of select="$s1_user-defined"/>
        </xsl:result-document>		 -->
	</xsl:template>
	
	<xsl:template name="table">
		<xsl:param name="group"/>
		<xsl:param name="type"/>
		<xsl:message>table template</xsl:message>
	
		<table border="1" cellpadding="3" cellspacing="0" width="100%">
			<thead bgcolor="#D2C8AE">
				<dsk:markerbookmark/>
				<dsk:marker dsk:name="toc">
					<xsl:attribute name="dsk:entrytext"><xsl:value-of select="substring-after($type,$ARCHIMATE_PREFIX)"/></xsl:attribute>
				</dsk:marker>	
				<tr >
					<td align="center" rowspan="2" width="10%">
						<span class="headerOfTable">
							<xsl:value-of select="substring-after($type,$ARCHIMATE_PREFIX)"/>
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
				<!-- I am not sure that it is good solution in case there is <folder> structure in <$group> -->
				<xsl:for-each select="$group[name()='element']">
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
								<xsl:variable name="parameters" select="property"/>
								<xsl:if test="count($parameters) > 0">
									<xsl:for-each select="$parameters">
										<span class="ThirdLevel">
											<xsl:text>key=</xsl:text>
											<xsl:value-of select="@key"/>
											<xsl:text>    value=</xsl:text>
											<xsl:value-of select="@value"/>
										</span><br/>
									</xsl:for-each>
								</xsl:if>
								<xsl:if test="count($parameters) = 0">
									<xsl:text>N/A</xsl:text>
								</xsl:if>
							</td>
							<td>
								<span class="ThirdLevel">
									<xsl:value-of select="documentation"/>
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
