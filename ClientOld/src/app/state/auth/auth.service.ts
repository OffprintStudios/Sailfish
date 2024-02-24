import { Injectable, inject } from "@angular/core";
import { HttpClient } from "@angular/common/http";
import { isDevMode } from "@angular/core";
import { environment } from "$environment";
import { Account, Profile, ProfileForm, RegisterForm } from "$models/accounts";
import { Observable } from "rxjs";

@Injectable({providedIn: 'root'})
export class AuthService {
    private http = inject(HttpClient);

    public logIn(email: string, password: string): Observable<Account> {
        const basicAuth = `${email}:${password}`;
        const authAsBase64 = btoa(basicAuth);

        return this.http.post<Account>(
            `${environment.apiUrl}/auth/log-in`,
            {},
            {
                headers: {
                    'Authorization': `Basic ${authAsBase64}`,
                },
            }
        );
    }

    public register(formInfo: RegisterForm): Observable<void> {
        return this.http.post<void>(
            `${environment.apiUrl}/auth/register`,
            formInfo,
        );
    }

    public fetchProfiles(token: string): Observable<Profile[]> {
        return this.http.get<Profile[]>(`${environment.apiUrl}/accounts/profiles/all`, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });
    }

    public createProfile(formInfo: ProfileForm, token: string) {
        return this.http.post<Profile>(
            `${environment.apiUrl}/accounts/profiles/create`,
            formInfo,
            {
                headers: {
                    'Authorization': `Bearer ${token}`
                }
            }
        );
    }
}
