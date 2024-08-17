import { Layout } from 'antd';
import LeftMenu from "../menu/LeftMenu.jsx";
const { Header, Footer, Sider, Content } = Layout;

const headerStyle = {
    textAlign: 'center',
    color: '#fff',
    height: 64,
    paddingInline: 48,
    lineHeight: '64px',
    backgroundColor: '#b7eb8f',
};
const contentStyle = {
    textAlign: 'center',
    flex: 1, // Allow content to take remaining space
    lineHeight: '120px',
    color: '#fff',
    backgroundColor: '#e6fffb',
};
const siderStyle = {
    textAlign: 'center',
    lineHeight: '100%',
    color: '#fff',
    backgroundColor: '#eaff8f',
    height: '100vh', // Ensure the Sider spans the full height of the screen
};
const footerStyle = {
    textAlign: 'center',
    color: '#fff',
    backgroundColor: '#adc6ff',
};
const layoutStyle = {
    height: '100vh', // Full height of the viewport
    maxWidth: '100%',
};

const App = () => (
    <Layout style={layoutStyle}>
        <Sider width="18%" style={siderStyle}>
            <LeftMenu/>
        </Sider>
        <Layout>
            <Header style={headerStyle}>Header</Header>
            <Content style={contentStyle}>Content</Content>
            <Footer style={footerStyle}>Footer</Footer>
        </Layout>
    </Layout>
);

export default App;
