import { Component, Input } from '@angular/core';
import { ControlValueAccessor, FormsModule, NG_VALUE_ACCESSOR } from "@angular/forms";

@Component({
    selector: 'app-text-area',
    standalone: true,
    imports: [FormsModule],
    templateUrl: './text-area.component.html',
    styleUrl: './text-area.component.css',
    providers: [
        {
            provide: NG_VALUE_ACCESSOR,
            useExisting: TextAreaComponent,
            multi: true,
        }
    ]
})
export class TextAreaComponent implements ControlValueAccessor {
    @Input({ required: true }) id!: string;
    @Input({ required: true }) label!: string;
    @Input() placeholder = 'Enter text here';
    @Input() errorMessage: string | null = null;
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
