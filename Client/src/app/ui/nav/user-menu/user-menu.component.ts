import { Component } from "@angular/core";
import { NgxFloatUiModule } from "ngx-float-ui";
import { Profile } from "$models/accounts";
import {
  AsyncPipe,
  NgIf,
  NgClass,
  NgOptimizedImage,
  NgComponentOutlet,
} from "@angular/common";
import { Select, Store } from "@ngxs/store";
import { AuthActions, AuthState } from "$state/auth";
import { Observable } from "rxjs";
import { NgIconComponent, provideIcons } from "@ng-icons/core";
import { remixCloseLine } from "@ng-icons/remixicon";
import { MainPanelComponent } from "$ui/nav/user-menu/panels/main-panel/main-panel.component";
import { QuickSettingsComponent } from "$ui/nav/user-menu/panels/quick-settings/quick-settings.component";
import { LogOutComponent } from "$ui/nav/user-menu/panels/log-out/log-out.component";

enum UserMenuPanels {
  main,
  settings,
  logOut,
}

@Component({
  selector: "app-user-menu",
  standalone: true,
  imports: [
    NgxFloatUiModule,
    AsyncPipe,
    NgClass,
    NgOptimizedImage,
    NgIf,
    NgIconComponent,
    NgComponentOutlet,
    MainPanelComponent,
    QuickSettingsComponent,
    LogOutComponent,
  ],
  viewProviders: [provideIcons({ remixCloseLine })],
  templateUrl: "./user-menu.component.html",
  styleUrl: "./user-menu.component.css",
})
export class UserMenuComponent {
  protected readonly UserMenuPanels = UserMenuPanels;
  @Select(AuthState.currProfile) currProfile$!: Observable<Profile>;
  currPanel = UserMenuPanels.main;
  isOpen = false;

  constructor(private store: Store) {}

  setOpen() {
    this.isOpen = true;
    this.currPanel = UserMenuPanels.main;
  }

  setClosed() {
    this.isOpen = false;
    this.currPanel = UserMenuPanels.main;
  }

  logOut() {
    this.store.dispatch(new AuthActions.LogOut()).subscribe(() => {
      this.isOpen = false;
      this.currPanel = UserMenuPanels.main;
    });
  }
}
