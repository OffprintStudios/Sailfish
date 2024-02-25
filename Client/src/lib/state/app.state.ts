import { browser } from "$app/environment";
import { ModeSwitch, RatingsFilter, Themes } from "$lib/models/util";
import { writable } from "svelte/store";

interface AppState {
    theme: Themes;
    mode: ModeSwitch;
    showNsfw: boolean;
    filter: RatingsFilter;
}

const defaultAppState: AppState = {
    theme: Themes.crimson,
    mode: ModeSwitch.system,
    showNsfw: false,
    filter: RatingsFilter.restricted,
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

export function setTheme(newTheme: Themes): void {
    app.update((state) => {
        const themes = Object.keys(Themes);
        document.body.classList.remove(...themes);
        state.theme = newTheme;
        document.body.classList.add(state.theme);
        const themeColor = document.querySelector("meta[name='theme-color']");
        const accentColor = getComputedStyle(document.body).getPropertyValue("--accent");
        themeColor?.setAttribute("content", `rgba(${accentColor})`);
        return state;
    });
}

export function setMode(newMode: ModeSwitch): void {
    app.update((state) => {
        const modes = Object.keys(ModeSwitch);
        document.body.classList.remove(...modes);
        state.mode = newMode;
        if (state.mode !== ModeSwitch.system) {
            document.body.classList.add(state.mode);
        } else {
            if (document.defaultView!.matchMedia('(prefers-color-scheme: dark)').matches) {
                document.body.classList.add(ModeSwitch.dark);
            } else {
                document.body.classList.add(ModeSwitch.light);
            }
        }
        return state;
    });
}

export function setShowNsfw(): void {
    app.update((state) => ({
        ...state,
        showNsfw: !state.showNsfw,
    }));
}

export function setFilter(enableMature: boolean, enableExplicit: boolean): void {
    app.update((state) => ({
        ...state,
        filter: determineRatingsFilter(enableMature, enableExplicit),
    }));
}

function determineRatingsFilter(enableMature: boolean, enableExplicit: boolean): RatingsFilter {
	let filterSetting: RatingsFilter = RatingsFilter.restricted;

	if (enableMature === true && enableExplicit === false) {
		filterSetting = RatingsFilter.mature;
	} else if (enableMature === false && enableExplicit === true) {
		filterSetting = RatingsFilter.explicit;
	} else if (enableMature === true && enableExplicit === true) {
		filterSetting = RatingsFilter.everything;
	} else if (enableMature === false && enableExplicit === false) {
		filterSetting = RatingsFilter.restricted;
	}

	return filterSetting;
}
