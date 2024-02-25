<script lang="ts">
	import { Avatar, Button } from "$lib/ui/util";
	import { auth } from "$lib/state/auth.state";
	import { RiArrowLeftRightLine } from "svelte-remixicon";
	import { guide, toggle } from "./guide.state";
	import { computePosition, flip, offset, shift } from "@floating-ui/dom";
	import { fade } from "svelte/transition";
	import { navigating } from "$app/stores";
	import { clickOutsideAction } from "svelte-legos";

	export let mode: "normal" | "section" = "normal";
	let button: HTMLButtonElement;
	let dropdown: HTMLDivElement;

	$: {
		if (button) {
			computePosition(button, dropdown, {
				placement: "bottom-end",
				middleware: [offset({ mainAxis: 5 }), flip(), shift()]
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

		if ($navigating) {
			$guide.open = false;
			$guide.routing = [];
		}
	}
</script>

<div class="relative z-[2]">
	{#if mode === "normal"}
		<Button id="open-guide" title="Open Guide" on:click={toggle} bind:thisButton={button} active={$guide.open} kind="primary">
			{#if $auth.account && $auth.currProfile}
				<Avatar src={$auth.currProfile.avatar} size="36px" borderWidth="1px" />
			{:else if $auth.account}
				<RiArrowLeftRightLine class="button-icon no-text -rotate-45" size="22px" />
			{/if}
		</Button>
	{:else if mode === "section"}
		<button
			class="section-button no-text"
			style="padding: 1.5rem 0.5rem 1.5rem 0.5rem; margin-right: 0;"
			bind:this={button}
			class:active={$guide.open}
			on:click={toggle}
		>
			{#if $auth.account && $auth.currProfile}
				<Avatar src={$auth.currProfile.avatar} size="36px" borderWidth="1px" />
			{:else if $auth.account}
				<RiArrowLeftRightLine class="button-icon no-text -rotate-45" size="22px" />
			{/if}
		</button>
	{/if}
	{#if $guide.open}
		<div
			class="guide-dropdown bg-zinc-200 dark:bg-zinc-700"
			transition:fade={{ delay: 0, duration: 150 }}
			bind:this={dropdown}
			use:clickOutsideAction
			on:clickoutside={toggle}
		>
			{#key $guide.routing[$guide.routing.length - 1]}
				<div transition:fade={{ delay: 0, duration: 150 }}>
					<svelte:component this={$guide.routing[$guide.routing.length - 1]} />
				</div>
			{/key}
		</div>
	{/if}
</div>
