import { writable } from "svelte/store";
import { Font, ParagraphStyle, Theme, WidthSettings } from "$lib/util/constants/sections";
import { browser } from "$app/environment";

interface SectionState {
	font: Font;
	theme: Theme;
	paragraphs: ParagraphStyle;
	fontSize: number;
	width: WidthSettings;
}

const defaultSectionState: SectionState = {
	font: Font.inter,
	theme: Theme.paper,
	paragraphs: ParagraphStyle.original,
	fontSize: 1,
	width: WidthSettings.Normal
};

const initialSectionState: SectionState = browser
	? JSON.parse(window.localStorage.getItem("section") ?? "null") ?? defaultSectionState
	: defaultSectionState;

export const section = writable<SectionState>(initialSectionState);

section.subscribe((value) => {
	if (browser) {
		window.localStorage.setItem("section", JSON.stringify(value));
	}
});
