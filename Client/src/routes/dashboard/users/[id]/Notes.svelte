<script lang="ts">
	import type { AccountWithReports } from "$lib/models/accounts";
	import type { Note, NoteForm } from "$lib/models/admin/users";
	import type { ResponseError } from "$lib/http";
	import { getReq, postReq } from "$lib/http";
	import { Loader5Line, SendPlaneFill } from "svelte-remixicon";
	import { createForm } from "felte";
	import { account as accountState } from "$lib/state/account.state";
	import { onMount } from "svelte";
	import toast from "svelte-french-toast";

	export let account: AccountWithReports;
	let notes: Note[] = [];
	let loading = false;

	onMount(async () => {
		await fetchNotes();
	});

	const { form } = createForm<NoteForm>({
		onSubmit: async (values) => {
			const response = await postReq<Note>(
				`/admin/add-note?profileId=${$accountState.currProfile?.id}`,
				values
			);
			if ((response as ResponseError).error) {
				const error = response as ResponseError;
				toast.error(error.message);
			} else {
				notes = [...notes, response as Note];
			}
		},
		validate: (values) => {
			const errors = {
				message: ""
			};

			if (values.message && values.message.length < 3) {
				errors.message = "Notes but at least 3 characters long.";
			}

			return errors;
		},
		initialValues: {
			accountId: account.id,
			message: ""
		}
	});

	async function fetchNotes(): Promise<Note[]> {
		loading = true;
		const response = await getReq<Note[]>(`/admin/fetch-notes/${account.id}`);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			notes = response as Note[];
		}
		loading = false;
	}
</script>

<div
	class="rounded-xl w-full h-full flex flex-col overflow-hidden bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed"
>
	<div class="flex items-center p-4 sticky top-0">
		<h3 class="text-2xl">Notes</h3>
		<div class="flex-1"><!--spacer--></div>
	</div>
	{#if loading}
		<div class="w-full flex-1 flex flex-col items-center justify-center">
			<span class="flex items-center">
				<Loader5Line size="18px" class="animate-spin mr-1" />
				<span class="uppercase font-bold tracking-wider">Loading</span>
			</span>
		</div>
	{:else}
		{#each notes as note}
			here's a note
		{:else}
			<div class="w-full flex-1 flex flex-col items-center justify-center">
				<span class="flex items-center">
					<span class="uppercase font-bold tracking-wider">No notes found</span>
				</span>
			</div>
		{/each}
	{/if}
	<form class="w-full bg-zinc-300 dark:bg-zinc-600 flex sticky bottom-0" use:form>
		<input
			type="text"
			name="message"
			class="w-full bg-zinc-300 dark:bg-zinc-600 border-0 rounded-bl-xl focus:ring-0 py-3"
			placeholder="Add a note"
		/>
		<button title="Add Note" class="add-note-button">
			<SendPlaneFill class="button-icon no-text" size="22px" />
		</button>
	</form>
</div>

<style lang="scss">
	button.add-note-button {
		@apply px-4 text-white;
		background: var(--accent);
		&:hover {
			background: var(--accent-light);
		}
	}
</style>
