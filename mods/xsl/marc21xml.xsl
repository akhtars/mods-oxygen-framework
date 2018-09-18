<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xlink="http://www.w3.org/1999/xlink" 
	xmlns:mods="http://www.loc.gov/mods/v3"	
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:drb="http://www.dartmouth.edu/~library/catmet/"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:lfn="localfunctions"
	exclude-result-prefixes="mods xlink drb lfn" 
	xmlns:marc="http://www.loc.gov/MARC21/slim">
<!-- 
	Modified from LC stylesheet - 2013 SA
	Original at http://www.loc.gov/standards/mods/v3/MODS3-4_MARC21slim_XSLT2-0.xsl
-->

	<xsl:include href="http://www.loc.gov/standards/marcxml/xslt/MARC21slimUtils.xsl"/>
	
	<xsl:include href="local-functions.xsl"/> <!-- SA add 2017-11-28; TODO: remove external dependency -->
	
	<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
	
	<xsl:strip-space elements="*"/> <!-- SA addition 2013-10-21 -->
	
	<!-- SA change authority identifier from "marc" to "marcgt" 2015-03-25 -->
	
	<xsl:template match="/">
		<xsl:result-document>
			<xsl:apply-templates/>
		</xsl:result-document>
	</xsl:template>

	<xsl:template match="mods:modsCollection">
		<marc:collection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">
			<xsl:apply-templates/>
		</marc:collection>
	</xsl:template>
	<!-- 1/04 fix -->
	<!--<xsl:template match="mods:targetAudience/mods:listValue" mode="ctrl008">-->
	<xsl:template match="mods:targetAudience[@authority='marctarget']" mode="ctrl008">
		<xsl:choose>
		<xsl:when test=".='adolescent'">d</xsl:when>
		<xsl:when test=".='adult'">e</xsl:when>
		<xsl:when test=".='general'">g</xsl:when>
		<xsl:when test=".='juvenile'">j</xsl:when>
		<xsl:when test=".='preschool'">a</xsl:when>
		<xsl:when test=".='specialized'">f</xsl:when>
		<xsl:otherwise><xsl:text>|</xsl:text></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mods:typeOfResource" mode="leader">
		<xsl:choose>
			<xsl:when test="text()='text' and @manuscript='yes'">t</xsl:when> <!-- SA fix by reordering 2014-10-16 -->
			<xsl:when test="text()='text'">a</xsl:when>
			<xsl:when test="text()='cartographic' and @manuscript='yes'">f</xsl:when>
			<xsl:when test="text()='cartographic'">e</xsl:when>
			<xsl:when test="text()='notated music' and @manuscript='yes'">d</xsl:when>
			<xsl:when test="text()='notated music'">c</xsl:when>
			<!-- v3 musical/non -->
			<xsl:when test="text()='sound recording-nonmusical'">i</xsl:when>
			<xsl:when test="text()='sound recording'">j</xsl:when>
			<xsl:when test="text()='sound recording-musical'">j</xsl:when>
			<xsl:when test="text()='still image'">k</xsl:when>
			<xsl:when test="text()='moving image'">g</xsl:when>
			<xsl:when test="text()='three dimensional object'">r</xsl:when>
			<xsl:when test="text()='software, multimedia'">m</xsl:when>
			<xsl:when test="text()='mixed material'">p</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mods:typeOfResource" mode="ctrl008">
		<xsl:choose>
			<xsl:when test="text()='text' and @manuscript='yes'">BK</xsl:when>
			<xsl:when test="text()='text'">
			<xsl:choose> <!-- SA add tests for subcategories 2016-05-16 -->
				<xsl:when test="../mods:originInfo/mods:issuance='monographic'">BK</xsl:when>
				<xsl:when test="../mods:originInfo/mods:issuance='single unit'">BK</xsl:when>
				<xsl:when test="../mods:originInfo/mods:issuance='multipart monograph'">BK</xsl:when>
				<xsl:when test="../mods:originInfo/mods:issuance='continuing'">SE</xsl:when>
				<xsl:when test="../mods:originInfo/mods:issuance='serial'">SE</xsl:when>
				<xsl:when test="../mods:originInfo/mods:issuance='integrating resource'">SE</xsl:when>
			</xsl:choose>
			</xsl:when>
			<xsl:when test="text()='cartographic' and @manuscript='yes'">MP</xsl:when>
			<xsl:when test="text()='cartographic'">MP</xsl:when>
			<xsl:when test="text()='notated music' and @manuscript='yes'">MU</xsl:when>
			<xsl:when test="text()='notated music'">MU</xsl:when>
			<xsl:when test="text()='sound recording'">MU</xsl:when>
			<!-- v3 musical/non -->
			<xsl:when test="text()='sound recording-nonmusical'">MU</xsl:when>
			<xsl:when test="text()='sound recording-musical'">MU</xsl:when>
			<xsl:when test="text()='still image'">VM</xsl:when>
			<xsl:when test="text()='moving image'">VM</xsl:when>
			<xsl:when test="text()='three dimensional object'">VM</xsl:when>
			<xsl:when test="text()='software, multimedia'">CF</xsl:when>
			<xsl:when test="text()='mixed material'">MM</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="controlField008-24-27">
		<xsl:variable name="chars">
			<xsl:for-each select="mods:genre[@authority='marcgt']">
				<xsl:choose>
					<xsl:when test=".='abstract of summary'">a</xsl:when>
					<xsl:when test=".='bibliography'">b</xsl:when>
					<xsl:when test=".='catalog'">c</xsl:when>
					<xsl:when test=".='dictionary'">d</xsl:when>
					<xsl:when test=".='directory'">r</xsl:when>
					<xsl:when test=".='discography'">k</xsl:when>
					<xsl:when test=".='encyclopedia'">e</xsl:when>
					<xsl:when test=".='filmography'">q</xsl:when>
					<xsl:when test=".='handbook'">f</xsl:when>
					<xsl:when test=".='index'">i</xsl:when>
					<xsl:when test=".='law report or digest'">w</xsl:when>
					<xsl:when test=".='legal article'">g</xsl:when>
					<xsl:when test=".='legal case and case notes'">v</xsl:when>
					<xsl:when test=".='legislation'">l</xsl:when>
					<xsl:when test=".='patent'">j</xsl:when>
					<xsl:when test=".='programmed text'">p</xsl:when>
					<xsl:when test=".='review'">o</xsl:when>
					<xsl:when test=".='standard or specification'">u</xsl:when> <!-- SA add 2018-01-08 -->
					<xsl:when test=".='statistics'">s</xsl:when>
					<xsl:when test=".='survey of literature'">n</xsl:when>
					<xsl:when test=".='technical report'">t</xsl:when>
					<xsl:when test=".='thesis'">m</xsl:when> <!-- SA fix 2015-04-02 -->
					<xsl:when test=".='treaty'">z</xsl:when>
				</xsl:choose>
			</xsl:for-each>
			<!-- SA change 2015-04-02, 2016-08-16 -->
			<xsl:if test="mods:note[@type='bibliography'] and not(mods:genre = 'bibliography')">b</xsl:if>
		</xsl:variable>
		<xsl:call-template name="makeSize">
			<xsl:with-param name="string" select="$chars"/>
			<xsl:with-param name="length" select="4"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="controlField008-30-31">
		<xsl:variable name="chars">
			<xsl:for-each select="mods:genre[@authority='marcgt']">
				<xsl:choose>
					<xsl:when test=".='biography'">b</xsl:when>
					<xsl:when test=".='conference publication'">c</xsl:when>
					<xsl:when test=".='drama'">d</xsl:when>
					<xsl:when test=".='essay'">e</xsl:when>
					<xsl:when test=".='fiction'">f</xsl:when>
					<xsl:when test=".='folktale'">o</xsl:when>
					<xsl:when test=".='history'">h</xsl:when>
					<xsl:when test=".='humor, satire'">k</xsl:when>
					<xsl:when test=".='instruction'">i</xsl:when>
					<xsl:when test=".='interview'">t</xsl:when>
					<xsl:when test=".='language instruction'">j</xsl:when>
					<xsl:when test=".='memoir'">m</xsl:when>
					<xsl:when test=".='rehersal'">r</xsl:when>
					<xsl:when test=".='reporting'">g</xsl:when>
					<xsl:when test=".='sound'">s</xsl:when>
					<xsl:when test=".='speech'">l</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<xsl:call-template name="makeSize">
			<xsl:with-param name="string" select="$chars"/>
			<xsl:with-param name="length" select="2"/>
			<xsl:with-param name="spacer">
				<xsl:text>|</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="makeSize">
		<xsl:param name="string"/>
		<xsl:param name="length"/>
		<xsl:param name="spacer"> <!-- SA add config option for choosing blank or fill 2016-03-21 -->
			<xsl:text> </xsl:text>
		</xsl:param>
		<xsl:variable name="nstring" select="normalize-space($string)"/>
		<xsl:variable name="nstringlength" select="string-length($nstring)"/>
		<xsl:choose>
			<xsl:when test="$nstringlength&gt;$length">
				<xsl:value-of select="substring($nstring,1,$length)"/>
			</xsl:when>
			<xsl:when test="$nstringlength&lt;$length">
				<xsl:value-of select="$nstring"/>
				<xsl:call-template name="buildSpaces">
					<xsl:with-param name="spaces" select="$length - $nstringlength"/>
					<xsl:with-param name="char" select="$spacer"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$nstring"/>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>

	<xsl:template match="mods:mods">
		<marc:record>
			<marc:leader>
				<!-- 00-04 -->				
				<xsl:text>     </xsl:text>
				<!-- 05 --> <!-- SA change 2015-10-15, 2016-08-17 -->
				<xsl:choose>
					<xsl:when test="mods:recordInfo/mods:recordInfoNote[@type='modifying agency']">c</xsl:when>
					<xsl:otherwise>n</xsl:otherwise>
				</xsl:choose>
				<!-- 06 -->
				<xsl:apply-templates mode="leader" select="mods:typeOfResource[1]"/>
				<!-- 07 -->
				<xsl:choose>
					<xsl:when test="mods:originInfo/mods:issuance='monographic'">m</xsl:when>
					<xsl:when test="mods:originInfo/mods:issuance='continuing'">s</xsl:when>
					<!--<xsl:when test="mods:typeOfResource/@collection='yes'">i</xsl:when>--> <!-- SA disable 2016-05-16 -->
					<!-- v3.4 Added mapping for single unit, serial, integrating resource, multipart monograph  -->
					<xsl:when test="mods:originInfo/mods:issuance='multipart monograph'">m</xsl:when>
					<xsl:when test="mods:originInfo/mods:issuance='single unit'">m</xsl:when>
					<xsl:when test="mods:originInfo/mods:issuance='integrating resource'">i</xsl:when>
					<xsl:when test="mods:originInfo/mods:issuance='serial'">s</xsl:when>
					<xsl:otherwise>m</xsl:otherwise>
				</xsl:choose>
				<!-- 08 -->
				<xsl:text> </xsl:text>
				<!-- 09 -->
				<xsl:text> </xsl:text>
				<!-- 10 -->
				<xsl:text>2</xsl:text>
				<!-- 11 -->
				<xsl:text>2</xsl:text>
				<!-- 12-16 -->				
				<xsl:text>     </xsl:text>
				<!-- 17 -->
				<xsl:text>K</xsl:text> <!-- SA change 2014-10-08 -->
				<!-- 18 -->
				<xsl:choose><!-- SA change 2014-10-08 -->
					<xsl:when test="mods:recordInfo/mods:descriptionStandard='rda'">i</xsl:when>
					<xsl:when test="mods:recordInfo/mods:descriptionStandard='aacr'">a</xsl:when>
					<xsl:otherwise>u</xsl:otherwise>
				</xsl:choose>
				<!-- 19 -->				
				<xsl:text> </xsl:text>
				<!-- 20-23 -->
				<xsl:text>4500</xsl:text>
			</marc:leader>
			<xsl:call-template name="controlRecordInfo"/>
			<!-- SA enhance 2014-10-08 -->
			<xsl:choose>
				<xsl:when test="mods:genre[@authority='marcgt']='atlas'">
					<marc:controlfield tag="007">ad||||||</marc:controlfield>
				</xsl:when>
				<xsl:when test="mods:genre[@authority='marcgt']='model'">
					<marc:controlfield tag="007">aq||||||</marc:controlfield>
				</xsl:when>
				<xsl:when test="mods:genre[@authority='marcgt']='remote sensing image'">
					<marc:controlfield tag="007">ar||||||</marc:controlfield>
				</xsl:when>
				<xsl:when test="mods:genre[@authority='marcgt']='map'"> <!-- SA update 2017-07-26, 2018-02-20 -->
					<marc:controlfield tag="007">aj |zzz|</marc:controlfield>
				</xsl:when>
				<xsl:when test="mods:genre[@authority='marcgt']='globe'">
					<marc:controlfield tag="007">d|||||</marc:controlfield>
				</xsl:when>
			</xsl:choose>
			<!-- SA enhance 2016-03-21 to match OCLC standards -->
			<!-- SA update 2018-07-20 to check for RDA terms before creating 007 -->
			<xsl:if test="mods:physicalDescription/mods:form[@authority='rdamedia']='computer' and
				mods:physicalDescription/mods:form[@authority='rdacarrier']='online resource'">
				<!-- SA always create 007 with "cr" 2017-07-26 -->
				<marc:controlfield tag="007">
					<!-- 00 -->
					<xsl:text>c</xsl:text>
					<!-- 01 -->
					<xsl:text>r</xsl:text>
					<!-- 02 -->
					<xsl:text> </xsl:text>
					<!-- 03 -->
					<xsl:text>|</xsl:text>
					<!-- 04 -->
					<xsl:text>n</xsl:text>
					<!-- 05-13 -->
					<xsl:text>|||||||||</xsl:text>
				</marc:controlfield>
			</xsl:if>
			<marc:controlfield tag="008">
				<xsl:variable name="typeOf008"><xsl:apply-templates mode="ctrl008" select="mods:typeOfResource"/></xsl:variable>
				<!-- 00-05 -->	
				<xsl:choose>
					<!-- 1/04 fix --> <!-- SA update 2016-08-17 -->
					<xsl:when test="mods:recordInfo/mods:recordInfoNote[@type='date entered as MARC']">
						<xsl:value-of select="mods:recordInfo/mods:recordInfoNote[@type='date entered as MARC']"/>
					</xsl:when>
					<xsl:when test="mods:extension/drb:flag[@type='marc']/@created">
						<xsl:value-of select="mods:extension/drb:flag[@type='marc']/@created"/>
					</xsl:when>
					<xsl:otherwise> <!-- SA change 2015-05-25 -->
						<xsl:value-of select="format-date(current-date(), '[Y01][M01][D01]')"/>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 06 -->	<!-- SA rewrite to check for issuance subcategories 2016-05-16 -->
				<xsl:choose>
					<xsl:when test="matches(mods:originInfo/mods:issuance, '(monographic|single unit|multipart monograph)') and count(mods:originInfo/mods:dateIssued)=1">s</xsl:when>
					<!-- v3 questionable, SA update 2015-11-24 -->
					<xsl:when test="mods:originInfo/mods:dateIssued[@qualifier='questionable'][@point]">q</xsl:when>
					<xsl:when test="matches(mods:originInfo/mods:issuance, '(monographic|single unit|multipart monograph)') and mods:originInfo/mods:dateIssued[@point='start'] and mods:originInfo/mods:dateIssued[@point='end']">m</xsl:when>
					<xsl:when test="matches(mods:originInfo/mods:issuance, '(continuing|serial|integrating resource)') and mods:originInfo/mods:dateIssued[@point='end' and @encoding='marc']='9999'">c</xsl:when>
					<xsl:when test="matches(mods:originInfo/mods:issuance, '(continuing|serial|integrating resource)') and mods:originInfo/mods:dateIssued[@point='end' and @encoding='marc']='uuuu'">u</xsl:when>
					<xsl:when test="matches(mods:originInfo/mods:issuance, '(continuing|serial|integrating resource)') and mods:originInfo/mods:dateIssued[@point='end' and @encoding='marc']">d</xsl:when>
					<xsl:when test="not(mods:originInfo/mods:issuance) and mods:originInfo/mods:dateIssued">s</xsl:when>
					<!-- v3 copyright date-->
					<xsl:when test="mods:originInfo/mods:copyrightDate">s</xsl:when>
					<xsl:otherwise>|</xsl:otherwise>
				</xsl:choose>						
				<!-- 07-14          -->
				<!-- 07-10 -->
				<xsl:choose>
					<xsl:when test="mods:originInfo/mods:dateIssued[@point='start' and @encoding='marc']">
						<xsl:value-of select="mods:originInfo/mods:dateIssued[@point='start' and @encoding='marc']"/>
					</xsl:when>
					<xsl:when test="mods:originInfo/mods:dateIssued[@encoding='marc']">
						<xsl:value-of select="mods:originInfo/mods:dateIssued[@encoding='marc']"/>
					</xsl:when>
					<xsl:when test="mods:originInfo/mods:dateIssued[@encoding='w3cdtf']"> <!-- SA add 2014-10-13 -->
						<xsl:value-of select="substring(mods:originInfo/mods:dateIssued[@encoding='w3cdtf'], 1, 4)"/>
					</xsl:when>
					<xsl:otherwise>					
						<xsl:text>    </xsl:text>
					</xsl:otherwise>
				</xsl:choose>				
				<!-- 11-14 -->
				<xsl:choose>
					<xsl:when test="mods:originInfo/mods:dateIssued[@point='end' and @encoding='marc']">
						<xsl:value-of select="mods:originInfo/mods:dateIssued[@point='end' and @encoding='marc']"/>
					</xsl:when>					
					<xsl:otherwise>
						<xsl:text>    </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 15-17 -->	
				<xsl:choose>
					<!-- v3 place -->
					<xsl:when test="mods:originInfo/mods:place/mods:placeTerm[@type='code'][@authority='marccountry']">
						<!-- v3 fixed marc:code reference and authority change-->
						<xsl:value-of select="mods:originInfo/mods:place/mods:placeTerm[@type='code'][@authority='marccountry']"/>
						<!-- 1/04 fix -->
						<xsl:if test="string-length(mods:originInfo/mods:place/mods:placeTerm[@type='code'][@authority='marccountry'])=2">
							<xsl:text> </xsl:text>
						</xsl:if>					
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>xx </xsl:text> <!-- SA change 2014-10-13 -->
					</xsl:otherwise>
				</xsl:choose>
				<!-- 18-21 -->
				<xsl:choose>
					<!-- SA change 2016-03-18 to support illustration codes for books -->
					<xsl:when test="$typeOf008='BK'">
						<xsl:variable name="chars">
							<xsl:for-each select="tokenize(mods:physicalDescription/mods:note[@type='other physical details'],
								'(,| )')">
								<xsl:choose>
									<xsl:when test="matches(., 'illustration')">a</xsl:when>
									<xsl:when test="matches(., 'map')">b</xsl:when>
									<xsl:when test="matches(., 'portrait')">c</xsl:when>
									<xsl:when test="matches(., 'chart')">d</xsl:when>
									<xsl:when test="matches(., 'plan')">e</xsl:when>
									<xsl:when test="matches(., 'plate')">f</xsl:when>
									<xsl:when test="matches(., 'music')">g</xsl:when>
									<xsl:when test="matches(., 'facsimile')">h</xsl:when>
									<xsl:when test="matches(., 'coat(s)? of arms')">i</xsl:when>
									<xsl:when test="matches(., 'genealogical table')">j</xsl:when>
									<xsl:when test="matches(., 'form')">k</xsl:when>
									<xsl:when test="matches(., 'sample')">l</xsl:when>
									<xsl:when test="matches(., 'audio')">m</xsl:when>
									<xsl:when test="matches(., 'photograph')">o</xsl:when>
									<xsl:when test="matches(., 'illumination')">p</xsl:when>
								</xsl:choose>
							</xsl:for-each>
						</xsl:variable>
						<xsl:call-template name="makeSize">
							<xsl:with-param name="string" select="$chars"/>
							<xsl:with-param name="length" select="4"/>
						</xsl:call-template>
					</xsl:when>
					<!-- SA add 2018-03-14 to support relief information -->
					<xsl:when test="$typeOf008='MP'">
						<xsl:variable name="chars">
							<xsl:for-each select="tokenize(string-join(mods:note[not(@type)][not(contains(., 'inset'))], '.'),
								'(;|\.)')">
								<xsl:if test="matches(., 'contour', 'i')">a</xsl:if>
								<xsl:if test="matches(., 'tint', 'i')">c</xsl:if>
								<xsl:if test="matches(., 'hachure', 'i')">d</xsl:if>
								<xsl:if test="matches(., 'spot heights', 'i')">g</xsl:if>
								<xsl:if test="matches(., 'pictorial', 'i')">i</xsl:if>
							</xsl:for-each>
						</xsl:variable>
						<xsl:call-template name="makeSize">
							<!-- SA fix de-duplication 2018-05-30 -->
							<xsl:with-param name="string" select="string-join(distinct-values(
								for $i in string-to-codepoints($chars) return codepoints-to-string($i)), '')"/>
							<xsl:with-param name="length" select="4"/>
						</xsl:call-template>
					</xsl:when>
					<!-- SA add 2018-06-19 to support running time -->
					<xsl:when test="$typeOf008='VM'">
						<!-- 18-20 -->
						<xsl:choose>
							<xsl:when test="mods:genre[@authority='marcgt']=('motion picture', 'videorecording')">
								<xsl:analyze-string select="mods:physicalDescription/mods:extent" regex="(\d+) (min.|minutes)">
									<xsl:matching-substring>
										<xsl:choose>
											<xsl:when test="string-length(regex-group(1)) gt 3">
												<xsl:text>000</xsl:text>
											</xsl:when>
											<xsl:when test="string-length(regex-group(1)) ne 0">
												<xsl:value-of select="lfn:pad-zeroes(regex-group(1), 3)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>---</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:matching-substring>
								</xsl:analyze-string>
							</xsl:when>
							<xsl:otherwise>nnn</xsl:otherwise>
						</xsl:choose>
						<!-- 21 -->
						<xsl:text> </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<!-- SA change 2016-05-16 to support frequency, regularity for continuing resources -->
						<!-- 18-19 -->
						<xsl:choose>
							<xsl:when test="$typeOf008='SE'">
								<xsl:choose>
									<xsl:when test="mods:originInfo/mods:frequency[@authority='marcfrequency']=
										'Completely irregular'">#</xsl:when>
									<xsl:when test="mods:originInfo/mods:frequency[@authority='marcfrequency']=
										'Annual'">a</xsl:when>
									<xsl:when test="mods:originInfo/mods:frequency[@authority='marcfrequency']=
										'Bimonthly'">b</xsl:when>
									<xsl:when test="mods:originInfo/mods:frequency[@authority='marcfrequency']=
										'Semiweekly'">c</xsl:when>
									<xsl:when test="mods:originInfo/mods:frequency[@authority='marcfrequency']=
										'Daily'">d</xsl:when>
									<xsl:when test="mods:originInfo/mods:frequency[@authority='marcfrequency']=
										'Biweekly'">e</xsl:when>
									<xsl:when test="mods:originInfo/mods:frequency[@authority='marcfrequency']=
										'Semiannual'">f</xsl:when>
									<xsl:when test="mods:originInfo/mods:frequency[@authority='marcfrequency']=
										'Biennial'">g</xsl:when>
									<xsl:when test="mods:originInfo/mods:frequency[@authority='marcfrequency']=
										'Triennial'">h</xsl:when>
									<xsl:when test="mods:originInfo/mods:frequency[@authority='marcfrequency']=
										'Three times a week'">i</xsl:when>
									<xsl:when test="mods:originInfo/mods:frequency[@authority='marcfrequency']=
										'Three times a month'">j</xsl:when>
									<xsl:when test="mods:originInfo/mods:frequency[@authority='marcfrequency']=
										'Continuously updated'">k</xsl:when>
									<xsl:when test="mods:originInfo/mods:frequency[@authority='marcfrequency']=
										'Monthly'">m</xsl:when>
									<xsl:when test="mods:originInfo/mods:frequency[@authority='marcfrequency']=
										'Quarterly'">q</xsl:when>
									<xsl:when test="mods:originInfo/mods:frequency[@authority='marcfrequency']=
										'Semimonthly'">s</xsl:when>
									<xsl:when test="mods:originInfo/mods:frequency[@authority='marcfrequency']=
										'Three times a year'">t</xsl:when>
									<xsl:when test="mods:originInfo/mods:frequency[@authority='marcfrequency']=
										'Unknown'">u</xsl:when>
									<xsl:when test="mods:originInfo/mods:frequency[@authority='marcfrequency']=
										'Weekly'">w</xsl:when>
									<xsl:when test="mods:originInfo/mods:frequency[@authority='marcfrequency']=
										'Other'">z</xsl:when>
									<xsl:otherwise>|</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="mods:note[@type='regularity']='Normalized irregular'">n</xsl:when>
									<xsl:when test="mods:note[@type='regularity']='Regular'">r</xsl:when>
									<xsl:when test="mods:note[@type='regularity']='Unknown'">u</xsl:when>
									<xsl:when test="mods:note[@type='regularity']='Completely irregular'">x</xsl:when>
									<xsl:otherwise>|</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>||</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
						<!-- 20 -->
						<xsl:text>|</xsl:text>
						<!-- 21 -->
						<xsl:choose>
							<xsl:when test="$typeOf008='SE'">
								<xsl:choose>
									<xsl:when test="mods:genre[@authority='marcgt']='database'">d</xsl:when>
									<xsl:when test="mods:genre[@authority='marcgt']='loose-leaf'">l</xsl:when>
									<xsl:when test="mods:genre[@authority='marcgt']='newspaper'">n</xsl:when>
									<xsl:when test="mods:genre[@authority='marcgt']='periodical'">p</xsl:when>
									<xsl:when test="mods:genre[@authority='marcgt']='series'">m</xsl:when>
									<xsl:when test="mods:genre[@authority='marcgt']='web site'">w</xsl:when>
									<xsl:otherwise>|</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>|</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 22 -->	
				<!-- 1/04 fix -->
				<xsl:choose>
					<xsl:when test="mods:targetAudience[@authority='marctarget']">
						<xsl:apply-templates mode="ctrl008" select="mods:targetAudience[@authority='marctarget']"/>
					</xsl:when>
					<xsl:otherwise> <!-- SA change 2015-02-05 -->
						<xsl:text> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 23 -->	
				<xsl:choose>
					<xsl:when test="$typeOf008='BK' or $typeOf008='MU' or $typeOf008='SE' or $typeOf008='MM'">
						<xsl:choose>
							<xsl:when test="mods:physicalDescription/mods:form[@authority='marcform']='braille'">f</xsl:when>
							<xsl:when test="mods:physicalDescription/mods:form[@authority='rdacarrier']='online resource'">o</xsl:when> <!-- SA add 2016-08-16 -->
							<xsl:when test="mods:physicalDescription/mods:form[@authority='marcform']='electronic' or mods:physicalDescription/mods:form[@authority='rdamedia']='computer'">s</xsl:when> <!-- SA update 2015-11-23 -->
							<xsl:when test="mods:physicalDescription/mods:form[@authority='marcform']='microfiche'">b</xsl:when>
							<xsl:when test="mods:physicalDescription/mods:form[@authority='marcform']='microfilm'">a</xsl:when>
							<xsl:when test="mods:physicalDescription/mods:form[@authority='marcform']='print'"><xsl:text> </xsl:text></xsl:when>
							<xsl:otherwise>|</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$typeOf008='MP'"> <!-- SA add 2017-08-14 -->
						<xsl:text> </xsl:text>
					</xsl:when>
					<xsl:otherwise>|</xsl:otherwise>
				</xsl:choose>
				<!-- 24-27 -->	
				<xsl:choose>
					<xsl:when test="$typeOf008='BK'">
						<xsl:call-template name="controlField008-24-27"/>
					</xsl:when>
					<xsl:when test="$typeOf008='MP'">
						<xsl:text> </xsl:text> <!-- SA change 2017-08-14 -->
						<xsl:choose>
							<xsl:when test="mods:genre[@authority='marcgt']='atlas'">e</xsl:when>
							<xsl:when test="mods:genre[@authority='marcgt']='globe'">d</xsl:when>
							<xsl:when test="contains(mods:physicalDescription/mods:extent, 'maps')">b</xsl:when> <!-- SA add 2018-06-12 -->
							<xsl:when test="contains(mods:physicalDescription/mods:extent, '1 map')">a</xsl:when> <!-- SA add 2018-06-12 -->
							<xsl:otherwise>z</xsl:otherwise> <!-- SA change 2017-07-26, 2018-06-12 -->
						</xsl:choose>
						<xsl:text>  </xsl:text> <!-- SA change 2017-08-14 -->
					</xsl:when>
					<xsl:when test="$typeOf008='CF'">
						<xsl:text>||</xsl:text>
						<xsl:choose>
							<xsl:when test="mods:genre[@authority='marcgt']='database'">e</xsl:when>
							<xsl:when test="mods:genre[@authority='marcgt']='font'">f</xsl:when>
							<xsl:when test="mods:genre[@authority='marcgt']='game'">g</xsl:when>
							<xsl:when test="mods:genre[@authority='marcgt']='numerical data'">a</xsl:when>
							<xsl:when test="mods:genre[@authority='marcgt']='sound'">h</xsl:when>
							<xsl:otherwise>|</xsl:otherwise>
						</xsl:choose>
						<xsl:text>|</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>||||</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 28 -->
				<!-- SA change 2015-02-05, 2018-08-24 -->
				<xsl:choose>
					<xsl:when test="$typeOf008='MP'">|</xsl:when>
					<xsl:otherwise>
						<xsl:text> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 29 -->
				<xsl:choose>
					<xsl:when test="$typeOf008='BK' or $typeOf008='SE'">
						<xsl:choose>
							<xsl:when test="mods:genre[@authority='marcgt']='conference publication'">1</xsl:when>
							<xsl:otherwise>|</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$typeOf008='MP' or $typeOf008='VM'">
						<xsl:choose>
						<xsl:when test="mods:physicalDescription/mods:form='online resource'">o</xsl:when> <!-- SA add 2015-02-05-->
						<xsl:when test="mods:physicalDescription/mods:form='braille'">f</xsl:when>
						<xsl:when test="mods:physicalDescription/mods:form='electronic'">m</xsl:when>
						<xsl:when test="mods:physicalDescription/mods:form='microfiche'">b</xsl:when>
						<xsl:when test="mods:physicalDescription/mods:form='microfilm'">a</xsl:when>
						<xsl:when test="mods:physicalDescription/mods:form='print'"><xsl:text> </xsl:text></xsl:when>
						<xsl:otherwise>|</xsl:otherwise>
						</xsl:choose>
					</xsl:when>					
					<xsl:otherwise>|</xsl:otherwise>
				</xsl:choose>
				<!-- 30-31 -->
				<xsl:choose>
					<xsl:when test="$typeOf008='MU'">
						<xsl:call-template name="controlField008-30-31"/>
					</xsl:when>
					<xsl:when test="$typeOf008='BK'">
						<xsl:choose>
							<xsl:when test="mods:genre[@authority='marcgt']='festschrift'">1</xsl:when>
							<xsl:otherwise>|</xsl:otherwise>
						</xsl:choose>
						<xsl:choose> <!-- SA change 2015-04-02 -->
							<xsl:when test="contains(mods:note[@type='bibliography'], 'index')">1</xsl:when>
							<xsl:when test="mods:note[not(@type)]='Includes index'">1</xsl:when> <!-- SA add 2018-05-04 -->
							<xsl:otherwise>|</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$typeOf008='MP'"> <!-- SA add 2017-08-14, update 2018-03-14 -->
						<xsl:text> </xsl:text>
						<xsl:choose>
							<xsl:when test="mods:note[not(@type)][contains(lower-case(.), 'index')]">1</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>||</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 32 -->					
				<xsl:text> </xsl:text> <!-- SA change 2016-03-21 -->
				<!-- 33 -->
				<!-- 2016-02-11 SA change fill characters to blanks -->
				<xsl:choose>
					<xsl:when test="$typeOf008='VM'">
						<xsl:choose>
						<xsl:when test="mods:genre[@authority='marcgt']='art original'">a</xsl:when>
						<xsl:when test="mods:genre[@authority='marcgt']='art reproduction'">c</xsl:when>
						<xsl:when test="mods:genre[@authority='marcgt']='chart'">n</xsl:when>
						<xsl:when test="mods:genre[@authority='marcgt']='diorama'">d</xsl:when>
						<xsl:when test="mods:genre[@authority='marcgt']='filmstrip'">f</xsl:when>
						<xsl:when test="mods:genre[@authority='marcgt']='flash card'">o</xsl:when>
						<xsl:when test="mods:genre[@authority='marcgt']='graphic'">k</xsl:when>
						<xsl:when test="mods:genre[@authority='marcgt']='kit'">b</xsl:when>
						<xsl:when test="mods:genre[@authority='marcgt']='technical drawing'">l</xsl:when>
						<xsl:when test="mods:genre[@authority='marcgt']='slide'">s</xsl:when>
						<xsl:when test="mods:genre[@authority='marcgt']='realia'">r</xsl:when>
						<xsl:when test="mods:genre[@authority='marcgt']='picture'">i</xsl:when>
						<xsl:when test="mods:genre[@authority='marcgt']='motion picture'">m</xsl:when>
						<xsl:when test="mods:genre[@authority='marcgt']='model'">q</xsl:when>
						<xsl:when test="mods:genre[@authority='marcgt']='microscope slide'">p</xsl:when>
						<xsl:when test="mods:genre[@authority='marcgt']='toy'">w</xsl:when>
						<xsl:when test="mods:genre[@authority='marcgt']='transparency'">t</xsl:when>
						<xsl:when test="mods:genre[@authority='marcgt']='videorecording'">v</xsl:when>
						<xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$typeOf008='BK'">
						<xsl:choose>
						<xsl:when test="mods:genre[@authority='marcgt']='comic strip'">c</xsl:when>
						<xsl:when test="mods:genre[@authority='marcgt']='fiction'">1</xsl:when>
						<xsl:when test="mods:genre[@authority='marcgt']='essay'">e</xsl:when>
						<xsl:when test="mods:genre[@authority='marcgt']='drama'">d</xsl:when>
						<xsl:when test="mods:genre[@authority='marcgt']='humor, satire'">h</xsl:when>
						<xsl:when test="mods:genre[@authority='marcgt']='letter'">i</xsl:when>
						<xsl:when test="mods:genre[@authority='marcgt']='novel'">f</xsl:when>
						<xsl:when test="mods:genre[@authority='marcgt']='short story'">j</xsl:when>
						<xsl:when test="mods:genre[@authority='marcgt']='speech'">s</xsl:when>
						<xsl:otherwise>0</xsl:otherwise> <!-- 2016-02-11 SA change default -->
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
				</xsl:choose>
				<!-- 34 -->	
				<!-- 2016-02-11 SA change fill characters to blanks -->
				<xsl:choose>
					<xsl:when test="$typeOf008='BK'">
						<xsl:choose>
							<xsl:when test="mods:genre[@authority='marcgt']='biography'">d</xsl:when>
							<xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$typeOf008='VM'"> <!-- SA add 2015-02-05 -->
						<xsl:choose>
							<xsl:when test="mods:genre[@authority='marcgt']='motion picture'">l</xsl:when> <!-- SA add 2018-06-19 -->
							<xsl:otherwise>n</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
				</xsl:choose>
				<!-- 35-37 -->	
				<!-- SA change to select no more than one language code 2016-12-16 -->
				<xsl:variable name="languageCodes" 
					select="count(mods:language/mods:languageTerm[@authority='iso639-2b'])"/>
				<xsl:choose>
				<!-- v3 language -->
					<xsl:when test="$languageCodes &gt; 1">
						<xsl:value-of select="mods:language[@usage='primary']/mods:languageTerm[@authority='iso639-2b']"/>
					</xsl:when>
					<xsl:when test="$languageCodes = 1">
						<xsl:value-of select="mods:language/mods:languageTerm[@authority='iso639-2b']"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>|||</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 38 -->	<!-- SA change 2015-01-23 to meet OCLC guidelines -->
				<xsl:text> </xsl:text>
				<!-- 39 --> <!-- SA add 2015-01-21 -->
				<xsl:text>d</xsl:text>
			</marc:controlfield>
			<!-- 1/04 fix sort -->
			<xsl:call-template name="recordIdentifier"/>
			<xsl:call-template name="source"/>
			<xsl:apply-templates/>
			<xsl:if test="mods:classification[@authority='lcc']">
				<xsl:call-template name="lcClassification"/>
			</xsl:if>
			
			<!-- SA add 2017-11-14 -->
			<xsl:call-template name="localRecordSource"/>
			
			<!-- SA add 2017-11-09, for born-digital materials -->
			<xsl:if test="not(mods:relatedItem[@type='otherFormat'] or mods:relatedItem[@type='original'])">
				<xsl:call-template name="dateOfWork"/>
			</xsl:if>
			
			<!-- SA add 2015-10-12 -->
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">884</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">
						<xsl:text>Dartmouth MODS to MARC transformation, version 0.9.16</xsl:text>
					</marc:subfield>
					<marc:subfield code="g">
						<xsl:value-of select="format-date(current-date(), '[Y0001][M01][D01]')"/>
					</marc:subfield>
					<marc:subfield code="q">
						<xsl:text>NhD</xsl:text>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
			
			<!-- SA add 2018-03-15 -->
			<xsl:call-template name="localBibNumber"/>
		</marc:record>
	</xsl:template>

	<xsl:template match="*"/>

<!-- Title Info elements -->
	<xsl:template match="mods:titleInfo[not(ancestor-or-self::mods:subject)][not(@type)][1]">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">245</xsl:with-param>
			<xsl:with-param name="ind1"> <!-- SA fix 2015-02-11 to accomodate no main entry -->
				<xsl:choose>
					<xsl:when test="following-sibling::mods:name[@usage='primary']|preceding-sibling::mods:name[@usage='primary']">1</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="ind2" select="string-length(mods:nonSort)"/>
			<xsl:with-param name="subfields">
				<xsl:call-template name="titleInfo"/>
				<!-- 1/04 fix -->
				<xsl:call-template name="stmtOfResponsibility"/>
				<xsl:call-template name="form"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="mods:titleInfo[@type='abbreviated']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">210</xsl:with-param>
			<xsl:with-param name="ind1">1</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:call-template name="titleInfo"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="mods:titleInfo[@type='translated']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">242</xsl:with-param>
			<xsl:with-param name="ind1">1</xsl:with-param>
			<xsl:with-param name="ind2" select="string-length(mods:nonSort)"/>
			<xsl:with-param name="subfields">
				<xsl:call-template name="titleInfo"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="mods:titleInfo[@type='alternative'][not(@displayLabel='Uncontrolled title')]"> <!-- SA update 2015-11-24 for 740 -->
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">246</xsl:with-param>
			<xsl:with-param name="ind1">3</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:call-template name="titleInfo"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<!-- SA add 2015-11-24 -->
	<xsl:template match="mods:titleInfo[@type='alternative'][@displayLabel='Uncontrolled title']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">740</xsl:with-param>
			<xsl:with-param name="ind1" select="string-length(mods:nonSort)"/>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:if test="mods:nonSort">
						<xsl:value-of select="mods:nonSort"/>
					</xsl:if>
					<xsl:value-of select="mods:title"/>
					<xsl:if test="mods:subTitle">
						<xsl:text> : </xsl:text>
						<xsl:value-of select="mods:subTitle"/>
					</xsl:if>
					<xsl:if test="not(mods:partNumber or mods:partName)">.</xsl:if>
				</marc:subfield>
				<xsl:for-each select="mods:partNumber">
					<marc:subfield code="n">
						<xsl:value-of select="."/>
						<xsl:if test="not(following-sibling::mods:partName)">.</xsl:if>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:partName">
					<marc:subfield code="p">
						<xsl:value-of select="."/>
						<xsl:text>.</xsl:text>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="mods:titleInfo[@type='uniform'][1]">
		<xsl:choose>
			<!-- v3 role -->
			<xsl:when test="../mods:name/mods:role/mods:roleTerm[@type='text']='creator' or mods:name/mods:role/mods:roleTerm[@type='code']='cre' or ../mods:name[@usage='primary']"> <!-- SA addition 2015-01-13 for @usage -->
				<xsl:call-template name="datafield">
					<xsl:with-param name="tag">240</xsl:with-param>
					<xsl:with-param name="ind1">1</xsl:with-param>
					<xsl:with-param name="ind2" select="string-length(mods:nonSort)"/>
					<xsl:with-param name="subfields">
						<xsl:call-template name="titleInfo"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="datafield">
					<xsl:with-param name="tag">130</xsl:with-param>
					<xsl:with-param name="ind1" select="string-length(mods:nonSort)"/>
					<xsl:with-param name="subfields">
						<xsl:call-template name="titleInfo"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 1/04 fix: 2nd uniform title to 730 -->
	<xsl:template match="mods:titleInfo[@type='uniform'][position()>1]">		
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">730</xsl:with-param>
			<xsl:with-param name="ind1" select="string-length(mods:nonSort)"/>
			<xsl:with-param name="subfields">
				<xsl:call-template name="titleInfo"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- 1/04 fix -->
	

	<xsl:template match="mods:titleInfo[not(ancestor-or-self::mods:subject)][not(@type)][position()>1]">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">246</xsl:with-param>
			<xsl:with-param name="ind1">3</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:call-template name="titleInfo"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
<!-- Name elements -->
	<xsl:template match="mods:name">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">720</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="mods:namePart"/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>	
	</xsl:template>
	<!-- v3 role-->
	<xsl:template match="mods:name[@type='personal'][@usage='primary']"> <!-- SA addition 2013-08-30 for @primary, update 2014-09-22 -->
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">100</xsl:with-param>
			<xsl:with-param name="ind1">
				<!-- SA add conditional logic 2016-12-16 -->
				<xsl:choose>
					<xsl:when test="mods:namePart[@type='given'] and not(mods:namePart[@type='family'])">0</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:choose> <!-- SA fix for inverted names 2013-11-15, update 2015-11-23, 2016-12-16 -->
						<xsl:when test="mods:namePart[@type='family'] and mods:namePart[@type='given']">
							<xsl:value-of select="concat(mods:namePart[@type='family'],', ',mods:namePart[@type='given'][1])"/>
						</xsl:when>
						<xsl:otherwise> <!-- SA update 2016-05-16 -->
							<xsl:value-of select="mods:namePart[not(@type='termsOfAddress' or @type='date')]"/>
						</xsl:otherwise>
					</xsl:choose>
					<!-- SA add 2015-02-05, update 2015-11-23, update 2016-03-21 -->
					<xsl:choose>
						<xsl:when test="child::mods:namePart[@type='given'][2]"/>
						<xsl:when test="not(child::mods:namePart[@type='termsOfAddress' or @type='date']) and not(ends-with(child::mods:namePart[last()], '.')) and not(mods:role)">.</xsl:when>
						<xsl:when test="child::mods:namePart[@type='termsOfAddress' or @type='date'] or mods:role">,</xsl:when>
						<xsl:otherwise/>
					</xsl:choose>
				</marc:subfield>
				<xsl:if test="mods:namePart[@type='given'][2]"> <!-- SA add 2015-11-23, update 2016-03-21, 2016-08-15 -->
					<marc:subfield code="q">
						<xsl:choose>
							<xsl:when test="starts-with(mods:namePart[@type='given'][2], '(')">
								<xsl:value-of select="mods:namePart[@type='given'][2]"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat('(', mods:namePart[@type='given'][2], ')')"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="not(child::mods:namePart[@type='termsOfAddress' or @type='date']) and not(ends-with(child::mods:namePart[last()], '.')) and not(mods:role)">.</xsl:when>
							<xsl:when test="child::mods:namePart[@type='termsOfAddress' or @type='date'] or mods:role">,</xsl:when>
							<xsl:otherwise/>
						</xsl:choose>
					</marc:subfield>
				</xsl:if>
				<!-- v3 termsOfAddress -->
				<xsl:for-each select="mods:namePart[@type='termsOfAddress']">
					<marc:subfield code="c">
						<xsl:value-of select="."/>
						<!-- SA add 2015-02-05 -->
						<xsl:if test="not(following-sibling::mods:namePart[@type='date']) and not(ends-with(., '.'))">.</xsl:if>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:namePart[@type='date']">
					<marc:subfield code="d">
						<xsl:value-of select="."/>
						<xsl:choose> <!-- SA add 2015-11-23 -->
							<xsl:when test="following-sibling::mods:role[mods:roleTerm[@type='text']]">,</xsl:when>
							<xsl:otherwise>.</xsl:otherwise>
						</xsl:choose>
					</marc:subfield>
				</xsl:for-each>
				<!-- v3 role -->
				<xsl:for-each select="mods:role/mods:roleTerm[@type='text']">
					<marc:subfield code="e">
						<xsl:value-of select="lower-case(.)"/> <!-- SA change 2015-02-05 -->
						<xsl:choose> <!-- SA add 2015-11-23 -->
							<xsl:when test="../following-sibling::mods:role[mods:roleTerm[@type='text']]">,</xsl:when>
							<xsl:when test="ends-with(., '.')"/> <!-- SA add 2018-02-01 -->
							<xsl:otherwise>.</xsl:otherwise>
						</xsl:choose>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:role/mods:roleTerm[@type='code']">
					<xsl:if test="not(../mods:roleTerm[@type='text'])"> <!-- SA change to skip if $e is used 2014-09-23 -->
						<marc:subfield code="4">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="mods:affiliation">
					<marc:subfield code="u">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:description">
					<marc:subfield code="g">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>	
	</xsl:template>
	<!-- v3 role -->
	<!-- SA change 2016-12-14 to use @usage -->
	<xsl:template match="mods:name[@type='corporate'][@usage='primary']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">110</xsl:with-param>
			<xsl:with-param name="ind1">2</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="mods:namePart[1]"/>
					<xsl:choose> <!-- SA add 2017-08-18 -->
						<xsl:when test="not(mods:namePart[position()>1]) and
							mods:role/mods:roleTerm[@type='text']">,</xsl:when>
						<xsl:when test="not(ends-with(mods:namePart[1], '.'))">.</xsl:when>
					</xsl:choose>
				</marc:subfield>
				<xsl:for-each select="mods:namePart[position()>1]">
					<marc:subfield code="b">
						<xsl:value-of select="."/>
						<xsl:choose> <!-- SA add 2017-08-18 -->
							<xsl:when test="following-sibling::mods:role/mods:roleTerm[@type='text']">,</xsl:when>
							<xsl:when test="not(ends-with(., '.'))">.</xsl:when>
						</xsl:choose>
					</marc:subfield>
				</xsl:for-each>
				<!-- v3 role -->
				<xsl:for-each select="mods:role/mods:roleTerm[@type='text']">
					<marc:subfield code="e">
						<xsl:value-of select="lower-case(.)"/> <!-- SA change 2015-02-05 -->
						<xsl:choose> <!-- SA add 2016-03-21 -->
							<xsl:when test="../following-sibling::mods:role[mods:roleTerm[@type='text']]">,</xsl:when>
							<xsl:when test="ends-with(., '.')"/> <!-- SA add 2018-02-01 -->
							<xsl:otherwise>.</xsl:otherwise>
						</xsl:choose>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:role/mods:roleTerm[@type='code']">
					<xsl:if test="not(../mods:roleTerm[@type='text'])"> <!-- SA change to skip if $e is used 2014-09-23 -->
						<marc:subfield code="4">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="mods:description">
					<marc:subfield code="g">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>	
	</xsl:template>
	<!-- v3 role -->
	<xsl:template match="mods:name[@type='conference'][mods:role/mods:roleTerm[@type='text']='creator']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">111</xsl:with-param>
			<xsl:with-param name="ind1">2</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="mods:namePart[1]"/>
				</marc:subfield>
				<!-- v3 role -->
				<xsl:for-each select="mods:role/mods:roleTerm[@type='code']">
					<marc:subfield code="4">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>	
	</xsl:template>
	<!-- v3 role -->
	<!-- SA change XPath 2014-09-22, update 2017-11-20 -->
	<xsl:template match="mods:name[@type='personal'][not(@usage='primary')][not(parent::mods:relatedItem)]">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">700</xsl:with-param>
			<xsl:with-param name="ind1">
				<!-- SA add conditional logic 2016-12-16 -->
				<xsl:choose>
					<xsl:when test="mods:namePart[@type='given'] and not(mods:namePart[@type='family'])">0</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:choose> <!-- SA update 2015-11-23 -->
						<xsl:when test="mods:namePart[@type='family']">
							<xsl:value-of select="concat(mods:namePart[@type='family'],', ',mods:namePart[@type='given'][1])"/>
						</xsl:when>
						<xsl:otherwise><xsl:value-of select="mods:namePart"/></xsl:otherwise>
					</xsl:choose>
					<!-- SA add 2015-11-23, update 2016-03-21 -->
					<xsl:choose>
						<xsl:when test="child::mods:namePart[@type='given'][2]"/>
						<xsl:when test="not(child::mods:namePart[@type='termsOfAddress' or @type='date'] or child::mods:role) and not(ends-with(child::mods:namePart[last()], '.'))">.</xsl:when>
						<xsl:when test="child::mods:namePart[@type='termsOfAddress' or @type='date'] or child::mods:role">,</xsl:when>
						<xsl:otherwise/>
					</xsl:choose>
				</marc:subfield>
				<xsl:if test="mods:namePart[@type='given'][2]"> <!-- SA add 2015-11-23, update 2017-11-20 -->
					<marc:subfield code="q">
						<xsl:choose>
							<xsl:when test="starts-with(mods:namePart[@type='given'][2], '(')">
								<xsl:value-of select="mods:namePart[@type='given'][2]"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat('(', mods:namePart[@type='given'][2], ')')"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="not(child::mods:namePart[@type='termsOfAddress' or @type='date'] or child::mods:role) and not(ends-with(child::mods:namePart[last()], '.'))">.</xsl:when>
							<xsl:when test="child::mods:namePart[@type='termsOfAddress' or @type='date'] or child::mods:role">,</xsl:when>
							<xsl:otherwise/>
						</xsl:choose>
					</marc:subfield>
				</xsl:if>
				<!-- v3 termsofAddress -->
				<xsl:for-each select="mods:namePart[@type='termsOfAddress']">
					<marc:subfield code="c">
						<xsl:value-of select="."/>
						<!-- SA add 2015-11-23 -->
						<xsl:if test="not(following-sibling::mods:namePart[@type='date']) and not(following-sibling::mods:role) and not(ends-with(., '.'))">.</xsl:if>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:namePart[@type='date']">
					<marc:subfield code="d">
						<xsl:value-of select="."/>
						<xsl:choose> <!-- SA add 2015-11-23 -->
							<xsl:when test="following-sibling::mods:role[mods:roleTerm[@type='text']]">,</xsl:when>
							<xsl:otherwise>.</xsl:otherwise>
						</xsl:choose>
					</marc:subfield>
				</xsl:for-each>
				<!-- v3 role -->
				<xsl:for-each select="mods:role/mods:roleTerm[@type='text']">
					<marc:subfield code="e">
						<xsl:value-of select="lower-case(.)"/> <!-- SA change 2015-02-05 -->
						<xsl:choose> <!-- SA add 2015-11-23 -->
							<xsl:when test="../following-sibling::mods:role[mods:roleTerm[@type='text']]">,</xsl:when>
							<xsl:when test="ends-with(., '.')"/> <!-- SA add 2018-02-01 -->
							<xsl:otherwise>.</xsl:otherwise>
						</xsl:choose>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:role/mods:roleTerm[@type='code']">
					<xsl:if test="not(../mods:roleTerm[@type='text'])"> <!-- SA change to skip if $e is used 2014-09-23 -->
						<marc:subfield code="4">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="mods:affiliation">
					<marc:subfield code="u">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>	
	</xsl:template>
	<!-- v3 role -->
	<!-- SA change XPath 2014-09-22, update 2017-11-20 -->
	<xsl:template match="mods:name[@type='corporate'][not(@usage='primary')][not(parent::mods:relatedItem)]">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">710</xsl:with-param>
			<xsl:with-param name="ind1">2</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:if test="@displayLabel"> <!-- SA add 2015-11-23 -->
					<marc:subfield code="i">
						<xsl:value-of select="@displayLabel"/>
					</marc:subfield>
				</xsl:if>
				<marc:subfield code="a">
					<!-- 1/04 fix -->
					<xsl:value-of select="mods:namePart[1]"/>
					<xsl:choose> <!-- SA add 2015-02-05, update 2016-03-21 -->
						<xsl:when test="mods:role/mods:roleTerm[@type='text']">,</xsl:when>
						<xsl:when test="not(ends-with(mods:namePart[1], '.'))">.</xsl:when>
					</xsl:choose>
				</marc:subfield>
				<xsl:for-each select="mods:namePart[position()>1]">
					<marc:subfield code="b">
						<xsl:value-of select="."/>
						<xsl:choose> <!-- SA add 2015-02-05, update 2016-03-21 -->
							<xsl:when test="following-sibling::mods:role/mods:roleTerm[@type='text']">,</xsl:when>
							<xsl:when test="not(ends-with(., '.'))">.</xsl:when>
						</xsl:choose>
					</marc:subfield>
				</xsl:for-each><!-- v3 role -->
				<xsl:for-each select="mods:role/mods:roleTerm[@type='text']">
					<marc:subfield code="e">
						<xsl:value-of select="lower-case(.)"/> <!-- SA change 2015-02-05 -->
						<xsl:choose> <!-- SA add 2016-03-21 -->
							<xsl:when test="../following-sibling::mods:role[mods:roleTerm[@type='text']]">,</xsl:when>
							<xsl:when test="ends-with(., '.')"/> <!-- SA add 2018-02-01 -->
							<xsl:otherwise>.</xsl:otherwise>
						</xsl:choose>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:role/mods:roleTerm[@type='code']">
					<xsl:if test="not(../mods:roleTerm[@type='text'])"> <!-- SA change to skip if $e is used 2014-09-23 -->
						<marc:subfield code="4">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:if>
				</xsl:for-each>
				<!-- SA disable 2015-02-18 -->
				<!--<xsl:for-each select="mods:description">
					<marc:subfield code="g">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>-->
				<!-- SA add 2018-09-11 to support encoding of "NhD" -->
				<xsl:for-each select="@ID">
					<marc:subfield code="5">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>	
	</xsl:template>
	<!-- v3 role -->
	<xsl:template match="mods:name[@type='conference'][mods:role/mods:roleTerm[@type='text']!='creator' or not(mods:role)]">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">711</xsl:with-param>
			<xsl:with-param name="ind1">2</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="mods:namePart[1]"/>
				</marc:subfield>
				<!-- v3 role -->
				<xsl:for-each select="mods:role/mods:roleTerm[@type='code']">
					<marc:subfield code="4">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>	
	</xsl:template>
	<!-- SA addition 2013-11-15 blank template for unneeded personal names -->
	<xsl:template match="mods:name[mods:role/mods:roleTerm[@type='text']='Thesis advisor']|mods:name[mods:role/mods:roleTerm[@type='text']='Committee member']"/>
	
<!-- Genre elements -->
	<xsl:template match="mods:genre[@authority!='marcgt' and @authority!='local'][not(parent::mods:subject)]"> <!-- SA fix 2015-01-13, update 2016-12-16 -->
		<xsl:variable name="dfv">
			<xsl:choose> <!-- SA change @authority to "rdacontent" 2013-10-25 -->
				<xsl:when test="@authority='rdacontent' and @type='musical composition'">047</xsl:when>
				<xsl:when test="@authority='rdacontent'">336</xsl:when>
				<xsl:otherwise>655</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag"><xsl:value-of select="$dfv"/></xsl:with-param>
			 <!-- SA change 2015-10-15 -->
			<xsl:with-param name="ind2">
				<xsl:choose>
					<xsl:when test="$dfv = '655'"><xsl:call-template name="authorityInd"/></xsl:when>
					<xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code='a'>
					<xsl:value-of select="."/>
					<xsl:if test="($dfv = '655') and not(ends-with(., '.'))">.</xsl:if> <!-- SA add 2017-11-20 -->
				</marc:subfield>
				<xsl:if test="$dfv = '336'"> <!-- SA add 2017-05-03-->
					<marc:subfield code='b'>
						<xsl:choose>
							<xsl:when test=".='cartographic dataset'">crd</xsl:when>
							<xsl:when test=".='cartographic image'">cri</xsl:when>
							<xsl:when test=".='cartographic moving image'">crm</xsl:when>
							<xsl:when test=".='cartographic tactile image'">crt</xsl:when>
							<xsl:when test=".='cartographic tactile three-dimensional form'">crn</xsl:when>
							<xsl:when test=".='cartographic three-dimensional form'">crf</xsl:when>
							<xsl:when test=".='computer dataset'">cod</xsl:when>
							<xsl:when test=".='computer program'">cop</xsl:when>
							<xsl:when test=".='notated movement'">ntv</xsl:when>
							<xsl:when test=".='notated music'">ntm</xsl:when>
							<xsl:when test=".='performed music'">prm</xsl:when>
							<xsl:when test=".='sounds'">snd</xsl:when>
							<xsl:when test=".='spoken word'">spw</xsl:when>
							<xsl:when test=".='still image'">sti</xsl:when>
							<xsl:when test=".='tactile image'">tci</xsl:when>
							<xsl:when test=".='tactile notated music'">tcm</xsl:when>
							<xsl:when test=".='tactile notated movement'">tcn</xsl:when>
							<xsl:when test=".='tactile text'">tct</xsl:when>
							<xsl:when test=".='tactile three-dimensional form'">tcf</xsl:when>
							<xsl:when test=".='text'">txt</xsl:when>
							<xsl:when test=".='three-dimensional form'">tdf</xsl:when>
							<xsl:when test=".='three-dimensional moving image'">tdm</xsl:when>
							<xsl:when test=".='two-dimensional moving image'">tdi</xsl:when>
							<xsl:when test=".='other'">xxx</xsl:when>
							<xsl:when test=".='unspecified'">zzz</xsl:when>
						</xsl:choose>
					</marc:subfield>
				</xsl:if>
				<xsl:for-each select="@authority">
					<marc:subfield code='2'>
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<!-- SA add 2017-12-22 -->
				<xsl:if test="@authority='fast' and @valueURI">
					<xsl:call-template name="authorityRecordNumberFAST"/>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>	
	
	
<!-- Origin Info elements -->	
	<xsl:template match="mods:originInfo">
		<!-- v3.4 Added for 264 ind2 = 0, 1, 2, 3-->
		<!-- v3 place, and fixed "mods:placeCode (v1?) -->		
		<xsl:for-each select="mods:place/mods:placeTerm[@type='code'][@authority='iso3166']">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">044</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code='c'>
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>		
		<!-- v3.4 -->
		<xsl:if test="mods:dateCaptured[@encoding='iso8601']">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">033</xsl:with-param>
				<xsl:with-param name="ind1">
					<xsl:choose>
						<xsl:when test="mods:dateCaptured[@point='start']|mods:dateCaptured[@point='end']">2</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>					
				</xsl:with-param>
				<xsl:with-param name="ind2">0</xsl:with-param>
				<xsl:with-param name="subfields">					
					<xsl:for-each select="mods:dateCaptured">
						<marc:subfield code='a'>
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:for-each>	
				</xsl:with-param>			
			</xsl:call-template>
		</xsl:if>
		<!-- v3 dates -->
		<!-- SA 2016-10-18 disable 046 -->
		<!--<xsl:if test="mods:dateModified|mods:dateCreated|mods:dateValid">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">046</xsl:with-param>
				<xsl:with-param name="subfields">					
					<xsl:for-each select="mods:dateModified">
						<marc:subfield code='j'>
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:for-each>
					<xsl:for-each select="mods:dateCreated[@point='start']|mods:dateCreated[not(@point)]">
						<marc:subfield code='k'>
							<xsl:value-of select="."/>
						</marc:subfield>				
					</xsl:for-each>
					<xsl:for-each select="mods:dateCreated[@point='end']">
						<marc:subfield code='l'>
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:for-each>
					<xsl:for-each select="mods:dateValid[@point='start']|mods:dateValid[not(@point)]">
						<marc:subfield code='m'>
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:for-each>
					<xsl:for-each select="mods:dateValid[@point='end']">
						<marc:subfield code='n'>
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:for-each>
				</xsl:with-param>			
			</xsl:call-template>	
		</xsl:if>	-->
		<xsl:for-each select="mods:edition">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">250</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code='a'>
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="mods:frequency">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">310</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code='a'>
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<!-- SA 2016-10-18 add check for applicable subelements before creating 264/260, add copyright support 2017-11-20 -->
		<xsl:if test="mods:place or mods:publisher or mods:dateIssued or mods:copyrightDate">
			<xsl:call-template name="datafield">
				<!-- SA change 2015-04-02 to create 264 based on @eventType, not @displayLabel -->
				<xsl:with-param name="tag">
					<xsl:choose>
						<xsl:when test="@eventType='production' or @eventType='publication' 
							or @eventType='manufacture' or @eventType='distribution'">264</xsl:when>
						<xsl:otherwise>260</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="ind2">
					<xsl:choose>
						<xsl:when test="@eventType='production'">0</xsl:when>
						<xsl:when test="@eventType='publication'">1</xsl:when> 
						<xsl:when test="@eventType='distribution'">2</xsl:when> <!-- SA swap/fix 2017-08-14 -->
						<xsl:when test="@eventType='manufacture'">3</xsl:when>
						<xsl:when test="@eventType='copyright'">4</xsl:when>
						<xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise> <!-- SA fix 2013-08-21 for blank ind2 -->
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="subfields">
					<!-- v3 place; changed to text  -->
					<xsl:for-each select="mods:place/mods:placeTerm[@type='text']">
						<marc:subfield code='a'>
							<xsl:choose> <!-- SA add brackets when @supplied 2015-11-23 -->
								<xsl:when test="../@supplied='yes'">
									<xsl:text>[</xsl:text>
									<xsl:value-of select="."/>
									<xsl:text>]</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="."/>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="../../mods:publisher"> <!-- SA add 2015-11-23, update 2017-01-27 -->
								<xsl:text> :</xsl:text>
							</xsl:if>
						</marc:subfield>
					</xsl:for-each>
					<xsl:for-each select="mods:publisher">
						<marc:subfield code='b'>
							<xsl:choose> <!-- SA add brackets when @supplied 2015-11-23 -->
								<xsl:when test="@supplied='yes'">
									<xsl:text>[</xsl:text>
									<xsl:value-of select="."/>
									<xsl:text>]</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="."/>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="following-sibling::mods:dateIssued"> <!-- SA add 2015-11-23, update 2017-01-27 -->
								<xsl:text>,</xsl:text>
							</xsl:if>
						</marc:subfield>
					</xsl:for-each>
					<xsl:for-each select="mods:dateIssued[not(@point='end')][not(@encoding='fast')]"> <!-- SA update 2017-11-16 -->
						<marc:subfield code='c'>
							<xsl:if test="@drb:supplied='yes' or @qualifier='questionable'"> <!-- SA add brackets when @drb:supplied 2017-05-05, @qualifier="questionable" 2018-05-30 -->
								<xsl:text>[</xsl:text>
							</xsl:if>
							<xsl:value-of select="substring(.,1,4)"/>
							<!-- v3.4 generate question mark for dateIssued with qualifier="questionable" -->
							<xsl:if test="@qualifier='questionable'">?</xsl:if>
							<!-- v3.4 Generate a hyphen before end date -->
							<xsl:if test="mods:dateIssued[@point='end']">
								- <xsl:value-of select="../mods:dateIssued[@point='end']"/>
							</xsl:if>
							<xsl:if test="@drb:supplied='yes' or @qualifier='questionable'"> <!-- SA add brackets when @drb:supplied 2017-05-05, @qualifier="questionable" 2018-05-30 -->
								<xsl:text>]</xsl:text>
							</xsl:if>
							<!-- SA add 2015-02-05, update 2015-11-23, 2017-05-05 -->
							<xsl:if test="not(@qualifier='questionable') and not(@drb:supplied)">
								<xsl:text>.</xsl:text>
							</xsl:if>
						</marc:subfield>
					</xsl:for-each>
					<xsl:if test="@eventType='copyright'">
						<xsl:for-each select="mods:copyrightDate">
							<marc:subfield code='c'>
								<xsl:text>©</xsl:text>
								<xsl:value-of select="."/>
							</marc:subfield>
						</xsl:for-each>
					</xsl:if>
					<!-- SA disable 2013-11-15 -->
					<!--<xsl:for-each select="mods:dateCreated">
					<marc:subfield code='g'>
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>-->
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
<!-- Language -->
	<!-- SA add 2016-12-16 -->
	<xsl:template match="mods:language[1]">
		<!-- v3 language -->
		<!-- SA change 2016-12-16, create 041 with repeated $a if multiple codes -->
		<xsl:if test="count(../mods:language/mods:languageTerm[@authority='iso639-2b']) &gt; 1">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">041</xsl:with-param>
				<xsl:with-param name="ind1">0</xsl:with-param>
				<xsl:with-param name="subfields">
					<!-- SA update 2018-06-15 to not put secondary codes from @objectPart into $a -->
					<xsl:for-each select="../mods:language
						[@objectPart='text/sound track' or not(@objectPart)]/mods:languageTerm[@authority='iso639-2b']">
						<marc:subfield code='a'>
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:for-each>
					<!-- SA add 2018-06-15 support for additional codes from @objectPart in same 041 field -->
					<xsl:for-each select="following-sibling::mods:language[@objectPart]/mods:languageTerm[@authority='iso639-2b']">
						<xsl:choose>
							<xsl:when test="../@objectPart='text/sound track'">
								<marc:subfield code='a'>
									<xsl:value-of select="."/>
								</marc:subfield>
							</xsl:when>
							<xsl:when test="../@objectPart='summary or abstract' or ../@objectPart='summary' or ../@objectPart='abstract'">
								<marc:subfield code='b'>
									<xsl:value-of select="."/>
								</marc:subfield>
							</xsl:when>
							<xsl:when test="../@objectPart='sung or spoken text'">
								<marc:subfield code='d'>
									<xsl:value-of select="."/>
								</marc:subfield>
							</xsl:when>
							<xsl:when test="../@objectPart='librettos' or ../@objectPart='libretto'">
								<marc:subfield code='e'>
									<xsl:value-of select="."/>
								</marc:subfield>
							</xsl:when>
							<xsl:when test="../@objectPart='table of contents'">
								<marc:subfield code='f'>
									<xsl:value-of select="."/>
								</marc:subfield>
							</xsl:when>
							<xsl:when test="../@objectPart='accompanying material other than librettos' or ../@objectPart='accompanying material'">
								<marc:subfield code='g'>
									<xsl:value-of select="."/>
								</marc:subfield>
							</xsl:when>
							<xsl:when test="../@objectPart='original and/or intermediate translations of text' or ../@objectPart='translation'">
								<marc:subfield code='h'>
									<xsl:value-of select="."/>
								</marc:subfield>
							</xsl:when>
							<xsl:when test="../@objectPart='subtitles or captions' or ../@objectPart='subtitle or caption'">
								<marc:subfield code='j'>
									<xsl:value-of select="."/>
								</marc:subfield>
							</xsl:when>
							<xsl:otherwise>
								<marc:subfield code='a'>
									<xsl:value-of select="."/>
								</marc:subfield>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="mods:language[position() &gt; 1]">
		<xsl:apply-templates/>
	</xsl:template>
	
	<!-- v3.4 language with objectPart-->
	<!-- SA update 2018-06-15 to not create 2nd 041 if one already exists -->
	<xsl:template match="mods:languageTerm[@objectPart][not(../preceding-sibling::mods:language[not(@objectPart)])]">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">041</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:choose>
					<xsl:when test="@objectPart='text/sound track'">
						<marc:subfield code='a'>
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:when>
					<xsl:when test="@objectPart='summary or abstract' or @objectPart='summary' or @objectPart='abstract'">
						<marc:subfield code='b'>
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:when>
					<xsl:when test="@objectPart='sung or spoken text'">
						<marc:subfield code='d'>
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:when>
					<xsl:when test="@objectPart='librettos' or @objectPart='libretto'">
						<marc:subfield code='e'>
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:when>
					<xsl:when test="@objectPart='table of contents'">
						<marc:subfield code='f'>
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:when>
					<xsl:when test="@objectPart='accompanying material other than librettos' or @objectPart='accompanying material'">
						<marc:subfield code='g'>
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:when>
					<xsl:when test="@objectPart='original and/or intermediate translations of text' or @objectPart='translation'">
						<marc:subfield code='h'>
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:when>
					<xsl:when test="@objectPart='subtitles or captions' or @objectPart='subtitle or caption'">
						<marc:subfield code='j'>
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:when>
					<xsl:otherwise>
						<marc:subfield code='a'>
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<!-- v3 language -->
	<xsl:template match="mods:languageTerm[@authority='rfc3066']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">041</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>
			<xsl:with-param name="ind2">7</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code='a'>
					<xsl:value-of select="."/>
				</marc:subfield>
				<marc:subfield code='2'>rfc3066</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- v3.4 language with scriptTerm -->
	<xsl:template match="mods:language/mods:languageTerm[@authority='rfc3066']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">546</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code='b'>
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
<!-- Physical Description -->	
	<xsl:template match="mods:physicalDescription">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="mods:extent">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">300</xsl:with-param>
			<xsl:with-param name="subfields">
				<!-- SA add subfields b and c with ISBD punctuation 2015-05-04, subfield e 2018-07-18 -->
				<marc:subfield code='a'>
					<xsl:value-of select="."/>
					<xsl:choose>
						<xsl:when test="following-sibling::mods:note[@type='other physical details']">
							<xsl:text> :</xsl:text>
						</xsl:when>
						<xsl:when test="following-sibling::mods:note[@type='dimensions']">
							<xsl:text> ;</xsl:text>
						</xsl:when>
						<xsl:when test="following-sibling::mods:note[@type='accompanying material']">
							<xsl:text> +</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="not(ends-with(., '.'))">
								<xsl:text>.</xsl:text>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</marc:subfield>
				<xsl:if test="following-sibling::mods:note[@type='other physical details']">
					<marc:subfield code='b'>
						<xsl:value-of select="following-sibling::mods:note[@type='other physical details']"/>
						<xsl:choose>
							<xsl:when test="following-sibling::mods:note[@type='dimensions']">
								<xsl:text> ;</xsl:text>
							</xsl:when>
							<xsl:when test="following-sibling::mods:note[@type='accompanying material']">
								<xsl:text> +</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="not(ends-with(., '.'))">
									<xsl:text>.</xsl:text>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</marc:subfield>
				</xsl:if>
				<xsl:if test="following-sibling::mods:note[@type='dimensions']">
					<marc:subfield code='c'>
						<xsl:value-of select="following-sibling::mods:note[@type='dimensions']"/>
						<xsl:choose>
							<xsl:when test="following-sibling::mods:note[@type='accompanying material']">
								<xsl:text> +</xsl:text>
							</xsl:when>
							<xsl:when test="not(ends-with(following-sibling::mods:note[@type='dimensions'], '.'))">
								<xsl:text>.</xsl:text>
							</xsl:when>
						</xsl:choose>
					</marc:subfield>
				</xsl:if>
				<xsl:if test="following-sibling::mods:note[@type='accompanying material']">
					<marc:subfield code='e'>
						<xsl:variable name="accompMat" select="following-sibling::mods:note[@type='accompanying material']"/>
						<xsl:value-of select="$accompMat"/>
						<xsl:if test="not(ends-with($accompMat, '.') or ends-with($accompMat, ')'))"> <!-- SA update 2018-09-11 -->
							<xsl:text>.</xsl:text>
						</xsl:if>
					</marc:subfield>
				</xsl:if>
				
				<!--<marc:subfield code='a'>
					<xsl:choose> <!-\- SA add 2015-02-05 -\->
						<xsl:when test="not(ends-with(., '.'))">
							<xsl:value-of select="."/>
							<xsl:text>.</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="."/>
						</xsl:otherwise>
					</xsl:choose>
				</marc:subfield>-->
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<!-- v3.4 Added for 337 and 338 mods:form-->
	<xsl:template match="mods:form[not(@authority='gmd') and not(@authority='marcform')]">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">
				<xsl:choose>
					<xsl:when test="@type='media'">337</xsl:when>
					<xsl:when test="@type='carrier'">338</xsl:when>
					<xsl:when test="@type='material'">340</xsl:when>
					<xsl:when test="@type='technique'">340</xsl:when>
					<xsl:otherwise>655</xsl:otherwise> <!-- SA add fallback 2016-05-16 -->
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:if test="not(@type='technique')">
					<marc:subfield code='a'>
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:if>
				<xsl:choose> <!-- SA add 2017-05-03 -->
					<xsl:when test=".='computer'">
						<marc:subfield code='b'>c</marc:subfield>
					</xsl:when>
					<xsl:when test=".='online resource'">
						<marc:subfield code='b'>cr</marc:subfield>
					</xsl:when>
				</xsl:choose>
				<xsl:if test="@type='technique'">
					<marc:subfield code='d'>
						<xsl:value-of select="."/>
					</marc:subfield>					
				</xsl:if>
				<xsl:if test="@authority">
					<marc:subfield code='2'>
						<xsl:value-of select="@authority"/>
					</marc:subfield>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
<!-- Abstract -->
	<xsl:template match="mods:abstract[not(@shareable)][not(@type='splash')]"> <!-- SA add check for @shareable 2017-08-18, for @splash 2017-11-03 -->
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">520</xsl:with-param>
			<xsl:with-param name="ind1">
			<!-- v3.4 added values for ind1 based on displayLabel -->	
				<xsl:choose>
					<xsl:when test="@displayLabel='Subject'">0</xsl:when>
					<xsl:when test="@displayLabel='Review'">1</xsl:when>
					<xsl:when test="@displayLabel='Scope and content'">2</xsl:when>
					<xsl:when test="@displayLabel='Abstract'">3</xsl:when> <!-- SA fix 2013-08-22 -->
					<xsl:when test="@displayLabel='Content advice'">4</xsl:when>
					<xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise> <!-- SA fix 2015-11-23 -->
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="normalize-space(.)"/> <!-- SA change 2016-07-14 -->
				</marc:subfield>
				<xsl:for-each select="@xlink:href">
					<marc:subfield code="u">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
<!-- Table of Contents -->	
	<xsl:template match="mods:tableOfContents">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">505</xsl:with-param>
			<xsl:with-param name="ind1">
				<!-- v3.4 added values for ind1 based on displayLabel -->
				<xsl:choose>
					<xsl:when test="@displayLabel='Contents'">0</xsl:when>
					<xsl:when test="@displayLabel='Incomplete contents'">1</xsl:when>
					<xsl:when test="@displayLabel='Partial contents'">2</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
				<xsl:for-each select="@xlink:href">
					<marc:subfield code="u">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
<!-- Target Audience -->	
	<!-- 1/04 fix -->
<!--	<xsl:template match="mods:targetAudience">
		<xsl:apply-templates/>
	</xsl:template>-->
	
	<!--<xsl:template match="mods:targetAudience/mods:otherValue"> -->
	<xsl:template match="mods:targetAudience[not(@authority)] | mods:targetAudience[@authority!='marctarget']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">521</xsl:with-param>
			<xsl:with-param name="ind1">
				<!-- v3.4 added values for ind1 based on displayLabel -->
				<xsl:choose>
					<xsl:when test="@displayLabel='Reading grade level'">0</xsl:when>
					<xsl:when test="@displayLabel='Interest age level'">1</xsl:when>
					<xsl:when test="@displayLabel='Interest grade level'">2</xsl:when>
					<xsl:when test="@displayLabel='Special audience characteristics'">3</xsl:when>
					<xsl:when test="@displayLabel='Motivation or interest level'">3</xsl:when>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code='a'>
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

<!-- Note -->	
	<!-- 1/04 fix -->
	<xsl:template match="mods:note[not(@type='statement of responsibility' or @type='contact information' or @type='other physical details' or @type='dimensions' or @type='accompanying material')]"> <!-- SA addition 2013-08-23 filter out "additional" notes, update 2015-01-20, update 2015-05-04, update 2018-09-11 -->
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">
				<xsl:choose>
					<xsl:when test="@type='performers'">511</xsl:when>
					<xsl:when test="@type='venue'">518</xsl:when>
					<xsl:when test="@type='thesis'">502</xsl:when> <!-- SA fix 2013-08-22 -->
					<xsl:when test="@type='additional physical form'">530</xsl:when> <!-- SA add 2014-10-08 -->
					<xsl:when test="@type='bibliography'">504</xsl:when> <!-- SA add 2015-04-02 -->
					<xsl:when test="@type='language'">546</xsl:when> <!-- SA add 2015-11-23 -->
					<xsl:when test="@type='funding'">536</xsl:when> <!-- SA add 2016-10-19 -->
					<xsl:when test="@type='creation/production credits'">508</xsl:when> <!-- SA add 2018-06-19 -->
					<xsl:otherwise>500</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="ind1"> <!-- SA add 2018-06-19 -->
				<xsl:choose>
					<xsl:when test="@type='performers'">1</xsl:when>
					<xsl:otherwise>
						<xsl:text> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code='a'>
					<xsl:if test="@displayLabel"> <!-- SA add 2015-01-20 -->
						<xsl:value-of select="@displayLabel"/>
						<xsl:text>: </xsl:text>
					</xsl:if>
					<xsl:choose> <!-- SA add 2015-02-05 -->
						<xsl:when test="not(ends-with(., '.'))">
							<xsl:value-of select="."/>
							<xsl:text>.</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="."/>
						</xsl:otherwise>
					</xsl:choose>
				</marc:subfield>
				<!-- 1/04 fix: 856$u instead -->
				<!--<xsl:for-each select="@xlink:href">
					<marc:subfield code='u'>
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>-->
			</xsl:with-param>
		</xsl:call-template>
		<xsl:for-each select="@xlink:href">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">856</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code='u'>
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="mods:note[@type='additional']"/> <!-- SA addition 2013-11-15 -->
	
	<!-- 1/04 fix -->
	<!--<xsl:template match="mods:note[@type='statement of responsibility']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">245</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code='c'>
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
-->
	<xsl:template match="mods:accessCondition[@type='restriction on access'][text()!='']"> <!-- SA fix 2013-11-15 -->
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">506</xsl:with-param> <!-- SA change 2015-02-05 -->
			<!--<xsl:with-param name="tag">
			<xsl:choose>
				<!-\- SA fix 2013-08-14 -\->
				<xsl:when test="@type='restriction on access'">506</xsl:when>
				<xsl:when test="@type='use and reproduction'">540</xsl:when>
			</xsl:choose>
			</xsl:with-param>-->
			<xsl:with-param name="subfields">
				<marc:subfield code='a'>
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- 1/04 fix -->
	<xsl:template name="controlRecordInfo">
		<xsl:variable name="source"> <!-- SA add 2015-11-23 -->
			<xsl:choose>
				<xsl:when test="mods:extension/drb:flag[@type='control number']">
					<xsl:value-of select="mods:extension/drb:flag[@type='control number']/@source"/>
				</xsl:when>
				<xsl:otherwise>OCoLC</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select="mods:recordInfo/mods:recordIdentifier[@source=$source]"> <!-- SA change 2015-10-14, 2015-11-23 -->
			<marc:controlfield tag="001"><xsl:value-of select="."/></marc:controlfield>
			<xsl:for-each select="@source">
				<marc:controlfield tag="003"><xsl:value-of select="."/></marc:controlfield>			
			</xsl:for-each>
		</xsl:for-each>
		<xsl:for-each select="mods:recordInfo/mods:recordChangeDate[@encoding='iso8601']">
			<marc:controlfield tag="005"><xsl:value-of select="."/></marc:controlfield>
		</xsl:for-each>		
	</xsl:template>
	
	<xsl:template name="recordIdentifier"> <!-- SA add 2015-01-23 -->
		<xsl:for-each select="mods:recordInfo/mods:recordIdentifier[not(@source='OCoLC')]"> <!-- SA change 2015-10-12 -->
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">035</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">
						<xsl:text>(</xsl:text>
						<xsl:value-of select="@source"/>
						<xsl:text>)</xsl:text>
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="source">
		<xsl:for-each select="mods:recordInfo/mods:recordContentSource[@authority!='local']"> <!-- SA change attribute requirement 2014-09-22, 2016-05-16 -->
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">040</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
					<xsl:for-each select="../mods:languageOfCataloging/mods:languageTerm[@type='code']"> <!-- SA addition 2013-10-25 -->
						<marc:subfield code="b">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:for-each>
					<xsl:for-each select="../mods:descriptionStandard"> <!-- SA addition 2013-10-25 -->
						<marc:subfield code="e">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:for-each>
					<marc:subfield code="c"> <!-- SA addition 2014-09-23 -->
						<xsl:value-of select="."/>
					</marc:subfield>
					<xsl:for-each select="../mods:recordInfoNote[@type='modifying agency']"> <!-- SA change 2015-11-05 -->
						<marc:subfield code="d">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:for-each>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	
	<!-- v3 authority -->
	
	<xsl:template match="mods:subject">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mods:subject[@*][local-name(*[1])='topic']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">650</xsl:with-param> <!-- SA change 2015-01-13 remove ind1 -->
			<xsl:with-param name="ind2"><xsl:call-template name="authorityInd"/></xsl:with-param> <!-- SA fix 2013-08-21 -->
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="*[1]"/>
					<xsl:if test="not(*[2]) and not(ends-with(*[1], '.'))">.</xsl:if> <!-- SA add 2016-03-21 -->
				</marc:subfield>
				<!-- SA fix to not produce 043 within 650 2018-05-30 -->
				<xsl:apply-templates select="*[position()>1][not(self::mods:geographicCode)]"/>
				<!-- SA add 2015-10-14 -->
				<xsl:if test="@authority and not(@authority='lcsh') and not(@authority='lcshac') and not(@authority='mesh') and not(@authority='csh') and not(@authority='nal') and not(@authority='rvm')">
					<marc:subfield code="2">
						<xsl:value-of select="@authority"/>
					</marc:subfield>
				</xsl:if>
				<!-- SA add 2017-11-28 -->
				<xsl:if test="@authority='fast' and @valueURI">
					<xsl:call-template name="authorityRecordNumberFAST"/>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:apply-templates select="*[position()>1][self::mods:geographicCode]"/> <!-- SA add 2018-05-30 -->
	</xsl:template>
	<!-- SA addition 2013-08-30 for uncontrolled terms, update 2018-05-30 to ignore mods:cartographics, update 2018-07-20 to create multiple 653 fields, use 2nd indicator -->
	<xsl:template match="mods:subject[not(@*)][not(mods:cartographics)]">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">653</xsl:with-param>
			<xsl:with-param name="ind2">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:for-each select="mods:topic">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>	
	</xsl:template>
	<xsl:template match="mods:subject[local-name(*[1])='titleInfo']">		
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">630</xsl:with-param>
			<xsl:with-param name="ind1"><xsl:value-of select="string-length(mods:titleInfo/mods:nonSort)"/></xsl:with-param>
			<xsl:with-param name="ind2"><xsl:call-template name="authorityInd"/></xsl:with-param>
			<xsl:with-param name="subfields">				
				<xsl:for-each select="mods:titleInfo">
					<xsl:call-template name="titleInfo"/>
				</xsl:for-each>
				<xsl:apply-templates select="*[position()>1]"/>				
				<!-- SA add 2015-10-14 -->
				<xsl:if test="@authority and not(@authority='lcsh') and not(@authority='lcshac') and not(@authority='mesh') and not(@authority='csh') and not(@authority='nal') and not(@authority='rvm')">
					<marc:subfield code="2">
						<xsl:value-of select="@authority"/>
					</marc:subfield>
				</xsl:if>
				<!-- SA add 2017-11-28 -->
				<xsl:if test="@authority='fast' and @valueURI">
					<xsl:call-template name="authorityRecordNumberFAST"/>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>	
		
	</xsl:template>
	
	<xsl:template match="mods:subject[local-name(*[1])='name']">
		<xsl:for-each select="*[1]">
			<xsl:choose>
				<xsl:when test="@type='personal'">
					<xsl:call-template name="datafield">
						<xsl:with-param name="tag">600</xsl:with-param>
						<xsl:with-param name="ind1">
							<!-- SA add conditional logic 2016-12-16 -->
							<xsl:choose>
								<xsl:when test="mods:namePart[@type='given'] and
									not(mods:namePart[@type='family'])">0</xsl:when>
								<xsl:otherwise>1</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
						<xsl:with-param name="ind2"><xsl:call-template name="authorityInd"/></xsl:with-param>
						<xsl:with-param name="subfields">
							<marc:subfield code="a"> <!-- SA update 2016-05-16, 2017-11-03 -->
								<xsl:choose>
									<xsl:when test="mods:namePart[@type='family'] and mods:namePart[@type='given']">
										<xsl:value-of select="concat(mods:namePart[@type='family'],', ',mods:namePart[@type='given'][1])"/>
									</xsl:when>
									<xsl:otherwise><xsl:value-of select="mods:namePart"/></xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="child::mods:namePart[@type='given'][2]"/>
									<xsl:when test="not(child::mods:namePart[@type='termsOfAddress' or @type='date'] or child::mods:role) and not(ends-with(child::mods:namePart[last()], '.')) and not(ancestor-or-self::mods:subject/*[position()>1])">.</xsl:when>
									<xsl:when test="child::mods:namePart[@type='termsOfAddress' or @type='date'] or child::mods:role">,</xsl:when>
									<xsl:otherwise/>
								</xsl:choose>
							</marc:subfield>
							<!-- v3 termsofAddress -->
							<xsl:for-each select="mods:namePart[@type='termsOfAddress']">
								<marc:subfield code="c">
									<xsl:value-of select="."/>
								</marc:subfield>
							</xsl:for-each>
							<xsl:if test="mods:namePart[@type='given'][2]"> <!-- SA add 2017-11-16 -->
								<marc:subfield code="q">
									<xsl:choose>
										<xsl:when test="starts-with(mods:namePart[@type='given'][2], '(')">
											<xsl:value-of select="mods:namePart[@type='given'][2]"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="concat('(', mods:namePart[@type='given'][2], ')')"/>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="not(child::mods:namePart[@type='termsOfAddress' or @type='date']) and not(ends-with(child::mods:namePart[last()], '.')) and not(mods:role)">.</xsl:when>
										<xsl:when test="child::mods:namePart[@type='termsOfAddress' or @type='date'] or mods:role">,</xsl:when>
										<xsl:otherwise/>
									</xsl:choose>
								</marc:subfield>
							</xsl:if>
							<xsl:for-each select="mods:namePart[@type='date']">
								<!-- v3 namepart/date was $a; fixed to $d -->
								<marc:subfield code="d">
									<xsl:value-of select="."/>
									<!-- SA add 2017-11-16 -->
									<xsl:if test="not(following-sibling::*)">
										<xsl:text>.</xsl:text>
									</xsl:if>
								</marc:subfield>
							</xsl:for-each>
							<!-- v3 role -->
							<xsl:for-each select="mods:role/mods:roleTerm[@type='text']">
								<marc:subfield code="e">
									<xsl:value-of select="lower-case(.)"/> <!-- SA change 2015-02-05 -->
								</marc:subfield>
							</xsl:for-each>
							<xsl:for-each select="mods:affiliation">
								<marc:subfield code="u">
									<xsl:value-of select="."/>
								</marc:subfield>
							</xsl:for-each>
							<!--<xsl:apply-templates select="*[position()>1]"/>--> <!-- SA change 2017-05-05-->
							<xsl:apply-templates select="ancestor-or-self::mods:subject/*[position()>1]"/>
							<!-- SA add 2017-11-03 -->
							<xsl:if test="../@authority and not(../@authority='lcsh') and not(../@authority='lcshac') and not(../@authority='mesh') and not(../@authority='csh') and not(../@authority='nal') and not(../@authority='rvm')">
								<marc:subfield code="2">
									<xsl:value-of select="../@authority"/>
								</marc:subfield>
							</xsl:if>
							<!-- SA add 2017-11-28, update 2018-04-30 -->
							<xsl:if test="ancestor-or-self::*/@authority='fast' and ancestor-or-self::*/@valueURI">
								<xsl:call-template name="authorityRecordNumberFAST"/>
							</xsl:if>
						</xsl:with-param>
					</xsl:call-template>	
				</xsl:when>
				<xsl:when test="@type='corporate'">
					<xsl:call-template name="datafield">
						<xsl:with-param name="tag">610</xsl:with-param>
						<xsl:with-param name="ind1">2</xsl:with-param>
						<xsl:with-param name="ind2"><xsl:call-template name="authorityInd"/></xsl:with-param>
						<xsl:with-param name="subfields">
							<marc:subfield code="a">
								<xsl:value-of select="mods:namePart[1]"/> <!-- SA fix 2013-08-21 -->
								<!-- SA add 2015-02-05, update 2017-11-16 -->
								<xsl:if test="mods:namePart[position()>1] or not(following-sibling::*)">.</xsl:if>
							</marc:subfield>
							<xsl:for-each select="mods:namePart[position()>1]">
								<marc:subfield code="b"> <!-- SA fix 2013-08-21 -->
									<xsl:value-of select="."/>
									<!-- SA add 2015-02-05 -->
									<xsl:if test="not(following-sibling::mods:namePart) and not(ancestor-or-self::mods:subject/*[position()>1]) and not(ends-with(., '.'))">.</xsl:if>
								</marc:subfield>
							</xsl:for-each>
							<!-- v3 role -->
							<xsl:for-each select="mods:role/mods:roleTerm[@type='text']">
								<marc:subfield code="e">
									<xsl:value-of select="lower-case(.)"/> <!-- SA change 2015-02-05 -->
									<xsl:choose> <!-- SA add 2016-03-21 -->
										<xsl:when test="../following-sibling::mods:role[mods:roleTerm[@type='text']]">,</xsl:when>
										<xsl:otherwise>.</xsl:otherwise>
									</xsl:choose>
								</marc:subfield>
							</xsl:for-each>
							<!--<xsl:apply-templates select="*[position()>1]"/>-->
							<xsl:apply-templates select="ancestor-or-self::mods:subject/*[position()>1]"/>
							<!-- SA add 2015-10-14, update 2018-04-30 -->
							<xsl:if test="../@authority and not(../@authority='lcsh') and not(../@authority='lcshac') and not(../@authority='mesh') and not(../@authority='csh') and not(../@authority='nal') and not(../@authority='rvm')">
								<marc:subfield code="2">
									<xsl:value-of select="../@authority"/>
								</marc:subfield>
							</xsl:if>
							<!-- SA add 2017-11-28, update 2018-04-30 -->
							<xsl:if test="ancestor-or-self::*/@authority='fast' and ancestor-or-self::*/@valueURI">
								<xsl:call-template name="authorityRecordNumberFAST"/>
							</xsl:if>
						</xsl:with-param>
					</xsl:call-template>	
				</xsl:when>
				<!-- SA add 2018-02-01 for FAST "event" facet terms (TODO: requires refinement from 611 terms) -->
				<!--<xsl:when test="@type='conference' and ../@authority='fast'">
					<xsl:call-template name="datafield">
						<xsl:with-param name="tag">647</xsl:with-param>
						<xsl:with-param name="ind2"><xsl:call-template name="authorityInd"/></xsl:with-param>
						<xsl:with-param name="subfields">
							<marc:subfield code="a">
								<xsl:value-of select="mods:namePart[not(@type='date')]"/>
							</marc:subfield>
							<xsl:for-each select="mods:namePart[@type='date']">
								<marc:subfield code="d">
									<xsl:value-of select="."/>
								</marc:subfield>
							</xsl:for-each>
							<!-\- v3 role -\->
							<xsl:for-each select="mods:role/mods:roleTerm[@type='code']">
								<marc:subfield code="4">
									<xsl:value-of select="."/>
								</marc:subfield>
							</xsl:for-each>
							<xsl:apply-templates select="*[position()>1]"/>
							<marc:subfield code="2">
								<xsl:value-of select="ancestor-or-self::mods:subject/@authority"/>
							</marc:subfield>
							<xsl:call-template name="authorityRecordNumberFAST"/>
						</xsl:with-param>
					</xsl:call-template>	
				</xsl:when>-->
				<xsl:when test="@type='conference'">
					<xsl:call-template name="datafield">
						<xsl:with-param name="tag">611</xsl:with-param>
						<xsl:with-param name="ind1">2</xsl:with-param>
						<xsl:with-param name="ind2"><xsl:call-template name="authorityInd"/></xsl:with-param>
						<xsl:with-param name="subfields">
							<marc:subfield code="a">
								<xsl:value-of select="mods:namePart[not(@type='date')]"/>
							</marc:subfield>
							<xsl:for-each select="mods:namePart[@type='date']">
								<marc:subfield code="d">
									<xsl:value-of select="."/>
								</marc:subfield>
							</xsl:for-each>
							<!-- v3 role -->
							<xsl:for-each select="mods:role/mods:roleTerm[@type='code']">
								<marc:subfield code="4">
									<xsl:value-of select="."/>
								</marc:subfield>
							</xsl:for-each>
							<xsl:apply-templates select="*[position()>1]"/>
							<!-- SA add 2015-10-14, update 2018-02-01, 2018-04-30 -->
							<xsl:if test="../@authority and not(../@authority='lcsh') and not(../@authority='lcshac') and not(../@authority='mesh') and not(../@authority='csh') and not(../@authority='nal') and not(../@authority='rvm')">
								<marc:subfield code="2">
									<xsl:value-of select="../@authority"/>
								</marc:subfield>
							</xsl:if>
							<!-- SA add 2017-11-28, update 2018-04-30 -->
							<xsl:if test="ancestor-or-self::*/@authority='fast' and ancestor-or-self::*/@valueURI">
								<xsl:call-template name="authorityRecordNumberFAST"/>
							</xsl:if>
						</xsl:with-param>
					</xsl:call-template>	
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="mods:subject[local-name(*[1])='geographic']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">651</xsl:with-param>
			<xsl:with-param name="ind2"><xsl:call-template name="authorityInd"/></xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="*[1]"/>
					<xsl:if test="not(*[2]) and not(ends-with(*[1], '.'))">.</xsl:if> <!-- SA add 2017-11-20 -->
				</marc:subfield>
				<!-- SA fix to not produce 043 within 651 2017-07-14 -->
				<xsl:apply-templates select="*[position()>1][not(self::mods:geographicCode)]"/>
				<!-- SA add 2015-10-14 -->
				<xsl:if test="@authority and not(@authority='lcsh') and not(@authority='lcshac') and not(@authority='mesh') and not(@authority='csh') and not(@authority='nal') and not(@authority='rvm')">
					<marc:subfield code="2">
						<xsl:value-of select="@authority"/>
					</marc:subfield>
				</xsl:if>
				<!-- SA add 2017-11-28 -->
				<xsl:if test="@authority='fast' and @valueURI">
					<xsl:call-template name="authorityRecordNumberFAST"/>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>	
		<xsl:apply-templates select="*[position()>1][self::mods:geographicCode]"/> <!-- SA add 2017-07-14 -->
	</xsl:template>
	
	<xsl:template match="mods:subject[local-name(*[1])='temporal']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">648</xsl:with-param> <!-- SA change from 650 2017-04-20 -->
			<xsl:with-param name="ind2"><xsl:call-template name="authorityInd"/></xsl:with-param> <!-- SA add 2015-01-23 -->
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="*[1]"/>
				</marc:subfield>
				<xsl:apply-templates select="*[position()>1]"/>
				<!-- SA add 2015-10-14 -->
				<xsl:if test="@authority and not(@authority='lcsh') and not(@authority='lcshac') and not(@authority='mesh') and not(@authority='csh') and not(@authority='nal') and not(@authority='rvm')">
					<marc:subfield code="2">
						<xsl:value-of select="@authority"/>
					</marc:subfield>
				</xsl:if>
				<!-- SA add 2017-11-28 -->
				<xsl:if test="@authority='fast' and @valueURI">
					<xsl:call-template name="authorityRecordNumberFAST"/>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>	
	</xsl:template>

	<!-- v3 geographicCode -->
	<!-- SA update reduce creation of duplicate fields from identical mods:geographicCode values 2017-07-14, enhance 2018-06-29 -->
	<xsl:template match="mods:subject/mods:geographicCode[@authority][not(preceding::mods:geographicCode[@authority])]">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">043</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:for-each select="distinct-values(../../mods:subject/mods:geographicCode[@authority='marcgac'])">
					<marc:subfield code='a'>
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="distinct-values(../../mods:subject/mods:geographicCode[@authority='iso3166'])">
					<marc:subfield code='c'>
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- 1/04 fix was 630 -->
	<xsl:template match="mods:subject/mods:hierarchicalGeographic">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">752</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:for-each select="mods:country">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:state">
					<marc:subfield code="b">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:county">
					<marc:subfield code="c">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:city">
					<marc:subfield code="d">
						<xsl:value-of select="."/>
						<xsl:text>.</xsl:text> <!-- SA add 2017-07-14 -->
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:subject/mods:cartographics">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">255</xsl:with-param>
			<xsl:with-param name="subfields">
				<!-- SA reorder subfields 2017-07-14 -->
				<xsl:for-each select="mods:scale">
					<marc:subfield code="a">
						<xsl:if test="matches(., '^\d+:\d+$')">
							<xsl:text>Scale </xsl:text>
						</xsl:if>
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:projection">
					<marc:subfield code="b">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:coordinates">
					<marc:subfield code="c">
						<xsl:choose>
							<!-- SA add support for coordinates already in ISBD format 2018-05-30 -->
							<xsl:when test="matches(., '^\([EW] \d{1,3}°(\d{1,2}''(\d{1,2}&quot;)?)?(--[EW] \d{1,3}°(\d{1,2}''(\d{1,2}&quot;)?)?)?/[NS] \d{1,3}°(\d{1,2}''(\d{1,2}&quot;)?)?(--[NS] \d{1,3}°(\d{1,2}''(\d{1,2}&quot;)?)?)?\)$')">
								<xsl:value-of select="."/>
							</xsl:when>
							<!-- SA enhance to provide ISBD punctuation for input formatted "L.at, L.on" 2017-07-14 -->
							<xsl:otherwise>
								<xsl:variable name="coords" select="tokenize(., ', ')"/>
								<!-- use index of decimal point to truncate to 2 decimal places -->
								<xsl:variable name="latdecindex" select="string-length(substring-before($coords[1], '.')) + 1"/>
								<xsl:variable name="londecindex" select="string-length(substring-before($coords[2], '.')) + 1"/>
								<xsl:text>(</xsl:text>
								<xsl:choose>
									<xsl:when test="starts-with($coords[2], '-')">
										<xsl:text>W </xsl:text>
										<xsl:value-of select="substring($coords[2], 2, $londecindex + 1)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>E </xsl:text>
										<xsl:value-of select="substring($coords[2], 1, $londecindex + 2)"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:text>°/</xsl:text>
								<xsl:choose>
									<xsl:when test="starts-with($coords[1], '-')">
										<xsl:text>S </xsl:text>
										<xsl:value-of select="substring($coords[1], 2, $latdecindex + 1)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>N </xsl:text>
										<xsl:value-of select="substring($coords[1], 1, $latdecindex + 2)"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:text>°)</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
		<!-- SA add 2018-05-30 -->
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">034</xsl:with-param>
			<xsl:with-param name="ind1">
				<xsl:choose>
					<xsl:when test="matches(mods:scale, '1:(\d+,?)+.+1:(\d+,?)+')">3</xsl:when>
					<xsl:when test="matches(mods:scale, '1:(\d+,?)+')">1</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:text>a</xsl:text>
				</marc:subfield>
				<xsl:analyze-string select="mods:scale" regex="1:((\d+,?)+)">
					<xsl:matching-substring>
						<marc:subfield code="b">
							<xsl:value-of select="xs:integer(replace(regex-group(1), '[^\d]', ''))"/>
						</marc:subfield>
					</xsl:matching-substring>
				</xsl:analyze-string>
				<xsl:choose>
					<xsl:when test="matches(mods:coordinates, '^\([EW] \d{1,3}°(\d{1,2}''(\d{1,2}&quot;)?)?/[NS] \d{1,3}°(\d{1,2}''(\d{1,2}&quot;)?)?\)$')"> <!-- point coordinates -->
						<xsl:variable name="coords" select="tokenize(mods:coordinates, '/')"/>
						<xsl:variable name="coordsW" select="tokenize(substring-after($coords[1], '('), '( |°|''|&quot;)')"/>
						<xsl:variable name="coordsN" select="tokenize(substring-before($coords[2], ')'), '( |°|''|&quot;)')"/>
						<marc:subfield code="d">	
							<xsl:value-of select="$coordsW[1]"/>
							<xsl:value-of select="lfn:pad-zeroes($coordsW[2], 3)"/>
							<xsl:value-of select="lfn:pad-zeroes($coordsW[3], 2)"/>
							<xsl:value-of select="lfn:pad-zeroes($coordsW[4], 2)"/>
						</marc:subfield>
						<marc:subfield code="e">	
							<xsl:value-of select="$coordsW[1]"/>
							<xsl:value-of select="lfn:pad-zeroes($coordsW[2], 3)"/>
							<xsl:value-of select="lfn:pad-zeroes($coordsW[3], 2)"/>
							<xsl:value-of select="lfn:pad-zeroes($coordsW[4], 2)"/>
						</marc:subfield>
						<marc:subfield code="f">	
							<xsl:value-of select="$coordsN[1]"/>
							<xsl:value-of select="lfn:pad-zeroes($coordsN[2], 3)"/>
							<xsl:value-of select="lfn:pad-zeroes($coordsN[3], 2)"/>
							<xsl:value-of select="lfn:pad-zeroes($coordsN[4], 2)"/>
						</marc:subfield>
						<marc:subfield code="g">	
							<xsl:value-of select="$coordsN[1]"/>
							<xsl:value-of select="lfn:pad-zeroes($coordsN[2], 3)"/>
							<xsl:value-of select="lfn:pad-zeroes($coordsN[3], 2)"/>
							<xsl:value-of select="lfn:pad-zeroes($coordsN[4], 2)"/>
						</marc:subfield>
					</xsl:when>
					<xsl:when test="matches(mods:coordinates, '^\([EW] \d{1,3}°(\d{1,2}''(\d{1,2}&quot;)?)?(--[EW] \d{1,3}°(\d{1,2}''(\d{1,2}&quot;)?)?)?/[NS] \d{1,3}°(\d{1,2}''(\d{1,2}&quot;)?)?(--[NS] \d{1,3}°(\d{1,2}''(\d{1,2}&quot;)?)?)?\)$')">
						<xsl:variable name="coords" select="tokenize(mods:coordinates, '--|/')"/>
						<xsl:variable name="coordsW" select="tokenize(substring-after($coords[1], '('), '( |°|''|&quot;)')"/>
						<xsl:variable name="coordsE" select="tokenize($coords[2], '( |°|''|&quot;)')"/>
						<xsl:variable name="coordsN" select="tokenize($coords[3], '( |°|''|&quot;)')"/>
						<xsl:variable name="coordsS" select="tokenize(substring-before($coords[4], ')'), '( |°|''|&quot;)')"/>
						<marc:subfield code="d">	
							<xsl:value-of select="$coordsW[1]"/>
							<xsl:value-of select="lfn:pad-zeroes($coordsW[2], 3)"/>
							<xsl:value-of select="lfn:pad-zeroes($coordsW[3], 2)"/>
							<xsl:value-of select="lfn:pad-zeroes($coordsW[4], 2)"/>
						</marc:subfield>
						<marc:subfield code="e">	
							<xsl:value-of select="$coordsE[1]"/>
							<xsl:value-of select="lfn:pad-zeroes($coordsE[2], 3)"/>
							<xsl:value-of select="lfn:pad-zeroes($coordsE[3], 2)"/>
							<xsl:value-of select="lfn:pad-zeroes($coordsE[4], 2)"/>
						</marc:subfield>
						<marc:subfield code="f">	
							<xsl:value-of select="$coordsN[1]"/>
							<xsl:value-of select="lfn:pad-zeroes($coordsN[2], 3)"/>
							<xsl:value-of select="lfn:pad-zeroes($coordsN[3], 2)"/>
							<xsl:value-of select="lfn:pad-zeroes($coordsN[4], 2)"/>
						</marc:subfield>
						<marc:subfield code="g">	
							<xsl:value-of select="$coordsS[1]"/>
							<xsl:value-of select="lfn:pad-zeroes($coordsS[2], 3)"/>
							<xsl:value-of select="lfn:pad-zeroes($coordsS[3], 2)"/>
							<xsl:value-of select="lfn:pad-zeroes($coordsS[4], 2)"/>
						</marc:subfield>
					</xsl:when>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:subject/mods:occupation">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">656</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>				
			</xsl:with-param>
		</xsl:call-template>	
	</xsl:template>
	
	<!-- SA add 2017-05-05 for $t in 600, 610, 611-->
	<xsl:template match="mods:subject[(@*)]/mods:titleInfo">
		<marc:subfield code="t">
			<xsl:value-of select="mods:title"/>
			<xsl:if test="not(following-sibling::*)">.</xsl:if>
		</marc:subfield>
	</xsl:template>
	
	<xsl:template match="mods:subject[(@*)]/mods:genre"> <!-- SA fix 2015-01-13 -->
		<marc:subfield code="v">
			<xsl:value-of select="."/>
			<xsl:if test="not(following-sibling::*) and not(ends-with(., '.'))">.</xsl:if> <!-- SA add 2015-02-05, update 2017-11-16 -->
		</marc:subfield>
	</xsl:template>
	
	<xsl:template match="mods:subject[(@*)]/mods:topic"> <!-- SA fix 2013-08-30 for uncontrolled terms -->
		<marc:subfield code="x">
			<xsl:value-of select="."/>
			<xsl:if test="not(following-sibling::*) and not(ends-with(., '.'))">.</xsl:if> <!-- SA add 2015-02-05, update 2017-11-16 -->
		</marc:subfield>
	</xsl:template>
	
	<xsl:template match="mods:subject[(@*)]/mods:temporal"> <!-- SA fix 2013-08-30 for uncontrolled terms -->
		<marc:subfield code="y">
			<xsl:value-of select="."/>
			<xsl:if test="not(following-sibling::*) and not(ends-with(., '.'))">.</xsl:if> <!-- SA add 2015-02-05, update 2017-11-16 -->
		</marc:subfield>
	</xsl:template>
	
	<xsl:template match="mods:subject[(@*)]/mods:geographic"> <!-- SA fix 2013-08-30 for uncontrolled terms -->
		<marc:subfield code="z">
			<xsl:value-of select="."/>
			<xsl:if test="not(following-sibling::*) and not(ends-with(., '.'))">.</xsl:if> <!-- SA add 2015-02-05, update 2017-11-16 -->
		</marc:subfield>
	</xsl:template>	

	<xsl:template name="titleInfo">
		<xsl:for-each select="mods:title">
			<marc:subfield code="a">
				<xsl:if test="../@supplied"> <!-- SA add 2018-05-30 -->
					<xsl:text>[</xsl:text>
				</xsl:if>
				<xsl:value-of select="../mods:nonSort"/><xsl:value-of select="."/>
				<xsl:if test="../@supplied"> <!-- SA add 2018-05-30 -->
					<xsl:text>]</xsl:text>
				</xsl:if>
				<xsl:choose> <!-- SA add 2015-02-05 -->
					<xsl:when test="following-sibling::mods:subTitle">
						<xsl:text> :</xsl:text>
					</xsl:when>
					<xsl:when test="../following-sibling::mods:note[@type='statement of responsibility']">
						<xsl:text> /</xsl:text>
					</xsl:when>
					<xsl:when test="not(ends-with(., '.')) and not(../@type='uniform')">
						<xsl:text>.</xsl:text>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</marc:subfield>
		</xsl:for-each>
		<!-- 1/04 fix -->
		<xsl:for-each select="mods:subTitle">
			<marc:subfield code="b">
				<xsl:value-of select="."/>
				<xsl:choose> <!-- SA add 2015-02-05 -->
					<xsl:when test="../following-sibling::mods:note[@type='statement of responsibility']">
						<xsl:text> /</xsl:text>
					</xsl:when>
					<xsl:when test="not(ends-with(., '.'))">
						<xsl:text>.</xsl:text>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</marc:subfield>
		</xsl:for-each>
		<xsl:for-each select="mods:partNumber">
			<marc:subfield code="n">
				<xsl:value-of select="."/>
			</marc:subfield>
		</xsl:for-each>
		<xsl:for-each select="mods:partName">
			<marc:subfield code="p">
				<xsl:value-of select="."/>
			</marc:subfield>
		</xsl:for-each>
	</xsl:template>
	
	<!-- SA add 2017-11-09 -->
	<xsl:template name="seriesTitleInfo">
		<xsl:for-each select="mods:title">
			<marc:subfield code="a">
				<xsl:value-of select="../mods:nonSort"/><xsl:value-of select="."/>
				<xsl:if test="following-sibling::mods:subTitle">
					<xsl:text>: </xsl:text>
					<xsl:value-of select="following-sibling::mods:subTitle"/>
				</xsl:if>
				<xsl:if test="mods:partNumber">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="following-sibling::mods:partNumber"/>
				</xsl:if>
				<xsl:if test="mods:partName">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="following-sibling::mods:partName"/>
				</xsl:if>
				<!-- SA check only for 830 2018-05-04 --> 
				<xsl:if test="../@authority and not(ends-with(., '.')) and not(../@type='uniform')">
					<xsl:text>.</xsl:text>
				</xsl:if>
			</marc:subfield>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="stmtOfResponsibility">
		<xsl:for-each select="following-sibling::mods:note[@type='statement of responsibility']">		
			<marc:subfield code='c'>
				<xsl:value-of select="."/>
				<xsl:text>.</xsl:text> <!-- SA add 2018-09-11 -->
			</marc:subfield>
		</xsl:for-each>
	</xsl:template>

<!-- Classification -->

	<!--<xsl:template match="mods:classification[@authority='lcc']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">050</xsl:with-param>
			<xsl:with-param name="ind2">
				<xsl:choose>
				<xsl:when test="../mods:recordInfo/mods:recordContentSource='DLC' or ../mods:recordInfo/mods:recordContentSource='Library of Congress'">0</xsl:when>
				<xsl:otherwise>2</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
-->
	
	<xsl:template match="mods:classification[@authority='ddc']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">082</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
				<xsl:for-each select="@edition">
					<marc:subfield code="2">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:classification[@authority='udc']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">080</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:classification[@authority='nlm']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">060</xsl:with-param>
			<xsl:with-param name="ind2">4</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:classification[@authority='sudocs']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">086</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:classification[@authority='candocs']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">086</xsl:with-param>
			<xsl:with-param name="ind1">1</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- v3.4 -->
	<xsl:template match="mods:classification[@authority='content']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">084</xsl:with-param>
			<xsl:with-param name="ind1">1</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="lcClassification">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">090</xsl:with-param> <!-- SA change from 050 2018-05-30 -->
			
			<!--<xsl:with-param name="ind2">
				<xsl:choose>
					<xsl:when test="../mods:recordInfo/mods:recordContentSource='DLC' or ../mods:recordInfo/mods:recordContentSource='Library of Congress'">0</xsl:when>
					<xsl:otherwise>2</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>-->
			<xsl:with-param name="subfields">
				<xsl:for-each select="mods:classification[@authority='lcc']">
					<marc:subfield code="a">
						<xsl:value-of select="substring-before(., ' ')"/>
					</marc:subfield>
					<marc:subfield code="b">
						<xsl:value-of select="substring-after(., ' ')"/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
<!-- Identifiers -->	
	<!-- v3.4 updated doi subfields and datafield mapping -->
	<xsl:template match="mods:identifier[@type='hdl'] "> <!-- SA remove DOI from this template 2014-09-22 -->
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">024</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
				<marc:subfield code="2">
					<xsl:value-of select="@type"/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:identifier[@type='isbn']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">020</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield>
					<!-- v3.4 updated code to handle invalid isbn -->
					<xsl:attribute name="code">
						<xsl:choose>
							<xsl:when test="@invalid='yes'">z</xsl:when>
							<xsl:otherwise>a</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>	
	<xsl:template match="mods:identifier[@type='isrc']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">024</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield>
					<!-- v3.4 updated code to handle invalid isbn -->
					<xsl:attribute name="code">
						<xsl:choose>
							<xsl:when test="@invalid='yes'">z</xsl:when>
							<xsl:otherwise>a</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="mods:identifier[@type='ismn']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">024</xsl:with-param>
			<xsl:with-param name="ind1">2</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield>
					<!-- v3.4 updated code to handle invalid isbn -->
					<xsl:attribute name="code">
						<xsl:choose>
							<xsl:when test="@invalid='yes'">z</xsl:when>
							<xsl:otherwise>a</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="mods:identifier[@type='issn'] | mods:identifier[@type='issn-l'] ">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">022</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield>
					<!-- v3.4 updated code to handle invalid isbn -->
					<xsl:attribute name="code">
						<xsl:choose>
							<xsl:when test="@invalid='yes'">z</xsl:when>
							<xsl:otherwise>a</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="mods:identifier[@type='issue number']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">028</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>
			<xsl:with-param name="ind2">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="mods:identifier[@type='lccn']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">010</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield>
					<!-- v3.4 updated code to handle invalid isbn -->
					<xsl:attribute name="code">
						<xsl:choose>
							<xsl:when test="@invalid='yes'">z</xsl:when>
							<xsl:otherwise>a</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="mods:identifier[@type='matrix number']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">028</xsl:with-param>
			<xsl:with-param name="ind1">1</xsl:with-param>
			<xsl:with-param name="ind2">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>	
	<xsl:template match="mods:identifier[@type='music publisher']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">028</xsl:with-param>
			<xsl:with-param name="ind1">3</xsl:with-param>
			<xsl:with-param name="ind2">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="mods:identifier[@type='music plate']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">028</xsl:with-param>
			<xsl:with-param name="ind1">2</xsl:with-param>
			<xsl:with-param name="ind2">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="mods:identifier[@type='sici']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">024</xsl:with-param>
			<xsl:with-param name="ind1">4</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield>
					<!-- v3.4 updated code to handle invalid isbn -->
					<xsl:attribute name="code">
						<xsl:choose>
							<xsl:when test="@invalid='yes'">z</xsl:when>
							<xsl:otherwise>a</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- v3.4 -->
	<xsl:template match="mods:identifier[@type='stocknumber']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">037</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="mods:identifier[@type=('uri', 'doi', 'ark')]"> <!-- SA add DOI 2014-09-22, add ARK 2018-06-12 -->
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">856</xsl:with-param>
			<xsl:with-param name="ind1">4</xsl:with-param> <!-- SA add 2014-09-22 -->
			<xsl:with-param name="ind2">0</xsl:with-param> <!-- SA change 2014-09-23 -->
			<xsl:with-param name="subfields">
				<marc:subfield code="u">
					<xsl:value-of select="."/>
				</marc:subfield>
				<xsl:call-template name="mediaType"/>
				<xsl:for-each select="@displayLabel"> <!-- SA add 2014-10-09 -->
					<marc:subfield code="3">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--v3 location/url -->
	<xsl:template match="mods:location[mods:url][not(../mods:identifier[@type=('doi', 'ark')])]"> <!-- SA change to disable if DOI exists 2014-09-22, if ARK exists 2018-06-18 -->
		<xsl:for-each select="mods:url[@usage='primary']"> <!-- SA change to limit to primary URL 2015-01-14 -->
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">856</xsl:with-param>
			<xsl:with-param name="ind1">4</xsl:with-param> <!-- SA add indicators 2015-01-14 -->
			<xsl:with-param name="ind2">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="u">
					<xsl:value-of select="."/>
				</marc:subfield>
				<!-- v3 displayLabel -->
				<xsl:for-each select="@displayLabel">
					<marc:subfield code="3">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="@note"> <!-- SA add 2015-05-04 -->
					<marc:subfield code="z">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="@dateLastAccessed">
					<marc:subfield code="z">
						<xsl:value-of select="concat('Last accessed: ',.)"/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="mods:identifier[@type='upc']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">024</xsl:with-param>
			<xsl:with-param name="ind1">1</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield>
					<!-- v3.4 updated code to handle invalid isbn -->
					<xsl:attribute name="code">
						<xsl:choose>
							<xsl:when test="@invalid='yes'">z</xsl:when>
							<xsl:otherwise>a</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:identifier[@type='videorecording']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">028</xsl:with-param>
			<xsl:with-param name="ind1">4</xsl:with-param>
			<xsl:with-param name="ind2">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="authorityInd">
		<xsl:choose>
			<!-- SA change 2015-10-15 -->
			<xsl:when test="(ancestor-or-self::mods:subject|ancestor-or-self::mods:genre)/@authority='lcsh'">0</xsl:when>
			<xsl:when test="(ancestor-or-self::mods:subject|ancestor-or-self::mods:genre)/@authority='lcshac'">1</xsl:when>
			<xsl:when test="(ancestor-or-self::mods:subject|ancestor-or-self::mods:genre)/@authority='mesh'">2</xsl:when>
			<xsl:when test="(ancestor-or-self::mods:subject|ancestor-or-self::mods:genre)/@authority='csh'">3</xsl:when>
			<xsl:when test="(ancestor-or-self::mods:subject|ancestor-or-self::mods:genre)/@authority='nal'">5</xsl:when>
			<xsl:when test="(ancestor-or-self::mods:subject|ancestor-or-self::mods:genre)/@authority='rvm'">6</xsl:when>
			<xsl:when test="(ancestor-or-self::mods:subject|ancestor-or-self::mods:genre)/@authority">7</xsl:when>
			<xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise><!-- v3 blank ind2 fix-->
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mods:relatedItem/mods:identifier[@type='uri']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">856</xsl:with-param>
			<xsl:with-param name="ind2">2</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="u">
					<xsl:value-of select="."/>
				</marc:subfield>
				<xsl:call-template name="mediaType"/>
			</xsl:with-param>
		</xsl:call-template>		
	</xsl:template>
	
	<!-- v3 physicalLocation -->
	<xsl:template match="mods:location[mods:physicalLocation]">
		<xsl:for-each select="mods:physicalLocation">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">852</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
					<!-- v3 displayLabel -->
					<xsl:for-each select="@displayLabel">
						<marc:subfield code="3">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:for-each>
				</xsl:with-param>
			</xsl:call-template>		
		</xsl:for-each>
		<xsl:apply-templates/> <!-- SA add 2018-07-20 -->
	</xsl:template>
	
	<!-- SA add 2018-07-20 to support item records for print materials -->
	<xsl:template match="mods:location[mods:holdingSimple][1]">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">946</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="u">
					<xsl:text>+l</xsl:text>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">949</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:text>*ov=.</xsl:text>
					<xsl:value-of select="../mods:recordInfo/mods:recordIdentifier[@source='DRB'][matches(., '^b\d+x?')]"/>
					<xsl:text>;</xsl:text>
					<xsl:text>b2=n;</xsl:text>
					<xsl:text>b3=-;</xsl:text>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:apply-templates select="mods:holdingSimple/mods:copyInformation"/>
	</xsl:template>
	<xsl:template match="mods:location[mods:holdingSimple][position()>1]">
		<xsl:apply-templates select="mods:holdingSimple/mods:copyInformation"/>
	</xsl:template>
	<xsl:template match="mods:copyInformation">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">949</xsl:with-param>
			<xsl:with-param name="ind2">1</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="w">
					<xsl:value-of select="mods:note[@type='item type']"/>
				</marc:subfield>
				<marc:subfield code="l">
					<xsl:value-of select="mods:subLocation"/>
				</marc:subfield>
				<marc:subfield code="u">
					<xsl:text>950</xsl:text>
					<xsl:choose>
						<xsl:when test="mods:shelfLocator[@type='lc']">01</xsl:when>
						<xsl:when test="mods:shelfLocator[@type='dewey']">02</xsl:when>
						<xsl:when test="mods:shelfLocator[@type='accession']">04</xsl:when>
					</xsl:choose>
				</marc:subfield>
				<xsl:if test="not(mods:shelfLocator[@type='lc'])">
					<marc:subfield code="b">
						<xsl:value-of select="mods:shelfLocator"/>
					</marc:subfield>
				</xsl:if>
				<marc:subfield code="z">
					<xsl:value-of select="mods:itemIdentifier[@type='barcode']"/>
				</marc:subfield>
				<xsl:if test="mods:enumerationAndChronology">
					<marc:subfield code="e">
						<xsl:value-of select="mods:enumerationAndChronology"/>
					</marc:subfield>
					<marc:subfield code="g">
						<xsl:analyze-string select="mods:enumerationAndChronology" regex="(\d+)">
							<xsl:matching-substring>
								<xsl:value-of select="regex-group(1)"/>
							</xsl:matching-substring>
						</xsl:analyze-string>
					</marc:subfield>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

<!-- v3.4 add physical location url -->
	<xsl:template match="mods:location[mods:physicalLocation[@xlink]]">
		<xsl:for-each select="mods:physicalLocation">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">852</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="u">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>		
		</xsl:for-each>
	</xsl:template>
	<!-- v3.4 location url -->
	<xsl:template match="mods:location[mods:uri]">
		<xsl:for-each select="mods:uri">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">852</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield>
						<xsl:choose>
							<xsl:when test="@displayLabel='content'">3</xsl:when>
							<xsl:when test="@dateLastAccessed='content'">z</xsl:when>
							<xsl:when test="@note='contents of subfield'">z</xsl:when>
							<xsl:when test="@access='preview'">3</xsl:when>
							<xsl:when test="@access='raw object'">3</xsl:when>
							<xsl:when test="@access='object in context'">3</xsl:when>
							<xsl:when test="@access='primary display'">z</xsl:when>
						</xsl:choose>
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>		
		</xsl:for-each>
	</xsl:template>	
	
	<!-- SA disable copying to 887 field 2013-10-25 -->
	<!--<xsl:template match="mods:extension">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">887</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>		
	</xsl:template>-->
	<!-- 1/04 fix -->
	<!--<xsl:template match="mods:internetMediaType">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">856</xsl:with-param>
			<xsl:with-param name="ind2">2</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="q">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>		
	</xsl:template>	-->

	<xsl:template name="mediaType">
		<!-- SA change to select first MIME type 2014-09-22, change to only create $q if exactly 1 type 2018-05-08 -->
		<xsl:if test="count(../mods:physicalDescription/mods:internetMediaType) eq 1">
			<marc:subfield code="q">
				<xsl:value-of select="../mods:physicalDescription/mods:internetMediaType"/>
			</marc:subfield>
		</xsl:if>
	</xsl:template>	
	
	<xsl:template name="form">
		<xsl:if test="../mods:physicalDescription/mods:form[@authority='gmd']">
			<marc:subfield code="h">
				<xsl:value-of select="../mods:physicalDescription/mods:form[@authority='gmd']"/>
			</marc:subfield>
		</xsl:if>
	</xsl:template>	
	
	<!-- v3 isReferencedBy -->
	<xsl:template match="mods:relatedItem[@type='isReferencedBy']">	
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">510</xsl:with-param>		
			<xsl:with-param name="subfields">
				<xsl:variable name="noteString">
					<xsl:for-each select="*">
						<xsl:value-of select="concat(.,', ')"/>
					</xsl:for-each>
				</xsl:variable>
				<marc:subfield code="a">
					<xsl:value-of select="substring($noteString, 1,string-length($noteString)-2)"/>
				</marc:subfield>
				<!--<xsl:call-template name="relatedItem76X-78X"/>-->
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:relatedItem[@type='series']">
		<!-- v3 build series type -->
		<!-- SA change to provide 490, 830 support 2017-11-09 -->
			<xsl:for-each select="mods:titleInfo[not(@authority)]">
				<xsl:call-template name="datafield">
					<xsl:with-param name="tag">490</xsl:with-param>
					<xsl:with-param name="ind1">
						<xsl:choose>
							<xsl:when test="../../mods:relatedItem[@type='series']/mods:titleInfo[@authority]">1</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>					
					<xsl:with-param name="subfields">
						<xsl:call-template name="seriesTitleInfo"/>
					</xsl:with-param>
				</xsl:call-template>					
			</xsl:for-each>
			<xsl:for-each select="mods:titleInfo[@authority]">
				<xsl:call-template name="datafield">
					<xsl:with-param name="tag">830</xsl:with-param>
					<xsl:with-param name="ind2">0</xsl:with-param>					
					<xsl:with-param name="subfields">
						<xsl:call-template name="seriesTitleInfo"/>
					</xsl:with-param>
				</xsl:call-template>					
			</xsl:for-each>
			<xsl:for-each select="mods:name">
				<xsl:call-template name="datafield">
					<xsl:with-param name="tag">
						<xsl:choose>
							<xsl:when test="@type='personal'">800</xsl:when>
							<xsl:when test="@type='corporate'">810</xsl:when>
							<xsl:when test="@type='conference'">811</xsl:when>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="subfields">
						<marc:subfield code="a">
							<xsl:value-of select="mods:namePart"/>
						</marc:subfield>
						<xsl:if test="@type='corporate'">
							<xsl:for-each select="mods:namePart[position()>1]">
								<marc:subfield code="b">
									<xsl:value-of select="."/>
								</marc:subfield>
							</xsl:for-each>
						</xsl:if>
						<xsl:if test="@type='personal'">
							<xsl:for-each select="mods:namePart[@type='termsOfAddress']">
								<marc:subfield code="c">
									<xsl:value-of select="."/>
								</marc:subfield>
							</xsl:for-each>								
							<xsl:for-each select="mods:namePart[@type='date']">
								<!-- v3 namepart/date was $a; fixed to $d -->
								<marc:subfield code="d">
									<xsl:value-of select="."/>
								</marc:subfield>
							</xsl:for-each>
						</xsl:if>
						<!-- v3 role -->
						<xsl:if test="@type!='conference'">
							<xsl:for-each select="mods:role/mods:roleTerm[@type='text']">
								<marc:subfield code="e">
									<xsl:value-of select="lower-case(.)"/> <!-- SA change 2015-02-05 -->
								</marc:subfield>
							</xsl:for-each>
						</xsl:if>
						<xsl:for-each select="mods:role/mods:roleTerm[@type='code']">
							<xsl:if test="not(../mods:roleTerm[@type='text'])"> <!-- SA change to skip if $e is used 2014-09-23 -->
								<marc:subfield code="4">
									<xsl:value-of select="."/>
								</marc:subfield>
							</xsl:if>
						</xsl:for-each>
					</xsl:with-param>
				</xsl:call-template>			
			</xsl:for-each>
	</xsl:template>

	<xsl:template match="mods:relatedItem[not(@type)]">
	<!-- v3 was type="related" -->
		   	<xsl:call-template name="datafield">
			<xsl:with-param name="tag">787</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>			
			<xsl:with-param name="subfields">
				<xsl:call-template name="relatedItem76X-78X"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:relatedItem[@type='preceding']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">780</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>
			<xsl:with-param name="ind2">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:call-template name="relatedItem76X-78X"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:relatedItem[@type='succeeding']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">785</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>
			<xsl:with-param name="ind2">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:call-template name="relatedItem76X-78X"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="mods:relatedItem[@type='otherVersion']">	
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">775</xsl:with-param>			
			<xsl:with-param name="subfields">
				<xsl:call-template name="relatedItem76X-78X"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:relatedItem[@type='otherFormat']">
		<xsl:call-template name="dateOfWork"/> <!-- SA update 2017-07-26 -->
		<xsl:if test="mods:titleInfo or mods:recordInfo"> <!-- SA change 2014-10-09, 2017-08-18 -->
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">776</xsl:with-param>
				<xsl:with-param name="ind1">0</xsl:with-param> <!-- SA add 2016-03-18 -->
				<xsl:with-param name="ind2">8</xsl:with-param> <!-- SA add 2016-03-18 -->
				<xsl:with-param name="subfields">
					<xsl:call-template name="relatedItem76X-78X"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mods:relatedItem[@type='original']">
		<xsl:call-template name="dateOfWork"/> <!-- SA add 2017-07-26 -->
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">534</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:call-template name="relatedItem76X-78X"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="printClassification"/> <!-- SA add 2018-05-30 -->
	</xsl:template>

	<xsl:template match="mods:relatedItem[@type='host']">
		<xsl:call-template name="datafield"> <!-- SA add 2015-04-02 -->
			<xsl:with-param name="tag">580</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:text>Part of the </xsl:text>
					<xsl:value-of select="mods:titleInfo/mods:title"/>
					<xsl:text> digital collection.</xsl:text>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">773</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<!-- v3 displaylabel -->
				<xsl:for-each select="@displaylabel">
					<marc:subfield code="3">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<!-- v3 part/text -->
				<xsl:for-each select="mods:part/mods:text">
					<marc:subfield code="g">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<!-- v3 sici part/detail 773$q 	1:2:3<4-->			
				<xsl:if test="mods:part/mods:detail">
					<xsl:variable name="parts">				
						<xsl:for-each select="mods:part/mods:detail">
							<xsl:value-of select="concat(mods:number,':')"/>
						</xsl:for-each>
					</xsl:variable>					
					<marc:subfield code="q">						
						<xsl:value-of select="concat(substring($parts,1,string-length($parts)-1),'&lt;',mods:part/mods:extent/mods:start)"/>
					</marc:subfield>
				</xsl:if>
				<xsl:call-template name="relatedItem76X-78X"/>
			</xsl:with-param>		
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:relatedItem[@type='constituent']">
		<xsl:call-template name="datafield">
			<!-- SA change tag and indicators 2017-11-15 -->
			<xsl:with-param name="tag">700</xsl:with-param>
			<xsl:with-param name="ind1">1</xsl:with-param>
			<xsl:with-param name="ind2">2</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:call-template name="relatedItem76X-78X"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- v3 changed this to not@type -->
	<!--<xsl:template match="mods:relatedItem[@type='related']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">787</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:call-template name="relatedItem76X-78X"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
-->
	<xsl:template name="relatedItem76X-78X">
		<!-- SA move to front of field 2016-07-13 -->
		<!-- v3 displaylabel -->
		<xsl:for-each select="@displayLabel">
			<!-- SA add 2017-07-26 -->
			<xsl:choose>
				<xsl:when test="../@type='original'">
					<marc:subfield code="p">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:when>
				<xsl:otherwise>
					<marc:subfield code="i">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<!-- SA rearrange 2016-07-13, update 2017-11-15 -->
		<xsl:if test="@type='otherFormat' or @type='original' or @type='constituent'">
			<xsl:call-template name="relatedItemNames"/>
		</xsl:if>
		<!-- SA add 2017-07-26 -->
		<xsl:if test="@type='original'">
			<xsl:for-each select="mods:originInfo"> <!-- SA update 2018-05-30 -->
				<!-- adapted from code for 264 -->
				<marc:subfield code="c">
					<xsl:for-each select="mods:place/mods:placeTerm[@type='text']">
						<xsl:choose> <!-- SA add brackets when @supplied 2015-11-23 -->
							<xsl:when test="../@supplied='yes'">
								<xsl:text>[</xsl:text>
								<xsl:value-of select="."/>
								<xsl:text>]</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="."/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:if test="../../mods:publisher"> <!-- SA add 2015-11-23, update 2017-01-27 -->
							<xsl:text> : </xsl:text>
						</xsl:if>
					</xsl:for-each>
					<xsl:for-each select="mods:publisher">
						<xsl:choose>
							<xsl:when test="@supplied='yes'">
								<xsl:text>[</xsl:text>
								<xsl:value-of select="."/>
								<xsl:text>]</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="."/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:if test="following-sibling::mods:dateIssued[@encoding='w3cdtf']">
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:for-each>
					<xsl:for-each select="mods:dateIssued[@point='start'][@encoding='w3cdtf'] | mods:dateIssued[not(@point)][@encoding='w3cdtf']">
						<!-- SA add brackets when @drb:supplied 2017-05-05, @qualifier=("questionable", "inferred") 2018-06-12 -->
						<xsl:if test="@drb:supplied='yes' or @qualifier=('questionable', 'inferred')">
							<xsl:text>[</xsl:text>
						</xsl:if>
						<xsl:value-of select="substring(.,1,4)"/>
						<!-- v3.4 generate question mark for dateIssued with qualifier="questionable" -->
						<xsl:if test="@qualifier='questionable'">?</xsl:if>
						<!-- v3.4 Generate a hyphen before end date -->
						<xsl:if test="mods:dateIssued[@point='end'][@encoding='w3cdtf']">
							- <xsl:value-of select="../mods:dateIssued[@point='end'][@encoding='w3cdtf']"/>
						</xsl:if>
						<!-- SA add brackets when @drb:supplied 2017-05-05, @qualifier=("questionable", "inferred") 2018-06-12 -->
						<xsl:if test="@drb:supplied='yes' or @qualifier=('questionable', 'inferred')">
							<xsl:text>]</xsl:text>
						</xsl:if>
						<!-- SA add 2015-02-05, update 2015-11-23, 2017-05-05, 2017-07-27 -->
						<xsl:choose>
							<xsl:when test="../mods:edition">
								<xsl:text>,</xsl:text>
							</xsl:when>
							<xsl:when test="not(@qualifier='questionable') and not(@drb:supplied) and
								not(../mods:edition)">
								<xsl:text>.</xsl:text>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</marc:subfield>
			</xsl:for-each>
			<xsl:for-each select="mods:originInfo/mods:edition">
				<marc:subfield code="b">
					<xsl:choose>
						<xsl:when test="@supplied='yes'">
							<xsl:text>[</xsl:text>
							<xsl:value-of select="."/>
							<xsl:text>]</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="."/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text>.</xsl:text>
				</marc:subfield>
			</xsl:for-each>
		</xsl:if>
		<xsl:for-each select="mods:titleInfo">
			<xsl:for-each select="mods:title">
				<xsl:choose>
					<xsl:when test="not(ancestor-or-self::mods:titleInfo/@type)">
						<marc:subfield code="t">
							<!-- SA change 2017-11-09 to account for nonfiling characters -->
							<xsl:choose>
								<xsl:when test="preceding-sibling::mods:nonSort">
									<xsl:value-of select="concat(upper-case(substring(., 1, 1)), substring(., 2))"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="."/>
								</xsl:otherwise>
							</xsl:choose>
							<!-- SA add 2017-01-26, update 2017-11-16 -->
							<xsl:if test="not(ends-with(., '.')) and 
								(../../mods:originInfo/*[@encoding='w3cdtf'] or ancestor::mods:relatedItem[@type='constituent'])">
								<xsl:text>.</xsl:text>
							</xsl:if>
						</marc:subfield>
					</xsl:when>
					<xsl:when test="ancestor-or-self::mods:titleInfo/@type='uniform'">
						<marc:subfield code="s">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:when>
					<xsl:when test="ancestor-or-self::mods:titleInfo/@type='abbreviated'">
						<marc:subfield code="p">
						<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:when>
				</xsl:choose>			
			</xsl:for-each>	
			<xsl:for-each select="mods:partNumber">
				<marc:subfield code="g">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:for-each>	
			<xsl:for-each select="mods:partName">
				<marc:subfield code="g">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:for-each>	
		</xsl:for-each>		
		<!-- 1/04 fix -->
		<!-- SA update 2017-11-15 -->
		<xsl:if test="not(@type='otherFormat' or @type='original' or @type='constituent')">
			<xsl:call-template name="relatedItemNames"/>
		</xsl:if>
		<!-- 1/04 fix -->
		<xsl:choose>		
			<xsl:when test="@type='original'"><!-- 534 -->
				<xsl:for-each select="mods:physicalDescription/mods:extent">
					<marc:subfield code="e">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="@type!='original'">
				<xsl:for-each select="mods:physicalDescription/mods:extent">
					<marc:subfield code="h">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
		<!-- SA add 2014-09-23, revise 2016-07-13, 2016-12-16, 2017-01-20 -->
		<xsl:if test="@type='otherFormat'">
			<!-- SA add 2016-05-26, update 2018-02-01, 2018-05-04 -->
			<xsl:if test="mods:originInfo/*[not(../@eventType='publication')][@encoding='w3cdtf'] and not(mods:titleInfo/mods:partName or mods:titleInfo/mods:partNumber)">
				<xsl:variable name="dates" select="mods:originInfo/*[@encoding='w3cdtf']"/>
				<marc:subfield code="d">
					<xsl:choose>
						<xsl:when test="$dates[2]">
							<xsl:value-of select="concat($dates[1], '-', $dates[2])"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring($dates, 1, 4)"/>
						</xsl:otherwise>
					</xsl:choose>
				</marc:subfield>
			</xsl:if>
			<!-- SA add 2018-04-30 -->
			<xsl:for-each select="mods:originInfo[@eventType='publication']">
				<!-- adapted from code for 264 -->
				<marc:subfield code="d">
					<xsl:for-each select="mods:place/mods:placeTerm[@type='text']">
						<xsl:choose> <!-- SA add brackets when @supplied 2015-11-23 -->
							<xsl:when test="../@supplied='yes'">
								<xsl:text>[</xsl:text>
								<xsl:value-of select="."/>
								<xsl:text>]</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="."/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:if test="../../mods:publisher"> <!-- SA add 2015-11-23, update 2017-01-27 -->
							<xsl:text> : </xsl:text>
						</xsl:if>
					</xsl:for-each>
					<xsl:for-each select="mods:publisher">
						<xsl:choose>
							<xsl:when test="@supplied='yes'">
								<xsl:text>[</xsl:text>
								<xsl:value-of select="."/>
								<xsl:text>]</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="."/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:if test="following-sibling::mods:dateIssued[@encoding='w3cdtf']">
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:for-each>
					<xsl:for-each select="mods:dateIssued[@point='start'][@encoding='w3cdtf'] | mods:dateIssued[not(@point)][@encoding='w3cdtf']">
						<!-- SA add brackets when @drb:supplied 2017-05-05, @qualifier=("questionable", "inferred") 2018-06-12 -->
						<xsl:if test="@drb:supplied='yes' or @qualifier=('questionable', 'inferred')">
							<xsl:text>[</xsl:text>
						</xsl:if>
						<xsl:value-of select="substring(.,1,4)"/>
						<!-- v3.4 generate question mark for dateIssued with qualifier="questionable" -->
						<xsl:if test="@qualifier='questionable'">?</xsl:if>
						<!-- v3.4 Generate a hyphen before end date -->
						<xsl:if test="mods:dateIssued[@point='end'][@encoding='w3cdtf']">
							- <xsl:value-of select="../mods:dateIssued[@point='end'][@encoding='w3cdtf']"/>
						</xsl:if>
						<!-- SA add brackets when @drb:supplied 2017-05-05, @qualifier=("questionable", "inferred") 2018-06-12 -->
						<xsl:if test="@drb:supplied='yes' or @qualifier=('questionable', 'inferred')">
							<xsl:text>]</xsl:text>
						</xsl:if>
						<!-- SA add 2015-02-05, update 2015-11-23, 2017-05-05, 2017-07-27 -->
						<xsl:choose>
							<xsl:when test="../mods:edition">
								<xsl:text>,</xsl:text>
							</xsl:when>
							<xsl:when test="not(@qualifier='questionable') and not(@drb:supplied) and
								not(../mods:edition)">
								<xsl:text>.</xsl:text>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</marc:subfield>
			</xsl:for-each>
		</xsl:if>
		<xsl:for-each select="mods:note">
			<marc:subfield code="n">
				<xsl:value-of select="."/>
			</marc:subfield>
		</xsl:for-each>
		<!-- SA update 2016-12-14 -->
		<xsl:for-each select="mods:identifier[not(@type)]|
			mods:location/mods:holdingSimple/mods:copyInformation/mods:shelfLocator">
			<marc:subfield code="o">
				<xsl:value-of select="."/>
			</marc:subfield>
		</xsl:for-each>
		<xsl:for-each select="mods:identifier[@type='issn']">
			<marc:subfield code="x">
				<xsl:value-of select="."/>
			</marc:subfield>
		</xsl:for-each>
		<xsl:for-each select="mods:identifier[@type='isbn']">
			<marc:subfield code="z">
				<xsl:value-of select="."/>
			</marc:subfield>
		</xsl:for-each>
		<!-- SA change to preference recordIdentifier over local identifier 2014-09-22 -->
		<!-- SA disable sharing local identifiers 2016-03-18 -->
		<!--<xsl:for-each select="mods:identifier[@type='local'][not(../mods:recordInfo/mods:recordIdentifier[@source])]">
			<marc:subfield code="w">
				<xsl:value-of select="."/>
			</marc:subfield>
		</xsl:for-each>-->
		<xsl:for-each select="mods:recordInfo/mods:recordIdentifier[@source='OCoLC']"> <!-- SA add 2014-09-22, update 2018-07-20 -->
			<marc:subfield code="w">
				<xsl:text>(</xsl:text><xsl:value-of select="@source"/><xsl:text>)</xsl:text>
				<!-- SA add 2017-11-09, remove leading zeroes from OCLC record numbers -->
				<xsl:value-of select="xs:integer(replace(., 'on|ocn|ocm', ''))"/> <!-- SA update 2018-05-31 -->
			</marc:subfield>
		</xsl:for-each>
		<!-- SA disable duplicate $n 2017-08-18 -->
		<!--<xsl:for-each select="mods:note">  
			<marc:subfield code="n">
				<xsl:value-of select="."/>
			</marc:subfield>
		</xsl:for-each>		-->		
	</xsl:template>
	
	<!-- SA update 2017-11-15, 2017-11-20 -->
	<xsl:template name="relatedItemNames">
		<xsl:if test="mods:name[mods:role/mods:roleTerm='creator' or mods:role/mods:roleTerm='author']">
			<xsl:choose>
				<xsl:when test="@type='constituent'"> <!-- 700/710 name/title -->
					<marc:subfield code="a">
						<xsl:for-each select="mods:name|../mods:name[@usage='primary']">
							<xsl:value-of select="string-join(mods:namePart, ', ')"/>
							<xsl:if test="not(ends-with(mods:namePart[last()], '.'))"> <!-- SA add 2017-01-26 -->
								<xsl:text>.</xsl:text>
							</xsl:if>
						</xsl:for-each>
					</marc:subfield>
				</xsl:when>
				<xsl:otherwise>
					<marc:subfield code="a">
						<xsl:variable name="nameString">
							<xsl:for-each select="mods:name">			
								<xsl:value-of select="string-join(mods:namePart, ', ')"/>
								<xsl:choose>
									<xsl:when test="mods:role/mods:roleTerm[@type='text']">
										<xsl:value-of select="concat(', ',mods:role/mods:roleTerm[@type='text'])"/>
									</xsl:when>	
									<xsl:when test="mods:role/mods:roleTerm[@type='code']">
										<xsl:value-of select="concat(', ',mods:role/mods:roleTerm[@type='code'])"/>
									</xsl:when>
								</xsl:choose>
							</xsl:for-each>
							<xsl:text>, </xsl:text>
						</xsl:variable>
						<xsl:value-of select="substring($nameString, 1,string-length($nameString)-2)"/>
						<xsl:text>.</xsl:text>
					</marc:subfield>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<!-- SA add as new template 2017-07-26 -->
	<xsl:template name="dateOfWork">
		<!-- SA 2016-10-18 add 388 support for dates of work, update 2017-07-27, 2017-08-18, 2017-11-15, 2018-05-31, 2018-06-12, 2018-07-12 -->
		<xsl:for-each select="mods:originInfo/(*[@encoding=('w3cdtf', 'fast')][not(@point='end' 
			and preceding-sibling::*[@encoding=('w3cdtf', 'fast')][@point='start'])])">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">388</xsl:with-param>
				<xsl:with-param name="ind1">1</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">
						<xsl:choose>
							<xsl:when test="@encoding='fast'">
								<xsl:value-of select="."/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="@point='end'">-</xsl:if>
								<xsl:value-of select="substring(., 1, 4)"/>
								<xsl:if test="@point='start'">-</xsl:if>
								<xsl:value-of select="substring(following-sibling::*[@encoding='w3cdtf' or
									@encoding='fast'][@point='end'], 1, 4)"/>
							</xsl:otherwise>
						</xsl:choose>
					</marc:subfield>
					<xsl:if test="@encoding='fast'">
						<marc:subfield code="2">fast</marc:subfield>
					</xsl:if>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	
	<!-- SA add 2017-11-14 -->
	<xsl:template name="localRecordSource">
		<xsl:for-each select="mods:recordInfo/mods:recordContentSource[@authority='local']">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">910</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	
	<!-- SA add 2018-03-15 -->
	<xsl:template name="localBibNumber">
		<xsl:for-each select="mods:extension/drb:flag[@type='marc']/@sierraRecordNumber">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">907</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">
						<xsl:value-of select="concat('.', .)"/>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	
	<!-- SA add 2017-11-28, update 2018-02-01, 2018-05-30 -->
	<xsl:template name="authorityRecordNumberFAST">
		<xsl:variable name="URInode" select="ancestor-or-self::*[@valueURI]"/>
		<marc:subfield code="0">
			<xsl:if test="not(contains($URInode/@valueURI, '(OCoLC)fst'))">
				<xsl:text>(OCoLC)fst</xsl:text>
			</xsl:if>
			<xsl:value-of select="lfn:pad-zeroes(tokenize($URInode/@valueURI, '/')[last()], 8)"/>
		</marc:subfield>
	</xsl:template>
	
	<!-- SA add 2018-05-30 -->
	<xsl:template name="printClassification">
		<xsl:if test="mods:classification[@authority='lcc']">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">852</xsl:with-param>
				<xsl:with-param name="ind1">0</xsl:with-param>
				<xsl:with-param name="ind2">1</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="h">
						<xsl:value-of select="mods:classification[@authority='lcc']"/>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- v3 not used?
		<xsl:variable name="leader06">
			<xsl:choose>
				<xsl:when test="mods:typeOfResource='text'">
					<xsl:choose>
						<xsl:when test="@manuscript='yes'">t</xsl:when>
						<xsl:otherwise>a</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="mods:typeOfResource='cartographic'">
					<xsl:choose>
						<xsl:when test="@manuscript='yes'">f</xsl:when>
						<xsl:otherwise>e</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="mods:typeOfResource='notated music'">
					<xsl:choose>
						<xsl:when test="@manuscript='yes'">d</xsl:when>
						<xsl:otherwise>c</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="mods:typeOfResource='sound recording'">j</xsl:when>
				<xsl:when test="mods:typeOfResource='still image'">k</xsl:when>
				<xsl:when test="mods:typeOfResource='moving image'">g</xsl:when>
				<xsl:when test="mods:typeOfResource='three dimensional object'">r</xsl:when>
				<xsl:when test="mods:typeOfResource='software, multimedia'">m</xsl:when>
				<xsl:when test="mods:typeOfResource='mixed material'">p</xsl:when>
			</xsl:choose>
		</xsl:variable>
-->
</xsl:stylesheet>