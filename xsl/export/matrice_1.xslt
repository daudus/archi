<?xml version="1.0" encoding="UTF-8"?>
<!--Template to transform ARCHI 2.2.0. XML model to the table form in CSV with semicolon -->
<!-- The intent is to describe one hierarchy (taxonomy) of artefacts on the left side and the linked with another artifact (also with possible hierarchy) on the right side. For example: Let imagine the hierarchy of business "functions" (from domain, subdomain, areas, ..., functions) and you are interested in relationships between these functions and application services or business processes and so on with respect on depicting their hierarchies. Hierarchies are defined by directory/folder structure.  -->
<!--Expected output is CSV : (example):-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:archimate="http://www.bolton.ac.uk/archimate">
	<xsl:output method="text" version="1.0" encoding="UTF-8" indent="yes"/>
	<!--Top level hierarchy directory/folder-->
	<!--
<xsl:param name="leftSideHierarchy" select="/archimate:model/folder[@type='business']/folder[@name='Functions']"/>
-->
	<xsl:param name="leftSideHierarchy" select="/archimate:model/folder[@type='business']"/>
	<xsl:param name="rightSideHierarchy" select="/archimate:model/folder[@type='application']/folder"/>

  <xsl:template match="/" priority="10">
	<xsl:message>Production template</xsl:message>
	<xsl:apply-templates select="$leftSideHierarchy//folder"/>
</xsl:template>

  <xsl:template match="folder">
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