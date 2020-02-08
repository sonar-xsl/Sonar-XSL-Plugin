package org.sonarxsl.schematron;

import java.util.List;

import org.sonar.api.server.rule.RulesDefinition;

public class SchematronBasedRulesDefinition implements RulesDefinition{
	
	private List<PendingRule> pendingRules;
	private String repoKey;
	private String LanguageKey;
	

	public SchematronBasedRulesDefinition(List<PendingRule> pendingRules, String repoKey, String languageKey) {
		super();
		this.pendingRules = pendingRules;
		this.repoKey = repoKey;
		LanguageKey = languageKey;
	}

	@Override
	public void define(Context context) {
		NewRepository repo = context.createRepository(repoKey, LanguageKey);
		for (PendingRule pendingRule : pendingRules) {
			NewRule newRule = repo.createRule(pendingRule.getKey()).setName(pendingRule.getName())
			.setHtmlDescription(pendingRule.getDescription())
			.setType(pendingRule.getType())
			.setSeverity(pendingRule.getSeverity().toString());
			
			List<String> tags = pendingRule.getTags();
			if(!tags.isEmpty()) {
				newRule.setTags(tags.toArray(new String[tags.size()]));
			}
			
		}
		repo.done();
		
	}

}
