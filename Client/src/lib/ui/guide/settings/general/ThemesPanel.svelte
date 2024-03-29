<script lang="ts">
	import { ArrowLeftSLine, MoonFill, MoonLine, SunFill, SunLine } from "svelte-remixicon";
	import { Button } from "$lib/ui/util";
	import { prevPage } from "../../guide.state";
	import { app, setTheme } from "$lib/state/app.state";
	import { ThemePref } from "$lib/util/constants";

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

<div class="panel-container">
	<div class="topbar">
		<div class="left-button">
			<Button on:click={prevPage}>
				<ArrowLeftSLine class="button-icon" />
				<span class="button-text">Settings</span>
			</Button>
		</div>
	</div>
	<div class="content-container">
		<div class="panel-section">
			<h3>Color</h3>
			<div class="panel-box">
				<select
					class="w-full rounded-lg border-transparent bg-zinc-300 dark:bg-zinc-600 focus:ring-0"
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
		</div>
		<div class="panel-section">
			<h3>Dark Mode</h3>
			<div class="panel-box">
				<div class="flex items-center">
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
		</div>
	</div>
</div>

<style lang="scss">
	@use "../../Guide";

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
