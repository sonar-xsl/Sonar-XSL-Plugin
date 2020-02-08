package org.sonarxsl.schematron;

import static java.util.Arrays.asList;

import java.util.List;

import org.sonar.api.config.PropertyDefinition;
import org.sonar.api.resources.AbstractLanguage;
import org.sonar.api.resources.Qualifiers;

public class SchematronBasedLanguage extends AbstractLanguage{
	
	private List<String> fileSuffixes;

	public SchematronBasedLanguage(String key, String name, List<String> fileSuffixes) {
		super(key, name);
		this.fileSuffixes = fileSuffixes;
	}
	
	

	@Override
	public String[] getFileSuffixes() {
		return this.fileSuffixes.toArray(new String[this.fileSuffixes.size()]);
	}
	
	public  List<PropertyDefinition> getProperties() {
	    return asList(PropertyDefinition.builder(fileSuffixesKey())
	      .defaultValue(commaSeparatedSuffixes())
	      .category(this.getKey())
	      .name("File Suffixes")
	      .description("Comma-separated list of suffixes for files to analyze.")
	      .onQualifiers(Qualifiers.PROJECT)
	      .build());
	  }
	
	private String fileSuffixesKey(){
		return "sonar."+this.getKey()+".file.suffixes";
	}
	
	private String commaSeparatedSuffixes(){
		StringBuilder sb = new StringBuilder();
		for (String suffix : fileSuffixes) {
			sb.append(suffix).append(',');
		}
		sb.setLength(sb.length() - 1);
		return sb.toString();
	}

}
