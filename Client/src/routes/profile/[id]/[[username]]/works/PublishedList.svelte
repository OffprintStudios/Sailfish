<script lang="ts">
	import { onMount } from "svelte";
	import { Edit2Line, DeleteBinLine } from "svelte-remixicon";
	import { page } from "$app/stores";
	import type { Work } from "$lib/models/content/works";
	import { ContentFilter } from "$lib/util/constants";
	import { account } from "$lib/state/account.state";
	import { delReq, getReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import type { Paginate } from "$lib/util/types";
	import { Paginator } from "$lib/ui/util";
	import { WorkCard } from "$lib/ui/content";
	import { slugify } from "$lib/util/functions";
	import toast from "svelte-french-toast";
	import { openPopup } from "$lib/ui/popup";
	import DeleteWorkPrompt from "./DeleteWorkPrompt.svelte";

	let works: Work[] = [];
	let pageNum = $page.url.searchParams.has("page") ? $page.url.searchParams.get("page") : 1;
	let per = $page.url.searchParams.has("per") ? $page.url.searchParams.get("per") : 10;
	let total = 1;
	let loading = false;

	onMount(async () => {
		await fetchPublished();
	});

	async function fetchPublished() {
		loading = true;
		const response = await getReq<Paginate<Work>>(
			`/works/fetch-works?` +
				`authorId=${$account.currProfile?.id}&` +
				`published=${true}&` +
				`filter=${ContentFilter.everything}&` +
				`page=${pageNum}&` +
				`per=${per}&`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			const result = response as Paginate<Work>;
			works = result.items;
			pageNum = result.metadata.page;
			per = result.metadata.per;
			total = result.metadata.total;
		}
		loading = false;
	}

	async function deleteWork(id: string) {
		openPopup(DeleteWorkPrompt, {
			onConfirm: async () => {
				const result = await toast.promise<void | ResponseError>(
					delReq<void>(`/works/delete-work/${id}?profileId=${$account.currProfile?.id}`),
					{
						loading: "Deleting work...",
						success: "Work deleted!",
						error: null
					}
				);
				if ((result as ResponseError).error) {
					const error = result as ResponseError;
					toast.error(error.message);
				} else {
					await fetchPublished();
				}
			}
		});
	}
</script>

{#if loading}
	<div class="empty">
		<h3>Loading...</h3>
	</div>
{:else}
	<div class="my-6 w-11/12 mx-auto">
		{#if works.length > 0}
			<div class="grid grid-cols-1 xl:grid-cols-2 gap-4">
				{#each works as work}
					<WorkCard {work}>
						<svelte:fragment slot="dropdown">
							<a href="/prose/{work.id}/{slugify(work.title)}/edit">
								<Edit2Line class="mr-1" size="18px" />
								<span>Edit work</span>
							</a>
							<button type="button" on:click={() => deleteWork(work.id)}>
								<DeleteBinLine class="mr-1" size="18px" />
								<span>Delete work</span>
							</button>
						</svelte:fragment>
					</WorkCard>
				{/each}
			</div>
		{:else}
			<div class="empty">
				<h3>You haven't published anything yet.</h3>
				<p>Publish a work and it'll show up here.</p>
			</div>
		{/if}
	</div>
{/if}

{#if works.length > 0}
	<Paginator currPage={pageNum} perPage={per} totalItems={total} />
{/if}
