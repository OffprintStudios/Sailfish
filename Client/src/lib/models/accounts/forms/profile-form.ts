import type { Pronouns } from '../pronouns';

export interface ProfileForm {
	readonly username: string;
	readonly pronouns: Pronouns[];
}
