<script lang="ts">
	import { onMount } from 'svelte';
	import type { Readable } from 'svelte/store';
	import { createEventDispatcher  } from 'svelte';
	import { BubbleMenu as BubbleMenuComponent, createEditor, Editor, EditorContent } from 'svelte-tiptap';
	import Document from '@tiptap/extension-document';
	import Paragraph from '@tiptap/extension-paragraph';
	import Text from '@tiptap/extension-text';
	import Typography from '@tiptap/extension-typography';
	import History from '@tiptap/extension-history';
	import Dropcursor from '@tiptap/extension-dropcursor';
	import Gapcursor from '@tiptap/extension-gapcursor';
	import Bold from '@tiptap/extension-bold';
	import Italic from '@tiptap/extension-italic';
	import Underline from '@tiptap/extension-underline';
	import Strike from '@tiptap/extension-strike';
	import Code from '@tiptap/extension-code';
	import Blockquote from '@tiptap/extension-blockquote';
	import HardBreak from '@tiptap/extension-hard-break';
	import Youtube from '@tiptap/extension-youtube';
	import Image from '@tiptap/extension-image';
	import Link from '@tiptap/extension-link';
	import Placeholder from '@tiptap/extension-placeholder';
	import BubbleMenu from '@tiptap/extension-bubble-menu';
	import { Icon } from 'svelte-remix';
	import { slide } from 'svelte/transition';

	export let value: string;
	export let markedAsSpoiler = false;

	enum ToolBar {
		Closed,
		Formatting,
		AddMedia,
		AddEmoji
	}

	const iconSize = "20px";
	let bubbleMenu: HTMLElement;
	let editor: Readable<Editor>;
	let currOptions = ToolBar.Closed;
	

	onMount(() => {
		editor = createEditor({
			extensions: [
				Document,
				Paragraph,
				Text,
				Typography,
				History,
				Dropcursor,
				Gapcursor,
				Bold,
				Italic,
				Underline,
				Strike,
				Code,
				Blockquote,
				HardBreak,
				Image.configure({ inline: true }),
				Link.configure({ openOnClick: false }),
				Youtube.configure({
					width: 480,
					height: 360,
					inline: true
				}),
				Placeholder.configure({ placeholder: "Share your thoughts" }),
				BubbleMenu.configure({ element: bubbleMenu }),
			],
			content: value,
			onUpdate: (props) => {
				value = props.editor.getHTML();
			},
		});
	});

	function openOptions(toolBar: ToolBar) {
		if (toolBar === currOptions) {
			currOptions = ToolBar.Closed;
		} else {
			currOptions = toolBar;
		}
	}
</script>

<div
	id="offprint-comment-editor"
	class="w-full flex flex-col lg:rounded-b-xl bg-zinc-200 dark:bg-zinc-700"
>
	<EditorContent editor={$editor} on:change />
	{#if editor}
		{#if currOptions !== ToolBar.Closed}
			<div 
				class="p-2 bg-zinc-300 dark:bg-zinc-600"
				transition:slide={{ delay: 0, duration: 200, axis: 'y' }}
			>
				{#if currOptions === ToolBar.Formatting}
					<div class="flex items-center">
						<button
							on:click={() => $editor.chain().focus().toggleBold().run()}
							class:active={$editor.isActive("bold")}
							type="button"
							title="Bold"
						>
							<Icon name="bold" width={iconSize} height={iconSize} />
						</button>
						<button
							on:click={() => $editor.chain().focus().toggleItalic().run()}
							class:active={$editor.isActive("italic")}
							type="button"
							title="Italic"
						>
							<Icon name="italic" width={iconSize} height={iconSize} />
						</button>
						<button
							on:click={() => $editor.chain().focus().toggleUnderline().run()}
							class:active={$editor.isActive("underline")}
							type="button"
							title="Underline"
						>
							<Icon name="underline" width={iconSize} height={iconSize} />
						</button>
						<button
							on:click={() => $editor.chain().focus().toggleStrike().run()}
							class:active={$editor.isActive("strike")}
							type="button"
							title="Strikethrough"
						>
							<Icon name="strikethrough" width={iconSize} height={iconSize} />
						</button>
					</div>
				{:else if currOptions === ToolBar.AddMedia}
					<div class="flex items-center"></div>
				{:else if currOptions === ToolBar.AddEmoji}
					<div class="flex items-center"></div>
				{/if}
			</div>
		{/if}
		<div 
			class="flex items-center p-2"
			class:pt-0={currOptions !== ToolBar.Closed}
		>
			<button
				class="editor-button hover:bg-zinc-300 dark:hover:bg-zinc-600"
				type="button"
				title="Change Formatting"
				class:active={currOptions === ToolBar.Formatting}
				on:click={() => openOptions(ToolBar.Formatting)}
			>
				<Icon name="font-size" width={iconSize} height={iconSize} tabindex="-1" />
			</button>
			<button
				class="editor-button hover:bg-zinc-300 dark:hover:bg-zinc-600"
				type="button"
				title="Add Media"
				class:active={currOptions === ToolBar.AddMedia}
				on:click={() => openOptions(ToolBar.AddMedia)}
			>
				<Icon name="gallery-line" width={iconSize} height={iconSize} tabindex="-1" />
			</button>
			<button
				class="editor-button hover:bg-zinc-300 dark:hover:bg-zinc-600"
				type="button"
				title="Add Emoji"
				class:active={currOptions === ToolBar.AddEmoji}
				on:click={() => openOptions(ToolBar.AddEmoji)}
			>
				<Icon name="emotion-line" width={iconSize} height={iconSize} tabindex="-1" />
			</button>
			<button
				class="editor-button hover:bg-zinc-300 dark:hover:bg-zinc-600"
				type="button"
				title="Mark As Spoiler"
				class:active-primary={markedAsSpoiler}
				on:click={() => markedAsSpoiler = !markedAsSpoiler}
			>
				<Icon name="alert-line" width={iconSize} height={iconSize} tabindex="-1" />
			</button>
			<div class="flex-1"><!--spacer--></div>
			<button
				class="editor-button active-primary"
				type="button"
				title="Send Message"
				disabled={currOptions !== ToolBar.Closed}
			>
				<Icon name="send-plane-fill" width={iconSize} height={iconSize} tabindex="-1" />
			</button>
		</div>
	{/if}
</div>

<style lang="scss">
  	button.editor-button {
    	@apply p-2 rounded-lg transition transform flex items-center;
		&.active {
			@apply bg-zinc-300 rounded-t-none;
		}
		&.active-primary {
	  		background: var(--accent);
	 		color: white;
	  		&:hover {
				background: var(--accent-light);
	  		}
			&:disabled {
				@apply bg-zinc-200 text-zinc-400 cursor-not-allowed;
			}
		}
  	}
	:global(.dark button.editor-button) {
		&.active {
			@apply bg-zinc-600;
		}
		&.active-primary {
			&:disabled {
				@apply text-zinc-500 bg-zinc-700;
			}
		}
	}
</style>