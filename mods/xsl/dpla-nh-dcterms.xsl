<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
   xmlns:mods="http://www.loc.gov/mods/v3"
   xmlns:drb="http://www.dartmouth.edu/~library/catmet/" 
   xmlns:xlink="http://www.w3.org/1999/xlink"
   xmlns:oai_qdc="http://worldcat.org/xmlschemas/qdc-1.0/" 
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:dcterms="http://purl.org/dc/terms/"
   xmlns:edm="http://www.europeana.eu/schemas/edm/"
   xmlns:cmd="http://www.cdlib.org/inside/diglib/copyrightMD"
   exclude-result-prefixes="xs xd xlink mods drb cmd" version="2.0">

   <xd:doc scope="stylesheet">
      <xd:desc>
         <xd:p><xd:b>Created on:</xd:b> May 25, 2018</xd:p>
         <xd:p><xd:b>Author:</xd:b> Shaun Akhtar</xd:p>

         <xd:p>Transforms MODS record into DCTERMS record for harvesting to
            New Hampshire service hub for Digital Public Library of America.</xd:p>

         <xd:p>Some templates adapted from LC MODS-to-MARCXML transformation.</xd:p>

         <xd:p>Relevant resources:</xd:p>

         <xd:ul>
            <xd:li>DPLA Metadata Quality Guidelines: http://bit.ly/dpla-metadata-qual</xd:li>
            <xd:li>DPLA Partners Crosswalk, MAP v4.0: http://bit.ly/dpla-MAP4-crosswalk</xd:li>
            <xd:li>DPLA Metadata Application Profile, version 5.0: http://dp.la/info/map</xd:li>
            <xd:li>NH Digital Library Metadata Standards: https://github.com/NewHampshireDigitalLibrary/metadata-standards</xd:li>
            <xd:li>DCMI Metadata Terms: http://dublincore.org/documents/dcmi-terms/</xd:li>
            <xd:li>Guidelines for implementing Dublin Core in XML: http://dublincore.org/documents/dc-xml-guidelines/</xd:li>
         </xd:ul>

         <xd:p>Copyright 2018 Trustees of Dartmouth College</xd:p>
      </xd:desc>
   </xd:doc>

   <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

   <xsl:strip-space elements="*"/>

   <xsl:template match="/">
      <xsl:result-document>
         <xsl:apply-templates/>
      </xsl:result-document>
   </xsl:template>

   <xsl:template match="mods:mods">
      <oai_qdc:qualifieddc>
         <xsl:apply-templates/>
      </oai_qdc:qualifieddc>
   </xsl:template>

   <xsl:template match="*"/>

   <xsl:template match="mods:titleInfo[not(ancestor-or-self::mods:subject)][not(@type)]">
      <dcterms:title>
         <xsl:call-template name="title"/>
      </dcterms:title>
   </xsl:template>

   <xsl:template match="mods:titleInfo[@type]">
      <dcterms:alternative>
         <xsl:call-template name="title"/>
      </dcterms:alternative>
   </xsl:template>

   <xsl:template match="mods:name[@usage = 'primary']">
      <dcterms:creator>
         <xsl:call-template name="name"/>
      </dcterms:creator>
   </xsl:template>

   <xsl:template match="mods:name[not(@usage)][not(mods:role/mods:roleTerm = 'repository')]">
      <dcterms:contributor>
         <xsl:call-template name="name"/>
      </dcterms:contributor>
   </xsl:template>

   <xsl:template match="mods:genre[@authority = 'rdacontent']">
      <dcterms:type>
         <xsl:choose>
            <xsl:when test=". = 'cartographic image'">StillImage</xsl:when>
            <xsl:when test=". = 'performed music'">Sound</xsl:when>
            <xsl:when test=". = 'sounds'">Sound</xsl:when>
            <xsl:when test=". = 'spoken word'">Sound</xsl:when>
            <xsl:when test=". = 'still image'">StillImage</xsl:when>
            <xsl:when test=". = 'text'">Text</xsl:when>
            <xsl:when test=". = 'two-dimensional moving image'">MovingImage</xsl:when>
            <xsl:when test=". = 'three-dimensional moving image'">MovingImage</xsl:when>
         </xsl:choose>
      </dcterms:type>
   </xsl:template>

   <xsl:template match="mods:originInfo[not(following-sibling::mods:relatedItem[@type = ('original', 'otherFormat')])]">
      <dc:date>
         <xsl:for-each select="mods:dateIssued[@encoding = ('w3cdtf', 'marc')][not(@point = 'end')]">
            <xsl:value-of select="substring(., 1, 4)"/>
            <xsl:if test="@qualifier = 'questionable'">?</xsl:if>
            <xsl:if test="mods:dateIssued[@point = 'end']">
               <xsl:text>-</xsl:text>
               <xsl:value-of select="../mods:dateIssued[@point = 'end']"/>
            </xsl:if>
         </xsl:for-each>
      </dc:date>
   </xsl:template>

   <xsl:template match="mods:language">
      <xsl:for-each select="mods:languageTerm[@authority = 'iso639-2b']">
         <dcterms:language>
            <xsl:apply-templates/>
         </dcterms:language>
      </xsl:for-each>
   </xsl:template>
   
   <xsl:template match="mods:genre[@authority = 'aat']">
      <edm:hasType>
         <xsl:apply-templates/>
      </edm:hasType>
   </xsl:template>
   
   <xsl:template match="mods:genre[parent::mods:mods][not(@authority = ('rdacontent', 'aat', 'local'))]">
      <dc:format>
         <xsl:apply-templates/>
      </dc:format>
   </xsl:template>

   <xsl:template match="mods:physicalDescription">
      <xsl:apply-templates/>
   </xsl:template>
   
   <xsl:template match="mods:internetMediaType">
      <dc:format>
         <xsl:apply-templates/>
      </dc:format>
   </xsl:template>

   <xsl:template match="mods:extent">
      <dcterms:extent>
         <xsl:apply-templates/>
      </dcterms:extent>
   </xsl:template>

   <xsl:template
      match="
         mods:abstract | mods:tableOfContents | mods:note[parent::mods:mods]
         [not(@type = ('statement of responsibility', 'bibliography', 'additional physical form', 'funding'))]">
      <dcterms:description>
         <xsl:apply-templates/>
      </dcterms:description>
   </xsl:template>

   <xsl:template match="mods:subject">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="mods:subject[@authority = 'lcsh'][not(../mods:subject[@authority = 'fast'])]">
      <dcterms:subject>
         <xsl:for-each select="mods:name">
            <xsl:call-template name="name"/>
            <xsl:if test="following-sibling::*">
               <xsl:text> -- </xsl:text>
            </xsl:if>
         </xsl:for-each>
         <xsl:value-of select="string-join(*[not(ancestor-or-self::mods:name)], ' -- ')"/>
      </dcterms:subject>
   </xsl:template>

   <xsl:template match="mods:subject[@authority = 'fast'][not(*[1][local-name() = 'temporal'])]">
      <dcterms:subject>
         <xsl:value-of select="string-join(*, ' -- ')"/>
      </dcterms:subject>
   </xsl:template>

   <xsl:template match="mods:subject[@authority = 'fast'][*[1][local-name() = 'temporal']]">
      <dcterms:temporal>
         <xsl:value-of select="string-join(*, ' -- ')"/>
      </dcterms:temporal>
   </xsl:template>

   <xsl:template match="mods:hierarchicalGeographic">
      <dcterms:spatial>
         <xsl:value-of select="string-join(reverse(*[not(. = 'United States')]), ', ')"/>
      </dcterms:spatial>
   </xsl:template>

   <xsl:template match="mods:cartographics">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="mods:scale">
      <dcterms:description>
         <xsl:text>Scale: </xsl:text>
         <xsl:apply-templates/>
      </dcterms:description>
   </xsl:template>

   <xsl:template match="mods:relatedItem[@type = ('original', 'otherFormat')]">
      <xsl:apply-templates mode="otherFormat"/>
   </xsl:template>

   <xsl:template match="mods:originInfo" mode="otherFormat">
      <xsl:for-each select="*[contains(local-name(.), 'date')][@encoding = ('w3cdtf', 'marc')][not(@point = 'end')]">
         <dc:date>
            <xsl:value-of select="substring(., 1, 4)"/>
            <xsl:if test="@qualifier = 'questionable'">?</xsl:if>
            <xsl:if test="following-sibling::*[@point = 'end']">
               <xsl:text>-</xsl:text>
               <xsl:value-of select="following-sibling::*[@point = 'end']"/>
            </xsl:if>
         </dc:date>
      </xsl:for-each>
      <xsl:if test="mods:publisher">
         <dcterms:publisher>
            <xsl:value-of select="mods:publisher"/>
         </dcterms:publisher>
      </xsl:if>
   </xsl:template>

   <xsl:template match="*" mode="otherFormat"/>

   <xsl:template match="mods:relatedItem[@type = 'host']">
      <xsl:apply-templates mode="host"/>
   </xsl:template>

   <xsl:template match="mods:titleInfo" mode="host">
      <dcterms:isPartOf>
         <xsl:call-template name="title"/>
      </dcterms:isPartOf>
   </xsl:template>

   <xsl:template match="*" mode="host"/>

   <xsl:template match="mods:identifier[@type = ('doi', 'ark')][parent::mods:mods]">
      <edm:isShownAt>
         <xsl:apply-templates/>
      </edm:isShownAt>
   </xsl:template>

   <xsl:template match="mods:location">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="mods:url[not(../../mods:identifier[@type = ('doi', 'ark')])][@usage = 'primary']">
      <edm:isShownAt>
         <xsl:apply-templates/>
      </edm:isShownAt>
   </xsl:template>

   <xsl:template match="mods:url[@access = 'preview']">
      <edm:preview>
         <xsl:apply-templates/>
      </edm:preview>
   </xsl:template>

   <xsl:template match="mods:accessCondition[@displayLabel = 'Standardized rights statement']">
      <edm:rights>
         <xsl:value-of select="@xlink:href"/>
      </edm:rights>
   </xsl:template>
   
   <xsl:template match="mods:accessCondition[cmd:copyright/cmd:rights.holder/cmd:name]">
      <dcterms:rightsHolder>
         <xsl:value-of select="cmd:copyright/cmd:rights.holder/cmd:name"/>
      </dcterms:rightsHolder>
   </xsl:template>

   <xsl:template match="mods:recordInfo[parent::mods:mods]">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="mods:recordIdentifier[@source = 'DRB']">
      <dcterms:identifier>
         <xsl:apply-templates/>
      </dcterms:identifier>
      <edm:dataProvider>Dartmouth College Library</edm:dataProvider>
      <edm:provider>New Hampshire Digital Library</edm:provider>
   </xsl:template>

   <xsl:template name="title">
      <xsl:value-of select="mods:nonSort"/>
      <xsl:value-of select="mods:title"/>
      <xsl:if test="mods:subTitle">
         <xsl:text>: </xsl:text>
         <xsl:value-of select="mods:subTitle"/>
      </xsl:if>
      <xsl:for-each select="mods:partNumber">
         <xsl:text>. </xsl:text>
         <xsl:value-of select="."/>
      </xsl:for-each>
      <xsl:for-each select="mods:partName">
         <xsl:choose>
            <xsl:when test="preceding-sibling::mods:partNumber">
               <xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>. </xsl:text>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:value-of select="."/>
      </xsl:for-each>
   </xsl:template>

   <xsl:template name="name">
      <xsl:choose>
         <xsl:when test="@type = 'personal'">
            <xsl:variable name="separator">
               <xsl:choose>
                  <xsl:when test="@lang = 'chi'">
                     <xsl:text/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:text>, </xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <xsl:value-of select="string-join(mods:description | mods:termsOfAddress | mods:namePart[not(@type = 'given'[2])], $separator)"/>
            <xsl:for-each select="mods:namePart[@type = 'given'[2]]">
               <xsl:choose>
                  <xsl:when test="starts-with(., '(')">
                     <xsl:value-of select="."/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="concat('(', ., ')')"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:for-each>
         </xsl:when>
         <xsl:when test="@type = ('corporate', 'conference')">
            <xsl:value-of select="string-join(mods:description | mods:namePart, '. ')"/>
         </xsl:when>
      </xsl:choose>
      <xsl:if test="following-sibling::mods:name[1][mods:etal]">
         <xsl:text>, </xsl:text>
         <xsl:value-of select="following-sibling::mods:name[1]/mods:etal"/>
      </xsl:if>
      <xsl:if test="mods:role/mods:roleTerm[@type = 'text']">
         <xsl:text>, </xsl:text>
         <xsl:value-of select="string-join(mods:role/mods:roleTerm[@type = 'text'], ', ')"/>
      </xsl:if>
   </xsl:template>

</xsl:stylesheet>
