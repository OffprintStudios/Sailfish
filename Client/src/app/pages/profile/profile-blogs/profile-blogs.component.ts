import { Component, OnInit, Input, inject, signal } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Paginated } from '$models/util';
import { Blog } from '$models/blogs';
import { ProfileService } from '$util/services/profile';

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
    profileId = signal<string>('');
    blogs = signal<Paginated<Blog>>({items: [], metadata: {page: 1, per: 15, total: 0}});

    @Input()
    set id(profileId: string) {
        this.profileId.set(profileId);
    }

    ngOnInit() {
        console.log(this.profileId());
        //this.profileService.fetchBlogs(this.profileId())
    }
}
