<?xml version="1.0" encoding="UTF-8"?>
<!--
CHANGELOG : 
  - 2018-05-13 : Take into account Text Value Template with XSLT 3.0 and namespaced variables and its scope
  - 2018-05-11 : #xslqual-SettingValueOfVariableIncorrectly, #xslqual-SettingValueOfParamIncorrectly : take xsl:sequence into account in addition to xsl:value-of
     + check if there is no non-empty text-node under the variable/param, which would be an reason to not use @select
  - 2018-05-11 : rule "xslqual-RedundantNamespaceDeclarations" : take into account some xsl attributes (@select, @as, @name, @mode)
  - 2018-05-11 : reviewing roles
  - 2017-11-05 : rule "xslqual-SettingValueOfParamIncorrectly" : extend rule to xsl:sequence
  - 2017-11-05 : rule "xslqual-UnusedFunction" : extends xsl xpath attributes
  - 2017-11-05 : rule "xslqual-UnusedFunction" : extends to function call in Attribute Value Template
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xs="http://www.w3.org/2001/XMLSchema"
        xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
        xmlns:xslq="https://github.com/mricaud/xsl-quality"
        xmlns:sonar="http://www.jimetevenard.com/ns/sonar-xslt"
        queryBinding="xslt2"
        id="xsl-qual">
  
  <ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
  <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
  <ns prefix="xd" uri="http://www.oxygenxml.com/ns/doc/xsl"/>
  <ns prefix="xslq" uri="https://github.com/mricaud/xsl-quality"/>
  
  <!--<xsl:import href="xslt-quality.xsl"/>-->
  
  <!--
      This rules are an schematron implementation of Mukul Gandhi XSL QUALITY xslt 
      at http://gandhimukul.tripod.com/xslt/xslquality.html
      Some rules have not bee reproduced :
          - xslqual-NullOutputFromStylesheet
          - xslqual-DontUseNodeSetExtension
          - xslqual-ShortNames
          - xslqual-NameStartsWithNumeric
    -->
  
  <!--====================================-->
  <!--              MAIN                 -->
  <!--====================================-->
  
   <!-- Sonar rules redaction tips : https://docs.sonarqube.org/display/DEV/Coding+Rule+Guidelines -->
  
  <pattern id="xslqual">
      <rule context="xsl:stylesheet">
         <sonar:name rel="xslqual-RedundantNamespaceDeclarations">Stylesheets should not have unused namespace declarations</sonar:name>
         <sonar:tags xmlns:html="http://www.w3.org/1999/xhtml"
                     rel="xslqual-RedundantNamespaceDeclarations">
            <sonar:tag>xslqual</sonar:tag>
         </sonar:tags>
         <assert id="xslqual-RedundantNamespaceDeclarations"
                 test="every $s in in-scope-prefixes(.)[not(. = ('xml', ''))] satisfies          exists(//(*[not(self::xsl:stylesheet)] | @*[not(parent::xsl:*)] | xsl:*/@select | xsl:*/@as | xsl:*/@name | xsl:*/@mode)         [starts-with(name(), concat($s, ':')) or starts-with(., concat($s, ':'))])"
                 role="warning">
        <!--[xslqual] There are redundant namespace declarations in the xsl:stylesheet element-->
        There are namespace prefixes that are declared in the xsl:stylesheet element but never used anywhere 
      </assert>
         <sonar:name rel="xslqual-TooManySmallTemplates">Too many low-granular templates should be avoided</sonar:name>
         <sonar:description rel="xslqual-TooManySmallTemplates">TODO needs description !</sonar:description>
         <sonar:tags xmlns:html="http://www.w3.org/1999/xhtml"
                     rel="xslqual-TooManySmallTemplates">
            <sonar:tag>xslqual</sonar:tag>
         </sonar:tags>
         <report id="xslqual-TooManySmallTemplates"
                 test="count(//xsl:template[@match and not(@name)][count(*) &lt; 3]) &gt;= 10"
                 role="info">
        [xslqual] Too many low granular templates in the stylesheet (10 or more)
      </report>
         <sonar:name rel="xslqual-MonolithicDesign">Stylesheets code should be modularized</sonar:name>
         <sonar:tags xmlns:html="http://www.w3.org/1999/xhtml" rel="xslqual-MonolithicDesign">
            <sonar:tag>xslqual</sonar:tag>
         </sonar:tags>
         <report id="xslqual-MonolithicDesign"
                 test="count(//xsl:template | //xsl:function) = 1"
                 role="warning">
        [xslqual] Using a single template/function in the stylesheet. You can modularize the code.
      </report>
         <sonar:name rel="xslqual-NotUsingSchemaTypes">Built-in XSD types should be used</sonar:name>
         <sonar:description rel="xslqual-NotUsingSchemaTypes">TODO needs description !</sonar:description>
         <sonar:tags xmlns:html="http://www.w3.org/1999/xhtml" rel="xslqual-NotUsingSchemaTypes">
            <sonar:tag>xslqual</sonar:tag>
         </sonar:tags>
         <report id="xslqual-NotUsingSchemaTypes"
                 test="(@version = ('2.0', '3.0')) and not(some $x in .//@* satisfies contains($x, 'xs:'))"
                 role="info">
        [xslqual] The stylesheet is not using any of the built-in Schema types (xs:string etc.), when working in XSLT <value-of select="@version"/> mode
      </report>
      </rule>
      <rule context="xsl:output">
         <sonar:name rel="xslqual-OutputMethodXml">"html" output method should be used when generating HTML code</sonar:name>
         <sonar:description rel="xslqual-OutputMethodXml">TODO needs description !</sonar:description>
         <sonar:tags xmlns:html="http://www.w3.org/1999/xhtml" rel="xslqual-OutputMethodXml">
            <sonar:tag>xslqual</sonar:tag>
         </sonar:tags>
         <report id="xslqual-OutputMethodXml"
                 test="(@method = 'xml') and starts-with(//xsl:template[.//html or .//HTML]/@match, '/')">
        Use output method 'html' instead of 'xml' when generating HTML code
      </report>
      </rule>
      <rule context="xsl:variable">
         <!-- TODO merge with xslqual-SettingValueOfParamIncorrectly -->
         <sonar:name rel="xslqual-SettingValueOfVariableIncorrectly">"@select" ashould be prefered to "xsl:value-of" or "xsl:sequence" to assign a variable</sonar:name>
         <sonar:description rel="xslqual-SettingValueOfVariableIncorrectly">TODO needs description !</sonar:description>
         <sonar:tags xmlns:html="http://www.w3.org/1999/xhtml"
                     rel="xslqual-SettingValueOfVariableIncorrectly">
            <sonar:tag>xslqual</sonar:tag>
         </sonar:tags>
         <report id="xslqual-SettingValueOfVariableIncorrectly"
                 test="(count(*) = 1) and (count(xsl:value-of | xsl:sequence) = 1) and (normalize-space(string-join(text(), '')) = '')">
            Assign value to the variable $<value-of select="@name"/> using the 'select' syntax if assigning a value with xsl:value-of (or xsl:sequence)
      </report>
         <sonar:name rel="xslqual-UnusedVariable">Unused variables should be avoided</sonar:name>
         <sonar:tags xmlns:html="http://www.w3.org/1999/xhtml" rel="xslqual-UnusedVariable">
            <sonar:tag>xslqual</sonar:tag>
         </sonar:tags>
         <assert id="xslqual-UnusedVariable"
                 role="warning"
                 test="xslq:var-or-param-is-referenced-within-its-scope(.)">
        Variable $<value-of select="@name"/> is unused within its scope
      </assert>
      </rule>
      <rule context="xsl:param">
         <sonar:name rel="xslqual-SettingValueOfParamIncorrectly">"@select" should be prefered to "xsl:value-of" or "xsl:sequence" to assign a param</sonar:name>
         <sonar:description rel="xslqual-SettingValueOfParamIncorrectly">TODO needs description !</sonar:description>
         <sonar:tags xmlns:html="http://www.w3.org/1999/xhtml"
                     rel="xslqual-SettingValueOfParamIncorrectly">
            <sonar:tag>xslqual</sonar:tag>
         </sonar:tags>
         <report id="xslqual-SettingValueOfParamIncorrectly"
                 role="warning"
                 test="(count(*) = 1) and (count(xsl:value-of | xsl:sequence) = 1)  and (normalize-space(string-join(text(), '')) = '')">
         Assign value to the parameter $<value-of select="@name"/> using the 'select' syntax if assigning a value with xsl:value-of (or xsl:sequence)
      </report>
         <sonar:name rel="xslqual-UnusedParameter">Unused parameters should be avoided</sonar:name>
         <sonar:tags xmlns:html="http://www.w3.org/1999/xhtml" rel="xslqual-UnusedParameter">
            <sonar:tag>xslqual</sonar:tag>
         </sonar:tags>
         <assert id="xslqual-UnusedParameter"
                 role="warning"
                 test="xslq:var-or-param-is-referenced-within-its-scope(.)">
        Parameter $<value-of select="@name"/> is unused within its scope
      </assert>
      </rule>
      <rule context="xsl:for-each | xsl:if | xsl:when | xsl:otherwise">
         <sonar:name rel="xslqual-EmptyContentInInstructions">Loops and conditionnal structures should not be empty</sonar:name>
         <sonar:tags xmlns:html="http://www.w3.org/1999/xhtml"
                     rel="xslqual-EmptyContentInInstructions">
            <sonar:tag>xslqual</sonar:tag>
         </sonar:tags>
         <report id="xslqual-EmptyContentInInstructions"
                 role="warning"
                 test="(count(node()) = count(text())) and (normalize-space() = '')">
        This &lt;<value-of select="name()"/>&gt; instruction is empty.
      </report>
      </rule>
      <rule context="xsl:function[(:ignore function library stylesheet:)       count(//xsl:template[@match][(@mode, '#default')[1] = '#default']) != 0]">
         <sonar:name rel="xslqual-UnusedFunction">Unused fonctions should be avoided</sonar:name>
         <sonar:description rel="xslqual-UnusedFunction">TODO except library</sonar:description>
         <sonar:tags xmlns:html="http://www.w3.org/1999/xhtml" rel="xslqual-UnusedFunction">
            <sonar:tag>xslqual</sonar:tag>
         </sonar:tags>
         <assert id="xslqual-UnusedFunction"
                 role="warning"
                 test="xslq:function-is-called-within-its-scope(.)">
        Function <value-of select="@name"/> is unused in the stylesheet
      </assert>
         <!--<report id="xslqual-UnusedFunction" role="warning"
        test="not(some $x in //(xsl:template/@match | xsl:*/@select | xsl:when/@test) satisfies contains($x, @name)) 
        and not(some $x in //(*[not(self::xsl:*)]/@*) satisfies contains($x, concat('{', @name, '(')))">
        [xslqual] Function is unused in the stylesheet
      </report>-->
         <sonar:name rel="xslqual-FunctionComplexity">Complex functions should be modularized</sonar:name>
         <sonar:description rel="xslqual-FunctionComplexity">TODO desc ?</sonar:description>
         <sonar:tags xmlns:html="http://www.w3.org/1999/xhtml" rel="xslqual-FunctionComplexity">
            <sonar:tag>xslqual</sonar:tag>
         </sonar:tags>
         <report id="xslqual-FunctionComplexity"
                 role="info"
                 test="count(.//xsl:*) &gt; 50">
            The size/complexity  of function <value-of select="@name"/> is high. There is need for refactoring the code.
      </report>
      </rule>
      <rule context="xsl:template">
         <sonar:name rel="xslqual-UnusedNamedTemplate">Named templates should be used in the stylesheet</sonar:name>
         <sonar:tags xmlns:html="http://www.w3.org/1999/xhtml" rel="xslqual-UnusedNamedTemplate">
            <sonar:tag>xslqual</sonar:tag>
         </sonar:tags>
         <report id="xslqual-UnusedNamedTemplate"
                 role="warning"
                 test="@name and not(@match) and not(//xsl:call-template/@name = @name)">
         Named template <value-of select="@name"/> in unused in the stylesheet
      </report>
         <sonar:name rel="xslqual-TemplateComplexity">Complex templates should be modularized</sonar:name>
         <sonar:description rel="xslqual-TemplateComplexity">TODO desc ?</sonar:description>
         <sonar:tags xmlns:html="http://www.w3.org/1999/xhtml" rel="xslqual-TemplateComplexity">
            <sonar:tag>xslqual</sonar:tag>
         </sonar:tags>
         <report id="xslqual-TemplateComplexity"
                 role="info"
                 test="count(.//xsl:*) &gt; 50">
            The size/complexity of template <value-of select="@name"/> is high. There is need for refactoring the code.
      </report>
      </rule>
      <rule context="xsl:element">
         <sonar:name rel="xslqual-NotCreatingElementCorrectly">Direct element creation should be prefered to xsl:element where possible</sonar:name>
         <sonar:description rel="xslqual-NotCreatingElementCorrectly">TODO desc obligatoire !!</sonar:description>
         <sonar:tags xmlns:html="http://www.w3.org/1999/xhtml"
                     rel="xslqual-NotCreatingElementCorrectly">
            <sonar:tag>xslqual</sonar:tag>
         </sonar:tags>
         <report id="xslqual-NotCreatingElementCorrectly"
                 test="not(contains(@name, '$') or (contains(@name, '(') and contains(@name, ')')) or          (contains(@name, '{') and contains(@name, '}')))">
        Create element node &lt;<value-of select="@name"/>&gt; directly instead of using the &lt;xsl:element&gt; instruction.
      </report>
      </rule>
      <rule context="xsl:apply-templates">
         <!-- TODO not code smell, bug ! -->
         <!-- TODO, possible de récupérer $var dans le message ? -->
         <sonar:name rel="xslqual-AreYouConfusingVariableAndNode">Variable references should not be confused whith node refenrences</sonar:name>
         <sonar:description rel="xslqual-AreYouConfusingVariableAndNode">TODO desc obligatoire !!</sonar:description>
         <sonar:tags xmlns:html="http://www.w3.org/1999/xhtml"
                     rel="xslqual-AreYouConfusingVariableAndNode">
            <sonar:tag>xslqual</sonar:tag>
         </sonar:tags>
         <report id="xslqual-AreYouConfusingVariableAndNode"
                 test="some $var in ancestor::xsl:template[1]//xsl:variable satisfies          (($var &lt;&lt; .) and starts-with(@select, $var/@name))">
        You might be confusing a variable reference with a node reference
      </report>
      </rule>
      <rule context="@*">
         <!-- TODO, near root ? cf. Matthieu, à documenter ou supprimer. -->
         <sonar:name rel="xslqual-DontUseDoubleSlashOperatorNearRoot">Double-Slash operator should be avoided near root</sonar:name>
         <sonar:tags xmlns:html="http://www.w3.org/1999/xhtml"
                     rel="xslqual-DontUseDoubleSlashOperatorNearRoot">
            <sonar:tag>xslqual</sonar:tag>
         </sonar:tags>
         <report id="xslqual-DontUseDoubleSlashOperatorNearRoot"
                 test="local-name(.)= ('match', 'select') and (not(matches(., '^''.*''$')))         and starts-with(., '//')"
                 role="warning">
        Avoid using the operator // near the root of a large tree
      </report>
         <sonar:name rel="xslqual-DontUseDoubleSlashOperator">Double-Slash operator should be avoided</sonar:name>
         <sonar:tags xmlns:html="http://www.w3.org/1999/xhtml"
                     rel="xslqual-DontUseDoubleSlashOperator">
            <sonar:tag>xslqual</sonar:tag>
         </sonar:tags>
         <report id="xslqual-DontUseDoubleSlashOperator"
                 test="local-name(.)= ('match', 'select') and (not(matches(., '^''.*''$')))         and not(starts-with(., '//')) and contains(., '//')"
                 role="info">
        Avoid using the operator // in XPath expressions
      </report>
         <sonar:name rel="xslqual-UsingNameOrLocalNameFunction">The choice of using "name()" or "local-name()" should be made with care</sonar:name>
         <sonar:description rel="xslqual-UsingNameOrLocalNameFunction">TODO desc  !</sonar:description>
         <let name="name-is-used" value="contains(., 'name(')"/>
         <let name="actual-name-statement"
              value="if($name-is-used) then 'name()' else 'local-name()'"/>
         <let name="candidate-name-statement"
              value="if($name-is-used) then 'local-name()' else 'name()'"/>
         <sonar:tags xmlns:html="http://www.w3.org/1999/xhtml"
                     rel="xslqual-UsingNameOrLocalNameFunction">
            <sonar:tag>xslqual</sonar:tag>
         </sonar:tags>
         <report id="xslqual-UsingNameOrLocalNameFunction"
                 test="contains(., 'name(') or contains(., 'local-name(')"
                 role="info">
        Consider using <value-of select="$candidate-name-statement"/> function instead of <value-of select="$actual-name-statement"/> if appropriate.
      </report>
         <sonar:name rel="xslqual-IncorrectUseOfBooleanConstants">Boolean constans "true()" or "false()" should be prefered to litteral strings</sonar:name>
         <sonar:description rel="TODO">TODO desc  !</sonar:description>
         <sonar:tags xmlns:html="http://www.w3.org/1999/xhtml"
                     rel="xslqual-IncorrectUseOfBooleanConstants">
            <sonar:tag>xslqual</sonar:tag>
         </sonar:tags>
         <report id="xslqual-IncorrectUseOfBooleanConstants"
                 role="info"
                 test="local-name(.)= ('match', 'select') and not(parent::xsl:attribute)         and ((contains(., 'true') and not(contains(., 'true()'))) or (contains(., 'false') and not(contains(., 'false()'))))">
        Use "true()" or "false()" instead of string litterals "true" or "false"
      </report>
         <sonar:name rel="xslqual-UsingNamespaceAxis">Usage of the deprecated "namescpace::" axis should be avoided</sonar:name>
         <sonar:description rel="TODO">TODO desc  !</sonar:description>
         <sonar:tags xmlns:html="http://www.w3.org/1999/xhtml" rel="xslqual-UsingNamespaceAxis">
            <sonar:tag>xslqual</sonar:tag>
         </sonar:tags>
         <report id="xslqual-UsingNamespaceAxis"
                 test="/xsl:stylesheet/@version = ('2.0', '3.0') and local-name(.)= ('match', 'select') and contains(., 'namespace::')">
        Do not use the deprecated namespace axis, when working in XSLT <value-of select="/*/@version"/> mode
      </report>
         <!-- TODO cf. Matthieu -->
         <sonar:name rel="xslqual-CanUseAbbreviatedAxisSpecifier">TODO xslqual-CanUseAbbreviatedAxisSpecifier</sonar:name>
         <sonar:description rel="xslqual-CanUseAbbreviatedAxisSpecifier">TODO desc  !</sonar:description>
         <sonar:tags xmlns:html="http://www.w3.org/1999/xhtml"
                     rel="xslqual-CanUseAbbreviatedAxisSpecifier">
            <sonar:tag>xslqual</sonar:tag>
         </sonar:tags>
         <report id="xslqual-CanUseAbbreviatedAxisSpecifier"
                 test="local-name(.) = ('match', 'select') and contains(., 'child::') or contains(., 'attribute::') or contains(., 'parent::node()')"
                 role="info">
        [xslqual] Using the lengthy axis specifiers like child::, attribute:: or parent::node()
      </report>
         <!-- TODO cf. Matthieu -->
         <sonar:name rel="xslqual-UsingDisableOutputEscaping">TODO xslqual-UsingDisableOutputEscaping</sonar:name>
         <sonar:description rel="TODO">TODO desc  !</sonar:description>
         <sonar:tags xmlns:html="http://www.w3.org/1999/xhtml"
                     rel="xslqual-UsingDisableOutputEscaping">
            <sonar:tag>xslqual</sonar:tag>
         </sonar:tags>
         <report id="xslqual-UsingDisableOutputEscaping"
                 test="local-name(.) = 'disable-output-escaping' and . = 'yes'">
        [xslqual] Have set the disable-output-escaping attribute to 'yes'. Please relook at the stylesheet logic.
      </report>
      </rule>
  </pattern>
  
  <!--====================================================-->
  <!--FUNCTIONS-->
  <!--====================================================-->
  
  <!--FIXME : functions are embedded within the schematron here, they could be loaded from an external file 
  but it seems not to work due to XML resolver reasons with Jing ?-->
  
  <xsl:function name="xslq:var-or-param-is-referenced-within-its-scope" as="xs:boolean">
      <xsl:param name="var" as="element()"/>
      <xsl:sequence select="xslq:expand-prefix($var/@name, $var) =        xslq:get-xslt-xpath-var-or-param-call-with-expanded-prefix($var/ancestor::xsl:*[1])"/>
  </xsl:function>
  
  <xsl:function name="xslq:function-is-called-within-its-scope" as="xs:boolean">
      <xsl:param name="function" as="element()"/>
      <xsl:sequence select="xslq:expand-prefix($function/@name, $function) =        xslq:get-xslt-xpath-function-call-with-expanded-prefix($function/ancestor::xsl:*[last()])"/>
  </xsl:function>
  
  <xsl:function name="xslq:get-xslt-xpath-var-or-param-call-with-expanded-prefix"
                 as="xs:string*">
      <xsl:param name="scope" as="element()"/>
      <!--prefix and local-name are NCname cf. https://www.w3.org/TR/REC-xml-names/#ns-qualnames--> 
      <xsl:variable name="NCNAME.reg" select="'[\i-[:]][\c-[:]]*'" as="xs:string"/>
      <xsl:variable name="QName.reg"
                    select="'(' || $NCNAME.reg || ':)?' || $NCNAME.reg"
                    as="xs:string"/>
      <xsl:for-each select="xslq:get-xslt-xpath-evaluated-attributes($scope)">
         <xsl:variable name="context" select="parent::*" as="element()"/>
         <xsl:analyze-string select="." regex="{'\$(' || $QName.reg || ')'}">
            <xsl:matching-substring>
               <xsl:sequence select="xslq:expand-prefix(regex-group(1), $context)"/>
            </xsl:matching-substring>
         </xsl:analyze-string>
      </xsl:for-each>
      <xsl:for-each select="xslq:get-xslt-xpath-value-template-nodes($scope)">
         <xsl:variable name="context" select="parent::*" as="element()"/>
         <xsl:for-each select="xslq:extract-xpath-from-value-template(.)">
            <xsl:analyze-string select="." regex="{'\$(' || $QName.reg || ')'}">
               <xsl:matching-substring>
                  <xsl:sequence select="xslq:expand-prefix(regex-group(1), $context)"/>
               </xsl:matching-substring>
            </xsl:analyze-string>
         </xsl:for-each>
      </xsl:for-each>
  </xsl:function>
  
  <xsl:function name="xslq:get-xslt-xpath-function-call-with-expanded-prefix"
                 as="xs:string*">
      <xsl:param name="scope" as="element()"/>
      <!--prefix and local-name are NCname cf. https://www.w3.org/TR/REC-xml-names/#ns-qualnames-->
      <xsl:variable name="NCNAME.reg" select="'[\i-[:]][\c-[:]]*'" as="xs:string"/>
      <xsl:variable name="QName.reg"
                    select="'(' || $NCNAME.reg || ':)?' || $NCNAME.reg"
                    as="xs:string"/>
      <xsl:for-each select="xslq:get-xslt-xpath-evaluated-attributes($scope)">
         <xsl:variable name="context" select="parent::*" as="element()"/>
         <!--don't catch the closing parenthesis in the function call because it would hide nested functions call-->
         <xsl:analyze-string select="." regex="{'(' || $QName.reg || ')' || '\('}">
            <xsl:matching-substring>
               <xsl:sequence select="xslq:expand-prefix(regex-group(1), $context)"/>
            </xsl:matching-substring>
         </xsl:analyze-string>
      </xsl:for-each>
      <xsl:for-each select="xslq:get-xslt-xpath-value-template-nodes($scope)">
         <xsl:variable name="context" select="parent::*" as="element()"/>
         <xsl:for-each select="xslq:extract-xpath-from-value-template(.)">
            <xsl:analyze-string select="." regex="{'(' || $QName.reg || ')' || '\('}">
               <xsl:matching-substring>
                  <xsl:sequence select="xslq:expand-prefix(regex-group(1), $context)"/>
               </xsl:matching-substring>
            </xsl:analyze-string>
         </xsl:for-each>
      </xsl:for-each>
  </xsl:function>
  
  <!--xsl attributes with xpath inside-->
  <xsl:function name="xslq:get-xslt-xpath-evaluated-attributes" as="attribute()*">
      <xsl:param name="scope" as="element()"/>
      <xsl:sequence select="$scope//       (       xsl:accumulator/@initial-value | xsl:accumulator-rule/@select | xsl:accumulator-rule/@match |       xsl:analyze-string/@select | xsl:apply-templates/@select | xsl:assert/@test | xsl:assert/@select |       xsl:attribute/@select | xsl:break/@select | xsl:catch/@select | xsl:comment/@select |       xsl:copy/@select | xsl:copy-of/@select | xsl:evaluate/@xpath | xsl:evaluate/@context-item |       xsl:evaluate/@namespace-context | xsl:evaluate/@with-params | xsl:for-each/@select |        xsl:for-each-group/@select | xsl:for-each-group/@group-by | xsl:for-each-group/@group-adjacent |        xsl:for-each-group/@group-starting-with | xsl:for-each-group/@group-ending-with |        xsl:if/@test | xsl:iterate/@select | xsl:key/@match | xsl:key/@use | xsl:map-entry/@key |       xsl:merge-key/@select | xsl:merge-source/@for-each-item | xsl:merge-source/@for-each-source |        xsl:merge-source/@select | xsl:message/@select | xsl:namespace/@select |       xsl:number/@value | xsl:number/@select | xsl:number/@count | xsl:number/@from |        xsl:on-completion/@select | xsl:on-empty/@select | xsl:on-non-empty/@select |       xsl:param/@select | xsl:perform-sort/@select | xsl:processing-instruction/@select |        xsl:sequence/@select | xsl:sort/@select | xsl:template/@match | xsl:try/@select |        xsl:value-of/@select | xsl:variable/@select | xsl:when/@test | xsl:with-param/@select       )       "/>
  </xsl:function>
  
  <xsl:function name="xslq:get-xslt-xpath-value-template-nodes" as="node()*">
      <xsl:param name="scope" as="element()"/>
      <xsl:sequence select="       (: === AVT : Attribute Value Template === :)       $scope//@*[matches(., '\{.*?\}')]       (: === TVT : Text Value Template === :)       (: XSLT 3.0 only when expand-text is activated:)       |$scope//text()[matches(., '\{.*?\}')]       [not(ancestor::xsl:*[1] is /*)](:ignore text outside templates or function (e.g. text within 'xd:doc'):)       [normalize-space(.)](:ignore white-space nodes:)       [ancestor-or-self::*[@expand-text[parent::xsl:*] | @xsl:expand-text][1]/@*[local-name() = 'expand-text'] = ('1', 'true', 'yes')]       "/>
  </xsl:function>
  
  <xsl:function name="xslq:extract-xpath-from-value-template" as="xs:string*">
      <xsl:param name="string" as="xs:string"/>
      <xsl:analyze-string select="$string" regex="\{{.*?\}}">
         <xsl:matching-substring>
            <xsl:value-of select="."/>
         </xsl:matching-substring>
      </xsl:analyze-string>
  </xsl:function>
  
  <!--Expand any xxx:yyy $string to the bracedURILiteral form Q{ns}yyy using $context to resolve prefix-->
  <xsl:function name="xslq:expand-prefix" as="xs:string">
      <xsl:param name="QNameString" as="xs:string"/>
      <xsl:param name="context" as="element()"/>
      <!--prefix and local-name are NCname cf. https://www.w3.org/TR/REC-xml-names/#ns-qualnames-->
      <!--NCName = an XML Name, minus the ":"-->
      <!--cf. https://stackoverflow.com/questions/1631396/what-is-an-xsncname-type-and-when-should-it-be-used-->
      <xsl:variable name="NCNAME.reg" select="'[\i-[:]][\c-[:]]*'" as="xs:string"/>
      <xsl:variable name="QName.reg"
                    select="'(' || $NCNAME.reg || ':)?' || $NCNAME.reg"
                    as="xs:string"/>
      <xsl:assert test="matches($QNameString, '^' || $QName.reg)"/>
      <!--<xsl:variable name="prefix" select="xs:string(prefix-from-QName(xs:QName(@name)))" as="xs:string"/>-->
      <xsl:variable name="prefix"
                    select="substring-before($QNameString, ':')"
                    as="xs:string"/>
      <!--<xsl:variable name="local-name" select="local-name-from-QName(xs:QName(@name))" as="xs:string"/>-->
      <xsl:variable name="local-name"
                    select="if (contains($QNameString, ':')) then (substring-after($QNameString, ':')) else ($QNameString)"
                    as="xs:string"/>
      <xsl:variable name="ns"
                    select="if ($prefix != '') then (namespace-uri-for-prefix($prefix, $context)) else ('')"
                    as="xs:string"/>
      <xsl:value-of select="'Q{' || $ns, '}' || $local-name" separator=""/>
  </xsl:function>
  
</schema>
