<script lang="ts">
	import { ThemePref } from "$lib/util/constants";
	import { app, setTheme } from "$lib/state/app.state";
	import { popPanel } from "$lib/ui/user/guide/guide.state";
	import { Button } from "$lib/ui/util";
	import { ArrowLeftSLine, SunFill, SunLine, MoonFill, MoonLine } from "svelte-remixicon";

	const themes = Object.entries(ThemePref).map(([key, value]) => ({ value: value, label: key }));
	let currTheme = themes.filter((theme) => {
		return theme.value === $app.theme;
	})[0];

	function toggleBrightness(value: string | null) {
		if (value === "dark") {
			$app.brightness = "dark";
			document.documentElement.classList.add("dark");
		} else {
			$app.brightness = null;
			document.documentElement.classList.remove("dark");
		}
	}
</script>

<div class="guide-nav bg-zinc-200 dark:bg-zinc-700">
	<Button on:click={popPanel}>
		<ArrowLeftSLine class="button-icon" />
		<span class="button-text">Settings</span>
	</Button>
</div>
<h5 class="guide-section-header">Color</h5>
<div class="guide-section p-2.5 bg-zinc-300 dark:bg-zinc-600" style="margin-top: 0.125rem;">
	<select
		class="w-full rounded-lg border-transparent bg-zinc-400 dark:bg-zinc-500 focus:ring-0"
		on:change={(event) => setTheme(ThemePref[event.target.value])}
	>
		{#each themes as theme}
			{#if currTheme.value === theme.value}
				<option value={theme.label} selected>{theme.label}</option>
			{:else}
				<option value={theme.label}>{theme.label}</option>
			{/if}
		{/each}
	</select>
</div>
<h5 class="guide-section-header">Dark Mode</h5>
<div class="guide-section p-2.5 bg-zinc-300 dark:bg-zinc-600" style="margin-top: 0.125rem;">
	<div class="flex items-center justify-center">
		<button
			class="mode-toggle"
			class:active={$app.brightness === null}
			on:click={() => toggleBrightness(null)}
		>
			{#if $app.brightness === null}
				<SunFill size="24px" />
			{:else}
				<SunLine size="24px" />
			{/if}
			<span>Lights On</span>
		</button>
		<button
			class="mode-toggle"
			class:active={$app.brightness === "dark"}
			on:click={() => toggleBrightness("dark")}
		>
			{#if $app.brightness === "dark"}
				<MoonFill size="24px" />
			{:else}
				<MoonLine size="24px" />
			{/if}
			<span>Lights Off</span>
		</button>
	</div>
</div>

<style lang="scss">
	button.mode-toggle {
		@apply flex flex-col items-center justify-center pt-0.5 border-2 border-zinc-400 dark:border-white rounded-lg mx-2 w-[80px] h-[68px];
		span {
			@apply all-small-caps font-bold;
		}
		&.active {
			@apply text-white;
			background: var(--accent);
		}
	}
</style>
