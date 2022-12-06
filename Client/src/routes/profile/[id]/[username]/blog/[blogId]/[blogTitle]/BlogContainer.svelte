<script lang="ts">
	import { onMount } from "svelte";
	import {
		AlarmWarningLine,
		Calendar2Line,
		CalendarCheckLine,
		CalendarEventLine,
		CalendarTodoLine,
		ChatNewLine,
		CloseLine,
		DeleteBinLine,
		Edit2Line, ImageAddLine, ImageEditLine,
		Save2Line,
		StarLine,
		StarFill,
		EditBoxLine,
	} from "svelte-remixicon";
	import { createForm } from "felte";
	import { goto } from "$app/navigation";
	import { Editor, TextField } from "$lib/ui/forms";
	import { Button, Time } from "$lib/ui/util";
	import { abbreviate, pluralize, slugify } from "$lib/util/functions";
	import type { Blog, BlogForm, FavoriteBlog, PublishBlogForm } from "$lib/models/content";
	import { ContentRating } from "$lib/models/content";
	import { account } from "$lib/state/account.state";
	import toast from "svelte-french-toast";
	import { Dropdown } from "$lib/ui/dropdown";
	import type { ResponseError } from "$lib/http";
	import { openPopup } from "$lib/ui/popup";
	import { getReq, postReq, delReq, patchReq } from "$lib/http";
	import { default as DeleteBlogPrompt } from './DeleteBlogPrompt.svelte';
	import { UploadBlogBanner } from "$lib/ui/upload";

	export let blog: Blog;
	const iconSize = '24px';
	let isEditing = false;
	let isPublishing = false;
	let hasFavorited: FavoriteBlog = null;
	let loadingFavorite = false;

	onMount(async () => {
		if ($account.account && $account.currProfile && $account.currProfile.id !== blog.author.id) {
			await fetchFavorite();
		}
	});

	const { form, data, createSubmitHandler, isSubmitting } = createForm({
		initialValues: {
			title: blog.title ?? null,
			desc: blog.desc ?? null,
			body: blog.body ?? null,
		}
	});

	async function fetchFavorite() {
		loadingFavorite = true;
		const response = await getReq<FavoriteBlog>(`/blogs/fetch-favorite/${blog.id}?profileId=${$account.currProfile?.id}`);
		if ((response as ResponseError).error) {
			hasFavorited = null;
		} else {
			hasFavorited = response as FavoriteBlog;
		}
		loadingFavorite = false;
	}

	async function favoriteBlog() {
		loadingFavorite = true;
		const response = await postReq<FavoriteBlog>(`/blogs/add-favorite/${blog.id}?profileId=${$account.currProfile?.id}`, {});
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			hasFavorited = response as FavoriteBlog;
		}
		loadingFavorite = false;
	}

	async function unfavoriteBlog() {
		const response = await delReq<void>(`/blogs/remove-favorite/${blog.id}?profileId=${$account.currProfile?.id}`);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			hasFavorited = null;
		}
		loadingFavorite = false;
	}

	const submitForm = createSubmitHandler({
		async onSubmit(values) {
			const formInfo: BlogForm = {
				body: values.body,
				desc: values.desc,
				rating: ContentRating.Everyone,
				title: values.title
			};

			const response = await patchReq<Blog>(`/api/content/blogs/${blog.id}/update-blog?profileId=${$account.currProfile?.id}`, formInfo);
			if ((response as ResponseError).error) {
				const error = response as ResponseError;
				toast.error(error.message);
			} else {
				toast.success("Changes saved!");
				blog = response as Blog;
				isEditing = false;
			}
		},
	});

	async function publishBlog(date?: Date) {
		isPublishing = true;
		const pubBlog: PublishBlogForm = {
			pubDate: date ? date.toISOString(). split('.')[0] + 'Z' : null,
		};
		const response = await patchReq<Blog>(`/blogs/publish-blog/${blog.id}?profileId=${$account.currProfile?.id}`, pubBlog);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			toast.success("Changes saved!");
			blog = response as Blog;
		}
		isPublishing = false;
	}

	async function updateCover() {
		openPopup(UploadBlogBanner, {
			async onConfirm(data: Blog) {
				blog = data;
			}
		}, {
			blogId: blog.id,
		});
	}

	async function deleteBlog() {
		openPopup(DeleteBlogPrompt, {
			async onConfirm() {
				const response = await delReq<void>(`/blogs/delete-blog/${blog.id}?profileId=${$account.currProfile?.id}`);
				if ((response as ResponseError).error) {
					const error = response as ResponseError;
					toast.error(error.message);
				} else {
					toast.success("Changes saved!");
					await goto(`/profile/${blog.author.id}/${slugify(blog.author.username)}/blogs`);
				}
			}
		});
	}
</script>

<div class="mx-auto max-w-4xl flex flex-col my-12 md:flex-row">
	<div class="hidden md:flex flex-row md:flex-col md:max-w-[108.16px] md:min-w-[108.16px]">
		<div class="date-block bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
			<Calendar2Line size="36px" class="mb-2" />
			{#if blog.publishedOn}
					<span class="month-and-day">
						{new Date(blog.publishedOn).toLocaleString('default', { month: 'short' })} {new Date(blog.publishedOn).getDate()}
					</span>
				<span class="year">{new Date(blog.publishedOn).getFullYear()}</span>
			{:else}
					<span class="month-and-day">
						{new Date(blog.createdAt).toLocaleString('default', { month: 'short' })} {new Date(blog.createdAt).getDate()}
					</span>
				<span class="year">{new Date(blog.createdAt).getFullYear()}</span>
			{/if}
		</div>
		{#if $account.account && $account.currProfile && $account.currProfile.id === blog.author.id}
			<div class="toolbox bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
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
					{#if blog.publishedOn}
						<Button classes="md:w-full md:justify-center" on:click={() => publishBlog(null)}>
							<EditBoxLine class="button-icon" />
							<span class="button-text">Unpublish</span>
						</Button>
					{:else}
						<Dropdown position="right-start">
							<svelte:fragment slot="button">
								<CalendarCheckLine class="button-icon" />
								<span class="button-text">Publish</span>
							</svelte:fragment>
							<svelte:fragment slot="items">
								<button type="button" on:click={() => publishBlog(new Date())}>
									<CalendarEventLine class="mr-2" />
									<span>Publish Now</span>
								</button>
								<button type="button" on:click={() => toast.error("This feature is not yet supported.")}>
									<CalendarTodoLine class="mr-2" />
									<span>Publish Later</span>
								</button>
							</svelte:fragment>
						</Dropdown>
					{/if}
					<div class="my-0.5"><!--spacer--></div>
					<Button classes="md:w-full md:justify-center" on:click={() => deleteBlog()}>
						<DeleteBinLine class="button-icon" />
						<span class="button-text">Delete</span>
					</Button>
				{/if}
			</div>
			{:else if $account.account && $account.currProfile}
			<div class="toolbox bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
				{#if !!hasFavorited}
					<Button classes="md:w-full md:justify-center" loading={loadingFavorite} loadingText="Wait..." on:click={() => unfavoriteBlog()}>
						<StarFill class="button-icon" />
						<span class="button-text">Unfave</span>
					</Button>
				{:else}
					<Button classes="md:w-full md:justify-center" loading={loadingFavorite} loadingText="Wait..." on:click={() => favoriteBlog()}>
						<StarLine class="button-icon" />
						<span class="button-text">Fave</span>
					</Button>
				{/if}
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
			</div>
		{/if}
		<div class="flex flex-col rounded-xl bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed p-2">
			<div class="stat-block">
				<span class="stat-name">Views</span>
				<span class="stat-value">{abbreviate(blog.stats.views)}</span>
			</div>
			<div class="stat-block">
				<span class="stat-name">Favorites</span>
				<span class="stat-value">{abbreviate(blog.stats.favorites)}</span>
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
			<div class="header-block">
				{#if blog.cover}
					{#if $account.account && $account.currProfile && $account.currProfile.id === blog.author.id}
						<div class="absolute top-1 right-1">
							<Button kind="primary" on:click={updateCover}>
								<ImageEditLine class="button-icon no-text" />
							</Button>
						</div>
					{/if}
					<div class="h-[12rem] overflow-hidden">
						<img src={blog.cover} class="h-full w-full object-cover" alt="cover" />
					</div>
				{:else}
					{#if $account.account && $account.currProfile && $account.currProfile.id === blog.author.id}
						<div class="absolute top-1 right-1">
							<Button kind="primary" on:click={updateCover}>
								<ImageAddLine class="button-icon no-text" />
							</Button>
						</div>
					{/if}
				{/if}
				<div class="blog-header">
					<h1 class="text-4xl font-medium">{blog.title}</h1>
				</div>
			</div>
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
			{#if blog.editedOn}
				<span class="text-xs italic border-t pt-4">Last edited <Time timestamp={blog.editedOn} relative="true" /></span>
			{/if}
		{/if}
	</div>
</div>

<style lang="scss">
	div.blog-container {
		@apply rounded-xl flex flex-col px-2 md:px-12;
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
	div.header-block {
		@apply relative mb-6 rounded-xl overflow-hidden w-full;
		background: var(--accent);
		div.blog-header {
			@apply px-4 py-6;
			h1 {
				@apply text-white text-4xl font-medium;
			}
		}
	}
</style>