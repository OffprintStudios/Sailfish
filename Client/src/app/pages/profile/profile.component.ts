import { Component, inject, OnInit } from '@angular/core';
import { map, Observable, of } from "rxjs";
import { Profile } from "$models/accounts";
import { ActivatedRoute, RouterOutlet, RouterLink, RouterLinkActive } from "@angular/router";
import { AsyncPipe, NgClass, NgIf } from "@angular/common";
import { AbbreviatePipe, LocaleDatePipe, PluralizePipe, SlugifyPipe } from "$util/pipes";
import { NgIconComponent, provideIcons } from "@ng-icons/core";
import {
    remixHome6Line,
    remixCupLine,
    remixCake2Line,
    remixUserFollowLine,
    remixUserUnfollowLine,
    remixSendPlaneLine,
    remixMore2Fill,
    remixArrowDownSLine,
    remixArrowUpSLine,
    remixAlarmWarningLine,
} from "@ng-icons/remixicon";
import { lucideBookCopy, lucideLibrary } from "@ng-icons/lucide";
import { ButtonComponent, SocialLinkBadgeComponent } from "$ui/util";

@Component({
    selector: 'app-profile',
    standalone: true,
    imports: [
        NgIf,
        AsyncPipe,
        NgClass,
        AbbreviatePipe,
        PluralizePipe,
        NgIconComponent,
        RouterOutlet,
        RouterLink,
        SlugifyPipe,
        RouterLinkActive,
        LocaleDatePipe,
        ButtonComponent,
        SocialLinkBadgeComponent,
    ],
    viewProviders: [provideIcons({
        remixHome6Line,
        remixCupLine,
        remixCake2Line,
        lucideBookCopy,
        lucideLibrary,
        remixUserFollowLine,
        remixUserUnfollowLine,
        remixSendPlaneLine,
        remixMore2Fill,
        remixArrowDownSLine,
        remixArrowUpSLine,
        remixAlarmWarningLine,
    })],
    templateUrl: './profile.component.html',
    styleUrl: './profile.component.css'
})
export class ProfileComponent implements OnInit {
    private readonly route: ActivatedRoute = inject(ActivatedRoute);
    profile$: Observable<Profile | null> = of(null);
    isOptionsMenuOpen = false;

    links = [
        "https://threads.net/@ofmanyfigments",
        "https://mastodon.social/@ofmanyfigments",
        "https://www.youtube.com/@MrBallen",
        "https://www.twitch.tv/hasanabi",
        "https://patreon.com/kanglim",
    ];

    ngOnInit() {
        this.profile$ = this.route.data.pipe(map(({profile}) => profile));
    }
}
