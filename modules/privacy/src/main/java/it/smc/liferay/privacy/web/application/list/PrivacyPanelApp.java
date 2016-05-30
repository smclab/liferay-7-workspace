package it.smc.liferay.privacy.web.application.list;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import com.liferay.application.list.BasePanelApp;
import com.liferay.application.list.PanelApp;
import com.liferay.application.list.constants.PanelCategoryKeys;
import com.liferay.portal.kernel.model.Portlet;

import it.smc.liferay.privacy.web.util.PrivacyPortletKeys;

@Component(
	immediate = true,
	property = {
		"panel.app.order:Integer=300",
		"panel.category.key=" + PanelCategoryKeys.SITE_ADMINISTRATION_CONTENT
	},
	service = PanelApp.class
)
public class PrivacyPanelApp extends BasePanelApp {

	@Override
	public String getPortletId() {
		return PrivacyPortletKeys.PRIVACY_ADMIN;
	}

	@Override
	@Reference(
		target = "(javax.portlet.name=" + PrivacyPortletKeys.PRIVACY_ADMIN + ")",
		unbind = "-"
	)
	public void setPortlet(Portlet portlet) {
		super.setPortlet(portlet);
	}

}
