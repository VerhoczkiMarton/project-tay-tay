import React from 'react';
import {render, screen} from '@testing-library/react';

describe('Sanity', () => {
  test('sanity', () => {
    render(<p>Sanity</p>)
    const element = screen.getByText(/Sanity/i);
    expect(element).toBeInTheDocument();
  });
});
