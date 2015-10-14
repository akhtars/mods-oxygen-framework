<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">

    <!-- Implements local restrictions on Dartmouth College Library-created MODS records. -->
    
    <!-- "Level 1", etc. indicate specific enforcement of the DLF Aquifer MODS Guidelines Levels of Adoption
        https://wiki.dlib.indiana.edu/display/DLFAquifer/MODS+Guidelines+Levels+of+Adoption -->

    <title>Dartmouth College Library MODS Implementation</title>
    <ns uri="http://www.loc.gov/mods/v3" prefix="mods"/>
    <ns uri="http://www.dartmouth.edu/~library/catmet/" prefix="drb"/>
    
    <!-- RECORD STRUCTURE -->

    <!-- Top-level elements -->

    <pattern>
        
        <!-- Digital Library Program materials -->
        
        <rule context="mods:mods[mods:extension/drb:flag[@type='program'][@value='ddlp']]">
            <assert test="mods:titleInfo">
                The record should have mods:title.
            </assert>
            <assert test="mods:typeOfResource">
                The record should have mods:typeOfResource.
            </assert>
            <assert test="mods:genre">
                The record should have mods:genre.
            </assert>
            <assert test="mods:originInfo">
                The record should have mods:originInfo.
            </assert>
            <!--<assert test="mods:language"/>-->
            <assert test="mods:physicalDescription">
                The record should have mods:physicalDescription.
            </assert>
            <!--<assert test="mods:tableOfContents"></assert>-->
            <!--<assert test="mods:targetAudience"></assert>-->
            <assert test="mods:note[not(@*)][matches(text(), 'Made available through the Dartmouth Digital Library.')]">
                The record should have the note "Made available through the Dartmouth Digital Library."
            </assert>
            <!--<assert test="mods:classification"></assert>-->
            <!--<assert test="mods:relatedItem"></assert>-->
            <assert test="mods:identifier">
                The record should have mods:identifier.
            </assert>
            <assert test="mods:location">
                The record should have mods:location.
            </assert>
            <assert test="mods:accessCondition">
                The record should have mods:accessCondition.
            </assert>
            <!--<assert test="mods:part"></assert>-->
            <!--<assert test="mods:extension"></assert>-->
            <assert test="mods:recordInfo">
                The record should have mods:recordInfo.
            </assert>
        </rule>
        
    </pattern>
    
    <!-- Elements for collection-level records -->
    
    <pattern>
        <rule context="mods:mods[child::mods:typeOfResource[@collection='yes']]">
            <assert test="mods:name">
                Collection-level records should have mods:name.
            </assert>
            <assert test="mods:originInfo/mods:place">
                Collection-level records should have mods:place.
            </assert>
            <assert test="mods:originInfo/mods:publisher">
                Collection-level records should have mods:publisher.
            </assert>
            <assert test="mods:abstract">
                Collection-level records should have mods:abstract.
            </assert>
            <assert test="mods:subject">
                Collection-level records should have mods:subject.
            </assert>
        </rule>
    </pattern>
    
    <!-- INDIVIDUAL ELEMENTS -->
    
    <!-- titleInfo -->
    
    <pattern>
        <rule context="mods:mods/mods:titleInfo">
            <assert test="mods:title">
                <name/> should have mods:title.
            </assert> <!-- Level 1 -->
        </rule>
    </pattern>

    <!-- name -->

    <pattern>
        <rule context="mods:mods/mods:name">
            <assert test="@type">
                <name/> should have @type.
            </assert> <!-- Level 4 -->
        </rule>
        <rule context="mods:mods/mods:name/mods:role">
            <assert test="mods:roleTerm[@type='text']">
                <name/> should have mods:roleTerm with @type="text".
            </assert>
        </rule>
    </pattern>
    
    <pattern>
        <rule context="mods:mods/mods:name[@usage='primary']">
            <assert test="mods:role/mods:roleTerm[@type='text'][normalize-space(text())]">
                The primary name should have a text mods:roleTerm assigned.
            </assert>
        </rule>
    </pattern>
    
    <!-- genre -->
    
    <pattern>
        <rule context="mods:mods/mods:genre">
            <assert test="@authority">
                <name/> should have @authority.
            </assert>
        </rule>
    </pattern>
    
    <!-- originInfo -->
    
    <pattern>
        <rule context="mods:mods/mods:originInfo">
            <assert test="@eventType">
                <name/> should have @eventType.
            </assert>
            <assert test="child::*[matches(name(.), 'date', 'i')][normalize-space(text())]">
                <name/> should have a non-blank date element.
            </assert> <!-- Level 1 -->
        </rule>
    </pattern>

    <!-- physicalDescription -->

    <pattern>
        <rule context="mods:mods/mods:physicalDescription">
            <assert test="mods:form">
                <name/> should have mods:form.
            </assert>
            <assert test="mods:internetMediaType">
                <name/> should have mods:internetMediaType.
            </assert> <!-- Level 2 -->
            <assert test="mods:extent">
                <name/> should have mods:extent.
            </assert>
            <assert test="mods:digitalOrigin">
                <name/> should have mods:digitalOrigin.
            </assert> <!-- Level 4 -->
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
            <assert test="@type">
                <name/> should have @type.
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
    
    <!-- Text -->
    
    <pattern>
        <rule context="//*[not(child::*)][not(parent::mods:extension)]">
            <assert test="not(normalize-space(text()) = '')">
                All elements without children should contain text.
            </assert>
        </rule>
    </pattern>

    <!-- Dates -->

    <pattern>
        <!-- CANDIDATE FOR W3C SCHEMA OVERRIDE -->
        <rule context="*[matches(name(.), 'date', 'i')][normalize-space(text())]">
            <assert test="@encoding='w3cdtf' or @encoding='marc'">
                All non-empty dates should be marked as W3CDTF or MARC.
            </assert>
        </rule>
    </pattern>
    
    <pattern>
        <rule context="*[matches(name(.), 'date', 'i')][@encoding='w3cdtf']">
            <assert
                test="matches(.,'^[0-9]{4}(-[0-9]{2}){0,2}$') or
                matches(.,'^[0-9]{4}(-[0-9]{2}){2}T[0-9]{2}:[0-9]{2}(:[0-9]{2}(\.[0-9]+)?)?(Z|[+-][0-9]{2}:[0-9]{2})$')">
                W3CDTF dates should match the specified format (YYYY-MM-DD, YYYY-MM, or YYYY).
            </assert>
        </rule>
    </pattern>

    <pattern>
        <rule context="*[matches(name(.), 'date', 'i')][not(normalize-space(text()))]">
            <assert test="@point='end'">
                All empty dates should be the end of a date range.
            </assert>
        </rule>
    </pattern>

    <pattern>
        <rule context="*[@keyDate]">
            <assert test="count(ancestor::mods:mods//*[@keyDate])=1">
                @keyDate should be used exactly once per record.
            </assert> <!-- Level 2 -->
            <assert test=".[@encoding='w3cdtf']">
                @keyDate should be expressed using W3CDTF.
            </assert> <!-- Level 3 -->
            <assert test="ancestor::mods:originInfo">
                @keyDate should appear within mods:originInfo.
            </assert>
        </rule>
    </pattern>
    
    <!-- DOIs -->
    
    <pattern>
        <rule context="mods:mods/mods:identifier[@type='doi']">
            <assert test="matches(., '^http(s)?://dx\.doi\.org/10\.\d{4,9}/[-._;()/:A-Z0-9]+$', 'i')">DOIs should match the specified format (http://dx.doi.org/[prefix]/[suffix]).</assert>
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

</schema>
