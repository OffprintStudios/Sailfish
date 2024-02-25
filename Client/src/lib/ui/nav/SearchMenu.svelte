<script lang="ts">
    import { DEFAULT_SLOGANS } from "$lib/models/util";
    import { RiSearchEyeLine } from "svelte-remixicon";

    let currSlogan = DEFAULT_SLOGANS[Math.floor(Math.random() * DEFAULT_SLOGANS.length)];
</script>

<div class="w-full relative">
    <button
        class="hidden md:flex w-11/12 h-[36px] mx-auto items-center justify-center rounded-xl border-2 border-x-transparent border-t-transparent border-zinc-300 bg-zinc-300 bg-opacity-40 backdrop-blur py-1 text-white"
    >
        <span class="mr-2 relative"><RiSearchEyeLine size="18px" /></span>
        <span class="text-xs">{currSlogan}</span>
    </button>
</div>
