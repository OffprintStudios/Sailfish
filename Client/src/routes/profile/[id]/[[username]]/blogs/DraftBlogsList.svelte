<script lang="ts">
	import { onMount } from "svelte";
	import { page } from "$app/stores";
	import type { Blog } from "$lib/models/content";
	import { account } from "$lib/state/account.state";
	import { ApprovalStatus } from "$lib/models/content";
	import { ContentFilter } from "$lib/util/constants";
	import type { Paginate } from "$lib/util/types";
	import { BlogCard } from "$lib/ui/content";
	import toast from "svelte-french-toast";
	import { Paginator } from "$lib/ui/util";
	import { delReq, getReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import { slugify } from "$lib/util/functions";
	import { DeleteBin2Line, Edit2Line } from "svelte-remixicon";
	import { openPopup } from "$lib/ui/popup";
	import DeleteBlogPrompt from "../blog/[blogId]/[[blogTitle]]/DeleteBlogPrompt.svelte";

	let blogs: Paginate<Blog> = {
		items: [],
		metadata: {
			page: 1,
			per: 10,
			total: 0
		}
	};
	$: pageNum = +($page.url.searchParams.get("page") ?? "1");
	$: perPage = +($page.url.searchParams.get("per") ?? "10");
	let loading = false;

	onMount(async () => {
		await fetchDrafts(pageNum);
	});

	async function fetchDrafts(newPage: number) {
		loading = true;
		$page.url.searchParams.set("page", `${newPage}`);
		const response = await getReq<Paginate<Blog>>(
			"/blogs/fetch?" +
				"authorId=" +
				$account.currProfile?.id +
				"&" +
				"status=" +
				ApprovalStatus.draft +
				"&" +
				"filter=" +
				ContentFilter.everything +
				"&" +
				"page=" +
				newPage +
				"&" +
				"per=" +
				perPage
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			blogs = response as Paginate<Blog>;
		}
		loading = false;
	}

	async function deleteBlog(blogId: string) {
		openPopup(DeleteBlogPrompt, {
			async onConfirm() {
				const response = await delReq<void>(
					`/blogs/${blogId}/delete?profileId=${$account.currProfile?.id}`
				);
				if ((response as ResponseError).error) {
					const error = response as ResponseError;
					toast.error(error.message);
				} else {
					toast.success("Changes saved!");
					await fetchDrafts(pageNum);
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
		{#if blogs.metadata.total > 0}
			<div class="w-11/12 xl:w-full mx-auto grid grid-cols-1 lg:grid-cols-2 gap-4">
				{#each blogs.items as blog}
					<BlogCard {blog}>
						<svelte:fragment slot="dropdown">
							<a
								href="/profile/{$page.data.id}/{slugify(
									$page.data.username
								)}/blog/{blog.id}/{slugify(blog.title)}/edit"
							>
								<Edit2Line size="18px" class="mr-2" />
								<span>Edit</span>
							</a>
							<div class="w-full my-1 border-b border-zinc-300"><!--divider--></div>
							<button on:click={() => deleteBlog(blog.id)}>
								<DeleteBin2Line size="18px" class="mr-2" />
								<span>Delete</span>
							</button>
						</svelte:fragment>
					</BlogCard>
				{/each}
			</div>
		{:else}
			<div class="empty">
				<h3>You haven't added anything yet.</h3>
				<p>Add a blog and it'll show up here.</p>
			</div>
		{/if}
		{#if blogs.metadata.total > 0}
			<Paginator
				currPage={pageNum}
				{perPage}
				totalItems={blogs.metadata.total}
				on:change={(event) => fetchDrafts(event.detail)}
			/>
		{/if}
	</div>
{/if}
