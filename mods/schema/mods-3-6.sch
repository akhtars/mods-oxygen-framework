<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mods="http://www.loc.gov/mods/v3">

    <!-- Implements local restrictions on Dartmouth College Library-created MODS records. -->
    
    <!-- "Level 1", etc. indicate specific enforcement of the DLF Aquifer MODS Guidelines Levels of Adoption
        https://wiki.dlib.indiana.edu/display/DLFAquifer/MODS+Guidelines+Levels+of+Adoption -->

    <title>Dartmouth College Library MODS Implementation</title>
    <ns uri="http://www.loc.gov/mods/v3" prefix="mods"/>
    <ns uri="http://www.dartmouth.edu/~library/catmet/" prefix="drb"/>
    
    <!-- RECORD STRUCTURE -->

    <!-- Top-level elements -->
    
    <pattern>
        <rule context="mods:mods">
            <assert test="not(in-scope-prefixes(.) = '')">
                No unprefixed namespaces should be present. [<name path=".."/>/<name/>]
            </assert>
        </rule>
    </pattern>

    <pattern>
        
        <!-- Digital Library Program materials -->
        
        <rule context="mods:mods[mods:extension/drb:flag[@type='program'][@value='ddlp']]">
            
            <assert test="mods:titleInfo" sqf:fix="titleInfo">
                The record should have mods:titleInfo.
            </assert>
            <sqf:fix id="titleInfo">
                <sqf:description>
                    <sqf:title>Add mods:titleInfo</sqf:title>
                </sqf:description>
                <sqf:add>
                    <xsl:text>
   </xsl:text><mods:titleInfo><xsl:text>
      </xsl:text><xsl:text>
   </xsl:text></mods:titleInfo>
                </sqf:add>
            </sqf:fix>
            
            <assert test="mods:typeOfResource" sqf:fix="typeOfResource">
                The record should have mods:typeOfResource.
            </assert>
            <sqf:fix id="typeOfResource">
                <sqf:description>
                    <sqf:title>Add mods:typeOfResource</sqf:title>
                </sqf:description>
                <sqf:add match="mods:titleInfo" position="after">
                    <xsl:text>
   </xsl:text><mods:typeOfResource></mods:typeOfResource>
                </sqf:add>
            </sqf:fix>
            
            <assert test="mods:genre" sqf:fix="genre">
                The record should have mods:genre.
            </assert>
            <sqf:fix id="genre">
                <sqf:description>
                    <sqf:title>Add mods:genre</sqf:title>
                </sqf:description>
                <sqf:add match="mods:typeOfResource" position="after">
                    <xsl:text>
   </xsl:text><mods:genre></mods:genre>
                </sqf:add>
            </sqf:fix>
            
            <assert test="mods:originInfo" sqf:fix="originInfo">
                The record should have mods:originInfo.
            </assert>
            <sqf:fix id="originInfo">
                <sqf:description>
                    <sqf:title>Add mods:originInfo</sqf:title>
                </sqf:description>
                <sqf:add match="mods:genre" position="after">
                    <xsl:text>
   </xsl:text><mods:originInfo eventType=""><xsl:text>
      </xsl:text><xsl:text>
   </xsl:text></mods:originInfo>
                </sqf:add>
            </sqf:fix>
            
            <!--<assert test="mods:language"/>-->
            
            <assert test="mods:physicalDescription" sqf:fix="physicalDescription">
                The record should have mods:physicalDescription.
            </assert>
            <sqf:fix id="physicalDescription">
                <sqf:description>
                    <sqf:title>Add mods:physicalDescription</sqf:title>
                </sqf:description>
                <sqf:add match="child::*[self::mods:originInfo or self::mods:language][last()]" position="after">
                    <xsl:text>
   </xsl:text><mods:physicalDescription><xsl:text>
      </xsl:text><mods:form type="media" authority="rdamedia">computer</mods:form><xsl:text>
      </xsl:text><mods:form type="carrier" authority="rdacarrier">online resource</mods:form><xsl:text>
   </xsl:text></mods:physicalDescription>
                </sqf:add>
            </sqf:fix>
            
            <!--<assert test="mods:tableOfContents"></assert>-->
            
            <!--<assert test="mods:targetAudience"></assert>-->
            
            <!--<assert test="mods:classification"></assert>-->
            
            <!--<assert test="mods:relatedItem"></assert>-->
            
            <assert test="mods:identifier" sqf:fix="identifier">
                The record should have mods:identifier.
            </assert>
            <sqf:fix id="identifier">
                <sqf:description>
                    <sqf:title>Add mods:identifier</sqf:title>
                </sqf:description>
                <sqf:add match="child::*[self::mods:note or self::mods:relatedItem][last()]" position="after">
                    <xsl:text>
   </xsl:text><mods:identifier></mods:identifier>
                </sqf:add>
            </sqf:fix>
            
            <assert test="mods:location" sqf:fix="location">
                The record should have mods:location.
            </assert>
            <sqf:fix id="location">
                <sqf:description>
                    <sqf:title>Add mods:location</sqf:title>
                </sqf:description>
                <sqf:add match="mods:identifier" position="after">
                    <xsl:text>
   </xsl:text><mods:location><xsl:text>
      </xsl:text><xsl:text>
   </xsl:text></mods:location>
                </sqf:add>
            </sqf:fix>
            
            <assert test="mods:accessCondition" sqf:fix="accessCondition">
                The record should have mods:accessCondition.
            </assert>
            <sqf:fix id="accessCondition">
                <sqf:description>
                    <sqf:title>Add mods:accessCondition</sqf:title>
                </sqf:description>
                <sqf:add match="mods:location" position="after">
                    <xsl:text>
   </xsl:text><mods:accessCondition type=""></mods:accessCondition>
                </sqf:add>
            </sqf:fix>
            
            <!--<assert test="mods:part"></assert>-->
            
            <!--<assert test="mods:extension"></assert>-->
            
            <assert test="mods:recordInfo" sqf:fix="recordInfo">
                The record should have mods:recordInfo.
            </assert>
            <sqf:fix id="recordInfo">
                <sqf:description>
                    <sqf:title>Add mods:recordInfo</sqf:title>
                </sqf:description>
                <sqf:add match="mods:accessCondition" position="after">
                    <xsl:text>
   </xsl:text><mods:recordInfo><xsl:text>
      </xsl:text><xsl:text>
   </xsl:text></mods:recordInfo>
                </sqf:add>
            </sqf:fix>
        </rule>
        
    </pattern>
    
    <!-- Elements for collection-level records -->
    
    <pattern>
        <rule context="mods:mods[mods:typeOfResource[@collection='yes']]">
            <assert test="mods:name">
                Collection-level records should have mods:name.
            </assert>
            <assert test="mods:genre[@authority='local']">
                Collection-level records should have a local mods:genre term.
            </assert>
            <assert test="mods:genre[@authority='marcgt']">
                Collection-level records should have a MARC mods:genre term.
            </assert>
            <assert test="mods:originInfo/mods:place">
                Collection-level records should have mods:place.
            </assert>
            <assert test="mods:originInfo/mods:publisher">
                Collection-level records should have mods:publisher.
            </assert>
            <assert test="mods:originInfo/mods:issuance[matches(., '(single unit|multipart monograph|serial|integrating resource)')]">
                Collection-level records should have mods:issuance with a value of "single unit", "multipart monograph", "serial", or "integrating resource".
            </assert>
            <assert test="mods:abstract">
                Collection-level records should have mods:abstract.
            </assert>
            <assert test="mods:subject">
                Collection-level records should have mods:subject.
            </assert>
            
            <assert test="mods:note[not(@*)][matches(text(), 'Made available through the Dartmouth Digital Library.')]" sqf:fix="note-made-available">
                The record should have the note "Made available through the Dartmouth Digital Library."
            </assert>
            <sqf:fix id="note-made-available">
                <sqf:description>
                    <sqf:title>Add mods:note about the Dartmouth Digital Library</sqf:title>
                </sqf:description>
                <sqf:add match="child::*[self::mods:physicalDescription or self::mods:tableOfContents][last()]" position="after">
                    <xsl:text>
   </xsl:text><mods:note>Made available through the Dartmouth Digital Library.</mods:note>
                </sqf:add>
            </sqf:fix>
            
        </rule>
        <rule context="mods:mods/mods:originInfo/mods:issuance[matches(., '(serial|integrating resource)')]">
            <assert test="../mods:frequency[@authority='marcfrequency']">
                Continuing resources should have mods:frequency.
            </assert>
        </rule>
        
    </pattern>
    
    <!-- Elements for item-level records -->
    
    <pattern>
        <rule context="mods:mods/mods:relatedItem[@type='host']">
            
            <assert test="mods:titleInfo" sqf:fix="relatedItem-titleInfo">
                Item-level records should have mods:titleInfo for their collection under mods:relatedItem[@type='host'].
            </assert>
            <sqf:fix id="relatedItem-titleInfo">
                <sqf:description>
                    <sqf:title>Add mods:titleInfo for host collection</sqf:title>
                </sqf:description>
                <sqf:add>
                    <xsl:text>
   </xsl:text><mods:titleInfo><xsl:text>
      </xsl:text><xsl:text>
   </xsl:text></mods:titleInfo>
                </sqf:add>
            </sqf:fix>
            
            <assert test="mods:typeOfResource[@collection='yes']" sqf:fix="relatedItem-typeOfResource">
                Item-level records should have mods:typeOfResource for their collection under mods:relatedItem[@type='host'].
            </assert>
            <sqf:fix id="relatedItem-typeOfResource">
                <sqf:description>
                    <sqf:title>Add mods:typeOfResource for host collection</sqf:title>
                </sqf:description>
                <sqf:add match="mods:titleInfo" position="after">
                    <xsl:text>
   </xsl:text><mods:typeOfResource collection="yes"></mods:typeOfResource>
                </sqf:add>
            </sqf:fix>
            
        </rule>
    </pattern>
    
    <!-- INDIVIDUAL ELEMENTS -->
    
    <!-- titleInfo -->
    
    <pattern>
        <rule context="mods:mods/mods:titleInfo">
            <assert test="mods:title" sqf:fix="title">
                <name/> should have mods:title.
            </assert> <!-- Level 1 -->
            <sqf:fix id="title">
                <sqf:description>
                    <sqf:title>Add mods:title</sqf:title>
                </sqf:description>
                <sqf:add node-type="element" target="mods:title"/>
            </sqf:fix>
        </rule>
    </pattern>

    <!-- name -->

    <pattern>
        <rule context="mods:mods/mods:name">
            <assert test="@type" sqf:fix="name-type">
                <name/> should have @type.
            </assert> <!-- Level 4 -->
            <sqf:fix id="name-type">
                <sqf:description>
                    <sqf:title>Add @type to mods:name</sqf:title>
                </sqf:description>
                <sqf:add node-type="attribute" target="type"/>
            </sqf:fix>
        </rule>
        <rule context="mods:mods/mods:name/mods:role">
            <assert test="mods:roleTerm[@type='text'][@authority='marcrelator']">
                <name/> should have mods:roleTerm with @type="text" and @authority="marcrelator".
            </assert>
        </rule>
    </pattern>
    
    <pattern>
        <rule context="mods:mods/mods:name[@usage='primary']">
            <assert test="mods:role/mods:roleTerm[@type='text'][normalize-space(text())]">
                The primary name should have a text mods:roleTerm assigned from the MARC Code List for Relators.
            </assert>
        </rule>
    </pattern>
    
    <!-- genre -->
    
    <pattern>
        <rule context="mods:mods/mods:genre">
            <assert test="@authority" sqf:fix="genre-authority">
                <name/> should have @authority.
            </assert>
            <sqf:fix id="genre-authority">
                <sqf:description>
                    <sqf:title>Add @authority to mods:genre</sqf:title>
                </sqf:description>
                <sqf:add node-type="attribute" target="authority"/>
            </sqf:fix>
        </rule>
    </pattern>
    
    <!-- originInfo -->
    
    <pattern>
        <rule context="mods:mods/mods:originInfo">
            <assert test="@eventType" sqf:fix="eventType">
                <name/> should have @eventType.
            </assert>
            <sqf:fix id="eventType">
                <sqf:description>
                    <sqf:title>Add @eventType to mods:originInfo</sqf:title>
                </sqf:description>
                <sqf:add node-type="attribute" target="eventType"/>
            </sqf:fix>
            <assert test="child::*[matches(name(.), 'date', 'i')][normalize-space(text())]">
                <name/> should have a non-blank date element.
            </assert> <!-- Level 1 -->
        </rule>
    </pattern>

    <!-- physicalDescription -->

    <pattern>
        <rule context="mods:mods/mods:physicalDescription">
            
            <assert test="mods:form" sqf:fix="form">
                <name/> should have mods:form.
            </assert>
            <sqf:fix id="form">
                <sqf:description>
                    <sqf:title>Add mods:form</sqf:title>
                </sqf:description>
                <sqf:add><xsl:text>
   </xsl:text><mods:form></mods:form>                    
                </sqf:add>
            </sqf:fix>
            
            <assert test="mods:internetMediaType" sqf:fix="internetMediaType">
                <name/> should have mods:internetMediaType.
            </assert> <!-- Level 2 -->
            <sqf:fix id="internetMediaType">
                <sqf:description>
                    <sqf:title>Add mods:internetMediaType</sqf:title>
                </sqf:description>
                <sqf:add match="mods:form" position="after"><xsl:text>
   </xsl:text><mods:internetMediaType></mods:internetMediaType>                    
                </sqf:add>
            </sqf:fix>
            
            <assert test="mods:extent" sqf:fix="extent">
                <name/> should have mods:extent.
            </assert>
            <sqf:fix id="extent">
                <sqf:description>
                    <sqf:title>Add mods:extent</sqf:title>
                </sqf:description>
                <sqf:add match="mods:internetMediaType" position="after"><xsl:text>
   </xsl:text><mods:extent></mods:extent>                    
                </sqf:add>
            </sqf:fix>
            
            <assert test="mods:digitalOrigin" sqf:fix="digitalOrigin">
                <name/> should have mods:digitalOrigin.
            </assert> <!-- Level 4 -->
            <sqf:fix id="digitalOrigin">
                <sqf:description>
                    <sqf:title>Add mods:digitalOrigin</sqf:title>
                </sqf:description>
                <sqf:add match="mods:extent" position="after"><xsl:text>
   </xsl:text><mods:digitalOrigin></mods:digitalOrigin>                    
                </sqf:add>
            </sqf:fix>
            
        </rule>
    </pattern>
    
    <!-- abstract -->
    
    <pattern>
        <rule context="mods:mods/mods:abstract">
            <assert test="matches(., '.+[\.\?!]$')">
                <name/> should end with a punctuation mark.
            </assert>
        </rule>
    </pattern>
    
    <!-- note -->
    
    <!-- classification -->
    
    <pattern>
        <rule context="mods:mods/mods:classification">
            <assert test="@authority">
                <name/> should have @authority.
            </assert> <!-- Level 3 -->
        </rule>
    </pattern>
    
    <!-- location -->
    
    <pattern>
        <rule context="mods:mods/mods:location">
            <assert test="mods:url[@access]">
                <name/> should have mods:url with @access.
            </assert> <!-- Level 1, 2 -->
        </rule>
    </pattern>
    
    <!-- accessCondition -->
    
    <pattern>
        <rule context="mods:mods/mods:accessCondition">
            <assert test="@type" sqf:fix="accessCondition-type">
                <name/> should have @type.
            </assert>
            <sqf:fix id="accessCondition-type">
                <sqf:description>
                    <sqf:title>Add @type to mods:accessCondition</sqf:title>
                </sqf:description>
                <sqf:add node-type="attribute" target="type"/>
            </sqf:fix>
            <assert test="@type = ('use and reproduction', 'restriction on access')">
                The value of @type for <name/> should be "use and reproduction" or "restriction on access".
            </assert> 
        </rule>
    </pattern>
    
    <!-- extension -->
    
    <pattern>
        <rule context="mods:mods/mods:extension/drb:flag[@type='doi']">
            <assert test="matches(@registered, '^$') or matches(@registered, '^[0-9]{4}(-[0-9]{2}){2}$')">
                @registered should either be blank or have a YYYY-MM-DD date.
            </assert>
        </rule>
        <rule context="mods:mods/mods:extension/drb:filename">
            <assert test="@type='master' or @type='component image'">
                <name/> should have @type='master' or @type='component image'.
            </assert>
            <assert test="matches(., '^\S+\.\w{2,4}$')">
                <name/> should include a file extension.
            </assert>
        </rule>
    </pattern>

    <!-- recordInfo -->

    <pattern>
        <rule context="mods:mods/mods:recordInfo">
            <assert test="mods:descriptionStandard[@authority='marcdescription']">
                <name/> should have mods:descriptionStandard with @authority="marcdescription".
            </assert>
            <assert test="mods:recordContentSource[@authority='oclcorg']='DRB'">
                <name/> should have mods:recordContentSource with @authority="oclcorg" and a value of "DRB".
            </assert> <!-- Level 5 -->
            <assert test="not(mods:recordContentSource[not(@authority)])">
                All mods:recordContentSource fields should have @authority.
            </assert>
            <assert test="mods:recordCreationDate">
                <name/> should have mods:recordCreationDate.
            </assert>
            <assert test="mods:languageOfCataloging/mods:languageTerm[@type='text']='English'">
                <name/> should have mods:languageOfCataloging/mods:languageTerm with @type="text" and a value of "English".
            </assert> <!-- Level 4 -->
            <assert
                test="mods:languageOfCataloging/mods:languageTerm[@type='code'][@authority='iso639-2b']='eng'">
                <name/> should have mods:languageOfCataloging/mods:languageTerm with @type="code", @authority="iso639-2b",
                and a value of "iso639-2b".
            </assert>
        </rule>
    </pattern>
    
    <!-- GENERAL REQUIREMENTS -->
    
    <!-- MODS Version -->
    
    <pattern>
        <rule context="mods:mods">
            <assert test="@version='3.6'">
                This record has not been upgraded to MODS version 3.6.
            </assert>
            <!--<sqf:fix id="mods-version">
                <sqf:description>
                    <sqf:title>Upgrade record to MODS version 3.6</sqf:title>
                </sqf:description>
                <sqf:replace node-type="attribute" match="@version" select="@version">3.6</sqf:replace>
            </sqf:fix>-->
        </rule>
    </pattern>
    
    <!-- Text -->
    
    <pattern>
        <rule context="//*[not(child::*)][not(parent::mods:extension)][not(self::mods:nonSort)]">
            <assert test="not(normalize-space(text()) = '')">
                All elements without children should contain text. [<name path=".."/>/<name/>]
            </assert>
            <assert test=". = normalize-space(.)">
                Elements with text should not contain extraneous whitespace (including line breaks). [<name path=".."/>/<name/>]
            </assert>
        </rule>
    </pattern>

    <!-- Dates -->

    <pattern>
        <!-- CANDIDATE FOR W3C SCHEMA OVERRIDE -->
        <rule context="*[matches(name(.), 'date', 'i')][normalize-space(text())]">
            <assert test="@encoding='w3cdtf' or @encoding='marc' or @encoding='iso8601'">
                All non-empty dates should be marked as W3CDTF, MARC, or ISO8601. [<name path=".."/>/<name/>]
            </assert>
        </rule>
    </pattern>
    
    <pattern>
        <rule context="*[matches(name(.), 'date', 'i')][@encoding='w3cdtf']">
            <assert
                test="matches(.,'^[0-9]{4}(-[0-9]{2}){0,2}$') or
                matches(.,'^[0-9]{4}(-[0-9]{2}){2}T[0-9]{2}:[0-9]{2}(:[0-9]{2}(\.[0-9]+)?)?(Z|[+-][0-9]{2}:[0-9]{2})$')">
                W3CDTF dates should match the specified format (YYYY-MM-DD, YYYY-MM, or YYYY). [<name path=".."/>/<name/>]
            </assert>
        </rule>
    </pattern>

    <pattern>
        <rule context="*[matches(name(.), 'date', 'i')][not(normalize-space(text()))]">
            <assert test="@point='end'">
                All empty dates should be the end of a date range. [<name path=".."/>/<name/>]
            </assert>
        </rule>
    </pattern>
    
    <pattern>
        <rule context="mods:mods">
            <assert test="count(descendant::*[@keyDate])=1">
                @keyDate should be used exactly once per record, within a mods:originInfo element.
            </assert> <!-- Level 2 -->
        </rule>
    </pattern>

    <pattern>
        <rule context="*[@keyDate]">
            <assert test=".[@encoding='w3cdtf' or @encoding='marc']">
                @keyDate should be expressed using W3CDTF or MARC. [<name path=".."/>/<name/>]
            </assert> <!-- Level 3 -->
            <assert test="ancestor::mods:originInfo">
                @keyDate should appear within mods:originInfo.
            </assert>
        </rule>
    </pattern>
    
    <!-- DOIs -->
    
    <pattern>
        <rule context="mods:mods//mods:identifier[@type='doi']">
            <assert test="matches(., '^http(s)?://dx\.doi\.org/10\.\d{4,9}/[-._;()/:A-Z0-9]+$', 'i')">
                DOIs should match the specified format (http://dx.doi.org/[prefix]/[suffix]).
            </assert>
        </rule>
    </pattern>
    
    <!-- RDA Conformance -->
    
    <pattern>
        <rule context="mods:mods">
            <assert test="mods:genre[@type='content'][@authority='rdacontent']">
                The record should have an RDA content term in mods:genre.
            </assert>
            <assert test="mods:physicalDescription/mods:form[@type='media'][@authority='rdamedia']">
                The record should have an RDA media term in mods:form.
            </assert>
            <assert test="mods:physicalDescription/mods:form[@type='carrier'][@authority='rdacarrier']">
                The record should have an RDA carrier term in mods:form.
            </assert>
            <assert test="mods:recordInfo/mods:descriptionStandard='rda'">
                The record's mods:descriptionStandard should be marked as "rda".
            </assert>
        </rule>
    </pattern>
    
    <!-- Non-Latin Scripts -->
    
    <pattern>
        <rule context="text()[matches(., '\p{IsGreekandCoptic}')]">
            <assert test="../@script='Grek'" sqf:fix="script-Grek">
                This element contains characters from the Greek and Coptic Unicode block but lacks the appropriate @script. [<name path="../.."/>/<name path=".."/>]
            </assert>
            <sqf:fix id="script-Grek">
                <sqf:description>
                    <sqf:title>Add @script for Greek and Coptic characters</sqf:title>
                </sqf:description>
                <sqf:add node-type="attribute" match=".." target="script">Grek</sqf:add>
            </sqf:fix>
        </rule>
    </pattern>
    
    <!-- OCLC WorldCat Data -->
    
    <pattern>
        <rule context="mods:mods/mods:recordInfo[
            mods:recordIdentifier[@source='OCoLC'] or
            mods:recordInfoNote[@type='date entered as MARC'] or 
            mods:recordChangeDate[@encoding='iso8601']
            ]">
            <assert test="mods:recordIdentifier[@source='OCoLC'] and
                mods:recordInfoNote[@type='date entered as MARC'] and 
                mods:recordChangeDate[@encoding='iso8601']">
                If the record has been contributed to WorldCat, it should have three additional fields: an OCLC number and the MARC dates for entered on file and last transaction.
            </assert>
        </rule>
        <rule context="mods:mods/mods:recordInfo/mods:recordIdentifier[@source='OCoLC']">
            <assert test="matches(., '^(ocm|ocn|on)\d{8,}$')">
                The OCLC number in <name path=".."/> should consist of an alphabetic prefix followed by 8 or more digits.
            </assert>
        </rule>
        <rule context="mods:mods/mods:relatedItem/mods:recordInfo/mods:recordIdentifier[@source='OCoLC']">
            <assert test="matches(., '^\d{8,}$')">
                The OCLC number in <name path="../.."/> should consist of 8 or more digits without an alphabetic prefix.
            </assert>
        </rule>
    </pattern>

</schema>
