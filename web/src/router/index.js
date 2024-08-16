import { createBrowserRouter } from 'react-router-dom';
import Layout from '../layouts/MainLayout';
import Login from '../pages/Login';
import MyChart from '../MyChart';
import React from 'react';
const router = createBrowserRouter([
    {
        path: '/',
        element: React.createElement(Layout),
        children: [
            {
                path: 'dashboard',

            },
            {
                path: 'myChart',
                element: React.createElement(MyChart),
            },
            // 可以在这里添加更多子路由...
        ],
    },
    {
        path: '/login',
        element: React.createElement(Login),
    },
]);

export default router;