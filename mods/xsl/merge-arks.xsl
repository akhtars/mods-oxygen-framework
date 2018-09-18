<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:saxon="http://saxon.sf.net/"
    xmlns:lfn="localfunctions"
    exclude-result-prefixes="xs xd saxon lfn"
    version="2.0">
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> June 14, 2018</xd:p>
            <xd:p><xd:b>Author:</xd:b> Shaun Akhtar</xd:p>
            
            <xd:p>
                Adds an ARK identifier to existing MODS record from input text
                file containing log of operations against the EZID API. Merges
                based on the unique record identifier. Creates mods:identifier
                with @type="ark" containing the ARK. Updates the datestamp in
                mods:recordChangeDate with @encoding="w3cdtf". Output record
                written to "merged-arks" subdirectory.
            </xd:p>
            
            <xd:p>Copyright 2018 Trustees of Dartmouth College</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:param name="location" select="."/> <!-- Replaced by ${cfdu} in Oxygen parameter configuration -->
    
    <xsl:param name="arks-file" select="unparsed-text(concat($location, '/arks.txt'))"/>
    
    <xsl:output method="xml" indent="yes" encoding="UTF-8" saxon:line-length="200"/>
    
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="filename" select="tokenize(base-uri(), '/')[last()]"/>
    
    <xsl:variable name="record-id" select="mods:mods/mods:recordInfo/mods:recordIdentifier[@source='DRB']"/>
    
    <!-- Create merged record in child directory if record identifier is found in ARK data file -->
    <xsl:template match="mods:mods">
        <xsl:if test="contains($arks-file, concat($record-id, '-ezid.txt'))">
            <xsl:result-document href="merged-arks\{$filename}" method="xml" indent="yes">
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:result-document>
        </xsl:if>
    </xsl:template>
    
    <!-- Identity transformation -->
    <xsl:template match="@*|*|processing-instruction()|comment()" name="identity">
        <xsl:copy>
            <xsl:apply-templates select="@*|*|text()|processing-instruction()|comment()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Add ARK -->
    <xsl:template match="mods:recordInfo">
        <xsl:param name="search-string" select="concat($record-id, '-ezid.txt (ark:/83024/[A-Za-z0-9]+)')" as="xs:string"/>
        <xsl:analyze-string select="$arks-file" regex="{$search-string}">
            <xsl:matching-substring>
                <mods:identifier type="ark">
                    <xsl:value-of select="concat('https://n2t.net/', regex-group(1))"/>
                </mods:identifier>
            </xsl:matching-substring>
        </xsl:analyze-string>
        <!-- Use existing MODS element as anchor for positioning new element -->
        <mods:recordInfo>
            <xsl:apply-templates/>
        </mods:recordInfo>
    </xsl:template>
    
    <xsl:template match="mods:recordChangeDate[@encoding='w3cdtf']">
        <mods:recordChangeDate encoding="w3cdtf">
            <xsl:value-of select="substring(xs:string(current-date()), 1, 10)"/>
        </mods:recordChangeDate>
    </xsl:template>
    
</xsl:stylesheet>