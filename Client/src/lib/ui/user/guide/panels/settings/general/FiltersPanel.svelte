<script lang="ts">
	import { app, setFilter, setOfAge } from "$lib/state/app.state";
	import { ContentFilter } from "$lib/util/constants";
	import { popPanel } from "$lib/ui/user/guide/guide.state";
	import { Button } from "$lib/ui/util";
	import { ArrowLeftSLine, CheckLine } from "svelte-remixicon";
	import { Toggle } from "$lib/ui/forms";

	let enableMature = false;
	let enableExplicit = false;

	if ($app.filter === ContentFilter.restricted) {
		enableMature = false;
		enableExplicit = false;
	} else if ($app.filter === ContentFilter.mature) {
		enableMature = true;
		enableExplicit = false;
	} else if ($app.filter === ContentFilter.explicit) {
		enableMature = false;
		enableExplicit = true;
	} else if ($app.filter === ContentFilter.everything) {
		enableMature = true;
		enableExplicit = true;
	}
	$: setFilter(enableMature, enableExplicit);
</script>

<div class="guide-nav bg-zinc-200 dark:bg-zinc-700">
	<Button on:click={popPanel}>
		<ArrowLeftSLine class="button-icon" />
		<span class="button-text">Settings</span>
	</Button>
</div>
<h5 class="guide-section-header">CONTENT RATINGS</h5>
<div
	class="guide-section p-2.5 items-center justify-center bg-zinc-300 dark:bg-zinc-600"
	style="margin-top: 0.125rem;"
>
	{#if $app.isOfAge}
		<Toggle bind:value={enableMature}>Show Mature</Toggle>
		<Toggle bind:value={enableExplicit}>Show Explicit</Toggle>
	{:else}
		<span
			>Changing this setting may expose you to content not suitable for people under the age
			of 18.</span
		>
		<span class="my-2">Are you sure you want to proceed?</span>
		<Button on:click={setOfAge}>
			<CheckLine class="button-icon" />
			<span class="button-text">Show me the money</span>
		</Button>
	{/if}
</div>
