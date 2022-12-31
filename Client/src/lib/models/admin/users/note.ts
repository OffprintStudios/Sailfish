import type { Profile } from "$lib/models/accounts";

export interface Note {
	readonly id: string;
	readonly addedBy: Profile;
	readonly account: { readonly id: string };
	readonly message: string;
	readonly createdAt: Date;
	readonly updatedAt: Date;
	readonly deletedAt: Date;
}
