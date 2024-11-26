<script lang="ts">
    import { Button } from "$lib/ui/util";
    import { IconChevronLeft, IconCheck, IconX } from "@tabler/icons-svelte";
	import { createEventDispatcher } from "svelte";

    const dispatch = createEventDispatcher();
</script>

<div class="flex items-center">
    <Button
        id="back-button"
        title="Go Back"
        on:click={() => dispatch('cancel')}
    >
        <span class="button-icon"><IconChevronLeft /></span>
        <span class="button-text">Back</span>
    </Button>
</div>
<div class="mx-4 mb-4 mt-8 flex flex-col">
    <h2 class="mb-8 text-center text-3xl">Log Out</h2>
    <p
        class="mb-8 text-center"
        style="font-family: var(--body-text); color: var(--text-color)"
    >
        Are you sure you want to log out?
    </p>
    <Button
        id="yes-button"
        title="Yes"
        kind="primary"
        fullWidth
    >
        <span class="button-icon"><IconCheck /></span>
        <span class="button-text">Yes</span>
    </Button>
    <div class="my-1" />
    <Button
        id="no-button"
        title="No"
        fullWidth
        on:click={() => dispatch('cancel')}
    >
        <span class="button-icon"><IconX /></span>
        <span class="button-text">No</span>
    </Button>
</div>