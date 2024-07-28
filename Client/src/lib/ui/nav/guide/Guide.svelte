<script lang="ts">
    import { auth } from "$lib/state/auth.state";
	import { onMount } from "svelte";
    import { writable } from "svelte/store";
    import MainPanel from "./MainPanel.svelte";
	import LogOutPanel from "./LogOutPanel.svelte";
	import { fade } from "svelte/transition";

    let button: HTMLButtonElement;
    let offset = writable("0px");
    $: width = 0;

    onMount(() => {
        getOffset();
    });

    const getOffset = () => {
        if (window && button) {
            const scrollX = window.scrollX;
            const isMinWidth = window.matchMedia("(min-width: 768px)").matches;
            if (isMinWidth) {
                $offset = `${button.getBoundingClientRect().left + scrollX - 335}px`;
                return;
            }
        }
        $offset = "0px";
    };

    $: getOffset(), width;

    enum Panels {
        Main,
        LogOut,
    }

    let currPanel = Panels.Main;
</script>

<svelte:window bind:innerWidth={width} />

<button class="relative mx-1 md:mr-0 transition transform hover:scale-110" bind:this={button} popovertarget="guide-menu">
    <div class="absolute z-[2] top-0 right-0">
        <div class="w-[13px] h-[13px] bg-rose-500 rounded-full" style="box-shadow: var(--dropshadow);">
            <div class="w-full h-full bg-rose-500 animate-ping rounded-full" />
        </div>
    </div>
    <div class="w-[40px] h-[40px] z-[1] relative rounded-full border-2 border-white overflow-hidden">
        <img src={$auth.currProfile?.avatar} class="w-full h-full object-cover" />
    </div>
</button>
<div
    id="guide-menu"
    class="[&:popover-open]:inset-[unset] [&:popover-open]:top-[66px] md:[&:popover-open]:w-[375px] [&:popover-open]:w-full [&:popover-open]:m-0 p-2 bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur border-b md:border md:border-t-0 border-zinc-600/25 dark:border-zinc-300/25 md:rounded-b-xl"
    style="box-shadow: var(--dropshadow); color: var(--text-color);"
    style:left={$offset}
    popover="auto"
>
    {#if currPanel === Panels.Main}
        <div in:fade>
            <MainPanel on:logout={() => currPanel = Panels.LogOut} />
        </div>
    {:else if currPanel === Panels.LogOut}
        <div in:fade>
            <LogOutPanel on:cancel={() => currPanel = Panels.Main} />
        </div>
    {/if}
</div>

<style>
    [popover] {
        animation: fadeIn 0.15s ease-in-out;
    }

    @keyframes fadeIn {
        from {
            opacity: 0;
        }
        to {
            opacity: 1;
        }
    }
</style>