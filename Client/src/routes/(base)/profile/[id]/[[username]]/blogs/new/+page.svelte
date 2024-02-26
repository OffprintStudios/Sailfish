<script lang="ts">
    import { TextField, GeneralEditor } from "$lib/ui/forms";
</script>

<form class="flex flex-col max-w-3xl mx-auto my-6">
    <TextField
        name="title"
        label="Title"
        hint="240 characters max"
        placeholder="Just Another Rundown"
        value={null}
    />
    <div class="my-2"><!--spacer--></div>
    <GeneralEditor
        label="Content"
        hint="3 characters minimum"
        value=""
    />
</form>
