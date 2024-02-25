<script lang="ts">
    import { RiArrowRightSLine } from "svelte-remixicon";
    import WorkCard from "./WorkCard.svelte";
</script>

<div>
    <div class="flex items-center mx-4 md:mx-0 mb-3">
        <slot />
        <div class="flex-1"><!--spacer--></div>
        <span class="all-small-caps text-xl font-bold tracking-wide relative -top-[0.075rem]">More</span>
        <RiArrowRightSLine size="30px" />
    </div>
    <div class="flex items-center justify-start flex-shrink-0 w-full pb-2 px-4 md:px-0 snap-x snap-mandatory snap-always overflow-y-scroll">
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
