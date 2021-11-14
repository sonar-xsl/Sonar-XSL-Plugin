package org.sonalxsl.plugin;

import org.sonar.api.Plugin;
import org.sonar.api.utils.log.Loggers;
import org.sonarxsl.exception.SchematronProcessingException;
import org.sonarxsl.schematron.SchematronLanguageDeclaration;

public class SonarXSLTPlugin implements Plugin {

	@Override
	public void define(Context context) {

		try {
			SchematronLanguageDeclaration declaration = xslLanguageDeclaration();
			declaration.declare(context);

		} catch (SchematronProcessingException e) {
			Loggers.get(SonarXSLTPlugin.class).error("Sonar XSL Failed to init", e);
		}

	}

	public SchematronLanguageDeclaration xslLanguageDeclaration() throws SchematronProcessingException {
		return new SchematronLanguageDeclaration()
				
				.name("XSLT")
				.key("xslt")
				.addFileSuffix(".xsl")
		
				.addSchematronsFromDependencies();
				

	}

}
