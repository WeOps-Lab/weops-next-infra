package io.github.yanfeiwuji.justauth.social;

import io.github.yanfeiwuji.justauth.social.common.JustAuthIdentityProviderConfig;
import io.github.yanfeiwuji.justauth.social.common.JustAuthKey;
import io.github.yanfeiwuji.justauth.social.common.JustAuthSecondIdentityProvider;
import io.github.yanfeiwuji.justauth.social.compatible.JustAuthWeChatEnterpriseQrcodeV2Request;
import org.keycloak.broker.oidc.OAuth2IdentityProviderConfig;
import org.keycloak.broker.provider.AbstractIdentityProviderFactory;
import org.keycloak.broker.social.SocialIdentityProviderFactory;
import org.keycloak.models.IdentityProviderModel;
import org.keycloak.models.KeycloakSession;
import me.zhyd.oauth.request.AuthGiteeRequest;
import org.keycloak.provider.ProviderConfigProperty;
import org.keycloak.provider.ProviderConfigurationBuilder;

import java.util.List;

/**
 * @author yanfeiwuji
 * @date 2021/1/10 5:48 下午
 */

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
