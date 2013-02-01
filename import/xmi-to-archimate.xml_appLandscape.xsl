<?xml version="1.0"?>
<!--
    Title: xmi-to-archimate.xml_landscape.xsl
    Purpose: An XSL stylesheet for converting SParxs EA XMI Export to the archimate.xml to import applications and their relationships in one package. It creates ARCHIMATE valid model for each application and relationship with other application. See generate.xlsx list Applications.

	 Based on ArgoUML 0.80 XMI to HTML.Copyright (C) 1999-2001, Objects by Design, Inc. All Rights Reserved.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation.

    Version:  January 31, 2013
	pro XMI verze 1.0
	EA Source: [Common - EA] - Common for all countries -.Architecture.Group Architecture Concepts.Application landscape models.Copy of Reference model - Application landscape with Homer Select 
    
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:archimate="http://www.bolton.ac.uk/archimate" version="2.0" >
	<xsl:output method="xml" indent="yes"  omit-xml-declaration="yes"/>
	
	<xsl:key name="classifier" match="//Foundation.Core.Component" use="@xmi.id"/>
	<xsl:key name="dependency" match="//Foundation.Core.Dependency" use="@xmi.id"/>

	<xsl:variable name="components">
			<components>
				<xsl:for-each select="//Foundation.Core.Component[@xmi.id]" >
					<xsl:sort select="Foundation.Core.ModelElement.name"/>
					
					<xsl:variable name="component" select="Foundation.Core.ModelElement.name"/>
					<xsl:variable name="guid" select="@xmi.id"/>
					
					<xsl:element name="element">
						<xsl:attribute name="xsi:type">archimate:ApplicationComponent</xsl:attribute>
						<xsl:attribute name="id"><xsl:value-of  select="generate-id($component)"/></xsl:attribute>
						<xsl:attribute name="name"><xsl:value-of  select="$component"/></xsl:attribute>
			
						<xsl:element name="property">
							<xsl:attribute name="key">GUID</xsl:attribute>
							<xsl:attribute name="value"><xsl:value-of  select="$guid"/></xsl:attribute>
						</xsl:element>
					</xsl:element>
					
				</xsl:for-each>
			</components>		
	</xsl:variable>

	<xsl:variable name="_functions">
			<functions>
				<xsl:for-each select="$components/components/element" >
<!--					<xsl:sort select="$components/components/element/@name"/> -->
					
					<xsl:variable name="component" select="@name"/>
					<xsl:variable name="tid" select="@id"/>
					
					<xsl:element name="element">
						<xsl:attribute name="xsi:type">archimate:ApplicationFunction</xsl:attribute>
						<xsl:attribute name="id"><xsl:value-of  select="concat($tid,'tmpFnc_')"/></xsl:attribute>
						<xsl:attribute name="name"><xsl:value-of  select="concat('tmpFnc_',$component)"/></xsl:attribute>
					</xsl:element>
					
					<!-- relation -->
					<xsl:element name="element">
						<xsl:attribute name="xsi:type">archimate:AssignmentRelationship</xsl:attribute>
						<xsl:attribute name="id"><xsl:value-of  select="concat($tid,'tmpFncCmpRel_')"/></xsl:attribute>
						<!--component-->
						<xsl:attribute name="source"><xsl:value-of select="$tid"/></xsl:attribute>
						<!--function-->
						<xsl:attribute name="target"><xsl:value-of select="concat($tid,'tmpFnc_')"/></xsl:attribute>
					</xsl:element>
				</xsl:for-each>
			</functions>		
	</xsl:variable>	

	<xsl:variable name="functions">
			<functions>
				<xsl:copy-of select="$_functions/functions/element[@xsi:type='archimate:ApplicationFunction']">
				</xsl:copy-of>
			</functions>		
	</xsl:variable>	

	<xsl:variable name="relations_cmp_fnc">
			<relations_cmp_fnc>
				<xsl:copy-of select="$_functions/functions/element[@xsi:type='archimate:AssignmentRelationship']">
				</xsl:copy-of>
			</relations_cmp_fnc>		
	</xsl:variable>	

	
	<xsl:variable name="_services">
			<services>
				<xsl:for-each select="$functions/functions/element" >
					
					<xsl:variable name="function" select="@name"/>
					<xsl:variable name="tid" select="@id"/>

					<xsl:element name="element">
						<xsl:attribute name="xsi:type">archimate:ApplicationService</xsl:attribute>
						<xsl:attribute name="id"><xsl:value-of  select="concat($tid,'tmpSvc_')"/></xsl:attribute>
						<xsl:attribute name="name"><xsl:value-of  select="concat('Svc_',substring-after($function,'tmpFnc_'))"/></xsl:attribute>
					</xsl:element>

					<!-- relation -->
					<xsl:element name="element">
						<xsl:attribute name="xsi:type">archimate:RealisationRelationship</xsl:attribute>
						<xsl:attribute name="id"><xsl:value-of  select="concat($tid,'tmpFncSvcRel_')"/></xsl:attribute>
						<!--function-->
						<xsl:attribute name="source"><xsl:value-of select="$tid"/></xsl:attribute>
						<!--service-->
						<xsl:attribute name="target"><xsl:value-of select="concat($tid,'tmpSvc_')"/></xsl:attribute>
					</xsl:element>
				</xsl:for-each>
			</services>		
	</xsl:variable>	

	<xsl:variable name="services">
			<services>
				<xsl:copy-of select="$_services/services/element[@xsi:type='archimate:ApplicationService']">
				</xsl:copy-of>
			</services>		
	</xsl:variable>	

	<xsl:variable name="relations_fnc_svc">
			<relations_fnc_svc>
				<xsl:copy-of select="$_services/services/element[@xsi:type='archimate:RealisationRelationship']">
				</xsl:copy-of>
			</relations_fnc_svc>		
	</xsl:variable>	

	<xsl:variable name="_interfaces">
			<interfaces>
				<xsl:for-each select="$components/components/element" >

					<xsl:variable name="component" select="@name"/>
					<xsl:variable name="tid" select="@id"/>
					
					<xsl:element name="element">
						<xsl:attribute name="xsi:type">archimate:ApplicationInterface</xsl:attribute>
						<xsl:attribute name="id"><xsl:value-of  select="concat($tid,'tmpInt_')"/></xsl:attribute>
						<xsl:attribute name="name"><xsl:value-of  select="concat('Intfc_',$component)"/></xsl:attribute>
					</xsl:element>
					
					<!-- relation CmpIntfc--> 
					<xsl:element name="element">
						<xsl:attribute name="xsi:type">archimate:CompositionRelationship</xsl:attribute>
						<xsl:attribute name="id"><xsl:value-of  select="concat($tid,'tmpCmpIntfcRel_')"/></xsl:attribute>
						<!--component-->
						<xsl:attribute name="source"><xsl:value-of select="$tid"/></xsl:attribute>
						<!--interface-->
						<xsl:attribute name="target"><xsl:value-of select="concat($tid,'tmpInt_')"/></xsl:attribute>
					</xsl:element>

					<!-- relation IntfcSvc-->    
					<xsl:element name="element">
						<xsl:attribute name="xsi:type">archimate:AssignmentRelationship</xsl:attribute>
						<xsl:attribute name="id"><xsl:value-of  select="concat($tid,'tmpIntfcSvcRel_')"/></xsl:attribute>
						<!--interface-->
						<xsl:attribute name="source"><xsl:value-of select="concat($tid,'tmpInt_')"/></xsl:attribute>
						<!--service-->
						<xsl:variable name="_fnc" select="$functions/functions/element[@id=concat($tid,'tmpFnc_')]/@id"/>
						<xsl:attribute name="target"><xsl:value-of select="concat($_fnc,'tmpSvc_')"/></xsl:attribute>
					</xsl:element>
				</xsl:for-each>
			</interfaces>		
	</xsl:variable>	

	<xsl:variable name="interfaces">
			<interfaces>
				<xsl:copy-of select="$_interfaces/interfaces/element[@xsi:type='archimate:ApplicationInterface']">
				</xsl:copy-of>
			</interfaces>		
	</xsl:variable>	

	<xsl:variable name="relations_cmp_intfc">
			<relations_cmp_intfc>
				<xsl:copy-of select="$_interfaces/interfaces/element[@xsi:type='archimate:CompositionRelationship']">
				</xsl:copy-of>
			</relations_cmp_intfc>		
	</xsl:variable>	

	<xsl:variable name="relations_intfc_svc">
			<relations_intfc_svc>
				<xsl:copy-of select="$_interfaces/interfaces/element[@xsi:type='archimate:AssignmentRelationship']">
				</xsl:copy-of>
			</relations_intfc_svc>		
	</xsl:variable>	
			
	<!-- Document Root -->
	<xsl:template match="/">
		<xroot>
				<!-- Components -->
				<xsl:copy-of select="$components">
				</xsl:copy-of>
				<!-- Functions -->
				<xsl:copy-of select="$functions">
				</xsl:copy-of>
				<!-- relations cmp_fnc-->
				<xsl:copy-of select="$relations_cmp_fnc">
				</xsl:copy-of>
				<!-- services-->
				<xsl:copy-of select="$services">
				</xsl:copy-of>
				<!-- relations fnc_svc-->
				<xsl:copy-of select="$relations_fnc_svc">
				</xsl:copy-of>
				<!-- interfaces-->
				<xsl:copy-of select="$interfaces">
				</xsl:copy-of>
				<!-- relations_cmp_intfc-->
				<xsl:copy-of select="$relations_cmp_intfc">
				</xsl:copy-of>
				<!-- relations_intfc_svc-->
				<xsl:copy-of select="$relations_intfc_svc">
				</xsl:copy-of>
				<relations_svc_fnc>
					<xsl:apply-templates select="//Foundation.Core.Component" mode="abraka"/>
				</relations_svc_fnc>
		</xroot>	
	</xsl:template>



	
	<!-- Component -->
	<xsl:template match="Foundation.Core.Component" mode="abraka">
		<xsl:variable name="element_name" select="Foundation.Core.ModelElement.name"/>
		<xsl:variable name="xmi_id" select="@xmi.id"/>
		<xsl:call-template name="dependencies.asclient">
			<xsl:with-param name="ssource" select="$xmi_id"/>
		</xsl:call-template>
		<!--
		<xsl:call-template name="dependencies.assupplier">
			<xsl:with-param name="ssource" select="$xmi_id"/>
		</xsl:call-template> -->
		<xsl:call-template name="associations">
			<xsl:with-param name="ssource" select="$xmi_id"/>
		</xsl:call-template>
	</xsl:template>



	<!-- Dependencies (component as client) -->
	<xsl:template name="dependencies.asclient">
		<xsl:param name="ssource"/>
		<!-- Dependencies identify dependencies -->
		<xsl:variable name="dependencies" select="Foundation.Core.ModelElement.clientDependency/Foundation.Core.Dependency"/>
			<xsl:if test="count($dependencies) > 0">
				<xsl:for-each select="$dependencies">
					<!-- get the supplier in the dependency -->
					<xsl:variable name="dependence" select="key('dependency', ./@xmi.idref)"/>
					<xsl:variable name="target" select="$dependence/Foundation.Core.Dependency.supplier/*/@xmi.idref"/>
					<xsl:call-template name="classify">
						<xsl:with-param name="source" select="$ssource"/>
						<xsl:with-param name="target" select="$target"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:if>
	</xsl:template>
	
	<!-- Dependencies (component as supplier) -->
	<xsl:template name="dependencies.assupplier">
		<xsl:param name="ssource"/>
		<!-- Dependencies identify dependencies -->
		<xsl:variable name="dependencies" select="Foundation.Core.ModelElement.supplierDependency/Foundation.Core.Dependency"/>
			<xsl:if test="count($dependencies) > 0">
				<xsl:for-each select="$dependencies">
					<!-- get the client in the dependency -->
					<xsl:variable name="dependence" select="key('dependency', ./@xmi.idref)"/>
					<xsl:variable name="target" select="$dependence/Foundation.Core.Dependency.client/*/@xmi.idref"/>
					<xsl:call-template name="classify">
						<xsl:with-param name="source" select="$ssource"/>
						<xsl:with-param name="target" select="$target"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:if>
	</xsl:template>
	
	<!-- Associations -->
	<xsl:template name="associations">
		<xsl:param name="ssource"/>
		<xsl:variable name="association_ends" select="//Foundation.Core.AssociationEnd[Foundation.Core.AssociationEnd.type/*/@xmi.idref=$ssource]"/>
			<xsl:if test="count($association_ends) > 0">
				<xsl:for-each select="$association_ends">
					<xsl:for-each select="preceding-sibling::Foundation.Core.AssociationEnd|following-sibling::Foundation.Core.AssociationEnd">
						<xsl:variable name="target" select="Foundation.Core.AssociationEnd.type/*/@xmi.idref"/>
						<xsl:call-template name="classify">
						<xsl:with-param name="source" select="$ssource"/>
							<xsl:with-param name="target" select="$target"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:if>
	</xsl:template>
	

	<!-- Association End -->
	<xsl:template name="association_end">
		<xsl:variable name="target" select="Foundation.Core.AssociationEnd.type/*/@xmi.idref"/>
		<xsl:call-template name="classify">
			<xsl:with-param name="source" select="./@xmi_id"/>
			<xsl:with-param name="target" select="$target"/>
		</xsl:call-template>
	</xsl:template>
	
	<!-- Classification -->
	<xsl:template name="classify">
	
		<xsl:param name="source"/>
		<xsl:param name="target"/>
		
		<xsl:variable name="_appB" select="$components/components/element[property/@value=$source]"/>
		<xsl:variable name="_appA" select="$components/components/element[property/@value=$target]"/>
			<xsl:value-of select="$_appB[@id]"/>

		<xsl:element name="element">
			<xsl:attribute name="xsi:type">archimate:UsedByRelationship</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of  select="concat($_appB/@id,'SvcFncRel_')"/></xsl:attribute>
			<!--service app B-->
			<xsl:variable name="function" select="$functions/functions/element[@id=concat($_appB/@id,'tmpFnc_')]"/>
			<xsl:attribute name="source"><xsl:value-of select="concat($function/@id,'tmpSvc_')"/></xsl:attribute>
			<!--function app A-->
			<xsl:variable name="function" select="$functions/functions/element[@id=concat($_appA/@id,'tmpFnc_')]"/>
			<xsl:attribute name="target"><xsl:value-of select="$function/@id"/></xsl:attribute>
		</xsl:element>

		<xsl:message>From: <xsl:value-of select="$source"/> To: <xsl:value-of select="$target"/></xsl:message>
	</xsl:template>
</xsl:stylesheet>
