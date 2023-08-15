import type { ActionReturn } from "svelte/action";

interface Attributes {
	'on:outclick': () => void;
}

export function clickOutside(node: HTMLElement): ActionReturn<Attributes> {
	const handleClick = (event: any) => {
		if (!node.contains(event.target)) {
			node.dispatchEvent(new CustomEvent("outclick"));
		}
	};

	document.addEventListener("click", handleClick, true);

	return {
		destroy() {
			document.removeEventListener("click", handleClick, true);
		}
	};
}
