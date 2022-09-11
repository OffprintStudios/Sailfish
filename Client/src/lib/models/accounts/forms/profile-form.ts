import type { Presence } from "../presence";

export interface ProfileForm {
	readonly username: string;
	readonly presence: Presence;
	readonly bio?: string;
	readonly tagline?: string;
}
