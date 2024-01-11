import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NgIconComponent, provideIcons } from "@ng-icons/core";
import { remixAppsLine, remixLoader2Line, remixBox2Line, remixShining2Line } from "@ng-icons/remixicon";
import { WorkCardComponent } from "$ui/content";

@Component({
    selector: 'app-explore',
    standalone: true,
    imports: [CommonModule, WorkCardComponent, NgIconComponent],
    viewProviders: [provideIcons({ remixAppsLine, remixLoader2Line, remixBox2Line, remixShining2Line })],
    templateUrl: './explore.component.html',
    styleUrl: './explore.component.css'
})
export class ExploreComponent {

}
