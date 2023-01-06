<script lang="ts">
	import { LinkKinds } from "$lib/models/accounts";
	import {
		DiscordFill,
		FacebookFill,
		Link,
		MastodonFill,
		PatreonFill,
		TumblrFill,
		TwitchFill,
		TwitterFill,
		YoutubeFill
	} from "svelte-remixicon";

	export let kind: LinkKinds;
	export let href: string;
</script>

{#if kind === LinkKinds.Facebook}
	<a class="link-tag bg-blue-700 hover:bg-blue-600" {href} target="_blank">
		<FacebookFill size="18px" class="mr-1" />
		<span>Facebook</span>
	</a>
{:else if kind === LinkKinds.Twitter}
	<a class="link-tag bg-cyan-500 hover:bg-cyan-400" {href} target="_blank">
		<TwitterFill size="18px" class="mr-1" />
		<span>Twitter</span>
	</a>
{:else if kind === LinkKinds.Mastodon}
	<a class="link-tag bg-purple-700 hover:bg-purple-600" {href} target="_blank">
		<MastodonFill size="18px" class="mr-1" />
		<span>Mastodon</span>
	</a>
{:else if kind === LinkKinds.Patreon}
	<a class="link-tag bg-orange-600 hover:bg-orange-500" {href} target="_blank">
		<PatreonFill size="18px" class="mr-1" />
		<span>Patreon</span>
	</a>
{:else if kind === LinkKinds.Twitch}
	<a class="link-tag bg-purple-600 hover:bg-purple-500" {href} target="_blank">
		<TwitchFill size="18px" class="mr-1" />
		<span>Twitch</span>
	</a>
{:else if kind === LinkKinds.Tumblr}
	<a class="link-tag bg-blue-900 bg-blue-800" {href} target="_blank">
		<TumblrFill size="18px" class="mr-1" />
		<span>Tumblr</span>
	</a>
{:else if kind === LinkKinds.Discord}
	<a class="link-tag bg-indigo-600 bg-indigo-500" {href} target="_blank">
		<DiscordFill size="18px" class="mr-1" />
		<span>Discord</span>
	</a>
{:else if kind === LinkKinds.YouTube}
	<a class="link-tag bg-red-600 bg-red-500" {href} target="_blank">
		<YoutubeFill size="18px" class="mr-1" />
		<span>YouTube</span>
	</a>
{:else if kind === LinkKinds.Other}
	<a class="link-tag bg-zinc-500 bg-zinc-400" {href} target="_blank">
		<Link size="18px" class="mr-1" />
		<span>Other</span>
	</a>
{/if}

<style lang="scss">
	a.link-tag {
		@apply block flex items-center no-underline py-1 pl-1 pr-1.5 rounded-md text-white mx-0.5 first:ml-0 last:mr-0 my-0.5;
	}
</style>
