<script lang="ts">
	import { page } from "$app/stores";
	import { getReq, type ResponseError } from "$lib/http";
	import { createForm } from "felte";
	import { SearchEyeLine } from "svelte-remixicon";
	import { Category } from "$lib/models/content/works";
	import type { Paginate } from "$lib/util/types";
	import type { Work } from "$lib/models/content/works";
	import type { Blog } from "$lib/models/content";
	import type { Profile } from "$lib/models/accounts";

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

	$: currPage = +($page.url.searchParams.get("page") ?? "1");
	$: perPage = +($page.url.searchParams.get("per") ?? "1");
	let loading = false;
	let url = `/search`;
	let workResults: Paginate<Work>;
	let blogResults: Paginate<Blog>;
	let userResults: Paginate<Profile>;

	const { form, data } = createForm({
		onSubmit: async (values, context) => {
			let categories: Category[] = [];
			if (values.categories === Categories.All) {
				categories = [Category.Original, Category.Fanwork];
			} else if (values.categories === Categories.Original) {
				categories = [Category.Original];
			} else {
				categories = [Category.Fanwork];
			}

			if (values.searchFor === SearchFor.Works) {
				url =
					`/search/${values.searchFor}?` +
					`title=${values.query}&` +
					`username=${values.author}&` +
					`categories=${categories.join(",")}`;
			} else if (values.searchFor === SearchFor.Blogs) {
				url =
					`/search/${values.searchFor}?` +
					`title=${values.query}&` +
					`username=${values.author}`;
			} else {
				url = `/search/${values.searchFor}?username=${values.query}`;
			}
		},
		initialValues: {
			query: "",
			author: "",
			searchFor: SearchFor.Works,
			categories: Categories.All
		}
	});

	async function fetchResults(newPage: number) {
		loading = true;
		$page.url.searchParams.set("page", `${newPage}`);
		$page.url.searchParams.set("per", `${perPage}`);
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
			<button class="search-button">
				<SearchEyeLine size="32px" class="text-white" />
			</button>
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
