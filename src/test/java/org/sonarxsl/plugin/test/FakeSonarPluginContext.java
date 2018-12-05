package org.sonarxsl.plugin.test;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.sonar.api.Plugin.Context;
import org.sonar.api.SonarRuntime;
import org.sonar.api.utils.Version;

public class FakeSonarPluginContext extends Context {
	
	private List<Object> extensionsAdded = new ArrayList<>();

	public FakeSonarPluginContext() {
		super(new FakeSonarRuntime());
	}

	@Override
	public Version getSonarQubeVersion() {
		return null;
	}

	@Override
	public SonarRuntime getRuntime() {
		return super.getRuntime();
	}

	@Override
	public Context addExtension(Object extension) {
		this.extensionsAdded.add(extension);
		return this;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public Context addExtensions(Collection extensions) {
		this.extensionsAdded.addAll(extensions);
		return this;
	}

	@Override
	public Context addExtensions(Object first, Object second, Object... others) {
		this.extensionsAdded.add(first);
		this.extensionsAdded.add(second);
		for (Object object : others) {
			this.extensionsAdded.add(object);
		}
		return this;
	}

	@SuppressWarnings("rawtypes")
	@Override
	public List getExtensions() {
		return this.extensionsAdded;
	}

	
}
