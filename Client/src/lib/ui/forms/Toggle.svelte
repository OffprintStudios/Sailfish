<script lang="ts">
    export let id: string;
    export let value: boolean;
    export let required: boolean = false;
</script>

<div class="my-1.5">
    <label class="switch">
        <input
            {id}
            {required}
            bind:value
            type="checkbox"
        />
        <span class="slider"><!--slider--></span>
    </label>
    <span class="relative top-[0.075rem]"><ng-content /></span>
</div>

<style lang="scss">
    .switch {
        position: relative;
        display: inline-block;
        width: 50px;
        height: 22px;

        input {
            opacity: 0;
            width: 0;
            height: 0;

            &:checked + .slider {
                background-color: rgb(var(--accent));
            }

            &:focus + .slider {
                box-shadow: 0 0 1px rgb(var(--accent));
            }

            &:checked + .slider:before {
                -webkit-transform: translateX(28px);
                -ms-transform: translateX(28px);
                transform: translateX(28px);
            }
        }

        .slider {
            @apply bg-zinc-400/50;
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            -webkit-transition: .4s;
            transition: .4s;
            border-radius: 34px;

            &:before {
                position: absolute;
                content: "";
                height: 14px;
                width: 14px;
                left: 4px;
                bottom: 4px;
                background-color: white;
                -webkit-transition: .4s;
                transition: .4s;
                border-radius: 50%;
            }
        }
    }
</style>
