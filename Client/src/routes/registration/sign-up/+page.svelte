<script lang="ts">
	import { createForm } from "felte";
	import { UserAddLine } from "svelte-remixicon";
	import { Checkbox, TextField } from "$lib/ui/forms";
	import { Button } from "$lib/ui/util";
	import type { RegisterForm } from "$lib/models/accounts/forms";
	import toast from "svelte-french-toast";
	import { account } from "$lib/state/account.state";
	import { goto } from "$app/navigation";

	const termsUrl =
		"https://docs.google.com/document/d/1qYEhhRVknvT9qw6cwZQ5JP72rKQgPpdM449hxP2PG3w/edit?usp=share_link";
	const privacyUrl =
		"https://docs.google.com/document/d/1CaO3WEW4HWaKF2p_KPZmtCONDWB04dvgBD3k-kCDklI/edit?usp=share_link";
	const constitutionUrl =
		"https://docs.google.com/document/d/1i_YMayX0p61_nJGkUsT_BsHwHo-5NyV_QovcGKZr2e0/edit?usp=share_link";

	const { form, data, errors, isSubmitting } = createForm({
		onSubmit: async (values) => {
			const formInfo: RegisterForm = {
				email: values.email,
				password: values.password,
				termsAgree: values.termsAgree
			};

			const response = await fetch("/api/auth/sign-up", {
				method: "POST",
				body: JSON.stringify(formInfo),
				credentials: "include"
			});
			const data = await response.json();
			if (response.status === 200) {
				$account.account = data.account;
				$account.profiles = data.profiles;
				$account.token = data.accessToken;
				await goto("/");
			} else {
				toast.error(data.message);
			}
		},
		validate: (values) => {
			const errors = {
				email: "",
				password: "",
				repeatPassword: "",
				ageCheck: "",
				termsAgree: ""
			};
			if (!values.email || !/^[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+/.test(values.email)) {
				errors.email = `That's not a valid email address.`;
			}
			if (!values.password) {
				errors.password = `Aren't you forgetting something?`;
			}
			if (values.password && values.password.length < 8) {
				errors.password = `Passwords must be at least 8 characters long.`;
			}
			if (!values.repeatPassword || values.password !== values.repeatPassword) {
				errors.repeatPassword = `Passwords must match.`;
			}
			if (values.ageCheck === false) {
				errors.ageCheck = `You must be at least 13 years or older to join.`;
			}
			if (values.termsAgree === false) {
				errors.termsAgree = `You must agree in order to join.`;
			}
			return errors;
		}
	});
</script>

<!--TODO: check to see if a user is already logged in, if true show an error message-->

<div class="w-full h-screen flex flex-col items-center justify-center">
	<div class="form-container bg-zinc-200 dark:bg-zinc-700">
		<div class="title-block">
			<h1 class="text-4xl">You new 'round these parts?</h1>
		</div>
		<div class="content-container">
			<form use:form>
				<TextField
					name="email"
					type="email"
					title="Email address"
					placeholder="somebody@example.net"
					kind="primary"
					errorMessage={$errors.email}
				/>
				<TextField
					name="password"
					type="password"
					title="Password"
					placeholder="••••••••••"
					kind="primary"
					errorMessage={$errors.password}
				/>
				<TextField
					name="repeatPassword"
					type="password"
					title="Repeat Password"
					placeholder="••••••••••"
					kind="primary"
					errorMessage={$errors.repeatPassword}
				/>
				<div class="my-0.5" />
				<Checkbox bind:value={$data.ageCheck}
					>I am at least 13 years of age or older.</Checkbox
				>
				<Checkbox bind:value={$data.termsAgree}>
					I agree to the <a href={termsUrl} target="_blank" rel="noreferrer"
						>Terms of Service</a
					>, <a href={privacyUrl} target="_blank" rel="noreferrer">Privacy Policy</a>, and
					<a href={constitutionUrl} target="_blank" rel="noreferrer"
						>Offprint Constitution</a
					>.
				</Checkbox>
				<div class="flex items-center mt-6">
					<div class="flex-1" />
					<Button
						kind="primary"
						type="submit"
						loading={$isSubmitting}
						loadingText="Signing up..."
					>
						<UserAddLine class="button-icon" />
						<span class="button-text">Sign up</span>
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
