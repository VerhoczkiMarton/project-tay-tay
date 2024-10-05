import {describe, it, expect} from 'vitest';
import api from '../api.js';

describe('Api', () => {
  it('should use the correct base URL', () => {
    expect(api.baseUrl).toBe('http://localhost:8080');
  });

  it('should construct the correct API URL', () => {
    expect(api.apiUrl).toBe('http://localhost:8080/api/v1');
  });
});
