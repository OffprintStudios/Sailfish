import { ModeSwitch, RatingsFilter, Themes } from "$models/util";

export namespace AppActions {
    export class SetTheme {
        static readonly type = '[App] Set Theme';
        constructor(public theme: Themes) {}
    }

    export class SetMode {
        static readonly type = '[App] Set Mode';
        constructor(public mode: ModeSwitch) {}
    }

    export class SetShowNSFW {
        static readonly type = '[App] Set Show NSFW';
    }

    export class SetRatingsFilter {
        static readonly type = '[App] Set Ratings Filter';
        constructor(public filter: RatingsFilter) {}
    }
}
