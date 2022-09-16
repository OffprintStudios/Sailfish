<script lang="ts">
	import {
		AlarmWarningLine,
		Calendar2Line,
		CalendarCheckLine,
		ChatNewLine,
		CloseLine,
		DeleteBinLine,
		Edit2Line,
		Save2Line,
		StarLine
	} from "svelte-remixicon";
	import { createForm } from "felte";
	import { Editor, TextField } from "$lib/ui/forms";
	import { Button, Time } from "$lib/ui/util";
	import { abbreviate, pluralize } from "$lib/util/functions";
	import type { Blog, BlogForm } from "$lib/models/content";
	import { ContentRating } from "$lib/models/content";
	import { account } from "$lib/state/account.state";
	import toast from "svelte-french-toast";

	export let blog: Blog;

	const iconSize = '24px';
	let isEditing = false;

	const { form, data, createSubmitHandler, isSubmitting } = createForm({
		initialValues: {
			title: blog.title ?? null,
			desc: blog.desc ?? null,
			body: blog.body ?? null,
		}
	});

	const submitForm = createSubmitHandler({
		async onSubmit(values) {
			const formInfo: BlogForm = {
				body: values.body,
				desc: values.desc,
				rating: ContentRating.Everyone,
				title: values.title
			};

			const response = await fetch(`/api/content/blogs/${blog.id}/update-blog?profileId=${$account.currProfile?.id}`, {
				method: 'PATCH',
				body: JSON.stringify(formInfo),
			});

			if (response.status === 200) {
				toast.success("Changes saved");
				blog = await response.json();
			} else {
				toast.error("Something went wrong! Try again in a little bit.");
			}
		},
	});
</script>

<div class="mx-auto max-w-4xl flex flex-col my-12 md:flex-row">
	<div class="hidden md:flex flex-row md:flex-col md:max-w-[108.16px] md:min-w-[108.16px]">
		<div class="date-block bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
			<Calendar2Line size="36px" class="mb-2" />
			{#if blog.publishedOn}
					<span class="month-and-day">
						{new Date(blog.createdAt).toLocaleString('default', { month: 'short' })} {new Date(blog.createdAt).getDay()}
					</span>
				<span class="year">{new Date(blog.createdAt).getFullYear()}</span>
			{:else}
					<span class="month-and-day">
						{new Date(blog.createdAt).toLocaleString('default', { month: 'short' })} {new Date(blog.createdAt).getDay()}
					</span>
				<span class="year">{new Date(blog.createdAt).getFullYear()}</span>
			{/if}
		</div>
		<div class="toolbox bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
			{#if $account.account && $account.currProfile && $account.currProfile.id === blog.author.id}
				{#if isEditing}
					<Button classes="md:w-full md:justify-center" on:click={submitForm} loading={$isSubmitting} loadingText="Saving">
						<Save2Line class="button-icon" />
						<span class="button-text">Save</span>
					</Button>
					<div class="my-0.5"><!--spacer--></div>
					<Button classes="md:w-full md:justify-center" on:click={() => isEditing = false}>
						<CloseLine class="button-icon" />
						<span class="button-text">Cancel</span>
					</Button>
					<div class="my-0.5"><!--spacer--></div>
					<Button classes="md:w-full md:justify-center" disabled="true">
						<DeleteBinLine class="button-icon" />
						<span class="button-text">Delete</span>
					</Button>
				{:else}
					<Button classes="md:w-full md:justify-center" on:click={() => isEditing = true}>
						<Edit2Line class="button-icon" />
						<span class="button-text">Edit</span>
					</Button>
					<div class="my-0.5"><!--spacer--></div>
					<Button classes="md:w-full md:justify-center">
						<CalendarCheckLine class="button-icon" />
						<span class="button-text">Publish</span>
					</Button>
					<div class="my-0.5"><!--spacer--></div>
					<Button classes="md:w-full md:justify-center">
						<DeleteBinLine class="button-icon" />
						<span class="button-text">Delete</span>
					</Button>
				{/if}
			{:else if $account.account && $account.currProfile}
				<Button classes="md:w-full md:justify-center">
					<StarLine class="button-icon" />
					<span class="button-text">Favorite</span>
				</Button>
				<div class="my-0.5"><!--spacer--></div>
				<Button classes="md:w-full md:justify-center">
					<ChatNewLine class="button-icon" />
					<span class="button-text">Discuss</span>
				</Button>
				<div class="my-0.5"><!--spacer--></div>
				<Button classes="md:w-full md:justify-center">
					<AlarmWarningLine class="button-icon" />
					<span class="button-text">Report</span>
				</Button>
			{/if}
		</div>
		<div class="flex flex-col rounded-xl bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed p-2">
			<div class="stat-block">
				<span class="stat-name">Views</span>
				<span class="stat-value">{abbreviate(blog.stats.views)}</span>
			</div>
			<div class="stat-block">
				<span class="stat-name">Comments</span>
				<span class="stat-value">{abbreviate(blog.stats.comments)}</span>
			</div>
			<div class="stat-block">
				<span class="stat-name">Words</span>
				<span class="stat-value">{abbreviate(blog.stats.words)}</span>
			</div>
		</div>
	</div>
	<div class="mx-0.5"><!--spacer--></div>
	<div class="blog-container">
		{#if isEditing}
			<form use:form>
				<TextField
					name="title"
					type="text"
					title="Title"
					placeholder="Just Catching Up"
				/>
				<div class="my-4"></div>
				<Editor label="Content" bind:value={$data.body} />
			</form>
		{:else}
			<h1 class="text-4xl font-medium">{blog.title}</h1>
			<div class="flex md:hidden items-center text-xs mb-4">
				<Time timestamp={blog.publishedOn ? blog.publishedOn : blog.createdAt} />
				<span class="mx-1">•</span>
				<span>{abbreviate(blog.stats.comments)} comment{pluralize(blog.stats.comments)}</span>
				<span class="mx-1">•</span>
				<span>{abbreviate(blog.stats.views)} view{pluralize(blog.stats.views)}</span>
			</div>
			<div class="mobile-tools">
				<Button>
					<StarLine size={iconSize} class="button-icon no-text" />
				</Button>
				<div class="mx-0.5"><!--spacer--></div>
				<Button>
					<ChatNewLine size={iconSize} class="button-icon no-text" />
				</Button>
				<div class="flex-1"><!--spacer--></div>
				<Button>
					<AlarmWarningLine size={iconSize} class="button-icon no-text" />
				</Button>
			</div>
			<div class="blog-body">{@html blog.body}</div>
		{/if}
	</div>
</div>

<style lang="scss">
	div.blog-container {
		@apply rounded-xl flex flex-col px-2 md:px-12 py-2;
	}
	div.stat-block {
		@apply flex flex-col items-center justify-center border-b-2 border-zinc-300 py-4 last:pb-2 last:border-0;
		span.stat-name {
			@apply uppercase text-zinc-500 text-xs font-medium tracking-widest mb-1;
		}
		span.stat-value {
			@apply text-lg font-bold;
			font-family: var(--body-serif-text);
		}
	}
	div.date-block {
		font-family: var(--header-text);
		@apply flex-col items-center justify-center pt-3.5 flex rounded-xl mb-4;
		span.month-and-day {
			@apply uppercase text-2xl font-medium relative kerning;
		}
		span.year {
			@apply text-lg font-light relative bottom-2;
		}
	}
	div.toolbox {
		@apply flex flex-col w-full md:max-w-[108.16px] md:min-w-[108.16px] p-2 rounded-xl mb-4;
	}
	div.mobile-tools {
		@apply flex md:hidden items-center;
	}
	div.blog-body {
		@apply text-[16px];
	}
</style>