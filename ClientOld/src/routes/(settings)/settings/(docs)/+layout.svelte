<script lang="ts">
    import { LinkBlock } from "$lib/ui/util";
	import { IconChevronLeft } from "@tabler/icons-svelte";
</script>

<div class="flex flex-col gap-4 p-6">
    <div class="flex items-center sticky top-6">
        <LinkBlock
            id="go-back"
            title="Go Back"
            href="/settings"
        >
            <span class="button-icon"><IconChevronLeft size="20px" /></span>
            <span class="button-text">Back</span>
        </LinkBlock>
    </div>
    
    <article class="prose prose-base dark:text-white dark:prose-strong:text-white dark:prose-a:text-blue-600 mx-auto my-12 w-11/12">
        <slot />
    </article>
</div>
