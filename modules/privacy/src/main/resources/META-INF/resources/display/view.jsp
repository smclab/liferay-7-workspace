<%--
/**
 * Copyright (c) SMC Treviso Srl. All rights reserved.
 */
--%>
<%@ include file="/display/init.jsp" %>

<c:if test="<%= showPrivacyInfoMessage %>">
	<%
	JournalArticle privacyInfo = PrivacyUtil.getPrivacyJournalArticle(scopeGroupId, privacyInfoMessageArticleId);
	%>
	<div class="privacy-info-message" id="<portlet:namespace />privacy-info-message">
		<c:if test="<%= privacyInfo != null %>">
			<liferay-ui:asset-display
				className="<%= JournalArticle.class.getName() %>"
				classPK="<%= privacyInfo.getResourcePrimKey() %>"
				showHeader="false"
			/>
		</c:if>
		<aui:button-row>
			<aui:button name="readMore" value="read-more" />
			<aui:button cssClass="btn btn-primary" name="okButton" value="ok" />
		</aui:button-row>
	</div>

	<liferay-portlet:renderURL var="viewPrivacyPolicyURL" windowState="<%= LiferayWindowState.POP_UP.toString() %>">
		<portlet:param name="jspPage" value="/display/view_privacy_policy.jsp"/>
	</liferay-portlet:renderURL>

	<aui:script use="aui-base,aui-io-deprecated,cookie,liferay-util-window">
		var okButton = A.one('#<portlet:namespace />okButton');
		var readMore = A.one('#<portlet:namespace />readMore');

		okButton.on('click', function(e) {

			hidePrivacyMessage();

			e.halt();
		});

		readMore.on('click', function(e) {
				e.preventDefault();

				var dialog = Liferay.Util.Window.getWindow(
					{
						dialog: {
							destroyOnClose: true,
							modal: true,
							centered: true,
							width: 800,
							height:600
						},
						title: '<%= privacyPolicy.getTitle(locale) %>'
					}
				);

				dialog.plug(
					A.Plugin.IO,
					{
						uri: '<%= viewPrivacyPolicyURL %>'
					}
				);
			},
			['liferay-util-window', 'aui-io-plugin-deprecated']
		);

		var wrapper = A.one('#wrapper');

		var privacyInfoMessage = A.one('.smc-privacy-portlet .privacy-info-message');

		if (privacyInfoMessage) {
			wrapper.addClass('wrapper-for-privacy-portlet');

			var hideStripPrivacyInfoMessage = privacyInfoMessage.one('.hide-strip-privacy-info-message');

			var hidePrivacyMessage = function() {

				privacyInfoMessage.ancestor('.smc-privacy-portlet').hide();
					// renewal
					var today = new Date();
					var expire = new Date();
					var nDays = <%= cookieExpiration %>;
					expire.setTime(today.getTime() + 3600000*24*nDays);
					var expString = "expires=" + expire.toGMTString();
					cookieName = "<%= PrivacyUtil.PRIVACY_READ %><%= nameExtend %>";
					cookieValue = today.getTime();
					document.cookie = cookieName+"="+escape(cookieValue)+ ";expires="+expire.toGMTString();

				wrapper.removeClass('wrapper-for-privacy-portlet');
			}

			if (hideStripPrivacyInfoMessage) {
				hideStripPrivacyInfoMessage.on('click', hidePrivacyMessage);
			}

		}
	</aui:script>

</c:if>