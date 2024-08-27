import React from 'react';
import { Button } from 'antd';
import { LogoutOutlined } from '@ant-design/icons';
import { useNavigate } from 'react-router-dom';


const HeaderLayout = () => {

    const navigate = useNavigate();

    const handleLogout = () => {
        console.log('User logged out');
        navigate('/login');
    };

    return (
        <div className="flex items-center justify-between w-full px-4">
                <h1 className="text-2xl md:text-3xl lg:text-4xl font-semibold text-gray-800 tracking-wide font-poppins">
                    <span className="text-blue-600 font-bold">
                        Medimate
                    </span>
                    {' '}Management System
                </h1>
            <Button 
                type="primary" 
                icon={<LogoutOutlined />} 
                onClick={handleLogout} 
                danger
                className="ml-4"
            >
                Logout
            </Button>
        </div>
    );
};

export default HeaderLayout;