import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { JumbotronComponent, CardCarouselComponent, NewsPanelComponent, GenreGridComponent } from "$ui/content";
import { NgIconComponent, provideIcons } from "@ng-icons/core";
import { remixLoader2Line, remixArrowRightSLine, remixSignalTowerLine } from "@ng-icons/remixicon";
import { Meta, Title } from "@angular/platform-browser";
import { generateTags } from "$util/meta";

@Component({
    selector: 'app-home',
    standalone: true,
    imports: [
        CommonModule,
        JumbotronComponent,
        CardCarouselComponent,
        NgIconComponent,
        NewsPanelComponent,
        GenreGridComponent
    ],
    viewProviders: [provideIcons({
        remixLoader2Line,
        remixArrowRightSLine,
        remixSignalTowerLine
    })],
    templateUrl: './home.component.html',
    styleUrl: './home.component.css'
})
export class HomeComponent implements OnInit {
    constructor(private title: Title, private meta: Meta) {}

    ngOnInit() {
        this.title.setTitle("Home — Offprint");
        this.meta.addTags(generateTags(
                "Offprint",
                "For The Stories Left To Tell",
                "website",
                "https://offprint.cafe/",
                "/images/offprint_icon.png"
            )
        );
    }
}
