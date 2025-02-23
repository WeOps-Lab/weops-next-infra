package org.neverland.social;

import org.neverland.social.common.JustAuthKey;
import org.neverland.social.common.JustIdentityProvider;
import org.neverland.social.common.JustIdentityProviderConfig;
import org.keycloak.broker.oidc.OAuth2IdentityProviderConfig;
import org.keycloak.broker.provider.AbstractIdentityProviderFactory;
import org.keycloak.broker.social.SocialIdentityProviderFactory;
import org.keycloak.models.IdentityProviderModel;
import org.keycloak.models.KeycloakSession;
import me.zhyd.oauth.request. AuthGiteeRequest;

/**
 * @author yanfeiwuji
 * @date 2021/1/10 5:48 下午
 */

public class GiteeIdentityProviderFactory extends
        AbstractIdentityProviderFactory<JustIdentityProvider< AuthGiteeRequest>>
        implements SocialIdentityProviderFactory<JustIdentityProvider< AuthGiteeRequest>> {

  public static final JustAuthKey JUST_AUTH_KEY = JustAuthKey.  GITEE;

  @Override
  public String getName() {
    return JUST_AUTH_KEY.getName();
  }

  @Override
  public JustIdentityProvider< AuthGiteeRequest> create(KeycloakSession session, IdentityProviderModel model) {
    return new JustIdentityProvider<>(session, new JustIdentityProviderConfig<>(model,JUST_AUTH_KEY, AuthGiteeRequest::new));
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
