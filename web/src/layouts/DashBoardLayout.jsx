import React, { useState, useEffect } from 'react';
import { ConfigProvider, Layout, Button } from 'antd';
import {
    MenuFoldOutlined,
    MenuUnfoldOutlined,
    LogoutOutlined,
    LeftOutlined,
    RightOutlined
} from '@ant-design/icons';
import LeftMenuLayout from "@/layouts/LeftMenuLayout.jsx";
import { Outlet, useNavigate, useLocation } from "react-router-dom";
import HeaderLayout from "@/layouts/HeaderLayout.jsx";
import logo from '../../asserts/images/logo.png';
const { Header, Sider, Content } = Layout;

const DashBoardLayout = () => {
    const [leftCollapsed, setLeftCollapsed] = useState(false);
    const [rightCollapsed, setRightCollapsed] = useState(false);
    const navigate = useNavigate();
    const location = useLocation();

    useEffect(() => {
        setRightCollapsed(true);
    }, [location.pathname]);

    const toggleLeftCollapsed = () => setLeftCollapsed(!leftCollapsed);
    const toggleRightCollapsed = () => setRightCollapsed(!rightCollapsed);

    const handleLogout = () => {
        console.log('User logged out');
        navigate('/login');
    };

    return (
        <ConfigProvider
            theme={{
                components: {
                    Layout: {
                        bodyBg: '#f0f2f5',
                        headerBg: '#001529',
                        siderBg: '#001529'
                    },
                    Menu: {
                        itemSelectedBg: '#1890ff',
                        itemSelectedColor: '#fff',
                        itemColor: 'rgba(255, 255, 255, 0.65)',
                        itemBg: 'transparent',
                        itemHoverColor: '#fff',
                        itemHoverBg: 'rgba(255, 255, 255, 0.08)'
                    },
                    Button: {
                        primaryColor: '#fff',
                        primaryBg: '#1890ff',
                        primaryHoverBg: '#40a9ff',
                        defaultBg: '#fff',
                        defaultColor: 'rgba(0, 0, 0, 0.85)',
                        defaultHoverBg: '#fff',
                        defaultHoverColor: '#40a9ff'
                    }
                },
                token: {
                    colorPrimary: '#1890ff',
                    colorBgContainer: '#fff'
                },
            }}
        >
            <Layout className="min-h-screen">
                <Sider collapsible collapsed={leftCollapsed} onCollapse={toggleLeftCollapsed}>
                    <div className="logo p-4 ">
                        <img
                            src={logo}
                            alt="Company Logo"
                            className={`w-full ${leftCollapsed ? 'h-8' : 'h-16'} object-contain transition-all duration-300`}
                        />
                    </div>
                    <LeftMenuLayout />
                </Sider>
                <Layout>
                    <Header className="flex items-center justify-between px-4 bg-white">
                        <Button
                            type="text"
                            icon={leftCollapsed ? <MenuUnfoldOutlined /> : <MenuFoldOutlined />}
                            onClick={toggleLeftCollapsed}
                            className="text-gray-600 hover:text-blue-500 text-xl"
                        />
                        <HeaderLayout />
                        <Button type="primary" icon={<LogoutOutlined />} onClick={handleLogout} danger>
                            Logout
                        </Button>
                    </Header>
                    <Layout>
                        <Content className="p-6 m-4 bg-white rounded-lg shadow-md">
                            <Outlet />
                        </Content>
                        <Sider
                            width={rightCollapsed ? 80 : "20%"}
                            className="bg-white m-4 rounded-lg shadow-md"
                            collapsible
                            collapsed={rightCollapsed}
                            reverseArrow
                            collapsedWidth={80}
                            trigger={null}
                        >
                            <div className="p-4 text-center">
                                <Button
                                    type="primary"
                                    onClick={toggleRightCollapsed}
                                    icon={rightCollapsed ? <LeftOutlined /> : <RightOutlined />}
                                >
                                    {rightCollapsed ? '' : 'Collapse'}
                                </Button>
                            </div>
                            {!rightCollapsed && <div className="p-4 text-gray-600">Right Sidebar Content</div>}
                        </Sider>
                    </Layout>

                </Layout>
            </Layout>
        </ConfigProvider>
    );
};

export default DashBoardLayout;