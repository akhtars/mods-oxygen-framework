<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:drb="http://www.dartmouth.edu/~library/catmet/"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:cmd="http://www.cdlib.org/inside/diglib/copyrightMD"
    exclude-result-prefixes="xs math xd"
    version="3.0">
    
    <xd:doc scope="stylesheet">
        <xd:desc>Refactoring operation for the Joseph Rainone Early Comic Collection.</xd:desc>
    </xd:doc>
    
    <xsl:output encoding="UTF-8" indent="yes"/>
    
    <xsl:param name="box-number"/>
    
    <xsl:import href="../resources/language-map.xsl"/>
    
    <!-- Identity transformation -->
    <xsl:template match="@*|*|processing-instruction()|comment()" name="identity">
        <xsl:copy>
            <xsl:apply-templates select="@*|*|text()|processing-instruction()|comment()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Update root attributes -->
    <xsl:template match="/mods:mods" >
        <mods:mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:mods="http://www.loc.gov/mods/v3"
            xmlns:drb="http://www.dartmouth.edu/~library/catmet/"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:cmd="http://www.cdlib.org/inside/diglib/copyrightMD"
            version="3.6"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
            <xsl:apply-templates/>
        </mods:mods>
    </xsl:template>
    
    <!-- Combine digital publication dates -->
    <xsl:template match="/mods:mods/mods:originInfo[@eventType = 'publication']">
        <mods:originInfo eventType="publication">
            <xsl:choose>
                <xsl:when test="mods:dateIssued[@encoding = 'w3cdtf'] = mods:dateIssued[@encoding = 'marc']">
                    <xsl:apply-templates select="*[not(self::mods:dateIssued[@encoding = 'marc'])]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </mods:originInfo>
    </xsl:template>
    
    <!-- Add language name -->
    <xsl:template match="/mods:mods/mods:language/mods:languageTerm[@authority = 'iso639-2b']">
        <!--<xsl:if test="not(preceding-sibling::mods:languageTerm[@type = 'text'])">-->
        <xsl:variable name="language-code" select="."/>
            <mods:languageTerm type="text">
                <xsl:value-of select="$language-map($language-code)"/>
            </mods:languageTerm>
        <!--</xsl:if>-->
        <xsl:copy>
            <xsl:apply-templates select="@*|*|text()|processing-instruction()|comment()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Add mods:physicalDescription data -->
    <xsl:template match="/mods:mods/mods:physicalDescription/mods:extent">
        <xsl:choose>
            <xsl:when test=". = '1 online resource'">
                <xsl:variable name="image-count" select="count(/mods:mods/mods:extension/drb:filename[@type='master'])"/>
                <mods:extent>
                    <xsl:text>1 online resource (</xsl:text>
                    <xsl:value-of select="if ($image-count gt 1) 
                        then concat($image-count, ' images') else concat($image-count, ' image')"/>
                    <xsl:text>)</xsl:text>
                </mods:extent>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|*|text()|processing-instruction()|comment()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="not(following-sibling::mods:internetMediaType)">
            <mods:internetMediaType>image/jpeg</mods:internetMediaType>    
        </xsl:if>
        <xsl:if test="not(following-sibling::mods:digitalOrigin)">
            <mods:digitalOrigin>reformatted digital</mods:digitalOrigin>
        </xsl:if>
    </xsl:template>
    
    <!-- Add Public Domain rights statement -->
    <xsl:template match="/mods:mods/mods:location[last()]">
        <xsl:copy>
            <xsl:apply-templates select="@*|*|text()|processing-instruction()|comment()"/>
        </xsl:copy>
        <xsl:if test="not(following-sibling::mods:accessCondition)">
            <mods:accessCondition type="use and reproduction">The organization that has made the material available believes that the material is in the Public Domain under the laws of the United States. No determination was made as to its copyright status under the copyright laws of other countries.</mods:accessCondition>
            <mods:accessCondition type="use and reproduction" displayLabel="Standardized rights statement" xlink:href="http://rightsstatements.org/vocab/NoC-US/1.0/">No Copyright - United States</mods:accessCondition>
            <mods:accessCondition>
                <cmd:copyright copyright.status="pd_expired" publication.status="published"/>
            </mods:accessCondition>
        </xsl:if>
    </xsl:template>
    
    <!-- Add collection resource type -->
    <xsl:template match="/mods:mods/mods:relatedItem[@type='host']/mods:titleInfo">
        <xsl:copy>
            <xsl:apply-templates select="@*|*|text()|processing-instruction()|comment()"/>
        </xsl:copy>
        <xsl:if test="not(following-sibling::mods:typeOfResource)">
            <mods:typeOfResource collection="yes">text</mods:typeOfResource>    
        </xsl:if>
    </xsl:template>
    
    <!-- Add physical location statement -->
    <xsl:template match="/mods:mods/mods:relatedItem[@type='otherFormat']/mods:recordInfo">
        <xsl:if test="not(preceding-sibling::mods:location)">
            <mods:location>
                <mods:holdingSimple>
                    <mods:copyInformation>
                        <mods:shelfLocator>
                            <xsl:text>Rauner Rainone Box </xsl:text>
                            <xsl:value-of select="$box-number"/>
                        </mods:shelfLocator>
                    </mods:copyInformation>
                </mods:holdingSimple>
            </mods:location>
        </xsl:if>
        <xsl:copy>
            <xsl:apply-templates select="@*|*|text()|processing-instruction()|comment()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Update mods:recordChangeDate -->
    <xsl:template match="/mods:mods/mods:recordInfo/mods:recordChangeDate[@encoding='w3cdtf']">
        <mods:recordChangeDate encoding="w3cdtf">
            <xsl:value-of select="substring(xs:string(current-date()), 1, 10)"/>
        </mods:recordChangeDate>
    </xsl:template>
    
    <!-- Remove mods:recordInfoNote derived from print -->
    <xsl:template match="/mods:mods/mods:recordInfo/mods:recordInfoNote"/>
    
</xsl:stylesheet>