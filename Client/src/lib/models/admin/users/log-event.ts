import type { Profile } from "$lib/models/accounts";

export interface LogEvent {
	readonly id: string;
	readonly account: { readonly id: string };
	readonly event: {
		readonly type: string;
		readonly detail: string;
	};
	readonly action: {
		readonly taken?: string;
		readonly by?: Profile;
		readonly reason?: string;
		readonly duration?: Date;
	};
	readonly createdAt: Date;
}
