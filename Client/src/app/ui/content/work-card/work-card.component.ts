import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NgIconComponent, provideIcons } from "@ng-icons/core";
import { remixThumbUpLine, remixThumbDownLine } from "@ng-icons/remixicon";

@Component({
    selector: 'app-work-card',
    standalone: true,
    imports: [CommonModule, NgIconComponent],
    templateUrl: './work-card.component.html',
    viewProviders: [provideIcons({ remixThumbUpLine, remixThumbDownLine })],
    styleUrl: './work-card.component.css'
})
export class WorkCardComponent {
    @Input() width: string | 'auto' = '360px';
}
