<script lang="ts">
	import { ChatNewLine } from "svelte-remixicon";
	import type { Comment as CommentModel } from "../../models/comments";
	import type { Paginate } from "$lib/util/types";
	import { CommentType } from "$lib/models/comments";
	import { account } from "$lib/state/account.state";
	import { Paginator } from "../util";
	import { NavLink } from "../nav";
	import { pluralize } from "$lib/util/functions";
	import { ThreadService } from "$lib/ui/comments";
	import CommentForm from "./CommentForm.svelte";
	import Comment from "./Comment.svelte";

	export let type: CommentType;
	export let threadId: string;
	export let sectionId: string;
	export let content: Paginate<CommentModel>;

	export let pageNum = 1;
	export let perPage = 25;

	const threadService = new ThreadService(type, threadId, content);
	const { loading, page, replies } = threadService;

	async function changePage(newPage: number) {
		pageNum = newPage;
		await threadService.fetchPage(pageNum, perPage, sectionId);
	}

	function onReply(comment: CommentModel) {
		$replies = [...$replies, comment];
	}
</script>

<div
	class="flex items-center w-full rounded-xl bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed px-2 py-2 mb-8 h-[77px]"
>
	<div class="flex-1">
		<h6 class="text-xl ml-4" style="color: var(--text-color);">
			{$page.items.length} comment{pluralize($page.items.length)}
		</h6>
	</div>
	{#if $account.account && $account.currProfile}
		<NavLink href="#comment-form">
			<ChatNewLine class="link-icon" />
			<span class="link-name">Add New</span>
		</NavLink>
	{/if}
</div>

{#if $page.items.length > 0}
	<Paginator
		currPage={pageNum}
		{perPage}
		totalItems={$page.metadata.total}
		on:change={(e) => changePage(e.detail)}
	/>
{/if}
{#if $loading}
	<div class="empty">
		<h3>Loading...</h3>
	</div>
{:else}
	{#each $page.items as comment, i}
		<Comment
			{comment}
			index={$page.metadata.per * ($page.metadata.page - 1) + (i + 1)}
			{threadService}
			on:reply={(event) => onReply(event.detail)}
		/>
	{/each}
{/if}

{#if $page.items.length !== 0}
	<Paginator
		currPage={pageNum}
		{perPage}
		totalItems={$page.metadata.total}
		on:change={(e) => changePage(e.detail)}
	/>
{/if}
{#if $account.account && $account.currProfile}
	<div id="comment-form">
		<CommentForm {threadService} {sectionId} />
	</div>
{/if}
