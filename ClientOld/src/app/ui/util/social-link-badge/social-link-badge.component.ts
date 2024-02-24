import { afterRender, Component, Input } from '@angular/core';
import { ProfileMatch, SocialLinks, TYPE_DEFAULT, TYPE_DESKTOP } from "social-links";
import { NgIconComponent, provideIcons } from "@ng-icons/core";
import {
    remixTwitterFill,
    remixThreadsLine,
    remixMastodonFill,
    remixPatreonFill,
    remixTwitchFill,
    remixTumblrFill,
    remixYoutubeFill,
    remixFacebookFill,
    remixLinksLine,
} from "@ng-icons/remixicon";

@Component({
    selector: 'app-social-link-badge',
    standalone: true,
    imports: [NgIconComponent],
    viewProviders: [provideIcons({
        remixTwitterFill,
        remixThreadsLine,
        remixMastodonFill,
        remixPatreonFill,
        remixTwitchFill,
        remixTumblrFill,
        remixYoutubeFill,
        remixFacebookFill,
        remixLinksLine,
    })],
    templateUrl: './social-link-badge.component.html',
    styleUrl: './social-link-badge.component.css'
})
export class SocialLinkBadgeComponent {
    @Input({required: true}) link!: string;
    socialLinks = new SocialLinks({
        usePredefinedProfiles: true,
        trimInput: true,
        allowQueryParams: false,
    });
    serviceName: string = '';
    profileId: string = '';
    displayString: string = '';

    constructor() {
        afterRender(() => {
            const threadsMatch: ProfileMatch[] =
                [
                    {
                        match: '(https?://)?(www.)?threads.net/@({PROFILE_ID})/?',
                        group: 3,
                        type: TYPE_DEFAULT,
                        pattern: 'https://threads.net/@{PROFILE_ID}'
                    }
                ];

            const tumblrMatch: ProfileMatch[] =
                [
                    {
                        match: '(https?://)?(www.)?tumblr.com/({PROFILE_ID})/?',
                        group: 3,
                        type: TYPE_DESKTOP,
                        pattern: 'https://tumblr.com/{PROFILE_ID}'
                    },
                    {
                        match: '(https?://)?({PROFILE_ID}.)?tumblr.com/?',
                        group: 3,
                        type: TYPE_DESKTOP,
                        pattern: 'https://{PROFILE_ID}.tumblr.com',
                    }
                ]

            this.socialLinks.addProfile('threads', threadsMatch);
            this.socialLinks.addProfile('tumblr', tumblrMatch);

            // detect service, profile ID, etc
            this.serviceName = this.socialLinks.detectProfile(this.link);
            this.profileId = this.socialLinks.getProfileId(this.serviceName, this.link);
            if (this.serviceName === 'twitter' || this.serviceName === 'mastodon' || this.serviceName === 'youtube' || this.serviceName === 'threads') {
                this.displayString = `@${this.profileId}`;
            } else if (this.serviceName !== '') {
                this.displayString = `${this.profileId};`
            } else {
                this.displayString = this.link;
            }
            this.displayString = this.displayString.replace(';', '');
        });
    }
}
