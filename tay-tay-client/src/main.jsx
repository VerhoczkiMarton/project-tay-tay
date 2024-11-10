import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App.jsx';
import { LogtoProvider } from '@logto/react';

const config = {
  endpoint: 'http://localhost:3001/',
  appId: '1kumj8ov6qlzc4t5imnv0',
  resources: ['http://localhost:8080/'],
};

ReactDOM.createRoot(document.getElementById('root')).render(
    <React.StrictMode>
        <LogtoProvider config={config}>
            <App />
        </LogtoProvider>
    </React.StrictMode>,
);
