<script lang="ts">
	import type { AccountWithReports } from "$lib/models/accounts";
	import type { ResponseError } from "$lib/http";
	import type { Report } from "$lib/models/admin/users/reports";
	import { getReq } from "$lib/http";
	import { CloseLine, Loader5Line } from "svelte-remixicon";

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
	class="p-4 rounded-xl relative h-[550px] flex flex-col overflow-hidden w-full bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed"
>
	<div class="sticky top-0 mb-4">
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
		{#each reports as report}
			here's a report
		{:else}
			<div class="w-full flex-1 flex flex-col items-center justify-center">
				<span class="flex items-center">
					<span class="uppercase font-bold tracking-wider">No reports found</span>
				</span>
			</div>
		{/each}
	{:catch error}
		<div class="w-full flex-1 flex flex-col items-center justify-center">
			<span class="flex items-center">
				<CloseLine size="18px" class="mr-1" />
				<span class="uppercase font-bold tracking-wider">Error</span>
			</span>
		</div>
	{/await}
</div>
