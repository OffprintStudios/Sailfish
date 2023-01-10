<script lang="ts">
	import type { Paginate } from "$lib/util/types";
	import type { AccountWithReports } from "$lib/models/accounts";
	import type { ResponseError } from "$lib/http";
	import { getReq } from "$lib/http";
	import { page } from "$app/stores";
	import { Paginator, Avatar } from "$lib/ui/util";
	import { pluralize } from "$lib/util/functions";
	import {
		EmotionLine,
		EmotionNormalLine,
		EmotionUnhappyLine,
		CriminalLine,
		Skull2Line,
		AlertLine,
		CheckboxCircleLine
	} from "svelte-remixicon";
	import toast from "svelte-french-toast";
	import Time from "$lib/ui/util/Time.svelte";
	import RoleBadge from "$lib/ui/util/RoleBadge.svelte";

	export let data: Paginate<AccountWithReports>;
	let currPage = +($page.url.searchParams.get("page") ?? "1");
	let perPage = +($page.url.searchParams.get("per") ?? "20");
	let loading = false;
	let containerTop;
	const iconSize = "50px";

	async function loadPage(newPage: number) {
		loading = true;
		currPage = newPage;
		const response = await getReq<Paginate<AccountWithReports>>(
			`/admin/fetch-users?page=${currPage}&per=${perPage}`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			data = response as Paginate<AccountWithReports>;
			containerTop.scrollIntoView({ behavior: "smooth" });
		}
		loading = false;
	}
</script>

<div bind:this={containerTop}><!--intentionally left blank--></div>
<div class="max-w-6xl mx-auto mb-6">
	{#each data.items as account}
		<div
			class="rounded-xl p-4 w-full my-6 relative transition first:mt-0 last:mb-0 bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed hover:bg-zinc-300 dark:hover:bg-zinc-600 group"
		>
			<a class="h-full w-full absolute z-[2]" href="/dashboard/users/{account.id}">
				<!--left intentionally blank-->
			</a>
			<div class="flex items-center mb-2">
				<div class="font-mono text-lg font-bold mb-2">Account ID: {account.id}</div>
				<div class="relative -top-1 ml-2">
					<RoleBadge roles={account.roles} size="large" />
				</div>
				<div class="flex-1"><!--spacer--></div>
				<div class="flex items-center">
					{#each account.profiles as profile}
						<span class="relative" title={profile.username}>
							<Avatar src={profile.avatar} size="42px" borderWidth="1px" />
						</span>
					{:else}
						<span>No Profiles Added</span>
					{/each}
				</div>
			</div>
			<div class="flex items-center">
				<div
					class="info-block bg-zinc-300 dark:bg-zinc-600"
					class:good-standing={account.total === 0}
					class:negligible-concern={account.total >= 1 && account.total < 3}
					class:possible-issue={account.total >= 3 && account.total < 5}
					class:brow-raising={account.total >= 5 && account.total < 7}
					class:needs-attention={account.total >= 7}
				>
					{#if account.total >= 7}
						<Skull2Line size={iconSize} class="mr-2" />
						<div style="font-family: var(--header-text);">
							<div class="flex items-end relative top-1">
								<span class="text-3xl relative top-1 mr-1">{account.total}</span>
								<span class="relative -top-[0.075rem]"
									>report{pluralize(account.total)}</span
								>
							</div>
							<div class="relative -top-1 all-small-caps text-xl font-bold">
								Needs Attention
							</div>
						</div>
					{:else if account.total >= 5}
						<CriminalLine size={iconSize} class="mr-2" />
						<div style="font-family: var(--header-text);">
							<div class="flex items-end relative top-1">
								<span class="text-3xl relative top-1 mr-1">{account.total}</span>
								<span class="relative -top-[0.075rem]"
									>report{pluralize(account.total)}</span
								>
							</div>
							<div class="relative -top-1 all-small-caps text-xl font-bold">
								Brow-Raising
							</div>
						</div>
					{:else if account.total >= 3}
						<EmotionUnhappyLine size={iconSize} class="mr-2" />
						<div style="font-family: var(--header-text);">
							<div class="flex items-end relative top-1">
								<span class="text-3xl relative top-1 mr-1">{account.total}</span>
								<span class="relative -top-[0.075rem]"
									>report{pluralize(account.total)}</span
								>
							</div>
							<div class="relative -top-1 all-small-caps text-xl font-bold">
								Possible Issue
							</div>
						</div>
					{:else if account.total >= 1}
						<EmotionNormalLine size={iconSize} class="mr-2" />
						<div style="font-family: var(--header-text);">
							<div class="flex items-end relative top-1">
								<span class="text-3xl relative top-1 mr-1">{account.total}</span>
								<span class="relative -top-[0.075rem]"
									>report{pluralize(account.total)}</span
								>
							</div>
							<div class="relative -top-1 all-small-caps text-xl font-bold">
								Negligible Concern
							</div>
						</div>
					{:else}
						<EmotionLine size={iconSize} class="mr-2" />
						<div style="font-family: var(--header-text);">
							<div class="flex items-end relative top-1">
								<span class="text-3xl relative top-1 mr-1">{account.total}</span>
								<span class="relative -top-[0.075rem]"
									>report{pluralize(account.total)}</span
								>
							</div>
							<div class="relative -top-1 all-small-caps text-xl font-bold">
								Good Standing
							</div>
						</div>
					{/if}
				</div>
				<div class="flex-1"><!--spacer--></div>
				<div
					class="info-block bg-zinc-300 dark:bg-zinc-600 group-hover:bg-zinc-200 dark:group-hover:bg-zinc-700"
				>
					<div>
						<div class="flex items-center text-2xl relative top-1.5">
							{#if account.terms_agree === true}
								<span class="flex-1"> Yes </span>
								<CheckboxCircleLine
									class="text-green-600 relative -top-1"
									size="32px"
								/>
							{:else}
								<span class="flex-1"> No </span>
								<AlertLine class="text-yellow-500 relative -top-1" size="32px" />
							{/if}
						</div>
						<div class="relative -top-0.5 all-small-caps text-xl font-bold">
							Agreed to Terms
						</div>
					</div>
				</div>
				<div
					class="info-block bg-zinc-300 dark:bg-zinc-600 group-hover:bg-zinc-200 dark:group-hover:bg-zinc-700"
				>
					<div>
						<div class="flex items-center text-2xl relative top-1.5">
							{#if account.email_confirmed === true}
								<span class="flex-1"> Yes </span>
								<CheckboxCircleLine
									class="text-green-600 relative -top-1"
									size="32px"
								/>
							{:else}
								<span class="flex-1"> No </span>
								<AlertLine class="text-yellow-500 relative -top-1" size="32px" />
							{/if}
						</div>
						<div class="relative -top-0.5 all-small-caps text-xl font-bold">
							Email Confirmed
						</div>
					</div>
				</div>
				<div
					class="info-block bg-zinc-300 dark:bg-zinc-600 group-hover:bg-zinc-200 dark:group-hover:bg-zinc-700"
				>
					<div>
						<div class="text-2xl relative top-1.5">
							<Time timestamp={account.createdAt} />
						</div>
						<div class="relative -top-0.5 all-small-caps text-xl font-bold">
							Created
						</div>
					</div>
				</div>
			</div>
		</div>
	{:else}
		<div class="empty">
			<h3>Nobody's here yet</h3>
			<p>Check back later once the accounts start rolling in.</p>
		</div>
	{/each}
	{#if data.metadata.total > 0}
		<Paginator
			{currPage}
			{perPage}
			totalItems={data.metadata.total}
			on:change={(event) => loadPage(event.detail)}
		/>
	{/if}
</div>

<style lang="scss">
	div.info-block {
		@apply flex items-center rounded-xl h-[70px] px-2 py-0.5 w-fit mx-1 first:ml-0 last:mr-0;
		font-family: var(--header-text);
	}
	div.good-standing {
		@apply text-white bg-green-700;
	}
	div.negligible-concern {
		@apply bg-yellow-700 text-white;
	}
	div.possible-issue {
		@apply bg-orange-700 text-white;
	}
	div.brow-raising {
		@apply bg-rose-700 text-white;
	}
	div.needs-attention {
		@apply bg-red-700 text-white;
	}
</style>
