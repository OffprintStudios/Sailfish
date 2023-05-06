<script lang="ts">
	import { LoginCircleLine, SearchEyeLine, More2Fill, UserLine } from "svelte-remixicon";
	import Button from "$lib/ui/util/Button.svelte";

	const searchSlogans = [
		"Need help finding anything?",
		"What are you looking for today?",
		"Let's find something you'll love.",
		"Need a hand?",
		"Offprint's got you covered.",
		"Only the best for a connoisseur like you."
	];
	const currSlogan = searchSlogans[Math.floor(Math.random() * searchSlogans.length)];
</script>

<div
	class="flex items-center text-white w-full px-4 h-[60px] sticky z-[50]"
	style="background: var(--accent); box-shadow: var(--dropshadow);"
>
	<div class="w-1/3 flex items-center">placeholder</div>
	<div class="w-1/3 relative">
		<button class="search-button">
			<SearchEyeLine size="20px" class="mr-2" />
			<span>{currSlogan}</span>
		</button>
	</div>
	<div class="w-1/3 flex items-center flex-row-reverse">
		<Button kind="primary">
			<UserLine class="button-icon no-text" size="20px" />
		</Button>
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
</style>
