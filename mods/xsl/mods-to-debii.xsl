<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:cmd="http://www.cdlib.org/inside/diglib/copyrightMD" 
    xmlns:drb="http://www.dartmouth.edu/~library/catmet/"
    xmlns:err="error"
    xmlns:gp="global-parameter"
    xmlns:lfn="localfunctions"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    exclude-result-prefixes="cmd drb err gp lfn map math mods xd xlink xs xsl"
    version="3.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>
                Generalized MODS-to-DEBII transformation, creating a load file
                for a single DEBII collection from a directory of MODS records.
            </xd:p>

            <xd:p>
                By Shaun Akhtar and Paul Merchant, Jr.
                Copyright © 2018 Trustees of Dartmouth College
            </xd:p>
            
            <xd:p>
                This stylesheet may be called in one of three ways:
                <xd:ul>
                    <xd:li>
                        By supplying a source MODS record file.  In this case, the
                        <xd:b>{global-parameter}collection</xd:b> parameter must also be supplied
                        to indicate the collection ID.  The name of the MODS file is used
                        as the record ID.  A DEBII load format file is produced from the MODS
                        record.
                    </xd:li>
                    <xd:li>
                        By specifying <xd:b>collection</xd:b> as the initial template.  The parameter
                        <xd:b>{global-parameter}collection</xd:b> must be supplied to indicate a directory containing
                        a set of MODS files.  The name of the directory is taken as the collection
                        identifier, and the name of each file is taken as a record ID.  A DEBII load 
                        format file is produced for each file in the directory.
                    </xd:li>
                    
                    <xd:li>
                        By specifying <xd:b>cfg-labels</xd:b> as the initial template.  No other parameters
                        are required, and a prototype dcfg file is produced based on the field name - label
                        map in the transformation.
                    </xd:li>
                </xd:ul>
            </xd:p>
        </xd:desc>
        
        <xd:param name="{global-parameter}location">
            The collection directory.  Required and used only in batch processing mode to
            specify the directory containing the collection's documents.  The name of the 
            directory is taken as the collection ID.
        </xd:param>
        
        <xd:param name="{global-parameter}collection">
            The identity of the collection.  Required and used only in single document
            processing mode.
        </xd:param>
    </xd:doc>

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <xsl:strip-space elements="*"/>

    <xsl:param name="gp:location"/>      <!-- Replaced by ${cfdu} in Oxygen parameter configuration -->
    <xsl:param name="gp:collection"/>    <!-- supplied by XMLCollections -->
    
    <!-- See https://www.w3.org/TR/xslt-30/#map-examples -->
    
    <!-- constants for keys in field-map.  Actual values are arbitrary, but integers are conveniently short. -->
    <xsl:variable name="A_LABEL" static="yes" as="xs:integer" select="0"/> 
    <xsl:variable name="A_DCMES" static="yes" as="xs:integer" select="1"/> 
   
    <!-- Error types -->
    <xsl:variable name="err:error" select="xs:QName('err:error')" static="yes"/>
    
    <!-- Map field name to an optional label and DCMES attribute value. -->
    <xsl:variable name="field-map" as="map(xs:string, map(xs:integer, xs:string))" select="
        map {
            'main-title'                    : map{ $A_LABEL : 'Title',                 $A_DCMES : 'Title'},
            'alt-title'                     : map{ $A_LABEL : 'Alternate Title',       $A_DCMES : 'Title' },
            'other-title'                   : map{ $A_LABEL : 'Alternate Title',       $A_DCMES : 'Title' },
            'uniform-title'                 : map{ $A_LABEL : 'Uniform Title' },
            'name'                          : map{ $A_LABEL : 'Name',                  $A_DCMES : 'Contributor' },
            'content-type'                  : map{ $A_LABEL : 'Content Type',          $A_DCMES : 'Type' },
            'genre'                         : map{ $A_LABEL : 'Genre' },
            'genre-marcgt'                  : map{ },
            'digital-publication'           : map{ $A_LABEL : 'Digital Publication' },
            'digital-publication-date'      : map{ },
            'edition'                       : map{ $A_LABEL : 'Edition' },
            'language'                      : map{ $A_LABEL : 'Language',              $A_DCMES : 'Language' },
            'extent'                        : map{ $A_LABEL : 'Extent',                $A_DCMES : 'Format' },
            'other-physical-details'        : map{ $A_LABEL : 'Other Physical Details' },
            'mime-type'                     : map{ $A_LABEL : 'MIME Type' },
            'digital-origin'                : map{ $A_LABEL : 'Digital Origin' },
            'summary'                       : map{ $A_LABEL : 'Summary',               $A_DCMES : 'Description' },
            'contents'                      : map{ $A_LABEL : 'Table of Contents',     $A_DCMES : 'Description' },
            'thesis-note'                   : map{ $A_LABEL : 'Thesis Note' },
            'funding-note'                  : map{ $A_LABEL : 'Funding Note' },
            'language-note'                 : map{ $A_LABEL : 'Language Note' },
            'cast-note'                     : map{ $A_LABEL : 'Cast' },
            'credits-note'                  : map{ $A_LABEL : 'Credits' },
            'note'                          : map{ $A_LABEL : 'Note' },
            'subject-topical'               : map{ $A_LABEL : 'Subject (Topical)',       $A_DCMES : 'Subject' },
            'subject-title'                 : map{ $A_LABEL : 'Subject (Title)',         $A_DCMES : 'Subject' },
            'subject-name'                  : map{ $A_LABEL : 'Subject (Name)',          $A_DCMES : 'Subject' },
            'subject-geographic'            : map{ $A_LABEL : 'Subject (Geographic)',    $A_DCMES : 'Coverage' },
            'subject-geographic-country'    : map{ $A_LABEL : 'Subject (Country)' },
            'subject-geographic-city'       : map{ $A_LABEL : 'Subject (City)' },
            'subject-chronological'         : map{ $A_LABEL : 'Subject (Chronological)', $A_DCMES : 'Coverage' },
            'stoiber-subject'               : map{ $A_LABEL : 'Stoiber Subject' },
            'stoiber-feature'               : map{ $A_LABEL : 'Stoiber Feature' },
            'scale'                         : map{ $A_LABEL : 'Scale' },
            'coordinates'                   : map{ $A_LABEL : 'Coordinates' },
            'classification'                : map{ $A_LABEL : 'Classification' },
            'collection'                    : map{ $A_LABEL : 'Collection' },
            'subcollection'                 : map{ $A_LABEL : 'Subcollection' },
            'date-of-work'                  : map{                                     $A_DCMES : 'Date' }, 
            'date-of-work-facet'            : map{ },
            'original-publication'          : map{ $A_LABEL : 'Original Publication',  $A_DCMES : 'Relation' },
            'original-production'           : map{ $A_LABEL : 'Original Production',   $A_DCMES : 'Relation' },
            'identifier'                    : map{ $A_LABEL : 'Identifier' },
            'persistent-identifier'         : map{ $A_LABEL : 'Permalink',             $A_DCMES : 'Identifier' },
            'standardized-rights-statement' : map{ $A_LABEL : 'Standardized Rights Statement', $A_DCMES : 'Rights' },
            'standardized-rights-label'     : map{ },
            'rights-holder'                 : map{ $A_LABEL : 'Rights Holder' },
            'rights-statement'              : map{ $A_LABEL : 'Rights Statement' },
            'record-identifier'             : map{ $A_LABEL : 'Record Identifier',     $A_DCMES : 'Identifier' },
            'citation-mla'                  : map{ $A_LABEL : 'Citation (MLA Format)' },
            'citation-chicago'              : map{ $A_LABEL : 'Citation (Chicago Format)' },
            'name-facet'                    : map{ $A_LABEL : 'Name' },
            'kaltura-id'                    : map{ $A_LABEL : 'Kaltura ID' },
            'shelf-location'                : map{ $A_LABEL : 'Shelf Location',        $A_DCMES : 'Identifier' },
            'numbering-note'                : map{ $A_LABEL : 'Numbering Peculiarities Note' },
            'event-note'                    : map{ $A_LABEL : 'Event Note' },
            'accessibility-note'            : map{ $A_LABEL : 'Accessibility Note' },
            'perry-biographical-period'     : map{ $A_LABEL : 'Biographical Period' },
            'perry-subject'                 : map{ $A_LABEL : 'Perry Subject' },
            'perry-remembered'              : map{ $A_LABEL : 'Perry Remembered' }
        }"
    />
    
    
    <xd:doc>
        <xd:desc>Validate a collection ID value.  Throws an exception if the id is invalid.</xd:desc>
        <xd:param name="id">A collection ID to be tested.</xd:param>
    </xd:doc>
    <xsl:function name="lfn:validate-id" as="xs:boolean">
        <xsl:param name="id" as="xs:string"/>
        
        <xsl:if test="not(matches($id, '[A-Za-z]([-_]?[A-Za-z0-9])*'))">
            <xsl:value-of select="error($err:error, concat('Invalid id: ', $id))"/>
        </xsl:if>
        
        <xsl:sequence select="true()"/>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>Test whether a required string value has been supplied.  Throws an exception if
        the value is absent or empty.</xd:desc>
        <xd:param name="v">the value to test</xd:param>
        <xd:param name="label">a string included in the error message to identify the value tested</xd:param>
    </xd:doc>
    <xsl:function name="lfn:required" as="xs:boolean">
        <xsl:param name="v" as="xs:string?"/>
        <xsl:param name="label" as="xs:string"/>
        
        <xsl:if test="empty($v) or $v eq ''">
            <xsl:value-of select="error($err:error, concat($label, ' is required.'))"/>
        </xsl:if>
        
        <xsl:sequence select="true()"/>
    </xsl:function>
    
    
    <xd:doc>
        <xd:desc>Entry point for processing a single document.</xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <xsl:variable name="val" select="lfn:required($gp:collection, 'collection') and lfn:validate-id($gp:collection)"/>
        
        <doc collection="{$gp:collection}">
            <xsl:apply-templates select="mods:mods"/>
        </doc>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>
            Entry template that generates the DEBII configuration file based on the
            field-map
        </xd:desc>
    </xd:doc>
    <xsl:template name="cfg-labels">
        <xsl:result-document 
            doctype-public="-//Dartmouth College Library//DTD Text Markup Configuration File DTD//EN"
            doctype-system="text-markup-cfg.dtd"
            >
            
            <config xmlns="http://dartmouth.edu/teixml/teitexts/cfg">
                
                <xsl:comment> An end-user visible name for the collection </xsl:comment>
                
                <param name="collection-name">xxxxxx</param>
                
                <xsl:comment>=========================================================</xsl:comment>
                <xsl:comment> Output document relative resources </xsl:comment>
                <xsl:comment>=========================================================</xsl:comment>
                
                <xsl:comment> Absolute URL to the collection's home or parent page.  This URL is associated with the collection's
            DOI as a pointer to all of the collections incarnations (PDF, HTML, etc.)
        </xsl:comment>
                <param name="collection-home">http://www.dartmouth.edu/~library/digital/collections/</param>
                
                <xsl:comment> an HTML fragment describing the subcollection </xsl:comment>
                <param name="description">
                    (no description provided)
                </param>
                
                <xsl:comment> field holding a record's unique id </xsl:comment>
                <param name="id-field">ID</param>
                <param name="title-field">main-title</param>
                
                <param name="browse-columns">
                    <column type="thumbnail" field="Thumbnail" linked="yes"/>
                    <column field="Title" linked="yes"/>
                </param>
                
                <param name="field-labels">
                    <xsl:for-each select="map:keys($field-map)">
                        <field name="{.}"  label="{$field-map(.)($A_LABEL)}" />
                    </xsl:for-each>
                </param>
            </config>
        </xsl:result-document>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            Initial template for batch processing a directory.  The directory name must be the collection
            identifier.  Each file must be named by the item identifier. (e.g. {id}.xml)
            
            Create load file from input collection of records. Create `record` wrapper for each object.
            Order template processing for DEBII record display.
        </xd:desc>
    </xd:doc>
    <xsl:template name="collection">
        <xsl:variable name="val" select="lfn:required($gp:location, 'location')"/>
        
        <xsl:variable name="source" select="collection(concat($gp:location, '?select=*-mods.xml'))"/>
        <xsl:variable name="cid" select="tokenize($gp:location, '/')[last()]"/>
        
        <xsl:variable name="val" select="lfn:validate-id($cid)"/>
        
        
        <xsl:result-document>
            <doc collection="{$cid}">
                <xsl:apply-templates select="$source/mods:mods"/>
            </doc>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="mods:mods">
        <xsl:variable name="path" select="document-uri(/)"/>
        <xsl:variable name="id" select="replace(tokenize(document-uri(/), '/')[last()], '(-mods)?\.xml$', '')"/>
       
        <xsl:variable name="val" select="lfn:validate-id($id)"/>
        
        <!-- Controlled list of @type values in MODS for specialized notes that should be displayed -->
        <xsl:variable name="displayed-note-types" select="('thesis', 'creation/production credits', 'performers', 'funding', 'language')"/>
        
        <!-- The mime-type attribute will be attached further downstream in a future release -->
        <record>
            <!-- generates "embargo" attribute if required -->
            <xsl:apply-templates select="mods:accessCondition[@type = 'restriction on access']"/>

            <!-- generate the "suppressed" attribute if required -->
            <xsl:apply-templates select="mods:recordInfo/mods:recordInfoNote[@type='suppressed']" mode="suppress"/>
            
            <field name="ID"><xsl:value-of select="$id"/></field>
            <xsl:apply-templates select="mods:titleInfo"/>
            <xsl:apply-templates select="mods:name[not(mods:namePart = 'Dartmouth Digital Library Program')]"/>
            <xsl:apply-templates select="mods:relatedItem[@type = 'host']"/>
            <xsl:if test="not(mods:relatedItem[@type = ('otherFormat', 'original')])">
                <xsl:apply-templates select="mods:originInfo" mode="dateOfWork"/>
            </xsl:if>
            <xsl:apply-templates select="mods:relatedItem[@type = ('otherFormat', 'original')]"/>
            <xsl:apply-templates select="mods:originInfo"/>
            <xsl:apply-templates select="mods:subject[not(mods:cartographics)]"/>
            <xsl:apply-templates select="mods:subject/mods:cartographics"/>
            <xsl:apply-templates select="mods:genre[not(@type = 'content')]"/>
            <xsl:apply-templates select="mods:genre[@type = 'content']"/>
            <xsl:apply-templates select="mods:genre[@authority = 'marcgt']" mode="marcgt"/>
            <xsl:apply-templates select="mods:note[@type = $displayed-note-types]"/>
            <xsl:apply-templates select="mods:note[not(@type)]"/>
            <xsl:apply-templates select="mods:physicalDescription"/>
            <xsl:apply-templates select="mods:abstract[not(@shareable = 'no')]"/>
            <xsl:apply-templates select="mods:tableOfContents"/>
            <xsl:apply-templates select="mods:language"/>
            <xsl:apply-templates select="mods:classification"/>
            <xsl:apply-templates select="mods:identifier[@type = 'local']"/>
            <xsl:apply-templates select="mods:identifier[@type = 'kaltura']"/>
            <xsl:apply-templates select="mods:identifier[@type = ('doi', 'ark')]"/>
            <xsl:apply-templates select="mods:recordInfo"/>
            <xsl:apply-templates select="mods:accessCondition[@type = 'use and reproduction'][@displayLabel = 'Standardized rights statement']"/>
            <xsl:apply-templates select="mods:accessCondition/cmd:copyright"/>
            <xsl:apply-templates select="mods:accessCondition[@type = 'use and reproduction'][not(@displayLabel)]"/>
            <xsl:apply-templates select="mods:physicalDescription" mode="secondaryPhysical"/>
            <xsl:call-template name="citations"/>
            <xsl:apply-templates select="mods:extension" mode="extension"/>
        </record>
    </xsl:template>

   <xd:doc>
        <xd:desc>
            Ignore elements not specified.
        </xd:desc>
    </xd:doc>
    <xsl:template match="*" mode="#all"/>

    <xd:doc>
        <xd:desc>
            Primary template for reformatting MODS data into DEBII load file format.
            Adapted from local customization of LC MODS-to-MARCXML transformation:
            http://www.loc.gov/standards/mods/v3/MODS3-4_MARC21slim_XSLT2-0.xsl.
        </xd:desc>
        <xd:param name="name">Internal field name; unique, concise.</xd:param>
        <xd:param name="data">(optional) Extract from MODS via XPath expression or custom function.  
                    If omitted, value of current node is used.</xd:param>
    </xd:doc>
    <xsl:template name="field">
        <xsl:param name="name" required="yes"/>
        <xsl:param name="data" select="."/>
        
        <!-- make sure we know about this field -->
        <xsl:if test="not(exists($field-map($name)))">
            <xsl:value-of select="error($err:error, concat('No mapping for field named &quot;', $name, '&quot;'))"/>
        </xsl:if>
        
        <!-- omit empty fields -->
        <xsl:if test="normalize-space($data) ne ''">
            <xsl:variable name="dcmes" select="$field-map($name)($A_DCMES)"/>
            <field name="{$name}">
                <xsl:if test="exists($dcmes)">
                    <xsl:attribute name="dcmes" select="$dcmes"/>
                </xsl:if>
                <xsl:value-of select="$data"/>
            </field>
        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>
            Alternate reformatting template, for date fields only.
        </xd:desc>
        <xd:param name="name">Internal field name; unique, concise.</xd:param>
        <xd:param name="data">(optional) Extract from MODS via XPath expression or custom function.  
            If omitted, value of current node is used.</xd:param>
    </xd:doc>
    <xsl:template name="date-field">
        <xsl:param name="name" required="yes"/>
        <xsl:param name="data" select="."/>
        
        <!-- make sure we know about this field -->
        <xsl:if test="not(exists($field-map($name)))">
            <xsl:value-of select="error($err:error, concat('No mapping for field named &quot;', $name, '&quot;'))"/>
        </xsl:if>
        
        <xsl:variable name="dcmes" select="$field-map($name)($A_DCMES)"/>
        
        <field name="{$name}">
            <xsl:if test="exists($dcmes)">
                <xsl:attribute name="dcmes" select="$dcmes"/>
            </xsl:if>
            <xsl:attribute name="from" select="$data[2]"/>
            <xsl:attribute name="to" select="$data[3]"/>
            <xsl:value-of select="$data[1]"/>
        </field>
    </xsl:template>

    <xd:doc>
        <xd:desc>
                  Assume the context is an item containing a date or date range in one or more
                  dateIssued and dateCreated nodes or node pairs.  Formats the element into a date field
                  with @from and @to suitable for a date range facet.
        </xd:desc>
        <xd:param name="name">Internal field name; unique, concise.</xd:param>
    </xd:doc>
    <xsl:template name="date-field-with-attrs">
        <xsl:param name="name" required="yes"/>
        
        <!-- make sure we know about this field -->
        <xsl:if test="not(exists($field-map($name)))">
            <xsl:value-of select="error($err:error, concat('No mapping for field named &quot;', $name, '&quot;'))"/>
        </xsl:if>
        
        <xsl:variable name="dcmes" select="$field-map($name)($A_DCMES)"/>


        <xsl:for-each select="(mods:dateIssued | mods:dateCreated)[@encoding = 'w3cdtf'][not(@point = 'end')]">
            <xsl:variable name="tagname" select="local-name()"/>
            <xsl:variable name="datefrom" select="."/>
            <xsl:variable name="dateto" select="../*[local-name() = $tagname][@encoding = 'w3cdtf'][@point = 'end']"/>
            
            <field name="{$name}">
                <xsl:if test="exists($dcmes)">
                    <xsl:attribute name="dcmes" select="$dcmes"/>
                </xsl:if>
                <xsl:attribute name="from" select="lfn:formatDateForRange($datefrom, false())"/>
                <xsl:attribute name="to" select="lfn:formatDateForRange(if (empty($dateto)) then $datefrom else $dateto, true())"/>
                <xsl:value-of select="lfn:datesToString($datefrom, $dateto)"/>
            </field>
        </xsl:for-each>
        
    </xsl:template>
    
    <xd:doc>
        <xd:desc>
            Standardize a w3cdtf date to a format suitable for the
            date range attributes.
        </xd:desc>
        <xd:param name="date">the original date string</xd:param>
        <xd:param name="end">true if the date represents the end of the date range, false if it represents the beginning</xd:param>
    </xd:doc>
    <xsl:function name="lfn:formatDateForRange" as="xs:string">
        <xsl:param name="date" as="xs:string"/>
        <xsl:param name="end" as="xs:boolean"/>
        
        <xsl:variable name="parsedDate">
            <xsl:analyze-string select="$date" regex="(\d{{4}})(-(\d{{2}})(-(\d{{2}}))?)?">
                <xsl:matching-substring>
                    <year><xsl:value-of select="regex-group(1)"/></year>
                    <month><xsl:value-of select="regex-group(3)"/></month>
                    <day><xsl:value-of select="regex-group(5)"/></day>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        
        <!-- add a default month and day if those are omitted by the original date.-->
        <xsl:sequence select="
            if ($parsedDate = '') 
                then ''
                else 
                    let $year := $parsedDate/year
                    ,   $month := if (not($parsedDate/month = '')) 
                                    then $parsedDate/month
                                    else if ($end) then '12' else '01'
                    ,   $monthstart := xs:date(string-join(($year, $month, '01'), '-'))
                    ,   $day := if (not($parsedDate/day = '')) 
                                    then $parsedDate/day
                                    else if ($end)
                                        then substring(xs:string($monthstart - xs:dayTimeDuration(concat('P', day-from-date($monthstart) - 1, 'D')) + xs:yearMonthDuration('P1M') - xs:dayTimeDuration('P1D')), 9)
                                        else '01'
                    return string-join(($year, $month, $day), '-')
            "/>
                    
    </xsl:function>
    
    
    <!-- Title -->
    <xsl:template match="mods:titleInfo[not(@type) or (@type = 'translated')]">
        <xsl:call-template name="field">
            <xsl:with-param name="name">main-title</xsl:with-param>
            <xsl:with-param name="data">
                <xsl:call-template name="title">
                    <xsl:with-param name="primary" select="true()"/>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Alternate title -->
    <xsl:template match="mods:titleInfo[@type = 'alternative'][not(@displayLabel = 'Uncontrolled title')]">
        <xsl:call-template name="field">
            <xsl:with-param name="name">alt-title</xsl:with-param>
            <xsl:with-param name="data">
                <xsl:if test="@displayLabel">
                    <xsl:value-of select="@displayLabel"/>
                    <xsl:text>: </xsl:text>
                </xsl:if>
                <xsl:call-template name="title">
                    <xsl:with-param name="primary" select="false()"/>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Uncontrolled title -->
    <xsl:template match="mods:titleInfo[@type = 'alternative'][@displayLabel = 'Uncontrolled title']">
        <xsl:call-template name="field">
            <xsl:with-param name="name">other-title</xsl:with-param>
            <xsl:with-param name="data">
                <xsl:call-template name="title">
                    <xsl:with-param name="primary" select="false()"/>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <!-- Uniform title -->
    <xsl:template match="mods:titleInfo[@type = 'uniform']">
        <xsl:call-template name="field">
            <xsl:with-param name="name">uniform-title</xsl:with-param>
            <xsl:with-param name="data">
                <xsl:call-template name="title">
                    <xsl:with-param name="primary" select="false()"/>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Name -->
    <xsl:template match="mods:name">
        <xsl:call-template name="field">
            <xsl:with-param name="name">name</xsl:with-param>
            <xsl:with-param name="data">
                <xsl:call-template name="name"/>
            </xsl:with-param>
        </xsl:call-template>
        <!-- FACET (without roleTerm) -->
        <xsl:call-template name="field">
            <xsl:with-param name="name">name-facet</xsl:with-param>
            <xsl:with-param name="data">
                <xsl:call-template name="name">
                    <xsl:with-param name="roles" select="false()"/>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Content type -->
    <xsl:template match="mods:genre[@type = 'content']">
        <xsl:call-template name="field">
            <xsl:with-param name="name">content-type</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Genre -->
    <xsl:template match="mods:genre[not(@type = 'content')][not(. = preceding-sibling::mods:genre)]">
        <xsl:call-template name="field">
            <xsl:with-param name="name">genre</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- FACET -->
    <!-- MARC genre term (facet-only) -->
    <xsl:template match="mods:genre[@authority = 'marcgt']" mode="marcgt">
        <xsl:call-template name="field">
            <xsl:with-param name="name">genre-marcgt</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="mods:originInfo">
        <!-- Digital publication -->
        <xsl:call-template name="field">
            <xsl:with-param name="name">digital-publication</xsl:with-param>
            <xsl:with-param name="data">
                <xsl:call-template name="publication"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates select="mods:dateIssued"/>
        <xsl:apply-templates select="mods:edition"/>
    </xsl:template>

    <!-- Digital publication date (facet-only) -->
    <!-- FACET -->
    <xsl:template match="mods:dateIssued">
        <xsl:call-template name="date-field">
            <xsl:with-param name="name">digital-publication-date</xsl:with-param>
            <xsl:with-param name="data">
                <xsl:call-template name="dateIssued">
                    <xsl:with-param name="date-field" select="true()"/>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Edition -->
    <xsl:template match="mods:edition">
        <xsl:call-template name="field">
            <xsl:with-param name="name">edition</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Language -->
    <xsl:template match="mods:language">
        <xsl:call-template name="field">
            <xsl:with-param name="name">language</xsl:with-param>
            <xsl:with-param name="data"
                select="
                    if (@objectPart)
                    then
                        concat(mods:languageTerm[@type = 'text'], ' (', @objectPart, ')')
                    else
                        mods:languageTerm[@type = 'text']"
            />
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="mods:physicalDescription">
        <xsl:apply-templates select="mods:extent | mods:note[@type = 'other physical details']"/>
    </xsl:template>

    <xsl:template match="mods:physicalDescription" mode="secondaryPhysical">
        <xsl:apply-templates select="mods:internetMediaType | mods:digitalOrigin"/>
    </xsl:template>

    <!-- Extent -->
    <xsl:template match="mods:extent">
        <xsl:call-template name="field">
            <xsl:with-param name="name">extent</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Other physical details -->
    <xsl:template match="mods:note[@type = 'other physical details']">
        <xsl:call-template name="field">
            <xsl:with-param name="name">other-physical-details</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- File type -->
    <xsl:template match="mods:internetMediaType">
        <xsl:call-template name="field">
            <xsl:with-param name="name">mime-type</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Digital origin -->
    <xsl:template match="mods:digitalOrigin">
        <xsl:call-template name="field">
            <xsl:with-param name="name">digital-origin</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Summary -->
    <xsl:template match="mods:abstract[not(@shareable = 'no')]">
        <xsl:call-template name="field">
            <xsl:with-param name="name">summary</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Table of contents -->
    <xsl:template match="mods:tableOfContents">
        <xsl:call-template name="field">
            <xsl:with-param name="name">contents</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Thesis note -->
    <xsl:template match="mods:note[@type = 'thesis']">
        <xsl:call-template name="field">
            <xsl:with-param name="name">thesis-note</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Funding note -->
    <xsl:template match="mods:note[@type = 'funding']">
        <xsl:call-template name="field">
            <xsl:with-param name="name">funding-note</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <!-- Cast note -->
    <xsl:template match="mods:note[@type = 'performers']">
        <xsl:call-template name="field">
            <xsl:with-param name="name">cast-note</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <!-- Credits note -->
    <xsl:template match="mods:note[@type = 'creation/production credits']">
        <xsl:call-template name="field">
            <xsl:with-param name="name">credits-note</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <!-- Language note -->
    <xsl:template match="mods:note[@type = 'language']">
        <xsl:call-template name="field">
            <xsl:with-param name="name">language-note</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <!-- Numbering peculiarities note -->
    <xsl:template match="mods:note[@type = 'numbering']">
        <xsl:call-template name="field">
            <xsl:with-param name="name">numbering-note</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <!-- Event note -->
    <xsl:template match="mods:note[@type = 'venue']">
        <xsl:call-template name="field">
            <xsl:with-param name="name">event-note</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <!-- Accessibility note -->
    <xsl:template match="mods:note[@type = 'accessibility']">
        <xsl:call-template name="field">
            <xsl:with-param name="name">accessibility-note</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- General note -->
    <xsl:template match="mods:note[not(@type)][parent::mods:mods]">
        <xsl:call-template name="field">
            <xsl:with-param name="name">note</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Subject (topical) -->
    <!-- FACET -->
    <xsl:template match="mods:subject[@*][not(@authority = 'local') and local-name(*[1]) = 'topic']">
        <xsl:call-template name="field">
            <xsl:with-param name="name">subject-topical</xsl:with-param>
            <xsl:with-param name="data">
                <xsl:value-of select="string-join(*[not(self::mods:geographicCode)], ' -- ')"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <!-- Subject (topical), local -->
    <xsl:template match="mods:subject[@*][@authority = 'local' and @authorityURI = 'http://www.dartmouth.edu/~library/catmet/stoiber-subject']">
        <xsl:call-template name="field">
            <xsl:with-param name="name">stoiber-subject</xsl:with-param>
            <xsl:with-param name="data">
                <xsl:value-of select="mods:topic"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="mods:subject[@*][@authority = 'local' and @authorityURI = 'http://www.dartmouth.edu/~library/catmet/stoiber-feature']">
        <xsl:call-template name="field">
            <xsl:with-param name="name">stoiber-feature</xsl:with-param>
            <xsl:with-param name="data">
                <xsl:value-of select="mods:topic"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="mods:subject[@*][@authority = 'local' and @authorityURI = 'http://www.dartmouth.edu/~library/catmet/perry-biographical-period']">
        <xsl:call-template name="field">
            <xsl:with-param name="name">perry-biographical-period</xsl:with-param>
            <xsl:with-param name="data">
                <xsl:value-of select="mods:topic"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="mods:subject[@*][@authority = 'local' and @authorityURI = 'http://www.dartmouth.edu/~library/catmet/perry-subject']">
        <xsl:call-template name="field">
            <xsl:with-param name="name">perry-subject</xsl:with-param>
            <xsl:with-param name="data">
                <xsl:value-of select="mods:topic"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="mods:subject[@*][@authority = 'local' and @authorityURI = 'http://www.dartmouth.edu/~library/catmet/perry-remembered']">
        <xsl:call-template name="field">
            <xsl:with-param name="name">perry-remembered</xsl:with-param>
            <xsl:with-param name="data">
                <xsl:value-of select="mods:topic"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Subject (title) -->
    <!-- FACET -->
    <xsl:template match="mods:subject[not(@authority = 'local') and local-name(*[1]) = 'titleInfo']">
        <xsl:call-template name="field">
            <xsl:with-param name="name">subject-title</xsl:with-param>
            <xsl:with-param name="data">
                <xsl:for-each select="mods:titleInfo">
                    <xsl:call-template name="title"/>
                </xsl:for-each>
                <xsl:if test="*[position() > 1]">
                    <xsl:text> -- </xsl:text>
                    <xsl:value-of select="string-join(*[position() > 1][not(self::mods:geographicCode)], ' -- ')"/>
                </xsl:if>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Subject (name) -->
    <!-- FACET -->
    <xsl:template match="mods:subject[not(@authority = 'local') and local-name(*[1]) = 'name']">
        <xsl:call-template name="field">
            <xsl:with-param name="name">subject-name</xsl:with-param>
            <xsl:with-param name="data">
                <xsl:for-each select="mods:name">
                    <xsl:call-template name="name"/>
                </xsl:for-each>
                <xsl:if test="*[position() > 1]">
                    <xsl:text> -- </xsl:text>
                    <xsl:value-of select="string-join(*[position() > 1][not(self::mods:geographicCode)], ' -- ')"/>
                </xsl:if>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Subject (geographic) -->
    <!-- FACET -->
    <xsl:template match="mods:subject[not(@authority = 'local') and local-name(*[1]) = 'geographic']">
        <xsl:call-template name="field">
            <xsl:with-param name="name">subject-geographic</xsl:with-param>
            <xsl:with-param name="data">
                <xsl:value-of select="string-join(*[not(self::mods:geographicCode)], ' -- ')"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Subject (hierarchical geographic) -->
    <!-- FACET -->
    <xsl:template match="mods:subject[not(@authority = 'local') and local-name(*[1]) = 'hierarchicalGeographic']">
        <xsl:call-template name="field">
            <xsl:with-param name="name">subject-geographic</xsl:with-param>
            <xsl:with-param name="data">
                <xsl:value-of select="string-join(mods:hierarchicalGeographic/*[not(self::mods:geographicCode)], ' -- ')"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:for-each select="mods:hierarchicalGeographic/*[local-name() = ('continent', 'country')]">
            <xsl:call-template name="field">
                <xsl:with-param name="name">subject-geographic-country</xsl:with-param>
                <xsl:with-param name="data">
                    <xsl:value-of select="."/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select="mods:hierarchicalGeographic/*[local-name() = ('city', 'state', 'province', 'area', 'island')]">
            <xsl:call-template name="field">
                <xsl:with-param name="name">subject-geographic-city</xsl:with-param>
                <xsl:with-param name="data">
                    <xsl:value-of select="."/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <!-- Subject (temporal) -->
    <!-- FACET -->
    <xsl:template match="mods:subject[@*][not(@authority = 'local') and local-name(*[1]) = 'temporal']">
        <xsl:call-template name="field">
            <xsl:with-param name="name">subject-chronological</xsl:with-param>
            <xsl:with-param name="data">
                <xsl:value-of select="string-join(*[not(self::mods:geographicCode)], ' -- ')"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="mods:cartographics">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- Scale -->
    <!-- FACET -->
    <xsl:template match="mods:scale">
        <xsl:call-template name="field">
            <xsl:with-param name="name">scale</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Coordinates -->
    <xsl:template match="mods:coordinates">
        <xsl:call-template name="field">
            <xsl:with-param name="name">coordinates</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Classification -->
    <xsl:template match="mods:classification">
        <xsl:call-template name="field">
            <xsl:with-param name="name">classification</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="mods:relatedItem[@type = 'host']">
        <xsl:apply-templates mode="host"/>
    </xsl:template>

    <!-- Collection -->
    <xsl:template match="mods:titleInfo" mode="host">
        <xsl:call-template name="field">
            <xsl:with-param name="name">collection</xsl:with-param>
            <xsl:with-param name="data">
                <xsl:call-template name="title"/>
            </xsl:with-param>
        </xsl:call-template>
        <!-- Subcollection -->
        <xsl:if test="../mods:part/mods:text">
            <xsl:call-template name="field">
                <xsl:with-param name="name">subcollection</xsl:with-param>
                <xsl:with-param name="data">
                    <xsl:value-of select="../mods:part/mods:text"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Related item (other format or original) -->
    <xsl:template match="mods:relatedItem[@type = ('otherFormat', 'original')]">
        <xsl:apply-templates select="
                mods:originInfo[(.//mods:dateIssued | .//mods:dateCreated)[@encoding = 'w3cdtf']]" mode="dateOfWork"/>
        <xsl:choose>
            <xsl:when test="mods:originInfo[@eventType = 'publication']">
                <!-- Original publication -->
                <xsl:call-template name="field">
                    <xsl:with-param name="name">original-publication</xsl:with-param>
                    <xsl:with-param name="data">
                        <xsl:call-template name="related-item"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- Original production -->
                <xsl:call-template name="field">
                    <xsl:with-param name="name">original-production</xsl:with-param>
                    <xsl:with-param name="data">
                        <xsl:call-template name="related-item"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="mods:classification|mods:location[mods:holdingSimple/mods:copyInformation/mods:shelfLocator]"
            mode="shelfLocation"/>
    </xsl:template>
    
    <xsl:template name="related-item">
        <xsl:apply-templates mode="relatedItem"/>
    </xsl:template>
    
    <xsl:template match="mods:titleInfo" mode="relatedItem">
        <xsl:call-template name="title"/>
        <xsl:if test="not(ends-with(mods:title, '.'))">
            <xsl:text>.</xsl:text>
        </xsl:if>
        <xsl:if test="following-sibling::mods:originInfo">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="mods:originInfo" mode="relatedItem">
        <xsl:call-template name="publication" />
        <xsl:if test="following-sibling::mods:recordInfo[mods:recordIdentifier[@source='OCoLC'][matches(., '\d+')]]">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="mods:recordInfo[mods:recordIdentifier[@source='OCoLC'][matches(., '\d+')]]" mode="relatedItem">
        <xsl:text>(OCoLC)</xsl:text>
        <xsl:value-of select="xs:integer(replace(mods:recordIdentifier[@source='OCoLC'], 'on|ocn|ocm', ''))"/>
    </xsl:template>

    <xsl:template match="mods:originInfo" mode="dateOfWork">
        <xsl:apply-templates mode="dateOfWork"/>
    </xsl:template>

    <!-- Date of work -->
    <!-- FACET -->
    <xsl:template match="*[(mods:dateIssued | mods:dateCreated)[@encoding = 'w3cdtf'][not(@point = 'end')]]" mode="dateOfWork">
        <xsl:call-template name="date-field-with-attrs">
            <xsl:with-param name="name" select="'date-of-work'"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- Shelf location -->
    <xsl:template match="mods:classification" mode="shelfLocation">
        <xsl:call-template name="field">
            <xsl:with-param name="name">shelf-location</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="mods:location[mods:holdingSimple/mods:copyInformation/mods:shelfLocator]" mode="shelfLocation">
        <xsl:call-template name="field">
            <xsl:with-param name="name">shelf-location</xsl:with-param>
            <xsl:with-param name="data" select="string-join(mods:holdingSimple/mods:copyInformation/mods:shelfLocator, ', ')"/>
        </xsl:call-template>
    </xsl:template>

    <!-- Identifier -->
    <xsl:template match="mods:identifier[@type = 'local'][not(@invalid)]">
        <xsl:call-template name="field">
            <xsl:with-param name="name">identifier</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="mods:identifier[@type = 'kaltura'][not(@invalid)]">
        <xsl:call-template name="field">
            <xsl:with-param name="name">kaltura-id</xsl:with-param>
        </xsl:call-template>        
    </xsl:template>

    <!-- Permalink -->
    <xsl:template match="mods:identifier[@type = ('doi', 'ark')][not(@invalid)]">
        <xsl:call-template name="field">
            <xsl:with-param name="name">persistent-identifier</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Standardized rights statement -->
    <xsl:template match="mods:accessCondition[@type = 'use and reproduction'][@displayLabel = 'Standardized rights statement']">
        <xsl:call-template name="field">
            <xsl:with-param name="name">standardized-rights-statement</xsl:with-param>
            <xsl:with-param name="data" select="concat(., ' ', @xlink:href)"/>
        </xsl:call-template>
        <!-- FACET -->
        <xsl:call-template name="field">
            <xsl:with-param name="name">standardized-rights-label</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Rights holder -->
    <xsl:template match="cmd:copyright">
        <xsl:for-each select="cmd:rights.holder/cmd:name[text()]">
            <xsl:call-template name="field">
                <xsl:with-param name="name">rights-holder</xsl:with-param> 
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <!-- Rights statement -->
    <xsl:template match="mods:accessCondition[@type = 'use and reproduction'][not(@displayLabel)]">
        <xsl:call-template name="field">
            <xsl:with-param name="name">rights-statement</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <!-- Embargo -->
    <xsl:template match="mods:accessCondition[@type = 'restriction on access']">
        <xsl:where-populated>
            <xsl:attribute name="embargo">
                <xsl:analyze-string select="." regex="(\d{{2}})/(\d{{2}})/(\d{{4}})">
                    <xsl:matching-substring>
                        <xsl:value-of select="xs:date(string-join((regex-group(3), regex-group(1), regex-group(2)), '-'))"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:attribute>
        </xsl:where-populated>
    </xsl:template>

    <xsl:template match="mods:recordInfo">
        <xsl:apply-templates />
    </xsl:template>

    <!-- Suppressed record.  Presence of the suppressed note indicates the record is to be suppressed except for access information -->
    <xsl:template match="mods:recordInfoNote[@type='suppressed']" mode="suppress">
        <xsl:attribute name="suppressed" select="true()"/>
    </xsl:template>
    
    
    <!-- Record identifier -->
    <xsl:template match="mods:recordIdentifier">
        <xsl:call-template name="field">
            <xsl:with-param name="name">record-identifier</xsl:with-param>
            <xsl:with-param name="data" select="concat('(', @source, ')', .)"/>
        </xsl:call-template>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            Copy each filename from a drb:filename element into the DEBII page list.
        </xd:desc>
    </xd:doc>
    <xsl:template match="mods:extension" mode="extension">
        <pages>
            <xsl:for-each select="drb:filename[@type = 'master']">
                <page>
                    <xsl:attribute name="name" select="tokenize(., '\.[a-z0-9]{3}')[1]"/>
                </page>
            </xsl:for-each>
        </pages>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            Generalized processing for titles.
        </xd:desc>
    </xd:doc>
    <xsl:template name="title">
        <xsl:param name="primary" as="xs:boolean" select="false()"/>
        <xsl:where-populated>
            <xsl:value-of select="mods:nonSort"/>
        </xsl:where-populated>
        <xsl:value-of select="mods:title"/>
        <xsl:for-each select="mods:subTitle">
            <xsl:text> : </xsl:text>
            <xsl:value-of select="."/>
        </xsl:for-each>
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
        <xsl:if test="$primary">
            <xsl:for-each select="../mods:note[@type = 'statement of responsibility']">
                <xsl:text> / </xsl:text>
                <xsl:value-of select="."/>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            Generalized processing for names.
        </xd:desc>
    </xd:doc>
    <xsl:template name="name">
        <xsl:param name="roles" as="xs:boolean" select="true()"/>
        <xsl:choose>
            <xsl:when test="@type = 'personal'">
                <xsl:choose>
                    <xsl:when test="@lang = 'chi'">
                        <xsl:value-of select="string-join(mods:description | mods:termsOfAddress | mods:namePart[not(@type = 'given'[2])], '')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="string-join(mods:description | mods:termsOfAddress | mods:namePart[not(@type = 'given'[2])], ', ')"/>
                    </xsl:otherwise>
                </xsl:choose>
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
        <xsl:if test="mods:role/mods:roleTerm[@type = 'text'] and $roles">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="string-join(mods:role/mods:roleTerm[@type = 'text'], ', ')"/>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            Generalized processing for publication statements.
        </xd:desc>
    </xd:doc>
    <xsl:template name="publication">
        <xsl:if test="../@displayLabel">
            <xsl:value-of select="concat(../@displayLabel, ' ')"/>
        </xsl:if>
        <xsl:for-each select="mods:place/mods:placeTerm[@type = 'text']">
            <xsl:choose>
                <xsl:when test="../@supplied = 'yes'">
                    <xsl:text>[</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>]</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="../../mods:publisher">
                    <xsl:text> : </xsl:text>
                </xsl:when>
                <xsl:when test="../../(mods:dateIssued | mods:dateCreated)[not(@encoding = 'fast')]">
                    <xsl:text>, </xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="mods:publisher">
            <xsl:choose>
                <xsl:when test="@supplied = 'yes'">
                    <xsl:text>[</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>]</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="../(mods:dateIssued | mods:dateCreated)[not(@encoding = 'fast')]">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:choose>
            <xsl:when test="(mods:dateIssued | mods:dateCreated)[@encoding = 'marc'] and 
                not((mods:dateIssued | mods:dateCreated)[@encoding = 'w3cdtf'])">
                <xsl:value-of select="(mods:dateIssued | mods:dateCreated)[@encoding = 'marc']"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="(mods:dateIssued | mods:dateCreated)[not(@point = 'end')][@encoding][not(@encoding = ('fast', 'marc'))]">
                    <xsl:if test="@drb:supplied = 'yes' or @qualifier = ('questionable', 'inferred')">
                        <xsl:text>[</xsl:text>
                    </xsl:if>
                    <xsl:value-of select="."/>
                    <xsl:if test="../(mods:dateIssued | mods:dateCreated)[@point = 'end'][@encoding][not(@encoding = ('fast', 'marc'))]">
                        <xsl:variable name="intervalDesignator">
                            <xsl:choose>
                                <xsl:when test="contains(., '-')">/</xsl:when> <!-- ISO 8601 -->
                                <xsl:otherwise>-</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:value-of select="$intervalDesignator"/>
                        <xsl:value-of select="../(mods:dateIssued | mods:dateCreated)[@point = 'end'][@encoding][not(@encoding = ('fast', 'marc'))]"/>
                    </xsl:if>
                    <xsl:if test="@qualifier = 'questionable'">?</xsl:if>
                    <xsl:if test="@drb:supplied = 'yes' or @qualifier = ('questionable', 'inferred')">
                        <xsl:text>]</xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>
            Generalized processing for publication dates.
        </xd:desc>
    </xd:doc>
    <xsl:template name="dateIssued">
        <xsl:param name="date-field" as="xs:boolean" select="false()"/>
        <xsl:variable name="text">
            <xsl:for-each select="../mods:dateIssued[not(@point = 'end')][not(@encoding = 'fast')]">
                <xsl:if test="@drb:supplied = 'yes' or @qualifier = ('questionable', 'inferred')">
                    <xsl:text>[</xsl:text>
                </xsl:if>
                <xsl:value-of select="."/>
                <xsl:if test="@qualifier = 'questionable'">?</xsl:if>
                <xsl:if test="../mods:dateIssued[@point = 'end']">
                    - <xsl:value-of select="../mods:dateIssued[@point = 'end']"/>
                </xsl:if>
                <xsl:if test="@drb:supplied = 'yes' or @qualifier = ('questionable', 'inferred')">
                    <xsl:text>]</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        
        <!-- TODO -->
        <xsl:value-of select="$text"/>
        <!--<xsl:choose>
            <xsl:when test="$date-field">
                <xsl:variable name="range">
                    <xsl:analyze-string select="$text" regex="([0-9u]{{4}}(-[0-9u]{{2}}){{0,2}})(-[0-9u]{{4}}(-[0-9u]{{2}}){{0,2}})?">
                        <xsl:matching-substring>
                            <xsl:sequence select="(regex-group(1), regex-group(3))"/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:variable>                
                <xsl:variable name="from" select="$range[1]"/>
                <xsl:variable name="to" select="$range[2]"/>
                <xsl:sequence select="($text, $from, $to)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>-->
    </xsl:template>
    
    <xd:doc>
        <xd:desc>
            Generalized processing for date of work, normalized for range facet and sorting.
        </xd:desc>
    </xd:doc>
    <xsl:template name="dateOfWork">
        <xsl:for-each select="../(mods:dateIssued | mods:dateCreated)[@encoding = 'w3cdtf'][not(@point = 'end')]">
            <xsl:value-of select="."/>
            <xsl:if test="../(mods:dateIssued | mods:dateCreated)[@encoding = 'w3cdtf'][@point = 'end']">
                <xsl:text>-</xsl:text>
                <xsl:value-of select="../(mods:dateIssued | mods:dateCreated)[@encoding = 'w3cdtf'][@point = 'end']"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:function name="lfn:datesToString" as="xs:string">
        <xsl:param name="start" as="xs:string"/>
        <xsl:param name="end" as="xs:string?"/>
        
        <xsl:sequence select="concat($start, if (exists($end)) then '-' else (), $end)"/>     
    </xsl:function>
    
    <xd:doc>
        <xd:desc>
            Generate item-level formatted citation.
            See display in other digital library systems:
            https://dp.la/item/1ea69ae7c31bdf0a994ec170bec65309
            https://digitalcollections.nypl.org/items/77b66f97-69a5-69f9-e040-e00a180669e1
        </xd:desc>
    </xd:doc>
    <xsl:template name="citations">
        
        <!-- variables for use in each citation format -->
        <xsl:variable name="name">
            <xsl:choose>
                <xsl:when test="mods:name[@usage = 'primary']">
                    <xsl:for-each select="mods:name[@usage = 'primary']">
                        <xsl:call-template name="name">
                            <xsl:with-param name="roles" select="mods:role/mods:roleTerm = ('author', 'creator')" />
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="mods:name[1]/mods:namePart = 'Dartmouth Digital Library Program'"/>
                <xsl:otherwise>
                    <xsl:for-each select="mods:name[1]">
                        <xsl:call-template name="name">
                            <xsl:with-param name="roles" select="mods:role/mods:roleTerm = ('author', 'creator')" />
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="title">
            <xsl:for-each select="mods:titleInfo[not(@type)]">
                <xsl:call-template name="title"/>
            </xsl:for-each>
        </xsl:variable>
        
        <xsl:variable name="collection">
            <xsl:for-each select="mods:relatedItem[@type = 'host']/mods:titleInfo[not(@type)]">
                <xsl:call-template name="title"/>
            </xsl:for-each>
        </xsl:variable>
        
        <xsl:variable name="date">
            <xsl:variable name="dateOfWork">
                <xsl:choose>
                    <xsl:when test="mods:relatedItem[@type = ('otherFormat', 'original')]/mods:originInfo/*[@encoding = 'w3cdtf']">
                        <xsl:for-each select="mods:relatedItem[@type = ('otherFormat', 'original')]/mods:originInfo/(mods:dateIssued | mods:dateCreated)[@encoding = 'w3cdtf'][not(@point = 'end')]">
                            <xsl:call-template name="dateOfWork"/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="mods:originInfo/*[@keyDate]">
                            <xsl:call-template name="dateIssued"/>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <xsl:analyze-string select="$dateOfWork" regex="^((\d{{4}})(-\d{{4}})?)">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(2)"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        
        <xsl:variable name="url">
            <xsl:choose>
                <xsl:when test="mods:identifier[@type = ('doi', 'ark')][not(@invalid)] ne ''">
                    <xsl:value-of select="mods:identifier[@type = ('doi', 'ark')][not(@invalid)]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="mods:location/mods:url[@usage='primary']"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <!-- MLA -->
        <xsl:call-template name="field">
            <xsl:with-param name="name">citation-mla</xsl:with-param>
            <xsl:with-param name="data">
                <xsl:if test="$name ne ''">
                    <xsl:value-of select="$name"/>
                    <xsl:if test="not(ends-with($name, '.'))">
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:text>"</xsl:text>
                <xsl:value-of select="$title"/>
                <xsl:if test="not(ends-with($title, '.'))">
                    <xsl:text>.</xsl:text>
                </xsl:if>
                <xsl:text>" </xsl:text>
                <xsl:value-of select="$collection"/>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="$date"/>
                <xsl:text>. </xsl:text>
                <em>Dartmouth Digital Library Program</em>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="substring-after($url, '//')"/>
                <xsl:text>.</xsl:text>
            </xsl:with-param>
        </xsl:call-template>
        
        <!-- Chicago -->
        <xsl:call-template name="field">
            <xsl:with-param name="name">citation-chicago</xsl:with-param>
            <xsl:with-param name="data">
                <xsl:if test="$name ne ''">
                    <xsl:value-of select="$name"/>
                    <xsl:if test="not(ends-with($name, '.'))">
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:value-of select="$title"/>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="$date"/>
                <xsl:text>. </xsl:text>
                <em>Dartmouth Digital Library Program</em>
                <xsl:text>. </xsl:text>
                <xsl:value-of select="$url"/>
                <xsl:text>.</xsl:text>
            </xsl:with-param>
        </xsl:call-template>
        
        <!-- APA -->
        <!--<xsl:call-template name="field">
            <xsl:with-param name="name">citation-apa</xsl:with-param>
            <xsl:with-param name="label">Citation (APA Format)</xsl:with-param>
            <xsl:with-param name="dcmes"/>
            <xsl:with-param name="data">
                <xsl:value-of select="$name"/>
                <xsl:if test="not(ends-with($name, '.'))">
                    <xsl:text>.</xsl:text>
                </xsl:if>
                <xsl:text> "</xsl:text>
                <xsl:value-of select="$title"/>
                <xsl:if test="not(ends-with($title, '.'))">
                    <xsl:text>.</xsl:text>
                </xsl:if>
                <xsl:text>" </xsl:text>
                <xsl:value-of select="$collection"/>
                <xsl:text>. </xsl:text>
                <xsl:text>Dartmouth Digital Library Program, </xsl:text>
                <xsl:value-of select="$date"/>
                <xsl:text>, </xsl:text>
                <xsl:text>Retrieved from </xsl:text>
                <xsl:value-of select="$permalink"/>
            </xsl:with-param>
        </xsl:call-template>-->
        
    </xsl:template>

    <xd:doc>
        <xd:desc>
            Capitalize the first letter of an input string.
        </xd:desc>
    </xd:doc>
    <xsl:function name="lfn:capitalize">
        <xsl:param name="s"/>
        <xsl:sequence select="concat(upper-case(substring($s, 1, 1)), substring($s, 2))"/>
    </xsl:function>

</xsl:stylesheet>
