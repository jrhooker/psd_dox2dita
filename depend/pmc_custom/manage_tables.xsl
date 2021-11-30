<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:db="http://docbook.org/ns/docbook" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:svg="http://www.w3.org/2000/svg" xmlns:mml="http://www.w3.org/1998/Math/MathML"
    xmlns:dbx="http://sourceforge.net/projects/docbook/defguide/schema/extra-markup"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xsl db xlink svg mml dbx xi html">

    <xsl:template match="table">
        <xsl:element name="table">
            <xsl:if test="@refid">
                <xsl:attribute name="id" select="@refid"></xsl:attribute>
            </xsl:if>
            <xsl:if test="caption">
                <xsl:element name="title">
                    <xsl:value-of select="caption"/>
                </xsl:element>
            </xsl:if>
            <xsl:element name="tgroup">
                <xsl:attribute name="cols" select="@cols"/>
                <xsl:if test="row/entry[@thead = 'yes']">
                    <xsl:element name="thead">
                        <xsl:for-each select="row[entry[@thead = 'yes']]">
                            <xsl:element name="row">
                                <xsl:apply-templates/>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="row/entry[@thead = 'no']">
                    <xsl:element name="tbody">
                        <xsl:for-each select="row[entry[@thead = 'no']]">
                            <xsl:element name="row">
                                <xsl:apply-templates/>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:if>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="entry">
        <xsl:element name="entry">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
