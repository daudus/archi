<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">

    <!--
STEP-1: matrice_1.xsl
All html without TOC

STEP-2: matrice_1_toc.xsl
TOC add
-->
<!-- BAD NOT WORKING. DO NOT USE.-->
    <!-- 
    Param values:
    0 = skip /identity/
    1 = use included step stylesheet.
    2 = and serialize step to file. -->

    <xsl:param name="param_matrice_1" select="2"/>
    <xsl:param name="param_matrice_1_toc" select="0"/>

    <xsl:include href="matrice_1.xsl"/>
    <xsl:include href="matrice_1_toc.xsl"/>

    <xsl:template match="/">

        <!-- STEP-1: -->
        <xsl:variable name="matrice_1">
            <xsl:choose>
                <xsl:when test="$param_matrice_1 = 1 or $param_matrice_1 = 2">
                    <xsl:apply-templates mode="matrice_1"/>
                </xsl:when>
                <xsl:when test="$param_matrice_1 = 0">
                    <xsl:copy-of select="."/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message terminate="yes">param_matrice_1 must have value 0|1|2</xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$param_matrice_1 = 2">
            <xsl:result-document href="temp_matrice_1.xml" method="xml" indent="yes">
                <xsl:copy-of select="$matrice_1"/>
            </xsl:result-document>
        </xsl:if>

        <!-- STEP-2: -->
        <xsl:variable name="matrice_1_toc">
            <xsl:choose>
                <xsl:when test="$param_matrice_1_toc = 1 or $param_matrice_1_toc = 2">
                    <xsl:apply-templates mode="matrice_1_toc" select="$matrice_1"/>
                </xsl:when>
                <xsl:when test="$param_matrice_1_toc = 0">
                    <xsl:copy-of select="$matrice_1"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message terminate="yes">param_matrice_1_toc must have value 0|1|2</xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$param_matrice_1_toc = 2">
            <xsl:result-document href="temp_matrice_1_toc.html" method="xml" indent="yes">
                <xsl:copy-of select="$matrice_1_toc"/>
            </xsl:result-document>
        </xsl:if>
    </xsl:template>    
</xsl:stylesheet>
