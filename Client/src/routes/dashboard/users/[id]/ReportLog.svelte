<script lang="ts">
	import type { AccountWithReports } from "$lib/models/accounts";
	import type { ResponseError } from "$lib/http";
	import type { Report } from "$lib/models/admin/users/reports";
	import { getReq } from "$lib/http";
	import { CloseLine, Loader5Line } from "svelte-remixicon";
	import { Time } from "$lib/ui/util";

	export let account: AccountWithReports;

	async function fetchReports() {
		const response = await getReq<Report[]>(`/admin/fetch-reports/${account.id}`);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			throw new Error(error.message);
		}
		return response as Report[];
	}
</script>

<div
	class="rounded-xl relative h-[550px] flex flex-col overflow-hidden overflow-y-auto w-full bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed"
>
	<div class="sticky top-0 z-[2] bg-zinc-200 dark:bg-zinc-700 px-4 pt-4 pb-1">
		<h3 class="text-2xl">Reports</h3>
	</div>
	{#await fetchReports()}
		<div class="w-full flex-1 flex flex-col items-center justify-center">
			<span class="flex items-center">
				<Loader5Line size="18px" class="animate-spin mr-1" />
				<span class="uppercase font-bold tracking-wider">Loading</span>
			</span>
		</div>
	{:then reports}
		<div class="px-4 pb-4">
			{#each reports as report}
				<div
					class="w-full bg-zinc-300 dark:bg-zinc-600 rounded-xl p-2 my-1 first:mt-0 last:mb-0 flex flex-col"
				>
					<div class="flex items-center w-full mb-0.5">
						<span
							class="all-small-caps font-bold border border-zinc-400 rounded-lg px-2 py-0.5"
						>
							<span class="relative -top-[0.075rem]">
								<Time
									timestamp={report.createdAt}
									format="MMM DD, YYYY  hh:mm:ss"
								/>
							</span>
						</span>
						<span class="mx-0.5"><!--spacer--></span>
						<span
							class="border border-zinc-400 rounded-lg px-2 py-0.5 all-small-caps font-bold"
						>
							<span class="relative -top-[0.075rem]">Type: {report.type}</span>
						</span>
					</div>
					<div class="border border-zinc-400 rounded-lg text-xs px-2 py-1 my-0.5">
						<div class="mb-0.5">
							<span class="font-bold uppercase">Reason:</span>
							{report.metadata.reason}
						</div>
						{#if report.metadata.itemId}
							<div class="mb-0.5">
								<span class="font-bold uppercase">Item ID:</span>
								<span class="font-mono">{report.metadata.itemId}</span>
							</div>
						{/if}
						{#if report.metadata.desc}
							<div class="mb-0.5">{report.metadata.desc}</div>
						{/if}
						{#if report.metadata.link}
							<div>
								<span class="font-bold uppercase">Link:</span>
								<a href={report.metadata.link}>Link</a>
							</div>
						{/if}
					</div>
					<div class="border border-zinc-400 rounded-lg px-2 py-0.5 my-0.5">
						<div class="relative -top-[0.075rem] all-small-caps font-bold">
							Reported By:
						</div>
						<div class="font-mono relative -top-[0.075rem] text-xs">
							{report.reportedBy.id}
						</div>
					</div>
				</div>
			{:else}
				<div class="w-full flex-1 flex flex-col items-center justify-center">
					<span class="flex items-center">
						<span class="uppercase font-bold tracking-wider">No reports found</span>
					</span>
				</div>
			{/each}
		</div>
	{:catch error}
		<div class="w-full flex-1 flex flex-col items-center justify-center">
			<span class="flex items-center">
				<CloseLine size="18px" class="mr-1" />
				<span class="uppercase font-bold tracking-wider">Error</span>
			</span>
		</div>
	{/await}
</div>
