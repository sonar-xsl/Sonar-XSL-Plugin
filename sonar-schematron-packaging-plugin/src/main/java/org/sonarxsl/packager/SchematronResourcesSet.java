package org.sonarxsl.packager;

import java.io.File;

import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugins.annotations.Parameter;

public class SchematronResourcesSet {
	
	@Parameter
	private String dir;
	
	@Parameter
	private String[] includes;
	
	@Parameter
	private String[] excludes;
	
	@Parameter
	private String[] entryPoints;

	public String getDir() {
		return dir;
	}
	
	public File resolveDir(File projectBaseDir) throws MojoExecutionException {
		if(this.dir == null) throw new MojoExecutionException("a SchematronResourcesSet requires a non-empty 'dir' element");
		File resolvedDir = new File(projectBaseDir, this.dir);
		if(!(resolvedDir.exists() && resolvedDir.isDirectory()))
				throw new MojoExecutionException(this.dir + "does not references an existing directory.");
		
		return resolvedDir;
	}

	public void setDir(String dir) {
		this.dir = dir;
	}

	public String[] getIncludes() {
		return includes;
	}

	public void setIncludes(String[] includes) {
		this.includes = includes;
	}

	public String[] getExcludes() {
		return excludes;
	}

	public void setExcludes(String[] excludes) {
		this.excludes = excludes;
	}
	
	public String[] getEntryPoints() {
		return entryPoints;
	}

	public void setEntryPoints(String[] entryPoints) {
		this.entryPoints = entryPoints;
	}
	
	

}
