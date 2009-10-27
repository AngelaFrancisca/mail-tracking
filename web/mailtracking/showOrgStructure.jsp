<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/fenix-renderers.tld" prefix="fr" %>
<%@ taglib uri="/WEB-INF/organization.tld" prefix="vo" %>

<h2><bean:message key="label.organization" bundle="ORGANIZATION_RESOURCES" /></h2>

<br/>
<logic:empty name="myorg" property="topUnits">
	<em><bean:message key="label.no.top.units" bundle="ORGANIZATION_RESOURCES" /></em>
</logic:empty>

<%-- 
<vo:viewOrganization organization="myorg" configuration="config">
	<vo:property name="rootClasses" value="tree" />
	<vo:property name="viewPartyUrl" value="/manageMailTracking.do?method=manageMailTracking&amp;partyOid=%s" />
</vo:viewOrganization>
--%>

<logic:empty name="mailTrackings" >
	<p><em><bean:message key="message.not.operator.in.any.mail.tracking" bundle="MAIL_TRACKING_RESOURCES" /></em></p>
</logic:empty>

<logic:notEmpty name="mailTrackings">
	<p><strong><bean:message key="message.choose.one.mail.manager" bundle="MAIL_TRACKING_RESOURCES" /></strong></p>
	<fr:view name="mailTrackings" schema="module.mail.tracking.choose" >
		<fr:layout name="tabular" >
			<fr:property name="classes" value="tabular" />
			
			<fr:property name="linkFormat(manage)" value="/manageMailTracking.do?method=manageMailTracking&partyOid=${unit.externalId}" />
			<fr:property name="key(manage)" value="label.view" />
			<fr:property name="bundle(manage)" value="MAIL_TRACKING_RESOURCES" />
		</fr:layout>		
	</fr:view>
	
</logic:notEmpty>
