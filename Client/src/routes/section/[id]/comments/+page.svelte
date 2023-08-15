<script lang="ts">
	import { onMount } from 'svelte';
	import type { SectionCommentsPage } from '$lib/models/comments';
	import { NewComment } from '$lib/ui/comments';
	import { SortDesc, Medal2Line } from 'svelte-remixicon';
	import { CommentEditor } from '$lib/ui/comments';
	import { account } from '$lib/state/account.state';
	import Avatar from '$lib/ui/util/Avatar.svelte';

	export let data: SectionCommentsPage;

	onMount(() => {
		setTimeout(() => {
			const sectionPage = document.getElementById("section-page");
			sectionPage?.classList.add("in-comments");
			const themeColor = document.querySelector("meta[name='theme-color']")!;
			const bgColor = getComputedStyle(document.documentElement).getPropertyValue("--background");
			themeColor.setAttribute("content", bgColor);
		}, 300);
	});
</script>

<div class="section-comments">
	<div class="relative pb-8 max-w-3xl mx-auto lg:w-11/12">
		<div
			class="flex items-center px-2 lg:px-0 lg:mx-4 pb-2 border-b border-zinc-200 dark:border-zinc-700"
		>
			<button class="meta-button with-text">
				<Medal2Line class="mr-1" />
				<span class="relative -top-0.5">Top</span>
			</button>
			<div class="mx-0.5"><!--spacer--></div>
			<button class="meta-button with-text active">
				<SortDesc class="mr-1" />
				<span class="relative -top-0.5">Oldest</span>
			</button>
		</div>
		<div class="mb-8"><!--spacer--></div>
		{#each data.page.items as comment}
			<div class="mx-2 lg:mx-0">
				<NewComment {comment} />
			</div>
		{/each}
		<div
			class="w-full my-6 border-b-4 border-dotted border-zinc-200 dark:border-zinc-700"
			class:hidden={!$account.currProfile}
		>
			<!--spacer-->
		</div>
		<form id="comment-form">
			{#if $account.currProfile}
				<div class="flex items-center w-full lg:rounded-t-xl p-2 bg-zinc-200 dark:bg-zinc-700">
					<Avatar src={$account.currProfile.avatar} size="42px" borderWidth="2px" />
					<h3 class="ml-2 text-xl relative top-0.5">Add A Comment</h3>
				</div>
				<CommentEditor value="" />
			{/if}
		</form>
	</div>
</div>