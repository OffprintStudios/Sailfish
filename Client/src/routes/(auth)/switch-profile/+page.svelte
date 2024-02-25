<script lang="ts">
    import { TextField, TextArea } from "$lib/ui/forms";
    import { Button } from "$lib/ui/util";
	import { RiAddLine, RiCloseLine, RiLoader5Line } from "svelte-remixicon";
    import { auth } from "$lib/state/auth.state";
	import { onMount } from "svelte";
    import { BASE_URL } from "$lib/http";
    import axios from "axios";
	import type { Profile } from "$lib/models/accounts";
    import { enhance } from "$app/forms";
	import type { ActionData } from "./$types";
    import toast from "svelte-french-toast";
	import { goto } from "$app/navigation";

    export let form: ActionData;
    let showCreateProfileForm = false;
    let loading = true;

    onMount(async () => {
        // TODO: this needs proper error handling
        await fetchData();
    });

    async function fetchData() {
        loading = true;

        const response = await axios.get<Profile[]>(`${BASE_URL}/accounts/profiles/all`, {
            headers: {
                'Authorization': `Bearer ${$auth.token}`
            }
        });

        $auth.profiles = response.data;
        loading = false;
    }

    function selectProfile(profile: Profile) {
        $auth.currProfile = profile;
        goto("/");
    }

    $: {
        if (form?.error) {
            toast.error(form!.error.message);
        }

        if (form?.profile) {
            $auth.profiles = [...$auth.profiles, form!.profile];
            showCreateProfileForm = false;
        }
    }
</script>

<div class="bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg md:rounded-xl max-w-xl p-4 md:p-12 w-full h-full md:h-fit overflow-y-scroll">
    {#if showCreateProfileForm}
        <div class="flex flex-col items-center justify-center">
            <h1 class="text-3xl">Create a Profile</h1>
            <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center" style="font-family: var(--header-text);">
                You can fuss with the details later
            </span>
            <form method="post" use:enhance>
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
                <div class="border-b-2 border-dotted rounded-xl border-zinc-500 dark:border-zinc-400 my-4"></div>
                <Button
                    id="add-profile"
                    title="Add Profile"
                    type="submit"
                    kind="primary"
                    fullWidth
                >
                    <span class="button-icon"><RiAddLine /></span>
                    <span class="button-text">Add Profile</span>
                </Button>
                <div class="my-2"></div>
                <Button
                    id="cancel-action"
                    title="Cancel"
                    type="button"
                    fullWidth
                    on:click={() => showCreateProfileForm = false}
                >
                    <span class="button-icon"><RiCloseLine /></span>
                    <span class="button-text">Cancel</span>
                </Button>
            </form>
        </div>
    {:else}
        <div class="flex flex-col items-center justify-center">
            <h1 class="text-3xl">Select a Profile</h1>
            <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pb-8" style="font-family: var(--header-text);">
                {$auth.profiles.length} out of 3
            </span>
            {#if loading}
                <span style="color: rgba(var(--accent), 0.75)">
                    <RiLoader5Line size="100px" class="animate-spin" />
                </span>
            {:else}
                <div class="flex items-center justify-center flex-wrap">
                    {#each $auth.profiles as profile}
                        <button
                            class="flex flex-col items-center rounded-xl p-4 mx-2 w-[120px] h-[150px] hover:bg-zinc-300 dark:hover:bg-zinc-600 transition"
                            on:click={() => selectProfile(profile)}
                        >
                            <img class="rounded-full border-2 object-cover w-[75px] h-[75px]" src={profile.avatar} alt="{profile.username}'s Avatar" />
                            <span class="pt-3 all-small-caps font-bold text-lg truncate max-w-[80px]">
                                {profile.username}
                            </span>
                        </button>
                    {/each}
                    {#if $auth.profiles.length < 3}
                        <button
                            class="flex flex-col items-center rounded-xl p-4 mx-2 w-[120px] h-[150px] hover:bg-zinc-300 dark:hover:bg-zinc-600 transition"
                            on:click={() => showCreateProfileForm = true}
                        >
                            <div class="flex flex-col items-center justify-center w-[75px] h-[75px] rounded-full border-2 border-dotted">
                                <RiAddLine size="28px" />
                            </div>
                            <span class="pt-3 all-small-caps font-bold text-lg">
                                Add New
                            </span>
                        </button>
                    {/if}
                </div>
            {/if}

        </div>
    {/if}
</div>
