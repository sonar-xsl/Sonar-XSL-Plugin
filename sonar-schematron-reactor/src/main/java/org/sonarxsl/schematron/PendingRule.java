package org.sonarxsl.schematron;

import java.util.ArrayList;
import java.util.List;

import org.sonar.api.batch.rule.Severity;
import org.sonar.api.rules.RuleType;

public class PendingRule {
	
	private static final int DEFAULT_TAGLIST_CAP = 2;
	public static final Severity DEFAULT_SEVERITY = Severity.MAJOR;
	public static final RuleType DEFAULT_TYPE = RuleType.CODE_SMELL;
	
	private String id;
	private String name;
	private String description;
	private Severity severity = DEFAULT_SEVERITY;
	private RuleType type = DEFAULT_TYPE;
	private List<String> tags = new ArrayList<>(DEFAULT_TAGLIST_CAP);
	

	
	public String getKey() {
		return id;
	}
	public void setKey(String id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public Severity getSeverity() {
		return severity;
	}
	public void setSeverity(Severity severity) {
		this.severity = severity;
	}
	public RuleType getType() {
		return type;
	}
	public void setType(RuleType type) {
		this.type = type;
	}
	public List<String> getTags() {
		return tags;
	}
	public void addTag(String tag) {
		if(!tag.isEmpty()) this.tags.add(tag.toLowerCase());
	}
	public void addTags(String... tags) {
		for (String tag : tags) {
			this.addTag(tag);
		}
	}
	@Override
	public String toString() {
		return "SchematronAssertReport [id=" + id + ", name=" + name + "]";
	}
	
	
	
	
	
	

}
