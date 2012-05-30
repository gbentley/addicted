<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- 
	
		dictxsl/filteredunfinished.xsl	pike@labforculture.org 2007
		
		returns a dict file, containing only instances of "unfinished"
		translations from the source file
		
		<message>
			<source>money</money>
			<translation type='unfinished'>geld</translation>
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

  <xsl:template match="*">
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="message">
    <xsl:if test="translation/@type='unfinished'">
      <xsl:copy-of select="." />
    </xsl:if>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:copy/>
  </xsl:template>

</xsl:stylesheet>
