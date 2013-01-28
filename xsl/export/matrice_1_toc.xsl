<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:archimate="http://www.bolton.ac.uk/archimate" xmlns:dsk="http://www.d.eu" xmlns:n1="http://www.s.eu/schemas/archi" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<xsl:output version="1.0" method="xml" indent="yes" encoding="UTF-8"/>
<!-- for ilustration example see toc_example.xsl and toc_example.xml -->
	<xsl:template match="/">
		<xsl:message>match="/"</xsl:message>
		<xsl:for-each select=".">
			<xsl:apply-templates mode="toc"/>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="dsk:toc[@dsk:name = 'toc']" mode="toc">
		<xsl:message>toc with [@name="toc"]</xsl:message>
		<span style="font-family:Arial; font-size:14pt; font-weight:bold; ">
			<xsl:text>Quick Finder</xsl:text>
		</span>
		<br/>
		<xsl:for-each select="ancestor::*[self::dsk:level | self::html][1]">
			<xsl:for-each select="descendant::dsk:level[ ancestor::*[self::dsk:level | self::html][1] = current() ]">
				<br/>
				<xsl:for-each select="descendant::dsk:marker[ @dsk:name = 'toc' and ancestor::dsk:level[1] = current() ]">
					<a href="{concat(&apos;#&apos;,generate-id(preceding-sibling::dsk:markerbookmark[1]))}">
						<span style="font-family:Arial; font-size:12pt; font-weight:bold; ">
							<xsl:choose>
								<xsl:when test="@dsk:entrytext">
									<xsl:value-of select="@dsk:entrytext"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates mode="tocref"/>
								</xsl:otherwise>
							</xsl:choose>
						</span>
					</a>
				</xsl:for-each>
				<br/>
				<table style="margin-top:2pt; " cellspacing="0" width="100%">
					<tbody>
						<tr>
							<td width="50%">
								<span style="font-size:10pt; font-weight:bold; ">
									<xsl:text>Departments</xsl:text>
								</span>
							</td>
							<td width="50%">
								<span style="font-size:10pt; font-weight:bold; ">
									<xsl:text>Persons</xsl:text>
								</span>
							</td>
						</tr>
					</tbody>
				</table>
				<xsl:for-each select="descendant::dsk:level[ ancestor::dsk:level[1] = current() ]">
					<table style="line-height:12pt; " cellspacing="0" width="100%">
						<tbody>
							<tr bgcolor="{if ( position() mod 2 ) then &quot;antiquewhite&quot; else &quot;navajowhite&quot;}">
								<td valign="top" width="50%">
									<xsl:for-each select="descendant::dsk:marker[ @dsk:name = 'toc' and ancestor::dsk:level[1] = current() ]">
										<a href="{concat(&apos;#&apos;,generate-id(preceding-sibling::dsk:markerbookmark[1]))}">
											<span style="font-family:Arial; font-size:10pt; font-weight:bold; ">
												<xsl:number level="multiple" count="dsk:level[count(ancestor::dsk:level) >= 1]" format="A.1"/>
											</span>
											<span style="font-family:Arial; font-size:10pt; font-weight:bold; ">
												<xsl:text>. </xsl:text>
											</span>
											<span style="font-family:Arial; font-size:10pt; font-weight:bold; ">
												<xsl:choose>
													<xsl:when test="@dsk:entrytext">
														<xsl:value-of select="@dsk:entrytext"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:apply-templates mode="tocref"/>
													</xsl:otherwise>
												</xsl:choose>
											</span>
										</a>
									</xsl:for-each>
								</td>
								<td valign="top" width="50%">
									<xsl:for-each select="descendant::dsk:level[ ancestor::dsk:level[1] = current() ]">
										<table cellpadding="0" cellspacing="0">
											<tbody>
												<tr>
													<td valign="top">
														<xsl:for-each select="descendant::dsk:marker[ @dsk:name = 'toc' and ancestor::dsk:level[1] = current() ]">
															<a href="{concat(&apos;#&apos;,generate-id(preceding-sibling::dsk:markerbookmark[1]))}">
																<span style="font-family:Arial; font-size:8pt; ">
																	<xsl:number level="multiple" count="dsk:level[count(ancestor::dsk:level) >= 1]" format="A.1"/>
																</span>
																<span style="font-family:Arial; font-size:8pt; ">
																	<xsl:text>&nbsp;</xsl:text>
																</span>
																<span style="font-family:Arial; font-size:8pt; ">
																	<xsl:choose>
																		<xsl:when test="@dsk:entrytext">
																			<xsl:value-of select="@dsk:entrytext"/>
																		</xsl:when>
																		<xsl:otherwise>
																			<xsl:apply-templates mode="tocref"/>
																		</xsl:otherwise>
																	</xsl:choose>
																</span>
															</a>
														</xsl:for-each>
													</td>
												</tr>
											</tbody>
										</table>
									</xsl:for-each>
								</td>
							</tr>
						</tbody>
					</table>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="dsk:markerbookmark" mode="toc">
		<xsl:message>dsk:markerbookmark</xsl:message>
		<a name="{generate-id()}">
			<xsl:apply-templates mode="toc"/>
		</a>
	</xsl:template>

	<xsl:template match="dsk:num-lvl" mode="toc tocref">
		<xsl:choose>
			<xsl:when test="@dsk:omitlevels">
				<xsl:variable name="omitlevels" select="@dsk:omitlevels"/>
				<xsl:number level="multiple" count="dsk:level[count(ancestor::dsk:level) >= $omitlevels]" format="{@dsk:format}"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:number level="multiple" count="dsk:level" format="{@dsk:format}"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="dsk:num-seq" mode="toc tocref">
		<xsl:variable name="sMatch" select="ancestor::dsk:marker[1]/@dsk:name"/>
		<xsl:number level="any" count="dsk:marker[ @dsk:name = $sMatch ]" format="{@dsk:format}"/>
	</xsl:template>


	<xsl:template match="text()" mode="tocref">
		<xsl:message>text</xsl:message>
		<xsl:value-of select="string(.)"/>
	</xsl:template>

	<xsl:template match="dsk:level|dsk:marker|dsk:marker/@*" mode="toc">
		<xsl:message>leve marker ...</xsl:message>
		<xsl:apply-templates select="@*|node()" mode="toc"/>
	</xsl:template>

	<xsl:template match="@*|node()" mode="toc">
		<xsl:message>node</xsl:message>
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="toc"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>