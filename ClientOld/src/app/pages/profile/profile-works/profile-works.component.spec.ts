import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ProfileWorksComponent } from './profile-works.component';

describe('ProfileWorksComponent', () => {
  let component: ProfileWorksComponent;
  let fixture: ComponentFixture<ProfileWorksComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ProfileWorksComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(ProfileWorksComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
