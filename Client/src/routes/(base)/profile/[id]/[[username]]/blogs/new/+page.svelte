<script lang="ts">
    import { TextField, GeneralEditor } from "$lib/ui/forms";
    import { applyAction, enhance } from "$app/forms";
	import Button from "$lib/ui/util/Button.svelte";
	import { RiAddLine, RiCheckboxBlankCircleLine, RiRadioButtonLine } from "svelte-remixicon";
	import type { SubmitFunction } from "@sveltejs/kit";
	import { ContentRating } from "$lib/models/util";
	import { slugify, throwError } from "$lib/util/functions";
	import toast from "svelte-french-toast";
	import type { ActionData, PageData } from "./$types";

    export let data: PageData;
    export let form: ActionData;

    let loading = false;
    let body = "";
    let rating = ContentRating.everyone;

    const createBlog: SubmitFunction = ({ formData, controller }) => {
        loading = true;

        const title = formData.get("title")?.toString() ?? throwError("Expected a string, got undefined");
        if (title.length < 3 || title.length > 240) {
            toast.error("Titles must be between 3 and 240 characters long");
            loading = false;
            controller.abort();
        }
        if (body.length < 3) {
            toast.error("Blog content must be at least 3 characters long");
            loading = false;
            controller.abort();
        }

        formData.set("title", title);
        formData.set("body", body);
        formData.set("rating", rating);
        formData.set("profileId", data.id);
        formData.set("redirectUrl", `/profile/${data.id}/${slugify(data.username)}/blogs`);

        return async ({ result }) => {
            loading = false;
            await applyAction(result);
        }
    }

    $: {
        if (form?.error) {
            toast.error(form!.error.message, { duration: 5000 });
        }
    }
</script>

<div class="w-full my-6 py-6 bg-zinc-200/50 dark:bg-zinc-700/50 backdrop-blur-lg rounded-xl border border-zinc-600/25 dark:border-zinc-300/25" style="box-shadow: var(--dropshadow);">
    <form class="flex flex-col max-w-3xl w-11/12 mx-auto" method="post" use:enhance={createBlog}>
        <h3 class="text-2xl text-center mb-6">Create a New Blog</h3>
        <TextField
            name="title"
            label="Title"
            hint="240 characters max"
            placeholder="Just Another Rundown"
            required
            value={null}
        />
        <div class="my-2"><!--spacer--></div>
        <GeneralEditor
            label="Content"
            hint="3 characters minimum"
            bind:value={body}
        />
        <div class="my-2"><!--spacer--></div>
        <div>
            <div class="flex items-center mx-2">
                <span class="flex-1 all-small-caps font-bold tracking-wide">Rating <span class="text-red-600 text-lg relative top-0.5">*</span></span>
                <span class="italic text-zinc-500 dark:text-zinc-400 font-bold tracking-wide all-small-caps">Choose 1</span>
            </div>
            <div class="grid grid-cols-1 md:gap-2 md:grid-cols-4 mb-6">
                <button
                    type="button"
                    class="hover:bg-green-600 hover:dark:bg-green-600 p-2 rounded-xl transition text-left border border-green-600 hover:border-zinc-300 dark:hover:border-white"
                    on:click={() => rating = ContentRating.everyone}
                >
                    <span class="flex items-center w-full">
                        {#if rating === ContentRating.everyone}
                            <RiRadioButtonLine size="20px" />
                        {:else}
                            <RiCheckboxBlankCircleLine size="20px" />
                        {/if}
                        <span class="ml-1 font-bold relative top-[0.05rem]">Everyone</span>
                    </span>
                    <span class="text-xs italic mt-1">
                        Not even a swear word.
                    </span>
                </button>
                <button
                    type="button"
                    class="hover:bg-yellow-500 hover:dark:bg-yellow-500 p-2 my-2 md:my-0 rounded-xl transition text-left border border-yellow-600 hover:border-zinc-300 dark:hover:border-white"
                    on:click={() => rating = ContentRating.teen}
                >
                    <span class="flex items-center w-full">
                        {#if rating === ContentRating.teen}
                            <RiRadioButtonLine size="20px" />
                        {:else}
                            <RiCheckboxBlankCircleLine size="20px" />
                        {/if}
                        <span class="ml-1 font-bold relative top-[0.05rem]">Teen</span>
                    </span>
                    <span class="text-xs italic mt-1">
                        Suitable for most content.
                    </span>
                </button>
                <button
                    type="button"
                    class="hover:bg-orange-600 hover:dark:bg-orange-600 p-2 mb-2 md:mb-0 rounded-xl transition text-left border border-orange-600 hover:border-zinc-300 dark:hover:border-white"
                    on:click={() => rating = ContentRating.mature}
                >
                    <span class="flex items-center w-full">
                        {#if rating === ContentRating.mature}
                            <RiRadioButtonLine size="20px" />
                        {:else}
                            <RiCheckboxBlankCircleLine size="20px" />
                        {/if}
                        <span class="ml-1 font-bold relative top-[0.05rem]">Mature</span>
                    </span>
                    <span class="text-xs italic mt-1">
                        Some heavy topics allowed.
                    </span>
                </button>
                <button
                    type="button"
                    class="hover:bg-red-600 hover:dark:bg-red-600 p-2 rounded-xl transition text-left border border-red-600 hover:border-zinc-300 dark:hover:border-white"
                    on:click={() => rating = ContentRating.explicit}
                >
                    <span class="flex items-center w-full">
                        {#if rating === ContentRating.explicit}
                            <RiRadioButtonLine size="20px" />
                        {:else}
                            <RiCheckboxBlankCircleLine size="20px" />
                        {/if}
                        <span class="ml-1 font-bold relative top-[0.05rem]">Explicit</span>
                    </span>
                    <span class="text-xs italic mt-1">
                        (Almost) anything goes.
                    </span>
                </button>
            </div>
            <hr class="mb-6 border-0" />
            <div class="w-8/12 mx-auto">
                <Button id="create-button" title="Create Blog" type="submit" kind="primary" {loading} loadingText="Saving..." fullWidth>
                    <span class="button-icon"><RiAddLine /></span>
                    <span class="button-text">Create</span>
                </Button>
            </div>
        </div>
    </form>
</div>
