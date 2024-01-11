import { Presence } from "./presence";
import { Roles } from "./roles";

export interface Profile {
    readonly id: string;
    readonly account: { readonly id: string };
    username: string;
    avatar: string;
    bannerArt?: string;
    bio?: string;
    tagline?: string;
    links: string[];
    readonly presence: Presence;
    followers: number;
    following: number;
    readonly roles: Roles[];
    readonly createdAt: Date;
    readonly updatedAt: Date;
}
