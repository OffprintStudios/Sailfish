<script lang="ts">
	import type { Blog } from "$lib/models/blogs";
	import { localeDate, slugify, abbreviate } from "$lib/util/functions";
	import { BookCheck, BookDashed } from "lucide-svelte";
    import { ContentRating } from "$lib/models/util";
    import { RiArrowUpSLine, RiArrowDownSLine, RiDiscussLine, RiEditCircleLine, RiDeleteBin2Line } from "svelte-remixicon";

    export let blog: Blog;
</script>

<div class="flex items-center relative p-2 w-full border-b last:border-b-0 border-zinc-600/25 dark:border-zinc-300/25 hover:bg-zinc-300/50 dark:hover:bg-zinc-600/50 transition">
    <a
        class="absolute top-0 right-0 left-0 bottom-0 z-[2]"
        href="/profile/{blog.author.id}/{slugify(blog.author.name)}/blog/{blog.id}/{slugify(blog.title)}"
    ><!--intentionally left blank--></a>
    <!--<div>
        {#if blog.publishedOn}
            <button class="p-1"><BookCheck size="42" /></button>
        {:else}
            <button class="p-2 mr-2 rounded-lg transition"><BookDashed size="42" /></button>
        {/if}
    </div>-->
    <button class="hidden md:flex flex-col items-center justify-center relative mr-2 z-[3] h-[67px] w-[67px] rounded-full transition" title="Publish {blog.title}">
        {#if blog.publishedOn}
            <span class="relative"><BookCheck size="28" /></span>
        {:else}
            <span class="relative"><BookDashed size="28" /></span>
        {/if}
    </button>
    <div class="flex-1">
        <h3 class="text-2xl relative max-w-[610px] truncate top-1">{blog.title}</h3>
        <div class="flex items-center relative -top-1 all-small-caps font-bold tracking-wide text-lg text-zinc-500 dark:text-zinc-400">
            <span>
                {#if blog.publishedOn}
                    {localeDate(blog.publishedOn, 'longDate')}
                {:else}
                    {localeDate(blog.createdAt, 'longDate')}
                {/if}
            </span>
            <span class="mx-2 relative -top-[0.075rem] text-xl">/</span>
            <div class="flex items-center text-lg" title="Upvotes">
                <span class="relative top-[0.075rem]"><RiArrowUpSLine /></span>
                <span>{abbreviate(blog.likes)}</span>
            </div>
            <div class="mr-1 text-xl"><!--spacer--></div>
            <div class="flex items-center text-lg" title="Downvotes">
                <span class="relative top-[0.075rem]"><RiArrowDownSLine /></span>
                <span>{abbreviate(blog.dislikes)}</span>
            </div>
            <div class="mx-1 text-xl"><!--spacer--></div>
            <div class="flex items-center text-lg" title="Comments">
                <span class="relative top-[0.075rem] mr-1"><RiDiscussLine size="14px" /></span>
                <!--TODO: update with dynamic comment number-->
                <span>{abbreviate(0)}</span>
            </div>
        </div>
    </div>
    <div
        class="z-[1] all-small-caps text-lg text-white px-4 mr-4 rounded-lg font-bold"
        class:bg-green-700={blog.rating === ContentRating.everyone}
        class:bg-yellow-600={blog.rating === ContentRating.teen}
        class:bg-orange-600={blog.rating === ContentRating.mature}
        class:bg-red-700={blog.rating === ContentRating.explicit}
        style="font-family: var(--header-text);"
    >
        {blog.rating}
    </div>
    <button class="hidden md:flex flex-col items-center justify-center relative z-[3] h-[67px] w-[67px] rounded-full transition" title="Edit {blog.title}">
        <span class="relative"><RiEditCircleLine size="28px" /></span>
    </button>
    <div class="hidden md:block mx-0.5"><!--spacer--></div>
    <button class="hidden md:flex flex-col items-center justify-center relative z-[3] h-[67px] w-[67px] rounded-full transition hover:bg-red-500 hover:dark:bg-red-500 hover:text-white" title="Delete {blog.title}">
        <span class="relative"><RiDeleteBin2Line size="28px" /></span>
    </button>
</div>
