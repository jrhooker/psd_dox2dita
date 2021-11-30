<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:param name="heading-level" select="3"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="heading[@level = $heading-level]">
        <xsl:variable name="level" select="@level"/>
        <xsl:variable name="heading-count"
            select="count(preceding-sibling::heading[@level = $heading-level]) + 1"/>
        <xsl:element name="section">
            <xsl:element name="heading">
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates/>
            </xsl:element>
            <xsl:for-each select="following-sibling::element()">
                <xsl:call-template name="process-siblings">
                    <xsl:with-param name="heading-node" select="$heading-count"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template name="process-siblings">
        <xsl:param name="heading-node"/>
        <xsl:choose>
            <xsl:when test="self::heading[@level = $heading-level]"></xsl:when>
            <xsl:when
                test="count(preceding-sibling::heading[@level = $heading-level]) = number($heading-node)">               
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template
        match="*[preceding-sibling::heading[@level = $heading-level] and not(self::heading[@level = $heading-level])]"/>

    <xsl:template match="*|@*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>



</xsl:stylesheet>
