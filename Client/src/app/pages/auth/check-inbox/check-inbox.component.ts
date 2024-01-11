import { Component, OnInit } from '@angular/core';
import { CommonModule } from "@angular/common";
import { RouterLink } from "@angular/router";
import { NgIconComponent, provideIcons } from "@ng-icons/core";
import { remixMailCheckLine } from "@ng-icons/remixicon";
import { Select } from "@ngxs/store";
import { AuthModel, AuthState } from "$state/auth";
import { Observable, take } from "rxjs";

@Component({
    selector: 'app-check-inbox',
    standalone: true,
    imports: [CommonModule, NgIconComponent, RouterLink],
    viewProviders: [provideIcons({ remixMailCheckLine })],
    templateUrl: './check-inbox.component.html',
    styleUrl: './check-inbox.component.css'
})
export class CheckInboxComponent implements OnInit {
    @Select(AuthState) auth$!: Observable<AuthModel>;
    showUnavailableActionPrompt = false;

    ngOnInit() {
        this.auth$.pipe(take(1)).subscribe(value => {
            if (value.account) {
                this.showUnavailableActionPrompt = true;
            }
        });
    }
}
