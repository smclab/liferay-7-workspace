<%--
/**
 * Copyright (c) SMC Treviso Srl. All rights reserved.
 */
--%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.liferay.portal.kernel.portlet.LiferayWindowState"%>
<%@ include file="/display/init.jsp" %>

<c:if test="<%= showPrivacyInfoMessage %>">

	<%
	JournalArticle privacyInfo = PrivacyUtil.getPrivacyJournalArticle(scopeGroupId, privacyInfoMessageArticleId);
	%>

	<div class="alert alert-info text-center privacy-info-message" id="<portlet:namespace />privacy-info-message">

		<c:if test="<%= privacyInfo != null %>">
			<liferay-ui:asset-display
				className="<%= JournalArticle.class.getName() %>"
				classPK="<%= privacyInfo.getResourcePrimKey() %>"
				showHeader="false"
			/>
		</c:if>

		<liferay-portlet:renderURL varImpl="viewPrivacyPolicyURL">
			<portlet:param name="jspPage" value="/display/view_privacy_policy.jsp"/>
		</liferay-portlet:renderURL>

		<aui:button-row>

			<%
			viewPrivacyPolicyURL.setWindowState(LiferayWindowState.MAXIMIZED);

			String href = viewPrivacyPolicyURL.toString();

			viewPrivacyPolicyURL.setWindowState(LiferayWindowState.POP_UP);

			String dataHref = viewPrivacyPolicyURL.toString();

			Map<String, Object> data = new HashMap<String, Object>();

			data.put("title", privacyPolicy.getTitle(locale));
			data.put("href", dataHref);
			%>

			<aui:button data="<%= data %>" href="<%= href %>" name="readMore" value="read-more" />
			<aui:button name="okButton" primary="true" value="ok" />
		</aui:button-row>
	</div>

	<aui:script use="aui-base,cookie,liferay-util-window">
		var okButton = A.one('#<portlet:namespace />okButton');
		var readMore = A.one('#<portlet:namespace />readMore');

		okButton.on('click', function (event) {
			hidePrivacyMessage();

			event.halt();
		});

		readMore.on('click', function (event) {
			if (!event.metaKey && !event.ctrlKey) {
				Liferay.Util.openInDialog(event);
			}
		});

		var wrapper = A.one('#wrapper');
		var privacyInfoMessage = A.one('#<portlet:namespace />privacy-info-message');

		if (wrapper) {
			wrapper.addClass('wrapper-for-privacy-portlet');
		}

		if (privacyInfoMessage) {
			var hideStripPrivacyInfoMessage = privacyInfoMessage.one('.hide-strip-privacy-info-message');

			if (hideStripPrivacyInfoMessage) {
				hideStripPrivacyInfoMessage.on('click', hidePrivacyMessage);
			}
		}

		function hidePrivacyMessage() {
			privacyInfoMessage.ancestor('.smc-privacy-portlet').hide();

			var today = new Date();
			var expire = new Date();
			var nDays = <%= cookieExpiration %>;

			expire.setTime(today.getTime() + 3600000 * 24 * nDays);

			var expString = "expires=" + expire.toGMTString();

			cookieName = "<%= PrivacyUtil.PRIVACY_READ %><%= nameExtend %>";
			cookieValue = today.getTime();

			document.cookie = cookieName+"="+escape(cookieValue)+ ";expires="+expire.toGMTString();

			wrapper.removeClass('wrapper-for-privacy-portlet');
		}
	</aui:script>

</c:if>