import { writable } from "svelte/store";
import type { ComponentType } from "svelte";
import { throttle } from "$lib/util/functions";
import { AccountPanel } from "./panels";

interface GuideState {
    open: boolean;
    routing: ComponentType[];
}

export const guide = writable<GuideState>({
    open: false,
    routing: [],
});

function switchState() {
    guide.update((state) => {
        state.open = !state.open;
        state.routing = state.routing.length < 1 ? [AccountPanel] : [];
        return state;
    });
}

export const toggle = throttle(switchState, 150);

export function pushPanel(component: ComponentType) {
    guide.update((state) => {
        if (state.open) {
            state.routing = [...state.routing, component];
        }
        return state;
    });
}

export function popPanel() {
    guide.update((state) => {
        if (state.routing.length > 0) {
            state.routing.pop();
            //eslint-disable-next-line no-self-assign
            state.routing = state.routing;
        } else {
            state.open = false;
            state.routing = [];
        }
        return state;
    });
}
