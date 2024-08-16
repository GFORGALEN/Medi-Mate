import React, { useState } from 'react';
import { Layout, Menu } from 'antd';
import { Link, useLocation } from 'react-router-dom';
import {
    DashboardOutlined,

} from '@ant-design/icons';

const { Sider } = Layout;

const SiderComponent = () => {
    const [collapsed, setCollapsed] = useState(false);
    const location = useLocation();

    const items = [
        {
            key: '/dashboard',
            icon: <DashboardOutlined />,
            label: <Link to="/dashboard">Dashboard</Link>,
        },
        {
            key: '/myChart',
            label: <Link to="/myChart">MyChart</Link>,
        },

    ];

    return (
        <Sider
            collapsible
            collapsed={collapsed}
            onCollapse={(value) => setCollapsed(value)}
            style={{ backgroundColor: '#eaff8f' }} // 自定义 Sider 背景色
        >
            <div className="logo" />
            <Menu
                theme="light"
                selectedKeys={[location.pathname]}
                mode="inline"
                items={items}
                style={{
                    backgroundColor: '#eaff8f', // 菜单背景色
                    color: '#eaff8f',           // 菜单文字颜色
                }}
            />
        </Sider>
    );
};
// style={{backgroundColor: '#eaff8f',}}
export default SiderComponent;