<script lang="ts">
	import { page } from "$app/stores";
	import type { Blog } from "$lib/models/content";
	import type { Comment } from "$lib/models/comments";
	import type { Paginate } from "$lib/util/types";
	import { CommentType } from "$lib/models/comments";
	import { slugify, abbreviate } from "$lib/util/functions";
	import { Button, InfoBar, Time } from "$lib/ui/util";
	import { account } from "$lib/state/account.state";
	import { Thread } from "$lib/ui/comments";
	import { onMount } from "svelte";
	import { delReq, getReq, patchReq, postReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import type { PublishBlogForm } from "$lib/models/content";
	import toast from "svelte-french-toast";
	import { openPopup } from "$lib/ui/popup";
	import { UploadBlogBanner } from "$lib/ui/upload";
	import { goto } from "$app/navigation";
	import {
		DiscussLine,
		ImageAddLine,
		ImageEditLine,
		StarLine,
		LineChartLine,
		PenNibLine,
		CalendarLine,
		AlarmWarningLine,
		StarFill,
		Edit2Line,
		DeleteBinLine,
		CheckboxBlankCircleLine,
		CheckboxCircleLine
	} from "svelte-remixicon";
	import DeleteBlogPrompt from "./DeleteBlogPrompt.svelte";
	import { ReportForm } from "$lib/ui/admin";
	import { ReportKind } from "$lib/models/admin/users/reports";
	import TagBadge from "$lib/ui/content/TagBadge.svelte";
	import { TagKind } from "$lib/models/tags";

	export let data: { blog: Blog; comments?: Paginate<Comment> };
	let blog = data.blog;
	let isPublishing = false;
	let checkFavorite = { hasFavorited: false };
	let loadingFavorite = false;

	$: pageNum = +($page.url.searchParams.get("page") ?? "1");
	$: perPage = +($page.url.searchParams.get("per") ?? "24");

	onMount(async () => {
		if (
			$account.account &&
			$account.currProfile &&
			$account.currProfile.id !== blog.author.id
		) {
			await fetchFavorite();
		}
	});

	async function fetchFavorite() {
		loadingFavorite = true;
		const response = await getReq<{ hasFavorited: boolean }>(
			`/blogs/${blog.id}/fetch-favorite?profileId=${$account.currProfile?.id}`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			checkFavorite = response as { hasFavorited: boolean };
		}
		loadingFavorite = false;
	}

	async function favoriteBlog() {
		loadingFavorite = true;
		const response = await postReq<{ hasFavorited: boolean }>(
			`/blogs/${blog.id}/add-favorite?profileId=${$account.currProfile?.id}`,
			{}
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			checkFavorite = response as { hasFavorited: boolean };
		}
		loadingFavorite = false;
	}

	async function unfavoriteBlog() {
		loadingFavorite = true;
		const response = await postReq<void>(
			`/blogs/${blog.id}/remove-favorite?profileId=${$account.currProfile?.id}`,
			{}
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			checkFavorite = response as { hasFavorited: boolean };
		}
		loadingFavorite = false;
	}

	async function publishBlog(date?: Date) {
		isPublishing = true;
		const pubBlog: PublishBlogForm = {
			pubDate: date ? date.toISOString().split(".")[0] + "Z" : null
		};
		const response = await patchReq<Blog>(
			`/blogs/${blog.id}/publish?profileId=${$account.currProfile?.id}`,
			pubBlog
		);
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
		openPopup(
			UploadBlogBanner,
			{
				async onConfirm(data: Blog) {
					blog = data;
				}
			},
			{
				blogId: blog.id
			}
		);
	}

	async function deleteBlog() {
		openPopup(DeleteBlogPrompt, {
			async onConfirm() {
				const response = await delReq<void>(
					`/blogs/${blog.id}/delete?profileId=${$account.currProfile?.id}`
				);
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

	function reportBlog() {
		openPopup(
			ReportForm,
			{
				onConfirm: () => {
					console.log("0");
				}
			},
			{
				kind: ReportKind.Blog,
				accountId: blog.author.account.id,
				itemId: blog.id,
				link: $page.url.pathname
			}
		);
	}
</script>

<svelte:head>
	<title>{data.blog.title} &mdash; Offprint</title>
	<!-- Primary Meta Tags -->
	<meta name="title" content={data.blog.title} />
	<meta
		name="description"
		content={data.blog.desc ? data.blog.desc : `From the desk of ${data.blog.author.username}.`}
	/>

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="website" />
	<meta
		property="og:url"
		content="https://offprint.net/profile/{data.blog.author.id}/{slugify(
			data.blog.author.username
		)}/blog/{data.blog.id}/{slugify(data.blog.title)}"
	/>
	<meta property="og:title" content={data.blog.title} />
	<meta
		property="og:description"
		content={data.blog.desc ? data.blog.desc : `From the desk of ${data.blog.author.username}.`}
	/>
	<meta property="og:image" content={data.blog.author.avatar} />

	<!-- Twitter -->
	<meta property="twitter:card" content="summary_large_image" />
	<meta
		property="twitter:url"
		content="https://offprint.net/profile/{data.blog.author.id}/{slugify(
			data.blog.author.username
		)}/blog/{data.blog.id}/{slugify(data.blog.title)}"
	/>
	<meta property="twitter:title" content={data.blog.title} />
	<meta
		property="twitter:description"
		content={data.blog.desc ? data.blog.desc : `From the desk of ${data.blog.author.username}.`}
	/>
	<meta property="twitter:image" content={data.blog.author.avatar} />
</svelte:head>

{#if !data.blog.publishedOn}
	<InfoBar
		message="This blog is a draft. Faves and comments are disabled, and views will not be tracked."
	/>
	<div class="mb-6"><!--spacer--></div>
{/if}

<div class="blog-container">
	<div class="header-block">
		{#if blog.bannerArt}
			{#if $account.account && $account.currProfile && $account.currProfile.id === blog.author.id}
				<div class="absolute top-1 right-1">
					<Button kind="primary" on:click={updateCover}>
						<ImageEditLine class="button-icon no-text" />
					</Button>
				</div>
			{/if}
			<div class="h-[12rem] overflow-hidden">
				<img src={blog.bannerArt} class="h-full w-full object-cover" alt="cover" />
			</div>
		{:else if $account.account && $account.currProfile && $account.currProfile.id === blog.author.id}
			<div class="absolute top-1 right-1">
				<Button kind="primary" on:click={updateCover}>
					<ImageAddLine class="button-icon no-text" />
				</Button>
			</div>
		{/if}
		<div class="blog-header" class:pb-4={!($account.account && $account.currProfile)}>
			<div class="flex items-center text-white">
				{#if blog.publishedOn}
					<span class="stat" title="Published On">
						<CalendarLine class="mr-1 relative -top-[0.075rem]" size="16px" />
						<Time timestamp={blog.publishedOn} />
					</span>
				{:else}
					<span class="stat" title="Created At">
						<CalendarLine class="mr-1 relative -top-[0.075rem]" size="16px" />
						<Time timestamp={blog.createdAt} />
					</span>
				{/if}
				<span class="mx-1 text-lg relative top-0.5">/</span>
				<span class="stat" title="Faves">
					<StarLine class="mr-1 relative -top-[0.075rem]" size="16px" />
					<span>{abbreviate(blog.stats.favorites)}</span>
				</span>
				<span class="mx-1 text-lg relative top-0.5">/</span>
				<span class="stat" title="Views">
					<LineChartLine class="mr-1 relative -top-[0.075rem]" size="16px" />
					<span>{abbreviate(blog.stats.views)}</span>
				</span>
				<span class="mx-1 text-lg relative top-0.5">/</span>
				<span class="stat" title="Comments">
					<DiscussLine class="mr-1 relative -top-[0.075rem]" size="16px" />
					<span>{abbreviate(blog.stats.comments)}</span>
				</span>
				<span class="mx-1 text-lg relative top-0.5">/</span>
				<span class="stat" title="Words">
					<PenNibLine class="mr-1 relative -top-[0.075rem]" size="16px" />
					<span>{abbreviate(blog.stats.words)}</span>
				</span>
				<div class="flex-1"><!--spacer--></div>
				<TagBadge kind={TagKind.rating} rating={blog.rating} size="small" />
			</div>
			<h1>{blog.title}</h1>
		</div>
		{#if $account.account && $account.currProfile}
			<div class="flex items-center px-2 pb-2">
				{#if $account.currProfile.id === blog.author.id}
					<Button kind="primary" asLink href="{$page.url.pathname}/edit">
						<Edit2Line class="button-icon" />
						<span class="button-text">Edit</span>
					</Button>
					<div class="mx-0.5"><!--spacer--></div>
					{#if blog.publishedOn}
						<Button
							kind="primary"
							loading={isPublishing}
							loadingText="Publishing..."
							on:click={() => publishBlog()}
						>
							<CheckboxCircleLine class="button-icon" />
							<span class="button-text">Unpublish</span>
						</Button>
					{:else}
						<Button
							kind="primary"
							loading={isPublishing}
							loadingText="Publishing..."
							on:click={() => publishBlog(new Date())}
						>
							<CheckboxBlankCircleLine class="button-icon" />
							<span class="button-text">Publish</span>
						</Button>
					{/if}
					<div class="flex-1"><!--spacer--></div>
					<Button kind="primary" on:click={deleteBlog}>
						<DeleteBinLine class="button-icon" />
						<span class="button-text">Delete</span>
					</Button>
				{:else}
					{#if checkFavorite.hasFavorited}
						<Button
							kind="primary"
							loading={loadingFavorite}
							loadingText="Saving..."
							on:click={unfavoriteBlog}
						>
							<StarFill class="button-icon" />
							<span class="button-text">Unfave</span>
						</Button>
					{:else}
						<Button
							kind="primary"
							loading={loadingFavorite}
							loadingText="Saving..."
							on:click={favoriteBlog}
						>
							<StarLine class="button-icon" />
							<span class="button-text">Fave</span>
						</Button>
					{/if}
					<div class="mx-0.5"><!--spacer--></div>
					<Button kind="primary" asLink href="{$page.url.pathname}#comment-form">
						<DiscussLine class="button-icon" />
						<span class="button-text">Discuss</span>
					</Button>
					<div class="flex-1"><!--spacer--></div>
					<Button kind="primary" on:click={reportBlog}>
						<AlarmWarningLine class="button-icon" />
						<span class="button-text">Report</span>
					</Button>
				{/if}
			</div>
		{/if}
	</div>
	<section class="blog-body">{@html blog.body}</section>
	{#if blog.editedOn}
		<span class="text-xs italic border-t pt-4">
			Last edited <Time timestamp={blog.editedOn} relative="true" />
		</span>
	{/if}
</div>

{#if data.blog.publishedOn && data.comments}
	<div class="max-w-4xl mx-auto">
		<Thread
			type={CommentType.Blog}
			threadId={data.blog.id}
			content={data.comments}
			{pageNum}
			{perPage}
		/>
	</div>
{/if}

<style lang="scss">
	div.blog-container {
		@apply max-w-[52rem] mx-auto mb-6;
		div.header-block {
			@apply relative mb-6 rounded-xl overflow-hidden w-full;
			background: var(--accent);
			div.blog-header {
				@apply px-4 pt-4;
				font-family: var(--header-text);
				h1 {
					@apply text-white text-4xl font-medium relative -left-0.5;
				}
				span.stat {
					@apply flex items-center;
				}
			}
		}
		section.blog-body {
			@apply mx-6 mb-8 text-[16px];
		}
	}
</style>
