<script lang="ts">
    import { Kind, type FetchWorkPage } from "$lib/models/content/works";
	import { Button, Time } from "$lib/ui/util";
	import { Icon } from "svelte-remix";
    import { abbreviate, readingTime } from "$lib/util/functions";

    export let data: FetchWorkPage;
    let sortNewest = false;
    let sectionList = [...data.tableOfContents];

    let sectionsName = "Sections";
    switch (data.work.kind) {
        case Kind.Prose:
            sectionsName = "Chapters";
            break;
        case Kind.Poetry:
            sectionsName = "Poems";
            break;
        case Kind.Nonfiction:
            sectionsName = "Sections";
            break;
        case Kind.Script:
            sectionsName = "Parts";
            break;
        case Kind.Anthology:
            sectionsName = "Entries";
            break;
    }

    function toggleSort() {
        sortNewest = !sortNewest;
        let oldArray = [...sectionList];
        oldArray.reverse();
        sectionList = oldArray;
    }
</script>

<div class="pb-8">
    <div class="flex items-center">
        <div class="flex flex-col flex-1 text-sm">
            <span class="font-bold">0 Volumes, {data.tableOfContents.length} {sectionsName}</span>
            <span class="text-zinc-500">{data.work.status}</span>
        </div>
        <Button on:click={toggleSort}>
            {#if sortNewest}
                <Icon name="sort-asc" class="button-icon" width="16px" height="16px" />
                <span class="button-text">
                    Newest
                </span>
            {:else}
                <Icon name="sort-desc" class="button-icon" width="16px" height="16px" />
                <span class="button-text">
                    Oldest
                </span>
            {/if}
        </Button>
    </div>
    <ul class="list-none w-full bg-zinc-200 dark:bg-zinc-700 rounded-xl overflow-hidden mt-6">
        {#each sectionList as section}
            <li class="with-link border-zinc-300 dark:border-zinc-600 hover:bg-zinc-400 dark:hover:bg-zinc-500">
                <a href="/section/{section.id}">
                    <div class="flex flex-col flex-1">
                        <span>{section.title}</span>
                        <div class="flex items-center text-xs uppercase font-bold text-zinc-500 dark:text-zinc-400">
                            <span><Icon name="calendar-2-line" width="16px" height="16px" class="mr-1" /></span>
                            {#if section.publishedOn}
                                <span class="relative top-[0.075rem]"><Time timestamp={section.publishedOn} /></span>
                            {:else}
                                <span class="relative top-[0.075rem]"><Time timestamp={section.createdAt} /></span>
                            {/if}
                            <span class="mx-1">•</span>
                            <span class="hidden lg:block"><Icon name="open-arm-line" width="16px" height="16px" class="mr-1" /></span>
							<span class="hidden lg:block relative top-[0.075rem]">{abbreviate(section.cheers)}</span>
							<span class="hidden lg:block mx-1">•</span>
							<span class="hidden lg:block"><Icon name="question-answer-line" width="16px" height="16px" class="mr-1" /></span>
							<span class="hidden lg:block relative top-[0.075rem]">{abbreviate(section.comments)}</span>
							<span class="hidden lg:block mx-1">•</span>
                            <span><Icon name="time-line" width="16px" height="16px" class="mr-1" /></span>
                            <span class="relative top-[0.075rem]">{readingTime(section.words)}</span>
                        </div>
                    </div>
                    <Icon name="arrow-right-s-line" width="20px" height="20px" class="text-zinc-500 dark:text-zinc-400" />
                </a>
            </li>
        {/each}
    </ul>
</div>

<style lang="scss">
    ul {
		@apply ml-0;
		li {
			@apply flex items-center my-0 px-4 py-3.5 border-b-2 last:border-0;
		}
		li.with-link {
			@apply my-0 px-0 py-0 border-b-2 last:border-0 transition;
			a {
				@apply w-full h-full flex items-center px-4 py-3.5 no-underline;
				color: var(--text-color);
			}
		}
    }
</style>