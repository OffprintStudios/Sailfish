<script lang="ts">
	import { onMount } from "svelte";
	import { profileState } from "$lib/state/profile.state";
	import { account } from "$lib/state/account.state";
	import { createForm } from "felte";
	import { AddLine, QuillPenLine } from "svelte-remixicon";
	import { Editor, RadioButton, TextField } from "$lib/ui/forms";
	import { ContentRating } from "$lib/models/content";
	import { Button } from "$lib/ui/util";
	import type { Tag } from "$lib/models/tags";
	import { TagKind } from "$lib/models/tags";
	import { Category, Kind, Status } from "$lib/models/content/works";
	import type { WorkForm } from "$lib/models/content/works";
	import { TagBadge } from "$lib/ui/content";
	import toast from "svelte-french-toast";

	let genres: {tag: Tag, isChosen: boolean}[] = [];

	onMount(async () => {
		await fetchGenres();
	});

	async function fetchGenres() {
		const response = await fetch(`/api/content/tags/fetch-tags?kind=${TagKind.genre}&withCounts=false&ascending=true`);
		const val = await response.json();
		genres = val.data;
	}

	function selectGenre(genre: { tag: Tag, isChosen: boolean }) {
		if ($data.tags.some(val => val === genre.tag.id)) {
			genre.isChosen = false;
			$data.tags = $data.tags.filter(val => val !== genre.tag.id);
			genres = genres.map(val => {
				if (val.tag.id === genre.tag.id) {
					return genre;
				} else {
					return val;
				}
			});
		} else if ($data.tags.length === 3) {
			toast.error(`You can't have more than 3 genre tags!`);
		} else {
			genre.isChosen = true;
			$data.tags.push(genre.tag.id);
			genres = genres.map(val => {
				if (val.tag.id === genre.tag.id) {
					return genre;
				} else {
					return val;
				}
			});
		}
	}

	const { form, errors, data } = createForm<WorkForm>({
		initialValues: {
			title: null,
			shortDesc: null,
			longDesc: null,
			category: Category.Original,
			rating: ContentRating.Everyone,
			status: Status.Incomplete,
			tags: [],
		}
	});
</script>

{#if $account.account && $account.currProfile && $account.currProfile.id === $profileState.id}
	<form class="max-w-4xl mx-auto rounded-xl overflow-hidden flex flex-col bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed" use:form>
		<div class="flex items-center justify-center px-2 py-4" style="background: var(--accent);">
			<QuillPenLine size="48px" class="text-white mr-2" />
			<h1 class="text-white text-4xl">Create a New Work</h1>
		</div>
		<div class="flex border-b border-zinc-400 dark:border-zinc-500">
			<div class="w-1/4 flex flex-col items-end px-4 pt-2 pb-3 border-r border-zinc-400 dark:border-zinc-500">
				<h3 class="text-lg" style="color: var(--text-color);">Category</h3>
				<span class="text-xs italic text-zinc-400 text-right">
					First thing's first. Is this an original work, or a fan work?
				</span>
			</div>
			<div class="w-3/4 px-2.5 py-2.5 flex items-center justify-center">
				<div class="flex flex-col p-4 bg-green-700 bg-opacity-10 rounded-xl border border-green-500 w-[250px] h-[111px]">
					<label class="mb-2">
						<input type="radio" value={Category.Original} bind:group={$data.category} />
						<span class="font-bold uppercase ml-0.5 relative top-[0.075rem]">Original Work</span>
					</label>
					<div class="text-xs">
						Wholly original content&mdash;written, owned, and published by you, stories yet untold.
					</div>
				</div>
				<div class="mx-1"><!--spacer--></div>
				<div class="flex flex-col p-4 bg-cyan-700 bg-opacity-10 rounded-xl border border-cyan-500 w-[250px] h-[111px]">
					<label class="mb-2">
						<input type="radio" value={Category.Fanwork} bind:group={$data.category} />
						<span class="font-bold uppercase ml-0.5 relative top-[0.075rem]">Fan Work</span>
					</label>
					<div class="text-xs">
						Derivative works&mdash;labors of love and naval combat, inspired by worlds of other origin.
					</div>
				</div>
			</div>
		</div>
		<div class="bg-zinc-300 dark:bg-zinc-600 border-b border-zinc-400 dark:border-zinc-500 p-3">
			<h2 class="text-xl" style="color: var(--text-color);">General Info</h2>
		</div>
		<div class="flex border-b border-zinc-400 dark:border-zinc-500">
			<div class="w-1/4 flex flex-col items-end px-4 pt-2 pb-3 border-r border-zinc-400 dark:border-zinc-500">
				<h3 class="text-lg" style="color: var(--text-color);">Title</h3>
				<span class="text-xs italic text-zinc-400 mb-1">120 characters max</span>
				<span class="text-xs italic text-zinc-400 text-right">What's your work called?</span>
			</div>
			<div class="w-3/4 px-2.5 flex flex-col items-center justify-center">
				<TextField
					name="title"
					type="text"
					placeholder="Another Great Adventure"
					errorMessage={$errors.title}
					kind="primary"
				/>
			</div>
		</div>
		<div class="flex border-b border-zinc-400 dark:border-zinc-500">
			<div class="w-1/4 flex flex-col items-end px-4 pt-2 pb-3 border-r border-zinc-400 dark:border-zinc-500">
				<h3 class="text-lg" style="color: var(--text-color);">Short Description</h3>
				<span class="text-xs italic text-zinc-400 mb-1">240 characters max</span>
				<span class="text-xs italic text-zinc-400 text-right">What's the basic idea of your work? Make it punchy!</span>
			</div>
			<div class="w-3/4 px-2.5 flex flex-col items-center justify-center">
				<TextField
					name="shortDesc"
					type="text"
					placeholder="A journey of a thousand words"
					errorMessage={$errors.shortDesc}
					kind="primary"
				/>
			</div>
		</div>
		<div class="flex border-b border-zinc-400 dark:border-zinc-500">
			<div class="w-1/4 flex flex-col items-end px-4 pt-2 pb-3 border-r border-zinc-400 dark:border-zinc-500">
				<h3 class="text-lg" style="color: var(--text-color);">Long Description</h3>
				<span class="text-xs italic text-zinc-400 text-right">
					Now set the stage&mdash;what's your work all about?
				</span>
			</div>
			<div class="w-3/4 px-2.5 py-2.5">
				<Editor kind="primary" bind:value={$data.longDesc} />
			</div>
		</div>
		<div class="bg-zinc-300 dark:bg-zinc-600 border-b border-zinc-400 dark:border-zinc-500 p-3">
			<h2 class="text-xl" style="color: var(--text-color);">Tags</h2>
		</div>
		<div class="flex border-b border-zinc-400 dark:border-zinc-500">
			<div class="w-1/4 flex flex-col items-end px-4 pt-2 pb-3 border-r border-zinc-400 dark:border-zinc-500">
				<h3 class="text-lg" style="color: var(--text-color);">Genres</h3>
				<span class="text-xs italic text-zinc-400 mb-1">3 max, 1 minimum</span>
				<span class="text-xs italic text-zinc-400 text-right">
					What genres do you think apply here? Don't worry, you can always change this later.
				</span>
			</div>
			<div class="w-3/4 px-2.5 py-2.5 flex justify-center  flex-wrap">
				{#each genres as genre}
					<div class="mx-[0.075rem] px-0.5 pb-1 rounded-lg border border-transparent" class:border-blue-300={genre.isChosen}>
						<TagBadge tag={genre.tag} kind={genre.tag.kind} on:click={() => selectGenre(genre)} />
					</div>
				{/each}
			</div>
		</div>
		{#if $data.category === Category.Fanwork}
			<div class="flex border-b border-zinc-400 dark:border-zinc-500">
				<div class="w-1/4 flex flex-col items-end px-4 pt-2 pb-3 border-r border-zinc-400 dark:border-zinc-500">
					<h3 class="text-lg" style="color: var(--text-color);">Fandoms</h3>
					<span class="text-xs italic text-zinc-400 mb-1">3 max, 1 minimum</span>
					<span class="text-xs italic text-zinc-400 text-right">
					What worlds are you enhancing? Make sure to only include the most pertinent ones!
				</span>
				</div>
				<div class="w-3/4 px-2.5 py-2.5">

				</div>
			</div>
		{/if}
		<div class="bg-zinc-300 dark:bg-zinc-600 border-b border-zinc-400 dark:border-zinc-500 p-3">
			<h2 class="text-xl" style="color: var(--text-color);">Metadata</h2>
		</div>
		<div class="flex border-b border-zinc-400 dark:border-zinc-500">
			<div class="w-1/4 flex flex-col items-end px-4 pt-2 pb-3 border-r border-zinc-400 dark:border-zinc-500">
				<h3 class="text-lg" style="color: var(--text-color);">Rating</h3>
				<span class="text-xs italic text-zinc-400 text-right">
					Check out the Offprint Omnibus for info about which one would be appropriate for your work.
				</span>
			</div>
			<div class="w-3/4 px-2.5 py-2.5 flex items-center justify-center">
				<div class="flex flex-col p-4 bg-red-700 bg-opacity-10 rounded-l-xl border border-red-500 w-[250px]">
					<label class="mb-2">
						<input type="radio" value={ContentRating.Everyone} bind:group={$data.rating} />
						<span class="font-bold uppercase ml-0.5 relative top-[0.075rem]">Everyone</span>
					</label>
					<div class="text-xs">
						Not even a swear word.
					</div>
				</div>
				<div class="flex flex-col p-4 bg-red-700 bg-opacity-10 border-y border-r border-red-500 w-[250px]">
					<label class="mb-2">
						<input type="radio" value={ContentRating.Teen} bind:group={$data.rating} />
						<span class="font-bold uppercase ml-0.5 relative top-[0.075rem]">Teen</span>
					</label>
					<div class="text-xs">
						Suitable for most works.
					</div>
				</div>
				<div class="flex flex-col p-4 bg-red-700 bg-opacity-10 border-y border-red-500 w-[250px]">
					<label class="mb-2">
						<input type="radio" value={ContentRating.Mature} bind:group={$data.rating} />
						<span class="font-bold uppercase ml-0.5 relative top-[0.075rem]">Mature</span>
					</label>
					<div class="text-xs">
						Heavy topics, but nothing explicit.
					</div>
				</div>
				<div class="flex flex-col p-4 bg-red-700 bg-opacity-10 rounded-r-xl border border-red-500 w-[250px]">
					<label class="mb-2">
						<input type="radio" value={ContentRating.Explicit} bind:group={$data.rating} />
						<span class="font-bold uppercase ml-0.5 relative top-[0.075rem]">Explicit</span>
					</label>
					<div class="text-xs">
						Like Mature, but goes into greater detail.
					</div>
				</div>
			</div>
		</div>
		<div class="flex border-b border-zinc-400 dark:border-zinc-500">
			<div class="w-1/4 flex flex-col items-end px-4 pt-2 pb-3 border-r border-zinc-400 dark:border-zinc-500">
				<h3 class="text-lg" style="color: var(--text-color);">Status</h3>
				<span class="text-xs italic text-zinc-400 text-right">
					What state is your work in? And no, I don't mean a US State.
				</span>
			</div>
			<div class="w-3/4 px-2.5 py-2.5 flex items-center justify-center">
				<div class="flex flex-col p-4 bg-teal-700 bg-opacity-10 rounded-l-xl border border-teal-500 w-[250px]">
					<label class="mb-2">
						<input type="radio" value={Status.Incomplete} bind:group={$data.status} />
						<span class="font-bold uppercase ml-0.5 relative top-[0.075rem]">Incomplete</span>
					</label>
					<div class="text-xs">
						A work in progress.
					</div>
				</div>
				<div class="flex flex-col p-4 bg-teal-700 bg-opacity-10 border-y border-teal-500 w-[250px]">
					<label class="mb-2">
						<input type="radio" value={Status.Complete} bind:group={$data.status} />
						<span class="font-bold uppercase ml-0.5 relative top-[0.075rem]">Complete</span>
					</label>
					<div class="text-xs">
						Totally wrapped up.
					</div>
				</div>
				<div class="flex flex-col p-4 bg-teal-700 bg-opacity-10 border-y border-l border-teal-500 w-[250px]">
					<label class="mb-2">
						<input type="radio" value={Status.Paused} bind:group={$data.status} />
						<span class="font-bold uppercase ml-0.5 relative top-[0.075rem]">Paused</span>
					</label>
					<div class="text-xs">
						Taking a break.
					</div>
				</div>
				<div class="flex flex-col p-4 bg-teal-700 bg-opacity-10 rounded-r-xl border border-teal-500 w-[250px]">
					<label class="mb-2">
						<input type="radio" value={Status.Cancelled} bind:group={$data.status} />
						<span class="font-bold uppercase ml-0.5 relative top-[0.075rem]">Cancelled</span>
					</label>
					<div class="text-xs">
						Nothing more to say.
					</div>
				</div>
			</div>
		</div>
		<div class="flex items-center justify-center bg-zinc-300 dark:bg-zinc-600 p-3">
			<Button type="button">
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
