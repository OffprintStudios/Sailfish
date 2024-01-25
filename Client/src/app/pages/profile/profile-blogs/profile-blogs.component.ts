import { Component, OnInit, Input, inject, signal } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Paginated } from '$models/util';
import { Profile } from '$models/accounts';
import { Blog } from '$models/blogs';
import { ProfileService } from '$util/services/profile';
import { Observable, of, map } from 'rxjs';

@Component({
    selector: 'app-profile-blogs',
    standalone: true,
    imports: [],
    templateUrl: './profile-blogs.component.html',
    styleUrl: './profile-blogs.component.css'
})
export class ProfileBlogsComponent implements OnInit {
    private readonly route = inject(ActivatedRoute);
    private readonly profileService = inject(ProfileService);
    profile$: Observable<Profile | null> = of(null);
    blogs = signal<Paginated<Blog>>({items: [], metadata: {page: 1, per: 15, total: 0}});

    ngOnInit() {
        this.profile$ = this.route.data.pipe(map(({profile}) => profile));
    }
}
