import React, { useState, useEffect, useCallback } from 'react';
import { ConfigProvider, Layout, Button } from 'antd';
import { LeftOutlined, RightOutlined } from '@ant-design/icons';
import LeftMenuLayout from "@/layouts/LeftMenuLayout";
import { Outlet, useLocation } from "react-router-dom";
import HeaderLayout from "@/layouts/HeaderLayout";

const { Header, Sider, Content } = Layout;

const themeConfig = {
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
};

const DashboardLayout = () => {
  const [collapsed, setCollapsed] = useState({ left: false, right: true });
  const location = useLocation();

  useEffect(() => {
    setCollapsed(prev => ({ ...prev, right: true }));
  }, [location.pathname]);

  const toggleCollapsed = useCallback((side) => {
    setCollapsed(prev => ({ ...prev, [side]: !prev[side] }));
  }, []);

  return (
    <ConfigProvider theme={themeConfig}>
      <Layout className="h-screen overflow-hidden">
        <Sider collapsible collapsed={collapsed.left} onCollapse={() => toggleCollapsed('left')}>
          <LeftMenuLayout collapsed={collapsed.left} />
        </Sider>

        <Layout>
          <Header className="flex items-center justify-between px-4 bg-white">
            <HeaderLayout />
          </Header>

          <Layout className="overflow-hidden">
            <Content className="p-6 m-4 bg-white rounded-lg shadow-md overflow-y-auto h-[calc(100vh-112px)]">
              <Outlet />
            </Content>
            <Sider
              width={collapsed.right ? 80 : "20%"}
              className="bg-white m-4 rounded-lg shadow-md"
              collapsible
              collapsed={collapsed.right}
              reverseArrow
              collapsedWidth={80}
              trigger={null}
            >
              <div className="p-4 text-center">
                <Button
                  type="primary"
                  onClick={() => toggleCollapsed('right')}
                  icon={collapsed.right ? <LeftOutlined /> : <RightOutlined />}
                >
                  {collapsed.right ? '' : 'Collapse'}
                </Button>
              </div>
              {!collapsed.right && <div className="p-4 text-gray-600">Right Sidebar Content</div>}
            </Sider>
          </Layout>
        </Layout>
      </Layout>
    </ConfigProvider>
  );
};

export default DashboardLayout;