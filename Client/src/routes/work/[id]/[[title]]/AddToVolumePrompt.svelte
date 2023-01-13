<script lang="ts">
	import { Button } from "$lib/ui/util";
	import { AddBoxLine, CloseLine, InformationLine, Loader5Line } from "svelte-remixicon";
	import { popup, closePopup, closePopupAndConfirm } from "$lib/ui/popup";
	import { getReq, patchReq, type ResponseError } from "$lib/http";
	import type { Volume } from "$lib/models/content/works";
	import { onMount } from "svelte";
	import { account } from "$lib/state/account.state";
	import toast from "svelte-french-toast";

	const workId: string = $popup.data.workId;
	const sectionId: string = $popup.data.sectionId;
	let loading = false;
	let adding = false;
	let volumes: Volume[] = [];

	onMount(async () => {
		await fetchVolumes();
	});

	export async function fetchVolumes() {
		loading = true;
		const response = await getReq<Volume[]>(
			`/volumes/fetch-volumes?workId=${workId}&status=draft`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			volumes = response as Volume[];
		}
		loading = false;
	}

	async function addToVolume(volumeId: string) {
		adding = true;
		const response = await patchReq<void>(
			`/sections/add-to-volume/${sectionId}?workId=${workId}&volumeId=${volumeId}&profileId=${$account.currProfile?.id}`,
			{}
		);
		if ((response as ResponseError).statusCode) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			toast.success(`Added to volume!`);
			closePopupAndConfirm();
		}
		adding = false;
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
		<ul class="mt-2">
			{#each volumes as volume}
				<li class="odd:bg-zinc-300 odd:dark:bg-zinc-600">
					<button
						class="w-full"
						disabled={adding}
						on:click={() => addToVolume(volume.id)}
					>
						<span class="flex-1 text-left">{volume.title}</span>
						{#if adding}
							<Loader5Line size="18px" class="animate-spin" />
						{:else}
							<AddBoxLine size="18px" />
						{/if}
					</button>
				</li>
			{/each}
		</ul>
	{/if}
</div>

<style lang="scss">
	button {
		@apply flex items-center text-sm transition transform h-full p-2;
		color: var(--text-color);
		span.title {
			@apply flex-1;
		}
		&:hover {
			background: var(--accent);
			@apply text-white;
		}
	}
</style>
