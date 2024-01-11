import { LocaleDatePipe } from './locale-date.pipe';

describe('LocaleDatePipe', () => {
  it('create an instance', () => {
    const pipe = new LocaleDatePipe();
    expect(pipe).toBeTruthy();
  });
});
