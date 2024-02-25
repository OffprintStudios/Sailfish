<script lang="ts">
	import { app, setFilter, setShowNsfw } from "$lib/state/app.state";
    import { RatingsFilter } from "$lib/models/util";
	import { popPanel } from "../../../guide.state";
	import { Button } from "$lib/ui/util";
	import { RiArrowLeftSLine, RiCheckLine } from "svelte-remixicon";
	import { Toggle } from "$lib/ui/forms";

	let enableMature = false;
	let enableExplicit = false;

	if ($app.filter === RatingsFilter.restricted) {
		enableMature = false;
		enableExplicit = false;
	} else if ($app.filter === RatingsFilter.mature) {
		enableMature = true;
		enableExplicit = false;
	} else if ($app.filter === RatingsFilter.explicit) {
		enableMature = false;
		enableExplicit = true;
	} else if ($app.filter === RatingsFilter.everything) {
		enableMature = true;
		enableExplicit = true;
	}
	$: {
        console.log(`Enable Mature: ${enableMature}`);
        console.log(`Enable Explicit: ${enableExplicit}`);
        setFilter(enableMature, enableExplicit);
    }
</script>

<div class="guide-nav bg-zinc-200 dark:bg-zinc-700">
	<Button id="back-button" title="Go Back" on:click={popPanel}>
		<span class="button-icon"><RiArrowLeftSLine /></span>
		<span class="button-text">Settings</span>
	</Button>
</div>
<h5 class="guide-section-header">CONTENT RATINGS</h5>
<div
	class="guide-section p-2.5 items-center justify-center bg-zinc-300 dark:bg-zinc-600"
	style="margin-top: 0.125rem;"
>
	{#if $app.showNsfw}
		<Toggle id="show-mature" bind:value={enableMature}>Show Mature</Toggle>
		<Toggle id="show-explicit" bind:value={enableExplicit}>Show Explicit</Toggle>
	{:else}
		<span
			>Changing this setting may expose you to content not suitable for people under the age
			of 18.</span
		>
		<span class="my-2">Are you sure you want to proceed?</span>
		<Button id="set-show-nsfw" title="Show NSFW" on:click={setShowNsfw}>
			<span class="button-icon"><RiCheckLine /></span>
			<span class="button-text">Show me the money</span>
		</Button>
	{/if}
</div>
