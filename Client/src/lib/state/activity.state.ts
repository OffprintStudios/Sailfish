import { writable } from "svelte/store";

interface ActivityState {
	count: number;
	markAsRead: string[];
}

export const activity = writable<ActivityState>({ count: 0, markAsRead: [] });
