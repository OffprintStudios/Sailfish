<script lang="ts">
	import { onMount } from 'svelte';
	import type { Readable } from 'svelte/store';
	import type { Editor } from '@tiptap/core';
	import { BubbleMenu as BubbleMenuComponent, createEditor, EditorContent } from 'svelte-tiptap';
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
	import {
		GalleryLine,
		EmotionLine,
		SendPlaneFill,
		FontSize,
		CodeBoxLine
	} from "svelte-remixicon";

	export let value: string;

	const iconSize = "20px";
	let bubbleMenu: HTMLElement;
	let editor: Readable<Editor>;

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
</script>

<div
	id="offprint-comment-editor"
	class="w-full flex flex-col lg:rounded-b-xl bg-zinc-200 dark:bg-zinc-700"
>
	<EditorContent editor={$editor} on:change />
	{#if editor}
		<div class="flex items-center p-2">
			<button
				class="hover:bg-zinc-300 dark:hover:bg-zinc-600"
				type="button"
				title="Formatting"
			>
				<FontSize size={iconSize} />
			</button>
			<button
				class="hover:bg-zinc-300 dark:hover:bg-zinc-600"
				type="button"
				title="Add Emoji"
			>
				<EmotionLine size={iconSize} />
			</button>
			<button
				class="hover:bg-zinc-300 dark:hover:bg-zinc-600"
				type="button"
				title="Add Media"
			>
				<GalleryLine size={iconSize} />
			</button>
			<div class="flex-1"><!--spacer--></div>
			<button
				class="active-primary"
				type="button"
				title="Send Message"
			>
				<SendPlaneFill size={iconSize} />
			</button>
		</div>
	{/if}
</div>

<style lang="scss">
  	button {
    	@apply p-2 rounded-lg transition transform flex items-center;
		&.active-primary {
	  		background: var(--accent);
	 		 color: white;
	  		&:hover {
				background: var(--accent-light);
	  		}
		}
  	}
</style>