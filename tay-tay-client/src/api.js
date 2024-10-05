const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:8080';

class Api {
  constructor(baseUrl = API_BASE_URL) {
    this.baseUrl = baseUrl;
    this.apiUrl = `${this.baseUrl}/api/v1`;
  }

  async request(endpoint, options = {}) {
    const url = `${this.apiUrl}${endpoint}`;
    console.log(`Making request to ${url}`);
    const defaultOptions = {
      headers: {
        'Content-Type': 'application/json',
      },
    };

    const mergedOptions = {...defaultOptions, ...options};

    try {
      const response = await fetch(url, mergedOptions);
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      return await response.json();
    } catch (error) {
      console.error('API request error:', error);
      throw error;
    }
  }

  async getUser(userId) {
    return this.request(`/users/${userId}`, {method: 'GET'});
  }

  async createUser(userData) {
    return this.request('/users', {
      method: 'POST',
      body: JSON.stringify(userData),
    });
  }
}

const api = new Api();
export default api;
