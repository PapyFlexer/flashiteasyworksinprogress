<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:variable
        name = "textes"
        select ="//TextParameterSet" />
	<xsl:variable
            name = "images"
            select ="//ImgParameterSet" />
	<xsl:variable
                name = "videos"
                select ="//VideoParameterSet" />
	<xsl:template match="/">
		<html>
			<head>
				<title>iOS version of FIE website</title>
			</head>
			<body>
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
    
	<xsl:template match="//ImgParameterSet/source">
		<xsl:call-template name="displayImg" >
			<xsl:with-param name="img" select="."/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="//VideoParameterSet/source">
		<xsl:variable name="txt" select="." />
		<p> video :<xsl:value-of select="." /></p>
	</xsl:template>

	<xsl:template match="//TextParameterSet/text">
		<xsl:call-template name="displayText" >
			<xsl:with-param name="txt" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	
	<!-- affichage des liste -->
	
	<!-- ===================================== -->
	
	<xsl:template name="displayText" >
		<xsl:param name="txt" />
		<p><xsl:value-of select="$txt" /></p>
	</xsl:template>
	
	<xsl:template name="displayImg" >
		<xsl:param name="img" />
		<img src="../{$img}" />
	</xsl:template>
    
</xsl:stylesheet>
