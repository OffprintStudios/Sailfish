import { writable } from 'svelte/store';
import type { SvelteComponent } from 'svelte';

interface ModalState {
	open: boolean;
	routing: SvelteComponent[];
	currPage: number;
}

export const modal = writable<ModalState>({
	open: false,
	routing: [],
	currPage: 0,
});

export function openModal(component: SvelteComponent) {
	modal.update(() => ({
		open: true,
		routing: [component],
		currPage: 0,
	}));
}

export function nextPage(component: SvelteComponent) {
	modal.update((state) => {
		const newIndex = state.routing.push(component);
		state.currPage = newIndex - 1;
		return state;
	});
}

export function prevPage() {
	modal.update((state) => {
		state.routing.pop();
		state.currPage = state.routing.length - 1;
		return state;
	});
}

export function closeModal() {
	modal.update(() => ({
		open: false,
		routing: [],
		currPage: 0,
	}));
}