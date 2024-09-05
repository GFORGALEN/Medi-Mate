import React from 'react';
import { Menu } from 'antd';
import { DesktopOutlined, PieChartOutlined, InboxOutlined, MedicineBoxOutlined } from '@ant-design/icons';
import { useNavigate, useLocation } from "react-router-dom";
import logo from '../../assets/images/image.png';


const items = [
  {
    key: '/analytics',
    icon: <PieChartOutlined />,
    label: 'Analytics',
  },
  {
    key: '/products',
    icon: <DesktopOutlined />,
    label: 'Products',
  },
  {
    key: '/pharmacies',
    icon: <InboxOutlined />,
    label: 'Pharmacies',
  },
  {
    key: '/OrderPage',
    icon: <MedicineBoxOutlined />,
    label: 'Order',
  },
];

const LeftMenuLayout = ({ collapsed }) => {
  const navigate = useNavigate();
  const location = useLocation();

  const handleMenuClick = (e) => {
    navigate(e.key, { replace: true });
  };

  return (
    <div className="flex flex-col h-full">
      <div className="logo p-4">
        <img
          src={logo}
          alt="Company Logo"
          className={`w-full ${collapsed ? 'h-8' : 'h-16'} object-contain transition-all duration-300`}
        />
      </div>
      <Menu
        selectedKeys={[location.pathname]}
        mode="inline"
        items={items}
        onClick={handleMenuClick}
      />
    </div>
  );
};

export default LeftMenuLayout;