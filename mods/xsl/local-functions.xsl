<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:lfn="localfunctions"
    exclude-result-prefixes="xs xd lfn"
    version="2.0">
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jun 19, 2014</xd:p>
            <xd:p><xd:b>Author:</xd:b> Shaun Akhtar</xd:p>
            
            <xd:p>Local functions for use in MODS record transformations</xd:p>
            
            <xd:p>Copyright 2014 Trustees of Dartmouth College</xd:p>
        </xd:desc>
    </xd:doc>
    
    <!-- DATES -->
    
    <xd:doc>
        <xd:desc>Returns current date in YYYY-MM-DD format.</xd:desc>
    </xd:doc>
    <xsl:function name="lfn:current-date" as="xs:date">
        <xsl:sequence select="xs:date(substring(string(current-date()),1,10))"/>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>Convert dates from MM-DD-YY format (used in 005 field of MARC records) to YYYY-MM-DD format.</xd:desc>
    </xd:doc>
    <xsl:function name="lfn:date_005-to-W3C" as="xs:date">
        <xsl:param name="input-date"/>
        <xsl:variable name="month" select="substring($input-date,1,2)"/>
        <xsl:variable name="day" select="substring($input-date,4,2)"/>
        <xsl:variable name="year">
            <xsl:choose>
                <xsl:when test="number(substring($input-date,7,2)) &gt; number(substring(string(current-date()),3,2))">
                    <xsl:value-of select="concat('19',substring($input-date,7,2))"></xsl:value-of>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('20',substring($input-date,7,2))"></xsl:value-of>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:sequence select="xs:date(string-join(($year, $month, $day), '-'))"/>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>Convert dates from MARC formats to YYYY-MM-DD format.</xd:desc>
    </xd:doc>
    <xsl:function name="lfn:date_MARC-to-W3C" as="xs:date">
        <xsl:param name="input-date"/>
        <xsl:if test="string-length($input-date) = 6">
            <xsl:variable name="year">
                <xsl:choose>
                    <xsl:when test="number(substring($input-date,1,2)) &gt; number(substring(string(current-date()),3,2))">
                        <xsl:value-of select="concat('19',substring($input-date,1,2))"></xsl:value-of>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('20',substring($input-date,1,2))"></xsl:value-of>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="month" select="substring($input-date,3,2)"/>
            <xsl:variable name="day" select="substring($input-date,5,2)"/>
            <xsl:sequence select="xs:date(string-join(($year, $month, $day), '-'))"/>
        </xsl:if>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>Convert dates from MM/DD/YYYY format to YYYY-MM-DD format.</xd:desc>
    </xd:doc>
    <xsl:function name="lfn:date_US-to-W3C" as="xs:date">
        <xsl:param name="input-date"/>
        <xsl:sequence select="xs:date(string-join((tokenize($input-date,'/')[3], tokenize($input-date,'/')[1], tokenize($input-date,'/')[2]),'-'))"/>
    </xsl:function>
    
    <!-- SUBJECTS -->
    
    <xd:doc>
        <xd:desc>Split coordinated LCSH subject headings on " -- " into multiple mods:topic fields.</xd:desc>
    </xd:doc>
    <xsl:function name="lfn:sub-topic-split" as="xs:string">
        <xsl:param name="input-string"/>
        <xsl:sequence select="tokenize($input-string, '( -- )')"/>
    </xsl:function>
    
    <!-- NUMERIC -->
    
    <xd:doc>
        <xd:desc>Pad the string given as the first argument with zeroes until it is the length specified in the second argument. If it is already at least the length of the second argument, return the original string.</xd:desc>
    </xd:doc>
    <xsl:function name="lfn:pad-zeroes" as="xs:string">
        <xsl:param name="input-string"/>
        <xsl:param name="total-length" as="xs:integer"/>
        <xsl:choose>
            <xsl:when test="string-length($input-string) >= $total-length">
                <xsl:value-of select="$input-string"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="new-string" select="concat('0', $input-string)"/>
                <xsl:value-of select="lfn:pad-zeroes($new-string, $total-length)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
</xsl:stylesheet>