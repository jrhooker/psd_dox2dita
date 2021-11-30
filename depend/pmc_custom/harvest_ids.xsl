<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:str="http://xsltsl.org/string" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0">

    <xsl:variable name="hrefs" select="//*[@href]"/>
    <xsl:variable name="line_feed">
        <xsl:text>        
</xsl:text>
    </xsl:variable>

    <xsl:output omit-xml-declaration="yes"/>

    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <xsl:element name="targets">
            <xsl:for-each select="$hrefs">
                <xsl:apply-templates select="document(@href)" mode="topics">
                    <xsl:with-param name="href" select="@href"/>
                </xsl:apply-templates>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template match="*" mode="topics">
        <xsl:param name="href"/>
        <xsl:variable name="ids" select="//@id"/>
        <xsl:for-each select="$ids">
            <xsl:variable name="topic-ancestors" select="ancestor-or-self::*[contains(@class, ' topic/topic ')]"></xsl:variable>
            <xsl:element name="link">
                <xsl:element name="id">
                    <xsl:value-of select="."/>
                </xsl:element>
                <xsl:element name="path">
                    <xsl:value-of select="$href"/>#<xsl:value-of select="$topic-ancestors[last()]/@id"></xsl:value-of>
                </xsl:element>
            </xsl:element>
           
            <xsl:value-of select="$line_feed"/>
        </xsl:for-each>

    </xsl:template>

</xsl:stylesheet>
