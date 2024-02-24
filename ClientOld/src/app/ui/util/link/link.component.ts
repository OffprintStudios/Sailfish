import { Component, Input, ViewEncapsulation } from '@angular/core';
import { NgClass } from "@angular/common";
import { RouterLink, RouterLinkActive } from "@angular/router";

@Component({
    selector: 'app-link',
    standalone: true,
    imports: [NgClass, RouterLink, RouterLinkActive],
    templateUrl: './link.component.html',
    styleUrl: './link.component.css',
    encapsulation: ViewEncapsulation.None,
})
export class LinkComponent {
    @Input({required: true}) id!: string;
    @Input({required: true}) title!: string;
    @Input({required: true}) link!: string | any[];
    @Input() kind: 'primary' | 'normal' = 'normal';
    @Input() fullWidth = false;
}
