import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SocialLinkBadgeComponent } from './social-link-badge.component';

describe('SocialLinkBadgeComponent', () => {
  let component: SocialLinkBadgeComponent;
  let fixture: ComponentFixture<SocialLinkBadgeComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [SocialLinkBadgeComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(SocialLinkBadgeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
