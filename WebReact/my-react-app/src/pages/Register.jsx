import React, { useState } from 'react';
import { UserApi } from '../apis/UserApi';  // 确保正确导入 UserApi
import { useNavigate } from 'react-router-dom';

function Register() {
  const [accessCode, setAccessCode] = useState('');
  const [isAuthorized, setIsAuthorized] = useState(false);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const userApi = new UserApi();  // 确保在这里实例化 UserApi
  const navigate = useNavigate();

  const handleAccessCodeSubmit = () => {
    if (accessCode === 'mdimate') {
      setIsAuthorized(true);
    } else {
      alert('Incorrect password. Please try again.');
    }
  };

  const handleRegister = async () => {
    if (password !== confirmPassword) {
      console.error('Passwords do not match');
      return;
    }
    try {
      await userApi.register({ email, password });  // 正确使用实例化的 userApi
      navigate('/login');
    } catch (error) {
      console.error('Registration failed', error);
    }
  };

  return (
    <div className="flex items-center justify-center min-h-screen bg-gradient-to-r from-black via-gray-800 to-white p-4">
      <div className="w-full max-w-lg p-8 space-y-8 bg-white bg-opacity-10 backdrop-filter backdrop-blur-lg rounded-lg shadow-lg">
        {!isAuthorized ? (
          <>
            <h2 className="text-2xl font-bold text-center text-white">Employee Only Access</h2>
            <p className="text-center text-white">Only employees can register. Please enter the access code:</p>
            <input
              type="password"
              value={accessCode}
              onChange={(e) => setAccessCode(e.target.value)}
              placeholder="Access Code"
              className="w-full px-4 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-indigo-400"
            />
            <button
              onClick={handleAccessCodeSubmit}
              className="w-full px-4 py-2 text-white bg-slate-900 rounded-md hover:bg-slate-400"
            >
              Submit
            </button>
          </>
        ) : (
          <>
            <h2 className="text-2xl font-bold text-center text-white">Create your account</h2>
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
              <input
                type="password"
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                placeholder="Confirm Password"
                className="w-full px-4 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-indigo-400"
              />
              <button
                onClick={handleRegister}
                className="w-full px-4 py-2 text-white bg-slate-900 rounded-md hover:bg-slate-400"
              >
                Register
              </button>
              <p className="text-center text-white">Already have an account? <a href="/login" className="text-slate-900 hover:underline">Sign In</a></p>
            </div>
          </>
        )}
      </div>
    </div>
  );
}

export default Register;
