<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://fenix-ashes.ist.utl.pt/fenix-renderers" prefix="fr"%>

<%@ page import="module.mailtracking.domain.CorrespondenceType" %>
<%@ page import="module.mailtracking.presentationTier.YearBean" %>

<bean:define id="correspondenceType" name="correspondenceType" />


<script type="text/javascript" src="<%= request.getContextPath() + "/javaScript/dataTables/media/js/jquery.dataTables.js"%>"></script>
<script src='<%= request.getContextPath() + "/webjars/jquery-ui/1.11.1/jquery-ui.js" %>'></script>
<link rel="stylesheet" href="<%= request.getContextPath() + "/webjars/jquery-ui-themes/1.11.0/smoothness/jquery-ui.css" %>">

<style type="text/css" title="currentStyle">
	@import "<%= request.getContextPath() + "/javaScript/dataTables/media/css/demo_table.css" %>";
	.saviourDiv {
		height: 30px;
	}
</style>


<style type="text/css" title="currentStyle">
	.fast-entry-creation {
		display: none;
	}
	
	.fast-entry-creation div {
		margin: auto;
		vertical-align: middle;
		text-align: center;
	}
	
	.hidden-link {
		display: none;
	}
	
	.spinner {
		display: none;
	}
	
	.entry_deleted {
		opacity: 0.5;
		filter: alpha(opacity = 20);
		zoom: 1;
	}

</style>

<script type="text/javascript">
	var fastEntryCreationModal = null;
	
	function loadFastCreateEntryPage(linkToUse) {
		$('.fast-entry-creation').html($('.spinner').html());
		
		if(fastEntryCreationModal != null) {
			fastEntryCreationModal.dialog('open');
		} else {
			fastEntryCreationModal = $('.fast-entry-creation').dialog({
				bgiframe: true,
				height: 600,
				width: 700,
				modal: true
			});
		}

		$('.fast-entry-creation').html("<b>Hello</b>");

		$.ajax({
			type: "POST",
			dataType: 'html',
			url: $('.' + linkToUse).attr('href'),
			success: function(data) {
				$('.fast-entry-creation').html(data);
			}
		});

	}

	function loadFastCopyEntryPage(entryId) {
		$('.fast-entry-creation').html($('.spinner').html());
		
		if(fastEntryCreationModal != null) {
			fastEntryCreationModal.dialog('open');
		} else {
			fastEntryCreationModal = $('.fast-entry-creation').dialog({
				bgiframe: true,
				height: 600,
				width: 700,
				modal: true
			});
		}

		$.ajax({
			type: "POST",
			dataType: 'html',
			url: $('.fast-entry-copy-submission-link').attr('href'),
			data: "entryId=" + entryId,
			success: function(data) {
				$('.fast-entry-creation').html(data);
			}
		});
	}
	
	function submitForm(linkToUse) {
		fastEntryCreationModal.dialog('disable');
		$.ajax({
			type: "POST",
			dataType: 'html',
			url: $('.' + linkToUse).attr('href'),
			data: buildFormDataForPost(),
			success: function(data) {
				$('.fast-entry-creation').html(data);
				oTable.fnDraw();
			},
			complete: function() {
				fastEntryCreationModal.dialog('enable');
			}
		});
	}

	function closeFastEntryCreation() {
		fastEntryCreationModal.dialog('close');
	}
 
	function buildFormDataForPost() {
		return $('#entryForm').serialize();
	}


	$(document).ready(function(){
		$('.fast-entry-creation').css('font-size', "80%");
	});

	function rowCallBackImpl(nRow, aData, iDisplayIndex) {
		if(aData[6] == "false" || aData[7] == "false") {
			$(nRow).addClass("entry_deleted");
		}
		
		$(nRow).find("td.width0").remove();

		return nRow;
	}
	
</script>


<bean:define id="mailTrackingId" name="mailTracking" property="externalId" />


<h2><bean:message key="title.mail.tracking.application" bundle="MAIL_TRACKING_RESOURCES" /></h2>

<%-- 
<logic:equal name="correspondenceType" value="<%= CorrespondenceType.SENT.name() %>">
	<h3><bean:message key="label.last.correspondence.sent.entries" bundle="MAIL_TRACKING_RESOURCES" /> </h3>
</logic:equal>

<logic:equal name="correspondenceType" value="<%=  CorrespondenceType.RECEIVED.name() %>">
	<h3><bean:message key="label.last.correspondence.received.entries" bundle="MAIL_TRACKING_RESOURCES" /> </h3>
</logic:equal>
--%>

<logic:equal name="mailTracking" property="currentUserAbleToCreateEntries" value="true">
	<ul class="mtop05 mbottom2">
		<li>
			<html:link href="#" onclick="loadFastCreateEntryPage('fast-sent-entry-creation-link')">
				<bean:message key="label.mail.tracking.create.new.entry.sent" bundle="MAIL_TRACKING_RESOURCES"/>
			</html:link>
		</li>
		<li>
			<html:link href="#" onclick="loadFastCreateEntryPage('fast-received-entry-creation-link')">
				<bean:message key="label.mail.tracking.create.new.entry.received" bundle="MAIL_TRACKING_RESOURCES"/>
			</html:link>
		</li>
		<li>
			<html:link action='<%= "/mailtracking.do?method=prepareSetReferenceCounters&amp;mailTrackingId=" + mailTrackingId %>'>
				<bean:message key="label.mail.tracking.set.counters" bundle="MAIL_TRACKING_RESOURCES" /> 
			</html:link>
		</li>
	</ul>
</logic:equal>


<div id="list_tabs">
	<ul>
		<logic:equal name="correspondenceType" value="<%= CorrespondenceType.SENT.name() %>">
			<li id="on_lists_tab" class="active">
				<span><bean:message key="label.last.correspondence.sent.entries" bundle="MAIL_TRACKING_RESOURCES" /></span>
			</li>
			<li id="my_lists_tab">
				<html:link page='<%= "/mailtracking.do?method=prepare&amp;correspondenceType=" + CorrespondenceType.RECEIVED.name() + "&amp;mailTrackingId=" + mailTrackingId %>'><bean:message key="label.last.correspondence.received.entries" bundle="MAIL_TRACKING_RESOURCES" /></html:link>
			</li>
		</logic:equal>
		<logic:equal name="correspondenceType" value="<%=  CorrespondenceType.RECEIVED.name() %>">
			<li id="on_lists_tab">
				<html:link page='<%= "/mailtracking.do?method=prepare&amp;correspondenceType=" + CorrespondenceType.SENT.name() + "&amp;mailTrackingId=" + mailTrackingId %>'><bean:message key="label.last.correspondence.sent.entries" bundle="MAIL_TRACKING_RESOURCES" /></html:link>
			</li>
			<li id="my_lists_tab" class="active">
				<span><bean:message key="label.last.correspondence.received.entries" bundle="MAIL_TRACKING_RESOURCES" /></span>
			</li>
		</logic:equal>
	</ul>
</div>




<logic:empty name="searchEntries">
	<bean:message key="message.searched.correspondence.entries.empty" bundle="MAIL_TRACKING_RESOURCES" /> 
</logic:empty> 


<style type="text/css" title="currentStyle">
	th.actions {
		width : 140px;
	}
</style>

<logic:notEmpty name="searchEntries">


<bean:define id="filterDeletedEntries" name="filterDeletedEntriesBean" property="value" />

<bean:define id="mailTrackingUrl" type="String">
	<%= String.format("/mailtracking.do?method=prepare&amp;correspondenceType=%s&amp;mailTrackingId=%s&amp;filterDeletedEntries=%s", correspondenceType, mailTrackingId, String.valueOf(filterDeletedEntries)) %>
</bean:define>


<bean:define id="listMailTrackingUrl" type="String">
	<%= mailTrackingUrl + "&amp;method=prepare" %>
</bean:define>

<p>
	<fr:form id="mail.tracking.select.years" action="<%= listMailTrackingUrl %>">
	
	<fr:edit id="year.bean" name="yearBean" schema="module.mail.tracking.choose.year" >
		<fr:layout name="tabular" >
			<fr:destination name="postback" path="<%= listMailTrackingUrl %>" />
		</fr:layout>
	</fr:edit>
	
	<fr:edit id="filter.deleted.entries.bean" name="filterDeletedEntriesBean" schema="module.mail.tracking.set.filter.deleted.entries">
		<fr:destination name="postback" path="<%= listMailTrackingUrl %>"/>
	</fr:edit>
	
	</fr:form>
</p>

<bean:define id="yearId" value='<%= ((YearBean) request.getAttribute("yearBean")).getChosenYear() != null ? ((YearBean) request.getAttribute("yearBean")).getChosenYear().getExternalId() : "" %>' /> 

<fr:view name="searchEntries" schema='<%= CorrespondenceType.SENT.name().equals(correspondenceType) ? "module.mailtracking.correspondence.sent.entries.view" : "module.mailtracking.correspondence.received.entries.view" %>' >
	<fr:layout name="ajax-tabular">
		<fr:property name="classes" value="tstyle3 mtop05 mbottom05"/>
		<fr:property name="style" value="width: 100%;"/>
		
		<fr:property name="headerClasses" value='<%= CorrespondenceType.SENT.name().equals(correspondenceType) ? ",,,,," : ",,,,,," %>' />
		<fr:property name="columnClasses" value='<%= CorrespondenceType.SENT.name().equals(correspondenceType) ? "width30px,width50px,,,,nowrap" : "width30px,width50px,,width20px,,,nowrap" %>' />
		
		<fr:property name="ajaxSourceUrl" value="/mailtracking.do" />

		<fr:property name="linkFormat(view)" value='<%= mailTrackingUrl + "&amp;method=viewEntry&amp;entryId=${externalId}" %>' />
		<fr:property name="bundle(view)" value="MAIL_TRACKING_RESOURCES"/>
		<fr:property name="key(view)" value="link.view"/>
		<fr:property name="order(view)" value="2" />
		<fr:property name="visibleIf(view)" value="userAbleToView" />
		<fr:property name="icon(view)" value="view" />

		<fr:property name="linkFormat(edit)" value='<%= mailTrackingUrl + "&amp;method=prepareEditEntry&amp;entryId=${externalId}" %>'/>
		<fr:property name="bundle(edit)" value="MAIL_TRACKING_RESOURCES"/>
		<fr:property name="key(edit)" value="link.edit"/>
		<fr:property name="order(edit)" value="3" />
		<fr:property name="visibleIf(edit)" value="userAbleToEdit" />
		<fr:property name="icon(edit)" value="edit" />

		<fr:property name="linkFormat(delete)" value='<%= mailTrackingUrl + "&amp;method=prepareDeleteEntry&amp;entryId=${externalId}" %>'/>
		<fr:property name="bundle(delete)" value="MAIL_TRACKING_RESOURCES"/>
		<fr:property name="key(delete)" value="link.delete"/>
		<fr:property name="order(delete)" value="4" />
		<fr:property name="visibleIf(delete)" value="userAbleToDelete" />
		<fr:property name="icon(delete)" value="delete" />
		
		<fr:property name="linkFormat(document)" value="mailtracking.do" />
		<fr:property name="bundle(document)" value="MAIL_TRACKING_RESOURCES" />
		<fr:property name="key(document)" value="link.view.document" />
		<fr:property name="order(document)" value="5" />
		<fr:property name="visibleIf(document)" value="userAbleToViewDocument" />
		<fr:property name="icon(document)" value="document" />

		<fr:property name="linkFormat(copyEntry)" value=""/>
		<fr:property name="bundle(copyEntry)" value="MAIL_TRACKING_RESOURCES" />
		<fr:property name="key(copyEntry)" value="link.copy.entry" />
		<fr:property name="order(copyEntry)" value="6" />
		<fr:property name="visibleIf(copyEntry)" value="userAbleToCopyEntry" />
		<fr:property name="icon(copyEntry)" value="copyEntry" />
				
		<fr:property name="extraParameter(method)" value="ajaxFilterCorrespondence" />
		<fr:property name="extraParameter(correspondenceType)" value="<%= (String) correspondenceType %>" />
		<fr:property name="extraParameter(mailTrackingId)" value="<%= (String) mailTrackingId %>" />
		<fr:property name="extraParameter(yearId)" value="<%= yearId %>" />
		<fr:property name="extraParameter(filterDeletedEntries)" value="<%= String.valueOf(filterDeletedEntries) %>" />
	</fr:layout>
</fr:view>

</logic:notEmpty>

<div class="fast-entry-creation">
</div>

<div class="spinner">
</div>

<html:link  styleClass="hidden-link fast-sent-entry-creation-link" page='<%= String.format("/ajax-mailtracking.do?method=prepareCreateFastNewEntry&amp;correspondenceType=%s&amp;mailTrackingId=%s", CorrespondenceType.SENT.name(), mailTrackingId) %>'></html:link>
<html:link  styleClass="hidden-link fast-received-entry-creation-link" page='<%= String.format("/ajax-mailtracking.do?method=prepareCreateFastNewEntry&amp;correspondenceType=%s&amp;mailTrackingId=%s", CorrespondenceType.RECEIVED.name(), mailTrackingId) %>'></html:link>
<html:link  styleClass="hidden-link fast-sent-entry-creation-submission-link" page='<%= String.format("/ajax-mailtracking.do?method=addNewEntry&amp;correspondenceType=%s&amp;mailTrackingId=%s", CorrespondenceType.SENT.name(), mailTrackingId) %>'></html:link>
<html:link  styleClass="hidden-link fast-received-entry-creation-submission-link" page='<%= String.format("/ajax-mailtracking.do?method=addNewEntry&amp;correspondenceType=%s&amp;mailTrackingId=%s", CorrespondenceType.RECEIVED.name(), mailTrackingId) %>'></html:link>
<html:link  styleClass="hidden-link fast-entry-copy-submission-link" page='<%= String.format("/ajax-mailtracking.do?method=prepareCopyEntry&amp;correspondenceType=%s&amp;mailTrackingId=%s", correspondenceType, mailTrackingId) %>'></html:link>
