import { Component, EventEmitter, Output, } from "@angular/core";
import { ButtonComponent, LinkComponent } from "$ui/util";
import { NgIconComponent, provideIcons } from "@ng-icons/core";
import {
    remixArrowLeftSLine,
    remixCheckLine,
    remixComputerFill,
    remixComputerLine,
    remixMoonFill,
    remixMoonLine,
    remixSunFill,
    remixSunLine,
    remixSettings2Line,
} from "@ng-icons/remixicon";
import { ModeSwitch, RatingsFilter, Themes } from "$models/util";
import { AsyncPipe, NgClass } from "@angular/common";
import { capitalize } from "$util/functions";
import { Select } from "@ngxs/store";
import { AppActions, AppState } from "$state/app";
import { Observable } from "rxjs";
import { Dispatch } from "@ngxs-labs/dispatch-decorator";
import { ToggleComponent } from "$ui/forms";
import { takeUntilDestroyed } from "@angular/core/rxjs-interop";
import { FormControl, FormGroup, ReactiveFormsModule } from "@angular/forms";
import { CapitalizePipe } from "$util/pipes";

@Component({
    selector: "app-quick-settings",
    standalone: true,
    imports: [
        ButtonComponent,
        NgIconComponent,
        NgClass,
        AsyncPipe,
        ToggleComponent,
        ReactiveFormsModule,
        LinkComponent,
        CapitalizePipe
    ],
    viewProviders: [
        provideIcons({
            remixArrowLeftSLine,
            remixCheckLine,
            remixSunFill,
            remixSunLine,
            remixMoonFill,
            remixMoonLine,
            remixComputerLine,
            remixComputerFill,
            remixSettings2Line,
        }),
    ],
    templateUrl: "./quick-settings.component.html",
    styleUrl: "./quick-settings.component.css",
})
export class QuickSettingsComponent {
    protected readonly ModeSwitch = ModeSwitch;
    @Select(AppState.theme) theme$!: Observable<Themes>;
    @Select(AppState.mode) mode$!: Observable<ModeSwitch>;
    @Select(AppState.showNsfw) showNsfw$!: Observable<boolean>;
    @Select(AppState.filter) filter$!: Observable<RatingsFilter>;
    @Output() onBack = new EventEmitter();
    themes = Object.keys(Themes);
    ratingsChangeForm = new FormGroup({
        showMature: new FormControl(false),
        showExplicit: new FormControl(false),
    });

    constructor() {
        this.filter$.pipe(takeUntilDestroyed()).subscribe((filter) => {
            this.ratingsChangeForm.setValue({
                showMature: filter === RatingsFilter.mature || filter === RatingsFilter.everything,
                showExplicit: filter === RatingsFilter.explicit || filter === RatingsFilter.everything,
            });
        });

        this.ratingsChangeForm.valueChanges.pipe(takeUntilDestroyed()).subscribe((value) => {
            if (value.showMature && value.showExplicit) {
                this.setRatingsFilter(RatingsFilter.everything);
            } else if (value.showMature && !value.showExplicit) {
                this.setRatingsFilter(RatingsFilter.mature);
            } else if (!value.showMature && value.showExplicit) {
                this.setRatingsFilter(RatingsFilter.explicit);
            } else {
                this.setRatingsFilter(RatingsFilter.restricted);
            }
        });
    }

    @Dispatch() setTheme = (theme: string) =>
        new AppActions.SetTheme((Themes as any)[theme]);
    @Dispatch() setMode = (mode: ModeSwitch) => new AppActions.SetMode(mode);
    @Dispatch() setShowNsfw = () => new AppActions.SetShowNSFW();
    @Dispatch() setRatingsFilter = (filter: RatingsFilter) =>
        new AppActions.SetRatingsFilter(filter);

    showEventLog(event: any) {
        console.log(event);
    }
}
