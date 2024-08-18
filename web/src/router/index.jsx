import {createBrowserRouter} from 'react-router-dom'
import Login from "@/pages/Login.jsx";
import Analytics from "@/pages/Analytics.jsx";
import DashBoardLayout from "@/pages/DashBoardLayout.jsx";

const router = createBrowserRouter([
    {
        path: '/',
        element: <DashBoardLayout/>,
        children: [{
            path: '/analytics',
            element: <Analytics/>
        }]
    }, {
        path: '/login',
        element: <Login/>
    }
])

export default router;