import { Injectable, inject } from "@angular/core";
import { HttpClient } from "@angular/common/http";
import { SelectSnapshot } from "@ngxs-labs/select-snapshot";
import { environment } from "$environment";
import { AuthState } from "$state/auth";
import { Paginated } from "$models/util";
import { Blog, BlogForm } from "$models/blogs";

@Injectable({ providedIn: 'root' })
export class BlogsService {
    @SelectSnapshot(AuthState.token) token: string | undefined;
    private http = inject(HttpClient);

    public fetchAllPublic(profileId: string) {
        // TODO: add rating and chronological filters
        return this.http.get<Paginated<Blog>>(`${environment.apiUrl}/profiles/${profileId}/blogs`);
    }

    public fetchAllPrivate(profileId: string) {
        // TODO: add rating and chronological filters
        return this.http.get<Paginated<Blog>>(`${environment.apiUrl}/blogs/all?profileId=${profileId}`, {
            headers: {
                'Authorization': `Bearer ${this.token}`
            }
        });
    }

    public create(profileId: string, formInfo: BlogForm) {
        return this.http.post(`${environment.apiUrl}/blogs/create?profileId=${profileId}`, formInfo, {
            headers: {
                'Authorization': `Bearer ${this.token}`
            }
        });
    }

    public read(blogId: string) {
        return this.http.get(`${environment.apiUrl}/blogs/${blogId}`);
    }

    public update(profileId: string, blogId: string, formInfo: BlogForm) {
        return this.http.post(`${environment.apiUrl}/blogs/${blogId}/update?profileId=${profileId}`, formInfo, {
            headers: {
                'Authorization': `Bearer ${this.token}`
            }
        });
    }

    public delete(profileId: string, blogId: string) {
        return this.http.delete(`${environment.apiUrl}/blogs/${blogId}/delete?profileId=${profileId}`, {
            headers: {
                'Authorization': `Bearer ${this.token}`
            }
        });
    }
}
