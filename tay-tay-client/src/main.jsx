import React from 'react';
import {createRoot} from 'react-dom/client';
import {Auth0Provider} from '@auth0/auth0-react';
import App from './App';

const root = createRoot(document.getElementById('root'));

root.render(
    <Auth0Provider
      domain="taytayapp.eu.auth0.com"
      clientId="j6dOAJU7LelJClVazV9Q83HRuEw9bIp0"
      authorizationParams={{
        redirect_uri: window.location.origin,
        audience: 'http://localhost/api/v1/',
      }}
    >
      <App/>
    </Auth0Provider>,
);
