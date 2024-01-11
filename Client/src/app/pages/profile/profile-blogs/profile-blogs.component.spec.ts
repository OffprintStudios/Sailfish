import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ProfileBlogsComponent } from './profile-blogs.component';

describe('ProfileBlogsComponent', () => {
  let component: ProfileBlogsComponent;
  let fixture: ComponentFixture<ProfileBlogsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ProfileBlogsComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(ProfileBlogsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
