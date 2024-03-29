<script lang="ts">
    import { RiArrowUpSLine, RiArrowDownSLine, RiDiscussLine, RiEyeOffLine, RiDeleteBin2Line } from "svelte-remixicon";
	import type { Blog } from "$lib/models/blogs";
	import { abbreviate, localeDate, slugify } from "$lib/util/functions";
	import { ContentRating } from "$lib/models/util";
    import { app } from "$lib/state/app.state";
    import { auth } from "$lib/state/auth.state";
	import { fade } from "svelte/transition";
	import Button from "../util/Button.svelte";

    export let blog: Blog;
    export let width: string | 'auto' = '380px';
</script>

<div
    title="{blog.title}"
    class="flex flex-col relative min-h-[256px] max-h-[256px] rounded-xl overflow-hidden bg-zinc-200/50 dark:bg-zinc-700/50 backdrop-blur border border-zinc-600/25 dark:border-zinc-300/25 hover:bg-zinc-300/50 dark:hover:bg-zinc-600/50 transition"
    style="box-shadow: var(--dropshadow);"
    style:width={width === 'auto' ? '100%' : width}
>
    <a
        class="absolute top-0 right-0 left-0 bottom-0 z-[2]"
        href="/profile/{blog.author.id}/{slugify(blog.author.name)}/blog/{blog.id}/{slugify(blog.title)}"
    ><!--intentionally left blank--></a>
    {#if $auth.currProfile && $auth.currProfile.id === blog.author.id}
        <div class="absolute top-1.5 left-1.5 z-[2]">
            <Button id="delete-blog-{blog.id}" title="Delete" kind="primary">
                <span class="button-icon no-text"><RiDeleteBin2Line /></span>
            </Button>
        </div>
    {/if}
    <div
        class="absolute top-0 right-0 z-[1] all-small-caps text-white px-2 rounded-bl-xl font-bold"
        class:bg-green-700={blog.rating === ContentRating.everyone}
        class:bg-yellow-600={blog.rating === ContentRating.teen}
        class:bg-orange-600={blog.rating === ContentRating.mature}
        class:bg-red-700={blog.rating === ContentRating.explicit}
        style="font-family: var(--header-text);"
    >
        {blog.rating}
    </div>
    {#if (blog.rating === ContentRating.mature || blog.rating === ContentRating.explicit) && !$app.unblurNsfw}
        <div class="absolute w-full h-full flex flex-col items-center justify-center" transition:fade={{ delay: 0, duration: 150 }}>
            <span class="relative -top-4"><RiEyeOffLine size="42px" /></span>
            <span class="relative -top-4 all-small-caps font-bold tracking-wide">Sensitive Content</span>
        </div>
    {/if}
    <div class="blog-body text-sm p-6 h-[calc(256px-60px)] z-0 relative blur transition" class:blur={(blog.rating === ContentRating.mature || blog.rating === ContentRating.explicit) && !$app.unblurNsfw}>
        {@html blog.body}
    </div>
    <div class="flex items-center w-full relative z-[1] h-[60px]" style="background: rgb(var(--accent));">
        <div class="avatar-box">
            <img src={blog.author.avatar} class="object-cover w-full h-full" alt="{blog.author.name}'s Avatar" title="{blog.author.name}'s Avatar" />
        </div>
        <div class="flex flex-col w-full" style="font-family: var(--header-text);">
            <h3 class="text-xl text-white relative top-1 max-w-[350px] truncate">{blog.title}</h3>
            <div class="flex items-center w-full relative -top-1 font-bold text-white/50 all-small-caps pr-3">
                <span class="text-lg hidden lg:block">{localeDate(blog.createdAt, "longDate")}</span>
                <span class="hidden lg:block flex-1"><!--spacer--></span>
                <div class="flex items-center text-lg" title="Upvotes">
                    <span><RiArrowUpSLine /></span>
                    <span>{abbreviate(blog.likes)}</span>
                </div>
                <div class="mr-1 text-xl"><!--spacer--></div>
                <div class="flex items-center text-lg" title="Downvotes">
                    <span><RiArrowDownSLine /></span>
                    <span>{abbreviate(blog.dislikes)}</span>
                </div>
                <div class="mx-1 text-xl"><!--spacer--></div>
                <div class="flex items-center text-lg" title="Comments">
                    <span class="mr-1"><RiDiscussLine size="14px" /></span>
                    <!--TODO: update with dynamic comment number-->
                    <span>{abbreviate(0)}</span>
                </div>
            </div>
        </div>
    </div>
</div>

<style lang="scss">
    div.avatar-box {
        @apply max-w-[85px] max-h-[85px] min-w-[85px] min-h-[85px] z-10 mx-2 rounded-full bottom-4 overflow-hidden relative border-8;
        border-color: rgb(var(--accent));
    }
</style>
