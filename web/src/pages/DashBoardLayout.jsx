import {Layout} from 'antd';
import LeftMenu from "@/pages/LeftMenu.jsx";
import {Outlet} from "react-router-dom";

const {Header, Footer, Sider, Content} = Layout;

const headerStyle = {
    textAlign: 'center',
    color: '#fff',
    height: '64px',
    paddingInline: 48,
    lineHeight: '64px',
    backgroundColor: '#b7eb8f',
};
const contentStyle = {
    textAlign: 'center',
    flex: 1, // Allow content to take remaining space
    lineHeight: '120px',
    color: '#000',
    backgroundColor: '#e6fffb',
};
const leftSiderStyle = {
    textAlign: 'center',
    lineHeight: '100%',
    color: '#fff',
    backgroundColor: '#eaff8f',
    flex: 1
};
const rightSiderStyle = {
    textAlign: 'center',
    lineHeight: '100%',
    color: '#fff',
    backgroundColor: '#eaff8f',
    flex: 1
};
const footerStyle = {
    textAlign: 'center',
    color: '#fff',
    backgroundColor: '#adc6ff',
};
const outerLayoutStyle = {
    height: '100vh',
    maxWidth: '100%',
};
const innerLayoutStyle={
    height: '100vn',
    maxWidth: '95%',
}

const DashBoardLayout = () => (
    <Layout style={outerLayoutStyle}>
        <Layout style={innerLayoutStyle}>
            <Header style={headerStyle}>Header</Header>
            <Layout>
                <Sider width="15%" style={leftSiderStyle}>
                    <LeftMenu/>
                </Sider>
                <Content style={contentStyle}>
                    <Outlet/>
                </Content>
            </Layout>
            <Footer style={footerStyle}>Footer</Footer>
        </Layout>
        <Sider width="5%" style={rightSiderStyle}>
            Sider
        </Sider>
    </Layout>
);

export default DashBoardLayout;
