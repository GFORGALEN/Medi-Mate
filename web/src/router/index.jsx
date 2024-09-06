import { createBrowserRouter, Navigate, Outlet } from 'react-router-dom';
import TLogin from "@/pages/TLogin.jsx";
import Login from "@/pages/Login.jsx";
import DashBoardLayout from "@/layouts/DashBoardLayout.jsx";
import Products from "@/pages/Products.jsx";
import EditProduct from "@/pages/EditProduct.jsx";
import ViewProduct from "@/pages/ViewProduct.jsx";
import NewProductForm from "@/pages/NewAddProduct.jsx";
import ProductAnalytics from "@/pages/Analytics.jsx";
import Inventory from "@/pages/Inventory.jsx";
import Pharmacies from "@/pages/Pharmacies.jsx";
import PharmacyInventory from "@/pages/PharmacyInventory.jsx";
import Homepage from '../pages/mobile/Homepage';
import OrderPage from '../pages/Order/OrderPage';

// 创建一个简单的身份验证检查函数
const isAuthenticated = () => {
    // 这里应该实现实际的身份验证逻辑
    // 例如，检查 localStorage 中是否存在有效的令牌
    return localStorage.getItem('token') !== null;
};

// 创建受保护的路由组件
const ProtectedRoute = () => {
    if (!isAuthenticated()) {
        return <Navigate to="/login" replace />;
    }
    return <Outlet />;
};

const router = createBrowserRouter([
    {
        path: '/',
        element: <Navigate to="/login" replace />,
    },
    {
        path: '/login',
        element: <TLogin />,
    },
    {
        path: '/mobile',
        element: <Homepage />, // 这是移动端首页
    },
    {
        path: '/',
        element: <ProtectedRoute />, // 使用受保护的路由组件
        children: [
            {
                path: '/',
                element: <DashBoardLayout />,
                children: [
                    {
                        path: 'analytics',
                        element: <ProductAnalytics />,
                    },
                    {
                        path: 'products',
                        element: <Products />,
                    },
                    {
                        path: 'products/productDetail/view/:id',
                        element: <ViewProduct />,
                    },
                    {
                        path: 'products/productDetail/edit/:id',
                        element: <EditProduct />,
                    },
                    {
                        path: 'products/new',
                        element: <NewProductForm />,
                    },
                    {
                        path: 'inventory',
                        element: <Inventory />,
                    },
                    {
                        path: 'pharmacies',
                        element: <Pharmacies />,
                    },
                    {
                        path: 'inventory/:pharmacyId',
                        element: <PharmacyInventory />,
                    },
                    {
                        path: 'OrderPage',
                        element: <OrderPage />,
                    },
                ],
            },
        ],
    },
]);

export default router;