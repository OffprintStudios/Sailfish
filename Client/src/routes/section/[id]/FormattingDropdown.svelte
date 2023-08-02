<script lang="ts">
	import {
		computePosition,
		flip,
		offset,
		shift,
		arrow,
		type ShiftOptions
	} from "@floating-ui/dom";
	import { createEventDispatcher } from "svelte";
	import { clickOutside, throttle } from "$lib/util/functions";
	import { navigating } from "$app/stores";
	import {
		PantoneLine,
		FontSize2,
		ArrowLeftSLine,
		ArrowRightSLine,
		FontSize,
		Paragraph
	} from "svelte-remixicon";
	import { fade } from "svelte/transition";
	import { section } from "$lib/state/section.state";
	import { Font, Theme, WidthSettings, ParagraphStyle } from "$lib/util/constants/sections";

	export let open = false;
	export let iconSize = "22px";

	let button: HTMLButtonElement;
	let dropdown: HTMLDivElement;
	let arrowEl: HTMLDivElement;

	function determineState() {
		open = !open;
	}

	const throttled = throttle(determineState, 150);
	const dispatch = createEventDispatcher();

	$: {
		if (button) {
			computePosition(button, dropdown, {
				placement: "bottom",
				middleware: [
					offset({ mainAxis: 8 }),
					flip(),
					shift({ padding: 5 } as ShiftOptions),
					arrow({ element: arrowEl })
				]
			})
				.then(({ x, y, placement, middlewareData }) => {
					Object.assign(dropdown.style, {
						left: `${x}px`,
						top: `${y}px`
					});

					const { x: arrowX, y: arrowY } = middlewareData.arrow;
					const staticSide = {
						top: "bottom",
						right: "left",
						bottom: "top",
						left: "right"
					}[placement.split("-")[0]];
					Object.assign(arrowEl.style, {
						left: arrowX != null ? `${arrowX}px` : "",
						top: arrowY != null ? `${arrowY}px` : "",
						right: "",
						bottom: "",
						[staticSide]: "-7px"
					});
				})
				.catch(() => {
					console.log(`Button not yet assigned!`);
				});
		}

		if ($navigating !== null) {
			open = false;
		}
	}

	function switchFont(value: Font) {
		$section.font = value;
		document
			?.getElementById("section-page")
			?.style.setProperty("--section-font-family", $section.font as string);
		dispatch("change");
	}

	function switchTheme(value: string) {
		$section.theme = Theme[value];
		const sectionPage = document.getElementById("section-page")!;
		const themeColor = document.querySelector("meta[name='theme-color']")!;
		sectionPage.classList.remove(
			Theme.white,
			Theme.paper,
			Theme.slate,
			Theme.dimmed,
			Theme.ink
		);
		sectionPage.classList.add(value);
		const themeColorValue =
			getComputedStyle(sectionPage).getPropertyValue("--section-background");
		themeColor.setAttribute("content", themeColorValue);
	}

	function increaseWidth() {
		const sectionPage = document.getElementById("section-page")!;
		if ($section.width === WidthSettings.Normal) {
			$section.width = WidthSettings.Wide;
			sectionPage.style.setProperty("--section-width", WidthSettings.Wide);
		} else if ($section.width === WidthSettings.Narrow) {
			$section.width = WidthSettings.Normal;
			sectionPage.style.setProperty("--section-width", WidthSettings.Normal);
		}
		dispatch("change");
	}

	function decreaseWidth() {
		const sectionPage = document.getElementById("section-page")!;
		if ($section.width === WidthSettings.Normal) {
			$section.width = WidthSettings.Narrow;
			sectionPage.style.setProperty("--section-width", WidthSettings.Narrow);
		} else if ($section.width === WidthSettings.Wide) {
			$section.width = WidthSettings.Normal;
			sectionPage.style.setProperty("--section-width", WidthSettings.Normal);
		}
		dispatch("change");
	}

	function adjustParagraphs(style: ParagraphStyle) {
		$section.paragraphs = style;
		const sectionPage = document.getElementById("section-page")!;
		switch ($section.paragraphs) {
			case ParagraphStyle.original:
				sectionPage.style.setProperty("--section-paragraph-margins", "1rem 0 1rem 0");
				sectionPage.style.setProperty("--section-paragraph-indent", "0");
				break;
			case ParagraphStyle.indented:
				sectionPage.style.setProperty("--section-paragraph-margins", "0");
				sectionPage.style.setProperty("--section-paragraph-indent", "2.5rem");
				break;
			case ParagraphStyle.doubleSpaced:
				sectionPage.style.setProperty("--section-paragraph-margins", "1rem 0 1rem 0");
				sectionPage.style.setProperty("--section-paragraph-indent", "0");
				break;
			case ParagraphStyle.both:
				sectionPage.style.setProperty("--section-paragraph-margins", "1rem 0 1rem 0");
				sectionPage.style.setProperty("--section-paragraph-indent", "2.5rem");
				break;
		}
		dispatch("change");
	}

	function adjustFontSize(value: number) {
		$section.fontSize = value;
		const sectionPage = document.getElementById("section-page")!;
		let size = 16;
		let lineHeight = 24;
		if (value < 1) {
			size = Math.floor(size * value + 2);
			lineHeight = Math.floor(lineHeight * value + 2);
		} else if (value > 1) {
			size = Math.floor(size * value - 2);
			lineHeight = Math.floor(lineHeight * value - 2);
		}
		sectionPage.style.setProperty("--section-font-size", `${size}px`);
		sectionPage.style.setProperty("--section-line-height", `${lineHeight}px`);
		dispatch("change");
	}
</script>

<div class="relative z-[2]">
	<button
		class="section-button no-text"
		class:active={open}
		title="Themes & Formatting"
		bind:this={button}
		on:click={throttled}
	>
		<PantoneLine size={iconSize} />
	</button>
	{#if open}
		<div
			class="section-dropdown"
			transition:fade|local={{ delay: 0, duration: 100 }}
			bind:this={dropdown}
			use:clickOutside
			on:outclick={throttled}
		>
			<div class="arrow" bind:this={arrowEl}><!--arrow--></div>
			<div class="lg:flex items-center justify-center my-2 hidden" title="Adjust Page Width">
				<button
					class="section-button"
					style="color: var(--section-text-color);"
					on:click={decreaseWidth}
				>
					<ArrowLeftSLine size="24px" />
				</button>
				<span
					class="text-base text-center relative mx-2 top-0.5 font-bold uppercase w-[75px]"
					style="font-family: var(--header-text); color: var(--section-text-color);"
				>
					{#if $section.width === WidthSettings.Narrow}
						Narrow
					{:else if $section.width === WidthSettings.Normal}
						Normal
					{:else if $section.width === WidthSettings.Wide}
						Wide
					{/if}
				</span>
				<button
					class="section-button"
					style="color: var(--section-text-color);"
					on:click={increaseWidth}
				>
					<ArrowRightSLine size="24px" />
				</button>
			</div>
			<div class="flex items-center justify-center mt-2 mb-4">
				<div
					class="theme-circle"
					title="White"
					on:click={() => switchTheme(Theme.white)}
					style="background: rgb(255, 255, 255);"
				>
					<!--spacer-->
				</div>
				<div
					class="theme-circle"
					title="Paper"
					on:click={() => switchTheme(Theme.paper)}
					style="background: rgb(247, 241, 228);"
				>
					<!--spacer-->
				</div>
				<div
					class="theme-circle"
					title="Slate"
					on:click={() => switchTheme(Theme.slate)}
					style="background: rgb(72, 72, 74);"
				>
					<!--spacer-->
				</div>
				<div
					class="theme-circle"
					title="Dimmed"
					on:click={() => switchTheme(Theme.dimmed)}
					style="background: rgb(44, 44, 46);"
				>
					<!--spacer-->
				</div>
				<div
					class="theme-circle"
					title="Ink"
					on:click={() => switchTheme(Theme.ink)}
					style="background: rgb(0, 0, 0);"
				>
					<!--spacer-->
				</div>
			</div>
			<div class="flex items-center mb-4" title="Change Font">
				<FontSize size="28px" class="ml-2 mr-4" />
				<select
					class="flex-1 rounded-lg focus:ring-0 border-0"
					style="background: var(--section-select-bg); color: var(--section-text-color);"
					on:change={(e) => switchFont(e.target.value)}
					value={$section.font}
				>
					<option value={Font.inter}> Inter </option>
					<option value={Font.libreBaskerville}> Libre Baskerville </option>
					<option value={Font.josefinSlab}> Josefin Slab </option>
					<option value={Font.ibmPlexMono}> Plex Mono </option>
				</select>
			</div>
			<div
				class="flex items-center"
				style="font-family: var(--header-text);"
				title="Change Font Size"
			>
				<FontSize2 size="28px" class="ml-2 mr-4" />
				<div class="w-full ml-1">
					<input
						id="font-size"
						class="w-full"
						type="range"
						min="0.8"
						max="1.8"
						step="0.2"
						list="size-list"
						bind:value={$section.fontSize}
						on:change={(e) => adjustFontSize(e.target.value)}
					/>
					<datalist id="size-list" class="flex items-center justify-between w-full">
						<option value="0.8" label="0.8">0.8</option>
						<option value="1.0" label="1.0">1.0</option>
						<option value="1.2" label="1.2">1.2</option>
						<option value="1.4" label="1.4">1.4</option>
						<option value="1.6" label="1.6">1.6</option>
						<option value="1.8" label="1.8">1.8</option>
					</datalist>
				</div>
			</div>
			<div class="my-2"><!--spacer--></div>
			<div class="flex items-center" title="Adjust Paragraph Style">
				<Paragraph size="28px" class="ml-2 mr-4" />
				<select
					class="flex-1 rounded-lg focus:ring-0 border-0"
					style="background: var(--section-select-bg); color: var(--section-text-color);"
					on:change={(e) => adjustParagraphs(e.target.value)}
					value={$section.paragraphs}
				>
					<option value={ParagraphStyle.original}> Original </option>
					<option value={ParagraphStyle.indented}> Indented </option>
					<option value={ParagraphStyle.doubleSpaced}> Double-Spaced </option>
					<option value={ParagraphStyle.both}> Both </option>
				</select>
			</div>
		</div>
	{/if}
</div>

<style lang="scss">
	div.theme-circle {
		@apply w-[40px] h-[40px] rounded-full border-2 mx-1 first:ml-0 last:mr-0 cursor-pointer;
		box-shadow: var(--dropshadow);
		border-color: var(--section-tool-color);
	}
	div.arrow {
		@apply absolute w-[12px] h-[12px] transform rotate-45 border-t border-l;
		background: var(--section-background);
		border-color: var(--section-tool-color);
	}
</style>
