package org.sonarxsl.plugin.test;

import org.sonar.api.Plugin;
import org.sonar.api.utils.log.Loggers;
import org.sonarxsl.exception.SchematronProcessingException;
import org.sonarxsl.schematron.SchematronLanguageDeclaration;

public class SonarPluginTestCase implements Plugin {

	@Override
	public void define(Context context) {

		try {
			SchematronLanguageDeclaration declaration = xslLanguageDeclaration();

			declaration.declare(context);

		} catch (SchematronProcessingException e) {
			throw new RuntimeException("Test Declaration failed !", e);
		}

	}

	public SchematronLanguageDeclaration xslLanguageDeclaration() throws SchematronProcessingException {
		return new SchematronLanguageDeclaration()
				
				.addSchematronsFromDependencies()			
				.name("Foo Language")
				.key("foo")
				.addFileSuffix(".foo");

	}

}
