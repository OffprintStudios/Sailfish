<script lang="ts">
    import { TextField, GeneralEditor } from "$lib/ui/forms";
</script>

<div class="w-full my-6 py-6 bg-zinc-200/50 dark:bg-zinc-700/50 backdrop-blur-lg rounded-xl border border-zinc-600/25 dark:border-zinc-300/25" style="box-shadow: var(--dropshadow);">
    <form class="flex flex-col max-w-3xl mx-auto">
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
            value=""
        />
    </form>
</div>
