import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
    name: 'pluralize',
    standalone: true
})
export class PluralizePipe implements PipeTransform {
    transform(value: number, suffix?: string): string {
        if (value === 0 || value > 1) {
            return suffix ? suffix : 's';
        }
        return '';
    }
}
