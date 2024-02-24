import { Injectable, inject } from "@angular/core";
import { HttpClient } from "@angular/common/http";
import { environment } from "$environment";
import { Profile } from "$models/accounts";
import { Paginated } from "$models/util";
import { Blog } from "$models/blogs";
import { SelectSnapshot } from "@ngxs-labs/select-snapshot";
import { AuthState } from "$state/auth";

@Injectable({providedIn: 'root'})
export class ProfileService {
    @SelectSnapshot(AuthState.token) token: string | undefined;
    private http = inject(HttpClient);

    public fetchOne(id: string) {
        return this.http.get<Profile>(`${environment.apiUrl}/profiles/${id}`);
    }

    public fetchBlogs(id: string, page: number = 1, per: number = 15, onlyPublic: boolean = true) {
        const publicUrl = `${environment.apiUrl}/profiles/${id}/blogs?page=${page}&per=${per}`;
        const privateUrl = `${environment.apiUrl}/blogs/all?profileId=${id}&page=${page}&per=${per}`;

        return this.http.get<Paginated<Blog>>(onlyPublic ? publicUrl : privateUrl, {
            headers: {
                'Authorization': `Bearer ${this.token}`,
            },
        });
    }
}
