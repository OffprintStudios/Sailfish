<script lang="ts">
	import { ArrowLeftSLine, CheckLine } from "svelte-remixicon";
	import { Button } from "$lib/ui/util";
	import { prevPage } from "../../guide.state";
	import { app, setFilter, setOfAge } from "$lib/state/app.state";
	import { ContentFilter } from "$lib/util/constants";
	import { Toggle } from "$lib/ui/forms";

	let enableMature = false;
	let enableExplicit = false;

	if ($app.filter === ContentFilter.Default) {
		enableMature = false;
		enableExplicit = false;
	} else if ($app.filter === ContentFilter.MatureEnabled) {
		enableMature = true;
		enableExplicit = false;
	} else if ($app.filter === ContentFilter.ExplicitEnabled) {
		enableMature = false;
		enableExplicit = true;
	} else if ($app.filter === ContentFilter.Everything) {
		enableMature = true;
		enableExplicit = true;
	}
	$: setFilter(enableMature, enableExplicit);
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
			<h3>Content Ratings</h3>
			<div class="panel-box">
				{#if $app.isOfAge}
					<Toggle bind:value={enableMature}>Show Mature</Toggle>
					<Toggle bind:value={enableExplicit}>Show Explicit</Toggle>
				{:else}
					<span>Changing this setting may expose you to content not suitable for people under the age of 18.</span>
					<span class="my-2">Are you sure you want to proceed?</span>
					<Button on:click={setOfAge}>
						<CheckLine class="button-icon" />
						<span class="button-text">Show me the money</span>
					</Button>
				{/if}
			</div>
		</div>
	</div>
</div>

<style lang="scss">
	@use '../../Guide';
</style>