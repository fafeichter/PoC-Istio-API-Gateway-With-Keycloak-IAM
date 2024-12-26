import {Component, inject, OnInit} from '@angular/core';
import {OidcSecurityService} from 'angular-auth-oidc-client';
import {HttpClient} from '@angular/common/http';
import {map, of, switchMap} from 'rxjs';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss'],
})
export class AppComponent implements OnInit {
  isAuthenticated = false;
  greeting: string = "";
  accessToken: string = "N/A";
  refreshToken: string = "N/A";
  userName: string = "N/A";

  private readonly httpClient = inject(HttpClient);
  private readonly oidcSecurityService = inject(OidcSecurityService);
  private readonly apiGatewayBaseUrl = 'http://localhost:4000/api';

  ngOnInit(): void {
    // Subscribe to authentication status
    this.oidcSecurityService.isAuthenticated$.subscribe(({isAuthenticated}) => {
      this.isAuthenticated = isAuthenticated;
    });

    // Subscribe to user data
    this.oidcSecurityService.userData$.subscribe(userDataResult => {
      if (userDataResult.userData) {
        this.userName = userDataResult.userData.name;
      }
    });

    // Handle access and refresh tokens
    this.oidcSecurityService.isAuthenticated$
      .pipe(
        switchMap(authStatus => {
          if (authStatus.isAuthenticated) {
            return this.oidcSecurityService.getAccessToken().pipe(
              switchMap(accessToken => {
                return this.oidcSecurityService.getRefreshToken().pipe(
                  map(refreshToken => ({accessToken, refreshToken}))
                );
              })
            );
          }
          return of(null);
        })
      )
      .subscribe(tokens => {
        if (tokens) {
          this.accessToken = tokens.accessToken;
          this.refreshToken = tokens.refreshToken;
        }
      });

    // Check initial authentication status
    this.oidcSecurityService.checkAuth().subscribe();
  }

  loginWithPopup(): void {
    this.oidcSecurityService.authorizeWithPopUp().subscribe();
  }

  loginWithRedirect(): void {
    this.oidcSecurityService.authorize();
  }

  openWindow(): void {
    window.open('/', '_blank');
  }

  forceRefreshSession(): void {
    this.oidcSecurityService.forceRefreshSession().subscribe();
  }

  logout(): void {
    this.oidcSecurityService.logoff().subscribe();
  }

  loadDataFromBackend(): void {
    this.httpClient.get(`${this.apiGatewayBaseUrl}/v1/customers/hello`, {responseType: 'text'})
      .subscribe(response => {
        this.greeting = response;
      });
  }
}