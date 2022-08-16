<script lang="ts">
	import { profileState } from "$lib/state/profile.state";
	import { account } from "$lib/state/account.state";
	import BlogsManagement from "./BlogsManagement.svelte";
</script>

{#if $account.account && $account.currProfile && $account.currProfile.id === $profileState.id}
	<BlogsManagement />
{:else}
	blogs list
{/if}
