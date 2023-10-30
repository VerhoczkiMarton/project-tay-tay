import React from 'react';
import {render, screen} from '@testing-library/react';
import App from './App';

describe('App Component', () => {
  test('renders the title', () => {
    render(<App />);
    const titleElement = screen.getByText(/Project Tay Tay/i);
    expect(titleElement).toBeInTheDocument();
  });

  test('this fails', () => {
    render(<App />);
    const element = screen.getByText(/Deffo not in document/i);
    expect(element).toBeInTheDocument();
  });
});
