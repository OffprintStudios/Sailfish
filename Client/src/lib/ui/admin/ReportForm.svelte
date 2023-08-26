<script lang="ts">
	import { popup, closePopup } from "$lib/ui/popup";
	import { ReportKind } from "$lib/models/admin/users/reports";
	import {
		ReportBlog,
		ReportComment,
		ReportUser,
		ReportWork
	} from "$lib/models/admin/users/reports/reasons";
	import { createForm } from "felte";
	import { Button } from "$lib/ui/util";
	import { TextArea } from "$lib/ui/forms";
	import { Icon } from "svelte-remix";
	import { postReq, type ResponseError } from "$lib/http";
	import type { ReportForm } from "$lib/ui/admin";
	import toast from "svelte-french-toast";

	const kind: ReportKind = $popup.data.kind;
	const accountId: string = $popup.data.accountId;
	const itemId: string = $popup.data.itemId;
	const link: string = $popup.data.link;
	const blogReasons = ReportBlog;
	const commentReasons = ReportComment;
	const userReasons = ReportUser;
	const workReasons = ReportWork;

	const { form, data, errors, isSubmitting } = createForm({
		onSubmit: async (values) => {
			const formInfo: ReportForm = {
				type: kind,
				accountId: accountId,
				reason: values.reason,
				itemId: itemId,
				desc: values.desc === "" ? null : values.desc,
				link: link
			};

			const response = await postReq<void>(`/accounts/file-report`, formInfo);
			if ((response as ResponseError).error) {
				const error = response as ResponseError;
				toast.error(error.message);
			} else {
				toast.success(`Report submitted!`);
				closePopup();
			}
		},
		validate: (values) => {
			const errors = {
				reason: "",
				desc: ""
			};

			if (values.reason === "") {
				errors.reason = "You must select a reason for this report.";
			}

			if (values.reason === "Other" && values.desc === "") {
				errors.desc = "You must include a description if you select the Other option.";
			}

			return errors;
		},
		initialValues: {
			reason: "",
			desc: ""
		}
	});
</script>

<div class="rounded-xl overflow-hidden bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
	<div class="p-4 flex items-center">
		<h3 class="text-2xl flex-1">Submit Report</h3>
		<Button on:click={closePopup}>
			<Icon name="close-line" class="button-icon no-text" size="24px" />
		</Button>
	</div>
	<form class="px-4 pb-4 w-full lg:w-[400px]" use:form>
		<select
			class="w-full rounded-xl py-3 border-0 focus:ring-0 bg-zinc-300 dark:bg-zinc-600"
			bind:value={$data.reason}
		>
			<option value="">Select a reason</option>
			{#if kind === ReportKind.Blog}
				{#each Object.keys(blogReasons) as key}
					<option value={blogReasons[key]}>{blogReasons[key]}</option>
				{/each}
			{:else if kind === ReportKind.User}
				{#each Object.keys(userReasons) as key}
					<option value={userReasons[key]}>{userReasons[key]}</option>
				{/each}
			{:else if kind === ReportKind.Work}
				{#each Object.keys(workReasons) as key}
					<option value={workReasons[key]}>{workReasons[key]}</option>
				{/each}
			{:else if kind === ReportKind.Comment}
				{#each Object.keys(commentReasons) as key}
					<option value={commentReasons[key]}>{commentReasons[key]}</option>
				{/each}
			{/if}
		</select>
		<TextArea
			title="Description (Optional)"
			name="desc"
			placeholder="Add any additional details"
			kind="primary"
			errorMessage={$errors.desc}
		/>
		<div class="flex items-center justify-center">
			<Button type="submit" kind="primary" loading={$isSubmitting} loadingText="Saving...">
				<Icon name="check-line" class="button-icon" />
				<span class="button-text">Submit</span>
			</Button>
			<div class="mx-0.5"><!--spacer--></div>
			<Button type="button" on:click={closePopup}>
				<Icon name="close-line" class="button-icon" />
				<span class="button-text">Cancel</span>
			</Button>
		</div>
	</form>
</div>
