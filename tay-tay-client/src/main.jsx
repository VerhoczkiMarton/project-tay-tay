import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App.jsx';
import { LogtoProvider } from '@logto/react';

const config = {
  endpoint: import.meta.env.VITE_LOGTO_CONFIG_ENDPOINT || 'http://localhost:3001/',
  appId: import.meta.env.VITE_LOGTO_CONFIG_APP_ID || '1kumj8ov6qlzc4t5imnv0',
  resources: [import.meta.env.VITE_LOGTO_CONFIG_RESOURCES || 'http://localhost:8080/'],
};

ReactDOM.createRoot(document.getElementById('root')).render(
    <React.StrictMode>
        <LogtoProvider config={config}>
            <App />
        </LogtoProvider>
    </React.StrictMode>,
);
