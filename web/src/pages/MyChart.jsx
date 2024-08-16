import React from 'react';
import { Typography } from 'antd';
import MyChart from "@/MyChart.jsx";

const { Title } = Typography;

const Dashboard = () => {
    return (
        <div>
            <Title level={2}>MyChart</Title>
            <p>Welcome to your MyChart!</p>
        </div>
    );
};

export default Dashboard;