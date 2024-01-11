import { Component, OnInit } from '@angular/core';
import { Store, Select } from "@ngxs/store";
import { AuthActions, AuthState } from "$state/auth";
import { Observable, take, withLatestFrom } from "rxjs";
import { Profile, ProfileForm } from "$models/accounts";
import { NgIconComponent, provideIcons } from "@ng-icons/core";
import { remixAddLine, remixCloseLine } from "@ng-icons/remixicon";
import { CommonModule, NgOptimizedImage } from "@angular/common";
import { toSignal } from "@angular/core/rxjs-interop";
import { FormControl, FormGroup, ReactiveFormsModule, Validators } from "@angular/forms";
import { TextAreaComponent, TextFieldComponent } from "$ui/forms";
import { ButtonComponent } from "$ui/util";
import { Router } from "@angular/router";

@Component({
    selector: 'app-switch-profile',
    standalone: true,
    imports: [CommonModule, NgIconComponent, ReactiveFormsModule, TextFieldComponent, TextAreaComponent, ButtonComponent, NgOptimizedImage],
    viewProviders: [provideIcons({ remixAddLine, remixCloseLine })],
    templateUrl: './switch-profile.component.html',
    styleUrl: './switch-profile.component.css'
})
export class SwitchProfileComponent implements OnInit {
    @Select(AuthState.profiles) profiles$!: Observable<Profile[]>;
    showCreateProfileForm = false;

    profileForm = new FormGroup({
        username: new FormControl('', [Validators.required, Validators.min(3), Validators.max(32)]),
        bio: new FormControl('', [Validators.min(3), Validators.max(120)]),
    });

    constructor(private store: Store, private router: Router) {}

    get username() { return this.profileForm.controls['username'] };
    get bio() { return this.profileForm.controls['bio'] };

    ngOnInit() {
        this.store.dispatch(new AuthActions.FetchProfiles())
            .pipe(take(1))
            .subscribe();
    }

    selectProfile(id: string) {
        this.store.dispatch(new AuthActions.SelectProfile(id))
            .pipe(take(1))
            .subscribe(() => {
                this.router.navigate(['/']);
            });
    }

    onSubmit() {
        if (!this.profileForm.valid) {
            // TODO: replace alert with toast message
            alert('The information you\'ve entered is invalid.');
            return;
        }

        const profileForm: ProfileForm = {
            username: this.username.value!,
            bio: this.bio.value === '' ? undefined : (this.bio.value ?? undefined),
            tagline: undefined,
            links: [],
        };

        console.log("Profile Form:");
        console.log(profileForm);

        this.store.dispatch(new AuthActions.CreateProfile(profileForm))
            .pipe(take(1))
            .subscribe(() => {
                this.showCreateProfileForm = false;
                this.profileForm.reset();
            });
    }
}
