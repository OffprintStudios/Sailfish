<script lang="ts">
	import { Avatar, Button } from "$lib/ui/util";
	import { RiImageCircleLine, RiLandscapeLine, RiSave2Line } from "svelte-remixicon";
	import type { PageData } from "./$types";
    import { TextField, TextArea } from "$lib/ui/forms";

    export let data: PageData;
</script>

<div class="border-b border-zinc-600/25 dark:border-zinc-300/25 pb-4 mb-4">
    <div class="flex items-center justify-center">
        <Avatar src={data.avatar} size="125px" />
        <div class="mx-1"></div>
        <Avatar src={data.avatar} size="100px" />
        <div class="mx-1"></div>
        <Avatar src={data.avatar} size="50px" />
    </div>
    <div class="flex items-center justify-center mt-4">
        <Button id="upload-button" title="Upload">
            <span class="button-icon"><RiImageCircleLine /></span>
            <span class="button-text">Upload Avatar</span>
        </Button>
    </div>
</div>

<div class="border-b border-zinc-600/25 dark:border-zinc-300/25 pb-4 mb-4">
    <form>
        <TextField
            name="username"
            label="Username"
            placeholder="Sombeody New"
            value={null}
            required
        />
        <div class="my-2"></div>
        <TextArea
            name="bio"
            label="Bio"
            placeholder="Just another new face at the bar"
            value={null}
            required
        />
        <div class="my-2"></div>
        <div class="w-8/12 mx-auto">
            <Button
                id="save-profile"
                title="Save Profile"
                type="submit"
                kind="primary"
                fullWidth
            >
                <span class="button-icon"><RiSave2Line /></span>
                <span class="button-text">Save</span>
            </Button>
        </div>
    </form>
</div>

<div class="flex flex-col items-center justify-center">
    <div class="w-11/12 mx-auto md:w-[450px] h-[150px] overflow-hidden rounded-xl" style="background: rgb(var(--accent));">
        {#if data.bannerArt}
            <img src="/images/backpacker.jpg" class="object-cover h-full w-full" alt="Banner Art" />
        {/if}
    </div>
    <div class="my-2"></div>
    <Button id="upload-button" title="Upload">
        <span class="button-icon"><RiLandscapeLine /></span>
        <span class="button-text">Upload Banner</span>
    </Button>
</div>
