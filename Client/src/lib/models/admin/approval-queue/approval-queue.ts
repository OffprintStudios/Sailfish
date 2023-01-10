import type {Work} from "$lib/models/content/works";
import type {Profile} from "$lib/models/accounts";
import type {Status} from "./status";

export interface ApprovalQueue {
    readonly id: string;
    readonly work: Work;
    readonly claimedBy: Profile;
    readonly status: Status;
    readonly reason?: string;
    readonly attempts: number;
    readonly createdAt: Date;
    readonly updatedAt: Date;
}