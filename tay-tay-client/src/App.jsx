import React from 'react';
import LoginButton from './LoginButton.jsx';
import LogoutButton from './LogoutButton.jsx';
import useApi from './hooks/useApi.js';
import {Button} from 'antd';
import {useAuth0} from '@auth0/auth0-react';

const App = () => {
  const {apiData, loading, error, callApi} = useApi();
  const {user, isAuthenticated} = useAuth0();

  return (
    <>
      <h1>Project Tay Tay</h1>
      <p>Its a work in progress, but now its React!</p>

      {isAuthenticated ?
        <>
          <p>User: {JSON.stringify(user)}</p>
          <LogoutButton/>
        </> :
        <>
          <p>Not logged in</p>
          <LoginButton/>
        </>
      }

      {
        loading && <p>Loading...</p>
      }

      {
        error && <p>Error: {error.message}</p>
      }

      {
        <>
          <br/>
          <Button
            onClick={() => callApi('public_users')}
          >
            Get PUBLIC Users
          </Button>
          <br/>
          <Button
            onClick={() => callApi( 'private_users', 'post')}
          >
            Get PRIVATE Users
          </Button>
          <br/>
          <Button
            onClick={() => callApi('private-scoped_users')}
          >
            Get PRIVATE SCOPED Users
          </Button>
        </>
      }
      {
        apiData && <p>API data: {JSON.stringify(apiData)}</p>
      }
    </>
  );
};

export default App;
