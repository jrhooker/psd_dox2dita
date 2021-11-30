<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:db="http://docbook.org/ns/docbook" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:opentopic-i18n="http://www.idiominc.com/opentopic/i18n"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:date="http://exslt.org/dates-and-times" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:deltaxml="http://www.deltaxml.com/ns/well-formed-delta-v1"
    xmlns:dxx="http://www.deltaxml.com/ns/xml-namespaced-attribute"
    xmlns:dxa="http://www.deltaxml.com/ns/non-namespaced-attribute"
    xmlns:pi="http://www.deltaxml.com/ns/processing-instructions"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/" version="2.0">

    <xsl:param name="outputdir"/>

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Author:</xd:b> hookerje</xd:p>
            <xd:p>A script to rewrite xrefs to point to valid targets.</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:output method="xml" media-type="text/xml" indent="no" encoding="UTF-8"
        doctype-public="-//OASIS//DTD DITA 1.2 Topic//EN" doctype-system="topic.dtd"/>
    
    <xsl:variable name="hrefs" select="//*[@href]"/>

    <xsl:variable name="ids" select="document('../../out/out.xml')/targets" />

    <xsl:template match="/">
        <xsl:call-template name="copy-topics"/>
    </xsl:template>

    <xsl:template match="processing-instruction()">
        <xsl:copy/>
    </xsl:template>

    <xsl:template name="copy-topics">
        <xsl:for-each select="$hrefs">
            <xsl:message>
                <xsl:value-of select="@href"/>
            </xsl:message>
            <xsl:variable name="href"><xsl:value-of select="$outputdir"/><xsl:value-of select="@href"/></xsl:variable>
            <xsl:message>
                <xsl:value-of select="$href"/>
            </xsl:message>
            <xsl:result-document href="{$href}" method="xml">
                <xsl:apply-templates select="document(@href)" mode="copy"/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="*" priority="0" mode="copy">
        <xsl:copy>
            <!-- Manage attributes -->
            <xsl:for-each select="@*">
                <xsl:variable name="current_att">
                    <xsl:value-of select="."/>
                </xsl:variable>
                <xsl:variable name="current_att_name">
                    <xsl:value-of select="name()"/>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="string-length($current_att) &gt; 0">
                        <xsl:attribute name="{$current_att_name}">
                            <xsl:value-of select="$current_att"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:for-each>
            <xsl:apply-templates mode="copy"/>
        </xsl:copy>
    </xsl:template>


    <xsl:template match="xref" priority="10" mode="copy">
        <xsl:variable name="href_value">
            <xsl:call-template name="find-link-value">
                <xsl:with-param name="href" select="@href"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$href_value = 'no_match'"><xsl:value-of select="."/></xsl:when>
            <xsl:otherwise>
                <xsl:element name="xref">
                    <xsl:for-each select="@*">
                        <xsl:variable name="current_att">
                            <xsl:value-of select="."/>
                        </xsl:variable>
                        <xsl:variable name="current_att_name">
                            <xsl:value-of select="name()"/>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="string-length($current_att) &gt; 0">
                                <xsl:attribute name="{$current_att_name}">
                                    <xsl:value-of select="$current_att"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:attribute name="href">
                       <xsl:value-of select="$href_value"></xsl:value-of>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>


    <xsl:template name="find-link-value">
        <xsl:param name="href"/>
        <xsl:variable name="matching_ids" select="$ids/link[id = $href]"/>        
    <xsl:choose>
            <xsl:when test="count($matching_ids) &gt; 0">
                <xsl:choose>
                    <xsl:when test="substring-after($matching_ids[1]/path, '#') = $href"><xsl:copy-of select="$matching_ids[1]/path"/></xsl:when>
                    <xsl:otherwise><xsl:copy-of select="$matching_ids[1]/path"/><xsl:text>/</xsl:text><xsl:value-of select="$href"/></xsl:otherwise>
                </xsl:choose>
                <xsl:message>Match for: <xsl:value-of select="$href"/></xsl:message>
            </xsl:when>
            <xsl:otherwise>no_match</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
