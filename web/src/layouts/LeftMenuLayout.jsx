// LeftMenuLayout.jsx
import { Menu } from 'antd';
import { DesktopOutlined, PieChartOutlined } from '@ant-design/icons';
import { useNavigate, useLocation } from "react-router-dom";
import Inventory from "@/pages/Inventory.jsx";

const items = [
    {
        key: '/analytics',
        icon: <PieChartOutlined />,
        label: 'Analytics',
    },
    {
        key: '/products',
        icon: <DesktopOutlined />,
        label: 'Products',
    },
    {
        key: '/inventory',
        label: 'Inventory',
    },

];

const LeftMenu = () => {
    const navigate = useNavigate();
    const location = useLocation();

    const clickHandler = (e) => {
        navigate(e.key, { replace: true })
    }

    return (
        <Menu
            theme="dark"
            defaultSelectedKeys={[location.pathname]}
            mode="inline"
            items={items}
            onClick={clickHandler}
        />
    );
};

export default LeftMenu;