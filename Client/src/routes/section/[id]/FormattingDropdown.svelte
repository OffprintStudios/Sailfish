<script lang="ts">
	import { computePosition, flip, offset, shift, type ShiftOptions } from "@floating-ui/dom";
	import { clickOutside, throttle } from "$lib/util/functions";
	import { navigating } from "$app/stores";
	import { PantoneLine } from "svelte-remixicon";
	import { fade } from "svelte/transition";
	import { section } from "$lib/state/section.state";
	import { Font, Theme } from "$lib/util/constants/sections";

	export let open = false;
	export let iconSize = "22px";

	let button: HTMLButtonElement;
	let dropdown: HTMLDivElement;

	function determineState() {
		open = !open;
	}

	const throttled = throttle(determineState, 150);

	$: {
		if (button) {
			computePosition(button, dropdown, {
				placement: "bottom",
				middleware: [offset({ mainAxis: 8 }), flip(), shift({ padding: 5 } as ShiftOptions)]
			})
				.then(({ x, y }) => {
					Object.assign(dropdown.style, {
						left: `${x}px`,
						top: `${y}px`
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
		console.log($section.font as string);
		document
			.getElementById("section-page")
			.style.setProperty("--section-font-family", $section.font as string);
	}

	function switchTheme(value: string) {
		$section.theme = Theme[value];
		const sectionPage = document.getElementById("section-page");
		const themeColor = document.querySelector("meta[name='theme-color']");
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
			<select
				class="w-full rounded-lg focus:ring-0 border-0"
				style="background: var(--section-select-bg); color: var(--section-text-color);"
				on:change={(e) => switchFont(e.target.value)}
				value={$section.font}
			>
				<option value={Font.inter} style="font-family: 'Inter', sans-serif;">
					Inter
				</option>
				<option
					value={Font.libreBaskerville}
					style="font-family: 'Libre Baskerville', serif;"
				>
					Libre Baskerville
				</option>
				<option value={Font.josefinSlab} style="font-family: 'Josefin Slab', serif;">
					Josefin Slab
				</option>
				<option value={Font.ibmPlexMono} style="font-family: 'IBM Plex Mono', sans-serif;">
					Plex Mono
				</option>
			</select>
			<div class="flex items-center justify-center my-2">
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
		</div>
	{/if}
</div>

<style lang="scss">
	div.theme-circle {
		@apply w-[40px] h-[40px] rounded-full border-2 mx-1 first:ml-0 last:mr-0 cursor-pointer;
		box-shadow: var(--dropshadow);
		border-color: var(--section-tool-color);
	}
</style>
