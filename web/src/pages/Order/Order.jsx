import React, { useState } from 'react';
import { Button, Modal } from 'antd';
const Order = ({ order, onStatusChange }) => {
  const [open, setOpen] = useState(false);

  const showModal = () => {
    setOpen(true);
  };

  const handleOk = () => {
    setOpen(false);
    onStatusChange(order.id);
  };

  const handleCancel = () => {
    setOpen(false);
  };

  const buttonText = order.status === 'receive' ? 'Start Picking' : 'Finish Order';

  return (
    <>
      <Button onClick={showModal}>
        Check
      </Button>
      <Modal
        open={open}
        title="Order Details"
        onOk={handleOk}
        onCancel={handleCancel}
        okText={buttonText}
      >
        <p>Order ID: {order.id}</p>
        <p>Current Status: {order.status}</p>
      </Modal>
    </>
  );
};
export default Order;