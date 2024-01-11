import { Component, Input } from '@angular/core';
import { ControlValueAccessor, FormsModule, NG_VALUE_ACCESSOR } from "@angular/forms";

@Component({
    selector: 'app-toggle',
    standalone: true,
    imports: [FormsModule],
    templateUrl: './toggle.component.html',
    styleUrl: './toggle.component.css',
    providers: [
        {
            provide: NG_VALUE_ACCESSOR,
            useExisting: ToggleComponent,
            multi: true,
        },
    ],
})
export class ToggleComponent implements ControlValueAccessor {
    @Input({ required: true }) id!: string;
    @Input() required = false;

    value!: boolean;

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
