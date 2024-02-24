<script lang="ts">
    import { RiMailCheckLine, RiUserForbidLine } from "svelte-remixicon";
    import { onMount } from "svelte";
    import { auth } from "$lib/state/auth.state";

    let showUnavailableActionPrompt = false;

    onMount(() => {
        if ($auth.account) {
            showUnavailableActionPrompt = true;
        }
    });
</script>

<div class="bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit overflow-y-scroll">
    {#if showUnavailableActionPrompt}
        <div class="flex flex-col items-center justify-center">
            <h1 class="text-3xl">Whoops!</h1>
            <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pb-8" style="font-family: var(--header-text);">
                Looks like you've taken the wrong turn.
            </span>
            <RiUserForbidLine size="150px" />
            <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pt-8" style="font-family: var(--header-text);">
                You're already logged in!
            </span>
        </div>
    {:else}
        <div class="flex flex-col items-center justify-center">
            <h1 class="text-3xl">Check your inbox!</h1>
            <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pb-8" style="font-family: var(--header-text);">
                We've sent a confirmation email.
            </span>
            <span><RiMailCheckLine size="150px" /></span>
            <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pt-8" style="font-family: var(--header-text);">
                Your account will remain locked<br/>until you confirm it.
            </span>
            <a class="text-center w-full pt-4 text-zinc-500 dark:text-zinc-400 text-sm hover:underline" href="/log-in">
                After that, just log on in!
            </a>
        </div>
    {/if}
</div>
