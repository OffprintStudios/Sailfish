<script lang="ts">
    import { RiArrowLeftSLine, RiCheckLine, RiComputerFill, RiComputerLine, RiMoonFill, RiMoonLine, RiSunFill, RiSunLine } from "svelte-remixicon";
    import { Button } from "$lib/ui/util";
    import { popPanel } from "$lib/ui/nav/guide/guide.state";
    import { app, setMode, setTheme } from "$lib/state/app.state";
    import { ModeSwitch, Themes } from "$lib/models/util";
	import { capitalize } from "$lib/util/functions";

    const themes = Object.keys(Themes);

    function setStringTheme(theme: string) {
        const newTheme = Themes[theme as keyof typeof Themes];
        setTheme(newTheme);
    }
</script>

<div class="guide-nav bg-zinc-200 dark:bg-zinc-700">
	<Button id="back-button" title="Go Back" on:click={popPanel}>
        <span class="button-icon"><RiArrowLeftSLine /></span>
		<span class="button-text">Settings</span>
	</Button>
</div>
<h5 class="guide-section-header">Color</h5>
<div class="guide-section px-2.5 pt-2.5 pb-4 bg-zinc-300 dark:bg-zinc-600" style="margin-top: 0.125rem;">
	<h3 class="all-small-caps mb-4 text-xl text-center" style="color: var(--text-color)">
        {$app.theme}
    </h3>
    <div class="flex items-center justify-center">
        {#each themes as theme}
            <div class="mx-1 {theme}" title="{capitalize(theme)}">
                <button
                    class="flex items-center justify-center h-12 w-12 rounded-full border"
                    style="background-color: rgb(var(--accent))"
                    on:click={() => setStringTheme(theme)}
                >
                    {#if $app.theme === theme}
                        <span class="relative top-[0.075rem] text-white">
                            <RiCheckLine size="20px" />
                        </span>
                    {/if}
                </button>
            </div>
        {/each}
    </div>
</div>
<h5 class="guide-section-header">Dark Mode</h5>
<div class="guide-section p-2.5 bg-zinc-300 dark:bg-zinc-600" style="margin-top: 0.125rem;">
	<div class="flex items-center justify-center">
		<button
            class="mode-toggle"
            class:active={$app.mode === ModeSwitch.system}
            on:click={() => setMode(ModeSwitch.system)}
        >
            {#if $app.mode === ModeSwitch.system}
                <RiComputerFill size="24px" />
            {:else}
                <RiComputerLine size="24px" />
            {/if}
            <span>System</span>
        </button>
        <button
            class="mode-toggle"
            class:active={$app.mode === ModeSwitch.light}
            on:click={() => setMode(ModeSwitch.light)}
        >
            {#if $app.mode === ModeSwitch.light}
                <RiSunFill size="24px" />
            {:else}
                <RiSunLine size="24px" />
            {/if}
            <span>Lights On</span>
        </button>
        <button
            class="mode-toggle"
            class:active={$app.mode === ModeSwitch.dark}
            on:click={() => setMode(ModeSwitch.dark)}
        >
            {#if $app.mode === ModeSwitch.dark}
                <RiMoonFill size="24px" />
            {:else}
                <RiMoonLine size="24px" />
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
			background: rgb(var(--accent));
		}
	}
</style>
