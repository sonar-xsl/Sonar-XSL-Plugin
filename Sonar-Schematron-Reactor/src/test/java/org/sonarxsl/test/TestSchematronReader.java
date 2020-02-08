package org.sonarxsl.test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import org.junit.Test;
import org.sonar.api.rules.RuleType;
import org.sonarxsl.helpers.ResourceHelper;
import org.sonarxsl.helpers.SaxonHolder;
import org.sonarxsl.schematron.PendingRule;
import org.sonarxsl.schematron.SchematronReader;

public class TestSchematronReader {
	
	public static final String PETIT_SCHEMATRON = "petit-schematron.sch";
	public static final String SCHEMATRON_XSL_QUALITY = "xsl-quality/checkXSLTstyle.sch";
	
	@Test
	public void monPetitSchematron() {
		try {
			
			System.setProperty(SaxonHolder.VERBOSE, "true");
			
			SchematronReader reader = new SchematronReader(ResourceHelper.resource(getClass(), PETIT_SCHEMATRON));
			reader.load();
			
			assertTrue(reader.getPendingRules().size() == 3);
			
			PendingRule firstRule = reader.getPendingRules().get(0);
			assertEquals("sonar:name test","Variables Should be Typed",firstRule.getName());
			assertEquals("Sonar tags test","typing",firstRule.getTags().get(0));
			assertEquals("Sonar tags test","code-style",firstRule.getTags().get(1));
			assertEquals("Sonar type test",RuleType.BUG,firstRule.getType());

			
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
	
	
	

	
	

}
