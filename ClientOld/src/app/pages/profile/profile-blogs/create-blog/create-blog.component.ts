import { Component, inject } from '@angular/core';
import { NgIconComponent, provideIcons } from '@ng-icons/core';
import { remixArrowLeftSLine } from '@ng-icons/remixicon';
import { ButtonComponent } from '$ui/util';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-create-blog',
  standalone: true,
  imports: [ButtonComponent, NgIconComponent],
  viewProviders: [provideIcons({ remixArrowLeftSLine })],
  templateUrl: './create-blog.component.html',
  styleUrl: './create-blog.component.css'
})
export class CreateBlogComponent {
    router = inject(Router);
    route = inject(ActivatedRoute);

    goBack() {
        this.router.navigate(['../'], { relativeTo: this.route })
    }
}
