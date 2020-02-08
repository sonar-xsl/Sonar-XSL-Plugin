package org.sonarxsl;

public class SonarPackagingConstants {
	
	public static final String PACKAGE_PATH = "com/jimetevenard/sonar-xsl/";

	public static final String ENTRYPOINTS_FILENAME = "ENTRYPOINTS";
	
	public static final EntryPointFileType ENTRYPOINTS_FILETYPE = EntryPointFileType.PLAIN_TEXT_ONE_PER_LINE;

	public static enum EntryPointFileType {
		PLAIN_TEXT_ONE_PER_LINE,
		XML,
		JSON;
	}
}
