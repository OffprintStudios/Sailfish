import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SearchMenuComponent } from './search-menu.component';

describe('SearchMenuComponent', () => {
  let component: SearchMenuComponent;
  let fixture: ComponentFixture<SearchMenuComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [SearchMenuComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(SearchMenuComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
