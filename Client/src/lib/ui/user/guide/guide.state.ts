import { writable } from "svelte/store";
import type { SvelteComponent } from "svelte";
import { AccountPanel } from "./panels";
import { throttle } from "$lib/util/functions";
import { navigating } from "$app/stores";

interface GuideState {
	open: boolean;
	routing: (typeof SvelteComponent)[];
}

export const guide = writable<GuideState>({
	open: false,
	routing: []
});

function switchState() {
	guide.update((state) => {
		state.open = !state.open;
		state.routing = state.routing.length < 1 ? [AccountPanel] : [];
		return state;
	});
}

export const toggle = throttle(switchState, 150);

export function pushPanel(component: typeof SvelteComponent) {
	guide.update((state) => {
		state.routing = [...state.routing, component];
		return state;
	});
}

export function popPanel() {
	guide.update((state) => {
		if (state.routing.length > 0) {
			state.routing.pop();
			// eslint-disable-next-line no-self-assign
			state.routing = state.routing;
		} else {
			state.open = false;
			state.routing = [];
		}
		return state;
	});
}
