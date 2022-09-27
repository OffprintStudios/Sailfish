import { get, writable } from "svelte/store";
import type { SvelteComponent } from "svelte";

interface PopupState {
	isOpen: boolean;
	component: SvelteComponent | null;
	onConfirm: PopupOnConfirm | null;
	data: any;
}

interface PopupOnConfirm {
	onConfirm(): void;
}

export const popup = writable<PopupState>({
	isOpen: false,
	component: null,
	onConfirm: null,
	data: null,
});

export function openPopup(component: SvelteComponent, onConfirm: PopupOnConfirm | null = null, data: any = null): void {
	popup.update((state) => ({
		...state,
		isOpen: true,
		component,
		onConfirm,
		data,
	}));
}

export function closePopup(): void {
	popup.update((state) => ({
		...state,
		isOpen: false,
		component: null,
	}));
}

export function closePopupAndConfirm(): void {
	closePopup();
	if (get(popup).onConfirm) {
		get(popup).onConfirm?.onConfirm();
	}
}

export function togglePopup(component: SvelteComponent): void {
	popup.update((state) => ({
		...state,
		isOpen: !state.isOpen,
		component: state.isOpen ? null : component,
	}));
}

export function getData(): any {
	if (get(popup).data) {
		return get(popup).data;
	}
	return null;
}
