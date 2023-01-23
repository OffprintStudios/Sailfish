<script lang="ts">
	import { createForm } from "felte";
	import { TextField } from "$lib/ui/forms";
	import { Button } from "$lib/ui/util";
	import { Save3Line } from "svelte-remixicon";
	import { goto } from "$app/navigation";
	import { patchReq, type ResponseError } from "$lib/http";
	import { page } from "$app/stores";
	import toast from "svelte-french-toast";

	const { form, isSubmitting, errors } = createForm<{ password: string; repeatPassword: string }>(
		{
			onSubmit: async (values) => {
				const formInfo = {
					accountId: $page.url.searchParams.get("userId") ?? "nil",
					resetCode: $page.url.searchParams.get("token") ?? "nil",
					newPassword: values.repeatPassword
				};
				const response = await patchReq<void>(`/auth/reset-password`, formInfo);
				if ((response as ResponseError).statusCode) {
					const error = response as ResponseError;
					toast.error(error.message);
				} else {
					toast.success(`Changes saved!`);
					await goto("/");
				}
			},
			validate: (values) => {
				const errors = {
					password: "",
					repeatPassword: ""
				};
				if (values.password.length < 8) {
					errors.password = `Passwords must be at least 8 characters long.`;
				}
				if (values.password !== values.repeatPassword) {
					errors.repeatPassword = `Passwords must match.`;
				}
				return errors;
			},
			initialValues: {
				password: "",
				repeatPassword: ""
			}
		}
	);
</script>

<div
	class="w-11/12 max-w-xl my-6 lg:my-0 lg:h-screen mx-auto flex flex-col items-center justify-center"
>
	<div class="rounded-xl w-full p-4 bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
		<h1 class="text-xl lg:text-3xl">Reset your password</h1>
		<p>
			Enter your new password below. Once that's done, hit Submit, and you'll be redirected to
			the Explore page so you can log in via the Guide.
		</p>
		<form use:form>
			<TextField
				title="New Password"
				name="password"
				type="password"
				placeholder="••••••••••"
				errorMessage={$errors.password}
				kind="primary"
			/>
			<TextField
				title="Repeat Password"
				name="repeatPassword"
				type="password"
				placeholder="••••••••••"
				errorMessage={$errors.repeatPassword}
				kind="primary"
			/>
			<div class="flex justify-center">
				<Button
					type="submit"
					kind="primary"
					loading={$isSubmitting}
					loadingText="Saving..."
				>
					<Save3Line class="button-icon" />
					<span class="button-text">Save Changes</span>
				</Button>
			</div>
		</form>
	</div>
</div>
