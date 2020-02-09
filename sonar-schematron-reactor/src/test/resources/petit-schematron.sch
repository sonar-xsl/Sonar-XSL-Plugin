<?xml version="1.0" encoding="UTF-8"?>
<sch:schema
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:sonar="http://www.jimetevenard.com/ns/sonar-xslt"
    queryBinding="xslt2">
    
    <sch:ns uri="http://www.w3.org/1999/XSL/Transform" prefix="xsl"/>
    
    <sch:pattern>
        <sch:rule context="xsl:variable">
            <sonar:name rel="typed-variables">Variables Should be Typed</sonar:name>
            <sonar:description rel="typed-variables">
                <html:p>It is a good practice to type your variables.</html:p>
                <html:p>It's really a good practice. trust me.</html:p>
            </sonar:description>
            <sonar:tags rel="typed-variables">
                <sonar:tag>typing</sonar:tag>
                <sonar:tag>code-style</sonar:tag>
            </sonar:tags>
            <sonar:type rel="typed-variables">bug</sonar:type>
            <sch:assert test="@as" id="typed-variables" sonar:type="TODO" sonar:severity="TODO" >
                Please provide a type for varaible <sch:value-of select="@name"/>
            </sch:assert>
            <!-- more asserts/reports... -->
        </sch:rule>
        <sch:rule context="xsl:stylesheet/xsl:variable | xsl:stylesheet/xsl:param">
            <sonar:name rel="global-var-param-default-value">Global params/variables should have a default value</sonar:name>
            <sch:assert test="@select | element()" id="global-var-param-default-value" sonar:type="TODO" sonar:severity="TODO">
                Global params/variables should have a default value
            </sch:assert>
            
            <sonar:name rel="global-var-param-namespace" >Global params/variables should have a namespace</sonar:name>
            <sonar:description rel="global-var-param-namespace">
                <html:p>Global params/variables should have a namespace to avoid confusion.</html:p>
            </sonar:description>
            <sch:report test="namespace-uri(@name) = ''" id="global-var-param-namespace" sonar:type="TODO" sonar:severity="TODO">
                Global params/variables should have a namespace to avoid confusion
            </sch:report>
        </sch:rule>
    </sch:pattern>
</sch:schema>