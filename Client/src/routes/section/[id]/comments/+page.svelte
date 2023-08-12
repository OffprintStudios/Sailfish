<script lang="ts">
	import { onMount } from 'svelte';
	import type { SectionCommentsPage } from '$lib/models/comments';
	import { NewComment } from '$lib/ui/comments';
	import { SortDesc, Medal2Line, ChatNewLine } from 'svelte-remixicon';
	import { slide } from 'svelte/transition';

	export let data: SectionCommentsPage;

	let addingComment = false;

	onMount(() => {
		const themeColor = document.querySelector("meta[name='theme-color']")!;
		const bgColor = getComputedStyle(document.documentElement).getPropertyValue("--background");
		themeColor.setAttribute("content", bgColor);
	});
</script>

<div class="section-comments">
	<div class="relative pb-8 max-w-3xl mx-auto w-11/12">
		<div class="flex items-center lg:mx-4 pb-2 border-b border-zinc-200 dark:border-zinc-700">
			<button class="meta-button with-text">
				<Medal2Line class="mr-1" />
				<span class="relative -top-0.5">Top</span>
			</button>
			<div class="mx-0.5"><!--spacer--></div>
			<button class="meta-button with-text active">
				<SortDesc class="mr-1" />
				<span class="relative -top-0.5">Oldest</span>
			</button>
			<div class="flex-1"><!--spacer--></div>
			<button class="meta-button with-text" class:active={addingComment} on:click={() => addingComment = !addingComment}>
				<ChatNewLine class="lg:mr-1" />
				<span class="hidden lg:block relative -top-0.5">Add New</span>
			</button>
		</div>
		{#if addingComment}
			<div transition:slide={{ delay: 0, duration: 200 }}>
				hello!
			</div>
		{/if}
		<div class="mb-8"><!--spacer--></div>
		{#each data.page.items as comment}
			<NewComment {comment} />
		{/each}
	</div>
</div>