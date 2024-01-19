import { Injectable, inject } from "@angular/core";
import { HttpClient } from "@angular/common/http";
import { environment } from "$environment";
import { Profile } from "$models/accounts";

@Injectable({providedIn: 'root'})
export class ProfileService {
    private http = inject(HttpClient);

    public fetchOne(id: string) {
        return this.http.get<Profile>(`${environment.apiUrl}/profiles/${id}`);
    }

    public fetchBlogs(id: string) {

    }
}
