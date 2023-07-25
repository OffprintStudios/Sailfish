<script lang="ts">
	import type { Paginate } from "$lib/util/types";
	import type { Profile } from "$lib/models/accounts";
	import { onMount } from "svelte";
	import { getReq, type ResponseError } from "$lib/http";
	import { account } from "$lib/state/account.state";
	import toast from "svelte-french-toast";
	import { page } from "$app/stores";
	import FollowCard from "./FollowCard.svelte";

	$: currPage = +($page.url.searchParams.get("page") ?? "1");
	$: perPage = +($page.url.searchParams.get("per") ?? "24");
	let loading = false;
	let recentUpdates: Paginate<Profile> = {
		items: [],
		metadata: {
			page: 1,
			per: 10,
			total: 0
		}
	};

	onMount(async () => {
		if ($account.account && $account.currProfile) {
			await fetchFollows(currPage);
		}
	});

	async function fetchFollows(newPage: number) {
		loading = true;
		$page.url.searchParams.set("page", `${newPage}`);
		const response = await getReq<Paginate<Profile>>(
			`/followers/fetch-following/${$account.currProfile?.id}?page=${newPage}&per=${perPage}`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			recentUpdates = response as Paginate<Profile>;
		}
		loading = false;
	}
</script>

{#if $account.account && $account.currProfile}
	{#if loading}
		<div class="empty">
			<h3>Loading...</h3>
		</div>
	{:else if recentUpdates.metadata.total === 0}
		<div class="empty">
			<h3>You haven't followed anyone yet</h3>
			<p>Check out the community to find people you'd want to see more of!</p>
		</div>
	{:else}
		<div class="max-w-6xl mx-auto grid grid-cols-1 lg:grid-cols-8 gap-4">
			{#each recentUpdates.items as follow}
				<FollowCard profile={follow} />
			{/each}
		</div>
	{/if}
{:else if $account.account}
	<div class="empty">
		<h3>No Profile Selected</h3>
		<p>Open up the Guide and select a profile to view this page.</p>
	</div>
{:else}
	<div class="empty">
		<h3>Not Logged In</h3>
		<p>You must be logged in to use this feature.</p>
	</div>
{/if}
