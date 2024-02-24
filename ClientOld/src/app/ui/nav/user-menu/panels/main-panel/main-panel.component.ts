import { Component, EventEmitter, Output } from "@angular/core";
import { NgIconComponent, provideIcons } from "@ng-icons/core";
import { AsyncPipe, NgOptimizedImage } from "@angular/common";
import {
    remixArrowDownSLine,
    remixArrowLeftRightLine,
    remixArrowRightSLine,
    remixArrowUpSLine,
    remixBook2Line,
    remixCloseLine,
    remixCupLine,
    remixEyeLine,
    remixLinksLine,
    remixLogoutBoxLine,
    remixQuillPenLine,
    remixSettings6Line,
} from "@ng-icons/remixicon";
import { Select, Store } from "@ngxs/store";
import { AuthActions, AuthState } from "$state/auth";
import { Observable, take } from "rxjs";
import { Profile } from "$models/accounts";
import { RouterLink } from "@angular/router";
import { SlugifyPipe } from "$util/pipes";

@Component({
    selector: "app-main-panel",
    standalone: true,
    imports: [NgIconComponent, NgOptimizedImage, AsyncPipe, RouterLink, SlugifyPipe],
    viewProviders: [
        provideIcons({
            remixQuillPenLine,
            remixCupLine,
            remixEyeLine,
            remixBook2Line,
            remixArrowLeftRightLine,
            remixLogoutBoxLine,
            remixLinksLine,
            remixArrowDownSLine,
            remixArrowUpSLine,
            remixArrowRightSLine,
            remixSettings6Line,
            remixCloseLine,
        }),
    ],
    templateUrl: "./main-panel.component.html",
    styleUrl: "./main-panel.component.css",
})
export class MainPanelComponent {
    @Select(AuthState.profiles) profiles$!: Observable<Profile[]>;
    @Select(AuthState.currProfile) currProfile$!: Observable<Profile>;
    @Output() onClickSettings = new EventEmitter();
    @Output() onClickLogOut = new EventEmitter();
    showSwitchProfile = false;

    constructor(private store: Store) {
    }

    selectProfile(id: string) {
        this.store.dispatch(new AuthActions.SelectProfile(id))
            .pipe(take(1))
            .subscribe(() => {
                this.showSwitchProfile = false;
            });
    }
}
