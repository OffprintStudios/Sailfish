<script lang="ts">
	import { RiEmotionLaughLine, RiSwordLine, RiMoonFoggyLine, RiFilePaper2Line, RiDoorClosedLine, RiMagicLine, RiGhost2Line, RiSearch2Line, RiHeartsLine, RiEmotionSadLine, RiAliensLine, RiHome3Line, RiMeteorLine, RiSpyLine, RiSkullLine, RiBox2Line } from "svelte-remixicon";

    const genres = [
        { id: 1, name: 'Action/Adventure', icon: RiSwordLine },
        { id: 2, name: 'Comedy', icon: RiEmotionLaughLine },
        { id: 3, name: 'Dark', icon: RiMoonFoggyLine },
        { id: 4, name: 'Drama', icon: RiFilePaper2Line },
        { id: 5, name: 'Erotica', icon: RiDoorClosedLine },
        { id: 6, name: 'Fantasy', icon: RiMagicLine },
        { id: 7, name: 'Horror', icon: RiGhost2Line },
        { id: 8, name: 'Mystery', icon: RiSearch2Line },
        { id: 9, name: 'Romance', icon: RiHeartsLine },
        { id: 10, name: 'Sad', icon: RiEmotionSadLine },
        { id: 11, name: 'Science Fiction', icon: RiAliensLine },
        { id: 12, name: 'Slice of Life', icon: RiHome3Line },
        { id: 13, name: 'Speculative Fiction', icon: RiMeteorLine },
        { id: 14, name: 'Thriller', icon: RiSpyLine },
        { id: 15, name: 'Tragedy', icon: RiSkullLine }
    ];
</script>

<div>
    <div class="flex items-center mb-3 mx-4 md:mx-0">
        <RiBox2Line size="30px" />
        <h3 class="text-2xl text-black dark:text-white mx-2">Genres</h3>
        <div class="flex-1"><!--spacer--></div>
    </div>
    <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-0 md:gap-2">
        {#each genres as genre}
            <div class="flex flex-col items-center justify-center overflow-hidden px-4 py-2 border border-zinc-300 dark:border-zinc-600 odd:border-l-0 even:border-r-0 md:border-0 md:rounded-xl bg-zinc-200 dark:bg-zinc-700 h-[106px]">
                <span class="relative top-0.5">
                    <svelte:component this={genre.icon} size="36px" />
                </span>
                <span class="text-center all-small-caps font-bold break-words text-lg leading-relaxed">{genre.name}</span>
            </div>
        {/each}
    </div>
</div>
