<script lang="ts">
	import { localeDate, abbreviate } from "$lib/util/functions";
    import { RiArrowUpSLine, RiArrowDownSLine, RiDiscussLine, RiEditCircleLine, RiDeleteBin2Line } from "svelte-remixicon";
    import { ContentRating } from "$lib/models/util";
    import type { PageData } from "./$types";
	import { Button } from "$lib/ui/util";
    import { BookCheck } from "lucide-svelte";

    export let data: PageData;
</script>

<div class="w-full">
    <div class="relative border-b border-zinc-600/25 dark:border-zinc-300/25">
        <div class="px-4 pt-4 pb-4" style="background: rgb(var(--accent));">
            <div
                class="absolute top-2 right-2 all-small-caps text-white text-lg tracking-wide px-4 rounded-lg font-bold"
                class:bg-green-700={data.blog.rating === ContentRating.everyone}
                class:bg-yellow-600={data.blog.rating === ContentRating.teen}
                class:bg-orange-600={data.blog.rating === ContentRating.mature}
                class:bg-red-700={data.blog.rating === ContentRating.explicit}
                style="font-family: var(--header-text);"
            >
                <span class="relative top-[0.075rem]">{data.blog.rating}</span>
            </div>
            <div class="w-full">
                <h1 class="relative text-4xl text-white max-w-[850px]">{data.blog.title}</h1>
            </div>
            <div class="flex items-center w-full all-small-caps text-xl font-bold text-white/75" style="font-family: var(--header-text);">
                <span>
                    {#if data.blog.publishedOn}
                        {localeDate(data.blog.publishedOn, "longDate")}
                    {:else}
                        {localeDate(data.blog.createdAt, "longDate")}
                    {/if}
                </span>
                <span class="flex-1"><!--spacer--></span>
                <div class="flex items-center" title="Upvotes">
                    <span><RiArrowUpSLine size="22px" /></span>
                    <span>{abbreviate(data.blog.likes)}</span>
                </div>
                <div class="mr-1 text-xl"><!--spacer--></div>
                <div class="flex items-center" title="Downvotes">
                    <span><RiArrowDownSLine size="22px" /></span>
                    <span>{abbreviate(data.blog.dislikes)}</span>
                </div>
                <div class="mx-1 text-xl"><!--spacer--></div>
                <div class="flex items-center" title="Comments">
                    <span class="mr-1"><RiDiscussLine size="18px" /></span>
                    <!--TODO: update with dynamic comment number-->
                    <span>{abbreviate(0)}</span>
                </div>
            </div>
        </div>
        <div class="flex items-center p-2 border-t border-white/50" style="background: rgb(var(--accent));">
            <Button id="edit-button" title="Edit">
                <span class="button-icon"><RiEditCircleLine /></span>
                <span class="button-text">Edit</span>
            </Button>
            <div class="mx-0.5"><!--spacer--></div>
            <Button id="publish-button" title="Publish">
                <span class="button-icon"><BookCheck size="18" /></span>
                <span class="button-text">Publish</span>
            </Button>
            <div class="flex-1"><!--spacer--></div>
            <Button id="delete-button" title="Delete">
                <span class="button-icon"><RiDeleteBin2Line /></span>
                <span class="button-text">Delete</span>
            </Button>
        </div>
    </div>
    <div class="blog-body px-20 py-12">
        {@html data.blog.body}
    </div>
</div>
