import React from 'react';
import { Layout, Button } from 'antd';
import { useNavigate } from 'react-router-dom';

const { Header } = Layout;

const HeaderComponent = () => {
    const navigate = useNavigate();

    const handleLogout = () => {

        navigate('/login');
    };

    return (
        <Header style={{ background: '#fff', padding: 0, display: 'flex', justifyContent: 'flex-end', alignItems: 'center' }}>
            <Button onClick={handleLogout} style={{ marginRight: 20 }}>
                Logout
            </Button>
        </Header>
    );
};

export default HeaderComponent;