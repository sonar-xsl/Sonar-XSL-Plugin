<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:sonar="http://www.jimetevenard.com/ns/sonar-xslt"
    xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs sch"
    version="3.0">
    
    <xsl:output indent="yes"></xsl:output>
    
    <xsl:preserve-space elements="*"/>
    
    
    <xsl:template match="node() | @*">
        <!-- IDENTITY -->
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" />
        </xsl:copy>
    </xsl:template>
    
    
    
   <!-- <xsl:template match="sonar:*">
        <xsl:copy-of select="." />
    </xsl:template>-->
    <xsl:template match="sch:assert | sch:report">
        <xsl:if test="@sonar:type">
            <sonar:type>
                <xsl:attribute name="rel" select="@id" />
                <xsl:value-of select="@sonar:type"/>
            </sonar:type>
        </xsl:if>
        <xsl:if test="@sonar:tags">
            <sonar:tags>
                <xsl:attribute name="rel" select="@id" />
                <xsl:for-each select="tokenize(@sonar:tags,'\s+')">
                    <sonar:tag>
                        <xsl:value-of select="."/>
                    </sonar:tag>
                </xsl:for-each>
            </sonar:tags>
        </xsl:if>
        <xsl:next-match />
    </xsl:template>
    
    <xsl:template match="@sonar:type">
       
    </xsl:template>
    
    <xsl:template match="@sonar:tags">
        
        
    </xsl:template>
    
</xsl:stylesheet>