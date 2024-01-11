import { Component } from '@angular/core';
import { NgIcon, provideIcons } from "@ng-icons/core";
import { remixSearchEyeLine } from "@ng-icons/remixicon";
import { NgxFloatUiModule } from "ngx-float-ui";
import { DEFAULT_SLOGANS } from "$models/util";
import { FormControl, FormGroup, ReactiveFormsModule } from "@angular/forms";

@Component({
    selector: 'app-search-menu',
    standalone: true,
    imports: [
        NgIcon,
        ReactiveFormsModule,
        NgxFloatUiModule,
    ],
    viewProviders: [provideIcons({remixSearchEyeLine})],
    templateUrl: './search-menu.component.html',
    styleUrl: './search-menu.component.css'
})
export class SearchMenuComponent {
    currSlogan = DEFAULT_SLOGANS[Math.floor(Math.random() * DEFAULT_SLOGANS.length)];
    searchForm = new FormGroup({
        query: new FormControl(''),
    });
}
