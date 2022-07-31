import type { Pronouns } from '../pronouns';
import type { Presence } from "../presence";

export interface ProfileForm {
	readonly username: string;
	readonly pronouns: Pronouns[];
	readonly presence: Presence;
	readonly bio?: string;
	readonly tagline?: string;
}
