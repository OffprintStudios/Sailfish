import type { MuteDuration, BanDuration } from "$lib/models/admin/users/durations";

export interface ActionForm {
	readonly accountId: string;
	readonly reason: string;
	readonly duration?: MuteDuration | BanDuration;
}
