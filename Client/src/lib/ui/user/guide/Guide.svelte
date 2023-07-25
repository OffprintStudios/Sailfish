<script lang="ts">
	import { Avatar, Button } from "$lib/ui/util";
	import { account } from "$lib/state/account.state";
	import { ArrowLeftRightLine } from "svelte-remixicon";
	import { guide, toggle } from "./guide.state";
	import { computePosition, flip, offset, shift } from "@floating-ui/dom";
	import { fly, fade, crossfade } from "svelte/transition";
	import { flip as flipAnim } from "svelte/animate";
	import { navigating } from "$app/stores";
	import { clickOutside } from "$lib/util/functions";

	const [send, receive] = crossfade({});
	let button: HTMLButtonElement;
	let dropdown: HTMLDivElement;

	$: {
		if (button) {
			computePosition(button, dropdown, {
				placement: "bottom-end",
				middleware: [offset({ mainAxis: 16 }), flip(), shift()]
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
	<Button on:click={toggle} bind:thisButton={button} isActive={$guide.open} kind="primary">
		{#if $account.account && $account.currProfile}
			<Avatar src={$account.currProfile.avatar} size="36px" borderWidth="1px" />
		{:else if $account.account}
			<ArrowLeftRightLine class="button-icon no-text -rotate-45" size="22px" />
		{/if}
	</Button>
	{#if $guide.open}
		<div
			class="guide-dropdown bg-zinc-200 dark:bg-zinc-700"
			transition:fly={{ delay: 0, duration: 150, x: 200 }}
			bind:this={dropdown}
			use:clickOutside
			on:outclick={toggle}
		>
			{#key $guide.routing[$guide.routing.length - 1]}
				<div transition:fade={{ delay: 0, duration: 150, x: 200 }}>
					<svelte:component this={$guide.routing[$guide.routing.length - 1]} />
				</div>
			{/key}
		</div>
	{/if}
</div>
