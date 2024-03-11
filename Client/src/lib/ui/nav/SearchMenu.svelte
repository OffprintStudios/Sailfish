<script lang="ts">
    import { DEFAULT_SLOGANS } from "$lib/models/util";
    import { RiSearchEyeLine } from "svelte-remixicon";

    let currSlogan = DEFAULT_SLOGANS[Math.floor(Math.random() * DEFAULT_SLOGANS.length)];
</script>

<div class="w-full relative">
    <button
        class="menu-button hidden md:flex w-11/12 h-[36px] mx-auto items-center justify-center rounded-xl border-2 border-x-transparent border-t-transparent border-zinc-300 bg-zinc-300/40 backdrop-blur py-1 text-white transition"
    >
        <span class="mr-2 relative"><RiSearchEyeLine size="18px" /></span>
        <span class="text-xs">{currSlogan}</span>
    </button>
</div>

<style lang="scss">
    :-moz-any(.menu-button) {
        background-color: rgba(var(--accent-light), 1.0);

        &:hover {
            background-color: rgb(var(--accent-light), 0.75);
        }
    }
</style>
