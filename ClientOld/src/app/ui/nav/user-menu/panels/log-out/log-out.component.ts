import { Component, EventEmitter, Output } from "@angular/core";
import { ButtonComponent } from "$ui/util";
import { NgIconComponent, provideIcons } from "@ng-icons/core";
import {
  remixArrowLeftSLine,
  remixCheckLine,
  remixCloseLine,
} from "@ng-icons/remixicon";

@Component({
  selector: "app-log-out",
  standalone: true,
  imports: [ButtonComponent, NgIconComponent],
  viewProviders: [
    provideIcons({ remixArrowLeftSLine, remixCheckLine, remixCloseLine }),
  ],
  templateUrl: "./log-out.component.html",
  styleUrl: "./log-out.component.css",
})
export class LogOutComponent {
  @Output() onLogOut = new EventEmitter();
  @Output() onBack = new EventEmitter();
}
