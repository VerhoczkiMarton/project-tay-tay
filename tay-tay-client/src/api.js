const api = {
  domain: window.location.origin,
  apiUrl: `${window.location.origin}/api/v1`,

  request: async (endpoint, options = {}) => {
    try {
      const response = await fetch(`${api.apiUrl}${endpoint}`, options);
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      return await response.json();
    } catch (error) {
      console.error('API request error:', error);
      throw error;
    }
  },

  getUser: async (userId) => {
    return api.request(`/get/${userId}`);
  },

  createUser: async (userData) => {
    return api.request('/create', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(userData),
    });
  },
};

export default api;
