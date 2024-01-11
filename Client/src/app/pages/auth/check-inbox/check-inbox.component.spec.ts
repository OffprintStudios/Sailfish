import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CheckInboxComponent } from './check-inbox.component';

describe('CheckInboxComponent', () => {
  let component: CheckInboxComponent;
  let fixture: ComponentFixture<CheckInboxComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [CheckInboxComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(CheckInboxComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
