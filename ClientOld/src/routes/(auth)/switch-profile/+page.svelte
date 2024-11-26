<script lang="ts">
    import { Metatags } from "$lib/ui/util";
	import type { PageData } from "./$types";
    import { goto } from "$app/navigation";
    import { auth } from "$lib/state/auth.state";
    import { IconPlus } from "@tabler/icons-svelte";
    import { default as cookies } from "js-cookie";

    export let data: PageData;
</script>

<Metatags
    title="Switch Profile — Offprint"
    desc="So, who's gonna be with us today?"
    url="https://offprint.cafe/switch-profile"
    image="/images/beatriz.png"
/>

<div class="bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg border border-zinc-300/25 dark:border-zinc-600/25 md:rounded-xl max-w-2xl p-6 md:p-12 w-full h-full md:h-fit" style="box-shadow: var(--dropshadow);">
    <div class="flex flex-col items-center justify-center pb-4">
        <h1 class="text-3xl">Select a Profile</h1>
        <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold" style="font-family: var(--header-text);">
            Who's gonna be with us today?
        </span>
    </div>
    <div class="flex items-center justify-center w-full">
        {#each data.profiles as profile}
            <button
                class="flex flex-col items-center rounded-xl p-4 mx-2 w-[140px] h-[170px] hover:bg-zinc-300 dark:hover:bg-zinc-600 transition"
                on:click={() => {
                    $auth.currProfile = profile;
                    cookies.set("profileId", profile.id, { path: "/", expires: 30 });
                    goto("/");
                }}
            >
                <img class="rounded-full object-cover min-w-[100px] min-h-[100px] max-w-[100px] max-h-[100px]" src={profile.avatar} alt="{profile.username}'s Avatar" />
                <span class="pt-3 font-header text-xl truncate max-w-[100px]">
                    {profile.username}
                </span>
            </button>
        {/each}
        {#if data.profiles.length < 3}
            <a
                class="flex flex-col items-center rounded-xl text-default hover:text-default hover:no-underline p-4 mx-2 w-[140px] h-[170px] hover:bg-zinc-300 dark:hover:bg-zinc-600 transition"
                href="/create-profile"
            >
                <div class="flex flex-col items-center justify-center w-[100px] h-[100px] rounded-full border-2 border-dotted">
                    <IconPlus size="36px" />
                </div>
                <span class="pt-3 font-header text-xl">
                    Add New
                </span>
            </a>
        {/if}
    </div>
</div>
