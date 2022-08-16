<script lang="ts">
	import { createForm } from "felte";
	import { Checkbox, TextField } from "$lib/ui/forms";
	import { Button } from "$lib/ui/util";
	import { LoginCircleLine } from "svelte-remixicon";
	import { account } from "$lib/state/account.state";
	import type { LoginForm } from "$lib/models/accounts";
	import toast from "svelte-french-toast";
	import { prevPage } from "../guide.state";

	const { form, data, errors, isSubmitting } = createForm({
		onSubmit: async (values) => {
			const formInfo: LoginForm = {
				email: values.email,
				password: values.password,
				rememberMe: values.rememberMe,
			};

			await fetch('/api/auth/log-in', { method: 'POST', body: JSON.stringify(formInfo), credentials: 'include' })
				.then(async (response) => {
					const data = await response.json();

					if (response.status === 422) {
						toast.error(data.message);
					} else if (response.status === 200) {
						$account.account = data.account;
						$account.profiles = data.profiles;
						prevPage();
					} else {
						toast.error('Something went wrong! Try again in a little bit.');
					}
				});
		},
		validate: (values) => {
			const errors = {
				email: '',
				password: '',
			};
			if (!values.email || !/^[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+/.test(values.email)) {
				errors.email = 'Not a valid email address.';
			}
			if (!values.password) {
				errors.password = `Aren't you forgetting something?`;
			}
			return errors;
		},
		initialValues: {
			email: null,
			password: null,
			rememberMe: false,
		}
	});
</script>

<div class="panel-container">
	<div class="title-block">
		<h1>Log in</h1>
	</div>
	<div class="content-container">
		<form use:form>
			<TextField
				name="email"
				type="email"
				title="Email address"
				placeholder="somebody@example.net"
				autocomplete="email"
				errorMessage={$errors.email}
			/>
			<TextField
				name="password"
				type="password"
				title="Password"
				placeholder="••••••••••"
				autocomplete="current-password"
				errorMessage={$errors.password}
			/>
			<div class="my-4">
				<a href="/registration/request-password-reset" class="text-sm">Forgot your password?</a>
			</div>
			<div class="flex items-center">
				<Checkbox bind:value={$data.rememberMe}>Remember me</Checkbox>
				<div class="flex-1"></div>
				<Button kind="primary" type="submit" loading={$isSubmitting} loadingText="Signing in...">
					<LoginCircleLine class="button-icon" />
					<span class="button-text">Log In</span>
				</Button>
			</div>
		</form>
	</div>
</div>

<style lang="scss">
	@use '../Guide';
</style>
