<script lang="ts">
	import { createForm } from "felte";
	import { TextField } from "$lib/ui/forms";
	import { Button } from "$lib/ui/util";
	import { SendPlaneLine } from "svelte-remixicon";
	import { goto } from "$app/navigation";
	import { getReq, type ResponseError } from "$lib/http";
	import toast from "svelte-french-toast";

	const { form, isSubmitting, errors } = createForm<{ email: string }>({
		onSubmit: async (values) => {
			const response = await getReq<void>(`/auth/send-recovery-email?email=${values.email}`);
			if ((response as ResponseError).statusCode) {
				const error = response as ResponseError;
				toast.error(error.message);
			} else {
				toast.success(
					`If we find your account, you'll receive an email within 10 minutes.`
				);
				await goto("/");
			}
		},
		validate: (values) => {
			const errors = {
				email: ""
			};
			if (!/^[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+/.test(values.email)) {
				errors.email = "Not a valid email address";
			}
			return errors;
		},
		initialValues: {
			email: ""
		}
	});
</script>

<div
	class="w-11/12 max-w-xl my-6 lg:my-0 lg:h-screen mx-auto flex flex-col items-center justify-center"
>
	<div class="rounded-xl w-full p-4 bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
		<h1 class="text-xl lg:text-3xl">Forgot your password?</h1>
		<p>
			We can help with that. Just enter the email address for your account below. If we find
			an account belonging to it, we'll send you an email with a reset link.
		</p>
		<form use:form>
			<TextField
				title="Email address"
				name="email"
				placeholder="somebody@example.net"
				errorMessage={$errors.email}
				kind="primary"
			/>
			<div class="flex justify-center">
				<Button
					type="submit"
					kind="primary"
					loading={$isSubmitting}
					loadingText="Sending..."
				>
					<SendPlaneLine class="button-icon" />
					<span class="button-text">Send</span>
				</Button>
			</div>
		</form>
	</div>
</div>
