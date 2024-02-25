<script lang="ts">
	import '../app.scss';

    import { Toaster } from "svelte-french-toast";
</script>

<main>
    <Toaster />
    <slot />
</main>
