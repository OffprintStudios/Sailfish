<script lang="ts">
	import { account } from "$lib/state/account.state";
	import type { Work } from "$lib/models/content/works";
	import SectionsList from "./SectionsList.svelte";
	import VolumesList from "./VolumesList.svelte";
	import { Button } from "$lib/ui/util";
	import { slugify } from "$lib/util/functions";
	import { AddBoxLine } from "svelte-remixicon";
	import { openPopup } from "$lib/ui/popup";
	import VolumeFormDialog from "./VolumeFormDialog.svelte";

	export let work: Work;
	let volList = VolumesList;

	enum ListTabs {
		sections,
		volumes
	}

	let currTab = ListTabs.sections;

	function switchTab(tab: ListTabs) {
		currTab = tab;
	}

	function addVolume() {
		openPopup(
			VolumeFormDialog,
			{
				async onConfirm() {
					await volList.fetchVolumes();
				}
			},
			{
				workId: work.id
			}
		);
	}
</script>

<div class="w-full mt-6">
	<div class="flex items-center">
		<div class="flex items-center overflow-hidden">
			<button
				class="tab-button"
				class:active={currTab === ListTabs.sections}
				on:click={() => switchTab(ListTabs.sections)}
			>
				<span>Chapters</span>
			</button>
			<button
				class="tab-button"
				class:active={currTab === ListTabs.volumes}
				on:click={() => switchTab(ListTabs.volumes)}
			>
				<span>Volumes</span>
			</button>
		</div>
		<div class="flex-1"><!--spacer--></div>
		{#if currTab === ListTabs.sections}
			{#if $account.currProfile && $account.currProfile.id === work.author.id}
				<Button
					asLink={true}
					href="/prose/{work.id}/{slugify(work.title)}/section/new-section"
				>
					<AddBoxLine class="button-icon variable-text" />
					<span class="button-text hidden lg:block">Chapter</span>
				</Button>
			{/if}
		{:else if $account.currProfile && $account.currProfile.id === work.author.id}
			<Button on:click={addVolume}>
				<AddBoxLine class="button-icon variable-text" />
				<span class="button-text hidden lg:block">Volume</span>
			</Button>
		{/if}
	</div>
	<div>
		{#if currTab === ListTabs.sections}
			<SectionsList {work} />
		{:else}
			<VolumesList bind:this={volList} {work} />
		{/if}
	</div>
</div>

<style lang="scss">
	button.tab-button {
		@apply flex items-center px-3 py-1 transition rounded-t-xl border-b-2 border-transparent;
		span {
			@apply all-small-caps tracking-wider text-base lg:text-lg font-bold relative -top-[0.075rem];
		}
		&.active {
			border-color: var(--accent);
		}
	}
</style>
