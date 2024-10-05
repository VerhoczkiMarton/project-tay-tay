import React, {useState} from 'react';
import api from './api.js';

const App = () => {
  const [userId, setUserId] = useState('');

  const createUserHandler = async () => {
    const user = await api.createUser();
    console.log(user);
  };

  const getUserHandler = async () => {
    const user = await api.getUser(userId);
    console.log(user);
  };

  const handleInputChange = (event) => {
    setUserId(event.target.value);
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    getUserHandler();
  };

  return (
    <>
      <h1>Project Tay Tay</h1>
      <p>Its a work in progress, but now its React!</p>
      <button onClick={createUserHandler}>Create User</button>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          placeholder="User ID"
          value={userId}
          onChange={handleInputChange}
        />
        <button type="submit">Get User</button>
      </form>
    </>
  );
};

export default App;
