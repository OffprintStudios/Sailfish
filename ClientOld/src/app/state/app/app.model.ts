import { ModeSwitch, RatingsFilter, Themes } from "$models/util";

export interface AppModel {
    theme: Themes;
    mode: ModeSwitch;
    showNsfw: boolean;
    filter: RatingsFilter;
}
