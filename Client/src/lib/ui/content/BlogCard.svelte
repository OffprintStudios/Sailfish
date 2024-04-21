<script lang="ts">
    import { RiArrowUpSLine, RiArrowDownSLine, RiDiscussLine, RiEyeOffLine, RiMoreFill, RiCloseLine, RiEditCircleLine, RiDeleteBin2Line } from "svelte-remixicon";
	import type { Blog } from "$lib/models/blogs";
	import { abbreviate, localeDate, slugify } from "$lib/util/functions";
	import { ContentRating } from "$lib/models/util";
    import { app } from "$lib/state/app.state";
    import { auth } from "$lib/state/auth.state";
	import { fade } from "svelte/transition";
    import { BookDashed, BookCheck } from "lucide-svelte";

    export let blog: Blog;
    export let width: string | 'auto' = '380px';

    let moreOptionsOpen = false;
</script>

<div
    title="{blog.title}"
    class="flex flex-col relative min-h-[200px] max-h-[200px] md:min-h-[256px] md:max-h-[256px] rounded-xl overflow-hidden bg-zinc-200/50 dark:bg-zinc-700/50 backdrop-blur border border-zinc-600/25 dark:border-zinc-300/25 hover:bg-zinc-300/50 dark:hover:bg-zinc-600/50 transition"
    style="box-shadow: var(--dropshadow);"
    style:width={width === 'auto' ? '100%' : width}
>
    <a
        class="absolute top-0 right-0 left-0 bottom-0 z-[2]"
        href="/profile/{blog.author.id}/{slugify(blog.author.name)}/blog/{blog.id}/{slugify(blog.title)}"
    ><!--intentionally left blank--></a>
    <div
        class="absolute top-0 right-0 z-[1] all-small-caps text-white px-2 rounded-bl-xl font-bold"
        class:bg-green-700={blog.rating === ContentRating.everyone}
        class:bg-yellow-600={blog.rating === ContentRating.teen}
        class:bg-orange-600={blog.rating === ContentRating.mature}
        class:bg-red-700={blog.rating === ContentRating.explicit}
        class:blur={moreOptionsOpen}
        style="font-family: var(--header-text);"
    >
        {blog.rating}
    </div>
    {#if $auth.currProfile && $auth.currProfile.id === blog.author.id}
        <div class="absolute flex items-center top-0.5 left-1.5 z-[3]">
            <button id="more-options-{blog.id}" title="More Options" class="rounded-xl p-0.5" on:click={() => moreOptionsOpen = !moreOptionsOpen}>
                {#if moreOptionsOpen}
                    <span class="button-icon no-text"><RiCloseLine size="24px" /></span>
                {:else}
                    <span class="button-icon no-text"><RiMoreFill size="24px" /></span>
                {/if}
            </button>
            <div class="mx-1 flex items-center all-small-caps text-lg font-bold tracking-wide" class:blur={moreOptionsOpen} title="{blog.publishedOn ? "Published" : "Draft"}">
                {#if blog.publishedOn}
                    <BookCheck size="16" />
                    <span class="ml-1 relative -top-[0.075rem]">Public</span>
                {:else}
                    <BookDashed size="16" />
                    <span class="ml-1 relative -top-[0.075rem]">Draft</span>
                {/if}
            </div>
        </div>
    {/if}
    {#if ((blog.rating === ContentRating.mature || blog.rating === ContentRating.explicit) && !$app.unblurNsfw) && !moreOptionsOpen}
        <div
            class="absolute w-full h-full flex flex-col items-center justify-center"
            transition:fade={{ delay: 0, duration: 150 }}
        >
            <span class="relative -top-4"><RiEyeOffLine size="42px" /></span>
            <span class="relative -top-4 all-small-caps font-bold tracking-wide">Sensitive Content</span>
        </div>
    {/if}
    {#if moreOptionsOpen}
        <div class="absolute w-full h-full flex items-center justify-center z-[2]">
            <button class="flex flex-col items-center justify-center h-[78px] w-[78px] rounded-full transition" title="Edit {blog.title}">
                <span class="relative top-1"><RiEditCircleLine size="38px" /></span>
                <span class="relative -top-0.5 all-small-caps font-bold tracking-wide">Edit</span>
            </button>
            <div class="mx-0.5"><!--spacer--></div>
            <button class="flex flex-col items-center justify-center h-[78px] w-[78px] rounded-full transition" title="Publish {blog.title}">
                <span class="relative top-1"><BookCheck size="38" /></span>
                <span class="relative -top-0.5 all-small-caps font-bold tracking-wide">Publish</span>
            </button>
            <div class="mx-0.5"><!--spacer--></div>
            <button class="flex flex-col items-center justify-center h-[78px] w-[78px] rounded-full transition hover:bg-red-500 hover:dark:bg-red-500 hover:text-white" title="Delete {blog.title}">
                <span class="relative top-1"><RiDeleteBin2Line size="38px" /></span>
                <span class="relative -top-0.5 all-small-caps font-bold tracking-wide">Delete</span>
            </button>
        </div>
    {/if}
    <div
        class="blog-body text-sm px-6 py-8 h-[calc(200px-50px)] md:h-[calc(256px-60px)] z-0 relative blur transition"
        class:blur={((blog.rating === ContentRating.mature || blog.rating === ContentRating.explicit) && !$app.unblurNsfw) || moreOptionsOpen}
    >
        {@html blog.body}
    </div>
    <div
        class="flex items-center w-full relative z-[1] h-[50px] md:h-[60px] transition"
        class:blur={moreOptionsOpen}
        style="background: rgb(var(--accent));"
    >
        <div class="avatar-box">
            <img src={blog.author.avatar} class="object-cover w-full h-full" alt="{blog.author.name}'s Avatar" title="{blog.author.name}'s Avatar" />
        </div>
        <div class="flex flex-col w-full">
            <h3 class="text-lg md:text-xl text-white relative top-1.5 md:top-1 line-clamp-1">{blog.title}</h3>
            <div class="flex items-center w-full relative -top-1.5 md:-top-1 font-bold text-white/50 all-small-caps tracking-wide pr-3">
                <span class="text-lg hidden lg:block">
                    {#if blog.publishedOn}
                        {localeDate(blog.publishedOn, "longDate")}
                    {:else}
                        {localeDate(blog.createdAt, "longDate")}
                    {/if}
                </span>
                <span class="hidden lg:block flex-1"><!--spacer--></span>
                <div class="flex items-center md:text-lg" title="Upvotes">
                    <span class="relative top-0.5 md:top-[0.075rem]"><RiArrowUpSLine /></span>
                    <span>{abbreviate(blog.likes)}</span>
                </div>
                <div class="mr-1 text-xl"><!--spacer--></div>
                <div class="flex items-center md:text-lg" title="Downvotes">
                    <span class="relative top-0.5 md:top-[0.075rem]"><RiArrowDownSLine /></span>
                    <span>{abbreviate(blog.dislikes)}</span>
                </div>
                <div class="mx-1 text-xl"><!--spacer--></div>
                <div class="flex items-center md:text-lg" title="Comments">
                    <span class="relative top-0.5 md:top-[0.075rem] mr-1"><RiDiscussLine size="14px" /></span>
                    <!--TODO: update with dynamic comment number-->
                    <span>{abbreviate(0)}</span>
                </div>
            </div>
        </div>
    </div>
</div>

<style lang="scss">
    div.avatar-box {
        @apply max-w-[50px] max-h-[50px] min-w-[50px] min-h-[50px] md:max-w-[75px] md:max-h-[75px] md:min-w-[75px] md:min-h-[75px] z-10 mx-2 rounded-full bottom-1 md:bottom-2 overflow-hidden relative border-4 md:border-8;
        border-color: rgb(var(--accent));
    }
</style>
