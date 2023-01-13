<script lang="ts">
	import { createEventDispatcher } from "svelte";
	import { createForm } from "felte";
	import type { Work, Section, SectionForm } from "$lib/models/content/works";
	import { account } from "$lib/state/account.state";
	import { slugify } from "$lib/util/functions";
	import { TextField, Editor } from "$lib/ui/forms";
	import { Button } from "$lib/ui/util";
	import { patchReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import { CloseLine, Save2Line } from "svelte-remixicon";
	import toast from "svelte-french-toast";

	export let work: Work;
	export let section: Section;

	const dispatch = createEventDispatcher();
	let hasTop = !!section?.noteTop;
	let hasBottom = !!section?.noteBottom;

	const { form, errors, data, isSubmitting } = createForm<SectionForm>({
		async onSubmit(values) {
			const formInfo: SectionForm = {
				title: values.title,
				body: values.body,
				noteTop: hasTop ? (values.noteTop === "" ? undefined : values.noteTop) : undefined,
				noteBottom: hasBottom
					? values.noteBottom === ""
						? undefined
						: values.noteBottom
					: undefined
			};

			const response = await patchReq<Section>(
				`/sections/update-section/${section.id}?workId=${work.id}&profileId=${$account.currProfile?.id}`,
				formInfo
			);
			if ((response as ResponseError).error) {
				const error = response as ResponseError;
				toast.error(error.message);
			} else {
				section = response as Section;
				dispatch("save");
			}
		},
		validate(values) {
			const errors = {
				title: "",
				body: "",
				noteTop: "",
				noteBottom: ""
			};

			if (!values.title || values.title.length < 3 || values.title.length > 120) {
				errors.title = "Titles must be between 3 and 120 characters";
			}

			if (!values.body || values.body.length < 3) {
				errors.body = "Body text must not be empty";
			}

			if (values.noteTop && values.noteTop.length < 3) {
				errors.noteTop = `Author's notes must be bigger than 3 characters`;
			}

			if (values.noteBottom && values.noteBottom.length < 3) {
				errors.noteTop = `Author's notes must be bigger than 3 characters`;
			}

			return errors;
		},
		initialValues: {
			title: section.title,
			body: section.body,
			noteTop: section?.noteTop ?? "",
			noteBottom: section?.noteBottom ?? ""
		}
	});

	function cancel() {
		dispatch("cancel");
	}
</script>

<div class="max-w-4xl mx-auto my-6">
	{#if $account.account && $account.currProfile && $account.currProfile.id === work.author.id}
		<form class="bg-zinc-200 dark:bg-zinc-700 rounded-xl overflow-hidden" use:form>
			<div class="p-4" style="background: var(--accent);">
				<h3 class="text-white font-light ml-0.5">
					<a
						class="text-white hover:text-white"
						href="/prose/{work.id}/{slugify(work.title)}">{work.title}</a
					>
					<span class="text-white mx-[0.075rem] text-lg">•</span>
					<a
						class="text-white hover:text-white"
						href="/profile/{work.author.id}/{slugify(work.author.username)}"
						>{work.author.username}</a
					>
				</h3>
				<h1 class="text-white text-4xl">Editing "{section.title}"</h1>
			</div>
			<div class="p-4">
				<div class="flex items-center mx-4 mb-2">
					<h5 class="text-white flex-1 text-xl">Title</h5>
				</div>
				<TextField
					name="title"
					type="text"
					placeholder="Another Great Adventure"
					errorMessage={$errors.title}
					kind="primary"
				/>
				{#if hasTop}
					<div class="flex items-center mt-4 mx-4 mb-2">
						<h5 class="text-white flex-1 text-xl">Author's Note (Top)</h5>
						<Button type="button" on:click={() => (hasTop = false)}>
							<CloseLine class="button-icon" />
							<span class="button-text">Cancel</span>
						</Button>
					</div>
					<Editor kind="primary" bind:value={$data.noteTop} />
				{:else}
					<button
						class="add-note border-zinc-300 dark:border-zinc-600 hover:bg-zinc-300 dark:hover:bg-zinc-600 hover:border-zinc-400 hover:dark:border-zinc-500"
						on:click={() => (hasTop = true)}
						type="button"
					>
						<span>Add Note</span>
					</button>
				{/if}
				<div class="flex items-center mt-4 mx-4 mb-2">
					<h5 class="text-white flex-1 text-xl">Body</h5>
				</div>
				<Editor kind="primary" bind:value={$data.body} />
				{#if hasBottom}
					<div class="flex items-center mt-4 mx-4 mb-2">
						<h5 class="text-white flex-1 text-xl">Author's Note (Bottom)</h5>
						<Button type="button" on:click={() => (hasBottom = false)}>
							<CloseLine class="button-icon" />
							<span class="button-text">Cancel</span>
						</Button>
					</div>
					<Editor kind="primary" bind:value={$data.noteBottom} />
				{:else}
					<button
						class="add-note border-zinc-300 dark:border-zinc-600 hover:bg-zinc-300 dark:hover:bg-zinc-600 hover:border-zinc-400 hover:dark:border-zinc-500"
						on:click={() => (hasBottom = true)}
						type="button"
					>
						<span>Add Note</span>
					</button>
				{/if}
			</div>
			<div class="flex items-center justify-center py-2 bg-zinc-300 dark:bg-zinc-600">
				<Button type="button" loading={$isSubmitting} on:click={cancel}>
					<CloseLine class="button-icon" />
					<span class="button-text">Cancel</span>
				</Button>
				<div class="mx-0.5"><!--spacer--></div>
				<Button
					kind="primary"
					type="submit"
					loading={$isSubmitting}
					loadingText="Saving..."
				>
					<Save2Line class="button-icon" />
					<span class="button-text">Save</span>
				</Button>
			</div>
		</form>
	{:else}
		<div class="empty">
			<h3>Uh-oh, what are <strong>you</strong> doing here?</h3>
			<p>This page ain't for you. Who told you you could be here?</p>
		</div>
	{/if}
</div>

<style lang="scss">
	div.section-header {
		@apply flex items-center;
	}
	button.add-note {
		@apply flex flex-col justify-center items-center my-4 rounded-xl border-4 border-dashed w-full h-24 transition;
	}
</style>
