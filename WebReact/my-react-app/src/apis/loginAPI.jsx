// src/apis/loginAPI.jsx
import axios from 'axios';

const loginAPI = async (email, password) => {
  try {
    const response = await axios.post('http://localhost:8080/api/user/login', {
      email,
      password
    });
    return response.data;
  } catch (error) {
    throw error.response ? error.response.data : new Error('登录失败');
  }
};

export default loginAPI;
