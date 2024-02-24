import { Pipe, PipeTransform } from '@angular/core';
import numbro from "numbro";

@Pipe({
    name: 'abbreviate',
    standalone: true
})
export class AbbreviatePipe implements PipeTransform {
    transform(value: number): string {
        if (value < 1000) {
            return `${value}`;
        }
        return numbro(value).format({average: true, totalLength: 2});
    }
}
