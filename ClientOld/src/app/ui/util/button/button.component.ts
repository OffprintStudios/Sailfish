import { Component, EventEmitter, Input, Output, ViewEncapsulation } from '@angular/core';
import { NgClass } from '@angular/common';

@Component({
    selector: 'app-button',
    standalone: true,
    imports: [NgClass],
    templateUrl: './button.component.html',
    styleUrl: './button.component.css',
    encapsulation: ViewEncapsulation.None,
})
export class ButtonComponent {
    @Input({required: true}) id!: string;
    @Input({required: true}) title!: string;
    @Input() type: 'button' | 'submit' | 'reset' = 'button';
    @Input() kind: 'primary' | 'normal' = 'normal';
    @Input() active = false;
    @Input() loading = false;
    @Input() disabled = false;
    @Input() fullWidth = false;

    @Output() click = new EventEmitter();
}
