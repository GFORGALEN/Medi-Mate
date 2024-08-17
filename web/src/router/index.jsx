import {createBrowserRouter} from 'react-router-dom'
import DashBoardLayout from "@/pages/Layout/DashBoardLayout.jsx";
import Login from "@/pages/Auth/Login.jsx";

const router = createBrowserRouter([
    {
        path: '/',
        element: <DashBoardLayout/>,
    }, {
        path: '/login',
        element: <Login/>
    }
])

export default router;