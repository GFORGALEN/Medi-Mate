import {createBrowserRouter} from 'react-router-dom'
import Login from "@/pages/Login.jsx";
import Analytics from "@/pages/Analytics.jsx";
import DashBoardLayout from "@/layouts/DashBoardLayout.jsx";
import Products from "@/pages/Products.jsx";
import EditProduct from "@/pages/EditProduct.jsx";
import ViewProduct from "@/pages/ViewProduct.jsx";
import NewProductForm from "@/pages/NewAddProduct.jsx";
const router = createBrowserRouter([
    {
        path: '/',
        element: <DashBoardLayout/>,
        children: [{
            path: '/analytics',
            element: <Analytics/>
        },
            {
                path: '/products',
                element: <Products/>
            },
            {
                path: '/products/productDetail/view/:id',
                element: <ViewProduct/>
            },
            {
                path: '/products/productDetail/edit/:id',
                element: <EditProduct/>
            },
            {
                path: '/products/new',
                element: <NewProductForm />
            }]
    }, {
        path: '/login',
        element: <Login/>
    }
])


export default router;