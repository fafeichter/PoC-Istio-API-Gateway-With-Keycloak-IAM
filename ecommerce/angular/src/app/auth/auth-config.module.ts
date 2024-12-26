import {NgModule} from '@angular/core';
import {AuthModule, LogLevel} from 'angular-auth-oidc-client';

@NgModule({
  imports: [AuthModule.forRoot({
    config: {
      authority: 'http://localhost:8080/realms/ecommerce/',
      redirectUrl: window.location.origin,
      postLogoutRedirectUri: window.location.origin,
      clientId: 'ecommerce',
      scope: 'openid profile email offline_access',
      responseType: 'code',
      silentRenew: true,
      useRefreshToken: true,
      renewTimeBeforeTokenExpiresInSeconds: 30,
      secureRoutes: ['http://localhost:4000/api/'],
      logLevel: LogLevel.Debug,
    }
  })],
  exports: [AuthModule],
})
export class AuthConfigModule {
}