<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:output method="xml"
                omit-xml-declaration="yes"
                encoding="UTF-8"
                media-type="application/json"
                indent="no"/>
    <!--
    GSA JSON Output Format

    Dom Sammut 2013

    Output's results from Google Search Appliance in JSON
    
    Replaces/removes the following tags
        * <b> with <strong>
        * <strong>...</strong> with ...
        * <br /> with a single space
        
    Built to support GSA 6.14
    -->

    <!-- Change value to determine if the dynamic navigation will be output -->
    <xsl:variable name="dynamicNavigation" select="true()"/>

    <xsl:template match="/">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="GSP">
        <xsl:text>{</xsl:text><xsl:text>&#xa;</xsl:text>
        <xsl:text>&#x9;</xsl:text>
        <xsl:call-template name="stripTagsEscapeCharacters">
            <xsl:with-param name="orig_string" select="local-name()"/>
        </xsl:call-template>
        <xsl:text>:{</xsl:text>
        <xsl:for-each select="@*">
            <xsl:text>&#xa;</xsl:text><xsl:text>&#x9;&#x9;</xsl:text>
            <xsl:call-template name="stripTagsEscapeCharacters">
                <xsl:with-param name="orig_string" select="local-name()"/>
            </xsl:call-template>
            <xsl:text>:</xsl:text>
            <xsl:call-template name="stripTagsEscapeCharacters">
                <xsl:with-param name="orig_string" select="."/>
            </xsl:call-template>
            <xsl:text>,</xsl:text>
        </xsl:for-each>
        <xsl:apply-templates />
        <xsl:text>&#x9;}&#xa;</xsl:text>
        <xsl:text>}</xsl:text>
    </xsl:template>

    <xsl:template match="TM | Q | GL | GD ">
        <xsl:if test="child::node()">
            <xsl:call-template name="jsonFormat"/>
            <xsl:call-template name="stripTagsEscapeCharacters">
                <xsl:with-param name="orig_string" select="local-name()"/>
            </xsl:call-template>
            <xsl:text>:</xsl:text>
            <xsl:call-template name="stripTagsEscapeCharacters">
                <xsl:with-param name="orig_string" select="."/>
            </xsl:call-template>
            <xsl:if test="following-sibling::*">
                <xsl:text>,</xsl:text>
                <xsl:if test="not(following-sibling::*[1]/self::PARAM)">
                    <xsl:text>&#xa;</xsl:text>
                </xsl:if>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template match="PARAM">
        <xsl:call-template name="jsonFormat"/>
        <xsl:text>"PARAM": {</xsl:text>
        <xsl:for-each select="@*">
            <xsl:text>&#xa;</xsl:text>
            <xsl:call-template name="jsonFormat"/>
            <xsl:call-template name="stripTagsEscapeCharacters">
                <xsl:with-param name="orig_string" select="local-name()"/>
            </xsl:call-template>
            <xsl:text>:</xsl:text>
            <xsl:call-template name="stripTagsEscapeCharacters">
                <xsl:with-param name="orig_string" select="."/>
            </xsl:call-template>
            <xsl:if test="position() != last()">,</xsl:if>
        </xsl:for-each>
        <xsl:text>&#xa;</xsl:text>
        <xsl:call-template name="jsonFormat"/>
        <xsl:text>}</xsl:text>
        <xsl:if test="./following-sibling::*">
            <xsl:text>,</xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- Match elements that might contain attributes -->
    <xsl:template match="RES | R | GM | NB | HAS | C | MT | PARM">
        <xsl:call-template name="jsonFormat"/>
        <xsl:call-template name="stripTagsEscapeCharacters">
            <xsl:with-param name="orig_string" select="local-name()"/>
        </xsl:call-template>
        <xsl:text>:{</xsl:text><xsl:text>&#xa;</xsl:text>
        <xsl:for-each select="@*">
            <xsl:call-template name="jsonFormat"/>
            <xsl:call-template name="stripTagsEscapeCharacters">
                <xsl:with-param name="orig_string" select="local-name()"/>
            </xsl:call-template>
            <xsl:text>:</xsl:text>
            <xsl:call-template name="stripTagsEscapeCharacters">
                <xsl:with-param name="orig_string" select="."/>
            </xsl:call-template>
            <xsl:if test="position() != last()">,<xsl:text>&#xa;</xsl:text></xsl:if>
        </xsl:for-each>
        <xsl:if test="count(@*) &gt; 0 and child::node()">,&#xa;</xsl:if>

        <xsl:apply-templates />
        <xsl:text>&#xa;</xsl:text>
        <xsl:call-template name="jsonFormat"/>
        <xsl:text>}</xsl:text>
        <xsl:choose>
            <xsl:when test="$dynamicNavigation = true()">
                <xsl:if test="(count(./following-sibling::*) &gt; 0) and (name(./following-sibling::*[1]) != 'SECURITY_TOKEN')">
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="(count(./following-sibling::*) &gt; 1)">
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <!-- Match elements that don't contain attributes -->
    <xsl:template match="M | FI | U | UE | T | RK | S | LANG | L | HN | NU | RK | PC ">

        <xsl:call-template name="jsonFormat"/>
        <xsl:call-template name="stripTagsEscapeCharacters">
            <xsl:with-param name="orig_string" select="local-name()"/>
        </xsl:call-template>
        <xsl:text>:</xsl:text>
        <xsl:call-template name="stripTagsEscapeCharacters">
            <xsl:with-param name="orig_string" select="."/>
        </xsl:call-template>
        <xsl:if test="./following-sibling::*">
            <xsl:text>,</xsl:text>
            <xsl:text>&#xa;</xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- Dynamic Navigation -->
    <xsl:template match="PV | PMT">
        <xsl:if test="$dynamicNavigation = true()">
            <xsl:call-template name="jsonFormat"/>
            <xsl:call-template name="stripTagsEscapeCharacters">
                <xsl:with-param name="orig_string" select="local-name()"/>
            </xsl:call-template>
            <xsl:text>:{</xsl:text><xsl:text>&#xa;</xsl:text>

            <!-- Output each attribute -->

            <xsl:for-each select="@*">
                <xsl:call-template name="jsonFormat"/>
                <xsl:call-template name="stripTagsEscapeCharacters">
                    <xsl:with-param name="orig_string" select="local-name()"/>
                </xsl:call-template>
                <xsl:text>:</xsl:text>
                <xsl:call-template name="stripTagsEscapeCharacters">
                    <xsl:with-param name="orig_string" select="."/>
                </xsl:call-template>
                <xsl:if test="position() != last()">
                    <xsl:text>,</xsl:text>
                </xsl:if>
                <xsl:text>&#xa;</xsl:text>
            </xsl:for-each>

            <xsl:if test="count(@*) &gt; 0 and child::node()">,&#xa;</xsl:if>

            <xsl:apply-templates />
            <xsl:call-template name="jsonFormat"/>
            <xsl:text>}</xsl:text>
            <xsl:if test="(count(./following-sibling::*) &gt;= 1)">
                <xsl:text>,</xsl:text>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="escape-string">
        <xsl:param name="s"/>
        <xsl:choose>
            <xsl:when test="string-length($s) > 0">
                <xsl:text>"</xsl:text>
                <xsl:call-template name="escape-bs-string">
                    <xsl:with-param name="s" select="$s"/>
                </xsl:call-template>
                <xsl:text>"</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>null</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Escape the backslash (\) before everything else. -->
    <xsl:template name="escape-bs-string">
        <xsl:param name="s"/>
        <xsl:choose>
            <xsl:when test="contains($s,'\')">
                <xsl:call-template name="escape-quot-string">
                    <xsl:with-param name="s" select="concat(substring-before($s,'\'),'\\')"/>
                </xsl:call-template>
                <xsl:call-template name="escape-bs-string">
                    <xsl:with-param name="s" select="substring-after($s,'\')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="escape-quot-string">
                    <xsl:with-param name="s" select="$s"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Escape the double quote ("). -->
    <xsl:template name="escape-quot-string">
        <xsl:param name="s"/>
        <xsl:choose>
            <xsl:when test="contains($s,'&quot;')">
                <xsl:call-template name="encode-string">
                    <xsl:with-param name="s" select="concat(substring-before($s,'&quot;'),'\&quot;')"/>
                </xsl:call-template>
                <xsl:call-template name="escape-quot-string">
                    <xsl:with-param name="s" select="substring-after($s,'&quot;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="encode-string">
                    <xsl:with-param name="s" select="$s"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Replace tab, line feed and/or carriage return by its matching escape code.-->
    <xsl:template name="encode-string">
        <xsl:param name="s"/>
        <xsl:choose>
            <!-- tab -->
            <xsl:when test="contains($s,'&#x9;')">
                <xsl:call-template name="encode-string">
                    <xsl:with-param name="s" select="concat(substring-before($s,'&#x9;'),'\t',substring-after($s,'&#x9;'))"/>
                </xsl:call-template>
            </xsl:when>
            <!-- line feed -->
            <xsl:when test="contains($s,'&#xA;')">
                <xsl:call-template name="encode-string">
                    <xsl:with-param name="s" select="concat(substring-before($s,'&#xA;'),'\n',substring-after($s,'&#xA;'))"/>
                </xsl:call-template>
            </xsl:when>
            <!-- carriage return -->
            <xsl:when test="contains($s,'&#xD;')">
                <xsl:call-template name="encode-string">
                    <xsl:with-param name="s" select="concat(substring-before($s,'&#xD;'),'\r',substring-after($s,'&#xD;'))"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$s"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Clean up the results / Expanded from the GSA Default XSL -->

    <xsl:variable name="res_keyword_format">strong</xsl:variable>
    <xsl:variable name="keyword_orig_start" select="'&lt;b&gt;'"/>
    <xsl:variable name="keyword_orig_end" select="'&lt;/b&gt;'"/>
    <xsl:variable name="keyword_reformat_start">
        <xsl:if test="$res_keyword_format">
            <xsl:text>&lt;</xsl:text>
            <xsl:value-of select="$res_keyword_format"/>
            <xsl:text>&gt;</xsl:text>
        </xsl:if>
    </xsl:variable>

    <xsl:variable name="keyword_reformat_end">
        <xsl:if test="$res_keyword_format">
            <xsl:text>&lt;/</xsl:text>
            <xsl:value-of select="$res_keyword_format"/>
            <xsl:text>&gt;</xsl:text>
        </xsl:if>
    </xsl:variable>

    <xsl:template name="stripTagsEscapeCharacters">
        <xsl:param name="orig_string"/>

        <xsl:variable name="reformatted_1">
            <xsl:call-template name="replace_string">
                <xsl:with-param name="find" select="'&lt;b&gt;'"/>
                <xsl:with-param name="replace" select="$keyword_reformat_start"/>
                <xsl:with-param name="string" select="$orig_string"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="reformatted_2">
            <xsl:call-template name="replace_string">
                <xsl:with-param name="find" select="'&lt;/b&gt;'"/>
                <xsl:with-param name="replace" select="$keyword_reformat_end"/>
                <xsl:with-param name="string" select="$reformatted_1"/>
            </xsl:call-template>
        </xsl:variable>

        <!-- Remove <br/> tags, let's leave the formatting to css -->

        <xsl:variable name="reformatted_3">
            <xsl:call-template name="replace_string">
                <xsl:with-param name="find" select="'&lt;br&gt;'"/>
                <xsl:with-param name="replace" select="''"/>
                <xsl:with-param name="string" select="$reformatted_2"/>
            </xsl:call-template>
        </xsl:variable>

        <!-- Remove strong of ... no need for it.-->

        <xsl:variable name="reformatted_4">
            <xsl:call-template name="replace_string">
                <xsl:with-param name="find" select="'&lt;strong&gt;...&lt;/strong&gt;'"/>
                <xsl:with-param name="replace" select="'...'"/>
                <xsl:with-param name="string" select="$reformatted_3"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:call-template name="escape-string">
            <xsl:with-param name="s" select="$reformatted_4"/>
        </xsl:call-template>

    </xsl:template>

    <!-- Used to set the tab spacing for the output, makes it pretty -->
    <xsl:template name="jsonFormat">
        <xsl:choose>
            <xsl:when test="count(ancestor::*) = 1">
                <xsl:text>&#x9;&#x9;</xsl:text>
            </xsl:when>
            <xsl:when test="count(ancestor::*) = 2">
                <xsl:text>&#x9;&#x9;&#x9;</xsl:text>
            </xsl:when>
            <xsl:when test="count(ancestor::*) = 3">
                <xsl:text>&#x9;&#x9;&#x9;&#x9;</xsl:text>
            </xsl:when>
            <xsl:when test="count(ancestor::*) = 4">
                <xsl:text>&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
            </xsl:when>
            <xsl:when test="count(ancestor::*) = 5">
                <xsl:text>&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
            </xsl:when>
            <xsl:when test="count(ancestor::*) = 6">
                <xsl:text>&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
            </xsl:when>
            <xsl:when test="count(ancestor::*) = 7">
                <xsl:text>&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Find and replace / Borrowed from the GSA Default XSL -->
    <xsl:template name="replace_string">
        <xsl:param name="find"/>
        <xsl:param name="replace"/>
        <xsl:param name="string"/>
        <xsl:choose>
            <xsl:when test="contains($string, $find)">
                <xsl:value-of select="substring-before($string, $find)"/>
                <xsl:value-of select="$replace"/>
                <xsl:call-template name="replace_string">
                    <xsl:with-param name="find" select="$find"/>
                    <xsl:with-param name="replace" select="$replace"/>
                    <xsl:with-param name="string" select="substring-after($string, $find)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$string"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*"/>

</xsl:stylesheet>