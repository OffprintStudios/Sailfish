import { Component, inject } from "@angular/core";
import { NgOptimizedImage, NgClass, NgStyle, AsyncPipe } from "@angular/common";
import { NgIconComponent, provideIcons } from "@ng-icons/core";
import {
    remixNotification2Line,
    remixInbox2Line,
    remixSearchEyeLine,
} from "@ng-icons/remixicon";
import {
    lucideLibrary,
    lucideLogIn,
    lucideUserPlus,
    lucideArrowRightLeft,
} from "@ng-icons/lucide";
import { Router, RouterLink, RouterLinkActive } from "@angular/router";
import { Select } from "@ngxs/store";
import { AuthModel, AuthState } from "$state/auth";
import { Observable } from "rxjs";
import { Profile } from "$models/accounts";
import { UserMenuComponent } from "$ui/nav/user-menu/user-menu.component";
import { SearchMenuComponent } from "$ui/nav/search-menu/search-menu.component";

@Component({
    selector: "app-navbar",
    standalone: true,
    imports: [
        NgClass,
        NgStyle,
        AsyncPipe,
        NgIconComponent,
        NgOptimizedImage,
        RouterLink,
        RouterLinkActive,
        UserMenuComponent,
        SearchMenuComponent,
    ],
    viewProviders: [
        provideIcons({
            remixNotification2Line,
            remixInbox2Line,
            remixSearchEyeLine,
            lucideLibrary,
            lucideLogIn,
            lucideUserPlus,
            lucideArrowRightLeft,
        }),
    ],
    templateUrl: "./navbar.component.html",
    styleUrl: "./navbar.component.css",
})
export class NavbarComponent {
    @Select(AuthState) auth$!: Observable<AuthModel>;
    @Select(AuthState.currProfile) currProfile$!: Observable<Profile>;
    @Select(AuthState.isAuthenticated) isAuthenticated$!: Observable<boolean>;
    route = inject(Router);
}
