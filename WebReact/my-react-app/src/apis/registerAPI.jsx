// src/apis/registerAPI.jsx
import axios from 'axios';

const registerAPI = async (email, password) => {
  try {
    const response = await axios.post('http://localhost:8080/api/user/register', {
      email,
      password
    });
    return response.data;
  } catch (error) {
    throw error.response ? error.response.data : new Error('注册失败');
  }
};

export default registerAPI;
