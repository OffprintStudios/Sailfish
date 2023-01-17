<script lang="ts">
	import { page } from "$app/stores";
	import { createForm } from "felte";
	import { type Work, type WorkForm, Kind } from "$lib/models/content/works";
	import { account } from "$lib/state/account.state";
	import { QuillPenLine, Save2Line } from "svelte-remixicon";
	import { Category, Status } from "$lib/models/content/works";
	import { TextField, Editor, TextArea } from "$lib/ui/forms";
	import { getReq, patchReq, type ResponseError } from "$lib/http";
	import toast from "svelte-french-toast";
	import { goto } from "$app/navigation";
	import { slugify } from "$lib/util/functions";
	import { ContentRating } from "$lib/models/content";
	import { TagKind } from "$lib/models/tags";
	import type { Tag } from "$lib/models/tags";
	import { onMount } from "svelte";
	import { Button } from "$lib/ui/util";
	import { TagBadge } from "$lib/ui/content";

	const work = $page.data as Work;
	let genres: { tag: Tag; isChosen: boolean }[] = [];
	let selectedGenres: string[] = work.tags
		.filter((item) => item.kind === TagKind.genre)
		.map((item) => item.id);
	let fandoms: { tag: Tag; isChosen: boolean }[] = [];
	let selectedFandoms: string[] = work.tags
		.filter((item) => item.kind === TagKind.fandom)
		.map((item) => item.id);

	let loadingFandoms = false;

	onMount(async () => {
		await fetchGenres();
		await fetchFandoms();
		genres = genres.map((genre) => {
			genre.isChosen = selectedGenres.some((id) => id === genre.tag.id);
			return genre;
		});
		fandoms = fandoms.map((fandom) => {
			fandom.isChosen = selectedFandoms.some((id) => id === fandom.tag.id);
			return fandom;
		});
	});

	async function fetchGenres() {
		const response = await getReq<{ tag: Tag; works: number; isChosen: boolean }[]>(
			`/tags/fetch-tags?kind=${TagKind.genre}&withCounts=false&ascending=true`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			genres = response as { tag: Tag; works: number; isChosen: boolean }[];
		}
	}

	async function fetchFandoms() {
		loadingFandoms = true;
		const response = await getReq<{ tag: Tag; works: number; isChosen: boolean }[]>(
			`/tags/fetch-tags?kind=${TagKind.fandom}&withCounts=false&ascending=true`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			fandoms = response as { tag: Tag; works: number; isChosen: boolean }[];
		}
		loadingFandoms = false;
	}

	function selectGenre(genre: { tag: Tag; isChosen: boolean }) {
		if (selectedGenres.some((val) => val === genre.tag.id)) {
			genre.isChosen = false;
			selectedGenres = selectedGenres.filter((val) => val !== genre.tag.id);
			genres = genres.map((val) => {
				if (val.tag.id === genre.tag.id) {
					return genre;
				} else {
					return val;
				}
			});
		} else if (selectedGenres.length === 3) {
			toast.error(`You can't have more than 3 genre tags!`);
		} else {
			genre.isChosen = true;
			selectedGenres.push(genre.tag.id);
			genres = genres.map((val) => {
				if (val.tag.id === genre.tag.id) {
					return genre;
				} else {
					return val;
				}
			});
		}
	}

	function selectFandom(fandom: { tag: Tag; isChosen: boolean }) {
		if (selectedFandoms.some((val) => val === fandom.tag.id)) {
			fandom.isChosen = false;
			selectedFandoms = selectedFandoms.filter((val) => val !== fandom.tag.id);
			fandoms = fandoms.map((val) => {
				if (val.tag.id === fandom.tag.id) {
					return fandom;
				} else {
					return val;
				}
			});
		} else {
			fandom.isChosen = true;
			selectedFandoms.push(fandom.tag.id);
			fandoms = fandoms.map((val) => {
				if (val.tag.id === fandom.tag.id) {
					return fandom;
				} else {
					return val;
				}
			});
		}
	}

	const { form, errors, data, isSubmitting } = createForm<WorkForm>({
		async onSubmit(values) {
			if (values.category === Category.Original) {
				values.tags = [...selectedGenres];
			} else {
				values.tags = [...selectedGenres, ...selectedFandoms];
			}

			console.log(`/works/update-work/${work.id}?profileId=${$account.currProfile?.id}`);

			const response = await patchReq<Work>(
				`/works/update-work/${work.id}?profileId=${$account.currProfile?.id}`,
				values
			);
			if ((response as ResponseError).error) {
				const error = response as ResponseError;
				toast.error(error.message);
			} else {
				const work = response as Work;
				await goto(`/work/${work.id}/${slugify(work.title)}`);
			}
		},
		validate(values) {
			const errors = {
				title: "",
				shortDesc: "",
				longDesc: "",
				genres: "",
				fandoms: ""
			};

			if (!values.title || values.title.length < 3 || values.title.length > 120) {
				errors.title = `Your title needs to be between 3 and 120 characters.`;
			}

			if (!values.shortDesc || values.shortDesc.length < 3 || values.shortDesc.length > 240) {
				errors.shortDesc = `Your short description needs to be between 3 and 240 characters.`;
			}

			if (!values.longDesc || values.longDesc.length < 3) {
				errors.longDesc = `Your long description needs to be more than 3 characters.`;
			}

			if (selectedGenres.length < 1) {
				errors.genres = `You must select at least one genre.`;
			}

			if (values.category === Category.Fanwork) {
				if (selectedFandoms.length < 1) {
					errors.fandoms = `You must select at least one fandom.`;
				}
			}

			return errors;
		},
		initialValues: {
			title: work.title,
			shortDesc: work.shortDesc,
			longDesc: work.longDesc,
			category: work.category,
			rating: work.rating,
			status: work.status,
			tags: [],
			kind: work.kind
		}
	});
</script>

<svelte:head>
	<title>Editing "{work.title}" &mdash; Offprint</title>
</svelte:head>

{#if $account.account && $account.currProfile && $account.currProfile.id === work.author.id}
	<form
		class="max-w-4xl mx-auto xl:rounded-xl overflow-hidden mb-6 xl:mt-6 flex flex-col bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed"
		use:form
	>
		<div class="flex items-center justify-center px-2 py-4" style="background: var(--accent);">
			<QuillPenLine class="text-white mr-2 w-[36px] h-[36px] lg:w-[48px] lg:h-[48px]" />
			<h1 class="text-white text-2xl lg:text-4xl">Editing "{work.title}"</h1>
		</div>
		<div class="flex flex-col lg:flex-row border-b border-zinc-400 dark:border-zinc-500">
			<div
				class="w-full lg:w-1/4 flex items-center lg:flex-col lg:items-end px-4 pt-2 pb-0 lg:pt-2 lg:pb-3 lg:border-r border-zinc-400 dark:border-zinc-500"
			>
				<h3 class="text-lg" style="color: var(--text-color);">Category</h3>
				<span class="text-xs italic text-zinc-400 text-right hidden lg:block">
					First thing's first. Is this an original work, or a fan work?
				</span>
			</div>
			<div class="w-full lg:w-3/4 px-2.5 py-2.5 flex items-center justify-center">
				<div
					class="flex flex-col p-4 bg-green-700 bg-opacity-10 rounded-xl border border-green-500 w-1/2 lg:w-[250px] lg:h-[111px]"
				>
					<label class="mb-2">
						<input type="radio" value={Category.Original} bind:group={$data.category} />
						<span class="font-bold uppercase ml-0.5 relative top-[0.075rem]"
							>Original Work</span
						>
					</label>
					<div class="text-xs hidden lg:block">
						Wholly original content&mdash;written, owned, and published by you, stories
						yet untold.
					</div>
				</div>
				<div class="mx-1"><!--spacer--></div>
				<div
					class="flex flex-col p-4 bg-cyan-700 bg-opacity-10 rounded-xl border border-cyan-500 w-1/2 lg:w-[250px] lg:h-[111px]"
				>
					<label class="mb-2">
						<input type="radio" value={Category.Fanwork} bind:group={$data.category} />
						<span class="font-bold uppercase ml-0.5 relative top-[0.075rem]"
							>Fan Work</span
						>
					</label>
					<div class="text-xs hidden lg:block">
						Derivative works&mdash;labors of love and naval combat, inspired by worlds
						of other origin.
					</div>
				</div>
			</div>
		</div>
		<div class="flex flex-col lg:flex-row border-b border-zinc-400 dark:border-zinc-500">
			<div
				class="w-full lg:w-1/4 flex items-center lg:flex-col lg:items-end px-4 pt-2 pb-0 lg:pt-2 lg:pb-3 lg:border-r border-zinc-400 dark:border-zinc-500"
			>
				<h3 class="text-lg" style="color: var(--text-color);">Kind</h3>
				<span class="text-xs italic text-zinc-400 text-right hidden lg:block">
					What kind of work is this? Select from the dropdown to view a short description.
				</span>
			</div>
			<div class="w-full lg:w-3/4 px-2.5 py-2.5 flex flex-col items-center justify-center">
				<div class="w-full bg-cyan-800 bg-opacity-10 border border-cyan-700 rounded-xl">
					<select
						name="kind"
						class="w-full rounded-t-xl lg:border-b-2 border-cyan-700 bg-transparent border-0 focus:ring-0 focus:border-cyan-700"
					>
						<option value={Kind.Prose}>{Kind.Prose}</option>
						<option value={Kind.Poetry}>{Kind.Poetry}</option>
						<option value={Kind.Nonfiction}>{Kind.Nonfiction}</option>
						<option value={Kind.Script}>{Kind.Script}</option>
						<option value={Kind.Anthology}>{Kind.Anthology}</option>
					</select>
					<div class="self-start hidden px-4 py-4 lg:flex flex-col">
						<span class="uppercase font-bold tracking-wider mb-2">DESCRIPTION</span>
						{#if $data.kind === Kind.Prose}
							Fictional works written plainly—the Standard Writing Method.
						{:else if $data.kind === Kind.Poetry}
							Lines organized with or without meter, playing with often abstract forms
							of language.
						{:else if $data.kind === Kind.Nonfiction}
							A story told from reality, written by either someone who was there or
							someone who did their research.
						{:else if $data.kind === Kind.Script}
							A story written for the stage or the screen.
						{:else if $data.kind === Kind.Anthology}
							A collection of drabbles, short stories, accounts, you name it. Best for
							collections of disparate things than a cohesive whole.
						{/if}
					</div>
				</div>
			</div>
		</div>
		<div class="bg-zinc-300 dark:bg-zinc-600 border-b border-zinc-400 dark:border-zinc-500 p-3">
			<h2 class="text-xl" style="color: var(--text-color);">General Info</h2>
		</div>
		<div class="flex flex-col lg:flex-row border-b border-zinc-400 dark:border-zinc-500">
			<div
				class="w-full lg:w-1/4 flex items-center lg:flex-col lg:items-end px-4 pt-2 pb-0 lg:pt-2 lg:pb-3 lg:border-r border-zinc-400 dark:border-zinc-500"
			>
				<h3 class="text-lg" style="color: var(--text-color);">Title</h3>
				<div class="flex-1 lg:hidden"><!--spacer--></div>
				<span class="text-xs italic text-zinc-400 lg:mb-1">120 characters max</span>
				<span class="text-xs italic text-zinc-400 text-right hidden lg:block">
					What's your work called?
				</span>
			</div>
			<div class="lg:w-3/4 px-2.5 flex flex-col items-center justify-center">
				<TextField
					name="title"
					type="text"
					placeholder="Just Another Rundown"
					errorMessage={$errors.title}
					kind="primary"
				/>
			</div>
		</div>
		<div class="flex flex-col lg:flex-row border-b border-zinc-400 dark:border-zinc-500">
			<div
				class="w-full lg:w-1/4 flex items-center lg:flex-col lg:items-end px-4 pt-2 pb-0 lg:pt-2 lg:pb-3 lg:border-r border-zinc-400 dark:border-zinc-500"
			>
				<h3 class="text-lg" style="color: var(--text-color);">Short Description</h3>
				<div class="flex-1 lg:hidden"><!--spacer--></div>
				<span class="text-xs italic text-zinc-400 lg:mb-1">240 characters max</span>
				<span class="text-xs italic text-zinc-400 text-right hidden lg:block"
					>What's the basic idea of your work? Make it punchy!</span
				>
			</div>
			<div class="w-full lg:w-3/4 px-2.5 flex flex-col items-center justify-center">
				<TextArea
					name="shortDesc"
					type="text"
					placeholder="A journey of a thousand words"
					errorMessage={$errors.shortDesc}
					kind="primary"
				/>
			</div>
		</div>
		<div class="flex flex-col lg:flex-row border-b border-zinc-400 dark:border-zinc-500">
			<div
				class="w-full lg:w-1/4 flex items-center lg:flex-col lg:items-end px-4 pt-2 pb-0 lg:pt-2 lg:pb-3 lg:border-r border-zinc-400 dark:border-zinc-500"
			>
				<h3 class="text-lg" style="color: var(--text-color);">Long Description</h3>
				<span class="text-xs italic text-zinc-400 text-right hidden lg:block">
					Now set the stage&mdash;what's your work all about?
				</span>
			</div>
			<div class="w-full lg:w-3/4 px-2.5 py-2.5">
				<Editor kind="primary" bind:value={$data.longDesc} />
			</div>
		</div>
		<div class="bg-zinc-300 dark:bg-zinc-600 border-b border-zinc-400 dark:border-zinc-500 p-3">
			<h2 class="text-xl" style="color: var(--text-color);">Tags</h2>
		</div>
		<div class="flex flex-col lg:flex-row border-b border-zinc-400 dark:border-zinc-500">
			<div
				class="w-full lg:w-1/4 flex items-center lg:flex-col lg:items-end px-4 pt-2 pb-0 lg:pt-2 lg:pb-3 lg:border-r border-zinc-400 dark:border-zinc-500"
			>
				<h3 class="text-lg" style="color: var(--text-color);">Genres</h3>
				<div class="flex-1 lg:hidden"><!--spacer--></div>
				<span class="text-xs italic text-zinc-400 mb-1">3 max, 1 minimum</span>
				<span class="text-xs italic text-zinc-400 text-right hidden lg:block">
					What genres do you think apply here? Don't worry, you can always change this
					later.
				</span>
			</div>
			<div
				class="w-full lg:w-3/4 px-2.5 py-2.5 flex items-center lg:justify-center flex-wrap"
			>
				{#each genres as genre}
					<div
						class="mx-[0.075rem] px-0.5 pb-1 rounded-lg border border-transparent"
						class:border-blue-300={genre.isChosen}
					>
						<TagBadge
							tag={genre.tag}
							kind={genre.tag.kind}
							on:click={() => selectGenre(genre)}
						/>
					</div>
				{/each}
			</div>
		</div>
		{#if $data.category === Category.Fanwork}
			<div class="flex flex-col lg:flex-row border-b border-zinc-400 dark:border-zinc-500">
				<div
					class="w-full lg:w-1/4 flex items-center lg:flex-col lg:items-end px-4 pt-2 pb-0 lg:pt-2 lg:pb-3 lg:border-r border-zinc-400 dark:border-zinc-500"
				>
					<h3 class="text-lg" style="color: var(--text-color);">Fandoms</h3>
					<div class="flex-1 lg:hidden"><!--spacer--></div>
					<span class="text-xs italic text-zinc-400 mb-1">1 minimum</span>
					<span class="text-xs italic text-zinc-400 text-right hidden lg:block">
						What worlds are you enhancing? Make sure to only include the most pertinent
						ones!
					</span>
				</div>
				<div
					class="w-full lg:w-3/4 px-2.5 py-2.5 flex items-center lg:justify-center flex-wrap h-[250px] overflow-hidden overflow-y-auto"
				>
					{#if loadingFandoms}
						<h5 class="font-medium text-lg">Loading...</h5>
					{:else}
						{#each fandoms as fandom}
							<div
								class="mx-[0.075rem] px-0.5 pb-1 rounded-lg border border-transparent"
								class:border-blue-300={fandom.isChosen}
							>
								<TagBadge
									tag={fandom.tag}
									kind={fandom.tag.kind}
									on:click={() => selectFandom(fandom)}
								/>
							</div>
						{/each}
					{/if}
				</div>
			</div>
		{/if}
		<div class="bg-zinc-300 dark:bg-zinc-600 border-b border-zinc-400 dark:border-zinc-500 p-3">
			<h2 class="text-xl" style="color: var(--text-color);">Metadata</h2>
		</div>
		<div class="flex flex-col lg:flex-row border-b border-zinc-400 dark:border-zinc-500">
			<div
				class="w-full lg:w-1/4 flex items-center lg:flex-col lg:items-end px-4 pt-2 pb-0 lg:pt-2 lg:pb-3 lg:border-r border-zinc-400 dark:border-zinc-500"
			>
				<h3 class="text-lg" style="color: var(--text-color);">Rating</h3>
				<span class="text-xs italic text-zinc-400 text-right hidden lg:block">
					Check out the Offprint Omnibus for info about which one would be appropriate for
					your blog.
				</span>
			</div>
			<div
				class="w-full lg:w-3/4 px-2.5 py-2.5 grid grid-cols-2 lg:grid-cols-4 whitespace-nowrap lg:whitespace-normal"
			>
				<div
					class="flex flex-col p-4 bg-red-700 bg-opacity-10 rounded-tl-xl lg:rounded-l-xl border border-red-500"
				>
					<label class="mb-2">
						<input
							type="radio"
							value={ContentRating.Everyone}
							bind:group={$data.rating}
						/>
						<span class="font-bold uppercase ml-1 relative top-[0.075rem]"
							>Everyone</span
						>
					</label>
					<div class="text-xs hidden lg:block">Not even a swear word.</div>
				</div>
				<div
					class="flex flex-col p-4 bg-red-700 bg-opacity-10 rounded-tr-xl lg:rounded-tr-none border-y border-r border-red-500"
				>
					<label class="mb-2">
						<input type="radio" value={ContentRating.Teen} bind:group={$data.rating} />
						<span class="font-bold uppercase ml-0.5 relative top-[0.075rem]">Teen</span>
					</label>
					<div class="text-xs hidden lg:block">Suitable for most works.</div>
				</div>
				<div
					class="flex flex-col p-4 bg-red-700 bg-opacity-10 border-t-0 border-b rounded-bl-xl lg:rounded-none lg:border-l-0 lg:border-y border-x border-red-500"
				>
					<label class="mb-2">
						<input
							type="radio"
							value={ContentRating.Mature}
							bind:group={$data.rating}
						/>
						<span class="font-bold uppercase ml-0.5 relative top-[0.075rem]"
							>Mature</span
						>
					</label>
					<div class="text-xs hidden lg:block">Heavy topics, but nothing explicit.</div>
				</div>
				<div
					class="flex flex-col p-4 bg-red-700 bg-opacity-10 rounded-br-xl lg:rounded-r-xl border-t-0 border lg:border-t border-l-0 border-red-500"
				>
					<label class="mb-2">
						<input
							type="radio"
							value={ContentRating.Explicit}
							bind:group={$data.rating}
						/>
						<span class="font-bold uppercase ml-0.5 relative top-[0.075rem]"
							>Explicit</span
						>
					</label>
					<div class="text-xs hidden lg:block">
						Like Mature, but goes into greater detail.
					</div>
				</div>
			</div>
		</div>
		<div class="flex flex-col lg:flex-row border-b border-zinc-400 dark:border-zinc-500">
			<div
				class="w-full lg:w-1/4 flex items-center lg:flex-col lg:items-end px-4 pt-2 pb-0 lg:pt-2 lg:pb-3 lg:border-r border-zinc-400 dark:border-zinc-500"
			>
				<h3 class="text-lg" style="color: var(--text-color);">Status</h3>
				<span class="text-xs italic text-zinc-400 text-right hidden lg:block">
					What state is your work in? And no, I don't mean a US State.
				</span>
			</div>
			<div
				class="w-full lg:w-3/4 px-2.5 py-2.5 grid grid-cols-2 lg:grid-cols-4 whitespace-nowrap lg:whitespace-normal"
			>
				<div
					class="flex flex-col p-4 bg-teal-700 bg-opacity-10 rounded-tl-xl lg:rounded-l-xl border border-teal-500 lg:w-auto"
				>
					<label class="mb-2">
						<input type="radio" value={Status.Incomplete} bind:group={$data.status} />
						<span class="font-bold uppercase ml-0.5 relative top-[0.075rem]"
							>Incomplete</span
						>
					</label>
					<div class="text-xs hidden lg:block">A work in progress.</div>
				</div>
				<div
					class="flex flex-col p-4 bg-teal-700 bg-opacity-10 rounded-tr-xl lg:rounded-none border-r lg:border-r-0 border-y border-teal-500"
				>
					<label class="mb-2">
						<input type="radio" value={Status.Complete} bind:group={$data.status} />
						<span class="font-bold uppercase ml-0.5 relative top-[0.075rem]"
							>Complete</span
						>
					</label>
					<div class="text-xs hidden lg:block">Totally wrapped up.</div>
				</div>
				<div
					class="flex flex-col p-4 bg-teal-700 bg-opacity-10 rounded-bl-xl lg:rounded-none border-t-0 border-b lg:border-y border-x lg:border-r-0 border-teal-500"
				>
					<label class="mb-2">
						<input type="radio" value={Status.Paused} bind:group={$data.status} />
						<span class="font-bold uppercase ml-0.5 relative top-[0.075rem]"
							>Paused</span
						>
					</label>
					<div class="text-xs hidden lg:block">Taking a break.</div>
				</div>
				<div
					class="flex flex-col p-4 bg-teal-700 bg-opacity-10 rounded-br-xl lg:rounded-r-xl border-b border-r lg:border border-teal-500"
				>
					<label class="mb-2">
						<input type="radio" value={Status.Cancelled} bind:group={$data.status} />
						<span class="font-bold uppercase ml-0.5 relative top-[0.075rem]"
							>Cancelled</span
						>
					</label>
					<div class="text-xs hidden lg:block">Nothing more to say.</div>
				</div>
			</div>
		</div>
		<div class="flex items-center justify-center bg-zinc-300 dark:bg-zinc-600 p-3">
			<Button type="submit" loading={$isSubmitting} loadingText="Saving...">
				<Save2Line class="button-icon" />
				<span class="button-text">Save Changes</span>
			</Button>
		</div>
	</form>
{:else}
	<div class="empty">
		<h3>You aren't allowed to view this page</h3>
		<p>Instead, how about looking up some pictures of cute cats?</p>
	</div>
{/if}
