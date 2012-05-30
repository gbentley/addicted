<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  version="1.0">
  <!-- 
	
		dictfinish.xsl	pike@labforculture.org 200807
		
		usage: xsltproc usecomments.xsl  input.ts  > output.ts


		"use comments for missing translations"
		
		takes a dict file, returns a dict file, 
		where all instances of translations that have
		no content have been entered the value 
		of the "comment". 
		
		this is (only) usefull for english 
		translation of 'tokenized' text, where the english
		version is in the comment.
		
		a la
		
		<message >
			<source>banner-teaser</money>
			<comment>Get your goods here</comment>
			<translation type="unfinished"></translation>
		</message>

		to

		<message>
			<source>banner-teaser</money>
			<comment>Get your goods here</comment>
			<translation>Get your goods here</translation>
		</message>

		
	-->

  <xsl:output
    method="xml" 
    encoding="utf-8" 
    omit-xml-declaration="yes"
    indent="yes"
    doctype-system="TS" />

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
      <message>
        
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
           	d<xsl:copy-of select="translation" />
          </xsl:otherwise>
        </xsl:choose>
      </message>
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
