package org.sonarxsl.schematron;

public enum SchematronStep {
	STEP1("iso_dsdl_include.xsl"),
	STEP2("iso_abstract_expand.xsl"),
	STEP3("iso_svrl_for_xslt2.xsl");
	
	private String stepFile;
	
	SchematronStep(String step){
		this.stepFile = step;
	}

	public String getStepFile() {
		return stepFile;
	}
	

}