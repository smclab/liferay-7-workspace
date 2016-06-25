package it.smc.liferay.privacy.web.util;

import javax.portlet.PortletPreferences;
import javax.servlet.http.HttpServletRequest;

import com.liferay.journal.model.JournalArticle;
import com.liferay.journal.service.JournalArticleLocalServiceUtil;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.service.PortletPreferencesLocalServiceUtil;
import com.liferay.portal.kernel.util.CookieKeys;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.PortletKeys;
import com.liferay.portal.kernel.util.Validator;

public class PrivacyUtil {

	public static final String PRIVACY_READ = "PRIVACY_READ";

	public static PortletPreferences getPrivacyAdminSettings(
		long companyId, long groupId) {

		return PortletPreferencesLocalServiceUtil.getPreferences(
			companyId, groupId, PortletKeys.PREFS_OWNER_TYPE_GROUP, 0,
			PrivacyPortletKeys.PRIVACY_ADMIN);
	}

	public static JournalArticle getPrivacyJournalArticle(
		long groupId, String articleId) {

		if (Validator.isNull(articleId) || Validator.isNull(groupId)) {
			return null;
		}

		try {
			return JournalArticleLocalServiceUtil.fetchArticle(
				groupId, articleId);
		}
		catch (Exception e) {
			_log.error(e, e);
		}

		return null;
	}

	public static boolean showPrivacyInfoMessage(
		boolean signedIn, boolean privacyEnabled, JournalArticle privacyPolicy,
		HttpServletRequest request, String nameExtend) {

		if (signedIn) {
			return false;
		}
		else if (!privacyEnabled) {
			if (_log.isDebugEnabled()) {
				_log.debug("Privacy is NOT enabled.");
			}

			return false;
		}

		if (Validator.isNull(privacyPolicy)) {
			if (_log.isWarnEnabled()) {
				_log.warn(
					"Privacy is enabled but no web content is set for " +
						"Privacy Policy!");
			}

			return false;
		}

		long cookieValidationDateMillis = GetterUtil.getLong(
			CookieKeys.getCookie(request, PRIVACY_READ + nameExtend));

		if (cookieValidationDateMillis == 0) {
			return true;
		}

		return false;
	}

	private static final Log _log = LogFactoryUtil.getLog(PrivacyUtil.class);

}
