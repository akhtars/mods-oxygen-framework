<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:mods="http://www.loc.gov/mods/v3" 
    xmlns:saxon="http://saxon.sf.net/"
    exclude-result-prefixes="xs xd saxon"
    version="3.0">
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Apr 10, 2018</xd:p>
            <xd:p><xd:b>Author:</xd:b> Shaun Akhtar</xd:p>
            
            <xd:p>Derives MODS record for print version of resource described
                in input record. Expects input record to include information
                for print manifestation.</xd:p>
            
            <xd:p>Copyright 2018 Trustees of Dartmouth College</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="xml" indent="yes" encoding="UTF-8" saxon:line-length="200"/>
    
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="record-id" select="substring-before(tokenize(base-uri(), '/')[last()], '-mods.xml')"/>
    
    <xsl:template match="mods:mods">
        <xsl:result-document href="{$record-id}-print-mods.xml" indent="yes" encoding="UTF-8">
            <mods:mods xmlns:mods="http://www.loc.gov/mods/v3" 
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
                xmlns:drb="http://www.dartmouth.edu/~library/catmet/"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:cmd="http://www.cdlib.org/inside/diglib/copyrightMD"
                xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd
                http://www.cdlib.org/inside/diglib/copyrightMD http://www.cdlib.org/groups/rmg/docs/copyrightMD.xsd">
                <xsl:attribute name="version" select="@version"/>
                <xsl:apply-templates/>
            </mods:mods>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="mods:physicalDescription">
        <mods:physicalDescription>
            <xsl:copy-of select="../mods:relatedItem[@type='otherFormat']/mods:physicalDescription/*"/>
            <xsl:apply-templates></xsl:apply-templates>
        </mods:physicalDescription>
    </xsl:template>
    
    <xsl:template match="mods:extent">
        <mods:extent>
            <xsl:analyze-string select="." regex="1 online resource \((.+)\)">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </mods:extent>
    </xsl:template>
    
    <xsl:template match="mods:relatedItem[@type='otherFormat']">
        <mods:relatedItem type="otherFormat">
            <mods:physicalDescription>
                <xsl:copy-of select="../mods:physicalDescription/mods:form"/>
            </mods:physicalDescription>
            <mods:recordInfo>
                <xsl:copy-of select="../mods:recordInfo/mods:recordIdentifier[@source='DRB']"/>
            </mods:recordInfo>
        </mods:relatedItem>
    </xsl:template>
    
    <xsl:template match="mods:location">
        <mods:location>
            <xsl:copy-of select="../mods:relatedItem[@type='otherFormat']/mods:location/*"/>
        </mods:location>
    </xsl:template>
    
    <xsl:template match="mods:recordCreationDate[@encoding='w3cdtf']">
        <mods:recordCreationDate encoding="w3cdtf">
            <xsl:value-of select="substring(string(current-date()),1,10)"/>
        </mods:recordCreationDate>
    </xsl:template>
    
    <xsl:template match="mods:recordIdentifier[@source='DRB']">
        <mods:recordIdentifier source="DRB">
            <xsl:value-of select="concat(., '-print')"/>
        </mods:recordIdentifier>
        <mods:recordIdentifier source="DRB">
            <xsl:value-of select="../../mods:relatedItem[@type='otherFormat']/mods:recordInfo/mods:recordIdentifier[@source='DRB']"/>
        </mods:recordIdentifier>
    </xsl:template>
    
    <!-- TODO: Change to mods:recordOrigin -->
    <xsl:template match="mods:recordOrigin">
        <mods:recordOrigin>Derived from MODS record for digital version.</mods:recordOrigin>
    </xsl:template>
    
    <xsl:template match="mods:name[mods:namePart='Dartmouth Digital Library Program']"/>
    
    <xsl:template match="mods:form|mods:internetMediaType|mods:digitalOrigin"/>
    
    <xsl:template match="mods:note[@type='additional physical form']|
        mods:note[.='Made available through the Dartmouth Digital Library.']"/>
    
    <xsl:template match="mods:relatedItem[@type='host']"/>
    
    <xsl:template match="mods:identifier[@type='doi']"/>
    
    <xsl:template match="mods:accessCondition"/>
    
    <xsl:template match="mods:recordChangeDate"/>
    
    <!-- Identity template -->
    <xsl:template match="@*|*">
        <xsl:copy>
            <xsl:apply-templates select="@*|*|text()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>