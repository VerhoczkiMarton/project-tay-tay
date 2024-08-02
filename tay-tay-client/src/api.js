const api = {
  api_url: 'https://service-production-0b43.up.railway.app/api/v1',
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
