<script lang="ts">
	import { ChatNewLine } from "svelte-remixicon";
	import type { Thread, Comment as CommentModel } from "../../models/comments";
	import type { Paginate } from "../../util/types";
	import { account } from "../../state/account.state";
	import { comments, fetchContentThread } from "./comments.state";
	import { Paginator } from "../util";
	import { NavLink } from "../nav";
	import { pluralize } from "../../util/functions";
	import CommentForm from "./CommentForm.svelte";
	import Comment from "./Comment.svelte";

	export let thread: Thread;
	export let content: Paginate<CommentModel>;
	export let kind: 'content' | 'forum' = 'content';
	export let page = 1;
	export let per = 25;

	$comments.thread = thread;
	$comments.page = content;

	async function changePage(pageNum: number) {
		page = pageNum;
		if (kind === 'content') {
			await fetchContentThread(thread.id, page, per);
		}
	}

	function reply(comment: Comment) {
		let commentForm = document.getElementById("comment-form");
		commentForm.scrollIntoView({ behavior: 'smooth' });
	}
</script>

<div class="flex items-center w-full rounded-xl bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed px-2 py-2 mb-8 h-[77px]">
	<div class="flex-1">
		<h6
			class="text-xl ml-4"
			style="color: var(--text-color);"
		>
			{$comments.page?.items.length} comment{pluralize($comments.page?.items.length)}
		</h6>
	</div>
	{#if $account.account && $account.currProfile}
		<NavLink href="#comment-form">
			<ChatNewLine class="link-icon" />
			<span class="link-name">Add New</span>
		</NavLink>
	{/if}
</div>
{#if $comments.page}
	{#if $comments.page?.items.length !== 0}
		<Paginator
			currPage={page}
			perPage={per}
			totalItems={$comments.page.metadata.total}
			on:change={(e) => changePage(e.detail)}
		/>
	{/if}
	{#if $comments.loading}
		<div class="empty">
			<h3>Loading...</h3>
		</div>
	{:else}
		{#each $comments.page.items as comment, i}
			<Comment
				{comment}
				index={$comments.page?.metadata.per * ($comments.page?.metadata.page - 1) + (i + 1)}
				on:reply={(e) => reply(e)}
			/>
		{/each}
	{/if}

	{#if $comments.page?.items.length !== 0}
		<Paginator
			currPage={page}
			perPage={per}
			totalItems={$comments.page.metadata.total}
			on:change={(e) => changePage(e.detail)}
		/>
	{/if}
	{#if $account.account && $account.currProfile}
		<div id="comment-form">
			<CommentForm threadId={thread.id} />
		</div>
	{/if}
{/if}
