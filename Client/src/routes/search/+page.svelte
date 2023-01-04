<script lang="ts">
	import { page } from "$app/stores";
	import { getReq, type ResponseError } from "$lib/http";
	import { createForm } from "felte";
	import { SearchEyeLine, Loader5Line } from "svelte-remixicon";
	import { Category } from "$lib/models/content/works";
	import type { Paginate } from "$lib/util/types";
	import type { Work } from "$lib/models/content/works";
	import type { Blog } from "$lib/models/content";
	import type { Profile } from "$lib/models/accounts";
	import { WorkCard, BlogCard, ProfileCard } from "$lib/ui/content";
	import { Paginator } from "$lib/ui/util";
	import toast from "svelte-french-toast";
	import { app } from "$lib/state/app.state";

	enum SearchFor {
		Works = "works",
		Blogs = "blogs",
		Users = "users"
	}

	enum Categories {
		All = "All Categories",
		Original = "Original Fiction",
		Fanfiction = "Fan-Fiction"
	}

	let loading = false;
	let url = `/search`;
	let workResults: Paginate<Work> = {
		items: [],
		metadata: { page: 1, per: 12, total: 0 }
	};
	let blogResults: Paginate<Blog> = {
		items: [],
		metadata: { page: 1, per: 12, total: 0 }
	};
	let userResults: Paginate<Profile> = {
		items: [],
		metadata: { page: 1, per: 12, total: 0 }
	};

	const { form, data, isSubmitting } = createForm({
		onSubmit: async (values) => {
			url = `/search`;
			workResults = { items: [], metadata: { page: 1, per: 12, total: 0 } };
			blogResults = { items: [], metadata: { page: 1, per: 12, total: 0 } };
			userResults = { items: [], metadata: { page: 1, per: 12, total: 0 } };

			let categories: Category[] = [];
			if (values.categories === Categories.All) {
				categories = [Category.Original, Category.Fanwork];
			} else if (values.categories === Categories.Original) {
				categories = [Category.Original];
			} else {
				categories = [Category.Fanwork];
			}
			if (values.searchFor === SearchFor.Works) {
				url = `/search/${values.searchFor}?filter=${$app.filter}&`;
				if (values.query !== null && values.query !== "") {
					url = url + `title=${values.query}&`;
				}
				if (values.author !== null && values.author !== "") {
					url = url + `username=${values.author}&`;
				}
				if (categories.length > 0) {
					url = url + `categories=${categories.join(",")}`;
				}
				await fetchWorkResults(1);
			} else if (values.searchFor === SearchFor.Blogs) {
				url = `/search/${values.searchFor}?filter=${$app.filter}&`;
				if (values.query !== null && values.query !== "") {
					url = url + `title=${values.query}&`;
				}
				if (values.author !== null && values.author !== "") {
					url = url + `username=${values.author}`;
				}
				await fetchBlogResults(1);
			} else {
				url = `/search/${values.searchFor}?`;
				if (values.query !== null && values.query !== "") {
					url = url + `username=${values.query}`;
				}
				await fetchUserResults(1);
			}
		},
		initialValues: {
			query: null,
			author: null,
			searchFor: SearchFor.Works,
			categories: Categories.All
		}
	});

	async function fetchWorkResults(newPage: number) {
		loading = true;
		$page.url.searchParams.set("page", `${newPage}`);
		const response = await getReq<Paginate<Work>>(`${url}&page=${newPage}&per=${12}`);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			workResults = response as Paginate<Work>;
		}
		loading = false;
	}

	async function fetchBlogResults(newPage: number) {
		loading = true;
		$page.url.searchParams.set("page", `${newPage}`);
		const response = await getReq<Paginate<Blog>>(`${url}&page=${newPage}&per=${12}`);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			blogResults = response as Paginate<Blog>;
		}
		loading = false;
	}

	async function fetchUserResults(newPage: number) {
		loading = true;
		$page.url.searchParams.set("page", `${newPage}`);
		const response = await getReq<Paginate<Profile>>(`${url}&page=${newPage}&per=${12}`);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			userResults = response as Paginate<Profile>;
		}
		loading = false;
	}
</script>

<svelte:head>
	<title>Search &mdash; Offprint</title>
</svelte:head>

<div class="max-w-7xl mx-auto">
	<form
		class="max-w-5xl mx-auto my-6 rounded-xl overflow-hidden bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed"
		use:form
	>
		<div class="flex border-b-2 border-zinc-300 dark:border-zinc-600">
			<input
				type="text"
				name="query"
				class="w-full bg-transparent border-0 focus:ring-0 text-2xl leading-3 placeholder:relative placeholder:top-0.5"
				style="font-family: var(--header-text);"
				placeholder="What's on the menu today?"
			/>
			{#if $isSubmitting}
				<button class="search-button" type="button">
					<Loader5Line size="32px" class="animate-spin text-white" />
				</button>
			{:else}
				<button class="search-button" type="submit">
					<SearchEyeLine size="32px" class="text-white" />
				</button>
			{/if}
		</div>
		<div
			class="flex items-center px-4"
			class:py-4={$data.searchFor !== SearchFor.Works && $data.searchFor !== SearchFor.Blogs}
			class:py-2={$data.searchFor === SearchFor.Works || $data.searchFor === SearchFor.Blogs}
		>
			<fieldset name="searchFor" class="text-base relative -top-0.5">
				<label>
					<input type="radio" value={SearchFor.Works} name="searchFor" />
					<span class="relative top-0.5">Works</span>
				</label>
				<label class="mx-2">
					<input type="radio" value={SearchFor.Blogs} name="searchFor" />
					<span class="relative top-0.5">Blogs</span>
				</label>
				<label>
					<input type="radio" value={SearchFor.Users} name="searchFor" />
					<span class="relative top-0.5">Users</span>
				</label>
			</fieldset>
			<div class="flex-1"><!--spacer--></div>
			{#if $data.searchFor === SearchFor.Works || $data.searchFor === SearchFor.Blogs}
				<input
					type="text"
					name="author"
					class="w-[200px] bg-zinc-300 dark:bg-zinc-600 border-0 focus:ring-0 rounded-xl"
					class:w-[200px]={$data.searchFor === SearchFor.Works}
					class:w-[250px]={$data.searchFor === SearchFor.Blogs}
					placeholder="Author"
				/>
			{/if}
			{#if $data.searchFor === SearchFor.Works}
				<select
					name="categories"
					class="ml-2 bg-zinc-300 dark:bg-zinc-600 rounded-xl border-0 w-[200px] focus:ring-0"
				>
					<option value={Categories.All}>{Categories.All}</option>
					<option value={Categories.Original}>{Categories.Original}</option>
					<option value={Categories.Fanfiction}>{Categories.Fanfiction}</option>
				</select>
			{/if}
		</div>
	</form>
	<div class="w-11/12 mx-auto">
		{#if loading}
			<div class="empty">
				<h3>Loading...</h3>
			</div>
		{:else if $data.searchFor === SearchFor.Works}
			{#if workResults.metadata.total === 0}
				<div class="empty">
					<h3>You haven't searched for anything yet</h3>
					<p>Type your query in the form above to get started!</p>
				</div>
			{:else}
				<div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
					{#each workResults.items as work}
						<WorkCard {work} withDropdown={false} />
					{/each}
				</div>
				<Paginator
					currPage={workResults.metadata.page}
					perPage={workResults.metadata.per}
					totalItems={workResults.metadata.total}
					on:change={(event) => fetchWorkResults(event.detail)}
				/>
			{/if}
		{:else if $data.searchFor === SearchFor.Blogs}
			{#if blogResults.metadata.total === 0}
				<div class="empty">
					<h3>You haven't searched for anything yet</h3>
					<p>Type your query in the form above to get started!</p>
				</div>
			{:else}
				<div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
					{#each blogResults.items as blog}
						<BlogCard {blog} hasDropdown={false} showAvatar={true} />
					{/each}
				</div>
				<Paginator
					currPage={blogResults.metadata.page}
					perPage={blogResults.metadata.per}
					totalItems={blogResults.metadata.total}
					on:change={(event) => fetchBlogResults(event.detail)}
				/>
			{/if}
		{:else if userResults.metadata.total === 0}
			<div class="empty">
				<h3>You haven't searched for anything yet</h3>
				<p>Type your query in the form above to get started!</p>
			</div>
		{:else}
			<div class="grid grid-cols-1 lg:grid-cols-3 gap-4">
				{#each userResults.items as profile}
					<ProfileCard {profile} showOptions={false} />
				{/each}
			</div>
			<Paginator
				currPage={userResults.metadata.page}
				perPage={userResults.metadata.per}
				totalItems={userResults.metadata.total}
				on:change={(event) => fetchUserResults(event.detail)}
			/>
		{/if}
	</div>
</div>

<style lang="scss">
	button.search-button {
		@apply p-4 transition;
		background: var(--accent);
		&:hover {
			background: var(--accent-light);
		}
	}
</style>
