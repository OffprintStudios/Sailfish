<script lang="ts">
	import { onMount } from "svelte";
	import { account } from "$lib/state/account.state";
	import type { Section, Work } from "$lib/models/content/works";
	import { BASE_URL } from "$lib/http";
	import toast from "svelte-french-toast";

	export let work: Work;
	let sections: Section[];
	let loading = false;

	onMount(async () => {
		await fetchSections();
	});

	async function fetchSections() {
		loading = true;
		if ($account.account && $account.currProfile && $account.currProfile.id === work.author.id) {
			const response = await fetch(`${BASE_URL}/sections/fetch-sections?workId=${work.id}`);
			if (response.status === 200) {
				sections = await response.json();
				loading = false;
			} else {
				toast.error(`Something went wrong fetching this work's sections. Try again in a little bit.`);
				loading = false;
			}
		} else {
			const response = await fetch(`${BASE_URL}/sections/fetch-sections?workId=${work.id}&published=true`);
			if (response.status === 200) {
				sections = await response.json();
				loading = false;
			} else {
				toast.error(`Something went wrong fetching this work's sections. Try again in a little bit.`);
				loading = false;
			}
		}
	}
</script>
