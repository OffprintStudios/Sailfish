<script lang="ts">
	import { LogInForm, SignUpForm } from './_forms';
</script>

<h1 class="text-5xl text-center mt-12">Welcome to Offprint!</h1>
<div class="forms-container">
	<div class="form-box">
		<LogInForm />
	</div>
	<div class="form-box">
		<SignUpForm />
	</div>
</div>

<style lang="scss">
	div.forms-container {
		@apply flex flex-col lg:flex-row rounded-xl my-12 mx-auto;
	}
	div.form-box {
		@apply w-11/12 lg:w-1/2 mb-6 mx-auto lg:mb-0 lg:mx-6;
	}
</style>