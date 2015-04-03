<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:mods="http://www.loc.gov/mods/v3"
    exclude-result-prefixes="xs xd"
    version="2.0">
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 20, 2015</xd:p>
            <xd:p><xd:b>Author:</xd:b> Shaun Akhtar</xd:p>
            
            <xd:p>Combines multiple MODS files (each containing one record) into a single file.</xd:p>
            
            <xd:p>Copyright 2015 Trustees of Dartmouth College</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:param name="location" select="."/> <!-- Replaced by ${pdu} in Oxygen parameter configuration -->
    
    <xsl:param name="source" select="collection(concat($location, '?select=*-mods.xml'))"/>
    
    <xsl:template name="collection">
        <xsl:result-document indent="yes" encoding="UTF-8">
            <mods:modsCollection xmlns:mods="http://www.loc.gov/mods/v3"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
                <xsl:for-each select="$source">
                    <xsl:sort select="mods:mods/mods:recordInfo/mods:recordIdentifier"/>
                    <xsl:apply-templates/>
                </xsl:for-each>
            </mods:modsCollection>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="mods:mods">
        <mods:mods>
            <xsl:attribute name="version" select="@version"/>
            <xsl:apply-templates/>
        </mods:mods>
    </xsl:template>
    
    <xsl:template match="@*|*">
        <xsl:copy>
            <xsl:apply-templates select="@*|*|text()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>