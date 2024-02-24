import { Component } from '@angular/core';
import { NgxTiptapModule } from 'ngx-tiptap';

@Component({
  selector: 'app-general-editor',
  standalone: true,
  imports: [NgxTiptapModule],
  templateUrl: './general-editor.component.html',
  styleUrl: './general-editor.component.css',
  host: { ngSkipHydration: 'true' }
})
export class GeneralEditorComponent {

}
