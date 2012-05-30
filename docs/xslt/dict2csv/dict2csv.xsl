<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version = "1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- 
	
		dictxsl/dict2csv.xsl	pike@labforculture.org 2007
		
		usage: xsltproc dict2csv.xsl  input.ts  > output.csv
		
		takes a dict file, returns a csv file		
		of all the messages of the type specified in $type

		note, csv files can be copy/pasted into microsnot excell easily

		eg, from

		<context>
			<name>admin/browse</name>
			<message>
				<source>money</source>
				<translation type="unfinished">geld</translation>
			</message>
			<message>
				<source>pay</source>
				<translation type="unfinished">betalen</translation>
			</message>
		</context>

		to
		
		"/admin/browse",	"money",	"geld"
		"/admin/browse",	"pay",		"betalen"
		
	-->
	<xsl:output method="text" indent="yes"  />

        <xsl:variable name="type">unfinished</xsl:variable>

        <xsl:template match="/">
	   	<xsl:apply-templates select="//context" />
        </xsl:template>

	<xsl:template match="context" >
		<xsl:variable name="cname" select="name" />
		<xsl:for-each select="message/translation[@type=$type]">
			<xsl:variable name="trans" select="." />
			<xsl:for-each select="../source"><xsl:text>
</xsl:text>&quot;<xsl:value-of select="$cname" />&quot;,	&quot;<xsl:value-of select="." />&quot;,	&quot;<xsl:value-of select="$trans" />&quot;
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
			
