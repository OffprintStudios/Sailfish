<script lang="ts">
	import { UserAddLine } from 'svelte-remixicon';
	import { TextField, Checkbox } from '$lib/ui/forms';
	import { Button } from '$lib/ui/util';
</script>

<form>
	<h3 class="text-2xl">Sign up</h3>
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
	<TextField
		name="repeatPassword"
		type="password"
		title="Repeat Password"
		placeholder="••••••••••"
	/>
	<div class="my-4">
		<Checkbox>I am 13 years of age or older</Checkbox>
		<Checkbox>I have read and agree to the Terms of Service, Privacy Policy, and Offprint Constitution</Checkbox>
	</div>
	<div class="flex items-center justify-end">
		<Button kind="primary" type="submit">
			<UserAddLine class="button-icon" />
			<span class="button-text">Sign Up</span>
		</Button>
	</div>
</form>