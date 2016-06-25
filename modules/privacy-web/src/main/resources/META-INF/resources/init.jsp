<%--
/**
 * Copyright (c) SMC Treviso Srl. All rights reserved.
 */
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>

<%@ page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@ page import="com.liferay.portal.kernel.util.StringPool"%>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@ page import="com.liferay.portal.kernel.util.Validator"%>
<%@ page import="com.liferay.portal.kernel.portlet.LiferayWindowState"%>

<%@ page import="javax.portlet.PortletPreferences"%>

<%@ page import="it.smc.liferay.privacy.web.util.PrivacyUtil"%>

<liferay-theme:defineObjects />

<portlet:defineObjects />

<%
PortletPreferences adminSettings = PrivacyUtil.getPrivacyAdminSettings(themeDisplay.getCompanyId(), scopeGroupId);

boolean privacyEnabled = GetterUtil.getBoolean(adminSettings.getValue("privacyEnabled", StringPool.BLANK), false);

String privacyInfoMessageArticleId = adminSettings.getValue("privacyInfoMessageArticleId", StringPool.BLANK);

String privacyPolicyArticleId = adminSettings.getValue("privacyPolicyArticleId", StringPool.BLANK);

int cookieExpiration = GetterUtil.getInteger(adminSettings.getValue("cookieExpiration", StringPool.BLANK),30);

String nameExtend = String.valueOf(scopeGroupId) + adminSettings.getValue("nameExtend", StringPool.BLANK);
%>