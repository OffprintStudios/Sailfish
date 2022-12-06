<script lang="ts">
	import { onMount } from "svelte";
	import { account } from "$lib/state/account.state";
	import type { Volume, Work } from "$lib/models/content/works";
	import { getReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import toast from "svelte-french-toast";
	import { Button } from "$lib/ui/util";
	import { Edit2Line, DeleteBin2Line, ImageAddLine, CheckboxBlankCircleLine, CheckboxCircleLine } from "svelte-remixicon";

	export let work: Work;
	let volumes: Volume[] = [];
	let loading = false;
	let deleting = false;

	onMount(async () => {
		await fetchVolumes();
	})

	export async function fetchVolumes() {
		loading = true;
		const response = await getReq<Volume[]>(`/volumes/fetch-volumes?workId=${work.id}`);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			volumes = response as Volume[];
		}
		loading = false;
	}

	async function editVolume(volume: Volume) {

	}

	async function addCoverArt(id: string) {

	}

	async function publishVolume(id: string) {

	}

	async function deleteVolume(id: string) {

	}
</script>

{#if loading}
	<div class="empty">
		<h3>Loading...</h3>
		<p>Please wait for awesome.</p>
	</div>
{:else if volumes.length === 0}
	<div class="empty">
		<h3>Nothing's been added yet!</h3>
		{#if $account.account && $account.currProfile && $account.currProfile.id === work.author.id}
			<p>Hit the Add Volume button to hit the ground running.</p>
		{:else}
			<p>Come back later when there's something to check out.</p>
		{/if}
	</div>
{:else}
	<div class="grid gap-4 grid-cols-1 lg:grid-cols-2 my-6">
		{#each volumes as volume}
			<div class="bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed rounded-xl">
				<div class="flex items-center">
					{#if volume.coverArt}
						some art
					{/if}
					<div class="p-4">
						<h3 class="text-xl">{volume.title}</h3>
						<span class="text-xs italic text-zinc-400">
						{volume.desc}
					</span>
					</div>
				</div>
				{#if $account.account && $account.currProfile && $account.currProfile.id === work.author.id}
					<div class="flex items-center p-1 border-t-2 border-zinc-300 dark:border-zinc-600">
						{#if volume.publishedOn}
							<Button title="Unpublish">
								<CheckboxCircleLine class="button-icon no-text" />
							</Button>
						{:else}
							<Button title="Publish">
								<CheckboxBlankCircleLine class="button-icon no-text" />
							</Button>
						{/if}
						<div class="mx-[0.075rem]"><!--spacer--></div>
						<Button title="Edit">
							<Edit2Line class="button-icon no-text" />
						</Button>
						<div class="mx-[0.075rem]"><!--spacer--></div>
						<Button title="Add Cover Art">
							<ImageAddLine class="button-icon no-text" />
						</Button>
						<div class="flex-1"><!--spacer--></div>
						<Button title="Delete">
							<DeleteBin2Line class="button-icon no-text" />
						</Button>
					</div>
				{/if}
			</div>
		{/each}
	</div>
{/if}
