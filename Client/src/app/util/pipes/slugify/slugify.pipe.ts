import { Pipe, PipeTransform } from '@angular/core';
import slug from "slug";

@Pipe({
    name: 'slugify',
    standalone: true
})
export class SlugifyPipe implements PipeTransform {
    transform(value: string): string {
        return slug(value);
    }
}
