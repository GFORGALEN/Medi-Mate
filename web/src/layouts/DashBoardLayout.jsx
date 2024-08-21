import React, { useState } from 'react';
import { ConfigProvider, Layout, Button } from 'antd';
import {
    MenuFoldOutlined,
    MenuUnfoldOutlined,
    LogoutOutlined,
    LeftOutlined,
    RightOutlined
} from '@ant-design/icons';
import LeftMenu from "@/layouts/LeftMenuLayout.jsx";
import { Outlet, useNavigate } from "react-router-dom";
import HeaderLayout from "@/layouts/HeaderLayout.jsx";

const { Header, Footer, Sider, Content } = Layout;

const headerStyle = {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
    color: '#ffffff',
    height: '64px',
    paddingInline: 16,
    backgroundColor: '#45ddc2',
};

const contentStyle = {
    padding: '24px',
    minHeight: 280,
    backgroundColor: '#f1f5f9',
    overflow: 'auto',
};

const leftSiderStyle = {
    backgroundColor: '#111827',
};

const rightSiderStyle = {
    backgroundColor: '#ffffff',
};

const footerStyle = {
    textAlign: 'center',
    color: '#fff',
    backgroundColor: '#111827',
};

const DashBoardLayout = () => {
    const [leftCollapsed, setLeftCollapsed] = useState(false);
    const [rightCollapsed, setRightCollapsed] = useState(false);
    const navigate = useNavigate();

    const toggleLeftCollapsed = () => {
        setLeftCollapsed(!leftCollapsed);
    };

    const toggleRightCollapsed = () => {
        setRightCollapsed(!rightCollapsed);
    };

    const handleLogout = () => {
        console.log('User logged out');
        navigate('/login');
    };

    return (
        <ConfigProvider
            theme={{
                components: {
                    Table: {
                        stickyScrollBarBg: '',
                    },
                    Menu: {
                        itemSelectedBg: '#29303D',
                        itemSelectedColor: '#fff',
                        itemColor: '#fff',
                        itemBg: '#111827'
                    }
                },
                token: {},
            }}
        >
            <Layout style={{ minHeight: '100vh' }}>
                <Sider collapsible collapsed={leftCollapsed} onCollapse={toggleLeftCollapsed} style={leftSiderStyle}>
                    <div className="logo" style={{ height: '64px', background: '#45ddc2', margin: '16px' }} />
                    <LeftMenu />
                </Sider>
                <Layout>
                    <Header style={headerStyle}>
                        <Button
                            type="text"
                            icon={leftCollapsed ? <MenuUnfoldOutlined /> : <MenuFoldOutlined />}
                            onClick={toggleLeftCollapsed}
                            style={{ fontSize: '16px', width: 64, height: 64 }}
                        />
                        <HeaderLayout />
                        <Button type="primary" icon={<LogoutOutlined />} onClick={handleLogout}>
                            Logout
                        </Button>
                    </Header>
                    <Layout>
                        <Content style={contentStyle}>
                            <Outlet />
                        </Content>
                        <Sider
                            width={rightCollapsed ? 80 : "20%"}
                            style={rightSiderStyle}
                            collapsible
                            collapsed={rightCollapsed}
                            reverseArrow
                            collapsedWidth={80}
                            trigger={null}
                        >
                            <div style={{ padding: '16px', textAlign: 'center' }}>
                                <Button
                                    type="primary"
                                    onClick={toggleRightCollapsed}
                                    icon={rightCollapsed ? <LeftOutlined /> : <RightOutlined />}
                                >
                                    {rightCollapsed ? '' : 'Collapse'}
                                </Button>
                            </div>
                            {!rightCollapsed && <div>Right Sider Content</div>}
                        </Sider>
                    </Layout>
                    <Footer style={footerStyle}>
                        Footer
                    </Footer>
                </Layout>
            </Layout>
        </ConfigProvider>
    );
};

export default DashBoardLayout;