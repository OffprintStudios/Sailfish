<script lang="ts">
    import { RiThumbUpLine, RiThumbDownLine } from "svelte-remixicon";

    export let width: string | 'auto' = '360px';
</script>

<div
    class="flex flex-col h-[256px] rounded-xl overflow-hidden bg-zinc-200 dark:bg-zinc-700"
    style:width={width === 'auto' ? '100%' : width}
>
    <div class="w-full h-[5rem]" style="background-color: rgb(var(--accent));"><!--banner--></div>
    <div class="flex items-center px-4 pt-2">
        <div class="flex flex-col">
            <span class="all-small-caps font-semibold">SPECULATIVE FICTION</span>
            <h3 class="text-xl line-clamp-1 text-black dark:text-white">Roquelle Pellegnon, Mad Peer Reviewer</h3>
            <span class="text-zinc-400" style="font-family: var(--header-text);">by baxil</span>
        </div>
    </div>
    <div class=" px-4 pb-4 pt-2 text-sm italic h-[56px]">
        <p class="line-clamp-2">
            It's time for Madame Pellegnon to put the science in Mad Science, and teach a peer some lessons about real scientific discovery.
        </p>
    </div>
    <div class="flex items-center px-4 pt-2">
        <div class="flex items-center text-sm text-green-600 font-bold">
            <RiThumbUpLine />
            <span class="ml-0.5">0</span>
        </div>
        <div class="mx-1"><!--spacer--></div>
        <div class="flex items-center text-sm text-red-600 font-bold">
            <RiThumbDownLine />
            <span class="ml-0.5">0</span>
        </div>
        <div class="flex-1"><!--spacer--></div>
        <div class="font-semibold text-zinc-400 text-xs">ORIGINAL</div>
    </div>
</div>
