<script lang="ts">
	import { computePosition, flip, offset, shift } from "@floating-ui/dom";
	import type { Placement } from "@floating-ui/dom";
	import { slide } from "svelte/transition";
	import { clickOutside } from "$lib/util/functions";
	import { DEFAULT_SLOGANS } from "$lib/util/constants";
	import { Loader5Line, SearchEyeLine } from "svelte-remixicon";
	import { onMount } from "svelte";
	import type { Paginate } from "$lib/util/types";
	import type { Work } from "$lib/models/content/works";
	import type { Blog } from "$lib/models/content";
	import type { Profile } from "$lib/models/accounts";
	import { getReq, type ResponseError } from "$lib/http";
	import toast from "svelte-french-toast";
	import { app } from "$lib/state/app.state";
	import ProfileCard from "$lib/ui/content/ProfileCard.svelte";
	import WorkCard from "$lib/ui/content/WorkCard.svelte";
	import BlogCard from "$lib/ui/content/BlogCard.svelte";

	export let open = false;
	export let position: Placement = "bottom";

	enum DropdownTabs {
		Works,
		Blogs,
		Users
	}

	const currSlogan = DEFAULT_SLOGANS[Math.floor(Math.random() * DEFAULT_SLOGANS.length)];

	let button: HTMLButtonElement;
	let dropdown: HTMLDivElement;
	let timer = -1;
	let loading = false;
	let currTab = DropdownTabs.Works;
	let query = "";
	let workResults: Paginate<Work> = {
		items: [],
		metadata: {
			page: 1,
			per: 3,
			total: 0
		}
	};
	let blogResults: Paginate<Blog> = {
		items: [],
		metadata: {
			page: 1,
			per: 3,
			total: 0
		}
	};
	let userResults: Paginate<Profile> = {
		items: [],
		metadata: {
			page: 1,
			per: 3,
			total: 0
		}
	};

	function determineState() {
		open = !open;
		workResults = {
			items: [],
			metadata: {
				page: 1,
				per: 3,
				total: 0
			}
		};
		blogResults = {
			items: [],
			metadata: {
				page: 1,
				per: 3,
				total: 0
			}
		};
		userResults = {
			items: [],
			metadata: {
				page: 1,
				per: 3,
				total: 0
			}
		};
	}

	onMount(() => {
		document.addEventListener("keydown", (event) => {
			if (event.key === "Escape" && open === true) {
				open = false;
			}
		});
	});

	$: {
		if (button) {
			computePosition(button, dropdown, {
				placement: position,
				middleware: [offset({ mainAxis: -40 }), flip(), shift({ padding: 5 })]
			})
				.then(({ x, y }) => {
					Object.assign(dropdown.style, {
						left: `${x}px`,
						top: `${y}px`
					});
				})
				.catch(() => {
					console.log(`Button not yet assigned!`);
				});
		}
	}

	async function searchFor(detail: string) {
		clearTimeout(timer);
		query = detail;
		timer = window.setTimeout(async () => {
			loading = true;
			const workResponse = await getReq<Paginate<Work>>(
				`/search/works?filter=${$app.filter}&title=${query}&page=1&per=3`
			);
			const blogResponse = await getReq<Paginate<Work>>(
				`/search/blogs?filter=${$app.filter}&title=${query}&page=1&per=3`
			);
			const userResponse = await getReq<Paginate<Profile>>(
				`/search/users?username=${query}&page=1&per=3`
			);
			if (
				(workResponse as ResponseError).error ||
				(blogResponse as ResponseError).error ||
				(userResponse as ResponseError).error
			) {
				const error = workResponse as ResponseError;
				toast.error(error.message);
			} else {
				workResults = workResponse as Paginate<Work>;
				blogResults = blogResponse as Paginate<Blog>;
				userResults = userResponse as Paginate<Profile>;
			}
			loading = false;
		}, 300);
	}
</script>

<div class="relative z-[2]">
	<button class="search-button" on:click={determineState} bind:this={button}>
		<SearchEyeLine size="20px" class="mr-2" />
		<span>{currSlogan}</span>
	</button>
	{#if open}
		<div
			class="search-dropdown-items bg-zinc-200 dark:bg-zinc-700"
			transition:slide|local={{ delay: 0, duration: 150 }}
			bind:this={dropdown}
			use:clickOutside
			on:outclick={determineState}
		>
			<div class="search-button">
				<SearchEyeLine size="20px" class="mx-2" />
				<input
					type="text"
					class="text-white text-sm px-0 py-2.5 flex-1 m-0 bg-transparent border-0 focus:ring-0 rounded-lg placeholder:text-zinc-200"
					placeholder={currSlogan}
					on:keyup={(e) => searchFor(e.target.value)}
					autofocus
				/>
			</div>
			<div class="search-items">
				<div class="search-tab-row">
					<button
						class:active={currTab === DropdownTabs.Works}
						on:click={() => (currTab = DropdownTabs.Works)}
					>
						Works <span class:hidden={workResults.metadata.total === 0}
							>({workResults.metadata.total})</span
						>
					</button>
					<button
						class:active={currTab === DropdownTabs.Blogs}
						on:click={() => (currTab = DropdownTabs.Blogs)}
					>
						Blogs <span class:hidden={blogResults.metadata.total === 0}
							>({blogResults.metadata.total})</span
						>
					</button>
					<button
						class:active={currTab === DropdownTabs.Users}
						on:click={() => (currTab = DropdownTabs.Users)}
					>
						Users <span class:hidden={userResults.metadata.total === 0}
							>({userResults.metadata.total})</span
						>
					</button>
				</div>
				<div class="search-results">
					{#if loading}
						<div class="empty">
							<p>
								<Loader5Line
									size="36px"
									class="animate-[spin_2s_linear_infinite]"
								/>
							</p>
						</div>
					{:else if workResults.metadata.total === 0 && blogResults.metadata.total === 0 && userResults.metadata.total === 0}
						<div class="empty">
							<p>Let's see what we can dig up, yeah?</p>
						</div>
					{:else if currTab === DropdownTabs.Works}
						{#if workResults.metadata.total === 0}
							<div class="empty">
								<p>Nothing to see here</p>
							</div>
						{:else}
							{#each workResults.items as work}
								<WorkCard {work} withDropdown={false} />
							{/each}
							<a href="/search?query={query}" class="py-2 px-4 my-6">See more</a>
						{/if}
					{:else if currTab === DropdownTabs.Blogs}
						{#if blogResults.metadata.total === 0}
							<div class="empty">
								<p>Nothing to see here</p>
							</div>
						{:else}
							{#each blogResults.items as blog}
								<BlogCard
									{blog}
									hasDropdown={false}
									showAvatar={true}
									showPreview={false}
								/>
							{/each}
							<a href="/search?query={query}" class="py-2 px-4 my-6">See more</a>
						{/if}
					{:else if currTab === DropdownTabs.Users}
						{#if userResults.metadata.total === 0}
							<div class="empty">
								<p>Nothing to see here</p>
							</div>
						{:else}
							{#each userResults.items as user}
								<ProfileCard
									profile={user}
									showOptions={false}
									showBanner={false}
								/>
							{/each}
							<a href="/search?query={query}" class="py-2 px-4 my-6">See more</a>
						{/if}
					{/if}
				</div>
			</div>
		</div>
	{/if}
</div>

<style lang="scss">
	button.search-button {
		@apply w-9/12 mx-auto flex items-center justify-center py-2 border-b-2 border-white text-sm rounded-md z-10 transition transform;
		background: var(--accent-light);
		box-shadow: var(--dropshadow);
		&:hover {
			@apply scale-[1.025];
		}
	}
	div.search-button {
		@apply w-full flex items-center justify-center sticky top-0 border-b-2 border-white text-sm rounded-t-md z-10 overflow-hidden transition transform;
		background: var(--accent-light);
		box-shadow: var(--dropshadow);
	}
	div.search-items {
		@apply p-2 min-h-[350px] max-h-[350px];
	}
	div.search-tab-row {
		@apply flex items-center justify-center mx-auto;
		button {
			@apply px-4 py-2 all-small-caps text-lg tracking-wider font-bold transition border-b-4 border-transparent;
			&.active {
				border-color: var(--accent);
			}
		}
	}
	div.search-results {
		@apply flex flex-col mt-4 overflow-y-scroll;
	}
	div.search-dropdown-items {
		@apply absolute rounded-lg z-50 min-w-[36rem] max-w-[36rem] overflow-hidden overflow-y-scroll;
		box-shadow: var(--dropshadow);
	}
</style>
