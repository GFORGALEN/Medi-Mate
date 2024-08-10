import React, { useState } from 'react';
import { useDispatch } from 'react-redux';
import { login } from '../store/slices/authSlice';
import { UserApi } from '../apis/UserApi';
import { useNavigate } from 'react-router-dom';

function Login() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const dispatch = useDispatch();
  const userApi = new UserApi();
  const navigate = useNavigate();

  const handleLogin = async () => {
    try {
      const response = await userApi.login({
        email: email,
        password: password
      });
      dispatch(login({
        user: response.data.user,
        token: response.data.token,
      }));
      navigate('/dashboard');
    } catch (error) {
      console.error('Login failed, redirecting to register...', error);
      navigate('/register');
    }
  };

  return (
    <div className="flex items-center justify-center min-h-screen bg-gradient-to-r from-black via-gray-800 to-white">
      <div className="w-full max-w-md p-8 space-y-8 bg-white bg-opacity-10 backdrop-filter backdrop-blur-lg rounded-lg shadow-lg">
        <h2 className="text-2xl font-bold text-center text-white">Sign in to your account</h2>
        <div className="space-y-4">
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="Email"
            className="w-full px-4 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-indigo-400"
          />
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder="Password"
            className="w-full px-4 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-indigo-400"
          />
          <button
            onClick={handleLogin}
            className="w-full px-4 py-2 text-white bg-slate-900 rounded-md hover:bg-slate-400"
          >
            Sign In
          </button>
          <p className="text-center text-white">Don't have an account? <a href="/register" className="text-slate-900 hover:underline">Register</a></p>
        </div>
      </div>
    </div>
  );
}

export default Login;
