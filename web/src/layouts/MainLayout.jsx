import React from 'react';
import { Layout } from 'antd';
import { Outlet } from 'react-router-dom';
import Sider from './components/Sider';
import Header from './components/Header';

const { Content } = Layout;

const MainLayout = () => {
    return (
        <Layout style={{ minHeight: '100vh' }}>
            <Sider />
            <Layout>
                <Header />
                <Content style={{ margin: '24px 16px 0' }}>
                    <div style={{ padding: 24, minHeight: 360, background: '#fff' }}>
                        <Outlet />
                    </div>
                </Content>
            </Layout>
        </Layout>
    );
};

export default MainLayout;