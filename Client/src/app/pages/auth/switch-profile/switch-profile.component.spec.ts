import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SwitchProfileComponent } from './switch-profile.component';

describe('SwitchProfileComponent', () => {
  let component: SwitchProfileComponent;
  let fixture: ComponentFixture<SwitchProfileComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [SwitchProfileComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(SwitchProfileComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
