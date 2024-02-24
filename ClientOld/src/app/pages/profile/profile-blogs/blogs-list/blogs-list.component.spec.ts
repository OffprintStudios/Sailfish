import { ComponentFixture, TestBed } from '@angular/core/testing';

import { BlogsListComponent } from './blogs-list.component';

describe('BlogsListComponent', () => {
  let component: BlogsListComponent;
  let fixture: ComponentFixture<BlogsListComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [BlogsListComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(BlogsListComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
