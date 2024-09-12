import React, { useState } from 'react';
import { Button, Modal } from 'antd';

const Order = ({ order, onStatusChange }) => {
    const [open, setOpen] = useState(false);

    const showModal = () => setOpen(true);
    const handleOk = () => {
        setOpen(false);
        const nextStatus = getNextStatus(order.status);
        if (nextStatus) {
            onStatusChange(order.orderId, nextStatus);
        }
    };
    const handleCancel = () => setOpen(false);

    const getNextStatus = (currentStatus) => {
        switch (currentStatus) {
            case 1: return 2; // from "Finish Order" to "Start Picking"
            case 2: return 3; // from "Start Picking" to "Finish Picking"
            case 3: return 4; // from "Finish Picking" to "Cancel Order" (if needed)
            default: return null;
        }
    };

    const getButtonText = (status) => {
        switch (status) {
            case 1: return 'Start Picking';
            case 2: return 'Finish Picking';
            case 3: return 'Complete Order';
            case 4: return 'Order Cancelled';
            default: return 'Check';
        }
    };

    const buttonText = getButtonText(order.status);
    const canChangeStatus = order.status < 4;

    return (
        <>
            <Button onClick={showModal} className="bg-blue-500 text-white" disabled={!canChangeStatus}>
                {buttonText}
            </Button>
            <Modal
                open={open}
                title="Order Details"
                onOk={handleOk}
                onCancel={handleCancel}
                okText={buttonText}
                okButtonProps={{ disabled: !canChangeStatus }}
            >
                <p>Order ID: {order.orderId}</p>
                <p>Current Status: {['Unknown', 'Finish Order', 'Start Picking', 'Finish Picking', 'Cancel Order'][order.status]}</p>
                <p>Amount: ${order.amount}</p>
                <p>Updated At: {new Date(order.updatedAt).toLocaleString()}</p>
                {order.status === 4 && order.cancelReason && (
                    <p>Cancel Reason: {order.cancelReason}</p>
                )}
            </Modal>
        </>
    );
};

export default Order;