package it.smc.liferay.privacy.web.portlet;

import java.io.IOException;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.PortletPreferences;

import org.osgi.service.component.annotations.Component;

import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.DateUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.WebKeys;

import it.smc.liferay.privacy.web.util.PrivacyUtil;

@Component(
	immediate = true,
	property = {
		"com.liferay.portlet.display-category=category.hidden",
		"com.liferay.portlet.instanceable=false",
		"com.liferay.portlet.preferences-owned-by-group=true",
		"com.liferay.portlet.preferences-unique-per-layout=false",
		"com.liferay.portlet.private-request-attributes=false",
		"com.liferay.portlet.private-session-attributes=false",
		"javax.portlet.display-name=EU Privacy Admin Portlet",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/admin/view.jsp",
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user"
	},
	service = Portlet.class
)
public class PrivacyAdminPortlet extends MVCPortlet {

	public void saveSettings(
			ActionRequest actionRequest, ActionResponse actionResponse)
		throws IOException, PortletException {

		ThemeDisplay themeDisplay = (ThemeDisplay)actionRequest.getAttribute(
			WebKeys.THEME_DISPLAY);

		long companyId = themeDisplay.getCompanyId();
		long groupId = themeDisplay.getScopeGroupId();

		String privacyPolicyArticleId = ParamUtil.getString(
			actionRequest, "privacyPolicyArticleId");

		String privacyInfoMessageArticleId = ParamUtil.getString(
			actionRequest, "privacyInfoMessageArticleId");

		boolean privacyEnabled = ParamUtil.getBoolean(
			actionRequest, "privacyEnabled", false);

		int cookieExpiration = ParamUtil.getInteger(
			actionRequest, "cookieExpiration", 30);

		boolean resetPreviousCookies = ParamUtil.getBoolean(
			actionRequest, "resetPreviousCookies", false);

		try {
			PortletPreferences preferences =
				PrivacyUtil.getPrivacyAdminSettings(companyId, groupId);

			preferences.setValue(
				"privacyPolicyArticleId", privacyPolicyArticleId);
			preferences.setValue(
				"privacyInfoMessageArticleId", privacyInfoMessageArticleId);
			preferences.setValue(
				"privacyEnabled", String.valueOf(privacyEnabled));
			preferences.setValue(
				"cookieExpiration", String.valueOf(cookieExpiration));

			if (resetPreviousCookies) {
				long now = DateUtil.newTime();

				preferences.setValue("nameExtend", String.valueOf(now));
			}

			preferences.store();
		}
		catch (SystemException e) {
			_log.error(e, e);

			SessionErrors.add(actionRequest, e.getMessage());
		}

		_log.info("saveSettings");
	}

	private static final Log _log = LogFactoryUtil.getLog(
		PrivacyAdminPortlet.class);

}