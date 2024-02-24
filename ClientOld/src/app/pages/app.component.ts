import { afterNextRender, Component, Inject } from '@angular/core';
import { CommonModule, DOCUMENT } from '@angular/common';
import { RouterOutlet } from '@angular/router';
import { NavbarComponent } from "$ui/nav";
import { Select } from "@ngxs/store";
import { AppModel, AppState } from "$state/app";
import { Observable } from "rxjs";
import { ModeSwitch, Themes } from "$models/util";

@Component({
    selector: 'app-root',
    standalone: true,
    imports: [CommonModule, RouterOutlet, NavbarComponent],
    templateUrl: './app.component.html',
    styleUrls: ['./app.component.css']
})
export class AppComponent {
    @Select(AppState) app$!: Observable<AppModel>;

    constructor(@Inject(DOCUMENT) private document: Document) {
        afterNextRender(() => {
            this.app$.subscribe(state => {
                let modes = Object.keys(ModeSwitch);
                let themes = Object.keys(Themes);
                this.document.body.classList.remove(...themes);
                this.document.body.classList.add(state.theme);

                let themeColor = this.document.querySelector("meta[name='theme-color']");
                let accentColor = this.document.defaultView!.getComputedStyle(this.document.body).getPropertyValue(
                    "--accent"
                );
                themeColor?.setAttribute("content", `rgba(${accentColor})`);

                this.document.body.classList.remove(...modes);
                if (state.mode !== ModeSwitch.system) {
                    this.document.body.classList.add(state.mode);
                } else {
                    if (this.document.defaultView!.matchMedia('(prefers-color-scheme: dark)').matches) {
                        this.document.body.classList.add(ModeSwitch.dark);
                    } else {
                        this.document.body.classList.add(ModeSwitch.light);
                    }
                }
            });
        });
    }
}
