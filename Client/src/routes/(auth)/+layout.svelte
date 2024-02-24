<script lang="ts">
	import LinkBlock from "$lib/ui/util/LinkBlock.svelte";
    import { RiCloseLine } from "svelte-remixicon";
</script>

<div
    class="flex flex-col items-center justify-center w-full h-screen bg-cover bg-center relative"
    style="background-image: url('/images/mountains.jpg')"
>
    <div class="absolute top-4 left-4 hidden md:block">
        <LinkBlock
            id="back-button"
            title="Go Back"
            href="/"
        >
            <span class="link-icon no-text text-zinc-300"><RiCloseLine size="32px" /></span>
        </LinkBlock>
    </div>

    <slot />
</div>
