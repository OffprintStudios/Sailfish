<script lang="ts">
	import { onMount } from "svelte";
	import { account } from "$lib/state/account.state";
	import type { Section, Work } from "$lib/models/content/works";
	import {
		CheckboxCircleLine,
		CheckboxBlankCircleLine,
		DeleteBinLine,
		Loader5Line
	} from "svelte-remixicon";
	import { slugify, localeDate } from "$lib/util/functions";
	import toast from "svelte-french-toast";
	import { getReq, patchReq, delReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import DeleteSectionPrompt from "./DeleteSectionPrompt.svelte";
	import { openPopup } from "$lib/ui/popup";

	export let work: Work;
	let sections: Section[] = [];
	let loading = false;
	let publishing = false;
	let deleting = false;

	onMount(async () => {
		await fetchSections();
	});

	async function fetchSections() {
		loading = true;
		if (
			$account.account &&
			$account.currProfile &&
			$account.currProfile.id === work.author.id
		) {
			const response = await getReq<Section[]>(`/sections/fetch-sections?workId=${work.id}`);
			if ((response as ResponseError).error) {
				const error = response as ResponseError;
				toast.error(error.message);
			} else {
				sections = response as Section[];
			}
		} else {
			const response = await getReq<Section[]>(
				`/sections/fetch-sections?workId=${work.id}&published=true`
			);
			if ((response as ResponseError).error) {
				const error = response as ResponseError;
				toast.error(error.message);
			} else {
				sections = response as Section[];
			}
		}
		loading = false;
	}

	async function publishSection(id: string) {
		publishing = true;
		const response = await patchReq<Section>(
			`/sections/publish-section/${id}?workId=${work.id}&profileId=${$account.currProfile?.id}`,
			{}
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			const section = response as Section;
			sections = sections.map((item) => (item.id === section.id ? section : item));
		}
		publishing = false;
	}

	async function deleteSection(id: string) {
		openPopup(DeleteSectionPrompt, {
			async onConfirm() {
				deleting = true;
				const response = await delReq<void>(
					`/sections/delete-section/${id}?workId=${work.id}&profileId=${$account.currProfile?.id}`
				);
				if ((response as ResponseError).error) {
					const error = response as ResponseError;
					toast.error(error.message);
				}
				deleting = false;
			}
		});
	}
</script>

{#if loading}
	<div class="empty">
		<h3>Loading...</h3>
		<p>Please wait for awesome.</p>
	</div>
{:else if sections.length === 0}
	<div class="empty">
		<h3>Nothing's been added yet!</h3>
		{#if $account.account && $account.currProfile && $account.currProfile.id === work.author.id}
			<p>Hit the Add Chapter button to hit the ground running.</p>
		{:else}
			<p>Come back later when there's something to read.</p>
		{/if}
	</div>
{:else}
	<ul class="mt-4 w-full">
		{#each sections as section}
			<li class="section-item odd:bg-zinc-300 odd:dark:bg-zinc-700">
				{#if $account.currProfile && $account.currProfile.id === work.author.id}
					{#if publishing}
						<button>
							<Loader5Line class="animate-spin" />
						</button>
					{:else}
						<button on:click={() => publishSection(section.id)}>
							{#if section.publishedOn}
								<CheckboxCircleLine class="button-icon no-text" />
							{:else}
								<CheckboxBlankCircleLine class="button-icon no-text" />
							{/if}
						</button>
					{/if}
				{/if}
				<a
					href="/prose/{work.id}/{slugify(work.title)}/section/{section.id}/{slugify(
						section.title
					)}"
					data-sveltekit-preload-data
				>
					<span class="title">{section.title}</span>
					<span class="words">{section.words} words</span>
					<span class="mx-1">•</span>
					{#if section.publishedOn}
						<span>{localeDate(section.publishedOn, "shortDate")}</span>
					{:else}
						<span>{localeDate(section.createdAt, "shortDate")}</span>
					{/if}
				</a>
				{#if $account.currProfile && $account.currProfile.id === work.author.id}
					{#if deleting}
						<button>
							<Loader5Line class="animate-spin" />
						</button>
					{:else}
						<button on:click={() => deleteSection(section.id)}>
							<DeleteBinLine class="button-icon no-text" />
						</button>
					{/if}
				{/if}
			</li>
		{/each}
	</ul>
{/if}

<style lang="scss">
	li.section-item {
		@apply w-full flex h-10;
		a {
			@apply flex-1 flex items-center no-underline text-sm transition transform h-full px-2;
			color: var(--text-color);
			span.title {
				@apply flex-1;
			}
			&:hover {
				background: var(--accent);
				@apply text-white;
			}
		}
		button {
			@apply h-full px-3 flex items-center;
			&:hover {
				@apply text-white;
				background: var(--accent);
			}
		}
	}
</style>
