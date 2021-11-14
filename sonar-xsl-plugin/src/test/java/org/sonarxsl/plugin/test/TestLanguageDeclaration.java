package org.sonarxsl.plugin.test;

import org.junit.Test;
import org.sonalxsl.plugin.SonarXSLTPlugin;
import org.sonarxsl.helpers.SaxonHolder;

public class TestLanguageDeclaration {
	
	
	@Test
	public void DeclareToFakeContext() {
		System.setProperty(SaxonHolder.VERBOSE, "true");
		
		SonarXSLTPlugin testPlugin = new SonarXSLTPlugin();
		FakeSonarPluginContext pluginContext = new FakeSonarPluginContext();
		testPlugin.define(pluginContext);
		
		// the lines above launch almost all the code.
		// so far, this test case consists to have no exception here.

	}

}
