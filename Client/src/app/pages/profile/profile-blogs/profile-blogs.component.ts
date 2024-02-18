import { Component, OnInit, inject, signal } from '@angular/core';
import { ActivatedRoute, Router, RouterOutlet } from '@angular/router';
import { AsyncPipe } from '@angular/common';
import { Paginated } from '$models/util';
import { Profile } from '$models/accounts';
import { Blog } from '$models/blogs';
import { BlogsListComponent } from './blogs-list/blogs-list.component';
import { Observable, of, map } from 'rxjs';
import { Select } from '@ngxs/store';
import { AuthState } from '$state/auth';

@Component({
    selector: 'app-profile-blogs',
    standalone: true,
    imports: [BlogsListComponent, AsyncPipe, RouterOutlet],
    templateUrl: './profile-blogs.component.html',
    styleUrl: './profile-blogs.component.css'
})
export class ProfileBlogsComponent implements OnInit {
    @Select(AuthState.currProfile) currProfile$!: Observable<Profile>;
    route = inject(ActivatedRoute);
    router = inject(Router);
    profile$: Observable<Profile | null> = of(null);
    blogs = signal<Paginated<Blog>>({items: [], metadata: {page: 1, per: 15, total: 0}});

    ngOnInit() {
        this.profile$ = this.route.parent!.data.pipe(map(({profile}) => profile));
    }
}
