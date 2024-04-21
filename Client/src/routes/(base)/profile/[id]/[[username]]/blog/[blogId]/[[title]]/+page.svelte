<script lang="ts">
	import { localeDate, abbreviate } from "$lib/util/functions";
    import { RiDiscussLine, RiEditCircleLine, RiDeleteBin2Line, RiThumbUpLine, RiThumbDownLine, RiHeartsLine, RiHeartAdd2Line, RiAlarmWarningLine } from "svelte-remixicon";
    import { ContentRating, ListingStatus } from "$lib/models/util";
    import type { PageData } from "./$types";
	import { Button } from "$lib/ui/util";
    import { BookCheck, BookHeart, BookLock, BookOpen, BookOpenCheck, Unlink } from "lucide-svelte";
	import { auth } from "$lib/state/auth.state";

    export let data: PageData;
</script>

<div class="w-full">
    <div class="relative">
        <div class="flex items-center w-full pl-2 pt-4 pr-2.5 h-[36px]">
            <div class="flex-1"><!--spacer--></div>
            <div
                class="flex items-center all-small-caps text-white md:text-lg tracking-wide px-2 md:px-4 rounded-lg font-bold bg-zinc-300 dark:bg-zinc-600"
            >
                {#if data.blog.listingStatus === ListingStatus.public}
                    <BookOpenCheck size="16" />
                {:else if data.blog.listingStatus === ListingStatus.unlisted}
                    <BookOpen size="16" />
                {:else if data.blog.listingStatus === ListingStatus.subscription}
                    <BookHeart size="16" />
                {:else}
                    <BookLock size="16" />
                {/if}
                <span class="ml-1 relative -top-[0.075rem]">{data.blog.listingStatus}</span>
            </div>
            <div class="mx-1"><!--spacer--></div>
            <div
                class="all-small-caps text-white md:text-lg tracking-wide px-2 md:px-4 rounded-lg font-bold"
                class:bg-green-700={data.blog.rating === ContentRating.everyone}
                class:bg-yellow-600={data.blog.rating === ContentRating.teen}
                class:bg-orange-600={data.blog.rating === ContentRating.mature}
                class:bg-red-700={data.blog.rating === ContentRating.explicit}
                style="font-family: var(--header-text);"
            >
                <span class="relative top-[0.075rem]">{data.blog.rating}</span>
            </div>
        </div>
        <div class="flex flex-col items-center justify-center pt-12 md:pt-20 pb-4">
            <h4 class="text-4xl md:text-5xl text-center mx-6">{data.blog.title}</h4>
            <span class="all-small-caps text-xl font-bold text-white/75" style="font-family: var(--header-text);">
                {#if data.blog.publishedOn}
                    {localeDate(data.blog.publishedOn, "longDate")}
                {:else}
                    {localeDate(data.blog.createdAt, "longDate")}
                {/if}
            </span>
            <div class="flex items-center all-small-caps font-bold text-lg text-white/75 relative -top-2">
                <div class="flex items-center" title="Likes">
                    <span class="relative top-0.5 mr-1"><RiThumbUpLine size="18px" /></span>
                    <span>{abbreviate(data.blog.likes)}</span>
                </div>
                <div class="font-thin text-4xl relative -top-0.5 mx-2">/</div>
                <div class="flex items-center" title="Dislikes">
                    <span class="relative top-0.5 mr-1"><RiThumbDownLine size="18px" /></span>
                    <span>{abbreviate(data.blog.dislikes)}</span>
                </div>
                <div class="font-thin text-4xl relative -top-0.5 mx-2">/</div>
                <div class="flex items-center" title="Favorites">
                    <span class="relative top-0.5 mr-1"><RiHeartsLine size="18px" /></span>
                    <span>{abbreviate(0)}</span>
                </div>
                <div class="font-thin text-4xl relative -top-0.5 mx-2">/</div>
                <div class="flex items-center" title="Comments">
                    <span class="relative top-0.5 mr-1"><RiDiscussLine size="18px" /></span>
                    <span>{abbreviate(0)}</span>
                </div>
            </div>
        </div>
    </div>
    <div class="blog-body px-6 py-5 md:px-20 md:py-12">
        {@html data.blog.body}
    </div>
    <div class="flex items-center mx-4 mb-4 p-1.5 bg-zinc-300/50 dark:bg-zinc-600/50 backdrop-blur rounded-xl">
        {#if $auth.currProfile && $auth.currProfile.id === data.blog.author.id}
            <Button id="edit-button" title="Edit">
                <span class="button-icon variable-text"><RiEditCircleLine /></span>
                <span class="button-text hidden md:block">Edit</span>
            </Button>
            <div class="mx-0.5"></div>
            <Button id="publish-button-button" title="Publish">
                <span class="button-icon variable-text"><BookCheck size="18" /></span>
                <span class="button-text hidden md:block">Publish</span>
            </Button>
            <div class="flex-1"></div>
            <Button id="delete-button" title="Delete">
                <span class="button-icon variable-text"><RiDeleteBin2Line /></span>
                <span class="button-text hidden md:block">Delete</span>
            </Button>
        {:else}
            <Button id="like-button" title="Like">
                <span class="button-icon variable-text"><RiThumbUpLine /></span>
                <span class="button-text hidden md:block">Like</span>
            </Button>
            <div class="mx-0.5"></div>
            <Button id="dislike-button" title="Dislike">
                <span class="button-icon variable-text"><RiThumbDownLine /></span>
                <span class="button-text hidden md:block">Dislike</span>
            </Button>
            <div class="mx-1 text-2xl text-zinc-400 dark:text-zinc-500 relative top-[0.075rem]">|</div>
            <Button id="add-to-favorites-button" title="Favorite">
                <span class="button-icon variable-text"><RiHeartAdd2Line /></span>
                <span class="button-text hidden md:block">Favorite</span>
            </Button>
            <div class="flex-1"></div>
            <Button id="report-button" title="Report">
                <span class="button-icon variable-text"><RiAlarmWarningLine /></span>
                <span class="button-text hidden md:block">Report</span>
            </Button>
        {/if}
    </div>
</div>
