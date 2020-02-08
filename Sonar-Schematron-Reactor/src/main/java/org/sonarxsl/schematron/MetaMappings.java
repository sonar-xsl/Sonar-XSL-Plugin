package org.sonarxsl.schematron;

import java.util.Optional;

import org.sonar.api.batch.rule.Severity;
import org.sonar.api.rules.RuleType;

public class MetaMappings {
	
	public static Optional<Severity> mapSeverity(String role) {
		switch (role) {
		case "info":
			return Optional.of(Severity.INFO);
		case "warn":
		case "warning":
			return Optional.of(Severity.MINOR);
		case "":
			return Optional.of(Severity.MAJOR);
		case "critical":
			return Optional.of(Severity.CRITICAL);
		case "blocker":
			return Optional.of(Severity.BLOCKER);
		default:
			return Optional.empty();
		}
	}
	
	public static Optional<RuleType> mapType(String type){
		switch (type) {
		case "code smell":
		case "code-smell":
		case "code_smell":
			return Optional.of(RuleType.CODE_SMELL);
		case "bug":
			return Optional.of(RuleType.BUG);
		case "vulnerability":
			return Optional.of(RuleType.VULNERABILITY);
		default:
			return Optional.empty();
		}
	}

}
