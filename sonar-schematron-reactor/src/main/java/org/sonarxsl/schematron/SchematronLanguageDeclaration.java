package org.sonarxsl.schematron;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;

import org.sonar.api.Plugin.Context;
import org.sonar.api.server.profile.BuiltInQualityProfilesDefinition;
import org.sonar.api.server.rule.RulesDefinition;
import org.sonarxsl.SonarPackagingConstants;
import org.sonarxsl.exception.SchematronProcessingException;
import org.sonarxsl.helpers.ResourceHelper;

public class SchematronLanguageDeclaration {
	
	private static final String SCH_PATH = SonarPackagingConstants.PACKAGE_PATH;

	private static final String ENTRYPOINTS_FILENAME = SonarPackagingConstants.ENTRYPOINTS_FILENAME;
	
	private String name;
	private String key;
	private List<String> fileSuffixes = new ArrayList<>();;
	private String qualityProfileName;
	private String ruleRepositoryKey;
	
	private List<SchematronReader> schematrons = new ArrayList<>();
	private List<PendingRule> pendingRules = new ArrayList<>(50);
		
	

	
	public SchematronLanguageDeclaration addSchematronsFromDependencies() throws SchematronProcessingException {
		try {
			List<String> dependenciesEntryPoints = scanDeclaredEntryPointsInDependencies();

			for (String entryPoint : dependenciesEntryPoints) {
				this.addSchematronResource(SCH_PATH + entryPoint);
			}
			
			// TODO : Quid des conflits de noms entre dépences ?
			// cf. Christophe marchand - @cmarchand qui en connait un rayon sur ces problematiques
			
		} catch (IOException e) {
			throw new SchematronProcessingException(e);
		}
		
		return this;
	}


	private List<String> scanDeclaredEntryPointsInDependencies() throws IOException {
		List<String> dependenciesEntryPoints = new ArrayList<>();
		
		Enumeration<URL> entryPointsDeclarations = this.getClass().getClassLoader().getResources(SCH_PATH + ENTRYPOINTS_FILENAME);
		while (entryPointsDeclarations.hasMoreElements()) {
			 InputStream entryPointDeclaration = ((URL) entryPointsDeclarations.nextElement()).openStream();
			 BufferedReader reader = new BufferedReader(new InputStreamReader(entryPointDeclaration));
			 String line;
			 while((line = reader.readLine()) != null) {
				 dependenciesEntryPoints.add(line);
			 }
			 reader.close();
		}
		
		return dependenciesEntryPoints;
	}


	public void declare(Context pluginContext) throws SchematronProcessingException{
		checkState();
		SchematronBasedLanguage language = new SchematronBasedLanguage(key, name, fileSuffixes);
		
		for (SchematronReader reader : this.schematrons) {
			reader.load();
			this.pendingRules.addAll(reader.getPendingRules());
			pluginContext.addExtension(new SchematronSensor(reader, key, ruleRepositoryKey));
		}
		
		RulesDefinition rulesDefinition = new SchematronBasedRulesDefinition(pendingRules, ruleRepositoryKey, key);
		BuiltInQualityProfilesDefinition qualityProfileDefinition = new SchematronBasedQualityProfile(key, qualityProfileName, ruleRepositoryKey, pendingRules);
		
		pluginContext.addExtension(language);
		pluginContext.addExtension(language.getProperties());
		pluginContext.addExtension(rulesDefinition);
		pluginContext.addExtension(qualityProfileDefinition);
	}
	
	

	public SchematronLanguageDeclaration name(String name){
		this.name = name;
		return this;
	}
	
	public SchematronLanguageDeclaration key(String key){
		this.key = key;
		return this;
	}
	
	public SchematronLanguageDeclaration addFileSuffix(String suffix){
		this.fileSuffixes.add(suffix);
		return this;
	}
	
	public SchematronLanguageDeclaration addSchematronResource(String resourceName){
		this.addSchematron(ResourceHelper.resource(this.getClass(), resourceName));
		return this;
	}
	public SchematronLanguageDeclaration addSchematron(Source schematron){
		this.schematrons.add(new SchematronReader(schematron));
		return this;
	}
	public SchematronLanguageDeclaration addSchematron(File schematron){
		this.addSchematron(new StreamSource(schematron));
		return this;
	}
	
	public SchematronLanguageDeclaration qualityProfileName(String qualityProfileName){
		this.qualityProfileName = qualityProfileName;
		return this;
	}
	
	public SchematronLanguageDeclaration ruleRepositoryName(String ruleRepositoryName){
		this.ruleRepositoryKey = ruleRepositoryName;
		return this;
	}
	
	private void checkState() {
		if(this.key == null || this.fileSuffixes.isEmpty() || this.schematrons.isEmpty()){
			throw new IllegalStateException("Language key, at least one fileSuffix and at least on Schematron are mandatory.");
		}
		
		if(this.name == null) this.name = this.key;
		if(this.qualityProfileName == null) this.qualityProfileName = this.key;
		if(this.ruleRepositoryKey == null) this.ruleRepositoryKey = this.key;		
	}

	
	// ==================
	
	public List<PendingRule> getPendingRules() {
		return pendingRules;
	}
	
	
	
}
