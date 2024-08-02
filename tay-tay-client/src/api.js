const api = {
  domain: window.location.origin,
  apiUrl: `${api.domain}/api/v1`,
  getUser: async (userId) => {
    const response = await fetch(`${api.api_url}/get/${userId}`);
    return await response.text();
  },
  createUser: async () => {
    const response = await fetch(`${api.api_url}/create`);
    return await response.text();
  },
};

export default api;