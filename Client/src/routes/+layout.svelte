<script lang="ts">
	import "../app.scss";
	import { Nav } from "$lib/ui/nav";
	import { app } from "$lib/state/app.state";
	import { Guide } from "$lib/ui/guide";
	import { Toaster } from "svelte-french-toast";
	import { account } from "$lib/state/account.state";
	import { Popup } from "$lib/ui/popup";
	import { activity } from "$lib/state/activity.state";
	import { afterNavigate } from "$app/navigation";

	export let data: { hasKey: boolean } = { hasKey: false };
	let containerTop;

	if (!data.hasKey) {
		$account.account = null;
		$account.currProfile = null;
		$account.profiles = [];
		$account.token = null;
		$activity.count = 0;
		$activity.markAsRead = [];
	}

	afterNavigate(() => {
		containerTop.scrollIntoView({ behavior: "smooth" });
	});
</script>

<Popup />
<main
	class="flex flex-col min-h-[100vh] h-full overflow-y-scroll lg:overflow-y-hidden lg:flex-row lg:h-screen {$app.theme}"
	class:light={$app.darkMode === false}
	class:dark={$app.darkMode === true}
>
	<Nav />
	<Guide>
		<div bind:this={containerTop}><!--intentionally left blank--></div>
		<slot />
	</Guide>
	<Toaster />
</main>

<style lang="scss">
	:global(main) {
		color: var(--text-color);
		font-family: var(--body-text);
		background: var(--background);
		@apply transition transform relative;
	}
</style>
