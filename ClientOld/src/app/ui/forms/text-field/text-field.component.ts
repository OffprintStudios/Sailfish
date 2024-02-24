import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ControlValueAccessor, FormsModule, NG_VALUE_ACCESSOR } from "@angular/forms";

@Component({
    selector: 'app-text-field',
    standalone: true,
    imports: [CommonModule, FormsModule],
    templateUrl: './text-field.component.html',
    styleUrl: './text-field.component.css',
    providers: [
        {
            provide: NG_VALUE_ACCESSOR,
            useExisting: TextFieldComponent,
            multi: true,
        },
    ],
})
export class TextFieldComponent implements ControlValueAccessor {
    @Input({ required: true }) id!: string;
    @Input({ required: true }) label!: string;
    @Input() type: 'text' | 'email' | 'password' = 'text';
    @Input() placeholder = 'Enter text here';
    @Input() errorMessage: string | null = null;
    @Input() autocomplete = 'off';
    @Input() required = false;

    value!: string;

    onChange: any = () => {};
    onTouched: any = () => {};

    registerOnChange(fn: any): void {
        this.onChange = fn;
    }

    registerOnTouched(fn: any): void {
        this.onTouched = fn;
    }

    writeValue(value: any): void {
        this.value = value;
    }
}
