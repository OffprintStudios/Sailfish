import { writable } from "svelte/store";
import { Font, Justification, ParagraphStyle, Theme } from "$lib/util/constants/sections";
import { browser } from "$app/environment";

interface SectionState {
	font: Font;
	theme: Theme;
	paragraphs: ParagraphStyle;
	justification: Justification;
	fontSize: number;
	width: number;
	lineHeight: number;
}

const defaultSectionState: SectionState = {
	font: Font.inter,
	theme: Theme.paper,
	paragraphs: ParagraphStyle.original,
	justification: Justification.original,
	fontSize: 1,
	width: 1,
	lineHeight: 1
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
