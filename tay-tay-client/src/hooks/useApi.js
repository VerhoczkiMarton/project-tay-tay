import {useAuth0} from '@auth0/auth0-react';
import axios from 'axios';
import {useState} from 'react';

const useApi = () => {
  const {getAccessTokenSilently, isAuthenticated, getIdTokenClaims} = useAuth0();
  const [apiData, setApiData] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const apiBaseUrl = 'http://localhost/api/v1/';

  const callApi = async (url, method = 'get', data = null) => {
    setLoading(true);
    setError(null);

    const claims = await getIdTokenClaims();

    data = JSON.stringify({
      ...data,
      claims: claims,
    });

    try {
      const request = {
        method,
        url: `${apiBaseUrl}${url}`,
        data,
        headers: {
          'Content-Type': 'application/json',
        },
      };

      if (isAuthenticated) {
        const token = await getAccessTokenSilently({
          audience: 'http://localhost/api/v1/',
          scope: 'read:current_user',
        });
        request.headers.Authorization = `Bearer ${token}`;
      }

      console.log('request', request);
      const response = await axios(request);

      setApiData(response.data);
    } catch (error) {
      setError(error);
    } finally {
      setLoading(false);
    }
  };

  return {
    apiData,
    loading,
    error,
    callApi,
  };
};

export default useApi;
