import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CardCarouselComponent } from './card-carousel.component';

describe('CardCarouselComponent', () => {
  let component: CardCarouselComponent;
  let fixture: ComponentFixture<CardCarouselComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [CardCarouselComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(CardCarouselComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
