<script lang="ts">
    import type { LayoutParentData } from "./$types";
    import { slugify } from "$lib/util/functions";
    import { IconPlus, IconFilter } from "@tabler/icons-svelte";
    import { LinkBlock, Button } from "$lib/ui/util";

    export let data: LayoutParentData;
</script>

<div class="hidden md:flex items-center w-full p-2 bg-zinc-200/50 dark:bg-zinc-700/50 backdrop-blur-lg rounded-b-xl border border-zinc-600/25 dark:border-zinc-300/25 transition">
    <LinkBlock
        id="create-link"
        title="Create a New Work"
        href="/profile/{data.profile.id}/{slugify(data.profile.username)}/works/new"
    >
        <span class="link-icon"><IconPlus size="18px" /></span>
        <span class="link-text">Create</span>
    </LinkBlock>
    <Button
        id="filter-button"
        title="Filter"
    >
        <span class="button-ico no-text"><IconFilter size="18px" /></span>
    </Button>
</div>