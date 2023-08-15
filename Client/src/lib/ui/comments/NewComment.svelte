<script lang="ts">
	import type { NewComment } from "$lib/models/comments";
	import { Avatar, Time, RoleBadge } from "../util";
	import { Icon } from "svelte-remix";
	import { slide } from "svelte/transition";
	import { copyToClipboard, slugify, abbreviate, clickOutside, throttle } from "$lib/util/functions";

	export let comment: NewComment;
	export let collapsed = false;
	export let topComment = false;

	const iconSize = "22px";
	let extrasOpen = false;

	function toggleExtras() {
		extrasOpen = !extrasOpen;
	}

	const throttledExtras = throttle(toggleExtras, 200);
</script>

<div class="comment">
	<div class="flex items-center">
		<Avatar src={comment.profile.avatar} size="36px" borderWidth="2px" />
		<div class="flex-1 ml-2">
			<div class="flex items-center relative top-0.5">
				<a style="color: var(--text-color);" href="/profile/{comment.profile.id}/{slugify(comment.profile.name)}">
					<h5 class="text-lg" style="color: var(--text-color);">{comment.profile.name}</h5>
				</a>
				<RoleBadge roles={comment.profile.roles} size="small" />
			</div>
			<div class="flex items-center text-xs text-zinc-400 relative -top-0.5">
				{#if comment.profile.info.tagline !== null && comment.profile.info.tagline !== "null" && comment.profile.info.tagline !== undefined}
					<span>{comment.profile.info.tagline}</span>
					<span class="mx-1">•</span>
				{:else}
					<span>Patron</span>
					<span class="mx-1">•</span>
				{/if}
				<span><Time timestamp={comment.createdAt} relative live /></span>
			</div>
		</div>
		{#if topComment}
			<div class="text-green-600 px-1.5 mr-2">
				<span><Icon name="medal-2-line" width={iconSize} height={iconSize} tabindex="-1" /></span>
			</div>
		{/if}
		<button 
			class="rounded-xl p-1.5 transition hover:bg-zinc-200 dark:hover:bg-zinc-700" 
			style="color: var(--text-color);" 
			on:click={throttledExtras}
		>
			<Icon name="more-2-fill" width="20px" height="20px" tabindex="-1" />
		</button>
	</div>
	{#if extrasOpen}
		<div
			class="flex items-center bg-zinc-200 dark:bg-zinc-700 bg-opacity-50 px-2 py-2 mt-2 border-y border-zinc-600"
			transition:slide={{ delay: 0, duration: 150 }}
			use:clickOutside
			on:outclick={throttledExtras}
		>
			<button class="extras-button" on:click={() => copyToClipboard("TODO: replace this")}>
				<Icon name="link" width="1rem" height="1rem" class="mr-2" tabindex="-1" />
				<span style="font-size: 0.825rem; line-height: 1rem;">Copy Link</span>
			</button>
			<div class="mx-0.5"><!--spacer--></div>
			<button class="extras-button">
				<Icon name="alarm-warning-line" width="1rem" height="1rem" class="mr-2" tabindex="-1" />
				<span style="font-size: 0.825rem; line-height: 1rem;">Report This</span>
			</button>
		</div>
	{/if}
	<div class="comment-body overflow-hidden" style="color: var(--text-color);" class:max-h-[8rem]={collapsed}>
		{@html comment.body}
	</div>
	<div class="comment-tools">
		{#if !topComment}
			<button class="tool-link">
				<span>Reply</span>
			</button>
		{/if}
		{#if comment.updatedAt.valueOf() > comment.createdAt.valueOf()}
			<span class="mx-1">•</span>
			<button class="tool-link">
				<span>Edited <Time timestamp={comment.updatedAt} relative live /></span>
			</button>
		{/if}
		<div class="flex-1"><!--spacer--></div>
		<button class="tool-link button">
			<Icon name="arrow-up-s-line" width={iconSize} height={iconSize} tabindex="-1" />
			<span>{abbreviate(comment.likes)}</span>
		</button>
		<div class="mx-0.5"><!--spacer--></div>
		<button class="tool-link button">
			<Icon name="arrow-down-s-line" width={iconSize} height={iconSize} tabindex="-1" />
			<span>{abbreviate(comment.dislikes)}</span>
		</button>
	</div>
</div>

<style lang="scss">
	div.comment {
		@apply flex flex-col w-full px-2 transition;
		button.extras-button {
			@apply flex items-center rounded-xl transition px-2 py-2.5;
			color: var(--text-color);
	  	}
	  	div.comment-tools {
        	@apply flex items-center text-xs text-zinc-400 pt-2;
	  	}
	  	button.tool-link {
      	  @apply flex items-center rounded-xl pl-0.5 pr-1 py-0.5 transition;
			&:hover {
			  @apply underline;
			  background-color: transparent !important;
			}
			&.button {
			  @apply no-underline;
			}
	  	}
		@media (min-width: 1024px) {
			@apply px-4;
		}
	}
</style>
