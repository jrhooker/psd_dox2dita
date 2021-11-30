<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:db="http://docbook.org/ns/docbook" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:svg="http://www.w3.org/2000/svg" xmlns:mml="http://www.w3.org/1998/Math/MathML"
    xmlns:dbx="http://sourceforge.net/projects/docbook/defguide/schema/extra-markup"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xsl db xlink svg mml dbx xi html">

    <xsl:output method="xml" media-type="text/xml" indent="yes" encoding="UTF-8"
        doctype-public="-//OASIS//DTD DITA Topic//EN"
        doctype-system="http://216.241.226.55:8080/xdbres/SysSchema/dita/topic.dtd"/>

    <xsl:variable name="quot">"</xsl:variable>
    <xsl:variable name="apos">'</xsl:variable>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- Remove processing instructions -->

    <xsl:template match="processing-instruction()"/>

    <!-- Turn the info element into pmc_iso elements -->

    <!-- Eliminate the info element that is already being processed inside the article element -->

    <xsl:template match="db:section | db:appendix | db:preface">
        <xsl:if test="string-length(normalize-space(.)) &gt; 2">
        <xsl:choose>
            <xsl:when test="@xml:id">
                <xsl:variable name="sectionNumber">
                    <xsl:value-of select="@xml:id"/>
                </xsl:variable>
                <xsl:result-document href="{$sectionNumber}.xml">
                    <topic id="{$sectionNumber}" class=" - topic/topic "
                        domains="(topic ui-d) (topic hi-d) (topic pr-d) (topic sw-d)"
                        ditaarch:DITAArchVersion="1.1">
                        <xsl:call-template name="topic_title"/>
                        <xsl:call-template name="generate_prolog"/>
                        <body class="- topic/body ">
                            <xsl:apply-templates/>
                        </body>
                    </topic>
                </xsl:result-document>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="sectionNumber">
                    <xsl:value-of select="generate-id()"/>
                </xsl:variable>
                <xsl:result-document href="{$sectionNumber}.xml">
                    <topic id="{$sectionNumber}" class=" - topic/topic "
                        domains="(topic ui-d) (topic hi-d) (topic pr-d) (topic sw-d)"
                        ditaarch:DITAArchVersion="1.1">
                        <xsl:call-template name="topic_title"/>
                        <xsl:call-template name="generate_prolog"/>
                        <body class="- topic/body ">
                            <xsl:apply-templates/>
                        </body>
                    </topic>
                </xsl:result-document>
            </xsl:otherwise>
        </xsl:choose>
        </xsl:if>
    </xsl:template>
    

    <xsl:template match="db:info">
        <xsl:choose>
            <xsl:when test="@xml:id">
                <xsl:variable name="sectionNumber">
                    <xsl:value-of select="@xml:id"/>
                </xsl:variable>
                <xsl:result-document href="index.xml">
                    <topic id="{$sectionNumber}" class=" - topic/topic "
                        domains="(topic ui-d) (topic hi-d) (topic pr-d) (topic sw-d)"
                        ditaarch:DITAArchVersion="1.1">
                        <xsl:element name="title">
                            <xsl:attribute name="class">- topic/title </xsl:attribute>
                            <xsl:value-of select="db:title"/>
                        </xsl:element>
                        <xsl:call-template name="generate_prolog"/>
                        <body class="- topic/body ">
                            <xsl:call-template name="info_element"/>
                            <xsl:call-template name="resource_list"/>
                        </body>
                    </topic>
                </xsl:result-document>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="sectionNumber">
                    <xsl:value-of select="generate-id()"/>
                </xsl:variable>
                <xsl:result-document href="index.xml">
                    <topic id="{$sectionNumber}" class=" - topic/topic "
                        domains="(topic ui-d) (topic hi-d) (topic pr-d) (topic sw-d)"
                        ditaarch:DITAArchVersion="1.1">
                        <xsl:element name="title">
                            <xsl:attribute name="class">- topic/title </xsl:attribute>
                            <xsl:value-of select="db:title"/>
                        </xsl:element>
                        <body class="- topic/body ">
                            <xsl:call-template name="info_element"/>
                            <xsl:call-template name="resource_list"/>
                        </body>
                    </topic>
                </xsl:result-document>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="generate_numbering">
        <xsl:number format="1. " level="multiple" count="child::db:section"/>
    </xsl:template>

    <xsl:template name="topic_title">
        <xsl:for-each select="db:title">
            <xsl:choose>
                <xsl:when
                    test="parent::db:table | parent::db:figure | parent::db:example | parent::db:procedure | parent::db:preface">
                    <xsl:element name="title">
                        <xsl:attribute name="class">- topic/title </xsl:attribute>
                        <xsl:apply-templates/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="title">                        
                        <xsl:attribute name="class">- topic/title </xsl:attribute>
                        <xsl:call-template name="generate_numbering"/>
                        <xsl:call-template name="add-underscores"><xsl:with-param name="name"><xsl:value-of select="."/></xsl:with-param></xsl:call-template>
                        <xsl:apply-templates/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="get_topic_title">
        <xsl:for-each select="db:title">
            <xsl:apply-templates/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="get_index_topic_title">
        <xsl:for-each select="db:title">
            <xsl:value-of select="."/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="db:para | db:caption">
        <xsl:element name="p">
            <xsl:attribute name="class">- topic/p </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:title">
        <xsl:choose>
            <xsl:when
                test="parent::db:section | parent::db:appendix | parent::db:preface | parent::db:table | parent::db:example | parent::db:figure"/>
            <xsl:otherwise>
                <xsl:element name="title">
                    <xsl:attribute name="class">- topic/title </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="db:title" mode="resource_list">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="db:abstract">
        <xsl:element name="shortdesc">            
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:bridgehead">
        <xsl:element name="p">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>            
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:sect5">
        <xsl:element name="section">
            <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:attribute name="class">- topic/section </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:sect1">
        <xsl:element name="section">
            <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:attribute name="class">- topic/section </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:table">
        <xsl:element name="table">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="class">- topic/table </xsl:attribute>
            <xsl:attribute name="otherprops">
                <xsl:number format="1" level="any"/>
            </xsl:attribute>
            <xsl:call-template name="topic_title"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:informaltable|db:entrytbl">
        <xsl:element name="table">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="class">- topic/table </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:tgroup">
        <xsl:element name="tgroup">
            <xsl:attribute name="class">- topic/tgroup </xsl:attribute>
            <xsl:attribute name="cols">
                <xsl:value-of select="@cols"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:tbody">
        <xsl:element name="tbody">
            <xsl:attribute name="class">- topic/tbody </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:thead">
        <xsl:element name="thead">
            <xsl:attribute name="class">- topic/thead </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:tfoot">
        <xsl:element name="tfoot">
            <xsl:attribute name="class">- topic/tfoot </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:row">
        <xsl:choose>
            <xsl:when test="(ancestor::db:informaltable) and (ancestor::db:thead)">
                <xsl:element name="head">
                    <xsl:attribute name="class">- topic/head </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="(ancestor::db:informaltable) and (ancestor::db:tbody)">
                <xsl:element name="row">
                    <xsl:attribute name="class">- topicrow </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="(ancestor::db:table) and (ancestor::db:thead)">
                <xsl:element name="row">
                    <xsl:attribute name="class">- topic/row </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="(ancestor::db:table) and (ancestor::db:tbody)">
                <xsl:element name="row">
                    <xsl:attribute name="class">- topic/row </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="(ancestor::db:entrytbl) and (ancestor::db:thead)">
                <xsl:element name="row">
                    <xsl:attribute name="class">- topic/row </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="(ancestor::db:entrytbl) and (ancestor::db:tbody)">
                <xsl:element name="row">
                    <xsl:attribute name="class">- topic/row </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="row">
                    <xsl:attribute name="class">- topic/row </xsl:attribute>
                    <xsl:apply-templates/>
                    <xsl:element name="entry">
                        <xsl:attribute name="class">- topic/entry </xsl:attribute> Missing options
                        in the db:row template </xsl:element>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="db:entry">
        <xsl:choose>
            <xsl:when test="(ancestor::node() = db:simpletable)">
                <xsl:element name="entry">
                    <xsl:if test="@nameend">
                        <xsl:copy-of select="@nameend"/>
                    </xsl:if>
                    <xsl:if test="@namest">
                        <xsl:copy-of select="@namest"/>
                    </xsl:if>
                    <xsl:if test="@morerows">
                        <xsl:copy-of select="@morerows"/>
                    </xsl:if>
                    <xsl:attribute name="class">- topic/entry </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="entry">
                    <xsl:if test="@nameend">
                        <xsl:copy-of select="@nameend"/>
                    </xsl:if>
                    <xsl:if test="@namest">
                        <xsl:copy-of select="@namest"/>
                    </xsl:if>
                    <xsl:if test="@morerows">
                        <xsl:copy-of select="@morerows"/>
                    </xsl:if>
                    <xsl:if test="@spanname">
                        <xsl:copy-of select="@spanname"/>
                    </xsl:if>
                    <xsl:attribute name="class">- topic/entry </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="db:colspec">
        <xsl:element name="colspec">
            <xsl:copy-of select="@*"/>
            <!-- <xsl:if test="@colwidth">
                <xsl:choose>
                    <xsl:when test="contains(@colwidth, 'in')">
                        <xsl:attribute name="colwidth"><xsl:value-of select="substring-before(@width, 'in') * 150" />px</xsl:attribute>          
                    </xsl:when>                 
                    <xsl:when test="contains(@colwidth, 'cm')"><xsl:attribute name="colwidth"><xsl:value-of select="substring-before(@colwidth, 'cm') * 70"></xsl:value-of>px</xsl:attribute></xsl:when>
                    <xsl:when test="contains(@colwidth, 'mm')"><xsl:attribute name="colwidth"><xsl:value-of select="substring-before(@colwidth, 'cm') * 7"></xsl:value-of>px</xsl:attribute></xsl:when>
                </xsl:choose>
            </xsl:if>-->
            <xsl:attribute name="class">- topic/colspec </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:spanspec">
        <xsl:element name="spanspec">
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="class">- topic/spanspec </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:caution | db:warning | db:note | db:tip | db:important">
        <xsl:element name="note">
            <xsl:attribute name="class">- topic/note </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:code | db:command | db:filename">
        <xsl:element name="codeph">
            <xsl:attribute name="class">- topic/ph pr-d/codeph </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:example">
        <xsl:element name="example">
            <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:attribute name="class">- topic/example </xsl:attribute>
            <xsl:attribute name="otherprops">
                <xsl:number format="1" level="any"/>
            </xsl:attribute>
            <xsl:call-template name="topic_title"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:footnote">
        <xsl:element name="fn">
            <xsl:attribute name="id">
                <xsl:value-of select="xml:id"/>
            </xsl:attribute>
            <xsl:attribute name="class">- topic/fn </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:footnoteref">
        <xsl:element name="xref">
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="class">- topic/fn </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:figure">
        <xsl:element name="fig">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="class">- topic/fig </xsl:attribute>
            <xsl:attribute name="otherprops">
                <xsl:number format="1" level="any"/>
            </xsl:attribute>
            <xsl:call-template name="topic_title"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:mediaobject | db:imageobject">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="db:imagedata">
        <xsl:element name="image">
            <xsl:attribute name="class">- topic/image </xsl:attribute>
            <xsl:attribute name="placement">break</xsl:attribute>
            <!--<xsl:if test="@width or @depth">
                   <xsl:choose>
                     <xsl:when test="contains(@width, 'in')">
                         <xsl:attribute name="width"><xsl:value-of select="number(substring-before(@width, 'in')) * 200" />px</xsl:attribute>          
                     </xsl:when>
                       <xsl:when test="contains(@depth, 'in')">
                           <xsl:attribute name="height"><xsl:value-of select="number(substring-before(@depth, 'in')) * 200" />px</xsl:attribute>                            
                   </xsl:when>
                     <xsl:when test="contains(@width, 'cm')"><xsl:value-of select="substring-before(@width, 'cm') * 70"></xsl:value-of>px</xsl:when>
                     <xsl:when test="contains(@width, 'mm')"><xsl:value-of select="substring-before(@width, 'cm') * 7"></xsl:value-of>px</xsl:when>
                   </xsl:choose>
                   </xsl:if>-->
            <xsl:attribute name="href">
                <xsl:value-of select="@fileref"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:index | db:indexdiv"/>

    <xsl:template match="db:indexentry">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="db:primary">
        <xsl:element name="indexterm">
            <xsl:attribute name="class">- topic/indexterm </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:secondary">
        <xsl:element name="indexterm">
            <xsl:attribute name="class">- topic/indexterm </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:tertiary">
        <xsl:element name="indexterm">
            <xsl:attribute name="class">- topic/indexterm </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:inlinemediaobject">
        <xsl:for-each select="db:imageobject/db:imagedata">
            <xsl:element name="image">
                <xsl:attribute name="class">- topic/image </xsl:attribute>
                <xsl:attribute name="placement">inline</xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:value-of select="@href"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="db:itemizedlist">
        <xsl:element name="ul">
            <xsl:attribute name="class">- topic/ul </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:orderedlist  | db:substeps">
        <xsl:if test="db:title">
            <xsl:element name="p">
                <xsl:attribute name="class">- topic/p </xsl:attribute>
                <xsl:value-of select="db:title"/>
            </xsl:element>
        </xsl:if>
        <xsl:element name="ol">
            <xsl:attribute name="class">- topic/ol </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:orderedlist/db:title | db:substeps/db:title"/>

    <xsl:template match="db:procedure">
        <xsl:element name="p">
            <xsl:attribute name="class">- topic/p </xsl:attribute>
            <xsl:element name="b">
                <xsl:attribute name="class">+ topic/ph hi-d/b </xsl:attribute>
                <xsl:value-of select="db:title"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="ol">
            <xsl:attribute name="class">- topic/ol </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:listitem | db:step | db:member">
        <xsl:element name="li">
            <xsl:attribute name="class">- topic/li </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:phrase">
        <xsl:element name="ph">
            <xsl:attribute name="class">- topic/ph </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:emphasis">
        <xsl:choose>
            <xsl:when test="contains(@role, 'bold')">
                <xsl:element name="b">
                    <xsl:attribute name="class">+ topic/ph hi-d/b </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="i">
                    <xsl:attribute name="class">+ topic/ph hi-d/i </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="db:programlisting">
        <xsl:element name="codeblock">
            <xsl:attribute name="scale">50</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:remark"/>

    <xsl:template match="db:simplelist">
        <xsl:element name="sl">
            <xsl:attribute name="class">- topic/sl </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:subscript">
        <xsl:element name="sub">
            <xsl:attribute name="class">- topic/ph -hi-d/sub </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:superscript">
        <xsl:element name="sup">
            <xsl:attribute name="class">- topic/ph -hi-d/sup </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:subtitle"/>

    <xsl:template match="db:symbol">
        <xsl:element name="ph">
            <xsl:attribute name="class">- topic/ph </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:variablelist">
        <xsl:element name="parml">
            <xsl:attribute name="class">- topic/dl pr-d/parml</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:varlistentry">
        <xsl:element name="plentry">
            <xsl:attribute name="class">- topic/dl pr-d/plentry </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:varlistentry/db:term">
        <xsl:element name="pt">
            <xsl:attribute name="class">- topic/dl pr-d/pt </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:varlistentry/db:listitem">
        <xsl:element name="pd">
            <xsl:attribute name="class">- topic/dl pr-d/pd </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:trademark">
        <xsl:element name="tm">
            <xsl:attribute name="class">- topic/tm </xsl:attribute>
            <xsl:attribute name="tmtype">tm</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- Cross refertences are tricky. In particular, we need to detect if the xref is to the current file, and if so avoid adding the filename. -->

    <xsl:template match="db:xref">
        <!-- Grab the ID of the xref endpoint  -->
        <xsl:variable name="temp_id">
            <xsl:value-of select="@linkend"/>
        </xsl:variable>
        <!-- Start forming the Xref  -->
        <xsl:element name="xref">
            <xsl:attribute name="class">- topic/xref </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:choose>
                    <!-- Form the href value of the xref. When the id is the id of a section or the preface, simply form the href by adding an .xml to the end of the id -->
                    <xsl:when test="//db:section[@xml:id=$temp_id] | //db:preface[@xml:id=$temp_id]">
                        <xsl:value-of select="concat($temp_id, '.xml')"/>
                    </xsl:when>
                    <!-- When the xref is the id of a table, figure, example, sect1, or listitem, it is an inside join, so we'll have to determine the section element that contains it before we can link to it -->
                    <xsl:when
                        test="(//db:table[@xml:id=$temp_id]) | (//db:figure[@xml:id=$temp_id]) | (//db:example[@xml:id=$temp_id])  | (//db:sect1[@xml:id=$temp_id]) |  (//db:sect5[@xml:id=$temp_id]) | (//db:listitem[@xml:id=$temp_id])  | (//db:row[@xml:id=$temp_id])   | (//db:para[@xml:id=$temp_id])">
                        <xsl:call-template name="find_xerf_target_parent_section">
                            <xsl:with-param name="temp_id">
                                <xsl:value-of select="$temp_id"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:value-of select="$temp_id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="find_xerf_target_parent_section">
                            <xsl:with-param name="temp_id">
                                <xsl:value-of select="$temp_id"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:value-of select="$temp_id"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
                <!-- If the ID is a row, look for the xref label -->
                <xsl:when test="@role = 'blockname'">
                    <xsl:call-template name="find_block_name">
                        <xsl:with-param name="temp_id">
                            <xsl:value-of select="$temp_id"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@role = 'register_table'">
                    <xsl:call-template name="find_block_name">
                        <xsl:with-param name="temp_id">
                            <xsl:value-of select="$temp_id"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="//db:row[@xml:id=$temp_id]">
                    <xsl:value-of select="//db:row[@xml:id=$temp_id]/@xreflabel"/>
                </xsl:when>
                <!-- when the endpoint is a sect1 or a sect5, it can be assumed to be a reg_bit -->
                <xsl:when test="//db:sect5[@xml:id=$temp_id]">
                    <xsl:value-of select="//db:sect5[@xml:id=$temp_id]/db:title"/>
                </xsl:when>
                <xsl:when test="//db:sect1[@xml:id=$temp_id]">
                    <xsl:value-of select="//db:sect1[@xml:id=$temp_id]/db:title"/>
                </xsl:when>
                <xsl:when test="//db:listitem[@xml:id=$temp_id]">[<xsl:value-of
                        select="count(//db:listitem[@xml:id=$temp_id])"/>]</xsl:when>
                <xsl:when test="//db:preface[@xml:id=$temp_id]">[Preface]</xsl:when>
                <xsl:when test="//db:section[@xml:id=$temp_id]"> [Section <xsl:number
                        select="//db:section[@xml:id=$temp_id]" format="1." level="multiple"
                        count="child::db:section"/>]</xsl:when>
                <xsl:when test="//db:table[@xml:id=$temp_id]">[Table <xsl:number
                        select="//db:table[@xml:id=$temp_id]" format="1" level="any"
                        count="db:table"/>]</xsl:when>
                <xsl:when test="//db:figure[@xml:id=$temp_id]">[Figure <xsl:number
                        select="//db:figure[@xml:id=$temp_id]" format="1" level="any"
                        count="db:figure"/>]</xsl:when>
                <xsl:when test="//db:example[@xml:id=$temp_id]">[Example <xsl:number
                        select="//db:example[@xml:id=$temp_id]" format="1" level="any"
                        count="db:example"/>]</xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="parent_section">
                        <xsl:call-template name="find_xerf_target_parent_section">
                            <xsl:with-param name="temp_id">
                                <xsl:value-of select="$temp_id"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="//db:section[@xml:id=$parent_section]/db:title"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="find_block_name">
        <xsl:param name="temp_id">section</xsl:param>
        <xsl:choose>
            <xsl:when test="//db:section[@xml:id=$temp_id]">
                <xsl:value-of select="//db:section[@xml:id=$temp_id]/db:title"/>
            </xsl:when>
            <xsl:when test="//db:section/*[@xml:id=$temp_id]">
                <xsl:value-of select="//db:section[*[@xml:id=$temp_id]]/db:title"/>
            </xsl:when>
            <xsl:when test="//db:section/*/*[@xml:id=$temp_id]">
                <xsl:value-of select="//db:section[*/*[@xml:id=$temp_id]]/db:title"/>
            </xsl:when>
            <xsl:when test="//db:section/*/*/*[@xml:id=$temp_id]">
                <xsl:value-of select="//db:section[*/*/*[@xml:id=$temp_id]]/db:title"/>
            </xsl:when>
            <xsl:when test="//db:section/*/*/*/*[@xml:id=$temp_id]">
                <xsl:value-of select="//db:section[*/*/*/*[@xml:id=$temp_id]]/db:title"/>
            </xsl:when>
            <xsl:when test="//db:section/*/*/*/*/*[@xml:id=$temp_id]">
                <xsl:value-of select="//db:section[*/*/*/*/*[@xml:id=$temp_id]]/db:title"/>
            </xsl:when>
            <xsl:when test="//db:section/*/*/*/*/*/*[@xml:id=$temp_id]">
                <xsl:value-of select="//db:section[*/*/*/*/*/*[@xml:id=$temp_id]]/db:title"/>
            </xsl:when>
            <xsl:when test="//db:section/*/*/*/*/*/*/*[@xml:id=$temp_id]">
                <xsl:value-of select="//db:section[*/*/*/*/*/*/*[@xml:id=$temp_id]]/db:title"/>
            </xsl:when>
            <xsl:when test="//db:section/*/*/*/*/*/*/*/*[@xml:id=$temp_id]">
                <xsl:value-of select="//db:section[*/*/*/*/*/*/*/*[@xml:id=$temp_id]]/db:title"/>
            </xsl:when>
            <xsl:when test="//db:section/*/*/*/*/*/*/*/*/*[@xml:id=$temp_id]">
                <xsl:value-of select="//db:section[*/*/*/*/*/*/*/*/*[@xml:id=$temp_id]]/db:title"/>
            </xsl:when>
            <xsl:otherwise>find_xref_target_parent_section_failed.xml_tempID=<xsl:value-of
                    select="$temp_id"/>#</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Find the parent section for  -->

    <xsl:template name="find_xerf_target_parent_section">
        <xsl:param name="temp_id">section</xsl:param>
        <xsl:choose>
            <xsl:when test="//db:section[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:section[*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                    select="//db:section[*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:section/*[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:section[*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                    select="//db:section[*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:preface/*[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:preface[*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                    select="//db:preface[*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:section/*/*[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:section[*/*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                    select="//db:section[*/*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:preface/*/*[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:preface[*/*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                    select="//db:preface[*/*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:section/*/*/*[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:section[*/*/*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                    select="//db:section[*/*/*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:preface/*/*/*[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:preface[*/*/*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                    select="//db:preface[*/*/*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:section/*/*/*/*[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:section[*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                    select="//db:section[*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:preface/*/*/*/*[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:preface[*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                    select="//db:preface[*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:section/*/*/*/*/*[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:section[*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                    select="//db:section[*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:preface/*/*/*/*/*[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:preface[*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                    select="//db:preface[*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:section/*/*/*/*/*/*[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:section[*/*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                    select="//db:section[*/*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:preface/*/*/*/*/*/*[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:preface[*/*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>.xml#<xsl:value-of
                    select="//db:preface[*/*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:section/*/*/*/*/*/*/*[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:section[*/*/*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"
                    />.xml#<xsl:value-of
                    select="//db:section[*/*/*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:preface/*/*/*/*/*/*/*[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:preface[*/*/*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"
                    />.xml#<xsl:value-of
                    select="//db:preface[*/*/*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:section/*/*/*/*/*/*/*/*[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:section[*/*/*/*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"
                    />.xml#<xsl:value-of
                    select="//db:section[*/*/*/*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:preface/*/*/*/*/*/*/*/*[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:preface[*/*/*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"
                    />.xml#<xsl:value-of
                    select="//db:preface[*/*/*/*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"/>__</xsl:when>
            <xsl:when test="//db:section/*/*/*/*/*/*/*/*/*[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:section[*/*/*/*/*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"
                    />.xml#<xsl:value-of
                    select="//db:section[*/*/*/*/*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"
                />__</xsl:when>
            <xsl:when test="//db:preface/*/*/*/*/*/*/*/*/*[@xml:id=$temp_id]"><xsl:value-of
                    select="//db:preface[*/*/*/*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"
                    />.xml#<xsl:value-of
                    select="//db:preface[*/*/*/*/*/*/*/*/*[@xml:id=$temp_id]]/@xml:id"
                />__</xsl:when>
            <xsl:otherwise>find_xref_target_parent_section_failed.xml_tempID=<xsl:value-of
                    select="$temp_id"/>#</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="sanitize_id">
        <xsl:value-of
            select="translate(translate(translate(translate(child::db:title, ':;[]{}~!@#$%^*()?µ\/=ΘΩ≠≥√∑±°&#xA;-.,–‘’-“”&amp;­', '_'), $quot, '_'), $apos, '_'), ' ', '_')"
        />
    </xsl:template>

    <xsl:template name="generate_tablefigureexample_indexentry">
        <xsl:variable name="temp_id">
            <xsl:value-of select="@xml:id"/>
        </xsl:variable>
        <xsl:element name="p">
            <xsl:attribute name="class">- topic/p </xsl:attribute>
            <xsl:element name="indexterm">
                <xsl:attribute name="class">- topic/indexterm </xsl:attribute>
                <xsl:choose>
                    <xsl:when test="//db:procedure[@xml:id=$temp_id]">Procedures</xsl:when>
                    <xsl:when test="//db:table[@xml:id=$temp_id]">Tables</xsl:when>
                    <xsl:when test="//db:figure[@xml:id=$temp_id]">Figures</xsl:when>
                    <xsl:when test="//db:example[@xml:id=$temp_id]">Examples</xsl:when>
                </xsl:choose>
                <xsl:element name="indexterm">
                    <xsl:attribute name="class">- topic/indexterm </xsl:attribute>
                    <xsl:value-of select="//db:info/db:title"/>
                    <xsl:element name="indexterm">
                        <xsl:attribute name="class">- topic/indexterm </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="//db:procedure[@xml:id=$temp_id]">Procedure <xsl:number
                                    select="//db:procedure[@xml:id=$temp_id]" format="001"
                                    level="any" count="db:procedure"/>: <xsl:call-template
                                    name="get_index_topic_title"/></xsl:when>
                            <xsl:when test="//db:table[@xml:id=$temp_id]">Table <xsl:number
                                    select="//db:table[@xml:id=$temp_id]" format="001" level="any"
                                    count="db:table"/>: <xsl:call-template
                                    name="get_index_topic_title"/></xsl:when>
                            <xsl:when test="//db:figure[@xml:id=$temp_id]">Figure <xsl:number
                                    select="//db:figure[@xml:id=$temp_id]" format="001" level="any"
                                    count="db:figure"/>: <xsl:call-template
                                    name="get_index_topic_title"/></xsl:when>
                            <xsl:when test="//db:example[@xml:id=$temp_id]">Example <xsl:number
                                    select="//db:example[@xml:id=$temp_id]" format="001" level="any"
                                    count="db:example"/>: <xsl:call-template
                                    name="get_index_topic_title"/></xsl:when>
                        </xsl:choose>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:procedure/db:title"/>

    <!-- INFO element -->

    <xsl:template match="db:info/db:title">
        <xsl:element name="title">
            <xsl:attribute name="class">- topic/title </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="info_element">
        <table class="- topic/table ">
            <tgroup class="- topic/tgroup " cols="4">
                <colspec class="- topic/colspec " colname="_1"/>
                <colspec class="- topic/colspec " colname="_2" colnum="2"/>
                <colspec class="- topic/colspec " colname="_3"/>
                <colspec class="- topic/colspec " colname="_4"/>
                <tbody class="- topic/tbody ">
                    <row class="- topic/row ">
                        <entry class="- topic/entry ">Title:</entry>
                        <entry class="- topic/entry " nameend="_4" namest="_2">
                            <xsl:value-of select="//db:info/db:title"/>
                        </entry>
                    </row>
                    <row class="- topic/row ">
                        <entry class="- topic/entry ">Abstract:</entry>
                        <entry class="- topic/entry " nameend="_4" namest="_2">
                            <xsl:for-each select="db:abstract/db:para">
                                <xsl:element name="p">
                                    <xsl:attribute name="class">- topic/p </xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:for-each>
                        </entry>
                    </row>
                    <row class="- topic/row ">
                        <entry class="- topic/entry ">Document Type:</entry>
                        <entry class="- topic/entry " nameend="_4" namest="_2">
                            <xsl:value-of select="//db:info/db:pmc_doc_type"/>
                        </entry>
                    </row>
                    <row class="- topic/row ">
                        <entry class="- topic/entry ">Marketing No:</entry>
                        <entry class="- topic/entry ">
                            <xsl:value-of select="//db:info/db:pmc_productnumber"/>
                        </entry>
                        <entry class="- topic/entry ">Doc Issue: </entry>
                        <entry class="- topic/entry ">
                            <xsl:value-of select="db:issuenum"/>
                        </entry>
                    </row>
                    <row class="- topic/row ">
                        <entry class="- topic/entry ">Document No:</entry>
                        <entry class="- topic/entry ">
                            <xsl:value-of select="//db:info/db:pmc_document_id"/>
                        </entry>
                        <entry class="- topic/entry ">Issue Date:</entry>
                        <entry class="- topic/entry ">
                            <xsl:value-of select="//db:info/db:pubdate"/>
                        </entry>
                    </row>
                    <row class="- topic/row ">
                        <entry class="- topic/entry ">Keywords</entry>
                        <entry class="- topic/entry " nameend="_4" namest="_2">
                            <xsl:element name="p">
                                <xsl:attribute name="class">- topic/p </xsl:attribute>
                                <xsl:for-each select="//db:info/db:keywords/db:keywords"
                                        ><xsl:value-of select="."/>, </xsl:for-each>
                            </xsl:element>
                        </entry>
                    </row>
                    <row class="- topic/row ">
                        <entry class="- topic/entry ">Patents</entry>
                        <entry class="- topic/entry " nameend="_4" namest="_2">
                            <xsl:for-each select="//db:info/db:pmc_patents/db:para">
                                <xsl:element name="p">
                                    <xsl:attribute name="class">- topic/p </xsl:attribute>
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:for-each>
                        </entry>
                    </row>
                </tbody>
            </tgroup>
        </table>
    </xsl:template>

    <xsl:template match="@colwidth">
        <xsl:attribute name="colwidth">
            <xsl:value-of select="substring-before(@colwidth, 'in') * 92"/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template name="resource_list">
        <table class="- topic/table ">
            <xsl:attribute name="id"><xsl:value-of select="//db:info/db:pmc_document_id"
                    />v<xsl:value-of select="//db:info/db:issuenum"/>_resources</xsl:attribute>
            <xsl:attribute name="otherprops">A</xsl:attribute>
            <title class="- topic/title ">Resources</title>
            <tgroup class="- topic/tgroup " cols="2">
                <colspec class="- topic/colspec "/>
                <colspec class="- topic/colspec "/>
                <thead class="- topic/thead ">
                    <row class="- topic/row ">
                        <entry class="- topic/entry ">Tables</entry>
                        <entry class="- topic/entry ">Figures</entry>
                    </row>
                </thead>
                <tbody class="- topic/tbody ">
                    <row class="- topic/row ">
                        <entry class="- topic/entry ">
                            <xsl:for-each select="//db:table">
                                <xsl:variable name="temp_id">
                                    <xsl:choose>
                                        <xsl:when test="@xml:id">
                                            <xsl:value-of select="@xml:id"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="generate-id()"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:element name="p">
                                    <xsl:attribute name="class">- topic/p </xsl:attribute>
                                    <xsl:element name="xref">
                                        <xsl:attribute name="class">- topic/xref </xsl:attribute>
                                        <xsl:attribute name="href">
                                            <xsl:call-template
                                                name="find_xerf_target_parent_section">
                                                <xsl:with-param name="temp_id">
                                                  <xsl:value-of select="$temp_id"/>
                                                </xsl:with-param>
                                            </xsl:call-template>
                                            <xsl:value-of select="$temp_id"/>
                                        </xsl:attribute> Table <xsl:number
                                            select="//db:table[@xml:id=$temp_id]" format="1"
                                            level="any" count="db:table"/><xsl:text> </xsl:text>
                                        <xsl:apply-templates
                                            select="//db:table[@xml:id=$temp_id]/db:title"
                                            mode="resource_list"/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </entry>
                        <entry class="- topic/entry ">
                            <xsl:for-each select="//db:figure">
                                <xsl:variable name="temp_id">
                                    <xsl:choose>
                                        <xsl:when test="@xml:id">
                                            <xsl:value-of select="@xml:id"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="generate-id()"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:element name="p">
                                    <xsl:attribute name="class">- topic/p </xsl:attribute>
                                    <xsl:element name="xref">
                                        <xsl:attribute name="class">- topic/xref </xsl:attribute>
                                        <xsl:attribute name="href">
                                            <xsl:call-template
                                                name="find_xerf_target_parent_section">
                                                <xsl:with-param name="temp_id">
                                                  <xsl:value-of select="$temp_id"/>
                                                </xsl:with-param>
                                            </xsl:call-template>
                                            <xsl:value-of select="$temp_id"/>
                                        </xsl:attribute> Figure <xsl:number
                                            select="//db:figure[@xml:id=$temp_id]" format="1"
                                            level="any" count="db:figure"/><xsl:text> </xsl:text>
                                        <xsl:apply-templates
                                            select="//db:figure[@xml:id=$temp_id]/db:title"
                                            mode="resource_list"/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </entry>
                    </row>
                </tbody>
            </tgroup>
        </table>
    </xsl:template>

    <xsl:template name="generate_prolog">
        <xsl:if test="@xml:id">
            <xsl:element name="prolog">
                <xsl:attribute name="class">- topic/prolog </xsl:attribute>
                <xsl:element name="data">
                    <xsl:attribute name="class">- topic/data </xsl:attribute>
                    <xsl:attribute name="type">pdf_name</xsl:attribute>
                    <xsl:attribute name="id">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:attribute>
                </xsl:element>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="db:info/*"/>

    <xsl:template match="db:remark" mode="resource_list"/>

    
</xsl:stylesheet>
