<script lang="ts">
	import type { PageData } from "./$types";
	import type { Paginate } from "$lib/util/types";
	import type { Profile } from "$lib/models/accounts";
	import { page } from "$app/stores";
	import { getReq, type ResponseError } from "$lib/http";
	import { ProfileCard } from "$lib/ui/content";
	import { Paginator } from "$lib/ui/util";
	import { account } from "$lib/state/account.state";
	import toast from "svelte-french-toast";

	export let data: PageData;
	let currPage: Paginate<Profile> = {
		items: data.items,
		metadata: data.metadata
	};
	$: pageNum = +($page.url.searchParams.get("page") ?? "1");
	$: perPage = +($page.url.searchParams.get("per") ?? "21");
	let loading = false;

	async function fetchPage(newPage: number) {
		loading = true;
		$page.url.searchParams.set("page", `${newPage}`);
		$page.url.searchParams.set("per", `${perPage}`);
		const response = await getReq<Paginate<Profile>>(
			`/followers/fetch-following/${data.id}?page=${pageNum}&per=${perPage}`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			currPage = response as Paginate<Profile>;
		}
		loading = false;
	}
</script>

<svelte:head>
	<title>{data.username}'s Follows &mdash; Offprint</title>
</svelte:head>

<div class="max-w-6xl mx-auto">
	<div class="flex items-center mb-6 pb-2 border-b border-zinc-700 dark:border-white">
		<h2 class="text-3xl">Following</h2>
	</div>
	{#if currPage.metadata.total === 0}
		<div class="empty">
			{#if $account.account && $account.currProfile && $account.currProfile?.id === data.id}
				<h3>You're not following anyone yet</h3>
				<p>Hit the Follow button on someone's profile and they'll show up here!</p>
			{:else}
				<h3>This user isn't following anyone</h3>
				<p>Come back later to see if that changes!</p>
			{/if}
		</div>
	{:else}
		<div class="grid grid-cols-1 lg:grid-cols-3 gap-4">
			{#each currPage.items as following}
				<ProfileCard profile={following} showOptions={false} />
			{/each}
		</div>
	{/if}
	{#if currPage.metadata.total > 0}
		<Paginator
			currPage={pageNum}
			{perPage}
			bind:loading
			totalItems={currPage.metadata.total}
			on:change={(event) => fetchPage(event.detail)}
		/>
	{/if}
</div>
