<script lang="ts">
	import type { AccountWithReports } from "$lib/models/accounts";
	import { ProfileCard } from "$lib/ui/content";

	export let account: AccountWithReports;
</script>

<div
	class="p-4 rounded-xl w-full h-full overflow-hidden bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed"
>
	<h3 class="text-2xl mb-4">Profiles</h3>
	<div class="flex items-center overflow-x-auto">
		{#each account.profiles as profile}
			<div class="mb-4 mx-2 border-4 rounded-lg border-zinc-300 dark:border-zinc-600">
				<ProfileCard {profile} showBanner={false} showId={true} />
			</div>
		{/each}
	</div>
</div>
