// src/router/index.jsx
import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import App from '../app';
import Login from '../components/Login';
import Register from '../components/Register';
// 其他导入...

const AppRouter = () => {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<App />} />
        <Route path="/login" element={<Login />} />
        <Route path="/register" element={<Register />} />
        {/* 添加更多路由... */}
      </Routes>
    </Router>
  );
};

export default AppRouter;
