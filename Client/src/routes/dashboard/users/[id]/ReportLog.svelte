<script lang="ts">
	import type { AccountWithReports } from "$lib/models/accounts";
	import type { ResponseError } from "$lib/http";
	import { getReq } from "$lib/http";

	export let account: AccountWithReports;

	enum ReportLogTabs {
		Reports,
		AuditLog
	}
	let currTab = ReportLogTabs.Reports;

	function switchTab(newTab: ReportLogTabs) {
		currTab = newTab;
	}

	async function fetchReports() {
		const response = await getReq(``);
	}
</script>

<div class="p-4 rounded-xl w-full h-full bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
	<div class="tabs">
		<button
			class:active={currTab === ReportLogTabs.Reports}
			on:click={() => switchTab(ReportLogTabs.Reports)}
		>
			<span class="relative top-0.5">Reports</span>
		</button>
		<button
			class:active={currTab === ReportLogTabs.AuditLog}
			on:click={() => switchTab(ReportLogTabs.AuditLog)}
		>
			<span class="relative top-0.5">Audit Log</span>
		</button>
	</div>
	<div class="h-[500px] w-full overflow-y-scroll">
		{#if currTab === ReportLogTabs.Reports}
			reports
		{:else}
			audit log
		{/if}
	</div>
</div>

<style lang="scss">
	div.tabs {
		@apply flex items-center mb-4;
		button {
			@apply text-2xl px-2 py-1 first:rounded-tl-xl border-b-4 border-transparent transition;
			font-family: var(--header-text);
			color: var(--accent);
			&.active {
				border-color: var(--accent);
			}
		}
	}
</style>
