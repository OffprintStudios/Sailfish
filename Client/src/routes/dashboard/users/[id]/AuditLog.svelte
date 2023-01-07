<script lang="ts">
	import type { AccountWithReports } from "$lib/models/accounts";
	import type { LogEvent } from "$lib/models/admin/users";
	import type { ResponseError } from "$lib/http";
	import { getReq } from "$lib/http";
	import { CloseLine, Loader5Line } from "svelte-remixicon";
	import { Time } from "$lib/ui/util";

	export let account: AccountWithReports;

	async function fetchLog() {
		const response = await getReq<LogEvent[]>(`/admin/fetch-log/${account.id}`);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			throw new Error(error.message);
		}
		return response as LogEvent[];
	}
</script>

<div
	class="p-4 rounded-xl relative flex flex-col overflow-hidden w-full h-[550px] bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed"
>
	<div class="sticky top-0 mb-4">
		<h3 class="text-2xl">Audit Log</h3>
	</div>
	<div>
		{#await fetchLog()}
			<div class="w-full flex-1 flex flex-col items-center justify-center">
				<span class="flex items-center">
					<Loader5Line size="18px" class="animate-spin mr-1" />
					<span class="uppercase font-bold tracking-wider">Loading</span>
				</span>
			</div>
		{:then logs}
			{#each logs as log}
				<div
					class="even:border-t-2 even:border-b-2 py-1 border-zinc-300 dark:border-zinc-600 font-mono my-1"
				>
					<span class="font-bold"
						><Time timestamp={log.createdAt} format="YYYY-MM-DD HH:mm:ss" /></span
					>
					<div class="flex items-center mb-2">
						<span>[{log.event.type}] {log.event.detail}</span>
					</div>
					{#if log.event.type === "CREATE"}
						<div>Account created by SYSTEM</div>
					{:else}
						<div>action details</div>
					{/if}
				</div>
			{:else}
				<div class="w-full flex-1 flex flex-col items-center justify-center">
					<span class="flex items-center">
						<span class="uppercase font-bold tracking-wider">No logs found</span>
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
</div>
