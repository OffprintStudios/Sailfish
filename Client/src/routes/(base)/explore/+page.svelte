<script lang="ts">
    import { RiAppsLine, RiLoader2Line, RiBox2Line, RiShining2Line } from "svelte-remixicon";
    import { WorkCard } from "$lib/ui/content";
</script>

<div class="pb-8">
    <div class="explore-nav bg-zinc-200/50 dark:bg-zinc-700/50 border-zinc-700/25 dark:border-zinc-200/25">
        <div class="explore-nav-items">
            <div class="select-box border-zinc-700/25 dark:border-zinc-200/25">
                <span class="relative top-[0.075rem] mr-1"><RiAppsLine /></span>
                <span>All Works</span>
            </div>
            <div class="select-box border-zinc-700/25 dark:border-zinc-200/25">
                <span class="relative top-[0.075rem] mr-1"><RiLoader2Line /></span>
                <span>Newest</span>
            </div>
            <div class="select-box border-zinc-700/25 dark:border-zinc-200/25">
                <span class="relative top-[0.075rem] mr-1"><RiBox2Line /></span>
                <span>All Genres</span>
            </div>
            <div class="select-box border-zinc-700/25 dark:border-zinc-200/25">
                <span class="relative top-[0.075rem] mr-1"><RiShining2Line /></span>
                <span>All Ratings</span>
            </div>
        </div>
    </div>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-2 md:gap-4 w-11/12 mx-auto max-w-7xl">
        <WorkCard width="auto" />
        <WorkCard width="auto" />
        <WorkCard width="auto" />
        <WorkCard width="auto" />
        <WorkCard width="auto" />
        <WorkCard width="auto" />
        <WorkCard width="auto" />
        <WorkCard width="auto" />
        <WorkCard width="auto" />
        <WorkCard width="auto" />
        <WorkCard width="auto" />
        <WorkCard width="auto" />
    </div>
</div>

<style lang="scss">
    div.explore-nav {
        @apply sticky top-[55px] md:top-[65px] flex w-full mb-8 h-[50px] md:h-[55px] backdrop-blur-lg z-10 border-b border-opacity-25;
        box-shadow: var(--dropshadow);

        & > div.explore-nav-items {
            @apply flex justify-start md:justify-center w-full max-w-7xl mx-auto overflow-y-scroll flex-shrink-0;
            -ms-overflow-style: none;
            scrollbar-width: none;

            &::-webkit-scrollbar {
                display: none;
            }
        }
    }

    div.select-box {
        @apply flex flex-shrink-0 items-center justify-center px-3 h-full all-small-caps font-bold tracking-wider text-lg border-r last:border-r-0;
    }
</style>
