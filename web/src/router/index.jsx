import { createBrowserRouter, Navigate } from 'react-router-dom';
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

const router = createBrowserRouter([
    {
        path: '/',
        element: <Navigate to="/login" replace />,
    },
    {
        path: '/login',
        element: <Login />,
    },
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
        ],
    },
]);

export default router;