<script lang="ts">
    import { IconChevronRight } from "@tabler/icons-svelte";
    import WorkCard from "./WorkCard.svelte";
</script>

<div>
    <div class="flex items-center mx-4 md:mx-0 mb-3">
        <slot />
        <div class="flex-1"></div>
        <span class="all-small-caps text-lg md:text-xl font-bold tracking-wide relative -top-[0.075rem]">More</span>
        <IconChevronRight size="30px" /> 
    </div>
    <div class="flex items-center justify-start flex-shrink-0 w-full pb-4 md:pb-8 px-4 snap-x snap-mandatory snap-always overflow-x-scroll scrollbar-none">
        <div class="mr-2 snap-center">
            <WorkCard />
        </div>
        <div class="mr-2 snap-center">
            <WorkCard />
        </div>
        <div class="mr-2 snap-center">
            <WorkCard />
        </div>
        <div class="mr-2 snap-center">
            <WorkCard />
        </div>
        <div class="mr-2 snap-center">
            <WorkCard />
        </div>
        <div class="mr-2 snap-center">
            <WorkCard />
        </div>
        <div class="mr-2 snap-center">
            <WorkCard />
        </div>
        <div class="mr-2 snap-center">
            <WorkCard />
        </div>
        <div class="snap-center">
            <WorkCard />
        </div>
    </div>
</div>