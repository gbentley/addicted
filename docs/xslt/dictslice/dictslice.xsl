<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version = "1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exsl="http://exslt.org/common"
	extension-element-prefixes="exsl">
	<!-- 
	
		dictslice.xsl	pike@labforculture.org 2007
		
		usage: xsltproc dictslice.xsl  input.ts  > output.ts
		
		takes a ts file, creates a ts file
		the created file is a slice of the original file, containing
		only the contexts listed in variable $contexts
		
		if you set the $invert variable to true, it returns
		all the contexts *not* listed in variable $contexts

		requires exsl
		
	-->
  <xsl:output
    method="xml" 
    encoding="UTF-8" 
    omit-xml-declaration="yes"
    indent="yes"
    doctype-system="TS" />


	<xsl:variable name="invert" select="true()" />

	<xsl:variable name="contexts">
		<name>content/classes</name>
		<name>design/simplemail/form</name>
		<name>design/eurocult</name>
		<name>thesaurus/types</name>
	</xsl:variable>
        
	<xsl:template match="/">
	   	<TS>
			<xsl:for-each select="//context">
				<xsl:variable name="context" select="."  />
				<xsl:if test="not($invert)">
					<xsl:for-each select="exsl:node-set($contexts)/name[.=$context/name]">
						<xsl:apply-templates select="$context" />
					</xsl:for-each>
				</xsl:if>
				<xsl:if test="$invert">
					<xsl:if test="count(exsl:node-set($contexts)/name[.=$context/name])=0">
						<xsl:apply-templates select="$context" />
					</xsl:if>
				</xsl:if>
			</xsl:for-each>
		</TS>
	</xsl:template>

	<xsl:template match="context" >
		<xsl:copy>
			<xsl:apply-templates />
		</xsl:copy>			
	</xsl:template>

	<xsl:template match="@*">
	    <xsl:copy>
		<xsl:value-of select="." />
	    </xsl:copy>
	</xsl:template>
	
	<xsl:template match="*">
	    <xsl:copy>
		<xsl:apply-templates select="@*" />
		<xsl:apply-templates />
	    </xsl:copy>
	</xsl:template>

</xsl:stylesheet>
			
