import {useState, useEffect, useCallback} from 'react';
import {ConfigProvider, Layout, Button} from 'antd';
import {LeftOutlined, RightOutlined} from '@ant-design/icons';
import LeftMenuLayout from "@/layouts/LeftMenuLayout";
import {Outlet, useLocation} from "react-router-dom";
import HeaderLayout from "@/layouts/HeaderLayout";

const {Header, Sider, Content} = Layout;

const themeConfig = {
    components: {
        Layout: {
            bodyBg: '#f5f7fa',
            headerBg: '#ffffff',
            siderBg: '#f8f7f4'  // 保持不变
        },
        Menu: {
            itemSelectedBg: '#1d39c4',
            itemSelectedColor: '#ffffff',
            itemColor: 'rgba(0, 0, 0, 0.65)',
            itemBg: 'transparent',
            itemHoverColor: '#2f54eb',
            itemHoverBg: 'rgba(45, 83, 235, 0.1)'
        },
        Button: {
            primaryColor: '#ffffff',
            primaryBg: '#2f54eb',
            primaryHoverBg: '#597ef7',
            defaultBg: '#ffffff',
            defaultColor: 'rgba(0, 0, 0, 0.85)',
            defaultHoverBg: '#ffffff',
            defaultHoverColor: '#2f54eb'
        }
    },
    token: {
        colorPrimary: '#2f54eb',
        colorBgContainer: '#ffffff'
    },
};

const DashboardLayout = () => {
    const [collapsed, setCollapsed] = useState({ left: true, right: true });
    const [isHovering, setIsHovering] = useState(false);
    const location = useLocation();

    useEffect(() => {
        setCollapsed(prev => ({ ...prev, right: true }));
    }, [location.pathname]);

    const toggleCollapsed = useCallback((side) => {
        setCollapsed(prev => ({ ...prev, [side]: !prev[side] }));
    }, []);

    const handleMouseEnter = useCallback(() => {
        setIsHovering(true);
        setCollapsed(prev => ({ ...prev, left: false }));
    }, []);

    const handleMouseLeave = useCallback(() => {
        setIsHovering(false);
        setCollapsed(prev => ({ ...prev, left: true }));
    }, []);

    return (
        <ConfigProvider theme={themeConfig}>
            <Layout className="h-screen overflow-hidden">
                <Sider
                    collapsible
                    collapsed={collapsed.left && !isHovering}
                    onCollapse={() => toggleCollapsed('left')}
                    onMouseEnter={handleMouseEnter}
                    onMouseLeave={handleMouseLeave}
                    className="transition-all duration-300 ease-in-out"
                    trigger={null}
                >
                    <LeftMenuLayout collapsed={collapsed.left && !isHovering} />
                </Sider>
            <Layout>
                    <Header className="flex items-center justify-between px-4">
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