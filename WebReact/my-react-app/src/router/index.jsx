// src/router/index.jsx
import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
// import App from '../app';
import Login from '../pages/Login.jsx';
import Register from '../pages/Register.jsx';
import Dashboard from '../pages/Dashboard.jsx';
// import Sidebar from './components/Sidebar';
// import Topbar from './components/Topbar';
import Settings from '../components/Settings';
import Profile from '../pages/Profile';
import ProtectedLayout from '../components/ProtectedLayout';
// 其他导入...

const AppRouter = () => {
  return (
    <Router>
      <Routes>

        <Route path="/" element={<Login />} />
        <Route path="/login" element={<Login />} />
        <Route path="/register" element={<Register />} />

        {/* 受保护的路由，显示侧边栏和顶栏 */}
        <Route element={<ProtectedLayout />}>
          <Route path="/dashboard" element={<Dashboard />} />
          <Route path="/settings" element={<Settings />} />
          <Route path="/profile" element={<Profile />} />
          {/* 可以添加更多的受保护路由 */}
        </Route>
        {/* 添加更多路由... */}

      </Routes>
    </Router>
  );
};


export default AppRouter;
