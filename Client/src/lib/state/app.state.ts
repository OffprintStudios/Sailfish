import { browser } from "$app/environment";
import { writable } from "svelte/store";
import { Theme, Brightness, RatingFilter } from "$lib/models/util";

interface AppState {
    theme: Theme;
    brightness: Brightness;
    showNsfw: boolean;
    unblurNsfw: boolean;
    filter: RatingFilter;
}

const defaultAppState: AppState = {
    theme: Theme.Crimson,
    brightness: Brightness.System,
    showNsfw: false,
    unblurNsfw: false,
    filter: RatingFilter.Restricted,
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

export function setTheme(newTheme: Theme): void {
    app.update((state) => {
        const themes = Object.keys(Theme);
        document.body.classList.remove(...themes);
        state.theme = newTheme;
        document.body.classList.add(state.theme);
        const themeColor = document.querySelector("meta[name='theme-color']");
        const accentColor = getComputedStyle(document.body).getPropertyValue("--accent");
        themeColor?.setAttribute("content", `rgba(${accentColor})`);
        return state;
    });
}

export function setMode(newMode: Brightness): void {
    app.update((state) => {
        const modes = Object.keys(Brightness);
        document.body.classList.remove(...modes);
        state.brightness = newMode;
        if (state.brightness !== Brightness.System) {
            document.body.classList.add(state.brightness);
        } else {
            if (document.defaultView!.matchMedia('(prefers-color-scheme: dark)').matches) {
                document.body.classList.add(Brightness.Dark);
            } else {
                document.body.classList.add(Brightness.Light);
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

export function setUnblurNsfw(): void {
    app.update((state) => ({
        ...state,
        unblurNsfw: !state.unblurNsfw,
    }));
}

export function setFilter(enableMature: boolean, enableExplicit: boolean): void {
    app.update((state) => ({
        ...state,
        filter: determineRatingsFilter(enableMature, enableExplicit),
    }));
}

function determineRatingsFilter(enableMature: boolean, enableExplicit: boolean): RatingFilter {
	let filterSetting: RatingFilter = RatingFilter.Restricted;

	if (enableMature === true && enableExplicit === false) {
		filterSetting = RatingFilter.MatureOnly;
	} else if (enableMature === false && enableExplicit === true) {
		filterSetting = RatingFilter.ExplicitOnly;
	} else if (enableMature === true && enableExplicit === true) {
		filterSetting = RatingFilter.Everything;
	} else if (enableMature === false && enableExplicit === false) {
		filterSetting = RatingFilter.Restricted;
	}

	return filterSetting;
}