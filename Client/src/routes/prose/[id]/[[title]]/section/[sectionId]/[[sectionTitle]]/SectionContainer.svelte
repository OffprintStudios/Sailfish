<script lang="ts">
	import { onMount, createEventDispatcher } from "svelte";
	import type { Section, Work } from "$lib/models/content/works";
	import { slugify } from "$lib/util/functions";
	import { app } from "$lib/state/app.state";
	import {
		ArrowLeftSLine,
		ArrowRightSLine,
		FontSize,
		ListUnordered,
		Edit2Line,
		BookmarkLine
	} from "svelte-remixicon";
	import { Dropdown } from "$lib/ui/dropdown";
	import { account } from "$lib/state/account.state";
	import { SectionFont } from "$lib/models/util";
	import { Button } from "$lib/ui/util";

	export let work: Work;
	export let section: Section;
	export let allSections: Section[] = [];
	let prevLink = `/prose/${work.id}/${slugify(work.title)}/section/${section.id}/${slugify(
		section.title
	)}`;
	let nextLink = `/prose/${work.id}/${slugify(work.title)}/section/${section.id}/${slugify(
		section.title
	)}`;

	const published: Section[] = allSections.filter((item) => {
		if (item.publishedOn !== undefined) {
			return item;
		}
	});

	const dispatch = createEventDispatcher();

	onMount(() => {
		setFont();
		generatePrevLink(section);
		generateNextLink(section);
	});

	function generatePrevLink(thisSection: Section) {
		let sections = published;
		if (
			$account.account &&
			$account.currProfile &&
			$account.currProfile.id === work.author.id
		) {
			sections = allSections;
		}
		const idx = sections.findIndex((item) => item.id === thisSection.id);
		if (idx >= 1) {
			thisSection = sections[idx - 1];
		}
		prevLink = `/prose/${work.id}/${slugify(work.title)}/section/${thisSection.id}/${slugify(
			thisSection.title
		)}`;
	}

	function generateNextLink(thisSection: Section) {
		let sections = published;
		if (
			$account.account &&
			$account.currProfile &&
			$account.currProfile.id === work.author.id
		) {
			sections = allSections;
		}
		const idx = sections.findIndex((item) => item.id === thisSection.id);
		if (idx < sections.length - 1) {
			thisSection = sections[idx + 1];
		}
		nextLink = `/prose/${work.id}/${slugify(work.title)}/section/${thisSection?.id}/${slugify(
			thisSection.title
		)}`;
	}

	function changeFont(font: SectionFont) {
		$app.sectionFont = font;
		setFont();
	}

	function setFont() {
		switch ($app.sectionFont) {
			case SectionFont.inter:
				document.documentElement.style.setProperty("--section-text", `'Inter', sans-serif`);
				break;
			case SectionFont.josefinSlab:
				document.documentElement.style.setProperty(
					"--section-text",
					`'Josefin Slab', serif`
				);
				break;
			case SectionFont.libreBaskerville:
				document.documentElement.style.setProperty(
					"--section-text",
					`'Libre Baskerville', serif`
				);
				break;
			case SectionFont.ibmPlexMono:
				document.documentElement.style.setProperty(
					"--section-text",
					`'IBM Plex Mono', sans-serif`
				);
				break;
		}
	}

	function onEdit() {
		dispatch("edit");
	}
</script>

<div class="lg:rounded-xl lg:mb-6 dark:highlight-shadowed" style="background: var(--accent);">
	<div class="flex flex-col lg:flex-row items-center p-4">
		{#if work.coverArt}
			<div
				class="relative overflow-hidden bg-white border-4 border-white rounded-xl mb-2 lg:mb-0 lg:mr-4"
				style="box-shadow: var(--dropshadow);"
			>
				<img src={work.coverArt} alt="cover art" class="max-w-[150px] max-h-[110px]" />
			</div>
		{/if}
		<div class="flex-1 text-center lg:text-left">
			<h3 class="text-white font-light ml-0.5">
				<a class="text-white hover:text-white" href="/prose/{work.id}/{slugify(work.title)}"
					>{work.title}</a
				>
				<span class="text-white mx-[0.075rem] text-lg">•</span>
				<a
					class="text-white hover:text-white"
					href="/profile/{work.author.id}/{slugify(work.author.username)}"
					>{work.author.username}</a
				>
			</h3>
			<h1 class="text-white text-2xl lg:text-4xl">{section.title}</h1>
		</div>
	</div>
	<div
		class="flex items-center lg:mt-2 p-2 border-t-2"
		style="border-color: var(--accent-light);"
	>
		{#if $account.account && $account.currProfile && $account.currProfile.id === work.author.id}
			<Button kind="primary" on:click={onEdit}>
				<Edit2Line class="button-icon variable-text" />
				<span class="button-text hidden lg:block">Edit</span>
			</Button>
		{:else if $account.account && $account.currProfile}
			<Button kind="primary">
				<BookmarkLine class="button-icon variable-text" />
				<span class="button-text hidden lg:bock">Bookmark</span>
			</Button>
		{/if}
		<div class="mx-0.5"><!--spacer--></div>
		<Dropdown kind="primary">
			<svelte:fragment slot="button">
				<FontSize class="button-icon variable-text" />
				<span class="button-text hidden lg:block">Formatting</span>
			</svelte:fragment>
			<svelte:fragment slot="items">
				<button
					type="button"
					on:click={() => changeFont(SectionFont.inter)}
					class:active={$app.sectionFont === SectionFont.inter}
				>
					<span style="font-family: 'Inter', sans-serif;">Inter</span>
				</button>
				<button
					type="button"
					on:click={() => changeFont(SectionFont.josefinSlab)}
					class:active={$app.sectionFont === SectionFont.josefinSlab}
				>
					<span style="font-family: 'Josefin Slab', serif;">Josefin Slab</span>
				</button>
				<button
					type="button"
					on:click={() => changeFont(SectionFont.libreBaskerville)}
					class:active={$app.sectionFont === SectionFont.libreBaskerville}
				>
					<span style="font-family: 'Libre Baskerville', serif;">Libre Baskerville</span>
				</button>
				<button
					type="button"
					on:click={() => changeFont(SectionFont.ibmPlexMono)}
					class:active={$app.sectionFont === SectionFont.ibmPlexMono}
				>
					<span style="font-family: 'IBM Plex Mono', sans-serif;">Plex Mono</span>
				</button>
			</svelte:fragment>
		</Dropdown>
		<div class="flex-1"><!--spacer--></div>
		<Dropdown kind="primary" position="bottom-end">
			<svelte:fragment slot="button">
				<ListUnordered class="button-icon variable-text" />
				<span class="button-text hidden lg:block">Chapters</span>
			</svelte:fragment>
			<svelte:fragment slot="items">
				{#if $account.account && $account.currProfile && $account.currProfile.id === work.author.id}
					{#each allSections as thisSection}
						<a
							href="/prose/{work.id}/{slugify(
								work.title
							)}/section/{thisSection.id}/{slugify(thisSection.title)}"
						>
							<span>{thisSection.title}</span>
						</a>
					{:else}
						<span>No other chapters added yet</span>
					{/each}
				{:else}
					{#each published as thisSection}
						<a
							href="/prose/{work.id}/{slugify(
								work.title
							)}/section/{thisSection.id}/{slugify(thisSection.title)}"
						>
							<span>{thisSection.title}</span>
						</a>
					{:else}
						<span>No other chapters added yet</span>
					{/each}
				{/if}
			</svelte:fragment>
		</Dropdown>
	</div>
</div>

<div class="flex flex-col lg:rounded-xl bg-zinc-200 dark:bg-zinc-700 lg:dark:highlight-shadowed">
	{#key section}
		{#if section.noteTop}
			<div class="note mt-12 border-b-2 rounded-bl-xl">
				<h3>From the author&mdash;</h3>
				<div class="authors-note">
					{@html section.noteTop}
				</div>
			</div>
		{/if}
		<div class="section-body px-4 py-2 lg:px-12 lg:py-6">
			{@html section.body}
		</div>
		{#if section.noteBottom}
			<div class="note mb-12 border-t-2 rounded-tl-xl">
				<h3>From the author&mdash;</h3>
				<div class="authors-note">
					{@html section.noteBottom}
				</div>
			</div>
		{/if}
	{/key}
	<div class="flex items-center p-2 lg:rounded-xl bg-zinc-300 dark:bg-zinc-600 lg:mx-4 lg:mb-4">
		<a class="direction-button hover:bg-zinc-400 dark:hover:bg-zinc-500" href={prevLink}>
			<span><ArrowLeftSLine /></span>
			<span class="uppercase font-bold tracking-wider text-xs">Prev</span>
		</a>
		<div class="mx-0.5"><!--spacer--></div>
		<a class="direction-button hover:bg-zinc-400 dark:hover:bg-zinc-500" href={nextLink}>
			<span class="uppercase font-bold tracking-wider text-xs">Next</span>
			<span><ArrowRightSLine /></span>
		</a>
		<div class="flex-1"><!--spacer--></div>
		<Dropdown position="top-end">
			<svelte:fragment slot="button">
				<ListUnordered class="button-icon variable-text" />
				<span class="button-text hidden lg:block">Chapters</span>
			</svelte:fragment>
			<svelte:fragment slot="items">
				{#if $account.account && $account.currProfile && $account.currProfile.id === work.author.id}
					{#each allSections as thisSection}
						<a
							href="/prose/{work.id}/{slugify(
								work.title
							)}/section/{thisSection.id}/{slugify(thisSection.title)}"
						>
							<span>{thisSection.title}</span>
						</a>
					{:else}
						<span>No other chapters added yet</span>
					{/each}
				{:else}
					{#each published as thisSection}
						<a
							href="/prose/{work.id}/{slugify(
								work.title
							)}/section/{thisSection.id}/{slugify(thisSection.title)}"
						>
							<span>{thisSection.title}</span>
						</a>
					{:else}
						<span>No other chapters added yet</span>
					{/each}
				{/if}
			</svelte:fragment>
		</Dropdown>
	</div>
</div>

<style lang="scss">
	a.direction-button {
		@apply flex items-center px-2 py-2.5 transition transform no-underline rounded-lg;
		color: var(--text-color);
	}
	div.note {
		@apply px-4 py-3 mx-6 lg:mx-20 border-l-2;
		border-color: var(--accent);
		h3 {
			@apply text-2xl;
		}
	}
</style>
