<script lang="ts">
	import { slide } from "svelte/transition";
	import { TagKind } from "$lib/models/tags";
	import { onMount } from "svelte";
	import { Button } from "$lib/ui/util";
	import type { Tag } from "$lib/models/tags";
	import {
		AddBoxLine,
		SortAsc,
		SortDesc,
		DeleteBin2Line,
		Edit2Line,
		ArrowDownSLine,
		ArrowUpSLine
	} from "svelte-remixicon";
	import { openPopup } from "$lib/ui/popup";
	import AddTagForm from "./AddTagForm.svelte";
	import { NavLink } from "$lib/ui/nav";
	import { Time } from "$lib/ui/util";
	import { getReq, delReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import UpdateTagForm from "./UpdateTagForm.svelte";
	import DeleteTagPrompt from "./DeleteTagPrompt.svelte";
	import toast from "svelte-french-toast";

	let tags: { tag: Tag; works: number; isOpen: boolean }[] = [];
	let currCategory = TagKind.fandom;
	let ascending = true;

	onMount(async () => {
		await fetchData(currCategory);
	});

	$: fetchData(currCategory);

	async function fetchData(tagKind: TagKind) {
		const response = await getReq<{ tag: Tag; works: number; isOpen: boolean }[]>(
			`/tags/fetch-tags?kind=${tagKind}&withCounts=true&ascending=${ascending}`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			tags = response as { tag: Tag; works: number; isOpen: boolean }[];
		}
	}

	async function addTag(parentId?: string) {
		openPopup(
			AddTagForm,
			{
				async onConfirm() {
					await fetchData(currCategory);
				}
			},
			{
				parentId,
				kind: currCategory
			}
		);
	}

	function getChildTags(tag: Tag): { tag: Tag; works: number; isOpen: boolean }[] {
		return tags.filter((item) => {
			if (item.tag.parent && item.tag.parent.id === tag.id) {
				return item;
			}
		});
	}

	async function switchDirection() {
		ascending = !ascending;
		await fetchData(currCategory);
	}

	async function updateTag(tag: Tag) {
		openPopup(
			UpdateTagForm,
			{
				async onConfirm() {
					await fetchData(currCategory);
				}
			},
			tag
		);
	}

	async function deleteTag(tagId: string) {
		openPopup(DeleteTagPrompt, {
			async onConfirm() {
				const response = await delReq<void>(`/tags/delete-tag/${tagId}`);
				if ((response as ResponseError).error) {
					const error = response as ResponseError;
					toast.error(error.message);
				} else {
					await fetchData(currCategory);
				}
			}
		});
	}
</script>

<div class="w-11/12 lg:w-full max-w-6xl mx-auto">
	<div class="flex items-center">
		<Button kind="primary" on:click={() => addTag()}>
			<AddBoxLine class="button-icon" />
			<span class="button-text">Add Tag</span>
		</Button>
		<div class="mx-0.5"><!--spacer--></div>
		{#if ascending}
			<Button on:click={switchDirection}>
				<SortAsc class="button-icon" />
				<span class="button-text">Ascending</span>
			</Button>
		{:else}
			<Button on:click={switchDirection}>
				<SortDesc class="button-icon" />
				<span class="button-text">Descending</span>
			</Button>
		{/if}
		<div class="flex-1"><!--spacer--></div>
		<select
			class="w-[150px] lg:w-[250px] border-transparent bg-zinc-200 dark:bg-zinc-700 rounded-xl dark:highlight-shadowed"
			bind:value={currCategory}
		>
			<option value={TagKind.fandom}>{TagKind.fandom}</option>
			<option value={TagKind.genre}>{TagKind.genre}</option>
			<option value={TagKind.warning}>{TagKind.warning}</option>
			<option value={TagKind.user}>{TagKind.user}</option>
		</select>
	</div>
	{#if tags.length === 0}
		<div class="empty">
			<h3>No tags for this category</h3>
			<p>Get started by clicking the Add Tag button!</p>
		</div>
	{:else}
		<div class="w-full flex flex-col my-6">
			{#each tags as tag}
				{#if !tag.tag.parent}
					<div
						class="flex flex-col p-4 bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed mb-4 last:mb-0 rounded-xl"
					>
						<div class="flex items-center">
							<div class="flex flex-col relative top-1">
								<span
									class="text-2xl font-bold flex items-center"
									style="font-family: var(--header-text);"
								>
									{tag.tag.name}
									<span
										class="text-sm font-mono ml-2 relative -top-0.5 text-zinc-400"
										>ID-{tag.tag.id}</span
									>
								</span>
							</div>
							<div class="flex-1"><!--spacer--></div>
							<span class="mr-4 all-small-caps text-lg font-bold tracking-wider">
								<Time timestamp={tag.tag.createdAt} />
							</span>
							{#if tag.isOpen}
								<Button on:click={() => (tag.isOpen = false)}>
									<ArrowUpSLine class="button-icon no-text" size="24px" />
								</Button>
							{:else}
								<Button on:click={() => (tag.isOpen = true)}>
									<ArrowDownSLine class="button-icon no-text" size="24px" />
								</Button>
							{/if}
						</div>
						{#if tag.isOpen}
							<div transition:slide>
								<div class="flex items-center mt-4">
									<div class="p-2 max-w-[400px]">
										{tag.tag.desc ?? "[No description provided]"}
									</div>
									<div class="flex-1"><!--spacer--></div>
									<NavLink type="button">
										<span
											class="font-bold text-2xl relative top-0.5"
											style="font-family: var(--header-text);"
											>{tag.works}</span
										>
										<span class="link-name relative -top-1">Works</span>
									</NavLink>
									<NavLink type="button" on:click={() => addTag(tag.tag.id)}>
										<AddBoxLine class="link-icon" />
										<span class="link-name">Child</span>
									</NavLink>
									<NavLink type="button" on:click={() => updateTag(tag.tag)}>
										<Edit2Line class="link-icon" />
										<span class="link-name">Edit</span>
									</NavLink>
									<NavLink type="button" on:click={() => deleteTag(tag.tag.id)}>
										<DeleteBin2Line class="link-icon" />
										<span class="link-name">Delete</span>
									</NavLink>
								</div>
								{#if getChildTags(tag.tag).length === 0}
									<div class="w-full text-center text-lg font-bold uppercase">
										No Children Associated With This Tag
									</div>
								{:else}
									<table class="table-compact w-full">
										<thead>
											<tr class="border-t-2 border-zinc-500">
												<th class="all-small-caps text-lg py-2"
													>Child Tag</th
												>
												<th class="all-small-caps text-lg py-2"
													>Description</th
												>
												<th class="all-small-caps text-lg py-2"># Works</th>
												<th class="all-small-caps text-lg py-2">Created</th>
												<th class="all-small-caps text-lg py-2">Actions</th>
											</tr>
										</thead>
										<tbody>
											{#each getChildTags(tag.tag) as child}
												<tr
													id="#{child.tag.id}"
													class="text-center even:bg-zinc-300 even:dark:bg-zinc-600"
												>
													<td class="flex flex-col py-2">
														<span
															class="text-lg font-bold relative top-0.5"
															style="font-family: var(--header-text);"
															>{child.tag.name}</span
														>
														<span
															class="font-mono text-sm text-zinc-400 relative -top-0.5"
															>ID-{child.tag.id}</span
														>
													</td>
													<td>{child.tag.desc ?? "No description"}</td>
													<td>{child.works}</td>
													<td><Time timestamp={child.tag.createdAt} /></td
													>
													<td>
														<div
															class="flex items-center justify-center"
														>
															<Button
																title="Edit"
																on:click={() =>
																	updateTag(child.tag)}
															>
																<Edit2Line
																	class="button-icon no-text"
																	size="22px"
																/>
															</Button>
															<Button
																title="Delete"
																on:click={() =>
																	deleteTag(child.tag.id)}
															>
																<DeleteBin2Line
																	class="button-icon no-text"
																	size="22px"
																/>
															</Button>
														</div>
													</td>
												</tr>
											{/each}
										</tbody>
									</table>
								{/if}
							</div>
						{/if}
					</div>
				{/if}
			{/each}
		</div>
	{/if}
</div>

<style lang="scss">
	div.stat-block {
		@apply flex flex-col items-center justify-center py-4 last:pb-2 last:border-0;
		span.stat-name {
			@apply uppercase text-zinc-400 text-xs font-medium tracking-widest mb-1;
		}
		span.stat-value {
			@apply text-lg font-bold;
			font-family: var(--body-serif-text);
		}
	}
	div.date-block {
		font-family: var(--header-text);
		@apply flex-col items-center justify-center relative top-2 flex rounded-xl;
		span.month-and-day {
			@apply uppercase text-2xl font-medium relative kerning;
		}
		span.year {
			@apply text-lg font-light relative bottom-2;
		}
	}
</style>
