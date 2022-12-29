<script lang="ts">
	import type { Paginate } from "$lib/util/types";
	import type { AccountWithReports } from "$lib/models/accounts";
	import type { ResponseError } from "$lib/http";
	import { getReq } from "$lib/http";
	import { page } from "$app/stores";
	import { Button, Paginator, Avatar } from "$lib/ui/util";
	import { pluralize } from "$lib/util/functions";
	import {
		EmotionLine,
		EmotionNormalLine,
		EmotionUnhappyLine,
		CriminalLine,
		Skull2Line
	} from "svelte-remixicon";
	import toast from "svelte-french-toast";

	export let data: Paginate<AccountWithReports>;
	$: pageNum = +($page.url.searchParams.get("page") ?? "1");
	$: perPage = +($page.url.searchParams.get("per") ?? "20");
	let loading = false;
	const iconSize = "50px";

	async function loadPage(newPage: number) {
		loading = true;
		$page.url.searchParams.set("page", `${newPage}`);
		const response = await getReq<Paginate<AccountWithReports>>(
			`/admin/fetch-users?page=${newPage}&per=${perPage}`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			data = response as Paginate<AccountWithReports>;
		}
		loading = false;
	}
</script>

<div class="max-w-6xl mx-auto mb-6">
	{#each data.items as account}
		<div
			class="flex items-center rounded-xl p-4 w-full my-6 first:mt-0 last:mb-0 bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed"
		>
			<div>
				<div class="font-mono text-zinc-400 font-bold mb-2">Account ID: {account.id}</div>
				<div
					class="flex items-center border rounded-xl px-2 py-0.5 w-fit"
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
			</div>
			<div class="flex-1"><!--spacer--></div>
			<div class="flex items-center">
				{#each account.profiles as profile}
					<span class="relative z-[2]" title={profile.username}>
						<Avatar src={profile.avatar} size="42px" borderWidth="1px" />
					</span>
				{:else}
					<span>No Profiles Added</span>
				{/each}
			</div>
		</div>
	{:else}
		<div class="empty">
			<h3>Nobody's here yet</h3>
			<p>Check back later once the accounts start rolling in.</p>
		</div>
	{/each}
</div>

<style lang="scss">
	div.good-standing {
		@apply border-green-600 bg-green-700 bg-opacity-25;
	}
	div.negligible-concern {
		@apply border-yellow-600 bg-yellow-700 bg-opacity-25;
	}
	div.possible-issue {
		@apply border-orange-600 bg-orange-700 bg-opacity-25;
	}
	div.brow-raising {
		@apply border-rose-600 bg-rose-700 bg-opacity-25;
	}
	div.needs-attention {
		@apply border-red-600 bg-red-700 bg-opacity-25;
	}
</style>
