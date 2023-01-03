<script lang="ts">
	import type { Profile } from "$lib/models/accounts";
	import { Avatar } from "$lib/ui/util";
	import { abbreviate, pluralize } from "$lib/util/functions";

	export let profile: Profile;
</script>

<div class="card">
	<a class="absolute h-full w-full" href="/feed/{profile.id}"><!--empty on purpose--></a>
	<Avatar src={profile.avatar} size="100px" borderWidth="1px" />
	<h3 class="text-2xl select-none">{profile.username}</h3>
	<div class="flex items-center text-zinc-400" style="font-family: var(--header-text)">
		<span>{abbreviate(profile.stats.works)} work{pluralize(profile.stats.works)}</span>
		<span class="mr-1">•</span>
		<span>{abbreviate(profile.stats.blogs)} blog{pluralize(profile.stats.blogs)}</span>
	</div>
</div>

<style lang="scss">
	div.card {
		@apply flex flex-col items-center justify-center rounded-xl p-2 transition relative;
		&:hover {
			@apply text-white;
			background: var(--accent);
			h3,
			span {
				@apply text-white;
			}
		}
	}
</style>
