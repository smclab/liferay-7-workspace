<%--
/**
 * Copyright (c) SMC Treviso Srl. All rights reserved.
 */
--%>
<%@ include file="/init.jsp" %>

<%@ page import="com.liferay.journal.model.JournalArticle"%>

<%
JournalArticle privacyPolicy = PrivacyUtil.getPrivacyJournalArticle(scopeGroupId, privacyPolicyArticleId);

boolean showPrivacyInfoMessage = PrivacyUtil.showPrivacyInfoMessage(
	themeDisplay.isSignedIn(), privacyEnabled, privacyPolicy, request, nameExtend);
%>


