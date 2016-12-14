<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:drb="http://www.dartmouth.edu/~library/catmet/"
    exclude-result-prefixes="xs xd"
    version="2.0">
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Dec 14, 2016</xd:p>
            <xd:p><xd:b>Author:</xd:b> Shaun Akhtar</xd:p>
            
            <xd:p>Generate a version of a MODS record appropriate for deposit
            to the Digital Preservation Network (DPN).</xd:p>
            
            <xd:p>Copyright 2016 Trustees of Dartmouth College</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:strip-space elements="mods:*"/>
    
    <xsl:template match="mods:collection">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="mods:mods">
        <xsl:variable name="filename">
            <xsl:choose>
                <xsl:when test="mods:recordInfo/mods:recordIdentifier[1]">
                    <xsl:value-of select="mods:recordInfo/mods:recordIdentifier[1]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="generate-id()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:result-document href="{$filename}-mods-dpn.xml" indent="yes" encoding="UTF-8">
            <mods:mods xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
                <xsl:attribute name="version" select="@version"/>
                <xsl:apply-templates/>
            </mods:mods>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="@*|*">
        <xsl:copy>
            <xsl:apply-templates select="@*|*|text()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="mods:internetMediaType"/>
    
    <xsl:template match="mods:location[mods:url]"/>
    
    <xsl:template match="drb:flag"/>
    
</xsl:stylesheet>