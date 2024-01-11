import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormControl, FormGroup, ReactiveFormsModule, Validators } from "@angular/forms";
import { TextFieldComponent } from "$ui/forms";
import { ButtonComponent } from "$ui/util";
import { NgIconComponent, provideIcons } from "@ng-icons/core";
import { Router, RouterLink } from "@angular/router";
import { remixMailCheckLine, remixUserForbidLine, remixUserAddLine } from "@ng-icons/remixicon";
import { Select, Store } from "@ngxs/store";
import { AuthModel, AuthState, AuthActions } from "$state/auth";
import { Observable, take } from "rxjs";
import { RegisterForm } from "$models/accounts";

@Component({
    selector: 'app-sign-up',
    standalone: true,
    imports: [CommonModule, ReactiveFormsModule, TextFieldComponent, ButtonComponent, NgIconComponent, RouterLink],
    viewProviders: [provideIcons({ remixUserAddLine, remixMailCheckLine, remixUserForbidLine })],
    templateUrl: './sign-up.component.html',
    styleUrl: './sign-up.component.css'
})
export class SignUpComponent implements OnInit {
    @Select(AuthState) auth$!: Observable<AuthModel>;
    showUnavailableActionPrompt = false;

    registerForm = new FormGroup({
        email: new FormControl('', [Validators.required, Validators.email]),
        password: new FormControl('', [Validators.required, Validators.min(8)]),
        repeatPassword: new FormControl('', [Validators.required, Validators.min(8)]),
        ageCheck: new FormControl(false, [Validators.required, Validators.requiredTrue]),
        termsAgree: new FormControl(false, [Validators.required, Validators.requiredTrue]),
    });

    constructor(private store: Store, private router: Router) {}

    ngOnInit() {
        this.auth$.pipe(take(1)).subscribe(value => {
            if (value.account) {
                this.showUnavailableActionPrompt = true;
            }
        });
    }

    get email() { return this.registerForm.controls['email']; }
    get password() { return this.registerForm.controls['password']; }
    get repeatPassword() { return this.registerForm.controls['repeatPassword']; }
    get ageCheck() { return this.registerForm.controls['ageCheck']; }
    get termsAgree() { return this.registerForm.controls['termsAgree']; }

    onSubmit() {
        if (this.registerForm.valid) {
            if (this.password !== this.repeatPassword) {
                // TODO: replace this with an actual alert pop up that isn't just the system shit
                alert('Passwords must match!');
                return;
            }

            const formInfo: RegisterForm = {
                email: this.email.value!,
                password: this.password.value!,
                ageCheck: this.ageCheck.value!,
                termsAgree: this.termsAgree.value!,
            }

            this.store.dispatch(new AuthActions.Register(formInfo))
                .subscribe(() => {
                    this.router.navigate(['/auth/check-inbox']).then(() => this.registerForm.reset());
                });
        }
    }
}
