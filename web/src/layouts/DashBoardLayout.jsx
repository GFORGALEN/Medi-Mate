import {ConfigProvider, Layout} from 'antd';
import LeftMenu from "@/layouts/LeftMenuLayout.jsx";
import {Outlet} from "react-router-dom";
import HeaderLayout from "@/layouts/HeaderLayout.jsx";

const {Header, Footer, Sider, Content} = Layout;

const headerStyle = {
    textAlign: 'center',
    color: '#fff',
    height: '64px',
    paddingInline: 0,
    lineHeight: '64px',
    backgroundColor: '#fff',
};
const contentStyle = {
    textAlign: 'center',
    flex: 1,
    lineHeight: '120px',
    color: '#000',
    backgroundColor: '#f1f5f9',
    overflow: 'auto',
    padding: '16px',
};
const leftSiderStyle = {
    textAlign: 'center',
    lineHeight: '100%',
    backgroundColor: '#111827',
    flex: 1
};
const rightSiderStyle = {
    textAlign: 'center',
    lineHeight: '100%',
    color: '#000',
    backgroundColor: '#fff',
    flex: 1
};
const footerStyle = {
    color: '#fff',
    backgroundColor: '#111827',
};
const outerLayoutStyle = {
    height: '100vh',
    maxWidth: '100%',
};
const innerLayoutStyle = {
    height: '100vn',
    maxWidth: '95%',
}

const DashBoardLayout = () => (
    <ConfigProvider
        theme={{
            components: {
                Table: {
                    stickyScrollBarBg: '',
                },
                Menu: {
                    itemSelectedBg:'#29303D',
                    itemSelectedColor:'#fff',
                    itemColor:'#fff',
                    itemBg:'#111827'
                }
            },
            token: {},
        }}
    >
        <Layout style={outerLayoutStyle}>
            <Layout style={innerLayoutStyle}>
                <Header style={headerStyle}><HeaderLayout/></Header>
                <Layout>
                    <Sider width="15%" style={leftSiderStyle}>
                        <LeftMenu/>
                    </Sider>
                    <Content style={contentStyle}>
                        <Outlet/>
                    </Content>
                </Layout>
                <Footer style={footerStyle}>
                    Footer
                </Footer>
            </Layout>
            <Sider width="5%" style={rightSiderStyle}>
                Sider
            </Sider>
        </Layout>
    </ConfigProvider>

);

export default DashBoardLayout;
