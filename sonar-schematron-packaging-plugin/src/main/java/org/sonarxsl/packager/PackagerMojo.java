package org.sonarxsl.packager;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;

import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.plugins.annotations.LifecyclePhase;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;
import org.codehaus.plexus.util.DirectoryScanner;
import org.sonarxsl.SonarPackagingConstants;
import org.sonarxsl.SonarPackagingConstants.EntryPointFileType;

 
@Mojo(name = "package-schematron-for-sonar", defaultPhase = LifecyclePhase.COMPILE)
public class PackagerMojo extends AbstractMojo {

	private static final Charset UTF_8 = Charset.forName("UTF-8");

	private static final String DESTINATION_PATH = SonarPackagingConstants.PACKAGE_PATH;

	private static final String ENTRYPOINTS_FILENAME = SonarPackagingConstants.ENTRYPOINTS_FILENAME;

	@Parameter(defaultValue = "${project.basedir}", required = true, readonly = true)
	private File basedir;
	
	@Parameter(defaultValue = "${project.build.outputDirectory}", required = true, readonly = true)
	private File outputDir; // i.e. target/classes/

	@Parameter
	private String encoding;

	@Parameter
	private String[] catalogs;

	@Parameter
	private SchematronResourcesSet[] schematronResourcesSets;
	
	private final List<String> entryPoints = new ArrayList<>();

	private File destinationDir;

	@Override
	public void execute() throws MojoExecutionException, MojoFailureException {
		
		getLog().info("Heeeelllooooooooooooooo !");
		// Include files into the jar
		// ==========================
		destinationDir = new File(outputDir, DESTINATION_PATH);
		destinationDir.mkdirs();
		
		for (SchematronResourcesSet resourceSet : schematronResourcesSets) {
			File resourceSetDir = resourceSet.resolveDir(this.basedir);
			String[] files = getIncludedFileNames(resourceSetDir, resourceSet.getIncludes(), resourceSet.getExcludes());
			for (String file : files) {
				copyFile(resourceSetDir,file);
			}
			for (String entryPoint : resourceSet.getEntryPoints()) {
				this.entryPoints.add(entryPoint);
			}
		}
		
		// Generating the ENTRYPOINTS manifest
		// ===================================
		makeEntryPointsFile();

	}

	private void makeEntryPointsFile() throws MojoExecutionException {
		if(!SonarPackagingConstants.ENTRYPOINTS_FILETYPE.equals(EntryPointFileType.PLAIN_TEXT_ONE_PER_LINE)) {
			throw new UnsupportedOperationException("EntryPoints declaration format not supported");
		}
		
		File entryPointsFile = new File(destinationDir, ENTRYPOINTS_FILENAME);
		try {
			entryPointsFile.createNewFile();
			BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(entryPointsFile)));
			
			int size = this.entryPoints.size();
			for(int i = 0; i < size; i++) {
				writer.write(this.entryPoints.get(i));
				if(i < size-1) writer.newLine();
			}
				
			writer.flush();
			writer.close();
		} catch (IOException e) {
			throw new MojoExecutionException("Error creating the ENTRYPOINT file", e);
		}
		
	}

	private void copyFile(File resourceSetDir, String file) throws MojoExecutionException {
		File source = new File(resourceSetDir,file);
		try {
			File dest = new File(destinationDir, file);
			dest.getParentFile().mkdirs();
			Files.copy(source.toPath(), dest.toPath());
		} catch (IOException e) {
			throw new MojoExecutionException("error copying file " + file, e);
		}
		
	}

	protected String[] getIncludedFileNames(File dir, String[] pIncludes, String[] pExcludes)
			throws MojoFailureException, MojoExecutionException {
		
		final DirectoryScanner ds = new DirectoryScanner();
		ds.setBasedir(dir);
		if (pIncludes != null && pIncludes.length > 0) {
			ds.setIncludes(pIncludes);
		}
		if (pExcludes != null && pExcludes.length > 0) {
			ds.setExcludes(pExcludes);
		}
		ds.scan();
		return ds.getIncludedFiles();
	}

	public File getBasedir() {
		return basedir;
	}

	public void setBasedir(File basedir) {
		this.basedir = basedir;
	}

	public String getEncoding() {
		return encoding;
	}

	public void setEncoding(String encoding) {
		this.encoding = encoding;
	}

	public String[] getCatalogs() {
		return catalogs;
	}

	public void setCatalogs(String[] catalogs) {
		this.catalogs = catalogs;
	}

	public SchematronResourcesSet[] getSchematronResourcesSets() {
		return schematronResourcesSets;
	}

	public void setSchematronResourcesSets(SchematronResourcesSet[] schematronResourcesSets) {
		this.schematronResourcesSets = schematronResourcesSets;
	}

	

	public static Charset getUtf8() {
		return UTF_8;
	}

}
