<%--
/**
 * Copyright (c) SMC Treviso Srl. All rights reserved.
 */
--%>
<%@ include file="/init.jsp" %>

<%
String redirect = ParamUtil.getString(request, "redirect");
%>

<aui:nav-bar cssClass="" markupView="lexicon">
	<aui:nav cssClass="navbar-nav">
		<aui:nav-item label="privacy-settings" selected="<%= true %>" />
	</aui:nav>
</aui:nav-bar>

<div class="closed container-fluid-1280 sidenav-container sidenav-right" id="<portlet:namespace />settingsPanelId">
	<div class="sidenav-content">
		<liferay-portlet:actionURL name="saveSettings" var="saveSettingsURL">
			<liferay-portlet:param name="mvcPath" value="/admin/view.jsp" />
		</liferay-portlet:actionURL>

		<aui:form action="<%= saveSettingsURL %>" method="post" name="fm" onSubmit='<%= "event.preventDefault(); " + renderResponse.getNamespace() + "savePolicySettings();" %>'>
			<aui:input name="redirect" type="hidden" value="<%= redirect %>" />

			<aui:fieldset>

				<aui:input name="privacyEnabled" label="privacy-enabled" type="checkbox"
						checked="<%= privacyEnabled %>"
						onchange='<%= renderResponse.getNamespace() + \"checkStatus()\" %>' />

				<div id="idsPanel" style="display:none">

					<aui:input name="privacyPolicyArticleId" label="privacy-policy-web-content-id" value="<%= privacyPolicyArticleId %>" />

					<aui:input name="privacyInfoMessageArticleId" label="privacy-info-web-content-id" value="<%= privacyInfoMessageArticleId %>" />

					<aui:input name="cookieExpiration" label="cookie-expiration" value="<%= String.valueOf(cookieExpiration) %>" />

					<aui:input name="resetPreviousCookies" label="reset-previous-cookies" type="checkbox" checked="false" />

				</div>

			</aui:fieldset>

			<aui:button-row>
				<aui:button type="submit" />
			</aui:button-row>

		</aui:form>
	</div>
</div>
<aui:script>
	function <portlet:namespace />savePolicySettings() {
		submitForm(document.<portlet:namespace />fm);
	}
</aui:script>

<aui:script>
	Liferay.provide(
		window,
		'<portlet:namespace />checkStatus',
		function() {
			var A = AUI();
			var checkbox = A.one('#<portlet:namespace />privacyEnabled');
			if (checkbox) {
				var status=checkbox.attr('checked');
				//alert("status: "+status);
				privacyEnabled=status;
				if (status) {
					//alert ("Show");
					A.one('#idsPanel').show(true);
				} else {
					//alert ("Hide");
					A.one('#idsPanel').hide(true);
				}
			}
		},
		['aui-base']
	);
</aui:script >

<!-- toggle panel on page load ad reload -->
<aui:script use="aui-base">
	var A = AUI();
	var checkbox = A.one('#<portlet:namespace />privacyEnabled');
	if (checkbox) {
		var status=checkbox.attr('checked');
		privacyEnabled=status;
		if (status) {
			A.one('#idsPanel').show(true);
		} else {
			A.one('#idsPanel').hide(true);
		}
	}
</aui:script>