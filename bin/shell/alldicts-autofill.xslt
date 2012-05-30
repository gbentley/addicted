<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"	version="1.0">
<!-- 

	alldicts-autofill.xsl pike@labforculture.org 200906
	
	usage: xsltproc alldicts-autofill.xsl	 input.ts	 > output.ts


	"use comments for missing translations"
	
	takes a dict file, returns a dict file, 
	where all instances of translations that have
	no content will have been given the value 
	of the "comment". the translation will
	still be set to 'unfinished', but ezpublish
	will use it for i18n.
	
	this is (only) usefull for the 
	translation of 'tokenized' text, 
	where the translated text is in 
	the comment.
	
	for example, this transforms
	
	<message >
		<source>banner-teaser</money>
		<comment>Get your goods here</comment>
		<translation type="unfinished"></translation>
	</message>

	to

	<message>
		<source>banner-teaser</money>
		<comment>Get your goods here</comment>
		<translation type="unfinished">Get your goods here</translation>
	</message>

	
-->

	<xsl:output
		method="xml" 
		encoding="utf-8" 
		omit-xml-declaration="yes"
		indent="yes"
		doctype-system="TS" />
	<xsl:strip-space elements="message TS context" />
	
	<xsl:template match="TS">
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="context">
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="name">
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="message">
		<xsl:if test="translation[not(@type) or @type!='obsolete']">
			<xsl:element name="message">
				<xsl:variable name="sourceNode" select="source"/>
				<xsl:variable name="commentNode" select="comment"/>
				<xsl:copy-of select="source" />
				<xsl:copy-of select="comment" />
				<xsl:choose>
					<xsl:when test="not(translation/text())">
						<xsl:element name="translation">
							<xsl:attribute name="type">unfinished</xsl:attribute>
							<xsl:value-of select="$commentNode"/>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
							<xsl:copy-of select="translation" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:if>
		<xsl:if test="translation[@type='obsolete']">
			<xsl:copy>
				<xsl:apply-templates/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template match="@*">
		<xsl:copy/>
	</xsl:template>

</xsl:stylesheet>
