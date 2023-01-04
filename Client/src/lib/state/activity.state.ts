import { writable } from "svelte/store";

interface ActivityState {
	count: number;
}

export const activity = writable<ActivityState>({ count: 0 });
