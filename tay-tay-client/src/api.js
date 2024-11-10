const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:8080';

class Api {
  constructor(baseUrl = API_BASE_URL) {
    this.baseUrl = baseUrl;
    this.apiUrl = `${this.baseUrl}/api`;
    this.token = null;
  }

  setToken(token) {
    this.token = token;
  }

  clearToken() {
    this.token = null;
  }

  async request(endpoint, options = {}) {
    const url = `${this.apiUrl}${endpoint}`;

    const defaultHeaders = {
      'Content-Type': 'application/json',
      ...(this.token && { Authorization: `Bearer ${this.token}` }),
    };

    const mergedOptions = {
      ...options,
      headers: {
        ...defaultHeaders,
        ...(options.headers || {}),
      },
    };

    try {
      const response = await fetch(url, mergedOptions);

      if (response.status === 401) {
        throw new Error("Unauthorized access - token may be expired or invalid");
      }

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      return await response.json();
    } catch (error) {
      throw error;
    }
  }

  async getUser(userId) {
    const result = await this.request(`/users/${userId}`, {method: 'GET'});
    return result;
  }

  async createUser(userData) {
    const result = await this.request('/users', {
      method: 'POST',
      body: JSON.stringify(userData),
    });
    return result;
  }
}

const api = new Api();
export default api;
