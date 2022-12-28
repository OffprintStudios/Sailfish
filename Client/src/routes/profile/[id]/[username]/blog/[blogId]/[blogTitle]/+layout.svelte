<script lang="ts">
	import type { Blog } from "$lib/models/content";
	import type { Paginate } from "$lib/util/types";
	import type { Comment } from "$lib/models/comments";

	export let data: { blog: Blog; comments: Paginate<Comment> };
</script>

<slot />
