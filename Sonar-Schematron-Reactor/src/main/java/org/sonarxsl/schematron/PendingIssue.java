package org.sonarxsl.schematron;

import org.sonar.api.rule.RuleKey;
import org.sonarxsl.exception.SchematronProcessingException;

import net.sf.saxon.s9api.XdmAtomicValue;
import net.sf.saxon.s9api.XdmValue;

public class PendingIssue {
	
	private String ruleKey;
	private String xpathLocation;
	private String message;
	
	
	
	
	
	
	public static PendingIssue of(XdmValue idValue, XdmValue locationValue, XdmValue messageValue) throws SchematronProcessingException{
		PendingIssue pendingIssue = new PendingIssue();
		try {
			pendingIssue.ruleKey = ((XdmAtomicValue)idValue).getStringValue();
			pendingIssue.xpathLocation = ((XdmAtomicValue)locationValue).getStringValue();
			pendingIssue.message = ((XdmAtomicValue)messageValue).getStringValue();
			return pendingIssue;
		} catch (ClassCastException e) {
			throw new SchematronProcessingException(e);
		}
	}
	
	public RuleKey rule(String repositoryKey){
		return RuleKey.of(repositoryKey, getRuleKey());
	}
	public String getRuleKey() {
		return ruleKey;
	}
	public void setRuleKey(String ruleKey) {
		this.ruleKey = ruleKey;
	}
	public String getXpathLocation() {
		return xpathLocation;
	}
	public void setXpathLocation(String xpathLocation) {
		this.xpathLocation = xpathLocation;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
	
	

}
