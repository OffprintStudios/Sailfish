import type { ThreadBlacklist } from "./thread-blacklist";

export interface Thread {
	readonly id: string;
	readonly createdBy?: { id: string };
	open: boolean;
	blacklist: ThreadBlacklist[];
	readonly createdAt: Date;
	readonly updatedAt: Date;
}
