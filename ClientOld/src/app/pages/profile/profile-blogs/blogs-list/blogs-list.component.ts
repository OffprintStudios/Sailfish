import { ChangeDetectionStrategy, Component, Input, OnChanges, inject } from '@angular/core';
import { NgIconComponent, provideIcons } from '@ng-icons/core';
import { remixAddLine, remixSearchEyeLine, remixFilter2Line } from '@ng-icons/remixicon';
import { ButtonComponent } from '$ui/util';
import { ViewSelectSnapshot } from '@ngxs-labs/select-snapshot';
import { AuthState } from '$state/auth';
import { Profile } from '$models/accounts';
import { Router } from '@angular/router';
import { Paginated } from '$models/util';
import { Blog } from '$models/blogs';
import { BlogsService } from '$util/services/blogs';
import { slugify } from '$util/functions';

@Component({
  selector: 'app-blogs-list',
  standalone: true,
  imports: [ButtonComponent, NgIconComponent],
  viewProviders: [provideIcons({ remixAddLine, remixSearchEyeLine, remixFilter2Line })],
  templateUrl: './blogs-list.component.html',
  styleUrl: './blogs-list.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class BlogsListComponent implements OnChanges {
    @Input({ required: true }) profileId!: string;
    @Input({ required: true }) profileName!: string;
    @ViewSelectSnapshot(AuthState.currProfile) currProfile: Profile | undefined;
    router = inject(Router);
    blogsService = inject(BlogsService);
    blogs: Paginated<Blog> = {
        items: [],
        metadata: {
            page: 1,
            per: 15,
            total: 0,
        }
    };

    ngOnChanges(): void {
        if (this.currProfile && this.profileId === this.currProfile?.id) {
            this.blogsService.fetchAllPrivate(this.currProfile.id).subscribe(results => {
                this.blogs = results;
            });
        } else {
            this.blogsService.fetchAllPublic(this.profileId).subscribe(results => {
                this.blogs = results;
            });
        }
    }

    goToCreatePage() {
        this.router.navigate(['/profile', this.profileId, slugify(this.profileName), 'blogs', 'create']);
    }
}
