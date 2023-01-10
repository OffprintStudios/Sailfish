<script lang="ts">
	import type { Shelf } from "../../models/content/library";
	import { abbreviate, pluralize } from "../../util/functions";
	import { BarChart2Line, MoreLine } from "svelte-remixicon";
	import { Time } from "../util";
	import { account } from "../../state/account.state";
	import { Dropdown } from "../dropdown";

	export let shelf: Shelf;
	export let href;
</script>

<div class="shelf-card bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed hover:bg-zinc-300 dark:hover:bg-zinc-600">
	<a
		class="absolute top-0 right-0 left-0 bottom-0 z-[2]"
		{href}
		data-sveltekit-preload-data
	>
		<!--should be empty-->
	</a>
	{#if $account.account && $account.currProfile}
	<div class="absolute top-0 right-0 z-[2]">
		<Dropdown position="bottom-end">
			<svelte:fragment slot="button">
				<MoreLine class="button-icon no-text" />
			</svelte:fragment>
			<svelte:fragment slot="items">
				<slot name="dropdown"></slot>
			</svelte:fragment>
		</Dropdown>
	</div>
	{/if}
	<div class="p-6 pr-3">
		<BarChart2Line size="32px" />
	</div>
	<div class="p-2">
		<h5 class="text-xl text-white">{shelf.name}</h5>
		<div class="flex items-center text-xs text-zinc-400" style="font-family: var(--header-text)">
			<span>{abbreviate(shelf.works)} work{pluralize(shelf.works)}</span>
			<span class="mx-0.5">•</span>
			<span>Updated <Time timestamp={shelf.updatedAt} relative /></span>
		</div>
	</div>
</div>

<style lang="scss">
	div.shelf-card {
		@apply flex items-center rounded-t-xl relative transition border-b-4;
		border-color: var(--accent);
	}
</style>
