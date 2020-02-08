<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:sonar="http://www.jimetevenard.com/ns/sonar-xslt"
    exclude-result-prefixes="xs sch" 
    version="2.0">
    
    <xsl:output method="xml" indent="yes" />
    
    <xsl:param name="add-descriptions" as="xs:boolean" select="false()" />
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/*">
        <xsl:copy>
            <xsl:namespace name="sonar">http://www.jimetevenard.com/ns/sonar-xslt</xsl:namespace>
            <xsl:apply-templates select="node() | @*" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="sch:assert | sch:report">
        <xsl:if test="not(exists(./sonar:name))">
            <sonar:name rel="{@id}"><xsl:value-of select="concat('TODO ',@id)"/></sonar:name>
        </xsl:if>
        <xsl:if test="not(exists(./sonar:description)) and $add-descriptions">
            <sonar:description rel="{@id}">TODO description</sonar:description>
        </xsl:if>
        <xsl:copy-of select="."></xsl:copy-of>
    </xsl:template>
    
</xsl:stylesheet>