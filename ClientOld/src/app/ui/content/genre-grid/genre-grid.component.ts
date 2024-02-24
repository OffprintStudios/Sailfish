import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NgIconComponent, provideIcons } from "@ng-icons/core";
import {
    remixBox2Line,
    remixSwordLine,
    remixEmotionLaughLine,
    remixMoonFoggyLine,
    remixFilePaper2Line,
    remixDoorClosedLine,
    remixMagicLine,
    remixGhost2Line,
    remixSearch2Line,
    remixHeartsLine,
    remixEmotionSadLine,
    remixAliensLine,
    remixHome3Line,
    remixMeteorLine,
    remixSpyLine,
    remixSkullLine,
} from "@ng-icons/remixicon";

@Component({
    selector: 'app-genre-grid',
    standalone: true,
    imports: [CommonModule, NgIconComponent],
    viewProviders: [provideIcons({
        remixBox2Line,
        remixSwordLine,
        remixEmotionLaughLine,
        remixMoonFoggyLine,
        remixFilePaper2Line,
        remixDoorClosedLine,
        remixMagicLine,
        remixGhost2Line,
        remixSearch2Line,
        remixHeartsLine,
        remixEmotionSadLine,
        remixAliensLine,
        remixHome3Line,
        remixMeteorLine,
        remixSpyLine,
        remixSkullLine,
    })],
    templateUrl: './genre-grid.component.html',
    styleUrl: './genre-grid.component.css'
})
export class GenreGridComponent {
    genres = [
        { id: 1, name: 'Action/Adventure', icon: 'remixSwordLine' },
        { id: 2, name: 'Comedy', icon: 'remixEmotionLaughLine' },
        { id: 3, name: 'Dark', icon: 'remixMoonFoggyLine' },
        { id: 4, name: 'Drama', icon: 'remixFilePaper2Line' },
        { id: 5, name: 'Erotica', icon: 'remixDoorClosedLine' },
        { id: 6, name: 'Fantasy', icon: 'remixMagicLine' },
        { id: 7, name: 'Horror', icon: 'remixGhost2Line' },
        { id: 8, name: 'Mystery', icon: 'remixSearch2Line' },
        { id: 9, name: 'Romance', icon: 'remixHeartsLine' },
        { id: 10, name: 'Sad', icon: 'remixEmotionSadLine' },
        { id: 11, name: 'Science Fiction', icon: 'remixAliensLine' },
        { id: 12, name: 'Slice of Life', icon: 'remixHome3Line' },
        { id: 13, name: 'Speculative Fiction', icon: 'remixMeteorLine' },
        { id: 14, name: 'Thriller', icon: 'remixSpyLine' },
        { id: 15, name: 'Tragedy', icon: 'remixSkullLine' }
    ]
}
