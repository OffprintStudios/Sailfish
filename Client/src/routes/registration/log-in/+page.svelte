<script lang="ts">
	import { createForm } from "felte";
	import { page } from "$app/stores";
	import { TextField, Checkbox } from "$lib/ui/forms";
	import { Button } from "$lib/ui/util";
	import { LoginCircleLine } from "svelte-remixicon";
	import { account } from "$lib/state/account.state";
	import type { LoginForm } from "$lib/models/accounts";
	import toast from "svelte-french-toast";

	const { form, data, errors, isSubmitting } = createForm({
		onSubmit: async (values) => {
			const formInfo: LoginForm = {
				email: values.email,
				password: values.password,
				rememberMe: values.rememberMe
			};
			const response = await fetch("/api/auth/log-in", {
				method: "POST",
				body: JSON.stringify(formInfo),
				credentials: "include"
			});
			const data = await response.json();
			if (response.status === 200) {
				$account.account = data.account;
				$account.profiles = data.profiles;
				$account.token = data.accessToken;
				history.back();
			} else {
				toast.error(data.message);
			}
		},
		validate: (values) => {
			const errors = {
				email: "",
				password: ""
			};
			if (
				values.email === "" ||
				!/^[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+/.test(values.email)
			) {
				errors.email = "Not a valid email address.";
			}
			if (values.password === "") {
				errors.password = `Aren't you forgetting something?`;
			}
			return errors;
		},
		initialValues: {
			email: "",
			password: "",
			rememberMe: true
		}
	});
</script>

<!--TODO: check to see if a user is already logged in, if true show an error message-->

<div class="w-full h-screen flex flex-col items-center justify-center">
	<div class="form-container bg-zinc-200 dark:bg-zinc-700">
		<div class="title-block">
			<h1 class="text-4xl">Welcome Back, You!</h1>
		</div>
		<div class="content-container">
			<form use:form>
				<TextField
					name="email"
					type="email"
					title="Email address"
					placeholder="somebody@example.net"
					autocomplete="email"
					kind="primary"
					errorMessage={$errors.email}
				/>
				<TextField
					name="password"
					type="password"
					title="Password"
					placeholder="••••••••••"
					autocomplete="current-password"
					kind="primary"
					errorMessage={$errors.password}
				/>
				<div class="my-4">
					<a href="/recovery/send-reset-email" class="text-sm">Forgot your password?</a>
				</div>
				<div class="flex items-center">
					<Checkbox bind:value={$data.rememberMe}>Remember Me</Checkbox>
					<div class="flex-1"><!--spacer--></div>
					<Button
						kind="primary"
						type="submit"
						loading={$isSubmitting}
						loadingText="Signing in..."
					>
						<LoginCircleLine class="button-icon" />
						<span class="button-text">Log In</span>
					</Button>
				</div>
			</form>
		</div>
	</div>
</div>

<style lang="scss">
	div.form-container {
		@apply p-4 rounded-xl max-w-2xl lg:min-w-[42rem] mx-auto;
		box-shadow: var(--dropshadow);
		div.title-block {
			@apply text-center;
		}
	}
</style>
