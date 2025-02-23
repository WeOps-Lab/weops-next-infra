package org.neverland.social;

import me.zhyd.oauth.config.AuthConfig;
import org.keycloak.broker.oidc.OAuth2IdentityProviderConfig;
import org.keycloak.broker.provider.AbstractIdentityProviderFactory;
import org.keycloak.broker.social.SocialIdentityProviderFactory;
import org.keycloak.models.IdentityProviderModel;
import org.keycloak.models.KeycloakSession;
import me.zhyd.oauth.request.AuthGiteeRequest;
import org.neverland.social.common.JustAuthIdentityProviderConfig;
import org.neverland.social.common.JustAuthKey;
import org.neverland.social.common.JustAuthSecondIdentityProvider;

import java.util.List;


public class GiteeIdentityProviderFactory extends
        AbstractIdentityProviderFactory<JustAuthSecondIdentityProvider>
        implements SocialIdentityProviderFactory<JustAuthSecondIdentityProvider> {

    public static final JustAuthKey JUST_AUTH_KEY = JustAuthKey.GITEE;

    @Override
    public String getName() {
        return JUST_AUTH_KEY.getName();
    }

    @Override
    public JustAuthSecondIdentityProvider create(KeycloakSession session, IdentityProviderModel model) {
        return new JustAuthSecondIdentityProvider(session,
                new JustAuthIdentityProviderConfig(model, JUST_AUTH_KEY, AuthGiteeRequest::new));
    }

    @Override
    public OAuth2IdentityProviderConfig createConfig() {
        return new OAuth2IdentityProviderConfig();
    }

    @Override
    public String getId() {
        return JUST_AUTH_KEY.getId();
    }

}
