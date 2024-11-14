import React, {useState, useEffect} from 'react';
import {useLogto} from '@logto/react';
import api from '../api';

const callbackUrl = `${window.location.origin}/callback`;
const signOutUrl = window.location.origin;

export default function Home() {
  const {signIn, signOut, isAuthenticated, getIdTokenClaims, getAccessToken} = useLogto();
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
        const token = await getAccessToken(import.meta.env.VITE_LOGTO_CONFIG_RESOURCES || 'http://localhost:8080/');
        setAccessToken(token);
        api.setToken(token);
      }
    })();
  }, [isAuthenticated, getAccessToken]);

  const handleCreateUser = async () => {
    const apiResult = await api.createUser();
    setResult(apiResult);
  };

  const handleGetUser = async () => {
    const apiResult = await api.getUser(requestedUser);
    setResult(apiResult);
  };

  return <>
    <h1>Project Tay Tay</h1>
    <p>Access token: {accessToken}</p>
    <p>User: {JSON.stringify(user)}</p>
    {
      isAuthenticated ?
      <button onClick={() => signOut(signOutUrl)}>Sign Out</button> :
      <button onClick={() => signIn(callbackUrl)}>Sign In</button>
    }
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
  </>;
}
