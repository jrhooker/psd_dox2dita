<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="para[heading]">
        <xsl:element name="para">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="*[not(heading)]"/>
        </xsl:element>
        <xsl:for-each select="heading">
            <xsl:element name="heading">
                <xsl:copy-of select="@*"/>
                <xsl:copy-of select="text()"></xsl:copy-of>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="*|@*">
        <xsl:choose>
            <xsl:when test="self::*[name() = 'heading']"/>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
