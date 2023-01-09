<script lang="ts">
	import { Button } from "$lib/ui/util";
	import { CloseLine, InformationLine, Loader5Line } from "svelte-remixicon";
	import { popup, closePopup } from "$lib/ui/popup";
	import type { Section } from "$lib/models/content/works";
	import { getReq, type ResponseError } from "$lib/http";
	import type { Volume } from "$lib/models/content/works";
	import { onMount } from "svelte";
	import toast from "svelte-french-toast";

	const workId: string = $popup.data.workId;
	const section: Section = $popup.data.section;
	let loading = false;
	let volumes: Volume[] = [];

	onMount(async () => {
		await fetchVolumes();
	});

	export async function fetchVolumes() {
		loading = true;
		const response = await getReq<Volume[]>(`/volumes/fetch-volumes?workId=${workId}`);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			volumes = response as Volume[];
		}
		loading = false;
	}
</script>

<div
	class="flex flex-col rounded-xl overflow-hidden overflow-y-auto bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed min-h-[350px] max-h-[400px] min-w-[350px] max-w-lg p-4"
>
	<div class="flex items-center">
		<h3 class="text-2xl">Add To Volume</h3>
		<div class="flex-1"><!--spacer--></div>
		<Button on:click={closePopup}>
			<CloseLine size="24px" class="button-icon no-text" />
		</Button>
	</div>
	{#if loading}
		<div class="flex flex-col items-center justify-center h-[350px]">
			<div class="flex items-center">
				<Loader5Line size="18px" class="mr-1 animate-spin" />
				<span class="font-bold uppercase tracking-wider">Loading</span>
			</div>
		</div>
	{:else if volumes.length === 0}
		<div class="flex flex-col items-center justify-center h-[350px]">
			<div class="flex items-center">
				<InformationLine size="18px" class="mr-1" />
				<span class="font-bold uppercase tracking-wider">No Volumes Found</span>
			</div>
		</div>
	{:else}
		<ul>
			{#each volumes as volume}
				<li>{volume.title}</li>
			{/each}
		</ul>
	{/if}
</div>
