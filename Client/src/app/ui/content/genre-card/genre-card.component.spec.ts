import { ComponentFixture, TestBed } from '@angular/core/testing';

import { GenreCardComponent } from './genre-card.component';

describe('GenreCardComponent', () => {
  let component: GenreCardComponent;
  let fixture: ComponentFixture<GenreCardComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [GenreCardComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(GenreCardComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
