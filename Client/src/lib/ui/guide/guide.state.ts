import { writable } from "svelte/store";
import type { SvelteComponentTyped } from "svelte";
import { AccountPanel } from "./account";

interface GuideState {
	open: boolean;
	canClose: boolean;
	routing: SvelteComponentTyped[];
	currPage: number;
	data: never | null;
}

export const guide = writable<GuideState>({
	open: false,
	canClose: true,
	routing: [],
	currPage: 0,
	data: null
});

export function openGuide(panel: SvelteComponentTyped): void {
	guide.update((state) => ({
		...state,
		open: true,
		canClose: true,
		routing: [panel],
		currPage: 0,
		data: null
	}));
}

export function closeGuide(): void {
	guide.update((state) => ({
		...state,
		open: false,
		canClose: true,
		mainPage: null,
		routing: [],
		currTab: null,
		currPage: 0,
		data: null
	}));
}

export function nextPage(component: SvelteComponentTyped): void {
	guide.update((state) => {
		const newLength = state.routing.push(component);
		state.currPage = newLength - 1;
		return state;
	});
}

export function switchTab(component: SvelteComponentTyped): void {
	guide.update((state) => {
		state.routing = [component];
		state.currPage = 0;
		return state;
	});
}

export function prevPage(): void {
	guide.update((state) => {
		state.routing.pop();
		state.currPage = state.routing.length - 1;
		if (state.routing.length === 1) {
			state.canClose = true;
		}
		return state;
	});
}
