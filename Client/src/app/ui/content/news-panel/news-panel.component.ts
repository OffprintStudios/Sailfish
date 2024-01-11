import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NgIconComponent, provideIcons } from "@ng-icons/core";
import { remixNewspaperLine, remixArrowRightSLine } from "@ng-icons/remixicon";

@Component({
    selector: 'app-news-panel',
    standalone: true,
    imports: [CommonModule, NgIconComponent],
    viewProviders: [provideIcons({ remixNewspaperLine, remixArrowRightSLine })],
    templateUrl: './news-panel.component.html',
    styleUrl: './news-panel.component.css'
})
export class NewsPanelComponent {

}
