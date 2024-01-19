import { Component, OnInit, inject } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Observable, of, map } from 'rxjs';
import { Profile } from '$models/accounts';

@Component({
    selector: 'app-profile-blogs',
    standalone: true,
    imports: [],
    templateUrl: './profile-blogs.component.html',
    styleUrl: './profile-blogs.component.css'
})
export class ProfileBlogsComponent implements OnInit {
    private readonly route: ActivatedRoute = inject(ActivatedRoute);
    profile$: Observable<Profile | null> = of(null);

    ngOnInit() {
        this.profile$ = this.route.data.pipe(map(({profile}) => profile));
    }
}
