<%--
/**
 * Copyright (c) SMC Treviso Srl. All rights reserved.
 */
--%>
<%@ include file="/init.jsp" %>

<%
String redirect = ParamUtil.getString(request, "redirect");

String[] staticPortlets = PropsUtil.getArray(PropsKeys.LAYOUT_STATIC_PORTLETS_ALL);
%>

<div class="container-fluid-1280" id="<portlet:namespace />settingsPanelId">

	<liferay-portlet:actionURL name="saveSettings" var="saveSettingsURL">
		<liferay-portlet:param name="mvcPath" value="/admin/view.jsp" />
	</liferay-portlet:actionURL>

	<aui:form action="<%= saveSettingsURL %>" method="post" name="fm" onSubmit='<%= "event.preventDefault(); " + renderResponse.getNamespace() + "savePolicySettings();" %>'>
		<aui:input name="redirect" type="hidden" value="<%= redirect %>" />

		<aui:fieldset-group markupView="lexicon">
			<aui:fieldset>

				<aui:input
					name="privacyEnabled"
					label="privacy-enabled"
					type="checkbox"
					checked="<%= privacyEnabled %>"
					onchange='<%= renderResponse.getNamespace() + "checkStatus()" %>'
				/>

				<c:if test="<%= !ArrayUtil.contains(staticPortlets, PrivacyPortletKeys.PRIVACY) %>">
					<div class="alert alert-warning">
						<p>
							<strong><liferay-ui:message key="warning" />!</strong>
							<liferay-ui:message key="looks-like-you-didnt-configure-this-portal-to-include-the-privacy-disclaimer-as-a-static-portlet" />
						</p>
						<p>
							<liferay-ui:message key="make-sure-your-portal-properties-have-something-similar-to-this" />
						</p>
						<pre style="margin: 5px 0px 0px"><code><%= PropsKeys.LAYOUT_STATIC_PORTLETS_ALL %>=<%= PrivacyPortletKeys.PRIVACY %></code></pre>
					</div>
				</c:if>

			</aui:fieldset>

			<div id="<portlet:namespace />settingsPanel" class="<%= privacyEnabled ? StringPool.BLANK : "hide" %>">
				<aui:fieldset collapsible="<%= true %>" label="disclaimer-configuration">

					<aui:input name="privacyPolicyArticleId" label="privacy-policy-web-content-id" value="<%= privacyPolicyArticleId %>" />

					<aui:input name="privacyInfoMessageArticleId" label="privacy-info-web-content-id" value="<%= privacyInfoMessageArticleId %>" />

					<aui:input name="cookieExpiration" label="cookie-expiration" value="<%= String.valueOf(cookieExpiration) %>" />

					<aui:input name="resetPreviousCookies" label="reset-previous-cookies" type="checkbox" checked="false" />

				</aui:fieldset>
			</div>

		</aui:fieldset-group>

		<aui:button-row>
			<aui:button type="submit" />
		</aui:button-row>

	</aui:form>
</div>

<aui:script>

	function <portlet:namespace />savePolicySettings() {
		submitForm(document.<portlet:namespace />fm);
	}

	Liferay.provide(
		window,
		'<portlet:namespace />checkStatus',
		function() {
			var A = AUI();

			var checkbox = A.one('#<portlet:namespace />privacyEnabled');
			var settingsPanel = A.one('#<portlet:namespace />settingsPanel');

			if (checkbox && settingsPanel) {
				settingsPanel.toggle(checkbox.attr('checked'))
			}
		},
		['aui-base']
	);

	<portlet:namespace />checkStatus();

</aui:script >
