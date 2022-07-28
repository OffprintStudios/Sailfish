<script lang="ts">
	import { LoginCircleLine } from 'svelte-remixicon';
	import { TextField, Checkbox } from '$lib/ui/forms';
	import { Button } from '$lib/ui/util';
</script>

<form>
	<h3 class="text-2xl">Log in</h3>
	<TextField
		name="email"
		type="email"
		title="Email Address"
		placeholder="somebody@example.net"
	/>
	<TextField
		name="password"
		type="password"
		title="Password"
		placeholder="••••••••••"
	/>
	<a href="/registration/request-password-reset" class="text-sm my-4">Forgot your password?</a>
	<div class="flex items-center">
		<Checkbox>Remember Me</Checkbox>
		<div class="flex-1"></div>
		<Button kind="primary" type="submit">
			<LoginCircleLine class="button-icon" />
			<span class="button-text">Log In</span>
		</Button>
	</div>
</form>