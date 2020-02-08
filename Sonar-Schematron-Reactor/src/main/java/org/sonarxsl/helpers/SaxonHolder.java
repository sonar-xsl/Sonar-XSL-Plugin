package org.sonarxsl.helpers;

import java.io.File;
import java.io.PrintStream;

import javax.xml.transform.Source;
import javax.xml.transform.SourceLocator;

import org.xmlresolver.Resolver;

import net.sf.saxon.s9api.DocumentBuilder;
import net.sf.saxon.s9api.MessageListener;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XPathCompiler;
import net.sf.saxon.s9api.XPathSelector;
import net.sf.saxon.s9api.XdmDestination;
import net.sf.saxon.s9api.XdmNode;
import net.sf.saxon.s9api.XsltCompiler;
import net.sf.saxon.s9api.XsltTransformer;

public class SaxonHolder {
	
	public static final String VERBOSE = SaxonHolder.class.getName() + ".verbose";
	
	private static SaxonHolder instance;

	private Processor proc;
	private XsltCompiler compiler;
	private XPathCompiler xpathCompiler;
	private DocumentBuilder docBuilder;
	
	private QuietMessageListener quietListener = new QuietMessageListener();
	


	public static SaxonHolder getInstance(){
		if(instance == null) instance = new SaxonHolder();
		return instance;
	}
	
	private SaxonHolder(){
		Resolver resolver = new Resolver();
		proc = new Processor(false);
		docBuilder = proc.newDocumentBuilder();
		docBuilder.setLineNumbering(true);
		compiler = proc.newXsltCompiler();
		compiler.setURIResolver(resolver);
		xpathCompiler = proc.newXPathCompiler();
	}
	
	public Processor getProcessor() {
		return proc;
	}
	
	// =========================================
	
	


	public XdmNode buildDocument(File file) throws SaxonApiException{
		return docBuilder.build(file);
	}
	
	public XdmNode buildDocument(Source source) throws SaxonApiException{
		return docBuilder.build(source);
	}
	
	// ==============================================
	
	public XdmNode runXslt(Source source, XsltTransformer xsl) throws SaxonApiException{
		xsl.setMessageListener(quietListener);
		xsl.setSource(source);
		XdmDestination destination = new XdmDestination();
		xsl.setDestination(destination);
		xsl.transform();
				
		return destination.getXdmNode();
	}
	
	public XdmNode runXslt(Source source, Source xslt) throws SaxonApiException{	
		return runXslt(source, compile(xslt));
	}
	
	public XdmNode runXslt(XdmNode source, Source xslt) throws SaxonApiException{	
		return runXslt(source.asSource(), compile(xslt));
	}
	
	public XdmNode runXslt(XdmNode source, XsltTransformer xslt) throws SaxonApiException{	
		return runXslt(source.asSource(), xslt);
	}
	
	public XsltTransformer compile(Source xslt) throws SaxonApiException{
		return compiler.compile(xslt).load();
	}
	
	// ==================================================
	
	public XPathSelector compileXpath(String xpath) throws SaxonApiException{
		return xpathCompiler.compile(xpath).load();
	}
	
	public static class QuietMessageListener implements MessageListener {
		
		@Override
		public void message(XdmNode content, boolean terminate, SourceLocator locator) {
			if(terminate) {
				throw new RuntimeException("XSLT transformation terminated : " + content + locator);
			}
			if(System.getProperty(VERBOSE) != null) {
				String loc = locator.getSystemId() + ", line " + locator.getLineNumber();
				System.out.println(content + " at " + loc);
			}
		}
		
		
		
	}
	
	
	
	
	

}
