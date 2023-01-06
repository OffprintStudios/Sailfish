<script lang="ts">
	import { page } from "$app/stores";
	import { createForm } from "felte";
	import type { Profile } from "$lib/models/accounts";
	import type { Blog, BlogForm } from "$lib/models/content";
	import { ContentRating } from "$lib/models/content";
	import { account } from "$lib/state/account.state";
	import { CupLine, AddLine } from "svelte-remixicon";
	import { TextField, TextArea, Editor } from "$lib/ui/forms";
	import { Button } from "$lib/ui/util";
	import { goto } from "$app/navigation";
	import { slugify, hasRoles } from "$lib/util/functions";
	import { postReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import { Roles } from "$lib/models/accounts";
	import toast from "svelte-french-toast";

	const profile = $page.data as Profile;

	const { form, data, errors, isSubmitting } = createForm({
		async onSubmit(values) {
			const response = await postReq<Blog>(
				`/blogs/create?profileId=${$account.currProfile?.id}`,
				values as BlogForm
			);
			if ((response as ResponseError).error) {
				const error = response as ResponseError;
				toast.error(error.message);
			} else {
				const blog = response as Blog;
				await goto(
					`/profile/${profile.id}/${slugify(profile.username)}/blog/${blog.id}/${slugify(
						blog.title
					)}`
				);
			}
		},
		validate(values) {
			const errors = {
				title: "",
				desc: "",
				body: ""
			};

			if (!values.title || values.title.length < 3 || values.title.length > 120) {
				errors.title = `Your title needs to be between 3 and 120 characters.`;
			}

			if (values.desc && (values.desc.length < 3 || values.desc.length > 240)) {
				errors.desc = `Your description needs to be between 3 and 240 characters.`;
			}

			if (!values.body || values.body.length < 3) {
				errors.body = `Your post needs to be more than 3 characters.`;
			}

			return errors;
		},
		initialValues: {
			title: null,
			desc: null,
			body: null,
			rating: ContentRating.Everyone,
			newsPost: false
		}
	});
</script>

<svelte:head>
	<title>Create a New Blog &mdash; Offprint</title>
</svelte:head>

{#if $account.account && $account.currProfile && $account.currProfile.id === profile.id}
	<form
		class="max-w-4xl mx-auto rounded-xl overflow-hidden flex flex-col bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed"
		use:form
	>
		<div
			class="flex flex-row items-center justify-center px-2 py-4"
			style="background: var(--accent);"
		>
			<CupLine class="text-white mr-2 w-[36px] h-[36px] lg:w-[48px] lg:h-[48px]" />
			<h1 class="text-white text-2xl lg:text-4xl">Create a New Blog</h1>
		</div>
		<div class="flex flex-col lg:flex-row border-b border-zinc-400 dark:border-zinc-500">
			<div
				class="w-full lg:w-1/4 flex items-center lg:flex-col lg:items-end px-4 pt-2 pb-0 lg:pt-2 lg:pb-3 lg:border-r border-zinc-400 dark:border-zinc-500"
			>
				<h3 class="text-lg" style="color: var(--text-color);">Title</h3>
				<div class="flex-1 lg:hidden"><!--spacer--></div>
				<span class="text-xs italic text-zinc-400 lg:mb-1">120 characters max</span>
				<span class="text-xs italic text-zinc-400 text-right hidden lg:block">
					What's the name of your blog?
				</span>
			</div>
			<div class="lg:w-3/4 px-2.5 flex flex-col items-center justify-center">
				<TextField
					name="title"
					type="text"
					placeholder="Just Another Rundown"
					errorMessage={$errors.title}
					kind="primary"
				/>
			</div>
		</div>
		<div class="flex flex-col lg:flex-row border-b border-zinc-400 dark:border-zinc-500">
			<div
				class="w-full lg:w-1/4 flex items-center lg:flex-col lg:items-end px-4 pt-2 pb-0 lg:pt-2 lg:pb-3 lg:border-r border-zinc-400 dark:border-zinc-500"
			>
				<h3 class="text-lg" style="color: var(--text-color);">Description</h3>
				<div class="flex-1 lg:hidden"><!--spacer--></div>
				<span class="text-xs italic text-zinc-400 lg:mb-1"
					>240 characters max (Optional)</span
				>
				<span class="text-xs italic text-zinc-400 text-right hidden lg:block"
					>What's the gist of your post? Don't worry, this part's optional.</span
				>
			</div>
			<div class="w-full lg:w-3/4 px-2.5 flex flex-col items-center justify-center">
				<TextArea
					name="desc"
					type="text"
					placeholder="A journey of a thousand words"
					errorMessage={$errors.desc}
					kind="primary"
				/>
			</div>
		</div>
		<div class="flex flex-col lg:flex-row border-b border-zinc-400 dark:border-zinc-500">
			<div
				class="w-full lg:w-1/4 flex items-center lg:flex-col lg:items-end px-4 pt-2 pb-0 lg:pt-2 lg:pb-3 lg:border-r border-zinc-400 dark:border-zinc-500"
			>
				<h3 class="text-lg" style="color: var(--text-color);">Body</h3>
				<span class="text-xs italic text-zinc-400 text-right hidden lg:block">
					Here's where the magic happens. Put the content of your blog here.
				</span>
			</div>
			<div class="w-full lg:w-3/4 px-2.5 py-2.5">
				<Editor kind="primary" bind:value={$data.body} />
			</div>
		</div>
		<div class="bg-zinc-300 dark:bg-zinc-600 border-b border-zinc-400 dark:border-zinc-500 p-3">
			<h2 class="text-xl" style="color: var(--text-color);">Metadata</h2>
		</div>
		<div class="flex flex-col lg:flex-row border-b border-zinc-400 dark:border-zinc-500">
			<div
				class="w-full lg:w-1/4 flex items-center lg:flex-col lg:items-end px-4 pt-2 pb-0 lg:pt-2 lg:pb-3 lg:border-r border-zinc-400 dark:border-zinc-500"
			>
				<h3 class="text-lg" style="color: var(--text-color);">Rating</h3>
				<span class="text-xs italic text-zinc-400 text-right hidden lg:block">
					Check out the Offprint Omnibus for info about which one would be appropriate for
					your blog.
				</span>
			</div>
			<div
				class="w-full lg:w-3/4 px-2.5 py-2.5 grid grid-cols-2 lg:grid-cols-4 whitespace-nowrap lg:whitespace-normal"
			>
				<div
					class="flex flex-col p-4 bg-red-700 bg-opacity-10 rounded-tl-xl lg:rounded-l-xl border border-red-500 w-[220px] lg:w-auto"
				>
					<label class="mb-2">
						<input
							type="radio"
							value={ContentRating.Everyone}
							bind:group={$data.rating}
						/>
						<span class="font-bold uppercase ml-1 relative top-[0.075rem]"
							>Everyone</span
						>
					</label>
					<div class="text-xs hidden lg:block">Not even a swear word.</div>
				</div>
				<div
					class="flex flex-col p-4 bg-red-700 bg-opacity-10 rounded-tr-xl lg:rounded-tr-none border-y border-r border-red-500"
				>
					<label class="mb-2">
						<input type="radio" value={ContentRating.Teen} bind:group={$data.rating} />
						<span class="font-bold uppercase ml-0.5 relative top-[0.075rem]">Teen</span>
					</label>
					<div class="text-xs hidden lg:block">Suitable for most works.</div>
				</div>
				<div
					class="flex flex-col p-4 bg-red-700 bg-opacity-10 border-l border-t-0 border-b rounded-bl-xl lg:rounded-none lg:border-l-0 lg:border-y border-red-500"
				>
					<label class="mb-2">
						<input
							type="radio"
							value={ContentRating.Mature}
							bind:group={$data.rating}
						/>
						<span class="font-bold uppercase ml-0.5 relative top-[0.075rem]"
							>Mature</span
						>
					</label>
					<div class="text-xs hidden lg:block">Heavy topics, but nothing explicit.</div>
				</div>
				<div
					class="flex flex-col p-4 bg-red-700 bg-opacity-10 rounded-br-xl lg:rounded-r-xl border-t-0 border lg:border-t border-red-500"
				>
					<label class="mb-2">
						<input
							type="radio"
							value={ContentRating.Explicit}
							bind:group={$data.rating}
						/>
						<span class="font-bold uppercase ml-0.5 relative top-[0.075rem]"
							>Explicit</span
						>
					</label>
					<div class="text-xs hidden lg:block">
						Like Mature, but goes into greater detail.
					</div>
				</div>
			</div>
		</div>
		{#if hasRoles($account.account?.roles, [Roles.Admin, Roles.Moderator, Roles.Contributor])}
			<div class="flex flex-col lg:flex-row border-b border-zinc-400 dark:border-zinc-500">
				<div
					class="w-full lg:w-1/4 flex items-center lg:flex-col lg:items-end px-4 pt-2 pb-0 lg:pt-2 lg:pb-3 lg:border-r border-zinc-400 dark:border-zinc-500"
				>
					<h3 class="text-lg" style="color: var(--text-color);">News Post</h3>
					<span class="text-xs italic text-zinc-400 text-right hidden lg:block">
						Is this a news post? If so, change this setting so that it's visible on the
						front page!
					</span>
				</div>
				<div class="w-full lg:w-3/4 px-2.5 py-2.5 grid grid-cols-2">
					<div
						class="flex flex-col p-4 bg-orange-700 bg-opacity-10 rounded-l-xl border border-orange-500"
					>
						<label class="mb-2">
							<input type="radio" value={true} bind:group={$data.newsPost} />
							<span class="font-bold uppercase ml-0.5 relative top-[0.075rem]"
								>Mark As News</span
							>
						</label>
						<div class="text-xs hidden lg:block">
							This will show up on the front page.
						</div>
					</div>
					<div
						class="flex flex-col p-4 bg-green-700 bg-opacity-10 rounded-r-xl border-y border-r border-green-500"
					>
						<label class="mb-2">
							<input type="radio" value={false} bind:group={$data.newsPost} />
							<span class="font-bold uppercase ml-0.5 relative top-[0.075rem]"
								>Mark As Blog</span
							>
						</label>
						<div class="text-xs hidden lg:block">This is just your personal entry.</div>
					</div>
				</div>
			</div>
		{/if}
		<div class="flex items-center justify-center bg-zinc-300 dark:bg-zinc-600 p-3">
			<Button type="submit" loading={$isSubmitting} loadingText="Saving...">
				<AddLine class="button-icon" />
				<span class="button-text">Create And Save</span>
			</Button>
		</div>
	</form>
{:else}
	<div class="empty">
		<h3>You aren't allowed to view this page</h3>
		<p>Instead, how about looking up some pictures of cute cats?</p>
	</div>
{/if}
