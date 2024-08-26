import React from 'react';
import { Menu } from 'antd';
import { DesktopOutlined, PieChartOutlined, InboxOutlined } from '@ant-design/icons';
import { useNavigate, useLocation } from "react-router-dom";

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
        icon: <InboxOutlined />,
        label: 'Inventory',
    },
    {
        key: '/pharmacies',
        icon: <InboxOutlined />,
        label: 'Pharmacies',
    },
];

const LeftMenuLayout = () => {
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

export default LeftMenuLayout;