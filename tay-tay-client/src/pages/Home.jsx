import React, {useState, useEffect} from 'react';
import { useLogto } from '@logto/react';
import api from '../api'

export default function Home() {
    const { signIn, signOut, isAuthenticated, getIdTokenClaims, getAccessToken } = useLogto();
    const [user, setUser] = useState();
    const [requestedUser, setRequestedUser] = useState();
    const [accessToken, setAccessToken] = useState();
    const [result, setResult] = useState();

    useEffect(() => {
      (async () => {
        if (isAuthenticated) {
          const claims = await getIdTokenClaims();
          setUser(claims);
        }
      })();
    }, [getIdTokenClaims, isAuthenticated]);

    useEffect(() => {
      (async () => {
        if (isAuthenticated) {
          const token = await getAccessToken('http://localhost:8080/');
          setAccessToken(token);
          api.setToken(token);
        }
      })();
    }, [isAuthenticated, getAccessToken]);

    const handleCreateUser = async () => {
      const api_result = await api.createUser();
      setResult(api_result)
    }

    const handleGetUser = async () => {
      const api_result = await api.getUser(requestedUser);
      setResult(api_result)
    }

    return <>
      <h1>Project Tay Tay</h1>
      <p>Access token: {accessToken}</p>
      {isAuthenticated ? <button onClick={() => signOut('http://localhost:5173/')}>Sign Out</button> : <button onClick={() => signIn('http://localhost:5173/callback')}>Sign In</button>}
      <br></br>
      <input
        type="text"
        value={requestedUser}
        onChange={(event) => setRequestedUser(event.target.value)}
      ></input>
      <button onClick={async () => await handleGetUser()}>Get user</button>
      <br></br>
      <button onClick={async () => await handleCreateUser()}>Create user</button>
      <p>Result: {JSON.stringify(result)}</p>
    </>
}