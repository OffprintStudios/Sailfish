import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ProfileShelvesComponent } from './profile-shelves.component';

describe('ProfileShelvesComponent', () => {
  let component: ProfileShelvesComponent;
  let fixture: ComponentFixture<ProfileShelvesComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ProfileShelvesComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(ProfileShelvesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
