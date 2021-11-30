<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:db="http://docbook.org/ns/docbook" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:svg="http://www.w3.org/2000/svg" xmlns:mml="http://www.w3.org/1998/Math/MathML"
    xmlns:dbx="http://sourceforge.net/projects/docbook/defguide/schema/extra-markup"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xsl db xlink svg mml dbx xi html">

    <xsl:param name="title">Dox 2 DITA Transformed Project</xsl:param>

    <!-- This stylesheet takes a Doxygen XML file flips it into a DITA bookmap. The next stylesheet will take the content of the Doxygen XML file and generate topics that connect to the bookmap -->

    <xsl:variable name="files" select="/doxygen/compounddef[@kind = 'file']"/>
    <xsl:variable name="structures" select="/doxygen/compounddef[@kind = 'struct']"/>
    <xsl:variable name="unions" select="/doxygen/compounddef[@kind = 'union']"/>
    <xsl:variable name="groups" select="/doxygen/compounddef[@kind = 'group']"/>


    <xsl:variable name="quot">"</xsl:variable>
    <xsl:variable name="apos">'</xsl:variable>

    <xsl:output method="xml" media-type="text/xml" indent="yes" encoding="UTF-8"
        doctype-public="-//OASIS//DTD DITA BookMap//EN" doctype-system="bookmap.dtd"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- Remove processing instructions -->

    <xsl:template match="processing-instruction()"/>

    <xsl:template match="db:cover"/>

    <!-- Turn the info element into pmc_iso elements -->
    <xsl:template name="pmc_iso_element">
        <xsl:element name="bookmeta">            
            <pmc_iso audience="PMCInternal">
                <pmc_title>
                    <xsl:value-of select="$title"/>
                </pmc_title>
                <pmc_subtitle> </pmc_subtitle>
                <pmc_abstract>
                    <p >This is the [ ] for the [ ] device.</p>
                </pmc_abstract>
                <pmc_productnumber>[PMxxxx]</pmc_productnumber>
                <pmc_document_id>[PMC-xxxxxxx]</pmc_document_id>
                <pmc_issue_date> </pmc_issue_date>
                <pmc_dev_status dev_status="Preliminary"/>
                <pmc_doc_status> </pmc_doc_status>
                <pmc_issuenum> </pmc_issuenum>
                <pmc_footertext>
                    <p>Proprietary and Confidential to PMC-Sierra, Inc.</p>
                </pmc_footertext>
                <pmc_patents>
                    <p> </p>
                </pmc_patents>
                <pmc_revhistory>
                    <pmc_revision >
                        <pmc_rev_number >[x]</pmc_rev_number>
                        <pmc_date >[Month Year]</pmc_date>
                        <pmc_name >[Author Name]</pmc_name>
                        <pmc_revdescription>
                            <p >[Revision Details]</p>
                        </pmc_revdescription>
                    </pmc_revision>
                </pmc_revhistory>
            </pmc_iso>
        </xsl:element>
    </xsl:template>


    <xsl:template match="doxygen">
        <xsl:element name="bookmap">            
            <xsl:attribute name="domains">(map mapgroup-d) (topic indexing-d) (topic xnal-d)</xsl:attribute>
            <xsl:attribute name="ditaarch:DITAArchVersion">1.1</xsl:attribute>
            <xsl:attribute name="id">org.pmc.help.ThisIsTheID</xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:call-template name="attribute_manager"/>
            <title>
                <xsl:value-of select="$title"/>
            </title>
            <xsl:call-template name="pmc_iso_element"/>
            <frontmatter>
                <booklists>
                    <toc></toc>
                </booklists>
            </frontmatter>
            <xsl:for-each select="$groups">
                <xsl:choose>
                    <xsl:when test="count(preceding-sibling::compounddef[@kind = 'group']) = 0">
                        <xsl:call-template name="create_chapterref"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>Preceding siblings <xsl:value-of
                                select="count(preceding-sibling::compounddef[@kind = 'group'])"/>
                        </xsl:message>
                        <xsl:call-template name="create_topicref"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>                 
            <backmatter>
                <booklists>
                    <indexlist/>
                </booklists>
            </backmatter>
        </xsl:element>
    </xsl:template>

    <!-- Eliminate the info element that is already being processed inside the article element -->

    <xsl:template match="db:table | db:informaltable" priority="10"/>

    <xsl:template name="create_chapter">
        <xsl:element name="chapter">
            <xsl:call-template name="attribute_manager"/>
            <xsl:call-template name="convert-attributes"/>
            <xsl:attribute name="href"><xsl:call-template name="id_processing"><xsl:with-param
                        name="link"><xsl:value-of select="@id"
                    /></xsl:with-param></xsl:call-template>.xml</xsl:attribute>
            <!-- Add attributes needed to connect the chapter to a file named after the section ID -->
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="create_topicref">
        <xsl:choose>
            <xsl:when test="@id = //compounddef[@kind = 'group']/innergroup/@refid">
                <xsl:message> Could find <xsl:value-of select="@id"/> belonging to any inner
                    group.</xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="compoundname = 'fccUserGuide'">
                        <xsl:element name="chapter">
                            <xsl:call-template name="attribute_manager"/>
                            <xsl:call-template name="convert-attributes"/>
                            <xsl:attribute name="href"><xsl:call-template name="id_processing"
                                        ><xsl:with-param name="link"><xsl:value-of select="@id"
                                        /></xsl:with-param></xsl:call-template>.xml</xsl:attribute>
                            <!-- Add attributes needed to connect the chapter to a file named after the section ID -->
                            <xsl:message> Could not find <xsl:value-of select="@id"/> belonging to
                                any inner group.</xsl:message>
                            <xsl:apply-templates/>
                            <xsl:for-each select="innergroup">
                                <xsl:variable name="refid" select="@refid"/>
                                <xsl:call-template name="innergroups">
                                    <xsl:with-param name="node" select="//node()[@id = $refid]"/>
                                </xsl:call-template>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="@id">
                        <xsl:element name="topicref">
                            <xsl:call-template name="attribute_manager"/>
                            <xsl:call-template name="convert-attributes"/>
                            <xsl:attribute name="href"><xsl:call-template name="id_processing"
                                        ><xsl:with-param name="link"><xsl:value-of select="@id"
                                        /></xsl:with-param></xsl:call-template>.xml</xsl:attribute>
                            <!-- Add attributes needed to connect the chapter to a file named after the section ID -->
                            <xsl:message> Could not find <xsl:value-of select="@id"/> belonging to
                                any inner group.</xsl:message>
                            <xsl:apply-templates/>
                            <xsl:for-each select="innergroup">
                                <xsl:variable name="refid" select="@refid"/>
                                <xsl:call-template name="innergroups">
                                    <xsl:with-param name="node" select="//node()[@id = $refid]"/>
                                </xsl:call-template>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="create_chapterref">
        <xsl:choose>
            <xsl:when test="@id = //compounddef[@kind = 'group']/innergroup/@refid">
                <xsl:message> Could find <xsl:value-of select="@id"/> belonging to any inner
                    group.</xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="@id">
                        <xsl:element name="chapter">
                            <xsl:call-template name="attribute_manager"/>
                            <xsl:call-template name="convert-attributes"/>
                            <xsl:attribute name="href"><xsl:call-template name="id_processing"
                                        ><xsl:with-param name="link"><xsl:value-of select="@id"
                                        /></xsl:with-param></xsl:call-template>.xml</xsl:attribute>
                            <!-- Add attributes needed to connect the chapter to a file named after the section ID -->
                            <xsl:message> Could not find <xsl:value-of select="@id"/> belonging to
                                any inner group.</xsl:message>
                            <xsl:apply-templates/>
                            <xsl:for-each select="innergroup">
                                <xsl:variable name="refid" select="@refid"/>
                                <xsl:call-template name="innergroups">
                                    <xsl:with-param name="node" select="//node()[@id = $refid]"/>
                                </xsl:call-template>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="innergroups">
        <xsl:param name="node"/>
        <xsl:for-each select="$node">
            <xsl:choose>
                <xsl:when test="@id">
                    <xsl:element name="topicref">
                        <xsl:call-template name="attribute_manager"/>
                        <xsl:call-template name="convert-attributes"/>
                        <xsl:attribute name="href"><xsl:call-template name="id_processing"
                                    ><xsl:with-param name="link"><xsl:value-of select="@id"
                                    /></xsl:with-param></xsl:call-template>.xml</xsl:attribute>
                        <!-- Add attributes needed to connect the chapter to a file named after the section ID -->
                        <xsl:apply-templates/>
                        <xsl:for-each select="innergroup">
                            <xsl:variable name="refid" select="@refid"/>
                            <xsl:call-template name="innergroups">
                                <xsl:with-param name="node" select="//node()[@id = $refid]"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="convert-attributes">
        <xsl:for-each select="@*">
            <xsl:choose>
                <xsl:when test="name(.) = 'audience'">
                    <xsl:attribute name="audience">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="name(.) = 'arch'">
                    <xsl:attribute name="product">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="name(.) = 'document'">
                    <xsl:attribute name="props">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="name(.) = 'role'">
                    <xsl:attribute name="otherprops">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
        <xsl:if test="db:title">
            <xsl:attribute name="navtitle">
                <xsl:value-of select="db:title/text()"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template name="deep-copy">
        <xsl:for-each select="child::node()">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="* | text()"/>

    <!-- ISO data -->

    <xsl:template match="db:info/*"/>

    <!-- Manage attributes -->

    <xsl:template name="attribute_manager">
        <xsl:for-each select="@*">
            <xsl:choose>
                <xsl:when test="name(.) = 'audience'">
                    <xsl:attribute name="audience">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="name(.) = 'arch'">
                    <xsl:attribute name="product">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="name(.) = 'document'">
                    <xsl:attribute name="props">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="name(.) = 'role'">
                    <xsl:attribute name="otherprops">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <!-- for some bizarre reason, someone nested a bunch of table in figure elements. This is just me busting them out. -->

    <xsl:template name="attribute_manager_figuretables">
        <xsl:for-each select="parent::db:figure/@*">
            <xsl:choose>
                <xsl:when test="name(.) = 'audience'">
                    <xsl:attribute name="audience">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="name(.) = 'arch'">
                    <xsl:attribute name="product">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="name(.) = 'document'">
                    <xsl:attribute name="props">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="name(.) = 'role'">
                    <xsl:attribute name="otherprops">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
        <xsl:call-template name="id_processing"/>
    </xsl:template>

    <!-- manage tfooters, which are not allowed in the DITA version of CALS tables. Call this template immediately after processing the table itself -->

    <xsl:template name="process_id">
        <xsl:choose>
            <xsl:when test="@xml:id">
                <xsl:variable name="sectionNumber">
                    <xsl:call-template name="id_processing"/>
                </xsl:variable>
                <xsl:value-of select="$sectionNumber"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="sectionNumber">
                    <xsl:value-of select="generate-id()"/>
                </xsl:variable>
                <xsl:value-of select="$sectionNumber"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="id_processing">
        <xsl:param name="link">default</xsl:param>
        <xsl:choose>
            <xsl:when test="$link = 'default'">
                <xsl:value-of select="@id"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$link"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
