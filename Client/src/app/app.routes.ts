import { Routes } from '@angular/router';
import { HomeComponent } from "$pages/home/home.component";
import { ExploreComponent } from "$pages/explore/explore.component";
import { LogInComponent } from "$pages/auth/log-in/log-in.component";
import { SignUpComponent } from "$pages/auth/sign-up/sign-up.component";
import { CheckInboxComponent } from "$pages/auth/check-inbox/check-inbox.component";
import { SwitchProfileComponent } from "$pages/auth/switch-profile/switch-profile.component";
import { authGuard } from "$util/guards";
import { SettingsComponent } from "$pages/settings/settings.component";
import { ProfileComponent } from "$pages/profile/profile.component";
import { ProfileHomeComponent } from "$pages/profile/profile-home/profile-home.component";
import { ProfileWorksComponent } from "$pages/profile/profile-works/profile-works.component";
import { ProfileBlogsComponent } from "$pages/profile/profile-blogs/profile-blogs.component";
import { ProfileFollowersComponent } from "$pages/profile/profile-followers/profile-followers.component";
import { ProfileFollowingComponent } from "$pages/profile/profile-following/profile-following.component";
import { ProfileResolver } from "$util/services/profile";
import { ProfileShelvesComponent } from "$pages/profile/profile-shelves/profile-shelves.component";

export const routes: Routes = [
    {path: '', component: HomeComponent},
    {path: 'explore', component: ExploreComponent},
    {
        path: 'auth', children: [
            {path: 'log-in', component: LogInComponent},
            {path: 'sign-up', component: SignUpComponent},
            {path: 'switch-profile', component: SwitchProfileComponent, canActivate: [authGuard]},
            {path: 'check-inbox', component: CheckInboxComponent},
        ]
    },
    {
        path: 'profile/:id/:username', component: ProfileComponent, resolve: {profile: ProfileResolver}, children: [
            {path: '', component: ProfileHomeComponent},
            {path: 'works', component: ProfileWorksComponent},
            {path: 'blogs', component: ProfileBlogsComponent},
            {path: 'shelves', component: ProfileShelvesComponent},
            {path: 'followers', component: ProfileFollowersComponent},
            {path: 'following', component: ProfileFollowingComponent},
        ],
    },
    {path: 'settings', component: SettingsComponent},
];
