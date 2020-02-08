<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:saxon="http://saxon.sf.net/"
  xmlns:sonar="http://www.jimetevenard.com/ns/sonar-xslt"
  xmlns:html="http://www.w3.org/1999/xhtml"
  queryBinding="xslt3"
  id="xsl-common.sch">
  
  <ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
  <ns prefix="xd" uri="http://www.oxygenxml.com/ns/doc/xsl"/>
  <ns prefix="saxon" uri="http://saxon.sf.net/"/>
  
  <xsl:key name="getElementById" match="*" use="@id"/>
  
  <let name="NCNAME.reg" value="'[\i-[:]][\c-[:]]*'"/>
  <let name="xslt.version" value="/*/@version"/>
  
  <!--====================================-->
  <!--            DIAGNOSTICS             -->
  <!--====================================-->
  
  <diagnostics>
    <diagnostic id="addType">Add @as attribute</diagnostic>
  </diagnostics>
  
  <!--====================================-->
  <!--              PHASE                 -->
  <!--====================================-->
  
  <!--<phase id="test">
    <active pattern="xslt-quality_common"/>
    <active pattern="xslt-quality_documentation"/>
    <active pattern="xslt-quality_typing"/>
    <active pattern="xslt-quality_namespaces"/>
    <active pattern="xslt-quality_writing"/>
	</phase>-->
  
  <!--====================================-->
  <!--              MAIN                 -->
  <!--====================================-->
  
  <sonar:description rel="exemple-description">
    <html:p>Ceci est un exemple de descrption.<html:br/>Toutes les règles devraient être documentées.</html:p>
    
    <html:p>Le formalisme des descriptions est décrit <html:a href="https://docs.sonarqube.org/display/DEV/Coding+Rule+Guidelines">sur cette page</html:a>.</html:p>
    
    <html:blockquote>
      <html:p>Un paragraphe dans une citation.</html:p>
    </html:blockquote>
    <html:h2>Noncompliant Code Example</html:h2>
    
    <html:p>Ce qui suit ne doit pas être fait...</html:p>
    
    <html:pre>
      &lt;xsl:template match="node() | @*"&gt;
      &lt;xsl:copy&gt;
      &lt;xsl:apply-templates select="node() | @*" /&gt;
      &lt;/xsl:copy&gt;
      &lt;/xsl:template&gt;
    </html:pre>
    
    <html:h2>Compliant Solution</html:h2>
    
    <html:p>Ceci en revanche, doit être fait...</html:p>
    
    <html:pre>
      &lt;xsl:template match="node() | @*"&gt;
      &lt;xsl:copy&gt;
      &lt;xsl:apply-templates select="node() | @*" /&gt;
      &lt;/xsl:copy&gt;
      &lt;/xsl:template&gt;
    </html:pre>
    
    <html:h2>See</html:h2>
    
    <html:ul>
      <html:li>Ce lien là : <html:a href="http://jimetevenard.com/">informations</html:a>
      </html:li>
      <html:li>Ce lien là : <html:a href="http://jimetevenard.com/">D'autre infos</html:a>
      </html:li>
    </html:ul>
    
  </sonar:description>
  
  <pattern id="xslt-quality_common">
    <rule context="xsl:for-each">
      <sonar:name rel="xslt-quality_avoid-for-each">"xsl:apply-templates" should be prefered to "xsl:for-each"</sonar:name>
      <sonar:description rel="xslt-quality_avoid-for-each">
        <html:h2>TODO description à rédiger</html:h2>
        
        <html:p>Ceci est un exemple de descrption.<html:br/>Toutes les règles devraient être documentées.</html:p>
        
        <html:p>Le formalisme des descriptions est décrit <html:a href="https://docs.sonarqube.org/display/DEV/Coding+Rule+Guidelines">sur cette page</html:a>.</html:p>
        
        <html:blockquote>
          <html:p>Un paragraphe dans une citation.</html:p>
        </html:blockquote>
        
        <html:h2>Noncompliant Code Example</html:h2>
        
        <html:p>Ce qui suit ne doit pas être fait...</html:p>
        
        <html:pre>
          &lt;xsl:template match="node() | @*"&gt;
          &lt;xsl:copy&gt;
          &lt;xsl:apply-templates select="node() | @*" /&gt;
          &lt;/xsl:copy&gt;
          &lt;/xsl:template&gt;
        </html:pre>
        
        <html:h2>Compliant Solution</html:h2>
        
        <html:p>Ceci en revanche, doit être fait...</html:p>
        
        <html:pre>
          &lt;xsl:template match="node() | @*"&gt;
          &lt;xsl:copy&gt;
          &lt;xsl:apply-templates select="node() | @*" /&gt;
          &lt;/xsl:copy&gt;
          &lt;/xsl:template&gt;
        </html:pre>
        
        <html:h2>See</html:h2>
        
        <html:ul>
          <html:li>Ce lien là : <html:a href="http://jimetevenard.com/">informations</html:a>
          </html:li>
          <html:li>Ce lien là : <html:a href="http://jimetevenard.com/">D'autre infos</html:a>
          </html:li>
        </html:ul>
        
      </sonar:description>
      <sonar:tags rel="xslt-quality_avoid-for-each">
        <sonar:tag>xsl-common</sonar:tag>
      </sonar:tags>
      <report test="ancestor::xsl:template          and not(starts-with(@select, '$'))         and not(starts-with(@select, 'tokenize('))         and not(starts-with(@select, 'distinct-values('))         and not(matches(@select, '\d'))"
        role="warning"
        id="xslt-quality_avoid-for-each">
        Consider using "&lt;xsl:apply-template &gt;" instead of "&lt;xsl:for-each &gt;"
      </report>
    </rule>
    <rule context="xsl:template/@match | xsl:*/@select | xsl:when/@test">
      <!-- TODO type => bug ? -->
      <sonar:name rel="xslt-quality_use-resolve-uri-instead-of-concat">"resolve-uri()" should be used to resolve relatives URIs</sonar:name>
      <sonar:description rel="xslt-quality_use-resolve-uri-instead-of-concat">TODO description</sonar:description>
      <sonar:type rel="xslt-quality_use-resolve-uri-instead-of-concat">bug</sonar:type>
      <sonar:tags rel="xslt-quality_use-resolve-uri-instead-of-concat">
        <sonar:tag>xsl-common</sonar:tag>
      </sonar:tags>
      <report test="contains(., 'document(concat(') or contains(., 'doc(concat(')"
        id="xslt-quality_use-resolve-uri-instead-of-concat">
        Don't use concat within <value-of select="if (contains(.,'document(')) then 'document()' else 'doc()'"/> function, use resolve-uri instead. (you may use static-base-uri() or base-uri())
      </report>
    </rule>
  </pattern>
  
  <pattern id="xslt-quality_documentation">
    <rule context="/xsl:stylesheet">
      <!-- TODO cf. Matthieu : rétrogradé en role="info" -->
      <sonar:name rel="xslt-quality_documentation-stylesheet">Stylesheet should be documented</sonar:name>
      <sonar:tags rel="xslt-quality_documentation-stylesheet">
        <sonar:tag>documentation</sonar:tag>
      </sonar:tags>
      <assert test="xd:doc[@scope = 'stylesheet']"
        id="xslt-quality_documentation-stylesheet"
        role="info">
        Add a documentation block for the whole stylesheet : &lt;xd:doc scope="stylesheet"&gt;.
      </assert>
    </rule>
  </pattern>
  
  <pattern id="xslt-quality_typing">
    <rule context="xsl:variable | xsl:param  | xsl:with-param | xsl:function">
      <sonar:name rel="xslt-quality_typing-with-as-attribute">Parameters, variables and functions declarations should be typed</sonar:name>
      <sonar:description rel="xslt-quality_typing-with-as-attribute">
        
        <html:p>It is good practice to explicitely specify the required type of a variable, parameter, or the return value of a function</html:p>
        
        <html:ul>
          <html:li>Untyped values can lead to unxecepted behavior</html:li>
          <html:li>The debuging is quite faster and the testability of the stylesheet is truly improved.</html:li>
        </html:ul>
        
        <html:blockquote>
          <html:p>[Definition: The context within a stylesheet where an XPath expression appears may specify the required type of the expression. The required type indicates the type of the value that the expression is expected to return.] If no required type is specified, the expression may return any value: in effect, the required type is then item()*.</html:p>
        </html:blockquote>
        
        <html:h2>Noncompliant Code Example</html:h2>
        
        <html:pre>
          &lt;xsl:variable name="foo" select="./invoces/invoice[@status = 'paid']" /&gt;
        </html:pre>
        
        <html:h2>Compliant Solution</html:h2>
        
        <html:pre>
          &lt;xsl:variable name="foo" select="./invoces/invoice[@status = 'paid']" as="element(invoice)*"/&gt;
        </html:pre>
        
        <html:h2>See</html:h2>
        
        <html:ul>
          <html:li>Related chapter in <html:a href="https://www.w3.org/TR/xslt-30/#dt-required-type">W3C XSLT 3.0 Specications</html:a>
          </html:li>
        </html:ul>
        
      </sonar:description>
      <sonar:tags rel="xslt-quality_typing-with-as-attribute">
        <sonar:tag>typing</sonar:tag>
      </sonar:tags>
      <assert test="@as"
        diagnostics="addType"
        id="xslt-quality_typing-with-as-attribute">
        Provide an explicit type for the <name/> 
        <value-of select="./@name"/>.
      </assert>
    </rule>
  </pattern>
  
  <pattern id="xslt-quality_namespaces">
    <rule context="xsl:template/@name | /*/xsl:variable/@name | /*/xsl:param/@name">
      <sonar:name rel="xslt-quality_ns-global-statements-need-prefix">Global statements names should be prefixed</sonar:name>
      <sonar:description rel="xslt-quality_ns-global-statements-need-prefix">TODO description</sonar:description>
      <sonar:tags rel="xslt-quality_ns-global-statements-need-prefix">
        <sonar:tag>namespaces</sonar:tag>
      </sonar:tags>
      <assert test="every $name in tokenize(., '\s+') satisfies matches($name, concat('^', $NCNAME.reg, ':'))"
        role="warning"
        id="xslt-quality_ns-global-statements-need-prefix">
        Add a namespace prefix to <value-of select="local-name(parent::*)"/> 
        <name/>="<value-of select="tokenize(., '\s+')[not(matches(., concat('^', $NCNAME.reg, ':')))]"/>" , so it doesn't generate conflict with imported XSLT. (or when this xslt is imported)
      </assert>
    </rule>
    <rule context="xsl:template/@mode">
      <sonar:name rel="xslt-quality_ns-mode-statements-need-prefix">Mode statements should be prefixed</sonar:name>
      <sonar:description rel="xslt-quality_ns-mode-statements-need-prefix">TODO description</sonar:description>
      <sonar:tags rel="xslt-quality_ns-mode-statements-need-prefix">
        <sonar:tag>namespaces</sonar:tag>
      </sonar:tags>
      <assert test="every $name in tokenize(., '\s+') satisfies matches($name, concat('^', $NCNAME.reg, ':'))"
        role="warning"
        id="xslt-quality_ns-mode-statements-need-prefix">
        Add a namespace prefix to <value-of select="local-name(parent::*)"/> @<name/> value "<value-of select="tokenize(., '\s+')[not(matches(., concat('^', $NCNAME.reg, ':')))]"/>" , so it doesn't generate conflict with imported XSLT. (or when this xslt is imported)
      </assert>
    </rule>    
    <rule context="@match | @select">
      <sonar:name rel="xslt-quality_ns-do-not-use-wildcard-prefix">Wildcard prefix should be avoided</sonar:name>
      <sonar:description rel="xslt-quality_ns-do-not-use-wildcard-prefix">TODO description</sonar:description>
      <sonar:tags rel="xslt-quality_ns-do-not-use-wildcard-prefix">
        <sonar:tag>namespaces</sonar:tag>
      </sonar:tags>
      <report test="contains(., '*:')"
        id="xslt-quality_ns-do-not-use-wildcard-prefix">
        Use a namespace prefix instead of "*:".
      </report>
    </rule>
  </pattern>
  
  <pattern id="xslt-quality_writing">
    <rule context="xsl:attribute | xsl:namespace | xsl:variable | xsl:param | xsl:with-param">
      <!-- TODO cf. Matthieu : doublon avec xsl-quality.sch => xslqual-SettingValueOfVariableIncorrectly -->
      <sonar:name rel="xslt-quality_writing-use-select-attribute-when-possible">TODO xslt-quality_writing-use-select-attribute-when-possible</sonar:name>
      <sonar:description rel="xslt-quality_writing-use-select-attribute-when-possible">TODO description</sonar:description>
      <sonar:tags rel="xslt-quality_writing-use-select-attribute-when-possible">
        <sonar:tag>writing</sonar:tag>
      </sonar:tags>
      <report id="xslt-quality_writing-use-select-attribute-when-possible"
        test="not(@select) and (count(* | text()[normalize-space(.)]) = 1) and (count(xsl:value-of | xsl:sequence | text()[normalize-space(.)]) = 1)">
        Use "@select" to assign a value to <name/>
      </report>
    </rule>
  </pattern>
  
  <pattern id="xslt-quality_xslt-3.0">
    <rule context="xsl:import[$xslt.version = '3.0']">
      <!-- TODO cf. Matthieu : Pourquoi ? -->
      <sonar:name rel="xslt-quality_xslt-3.0-import-first">"xsl:import" should come after the "xd:doc" block</sonar:name>
      <sonar:description rel="xslt-quality_xslt-3.0-import-first">TODO description</sonar:description>
      <sonar:tags rel="xslt-quality_xslt-3.0-import-first">
        <sonar:tag>xslt-30</sonar:tag>
      </sonar:tags>
      <report id="xslt-quality_xslt-3.0-import-first"
        test="following-sibling::xd:doc"
        role="info">
        When using XSLT 3.0 xsl:import may come after the xd:doc block
      </report>
    </rule>
  </pattern>
  
</schema>
