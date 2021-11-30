<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:db="http://docbook.org/ns/docbook" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:svg="http://www.w3.org/2000/svg" xmlns:mml="http://www.w3.org/1998/Math/MathML"
    xmlns:dbx="http://sourceforge.net/projects/docbook/defguide/schema/extra-markup"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xsl db xlink svg mml dbx xi html">

    <xsl:import href="manage_tables.xsl"/>
    <xsl:import href="manage_figures.xsl"/>

    <xsl:param name="file_path_root">work_folder</xsl:param>
    <xsl:param name="innergroup_ids" select="//innergroup/@refid"/>

    <xsl:variable name="files"
        select="/doxygen/compounddef[@kind = 'file'][(string-length(normalize-space(.)) -  string-length(normalize-space(compoundname))) &gt; 0] 
        | /doxygen/compounddef[@kind = 'struct'][(string-length(normalize-space(.)) -  string-length(normalize-space(compoundname))) &gt; 0]
        | /doxygen/compounddef[@kind = 'union'][(string-length(normalize-space(.)) -  string-length(normalize-space(compoundname))) &gt; 0]
        | /doxygen/compounddef[@kind = 'group'][(string-length(normalize-space(.)) -  string-length(normalize-space(compoundname))) &gt; 0]"/>

    <xsl:output method="xml" media-type="text/xml" indent="no" encoding="UTF-8"
        doctype-public="-//OASIS//DTD DITA 1.2 Topic//EN" doctype-system="topic.dtd"/>

    <xsl:strip-space elements="* *:*"/>

    <xsl:variable name="quot">"</xsl:variable>
    <xsl:variable name="apos">'</xsl:variable>

    <xsl:template match="/">
        <xsl:for-each select="$files">
            <xsl:call-template name="create_topic"/>
        </xsl:for-each>
    </xsl:template>

    <!-- Remove processing instructions -->

    <xsl:template match="processing-instruction()"/>

    <xsl:template name="create_topic">
        <xsl:choose>
            <xsl:when test="@id">
                <xsl:variable name="sectionNumber">
                    <xsl:value-of select="@id"/>
                </xsl:variable>
                <xsl:result-document href="{$sectionNumber}.xml">
                    <topic id="{$sectionNumber}" class="- topic/topic "
                        domains="(topic ui-d) (topic hi-d) (topic pr-d) (topic sw-d)"
                        ditaarch:DITAArchVersion="1.1">
                        <xsl:call-template name="topic_title"/>
                        <xsl:call-template name="create_body"/>
                    </topic>
                </xsl:result-document>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="sectionNumber">
                    <xsl:value-of select="generate-id()"/>
                </xsl:variable>
                <xsl:result-document href="{$sectionNumber}.xml">
                    <topic id="{$sectionNumber}" class="- topic/topic "
                        domains="(topic ui-d) (topic hi-d) (topic pr-d) (topic sw-d)"
                        ditaarch:DITAArchVersion="1.1">
                        <xsl:call-template name="topic_title"/>
                        <xsl:call-template name="create_body"/>
                    </topic>
                </xsl:result-document>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="create_body">
        <body class="- topic/body ">
            <xsl:if test="@kind = 'group'">
                <xsl:if test="string-length(briefdescription) &gt; 2">
                    <bodydiv>
                        <section>
                            <xsl:apply-templates select="briefdescription"/>
                        </section>
                    </bodydiv>
                </xsl:if>
                <xsl:if test="string-length(detaileddescription) &gt; 2">
                    <xsl:apply-templates select="detaileddescription"/>
                </xsl:if>
                <xsl:if test="inbodydescription">
                    <xsl:apply-templates select="inbodydescription"/>
                </xsl:if>
            </xsl:if>
            <xsl:if test="descendant::includes">
                <xsl:element name="bodydiv">
                    <xsl:attribute name="class">- topic/bodydiv </xsl:attribute>
                    <xsl:element name="section" xml:space="default">
                        <xsl:attribute name="class">- topic/section </xsl:attribute>
                        <xsl:element name="title" xml:space="default">Includes</xsl:element>
                        <xsl:element name="ul" xml:space="default">
                            <xsl:call-template name="includes"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <xsl:if test="descendant::includedby">
                <bodydiv class="- topic/bodydiv ">
                    <section class="- topic/section ">
                        <title class="- topic/title ">Included By</title>
                        <ul>
                            <xsl:call-template name="includedby"/>
                        </ul>
                    </section>
                </bodydiv>
            </xsl:if>
            <xsl:if test="descendant::innerclass">
                <bodydiv class="- topic/bodydiv ">
                    <section class="- topic/section ">
                        <title class="- topic/title ">Structures</title>
                        <xsl:for-each select="innerclass">
                            <xsl:element name="parml">
                                <xsl:variable name="id" select="@refid"/>
                                <xsl:choose>
                                    <xsl:when test="//*[@id = $id]">
                                        <xsl:apply-templates select="//*[@id = $id]"
                                            mode="innerclasses"/>
                                    </xsl:when>
                                    <!-- When there is no match for the ID in the project, just output a basic plentry -->
                                    <xsl:otherwise>
                                        <xsl:element name="plentry">
                                            <pt>
                                                <xsl:value-of select="."/>
                                            </pt>
                                            <pd/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:element>
                        </xsl:for-each>
                    </section>
                </bodydiv>
            </xsl:if>
            <xsl:if test="descendant::sectiondef[@kind = 'define']">
                <bodydiv class="- topic/bodydiv ">
                    <section class="- topic/section ">
                        <title class="- topic/title ">Defines</title>
                        <parml>
                            <xsl:call-template name="defines"/>
                        </parml>
                    </section>
                </bodydiv>
            </xsl:if>
            <xsl:if test="descendant::sectiondef[@kind = 'typedef']">
                <bodydiv class="- topic/bodydiv ">
                    <section class="- topic/section ">
                        <title class="- topic/title ">Typedefs</title>
                        <parml>
                            <xsl:call-template name="typedefs"/>
                        </parml>
                    </section>
                </bodydiv>
            </xsl:if>
            <xsl:if test="descendant::sectiondef[@kind = 'func']">
                <bodydiv class="- topic/bodydiv ">
                    <section class="- topic/section ">
                        <title class="- topic/title ">Functions</title>
                        <parml>
                            <xsl:call-template name="funcs"/>
                        </parml>
                    </section>
                </bodydiv>
            </xsl:if>
            <xsl:if test="descendant::sectiondef[@kind = 'enum']">
                <bodydiv class="- topic/bodydiv ">
                    <section class="- topic/section ">
                        <title class="- topic/title ">Enumerations</title>
                        <parml>
                            <xsl:call-template name="enums"/>
                        </parml>
                    </section>
                </bodydiv>
            </xsl:if>
            <xsl:if test="descendant::sectiondef[@kind = 'public-attrib']">
                <bodydiv class="- topic/bodydiv ">
                    <section class="- topic/section ">
                        <title class="- topic/title ">Variables</title>
                        <parml>
                            <xsl:call-template name="variables"/>
                        </parml>
                    </section>
                </bodydiv>
            </xsl:if>
            <xsl:if test="descendant::programlisting">
                <bodydiv class="- topic/bodydiv ">
                    <section class="- topic/section ">
                        <title class="- topic/title ">File</title>
                        <p>
                            <xsl:apply-templates select="programlisting"/>
                        </p>
                    </section>
                </bodydiv>
            </xsl:if>
        </body>
    </xsl:template>

    <xsl:template name="topic_title">
        <xsl:element name="title">
            <xsl:attribute name="class">- topic/title </xsl:attribute>
            <xsl:choose>
                <xsl:when test="compoundname/following-sibling::*[1][self::title]">
                    <xsl:value-of select="compoundname/following-sibling::*[1][self::title]"/>
                </xsl:when>
                <xsl:when test="contains(substring(compoundname, 1, 3), 'fcc')">
                    <xsl:call-template name="add-underscores">
                        <xsl:with-param name="name" select="substring-after(compoundname, 'fcc')"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="add-underscores">
                        <xsl:with-param name="name" select="compoundname"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <xsl:template name="includes">
        <xsl:for-each select="includes">
            <xsl:choose>
                <xsl:when test="@local = 'yes' and string-length(normalize-space(@refid)) &gt; 0">
                    <li>
                        <xsl:element name="xref">
                            <xsl:attribute name="href">
                                <xsl:value-of select="@refid"/>
                            </xsl:attribute>
                            <xsl:attribute name="format">DITA</xsl:attribute>
                            <xsl:value-of select="."/>
                        </xsl:element>
                        <xsl:text> (local)</xsl:text>
                    </li>
                </xsl:when>
                <xsl:when test="@local = 'no' and string-length(normalize-space(@refid)) &gt; 0">
                    <li>
                        <xsl:element name="xref">
                            <xsl:attribute name="href">
                                <xsl:value-of select="@refid"/>
                            </xsl:attribute>
                            <xsl:attribute name="format">DITA</xsl:attribute>
                            <xsl:value-of select="."/>
                        </xsl:element>
                    </li>
                </xsl:when>
                <xsl:otherwise>
                    <li>
                        <xsl:value-of select="."/>
                    </li>
                </xsl:otherwise>
            </xsl:choose>

        </xsl:for-each>
    </xsl:template>

    <xsl:template name="includedby">
        <xsl:for-each select="includedby">
            <li>               
                <xsl:if test="string-length(normalize-space(@refid)) &gt; 0">
                <xsl:element name="xref">
                    <xsl:attribute name="href">
                        <xsl:value-of select="@refid"/>
                    </xsl:attribute>
                    <xsl:attribute name="format">DITA</xsl:attribute>
                    <xsl:value-of select="substring-after(., $file_path_root)"/>
                </xsl:element>
                </xsl:if>
                <xsl:if test="@local = 'yes'">(local)</xsl:if>
            </li>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="*" mode="innerclasses">
        <xsl:element name="plentry">
            <xsl:call-template name="id"/>
            <pt>
                <xsl:value-of select="compoundname"/>
            </pt>
            <pd>
                <xsl:if test="string-length(briefdescription) &gt; 2">
                    <xsl:apply-templates select="briefdescription"/>
                </xsl:if>
                <xsl:if test="string-length(detaileddescription) &gt; 2">
                    <xsl:apply-templates select="detaileddescription"/>
                </xsl:if>
                <xsl:if test="string-length(inbodydescription) &gt; 2">
                    <xsl:apply-templates select="inbodydescription"/>
                </xsl:if>
                <xsl:if test="sectiondef/memberdef">
                    <xsl:element name="parml">
                        <xsl:for-each select="sectiondef/memberdef">
                            <xsl:element name="plentry">
                                <xsl:call-template name="id"/>
                                <pt>
                                    <xsl:call-template name="strip-at-signs">
                                        <xsl:with-param name="content">
                                            <xsl:value-of select="definition"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                    <xsl:if test="bitfield"> :<xsl:value-of select="bitfield"
                                        /></xsl:if>
                                </pt>
                                <pd>
                                    <xsl:if test="string-length(briefdescription) &gt; 2">
                                        <xsl:apply-templates select="briefdescription"/>
                                    </xsl:if>
                                    <xsl:if test="string-length(detaileddescription) &gt; 2">
                                        <xsl:apply-templates select="detaileddescription"/>
                                    </xsl:if>
                                    <xsl:if test="string-length(inbodydescription) &gt; 2">
                                        <xsl:apply-templates select="inbodydescription"/>
                                    </xsl:if>
                                </pd>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:if>
            </pd>

        </xsl:element>
    </xsl:template>

    <xsl:template name="defines">
        <xsl:for-each select="sectiondef[@kind = 'define']/memberdef[@kind='define']">
            <xsl:element name="plentry">
                <xsl:call-template name="id"/>
                <pt>
                    <xsl:value-of select="name"/>
                    <ph>
                        <indexterm>Defines<indexterm><xsl:value-of select="name"
                            /></indexterm></indexterm>
                        <indexterm>
                            <xsl:value-of select="name"/>
                        </indexterm>
                    </ph>
                </pt>
                <pd>
                    <xsl:variable name="paramCount" select="count(param)"/>
                    <xsl:variable name="pad">
                        <xsl:call-template name="create-padding">
                            <xsl:with-param name="string_length" select="string-length(name) + 9"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:element name="codeblock">
                        <xsl:text>#define </xsl:text>
                        <xsl:value-of select="name"/>
                        <xsl:if test="param">
                            <xsl:text> (</xsl:text>
                        </xsl:if>
                        <xsl:text/>
                        <xsl:for-each select="param">
                            <xsl:if test="count(preceding-sibling::param) &gt; 0">
                                <xsl:value-of select="$pad"/>
                            </xsl:if>
                            <xsl:value-of select="normalize-space(defname)"/>
                            <xsl:if test="count(preceding-sibling::param) + 1 &lt; $paramCount"
                                >,</xsl:if>
                        </xsl:for-each>
                        <xsl:if test="param">
                            <xsl:text>) </xsl:text>
                        </xsl:if>
                        <xsl:value-of select="normalize-space(initializer)"/>

                    </xsl:element>
                </pd>
                <xsl:if
                    test="string-length(normalize-space(briefdescription)) &gt; string-length(name)">
                    <pd>
                        <xsl:if
                            test="string-length(normalize-space(detaileddescription)) &gt; 2 or string-length(normalize-space(inbodydescription)) &gt; 2"> </xsl:if>
                        <xsl:apply-templates select="briefdescription"/>
                    </pd>
                </xsl:if>
                <xsl:if test="string-length(normalize-space(detaileddescription)) &gt; 2">
                    <pd>
                        <xsl:if
                            test="string-length(normalize-space(briefdescription)) &gt; string-length(name) or string-length(normalize-space(inbodydescription)) &gt; 2"> </xsl:if>
                        <xsl:apply-templates select="detaileddescription"/>
                    </pd>
                </xsl:if>
                <xsl:if test="string-length(normalize-space(inbodydescription)) &gt; 2">
                    <pd>
                        <xsl:if
                            test="string-length(normalize-space(briefdescription)) &gt; string-length(name) or string-length(normalize-space(detaileddescription)) &gt; 2"> </xsl:if>
                        <xsl:apply-templates select="inbodydescription"/>
                    </pd>
                </xsl:if>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="typedefs">
        <xsl:for-each select="sectiondef[@kind = 'typedef']/memberdef[@kind='typedef']">
            <xsl:element name="plentry">
                <xsl:call-template name="id"/>
                <pt>
                    <xsl:value-of select="definition"/>
                    <ph>
                        <indexterm>Typedefs<indexterm><xsl:value-of select="name"
                            /></indexterm></indexterm>
                        <indexterm>
                            <xsl:value-of select="name"/>
                        </indexterm>
                    </ph>
                </pt>
                <pd>
                    <xsl:if test="string-length(normalize-space(briefdescription)) &gt; 2">
                        <xsl:apply-templates select="briefdescription"/>
                    </xsl:if>
                    <xsl:if test="string-length(normalize-space(detaileddescription)) &gt; 2">
                        <xsl:apply-templates select="detaileddescription"/>
                    </xsl:if>
                    <xsl:if test="string-length(normalize-space(inbodydescription)) &gt; 2">
                        <xsl:apply-templates select="inbodydescription"/>
                    </xsl:if>
                </pd>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="funcs">
        <xsl:for-each select="sectiondef[@kind = 'func']/memberdef[@kind='function']">

            <xsl:element name="plentry">
                <xsl:call-template name="id"/>
                <pt>
                    <xsl:value-of select="name"/>
                    <ph>
                        <indexterm>Functions<indexterm><xsl:value-of select="name"
                            /></indexterm></indexterm>
                        <indexterm>
                            <xsl:value-of select="name"/>
                        </indexterm>
                    </ph>
                </pt>
                <pd>
                    <xsl:variable name="paramCount" select="count(param)"/>
                    <xsl:element name="codeblock">
                        <xsl:text/>
                        <xsl:value-of select="definition"/>
                        <xsl:text>(
</xsl:text>
                        <xsl:text/>
                        <xsl:for-each select="param">
                            <xsl:text>        </xsl:text>
                            <xsl:value-of select="normalize-space(type)"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="normalize-space(declname)"/>
                            <xsl:if test="count(preceding-sibling::param) + 1 &lt; $paramCount"
                                >,</xsl:if>
                            <xsl:text>
</xsl:text>
                        </xsl:for-each>
                        <xsl:text>)</xsl:text>

                    </xsl:element>
                </pd>
                <xsl:if
                    test="string-length(normalize-space(briefdescription)) &gt; string-length(name)">
                    <pd>
                        <xsl:if
                            test="string-length(normalize-space(inbodydescription)) &gt; string-length(name) or string-length(normalize-space(detaileddescription)) &gt; 2"> </xsl:if>
                        <xsl:apply-templates select="briefdescription"/>
                    </pd>
                </xsl:if>
                <xsl:if test="string-length(normalize-space(detaileddescription)) &gt; 2">
                    <pd>
                        <xsl:if
                            test="string-length(normalize-space(inbodydescription)) &gt; string-length(name) or string-length(normalize-space(briefdescription)) &gt; string-length(name)"> </xsl:if>
                        <xsl:apply-templates select="detaileddescription"/>
                    </pd>
                </xsl:if>
                <xsl:if test="string-length(normalize-space(inbodydescription)) &gt; 2">
                    <pd>
                        <xsl:if
                            test="string-length(normalize-space(detaileddescription)) &gt; 2 or string-length(normalize-space(briefdescription)) &gt; string-length(name)"> </xsl:if>
                        <xsl:apply-templates select="inbodydescription"/>
                    </pd>
                </xsl:if>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="enums">
        <xsl:for-each select="sectiondef[@kind = 'enum']/memberdef[@kind='enum']">
            <xsl:element name="plentry">
                <xsl:call-template name="id"/>
                <pt>
                    <xsl:value-of select="name"/>
                    <ph>
                        <indexterm>Enums<indexterm><xsl:value-of select="name"
                            /></indexterm></indexterm>
                        <indexterm>
                            <xsl:value-of select="name"/>
                        </indexterm>
                    </ph>
                </pt>
                <xsl:if test="string-length(normalize-space(briefdescription)) &gt; 2">
                    <pd>
                        <xsl:apply-templates select="briefdescription"/>
                    </pd>
                </xsl:if>
                <xsl:if test="string-length(normalize-space(detaileddescription)) &gt; 2">
                    <pd>
                        <xsl:apply-templates select="detaileddescription"/>
                    </pd>
                </xsl:if>
                <xsl:if test="string-length(normalize-space(inbodydescription)) &gt; 2">
                    <pd>
                        <xsl:apply-templates select="inbodydescription"/>
                    </pd>
                </xsl:if>
                <xsl:if test="enumvalue">
                    <pd>
                        <dl>
                            <xsl:for-each select="enumvalue">
                                <dlentry>
                                    <dt>
                                        <xsl:value-of select="name"/>
                                    </dt>
                                    <dd>
                                        <xsl:choose>
                                            <xsl:when test="string-length(briefdescription) &gt; 2">
                                                <xsl:apply-templates select="briefdescription"/>
                                            </xsl:when>
                                            <xsl:when
                                                test="not(string-length(briefdescription) &gt; 2) and string-length(detaileddescription/para[1]) &gt; 2">
                                                <xsl:apply-templates
                                                  select="detaileddescription/para[1]"/>
                                            </xsl:when>
                                        </xsl:choose>
                                        <xsl:for-each select="detaileddescription/node()">
                                            <xsl:if
                                                test="not(self::para[1] and string-length(ancestor::enumvalue/briefdescription) &gt; 2)">
                                                <xsl:apply-templates select="*"/>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </dd>
                                </dlentry>
                            </xsl:for-each>
                        </dl>
                    </pd>
                </xsl:if>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="variables">
        <xsl:for-each select="sectiondef[@kind = 'public-attrib']/memberdef[@kind='variable']">
            <xsl:element name="plentry">
                <xsl:call-template name="id"/>
                <pt>
                    <xsl:value-of select="name"/>
                    <ph>
                        <indexterm>Variables<indexterm><xsl:value-of select="name"
                            /></indexterm></indexterm>
                        <indexterm>
                            <xsl:value-of select="name"/>
                        </indexterm>
                    </ph>
                </pt>
                <pd>
                    <simpletable relcolwidth="14* 86*">
                        <strow>
                            <stentry>Type:</stentry>
                            <stentry>
                                <xsl:value-of select="type"/>
                            </stentry>
                        </strow>
                        <strow>
                            <stentry>Definition:</stentry>
                            <stentry>
                                <xsl:value-of select="definition"/>
                            </stentry>
                        </strow>
                        <xsl:if test="string-length(argsstring) &gt; 0">
                            <strow>
                                <stentry>argsstring:</stentry>
                                <stentry>
                                    <xsl:value-of select="argsstring"/>
                                </stentry>
                            </strow>
                        </xsl:if>
                        <xsl:if test="location">
                            <strow>
                                <stentry>Location:</stentry>
                                <stentry>
                                    <xsl:call-template name="location"/>
                                </stentry>
                            </strow>
                        </xsl:if>
                    </simpletable>
                </pd>
                <xsl:if
                    test="string-length(normalize-space(briefdescription)) &gt; string-length(name)">
                    <pd>
                        <xsl:if
                            test="string-length(normalize-space(inbodydescription)) &gt; 2 or string-length(normalize-space(inbodydescription)) &gt; 2"> </xsl:if>
                        <xsl:apply-templates select="briefdescription"/>
                    </pd>
                </xsl:if>
                <xsl:if test="string-length(normalize-space(detaileddescription)) &gt; 2">
                    <pd>
                        <xsl:if
                            test="string-length(normalize-space(inbodydescription)) &gt; 2 or string-length(normalize-space(briefdescription)) &gt; string-length(name)"> </xsl:if>
                        <xsl:apply-templates select="detaileddescription"/>
                    </pd>
                </xsl:if>
                <xsl:if test="string-length(normalize-space(inbodydescription)) &gt; 2">
                    <pd>
                        <xsl:if
                            test="string-length(normalize-space(detaileddescription)) &gt; 2 or string-length(normalize-space(briefdescription)) &gt; string-length(name)"> </xsl:if>
                        <xsl:apply-templates select="inbodydescription"/>
                    </pd>
                </xsl:if>
                <xsl:if test="enumvalue">
                    <xsl:element name="parml">
                        <xsl:apply-templates select="enumvalue"/>
                    </xsl:element>
                </xsl:if>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>


    <!-- I think that incdepgraph and invincdepgraph are used to generate the image of dependencies -->

    <xsl:template match="incdepgraph | invincdepgraph"/>

    <!-- enum templates -->

    <xsl:template match="enumvalue">
        <xsl:element name="plentry">
            <xsl:call-template name="id"/>
            <xsl:element name="pt">
                <xsl:value-of select="name"/>
            </xsl:element>
            <pd>
                <xsl:element name="p">Initializer: <xsl:value-of select="initializer"
                    /></xsl:element>
                <p>
                    <xsl:call-template name="strip-at-signs">
                        <xsl:with-param name="content">
                            <xsl:value-of select="definition"/>
                        </xsl:with-param>
                    </xsl:call-template>
                    <xsl:call-template name="strip-at-signs">
                        <xsl:with-param name="content">
                            <xsl:value-of select="argstring"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </p>
                <xsl:if test="string-length(briefdescription) &gt; 2">
                    <note>
                        <p>6</p>
                        <xsl:apply-templates select="briefdescription"/>
                    </note>
                </xsl:if>
                <xsl:if test="location">
                    <xsl:call-template name="location"/>
                </xsl:if>
            </pd>

            <xsl:if test="string-length(detaileddescription) &gt; 2">
                <pd>
                    <xsl:apply-templates select="detaileddescription"/>
                </pd>
            </xsl:if>
            <xsl:if test="inbodydescription">
                <pd>
                    <xsl:apply-templates select="inbodydescription"/>
                </pd>
            </xsl:if>
        </xsl:element>
    </xsl:template>

    <!-- generic templates -->

    <xsl:template match="section">
        <xsl:variable name="cleanedup">
            <xsl:call-template name="clean-ids">
                <xsl:with-param name="name" select="heading/text()"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:element name="topic">
            <xsl:attribute name="id">title_<xsl:value-of select="$cleanedup"/>_<xsl:value-of
                    select="generate-id()"/></xsl:attribute>
            <xsl:element name="title">
                <xsl:value-of select="heading"/>
            </xsl:element>
            <xsl:element name="body">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="heading[count(preceding-sibling::element()) = 0][parent::section]"/>

    <xsl:template match="sect1">
        <xsl:element name="section">
            <xsl:call-template name="id"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="title">
        <xsl:element name="title">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="parameterlist">
        <xsl:element name="parml">
            <xsl:call-template name="id"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="parameterlist[@kind = 'param']">
        <xsl:element name="p">
            <xsl:element name="b">Parameters:</xsl:element>
        </xsl:element>
        <xsl:element name="parml">
            <xsl:call-template name="id"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="parameteritem">
        <xsl:element name="plentry">
            <xsl:call-template name="id"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="parameternamelist">
        <xsl:element name="pt">
            <xsl:call-template name="id"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="parameterdescription">
        <xsl:element name="pd">
            <xsl:call-template name="id"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="para">
        <xsl:variable name="children" select="child::element() | child::text()"/>

        <xsl:choose>
            <xsl:when test="parameterlist">
                <xsl:for-each select="$children">
                    <xsl:choose>
                        <xsl:when test="self::element()[name() = 'parameterlist']">
                            <xsl:apply-templates select="self::*"/>
                        </xsl:when>
                        <xsl:when test="self::text()">
                            <p>
                                <xsl:apply-templates select="."/>
                            </p>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="self::*"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="simplesect">
                <xsl:for-each select="$children">
                    <xsl:choose>
                        <xsl:when test="self::element()[name() = 'simplesect']">
                            <xsl:apply-templates select="self::*"/>
                        </xsl:when>
                        <xsl:when test="self::text()">
                            <p>
                                <xsl:apply-templates select="."/>
                            </p>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="self::*"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="p">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>



        <!--<xsl:choose>
            <xsl:when test="bold[contains(., 'Note:')]">
                <xsl:element name="note">
                    <xsl:call-template name="id"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>            
            <xsl:when test="count(child::element()) &gt; 0 and count(child::text()) = 0">
                <xsl:apply-templates/>
            </xsl:when>            
            <xsl:otherwise>
                <xsl:element name="p">
                    <xsl:call-template name="id"/>                  
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose> -->
    </xsl:template>

    <xsl:template match="parametername">
        <xsl:element name="parmname">
            <xsl:call-template name="id"/>
            <xsl:choose>
                <xsl:when test="@direction = 'in'">In:<xsl:text>  </xsl:text><xsl:value-of
                        select="."/></xsl:when>
                <xsl:when test="@direction = 'out'">Out:<xsl:text>  </xsl:text><xsl:value-of
                        select="."/></xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <xsl:template match="programlisting">
        <xsl:element name="codeblock">
            <xsl:call-template name="id"/>
            <xsl:attribute name="scale">70</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="codeline">
        <xsl:choose>
            <xsl:when test="string-length(.) = 0">
                <xsl:call-template name="line_number"/>
                <xsl:text>
</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="create_linenumber_anchor"/>
                <xsl:apply-templates/>
                <xsl:text>            
</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="highlight">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="sp">
        <xsl:text> </xsl:text>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template name="line_number">
        <xsl:choose>
            <xsl:when test="number(@lineno) &lt; 10">000<xsl:value-of
                    select="normalize-space(@lineno)"/>.</xsl:when>
            <xsl:when test="number(@lineno) &lt; 100">00<xsl:value-of
                    select="normalize-space(@lineno)"/>.</xsl:when>
            <xsl:when test="number(@lineno) &lt; 1000">0<xsl:value-of
                    select="normalize-space(@lineno)"/>.</xsl:when>
            <xsl:when test="@lineno"><xsl:value-of select="normalize-space(@lineno)"/>.</xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="create_linenumber_anchor">
        <xsl:if test="@lineno">
            <ph>
                <xsl:attribute name="id" select="@lineno"/>
                <xsl:call-template name="line_number"/>
            </ph>
        </xsl:if>
    </xsl:template>

   <!-- The content needed to create the SVG -->

    <xsl:template match="collaborationgraph"/>

    <xsl:template name="location">
        <p>
            <xsl:variable name="filename">
                <xsl:variable name="temp1" select="tokenize(location/@file, '/')"/>
                <xsl:variable name="temp2" select="$temp1[last()]"/>
                <xsl:variable name="temp3" select="//compounddef[compoundname = $temp2]/@id"/>
                <xsl:value-of select="$temp3"/>
            </xsl:variable>
            <xsl:variable name="file_path" select="substring-after(location/@file, $file_path_root)"/>
            <xsl:choose>
                <xsl:when test="string-length(normalize-space(@refid)) &gt; 0">
                    <xsl:element name="xref">                
                        <xsl:attribute name="href">
                            <xsl:value-of select="@refid"/>
                        </xsl:attribute>
                        <xsl:attribute name="format">DITA</xsl:attribute>
                        <xsl:variable name="temp1" select="tokenize(location/@file, '/')"/>
                        <xsl:variable name="temp2" select="$temp1[last()]"/>
                        <xsl:value-of select="$temp2"/>
                        <xsl:text> Line </xsl:text>
                        <xsl:value-of select="location/@line"/>
                    </xsl:element></xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="temp1" select="tokenize(location/@file, '/')"/>
                    <xsl:variable name="temp2" select="$temp1[last()]"/>
                    <xsl:value-of select="$temp2"/>
                    <xsl:text> Line </xsl:text>
                    <xsl:value-of select="location/@line"/>
                </xsl:otherwise>
            </xsl:choose>         
        </p>
    </xsl:template>

    <xsl:template match="simplesect">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="simplesect[@kind = 'return']">
        <p>
            <b>Return Values:</b>
        </p>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template name="id">
        <xsl:if test="@id">
            <xsl:attribute name="id" select="@id"/>
        </xsl:if>
    </xsl:template>


    <xsl:template match="orderedlist">
        <ol>
            <xsl:call-template name="id"/>
            <xsl:apply-templates/>
        </ol>
    </xsl:template>

    <xsl:template match="itemizedlist">
        <ul>
            <xsl:call-template name="id"/>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>

    <xsl:template match="listitem">
        <li>
            <xsl:call-template name="id"/>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <xsl:template match="preformatted">
        <xsl:element name="codeblock">
            <xsl:call-template name="id"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="bold">
        <xsl:choose>
            <xsl:when test="text() = 'Note:'"/>
            <xsl:otherwise>
                <xsl:element name="b">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="compoundname | innergroup"/>

    <xsl:template name="clean-ids-recurse">
        <xsl:param name="entry" select="''"/>
        <xsl:param name="search.chars">~`@#$%^&amp;*()=+{}[]|\:;"'&gt;&lt;,./? </xsl:param>
        <xsl:choose>
            <xsl:when test="$id.underscore = ''">
                <xsl:value-of select="$entry"/>
            </xsl:when>
            <xsl:when test="string-length($entry) &gt; 0">
                <xsl:variable name="char" select="substring($entry, 2, 1)"/>
                <xsl:if test="contains($search.chars, $char)">
                    <!-- Do not hyphen in-between // -->
                    <xsl:if
                        test="not($char = '/' and substring($entry,3,1) = '/' or contains($search.chars, substring($entry, 1, 1)))">
                        <xsl:copy-of select="$id.underscore"/>
                    </xsl:if>
                </xsl:if>
                <xsl:value-of select="$char"/>
                <!-- recurse to the next character -->
                <xsl:call-template name="clean-ids-recurse">
                    <xsl:with-param name="entry" select="substring($entry, 2)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$entry"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:param name="id.underscore">_</xsl:param>

    <xsl:template name="clean-ids">
        <xsl:param name="name"/>
        <xsl:variable name="size" select="string-length($name)"/>
        <xsl:variable name="processed_name">
            <xsl:call-template name="clean-ids-recurse">
                <xsl:with-param name="entry" select="$name"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="substring($name, 1, 1)"/>
        <xsl:value-of select="$processed_name"/>
    </xsl:template>

    <xsl:template name="add-underscores-recurse">
        <xsl:param name="entry" select="''"/>
        <xsl:param name="search.chars">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:param>
        <xsl:choose>
            <xsl:when test="$name.underscore = ''">
                <xsl:value-of select="$entry"/>
            </xsl:when>
            <xsl:when test="string-length($entry) &gt; 0">
                <xsl:variable name="char" select="substring($entry, 2, 1)"/>
                <xsl:if test="contains($search.chars, $char)">
                    <!-- Do not hyphen in-between // -->
                    <xsl:if
                        test="not($char = '/' and substring($entry,3,1) = '/' or contains($search.chars, substring($entry, 1, 1)))">
                        <xsl:copy-of select="$name.underscore"/>
                    </xsl:if>
                </xsl:if>
                <xsl:value-of select="$char"/>
                <!-- recurse to the next character -->
                <xsl:call-template name="add-underscores-recurse">
                    <xsl:with-param name="entry" select="substring($entry, 2)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$entry"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:param name="name.underscore">
        <xsl:text> </xsl:text>
    </xsl:param>

    <xsl:template name="add-underscores">
        <xsl:param name="name"/>
        <xsl:variable name="size" select="string-length($name)"/>
        <xsl:variable name="processed_name">
            <xsl:call-template name="add-underscores-recurse">
                <xsl:with-param name="entry" select="$name"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="substring($name, 1, 1)"/>
        <xsl:value-of select="$processed_name"/>
    </xsl:template>


    <xsl:template name="create-padding">
        <xsl:param name="string_length"/>
        <xsl:param name="count" select="0"/>
        <xsl:param name="padding"/>

        <xsl:variable name="pad">
            <xsl:text> </xsl:text>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="number($string_length) &gt;= number($count)">
                <xsl:call-template name="create-padding">
                    <xsl:with-param name="count" select="$count + 1"/>
                    <xsl:with-param name="padding">
                        <xsl:value-of select="concat($padding, $pad)"/>
                    </xsl:with-param>
                    <xsl:with-param name="string_length" select="$string_length"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$padding"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ref">
        <xsl:variable name="refid" select="@refid"/>
        <xsl:choose>
            <xsl:when test="preceding-sibling::para">
                <xsl:element name="para">
                    <xsl:element name="xref">
                        <xsl:attribute name="href">
                            <xsl:call-template name="generate-xref-target">
                              <xsl:with-param name="refid">
                                   <xsl:value-of select="@refid"/>
                              </xsl:with-param>
                            </xsl:call-template>                           
                        </xsl:attribute>
                        <xsl:attribute name="format">DITA</xsl:attribute>
                        <xsl:value-of select="."/>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="xref">
                    <xsl:attribute name="href">
                        <xsl:value-of select="@refid"/>
                    </xsl:attribute>
                    <xsl:attribute name="format">DITA</xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="strip-at-signs">
        <xsl:param name="content"/>
        <xsl:choose>
            <xsl:when test="contains($content, '@')">
                <xsl:value-of select="substring-before($content, '@')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$content"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="generate-xref-target">
        <xsl:param name="refid"/>
        <xsl:variable name="filename"
            select="//doxygen/compounddef[descendant-or-self::*[@id = $refid]]/@id"/>
        <xsl:choose>
            <xsl:when test="$filename = ancestor-or-self::compoundef/@id">
                <xsl:value-of select="concat('./', $refid)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($filename, '.xml#', $filename, '/',$refid)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


</xsl:stylesheet>
