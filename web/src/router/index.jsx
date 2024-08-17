import {createBrowserRouter} from 'react-router-dom'
import Layout from "../pages/layout/Layout.jsx";

const router = createBrowserRouter([
    {
        path: '/',
        element: <Layout/>,
    }
])

export default router;