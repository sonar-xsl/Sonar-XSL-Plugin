# Sonar-XSL-Plugin

*A Schematron-based SonarQube plugin for XSL code quality measurement.*

## Goals

Extends the benefits of SonarQube to XSL projects :
* Continuous Quality measurement
* Interactive documentation of best-practices

## What this plugin does

This plugin runs an XSL-related Best-practice Schematron on each xslt file of your project.

It embeds the [xslt-quality](https://github.com/mricaud/xslt-quality) schematron from @mricaud.  
That Schematron Script, based on [Mukul Gandhi's work](http://gandhimukul.tripod.com/xslt/xslquality.html), checks some common XSL pitfalls.

Examples :

* Variables should be typed
* The use of wildcard namespaces `*:` in xpath statements should be avoided
* Using `xsl:for-each` on nodes may be a clue of procedural programming ;
You should maybe consider using `xsl:apply-templates` instead
* boolean `true() or `false()` value should be used instead of litteral strings `'true'` and `'false'`
* Costly double-slash operator should be used with caution
* Global variables, global parameters and mode names should have a namespace to improve the portability of your stylesheet
* etc.

Since this plugin is open source, one can embed any additional Schematron script to support custom rules.

## Architecture / Extending

The Sonar-XSL-Plugin is built *via* Maven.

Running `mvn package` will invoke  the [sonar-packaging-maven-plugin](https://github.com/SonarSource/sonar-packaging-maven-plugin) to build a SonarQube-Ready JAR file.

The process of installing a SonarQube plugin is documented here :  
<https://docs.sonarqube.org/latest/setup/install-plugin/>, see § *Manual Installation*

It embeds two main modules

#### Sonar-Schematron-Reactor

Makes the link between Schematron and the SonarQube API.

Cf. <https://github.com/sonar-xsl/Sonar-Schematron-Reactor>

#### Some Schematrons modules

Out of the box, the unique [xslt-quality](https://github.com/mricaud/xslt-quality)

Packaged for this plugin, via the dedicated [Maven Plugin](https://github.com/sonar-xsl/sonar-schematron-packaging-plugin).

This mechanism can be used to extend this plugin :

1. Write some XSL-Related Schematron rules
2. Package them with the plugin
3. Add the resulting artifact as a dependency

## So, does it actually works ?

Well, there is some TODOs to fix :

* Realese and pushish the plugin to Maven Central !  
  As for now, if you wana try it, you have to build it locally from the sources (And it's specific dependencies as well)
* The execution is quite slow...
  * NB : The actual implementation is based on the [Skeleton XSLT implementation](https://github.com/Schematron/schematron) of ISO-Schematron.
* Integration with SonarQube
  * The native Code Duplication Detection does not work.
  * Highlighting from [SonarSource/sonar-xml](https://github.com/SonarSource/sonar-xml) integrated in a quick-lazy way...
* Improve the integration of [xslt-quality](https://github.com/mricaud/xslt-quality) ruleSet.
  * I need to package it and add some SonarQube-specific annotation.
  * For that purpose, [I temporarily forked it](https://github.com/jimetevenard/xslt-quality)
  * I'm working on a cleaner integration : Importing it as a Maven dependency, and then adding the annotations via XSLT.
  * The schematron may have itself some dependencies that needs to be resolved, so there is a little bit of work
* Integration with the XSPEC Maven plugin
  * To bring code coverage into SonarQube
  
## Repositories :

* [sonar-xsl](https://github.com/sonar-xsl/) (This organization)
* [sonar-xsl/Sonar-Schematron-Reactor](https://github.com/sonar-xsl/Sonar-Schematron-Reactor)
* [sonar-xsl/sonar-xsl-packaging-api](https://github.com/sonar-xsl/sonar-xsl-packaging-api)
* [sonar-xsl/sonar-schematron-packaging-plugin](https://github.com/sonar-xsl/sonar-schematron-packaging-plugin)
* [mricaud/xslt-quality: XML utilities](https://github.com/mricaud/xslt-quality)
* [jimetevenard/xslt-quality: XML utilities](https://github.com/jimetevenard/xslt-quality) - (temp fork)

