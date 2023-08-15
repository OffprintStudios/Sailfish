<script lang="ts">
	import { LinkKinds } from "$lib/models/accounts";
	import { Icon } from "svelte-remix";

	export let kind: string;
	export let href: string | undefined;

	const iconSize = "18px";
</script>

{#if kind === LinkKinds.Facebook}
	<a class="link-tag bg-blue-700 hover:bg-blue-600" {href} target="_blank" rel="noreferrer">
		<Icon name="facebook-fill" width={iconSize} height={iconSize} class="mr-1" />
		<span>Facebook</span>
	</a>
{:else if kind === LinkKinds.Twitter}
	<a class="link-tag bg-cyan-500 hover:bg-cyan-400" {href} target="_blank" rel="noreferrer">
		<Icon name="twitter-fill" width={iconSize} height={iconSize} class="mr-1" />
		<span>Twitter</span>
	</a>
{:else if kind === LinkKinds.Mastodon}
	<a class="link-tag bg-purple-700 hover:bg-purple-600" {href} target="_blank" rel="noreferrer">
		<Icon name="mastodon-fill" width={iconSize} height={iconSize} class="mr-1" />
		<span>Mastodon</span>
	</a>
{:else if kind === LinkKinds.Patreon}
	<a class="link-tag bg-orange-600 hover:bg-orange-500" {href} target="_blank" rel="noreferrer">
		<Icon name="patreon-fill" width={iconSize} height={iconSize} class="mr-1" />
		<span>Patreon</span>
	</a>
{:else if kind === LinkKinds.Twitch}
	<a class="link-tag bg-purple-600 hover:bg-purple-500" {href} target="_blank" rel="noreferrer">
		<Icon name="twitch-fill" width={iconSize} height={iconSize} class="mr-1" />
		<span>Twitch</span>
	</a>
{:else if kind === LinkKinds.Tumblr}
	<a class="link-tag bg-blue-900 hover:bg-blue-800" {href} target="_blank" rel="noreferrer">
		<Icon name="tumblr-fill" width={iconSize} height={iconSize} class="mr-1" />
		<span>Tumblr</span>
	</a>
{:else if kind === LinkKinds.Discord}
	<a class="link-tag bg-indigo-600 hover:bg-indigo-500" {href} target="_blank" rel="noreferrer">
		<Icon name="discord-fill" width={iconSize} height={iconSize} class="mr-1" />
		<span>Discord</span>
	</a>
{:else if kind === LinkKinds.YouTube}
	<a class="link-tag bg-red-600 hover:bg-red-500" {href} target="_blank" rel="noreferrer">
		<Icon name="youtube-fill" width={iconSize} height={iconSize} class="mr-1" />
		<span>YouTube</span>
	</a>
{:else}
	<a class="link-tag bg-zinc-500 hover:bg-zinc-400" {href} target="_blank" rel="noreferrer">
		<Icon name="link" width={iconSize} height={iconSize} class="mr-1" />
		<span>Other</span>
	</a>
{/if}

<style lang="scss">
	a.link-tag {
		@apply flex items-center no-underline py-1 pl-1 pr-1.5 rounded-md text-white mx-0.5 my-0.5;
		&:first-child {
			@apply ml-0;
		}
		&:last-child {
			@apply mr-0;
		}
	}
</style>
