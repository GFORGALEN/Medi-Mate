import React, { useState } from 'react';
import { Button, Modal } from 'antd';

const Order = ({ order, onStatusChange }) => {
    const [open, setOpen] = useState(false);

    const showModal = () => setOpen(true);
    const handleOk = () => {
        setOpen(false);
        onStatusChange(order.orderId, order.status + 1);
    };
    const handleCancel = () => setOpen(false);

    const buttonText = order.status === 0 ? 'Start Picking' : 'Finish Order';

    return (
        <>
            <Button onClick={showModal} className="bg-blue-500 text-white">Check</Button>
            <Modal
                open={open}
                title="Order Details"
                onOk={handleOk}
                onCancel={handleCancel}
                okText={buttonText}
            >
                <p>Order ID: {order.orderId}</p>
                <p>Current Status: {['receive', 'picking', 'finish'][order.status]}</p>
            </Modal>
        </>
    );
};

export default Order;
//这个是你原来的order.jsx文件 几乎没有变化