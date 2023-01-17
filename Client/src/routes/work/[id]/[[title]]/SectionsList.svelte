<script lang="ts">
	import { onMount } from "svelte";
	import { account } from "$lib/state/account.state";
	import type { Section, Work } from "$lib/models/content/works";
	import {
		CheckboxCircleLine,
		CheckboxBlankCircleLine,
		DeleteBinLine,
		Loader5Line,
		PlayListAddLine,
		ListCheck2,
		BookOpenLine,
		BookLine,
		More2Fill
	} from "svelte-remixicon";
	import { slugify, localeDate } from "$lib/util/functions";
	import toast from "svelte-french-toast";
	import { getReq, patchReq, delReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import AddToVolumePrompt from "./AddToVolumePrompt.svelte";
	import DeleteSectionPrompt from "./DeleteSectionPrompt.svelte";
	import { openPopup } from "$lib/ui/popup";
	import type { ReadingHistory } from "$lib/models/content/library";
	import { abbreviate } from "$lib/util/functions/index.js";
	import Dropdown from "$lib/ui/dropdown/Dropdown.svelte";
	import Button from "$lib/ui/util/Button.svelte";

	export let work: Work;
	export let history: ReadingHistory;
	let sections: Section[] = [];
	let loading = false;
	let publishing = false;
	let deleting = false;
	let loadingVolumeAction = false;

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

	async function addToVolume(id: string) {
		openPopup(
			AddToVolumePrompt,
			{
				onConfirm: async () => {
					await fetchSections();
				}
			},
			{ sectionId: id, workId: work.id }
		);
	}

	async function removeFromVolume(id: string) {
		loadingVolumeAction = true;
		const response = await patchReq<void>(
			`/sections/remove-from-volume/${id}?workId=${work.id}&profileId=${$account.currProfile?.id}`,
			{}
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			await fetchSections();
		}
		loadingVolumeAction = false;
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
			<li class="section-item odd:bg-zinc-200 odd:dark:bg-zinc-700">
				{#if $account.account && $account.currProfile && $account.currProfile.id !== work.author.id}
					{#if history && history.sectionsRead.includes(section.id)}
						<Button inline={true} title="Read">
							<BookOpenLine />
						</Button>
					{:else}
						<Button inline={true} title="Unread">
							<BookLine />
						</Button>
					{/if}
				{/if}
				<a
					href="/work/{work.id}/{slugify(work.title)}/section/{section.id}/{slugify(
						section.title
					)}"
					data-sveltekit-preload-data
				>
					<span class="title">
						{section.title}
						{#if section.volume}
							<span class="mx-1 text-zinc-400 hidden lg:block">•</span>
							<span class="text-zinc-400 hidden lg:block">{section.volume.title}</span
							>
						{/if}
					</span>
					<span
						class="flex items-center text-xs lg:text-sm text-zinc-400 relative -top-0.5 lg:top-0"
					>
						{#if section.volume}
							<span class="text-zinc-400 block lg:hidden">
								{section.volume.title}
							</span>
							<span class="mx-1 block lg:hidden">•</span>
						{/if}
						<span class="words">{abbreviate(section.words)} words</span>
						<span class="mx-1">•</span>
						{#if section.publishedOn}
							<span>{localeDate(section.publishedOn, "shortDate")}</span>
						{:else}
							<span>{localeDate(section.createdAt, "shortDate")}</span>
						{/if}
					</span>
				</a>
				{#if $account.currProfile && $account.currProfile.id === work.author.id}
					<Dropdown inline={true} position="left-start">
						<svelte:fragment slot="button">
							<More2Fill class="button-icon no-text" size="18px" />
						</svelte:fragment>
						<svelte:fragment slot="items">
							{#if publishing}
								<button type="button">
									<Loader5Line class="animate-spin mr-2" />
									<span>Saving...</span>
								</button>
							{:else}
								<button
									on:click={() => publishSection(section.id)}
									title="Publish/Unpublish"
									type="button"
								>
									{#if section.publishedOn}
										<CheckboxCircleLine class="mr-2" />
										<span>Unpublish</span>
									{:else}
										<CheckboxBlankCircleLine class="mr-2" />
										<span>Publish</span>
									{/if}
								</button>
							{/if}
							{#if section.volume}
								<button
									title="Remove From Volume"
									type="button"
									disabled={loadingVolumeAction}
									on:click={() => removeFromVolume(section.id)}
								>
									{#if loadingVolumeAction}
										<Loader5Line class="animate-spin mr-2" />
									{:else}
										<ListCheck2 class="mr-2" />
										<span>Remove from Volume</span>
									{/if}
								</button>
							{:else}
								<button
									title="Add To Volume"
									type="button"
									on:click={() => addToVolume(section.id)}
								>
									<PlayListAddLine class="mr-2" />
									<span>Add to Volume</span>
								</button>
							{/if}
							<div class="divider"><!--divider--></div>
							<button
								type="button"
								disabled={deleting}
								on:click={() => deleteSection(section.id)}
							>
								{#if deleting}
									<Loader5Line class="animate-spin mr-2" />
									<span>Saving...</span>
								{:else}
									<DeleteBinLine class="mr-2" />
									<span>Delete</span>
								{/if}
							</button>
						</svelte:fragment>
					</Dropdown>
				{/if}
			</li>
		{/each}
	</ul>
{/if}

<style lang="scss">
	li.section-item {
		@apply w-full flex h-10;
		a {
			@apply flex-1 flex flex-col lg:flex-row lg:items-center no-underline text-sm transition transform h-full px-2;
			color: var(--text-color);
			span.title {
				@apply flex-1 flex items-center relative top-0.5 lg:top-0;
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
