import type { Thread } from "./thread";
import type { Paginate } from "$lib/util/types";

export interface ThreadPage {
	readonly thread: Thread;
	readonly page: Paginate<Comment>;
}