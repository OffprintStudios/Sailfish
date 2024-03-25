<script lang="ts">
    import type { PageData } from "./$types";
    import { auth } from "$lib/state/auth.state";
    import axios from "axios";
	import { BASE_URL } from "$lib/http";
	import type { Paginated } from "$lib/models/util";
	import type { Blog } from "$lib/models/blogs";
	import { onMount } from "svelte";
	import { BlogCard } from "$lib/ui/content";

    export let data: PageData;
    let loading = false;
    let err: string | null = null;
    let blogs: Paginated<Blog> = {
        items: [],
        metadata: {
            page: 1,
            per: 15,
            total: 0,
        }
    };

    onMount(async () => {
        await fetchData();
    });

    async function fetchData() {
        loading = true;

        if ($auth.currProfile && $auth.currProfile.id === data.id) {
            const response = await axios.get<Paginated<Blog>>(`${BASE_URL}/blogs/all?profileId=${$auth.currProfile.id}`, {
                headers: {
                    'Authorization': `Bearer ${$auth.token}`,
                }
            });
            if (response.status === 200) {
                blogs = response.data;
            } else {
                err = "Something went wrong! Try again in a little bit.";
            }
        } else {
            const response = await axios.get<Paginated<Blog>>(`${BASE_URL}/profiles/${data.id}/blogs`);
            if (response.status === 200) {
                blogs = response.data;
            } else {
                err = "Something went wrong! Try again in a little bit.";
            }
        }

        loading = false;
    }
</script>

{#if loading}
    <div class="empty">
        <h3>Loading...</h3>
    </div>
{:else}
    {#if blogs.items.length === 0}
        <div class="empty">
            <h3>Nothing to see here</h3>
            <p>Check back later to see if they added anything!</p>
        </div>
    {:else}
        <div class="grid grid-cols-1 md:grid-cols-2 gap-2 my-6">
            {#each blogs.items as blog}
                <BlogCard {blog} width="auto" />
            {/each}
        </div>
    {/if}
{/if}


