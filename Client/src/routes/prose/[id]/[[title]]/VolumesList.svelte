<script lang="ts">
	import { onMount } from "svelte";
	import { account } from "$lib/state/account.state";
	import type { Volume, Work } from "$lib/models/content/works";
	import { BASE_URL } from "$lib/http";
	import toast from "svelte-french-toast";

	export let work: Work;
	let volumes: Volume[] = [];
	let loading = false;
	let deleting = false;

	onMount(async () => {
		await fetchVolumes();
	})

	async function fetchVolumes() {
		loading = true;
		const response = await fetch(`${BASE_URL}/volumes/fetch-volumes?workId=${work.id}`);
		if (response.status === 200) {
			volumes = await response.json();
			loading = false;
		} else {
			toast.error(`Something went wrong fetching this work's volumes. Try again in a little bit.`);
			loading = false;
		}
	}
</script>

{#if loading}
	<div class="empty">
		<h3>Loading...</h3>
		<p>Please wait for awesome.</p>
	</div>
{:else if volumes.length === 0}
	<div class="empty">
		<h3>Nothing's been added yet!</h3>
		{#if $account.account && $account.currProfile && $account.currProfile.id === work.author.id}
			<p>Hit the Add Volume button to hit the ground running.</p>
		{:else}
			<p>Come back later when there's something to check out.</p>
		{/if}
	</div>
{:else}
{/if}
