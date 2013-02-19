<?xml version="1.0"?>
<!--
    Title: xmi-to-archmate.xml.businessProcess_all.xsl
    Purpose: An XSL stylesheet for converting SParxs EA XMI Export to the Archi.Archimate for import busiensss processes, activities, pools, to be prepared for BUSINBESS REQUIREMENTS linking.
	
	Only fresh import, no Change management implemented.

    Version:  February 18, 2013
	pro XMI verze 2.1
	EA Source: [HS_BP] Model.Business processes and Requirements.Business Processes.Process_Specification_Map
    
	WARNING!  POOL INSIDE POOL - ex Back Office, Centrall Processing, 
	
	
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:archimate="http://www.bolton.ac.uk/archimate" xmlns:uml="http://schema.omg.org/spec/UML/2.1" xmlns:xmi="http://schema.omg.org/spec/XMI/2.1" version="2.0" >
	<xsl:output method="xml" indent="yes"  omit-xml-declaration="yes"/>
	
		<xsl:variable name="_composite_processes">
			<cmp_processes>
				<!-- first level ignoring -->
<!--				<xsl:apply-templates select="/xmi:XMI/uml:Model/packagedElement[1]/packagedElement[@xmi:type='uml:Package']" mode="top"/> -->
				<xsl:apply-templates select="/xmi:XMI/uml:Model/packagedElement[@xmi:type='uml:Package']" mode="top"/>
			</cmp_processes>
		</xsl:variable>			


	
	<!-- Document Root -->
	<xsl:template match="/">
		<xroot>
			<folder name="biz_processes" id="aaaaaaaaaa">
				<xsl:copy-of select="$_composite_processes/cmp_processes/element[@xsi:type='archimate:BusinessProcess']"/> 
			</folder>
			<folder name="biz_roles" id="bbbbbbbbbb">
				<xsl:copy-of select="$_composite_processes/cmp_processes/element[@xsi:type='archimate:BusinessRole']"/> 
			</folder>
			<folder name="biz_proc_rel" id="cccccccccc">
				<xsl:copy-of select="$_composite_processes/cmp_processes/element[@xsi:type='archimate:CompositionRelationship']"/> 
			</folder>
			<folder name="biz_role_proc_rel" id="dddddddddd">
				<xsl:copy-of select="$_composite_processes/cmp_processes/element[@xsi:type='archimate:AssignmentRelationship']"/> 
			</folder>
		</xroot>	
	</xsl:template>

	<xsl:template match="packagedElement[@xmi:type='uml:Package']" mode="top">
		<xsl:variable name="composite" select="@name"/>
		<xsl:variable name="guid" select="@xmi:id"/>
		
		<xsl:element name="element">
			<xsl:attribute name="xsi:type">archimate:BusinessProcess</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of  select="generate-id($composite)"/></xsl:attribute>
			<xsl:attribute name="name"><xsl:value-of  select="$composite"/></xsl:attribute>

			<xsl:element name="property">
				<xsl:attribute name="key">GUID</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of  select="$guid"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="property">
				<xsl:attribute name="key">UID</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of  select="translate(substring($guid,6),'_','-')"/></xsl:attribute>
			</xsl:element>
		</xsl:element>
		
		<xsl:apply-templates select="packagedElement[@xmi:type='uml:Package']" mode="inner"/>
		<!--  <xsl:apply-templates select="packagedElement[@xmi:type='uml:Activity']"/>  -->
	</xsl:template>

	<xsl:template match="packagedElement[@xmi:type='uml:Package']" mode="inner">

		<xsl:variable name="composite" select="@name"/>
		<xsl:variable name="guid" select="@xmi:id"/>
	
		<!--  has deliveryMatrix RTF appendix -->
		<xsl:variable name="deliveryMatrix" select="packagedElement[@xmi:type='uml:Artifact']"/>						
		<xsl:variable name="dM" select="/xmi:XMI/xmi:Extension/*/element[@xmi:idref=$deliveryMatrix/@xmi:id and @xmi:type='uml:Artifact']"/>						
	
		<!--  has <<BusinessProcess>> defined-->
		<xsl:variable name="businessProcess" select="packagedElement[@xmi:type='uml:Activity']"/>						
		<xsl:variable name="bP" select="/xmi:XMI/xmi:Extension/*/element[@xmi:idref=$businessProcess/@xmi:id and @xmi:type='uml:Activity']"/>						
	
		<xsl:element name="element">
			
			<xsl:attribute name="xsi:type">archimate:BusinessProcess</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of  select="generate-id($composite)"/></xsl:attribute>
			<xsl:attribute name="name"><xsl:value-of  select="$composite"/></xsl:attribute>
	
			<xsl:element name="property">
				<xsl:attribute name="key">GUID</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of  select="$guid"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="property">
				<xsl:attribute name="key">UID</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of  select="translate(substring($guid,6),'_','-')"/></xsl:attribute>
			</xsl:element>
			
			<!--  has deliveryMatrix RTF appendix -->
			<xsl:if test="(count($deliveryMatrix)>0) and (count($dM)>0)">
				<xsl:element name="property">
					<xsl:attribute name="key">delivery-matrix</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of  select="$dM/modelDocument"/></xsl:attribute>
				</xsl:element>
			</xsl:if>
	
			<!--  has <<BusinessProcess>> defined-->
			<xsl:if test="(count($businessProcess)>0) and (count($bP/properties[@stereotype='BusinessProcess'])>0)">
				<xsl:element name="property">
					<xsl:attribute name="key">businessProcess</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of  select="$businessProcess/@xmi:id"/></xsl:attribute>
				</xsl:element>
				<xsl:element name="property">
					<xsl:attribute name="key">documentation</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of  select="$bP/properties/@documentation"/></xsl:attribute>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	
		<xsl:element name="element">
			<xsl:attribute name="xsi:type">archimate:CompositionRelationship</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of  select="concat(generate-id($composite),'BpBpRel_')"/></xsl:attribute>
			<!--package-->
			<xsl:attribute name="source"><xsl:value-of select="generate-id(../@name)"/></xsl:attribute>
			<!--function-->
			<xsl:attribute name="target"><xsl:value-of select="generate-id($composite)"/></xsl:attribute>
		</xsl:element>
		
		
		<!-- continue with pools -->
		<!--  in case <<BusinessProcess>> is defined-->
		<xsl:if test="(count($businessProcess)>0) and (count($bP/properties[@stereotype='BusinessProcess'])>0)">
			<xsl:call-template name="business-process">
				<xsl:with-param name="superprocess" select="$composite"/>
				<xsl:with-param name="bizProcess" select="$businessProcess"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:apply-templates select="packagedElement[@xmi:type='uml:Package']" mode="inner"/>
	</xsl:template>
	
	
	<xsl:template name="business-process">
		<xsl:param name="bizProcess"/>
		<xsl:param name="superprocess"/>
		
		<!-- each POOL is one BUSINESS ROLE/ACTOR-->
		<xsl:for-each select="$bizProcess/group[@xmi:type='uml:ActivityPartition']">
			<!-- create business role -->
			<xsl:element name="element">
				<xsl:attribute name="xsi:type">archimate:BusinessRole</xsl:attribute>
				<xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="generate-id(@name)"/></xsl:attribute>
				
				<xsl:element name="property">
					<xsl:attribute name="key">GUID</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of  select="@xmi:id"/></xsl:attribute>
				</xsl:element>
				<xsl:element name="property">
					<xsl:attribute name="key">UID</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of  select="translate(substring(@xmi:id,6),'_','-')"/></xsl:attribute>
				</xsl:element>

			</xsl:element>
			
			<!-- for each pool search real activities-->
			<xsl:for-each select="node">
				<xsl:variable name="guid" select="./@xmi:idref"/>
				<xsl:variable name="activity" select="$bizProcess/packagedElement[(@xmi:id=$guid) and (@xmi:type='uml:Activity')]"/>
				<!-- real activity? -->
				<xsl:if test="count($activity)">
					<!-- create real activity -->
					<xsl:element name="element">
						
						<xsl:attribute name="xsi:type">archimate:BusinessProcess</xsl:attribute>
						<xsl:attribute name="id"><xsl:value-of  select="generate-id($activity)"/></xsl:attribute>
						<xsl:attribute name="name"><xsl:value-of  select="concat('(act)',$activity/@name)"/></xsl:attribute>
						
						<xsl:element name="property">
							<xsl:attribute name="key">GUID</xsl:attribute>
							<xsl:attribute name="value"><xsl:value-of  select="$activity/@xmi:id"/></xsl:attribute>
						</xsl:element>
						<xsl:element name="property">
							<xsl:attribute name="key">UID</xsl:attribute>
							<xsl:attribute name="value"><xsl:value-of  select="translate(substring($activity/@xmi:id,6),'_','-')"/></xsl:attribute>
						</xsl:element>
					</xsl:element>	
					<!-- link to superprocess -->
					<xsl:element name="element">
						<xsl:attribute name="xsi:type">archimate:CompositionRelationship</xsl:attribute>
						<xsl:attribute name="id"><xsl:value-of  select="concat(generate-id($activity),'ActBpRel_')"/></xsl:attribute>
						<!--package-->
						<xsl:attribute name="source"><xsl:value-of select="generate-id($superprocess)"/></xsl:attribute>
						<!--function-->
						<xsl:attribute name="target"><xsl:value-of select="generate-id($activity)"/></xsl:attribute>
					</xsl:element>
					<!-- link to business role -->
					<xsl:element name="element">
						<xsl:attribute name="xsi:type">archimate:AssignmentRelationship</xsl:attribute>
						<xsl:attribute name="id"><xsl:value-of  select="concat(generate-id($activity),'RolActRel_')"/></xsl:attribute>
						<!--package-->
						<xsl:attribute name="source"><xsl:value-of select="generate-id(../@name)"/></xsl:attribute>
						<!--function-->
						<xsl:attribute name="target"><xsl:value-of select="generate-id($activity)"/></xsl:attribute>
					</xsl:element>
					
				</xsl:if>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>
