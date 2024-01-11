import { Component, forwardRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { WorkCardComponent } from "$ui/content";
import { NgIconComponent, provideIcons } from "@ng-icons/core";
import { remixArrowRightSLine } from "@ng-icons/remixicon";

@Component({
    selector: 'app-card-carousel',
    standalone: true,
    imports: [CommonModule, forwardRef(() => WorkCardComponent), NgIconComponent],
    viewProviders: [provideIcons({ remixArrowRightSLine })],
    templateUrl: './card-carousel.component.html',
    styleUrl: './card-carousel.component.css'
})
export class CardCarouselComponent {

}
