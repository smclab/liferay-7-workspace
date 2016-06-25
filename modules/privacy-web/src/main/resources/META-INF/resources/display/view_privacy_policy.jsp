<%--
/**
 * Copyright (c) SMC Treviso Srl. All rights reserved.
 */
--%>
<%@ include file="/display/init.jsp" %>

<div class="privacy-policy-container" id="<portlet:namespace />privacy-policy">
	<c:if test="<%= privacyPolicy != null %>">
		<liferay-ui:asset-display
			className="<%= JournalArticle.class.getName() %>"
			classPK="<%= privacyPolicy.getResourcePrimKey() %>"
			showHeader="<%= !themeDisplay.isStatePopUp() %>"
		/>
	</c:if>
</div>