<script lang="ts">
	import { guide, prevPage } from "$lib/ui/guide";
	import { Button } from "$lib/ui/util";
	import { ArrowLeftSLine } from "svelte-remixicon";
</script>

<div class="panel-container">
	{#if $guide.routing.length > 1}
		<div class="topbar">
			<div class="left-button">
				<Button on:click={prevPage}>
					<ArrowLeftSLine class="button-icon" />
					<span class="button-text">Account</span>
				</Button>
			</div>
		</div>
	{/if}
	<div class="empty">
		<h3>Pardon the dust—</h3>
		<p>This feature is not yet available.</p>
	</div>
</div>

<style lang="scss">
	@use "../Guide";
</style>
