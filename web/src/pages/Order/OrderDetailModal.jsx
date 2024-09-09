import React, { useState, useEffect } from 'react';
import { Modal, Spin, Table } from 'antd';
import { pharmacyOrderAPI } from '@/api/orderApi.jsx';

const OrderDetailModal = ({ orderId, visible, onClose }) => {
    const [orderDetails, setOrderDetails] = useState(null);
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        if (visible && orderId) {
            setLoading(true);
            pharmacyOrderAPI.getOrderDetail(orderId)
                .then(response => {
                    if (response.code === 1 && Array.isArray(response.data)) {
                        setOrderDetails(response.data);
                    }
                })
                .catch(error => console.error('Error fetching order details:', error))
                .finally(() => setLoading(false));
        }
    }, [orderId, visible]);

    const columns = [
        { title: 'Product Name', dataIndex: 'productName', key: 'productName' },
        { title: 'Quantity', dataIndex: 'quantity', key: 'quantity' },
        { title: 'Price', dataIndex: 'price', key: 'price', render: price => `$${price.toFixed(2)}` },
        { title: 'Manufacturer', dataIndex: 'manufacturerName', key: 'manufacturerName' },
    ];

    return (
        <Modal
            title={`Order Details - ${orderId}`}
            open={visible}
            onCancel={onClose}
            footer={null}
            width={800}
        >
            {loading ? (
                <Spin size="large" />
            ) : orderDetails ? (
                <Table
                    dataSource={orderDetails}
                    columns={columns}
                    rowKey="productId"
                    pagination={false}
                />
            ) : (
                <p>No details available</p>
            )}
        </Modal>
    );
};

export default OrderDetailModal;
//这个是点击view details后弹出的modal，显示订单详情