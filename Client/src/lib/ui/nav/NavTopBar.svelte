<script lang="ts">
	import {
		LoginCircleLine,
		UserSharedLine,
		UserAddLine,
		Settings5Line,
		CloseLine
	} from "svelte-remixicon";
	import SearchDropdown from "$lib/ui/nav/SearchDropdown.svelte";
	import { navigating } from "$app/stores";
	import { closeGuide, openGuide, guide } from "$lib/ui/guide";
	import Button from "$lib/ui/util/Button.svelte";

	$: {
		if ($navigating !== null) {
			closeGuide();
		}
	}
</script>

<div
	class="flex items-center text-white w-full px-4 h-[60px] sticky z-[50]"
	style="background: var(--accent); box-shadow: var(--dropshadow);"
>
	<div class="w-1/3 flex items-center">
		<h3 class="text-white text-3xl tracking-wide mr-2">Offprint</h3>
		<div
			class="hidden lg:block text-white font-bold tracking-widest border-2 border-white mb-1 pl-1.5 pr-1 py-1"
		>
			BETA
		</div>
	</div>
	<div class="w-1/3 relative">
		<SearchDropdown />
	</div>
	<div class="w-1/3 flex items-center flex-row-reverse">
		{#if $guide.open}
			<Button kind="primary" on:click={closeGuide}>
				<CloseLine class="button-icon no-text" size="26px" />
			</Button>
		{:else}
			<Button kind="primary" on:click={openGuide}>
				<UserSharedLine class="button-icon no-text" size="26px" />
			</Button>
		{/if}
	</div>
</div>

<style lang="scss">
	button.search-button {
		@apply w-9/12 mx-auto flex items-center justify-center py-2 border-b-2 border-white text-sm rounded-md z-10 transition transform;
		background: var(--accent-light);
		box-shadow: var(--dropshadow);
		&:hover {
			@apply scale-[1.025];
		}
	}
	a.dropdown-link {
		@apply flex items-center;
		&:hover {
			background: var(--accent) !important;
		}
	}
</style>
