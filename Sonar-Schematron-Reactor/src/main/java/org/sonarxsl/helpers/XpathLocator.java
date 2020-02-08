package org.sonarxsl.helpers;

import javax.xml.transform.Source;

import org.sonarxsl.exception.SchematronProcessingException;

import net.sf.saxon.s9api.DocumentBuilder;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XPathCompiler;
import net.sf.saxon.s9api.XdmItem;
import net.sf.saxon.s9api.XdmNode;

public class XpathLocator {
	
	private DocumentBuilder docBuilder;
	private XPathCompiler xpathCompilo;
	private XdmNode builtDocument;


	public XpathLocator(Source xmlDocument) throws SchematronProcessingException {
		Processor proc = SaxonHolder.getInstance().getProcessor();
		this.xpathCompilo = proc.newXPathCompiler();
		this.docBuilder = proc.newDocumentBuilder();
		this.docBuilder.setLineNumbering(true);
		try {
			builtDocument = this.docBuilder.build(xmlDocument);
		} catch (SaxonApiException e) {
			throw new SchematronProcessingException(e);
		}
	}
	
	public XpathLocator(XdmNode xmlDocument) {
		Processor proc = SaxonHolder.getInstance().getProcessor();
		this.xpathCompilo = proc.newXPathCompiler();
		this.builtDocument = xmlDocument;	
	}
	
	
	public int locateSingle(String xpath) throws SchematronProcessingException{
		try {
			XdmItem occurence = this.xpathCompilo.evaluateSingle(xpath, builtDocument);
			return ((XdmNode) occurence).getLineNumber();
		} catch (SaxonApiException | ClassCastException e) {
			throw new SchematronProcessingException(e);
		}
	}
	
	
}
