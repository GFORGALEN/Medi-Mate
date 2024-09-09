import React, { useState, useEffect } from 'react';
import { Modal, Spin, Table, Button } from 'antd';
import { pharmacyOrderAPI } from '@/api/orderApi.jsx';
import GenerateReceiptButton from './GenerateReceiptButton';

const OrderDetailModal = ({ orderId, visible, onClose }) => {
    const [orderDetails, setOrderDetails] = useState(null);
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        if (visible && orderId) {
            setLoading(true);
            pharmacyOrderAPI.getOrderDetail(orderId)
                .then(response => {
                    if (response.code === 1 && Array.isArray(response.data)) {
                        setOrderDetails({
                            ...response.data[0],
                            createdAt: new Date().toISOString(), // 添加订单生成时间
                            items: response.data
                        });
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
            footer={[
                <GenerateReceiptButton key="receipt" order={orderDetails} />,
                <Button key="close" onClick={onClose}>
                    Close
                </Button>
            ]}
            width={800}
        >
            {loading ? (
                <Spin size="large" />
            ) : orderDetails ? (
                <>
                    <p>Order Date: {new Date(orderDetails.createdAt).toLocaleString()}</p>
                    <Table
                        dataSource={orderDetails.items}
                        columns={columns}
                        rowKey="productId"
                        pagination={false}
                    />
                </>
            ) : (
                <p>No details available</p>
            )}
        </Modal>
    );
};

export default OrderDetailModal;