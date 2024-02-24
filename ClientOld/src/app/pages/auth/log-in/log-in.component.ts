import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormGroup, FormControl, Validators } from "@angular/forms";
import { NgIconComponent, provideIcons } from "@ng-icons/core";
import { lucideLogIn } from "@ng-icons/lucide";
import { TextFieldComponent } from "$ui/forms";
import { ButtonComponent } from "$ui/util";
import { Router, RouterLink } from "@angular/router";
import { Select, Store } from "@ngxs/store";
import { Observable, take, withLatestFrom } from "rxjs";
import { AuthState, AuthModel, AuthActions } from "$state/auth";
import { remixMailCheckLine, remixUserForbidLine } from "@ng-icons/remixicon";
import { Meta, Title } from "@angular/platform-browser";
import { generateTags } from "$util/meta";

@Component({
    selector: 'app-log-in',
    standalone: true,
    imports: [CommonModule, ReactiveFormsModule, TextFieldComponent, ButtonComponent, NgIconComponent, RouterLink],
    viewProviders: [provideIcons({ lucideLogIn, remixMailCheckLine, remixUserForbidLine  })],
    templateUrl: './log-in.component.html',
    styleUrl: './log-in.component.css'
})
export class LogInComponent implements OnInit {
    @Select(AuthState) auth$!: Observable<AuthModel>;
    showUnavailableActionPrompt = false;

    loginForm = new FormGroup({
        email: new FormControl('', [Validators.required, Validators.email]),
        password: new FormControl('', [Validators.required, Validators.min(8)]),
    });

    constructor(private store: Store, private router: Router, private title: Title, private meta: Meta) {}

    ngOnInit() {
        this.auth$.pipe(take(1)).subscribe(value => {
            if (value.account) {
                this.showUnavailableActionPrompt = true;
            }
        });

        this.title.setTitle("Log In — Offprint");
        this.meta.addTags(generateTags("Log In", "Log In To Your Offprint Account", "website", "https://offprint.cafe/auth/log-in", "/images/offprint_icon.png"))
    }

    get email() { return this.loginForm.controls['email'].value; }
    get password() { return this.loginForm.controls['password'].value; }

    onSubmit() {
        if (this.loginForm.valid) {
            const loginFormValue = {
                email: this.email!,
                password: this.password!,
            }
            this.store.dispatch(new AuthActions.LogIn(loginFormValue))
                .pipe(withLatestFrom(this.auth$))
                .subscribe(([_, auth]) => {
                    if (auth.token) {
                        console.log("navigating...");
                        this.router.navigate(['/auth/switch-profile']).then(() => this.loginForm.reset());
                    } else {
                        this.router.navigate(['/auth/check-inbox']).then(() => this.loginForm.reset());
                    }
                });
        }
    }
}
