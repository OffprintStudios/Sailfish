<script lang="ts">
	import { onMount } from "svelte";
	import { account } from "$lib/state/account.state";
	import type { Paginate } from "$lib/util/types";
	import type { FavoriteBlog } from "$lib/models/content";
	import { BlogCard } from "$lib/ui/content";
	import { Paginator } from "$lib/ui/util";
	import { postReq, getReq, type ResponseError } from "$lib/http";
	import toast from "svelte-french-toast";
	import { page } from "$app/stores";
	import { CloseLine, Loader5Line } from "svelte-remixicon";

	let loading = false;
	let stateChanging = false;
	let currPage = +($page.url.searchParams.get("page") ?? "1");
	let perPage = +($page.url.searchParams.get("per") ?? "21");
	let blogs: Paginate<FavoriteBlog> = {
		items: [],
		metadata: {
			page: currPage,
			per: perPage,
			total: 0
		}
	};

	onMount(async () => {
		await loadFavorites(1);
	});

	async function loadFavorites(newPage: number) {
		loading = true;
		currPage = newPage;
		const response = await getReq<Paginate<FavoriteBlog>>(
			`/blogs/fetch-favorites?profileId=${$account.currProfile?.id}&page=${currPage}&per=${perPage}`
		);
		if ((response as ResponseError).error) {
			const errorMsg = response as ResponseError;
			toast.error(errorMsg.message);
		} else {
			blogs = response as Paginate<FavoriteBlog>;
		}
		loading = false;
	}

	async function unfavoriteBlog(id: string) {
		stateChanging = true;
		const response = await postReq<void>(
			`/blogs/${id}/remove-favorite?profileId=${$account.currProfile?.id}`,
			{}
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			await loadFavorites(currPage);
		}
		stateChanging = false;
	}
</script>

{#if loading && !blogs}
	<div class="h-full flex flex-col items-center justify-center">
		<div class="empty">
			<h3>Loading...</h3>
		</div>
	</div>
{:else if blogs}
	{#if blogs.items.length > 0}
		<div class="max-w-6xl mx-auto grid grid-cols-1 lg:grid-cols-3 gap-4">
			{#each blogs.items as favorite}
				<BlogCard showAvatar blog={favorite}>
					<svelte:fragment slot="dropdown">
						<button
							type="button"
							disabled={stateChanging}
							on:click={unfavoriteBlog(favorite.id)}
						>
							{#if stateChanging}
								<Loader5Line class="mr-1 animate-spin" size="18px" />
								<span>Saving...</span>
							{:else}
								<CloseLine class="mr-1" size="18px" />
								<span>Remove</span>
							{/if}
						</button>
					</svelte:fragment>
				</BlogCard>
			{/each}
		</div>
	{:else}
		<div class="h-full flex flex-col items-center justify-center">
			<div class="empty">
				<h3>You haven't added any favorites yet</h3>
				<p>Click the Fave button on any blog and it'll show up here!</p>
			</div>
		</div>
	{/if}
	{#if loading}
		<div class="empty">
			<h3>Loading...</h3>
		</div>
	{/if}
{:else}
	<div class="empty">
		<h3>Something went wrong!</h3>
		<p>Try again in a little bit.</p>
	</div>
{/if}

{#if blogs && blogs.items.length > 0}
	<Paginator
		currPage={blogs.metadata.page}
		perPage={blogs.metadata.per}
		totalItems={blogs.metadata.total}
		on:change={(page) => loadFavorites(page)}
	/>
{/if}
