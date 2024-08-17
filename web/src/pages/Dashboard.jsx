import React from 'react';
import { Typography } from 'antd';

const { Title } = Typography;

const Dashboard = () => {
    return (
        <div>
            <Title level={2}>Dashboard</Title>
            <p>Welcome to your dashboard!</p>
        </div>
    );
};

export default Dashboard;