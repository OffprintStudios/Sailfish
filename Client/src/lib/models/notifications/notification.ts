import type { Profile } from "$lib/models/accounts";
import type { EventType } from "./event-type";

export interface Notification {
	readonly id: string;
	readonly to: Profile;
	readonly from?: Profile;
	readonly eventType: EventType;
	readonly entityId?: string;
	readonly context: Map<string, string>;
	readonly readOn?: Date;
	readonly createdAt: Date;
	readonly updatedAt: Date;
}
