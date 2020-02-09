package org.sonarxsl.schematron;

import java.util.List;

import org.sonar.api.server.profile.BuiltInQualityProfilesDefinition;

public class SchematronBasedQualityProfile implements BuiltInQualityProfilesDefinition{
	
	private String languageKey;
	private String qualityProfileName;
	private String repositoryKey;
	private List<PendingRule> PendingRules;
	

	public SchematronBasedQualityProfile(String languageKey, String qualityProfileName, String repositoryKey,
			List<PendingRule> pendingRules) {
		super();
		this.languageKey = languageKey;
		this.qualityProfileName = qualityProfileName;
		this.repositoryKey = repositoryKey;
		PendingRules = pendingRules;
	}


	@Override
	public void define(Context context) {
		NewBuiltInQualityProfile profile = context.createBuiltInQualityProfile(qualityProfileName, languageKey);
		
		for (PendingRule pendingRule : PendingRules) {
			profile.activateRule(repositoryKey, pendingRule.getKey());
		}
		
		profile.done();
		
	}

}
