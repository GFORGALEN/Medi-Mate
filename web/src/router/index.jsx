import {createBrowserRouter} from 'react-router-dom'
import Login from "@/pages/Login.jsx";
import Analytics from "@/pages/Analytics.jsx";
import DashBoardLayout from "@/layouts/DashBoardLayout.jsx";
import Products from "@/pages/Products.jsx";

const router = createBrowserRouter([
    {
        path: '/',
        element: <DashBoardLayout/>,
        children: [{
            path: '/analytics',
            element: <Analytics/>
        }
        ,{
            path: '/products',
            element: <Products/>
        }]
    }, {
        path: '/login',
        element: <Login/>
    }
])

export default router;