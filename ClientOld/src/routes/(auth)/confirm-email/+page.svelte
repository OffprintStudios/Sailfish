<script lang="ts">
    import type { PageData } from "./$types";
    import { IconMailCheck, IconMailQuestion, IconMailX } from "@tabler/icons-svelte";

    export let data: PageData;
</script>

<div class="flex flex-col justify-center bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit overflow-y-scroll">
    <div class="flex flex-col items-center justify-center">
        {#if data.success}
            <h1 class="text-3xl">Email confirmed!</h1>
            <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pb-8" style="font-family: var(--header-text);">
                Welcome to Offprint
            </span>
            <span class="text-green-500"><IconMailCheck size="150px" /></span>
            <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pt-8" style="font-family: var(--header-text);">
                Looks like you're ready to get started.
            </span>
            <a class="text-center w-full pt-4 text-zinc-500 dark:text-zinc-400 text-sm hover:underline" href="/log-in">
                Without further ado, yeah?
            </a>
        {:else if data.error}
            <h1 class="text-3xl">Uh-oh...</h1>
            <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pb-8" style="font-family: var(--header-text);">
                Something went wrong
            </span>
            <span class="text-red-500"><IconMailX size="150px" /></span>
            <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pt-8" style="font-family: var(--header-text);">
                Seems like there's been a hiccup on our end.
            </span>
            <a class="text-center w-full pt-4 text-zinc-500 dark:text-zinc-400 text-sm hover:underline" href="/settings">
                Get in touch with our mod team.
            </a>
        {:else}
            <h1 class="text-3xl">Huh</h1>
            <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pb-8" style="font-family: var(--header-text);">
                Well that's weird
            </span>
            <span class="text-blue-500"><IconMailQuestion size="150px" /></span>
            <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pt-8" style="font-family: var(--header-text);">
                Doesn't seem like you got all your ducks in a row
            </span>
            <a class="text-center w-full pt-4 text-zinc-500 dark:text-zinc-400 text-sm hover:underline" href="/log-in">
                Let's try this all again, shall we?
            </a>
        {/if}
    </div>
</div>