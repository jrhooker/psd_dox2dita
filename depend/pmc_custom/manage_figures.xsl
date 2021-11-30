<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:db="http://docbook.org/ns/docbook" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:svg="http://www.w3.org/2000/svg" xmlns:mml="http://www.w3.org/1998/Math/MathML"
    xmlns:dbx="http://sourceforge.net/projects/docbook/defguide/schema/extra-markup"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xsl db xlink svg mml dbx xi html">

    <xsl:template match="image">
        <xsl:element name="fig">
            <xsl:if test="@refid">
                <xsl:attribute name="id" select="@refid"></xsl:attribute>
            </xsl:if>
            <xsl:if test="text()">
                <xsl:element name="title">
                    <xsl:value-of select="text()"/>
                </xsl:element>
            </xsl:if>
            <xsl:element name="image">
                <xsl:attribute name="href" select="@name"/>
                <xsl:attribute name="placement">break</xsl:attribute>
                <xsl:attribute name="width">400</xsl:attribute>
            </xsl:element>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
