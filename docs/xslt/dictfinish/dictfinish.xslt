<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"; 
  version="1.0">
  <!-- 
	
		dictfinish.xsl	pike@labforculture.org 2007
		
		usage: xsltproc dictfinish.xsl  input.ts  > output.ts


		takes a dict file, returns a dict file, 

		where all instances of "unfinished"
		translations have been entered the value of the "source"
		a la
		
		<message >
			<source>money</money>
			<translation type="unfinished"></translation>
		</message>

		to

		<message>
			<source>money</money>
			<translation>money</translation>
		</message>

		
	-->

  <xsl:output>
    method="xml" 
    encoding="iso-8859-1" 
    omit-xml-declaration="yes"
    indent="yes"
    doctype-system="TS"
  </xsl:output>

  <xsl:template match="TS">
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
    <xsl:if test="translation/@type!='obsolete'">
      <xsl:copy>
        <xsl:apply-templates select="@*"/>
        <xsl:variable name="sourceNode" select="source"/>
        <source>
          <xsl:value-of select="$sourceNode"/>
        </source>
        <xsl:copy-of select="comment"/>
        <xsl:choose>
          <xsl:when test="translation/@type='unfinished'">
            <translation>
              <xsl:value-of select="$sourceNode"/>
            </translation>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="translation"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:copy/>
  </xsl:template>

</xsl:stylesheet>
