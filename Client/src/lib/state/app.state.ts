import { browser } from "$app/environment";
import { writable } from "svelte/store";
import { CardSize, ContentFilter, ThemePref } from "$lib/util/constants";
import { SectionFont } from "../models/util";

interface AppState {
	isOfAge: boolean;
	filter: ContentFilter;
	theme: ThemePref;
	brightness: string | null;
	cardSize: CardSize;
	sectionFont: SectionFont;
}

const defaultAppState: AppState = {
	isOfAge: false,
	filter: ContentFilter.restricted,
	theme: ThemePref.Crimson,
	brightness: null,
	cardSize: CardSize.Medium,
	sectionFont: SectionFont.inter
};

const initialAppState: AppState = browser
	? JSON.parse(window.localStorage.getItem("app") ?? "null") ?? defaultAppState
	: defaultAppState;

export const app = writable<AppState>(initialAppState);

app.subscribe((value) => {
	if (browser) {
		window.localStorage.setItem("app", JSON.stringify(value));
	}
});

export function setTheme(theme: ThemePref): void {
	app.update((state) => {
		const oldTheme = state.theme;
		state.theme = theme;
		const hasNewTheme = document.documentElement.classList.replace(oldTheme, state.theme);
		if (hasNewTheme) {
			const themeColor = document.querySelector("meta[name='theme-color']");
			const accentColor = getComputedStyle(document.documentElement).getPropertyValue(
				"--accent"
			);
			themeColor?.setAttribute("content", accentColor);
		}
		return state;
	});
}

export function setCardSize(size: CardSize): void {
	app.update((state) => ({
		...state,
		cardSize: size
	}));
}

export function setDarkMode(isDark: boolean): void {
	app.update((state) => ({
		...state,
		darkMode: isDark
	}));
}

export function setOfAge(): void {
	app.update((state) => ({
		...state,
		isOfAge: !state.isOfAge
	}));
}

export function setFilter(enableMature: boolean, enableExplicit: boolean): void {
	app.update((state) => ({
		...state,
		filter: determineContentFilter(enableMature, enableExplicit)
	}));
}

function determineContentFilter(enableMature: boolean, enableExplicit: boolean): ContentFilter {
	let filterSetting: ContentFilter = ContentFilter.restricted;

	if (enableMature === true && enableExplicit === false) {
		filterSetting = ContentFilter.mature;
	} else if (enableMature === false && enableExplicit === true) {
		filterSetting = ContentFilter.explicit;
	} else if (enableMature === true && enableExplicit === true) {
		filterSetting = ContentFilter.everything;
	} else if (enableMature === false && enableExplicit === false) {
		filterSetting = ContentFilter.restricted;
	}

	return filterSetting;
}
