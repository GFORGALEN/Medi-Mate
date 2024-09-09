import React, { useEffect, useState, useCallback, useMemo } from 'react';
import { DndProvider, useDrag, useDrop } from 'react-dnd';
import { HTML5Backend } from 'react-dnd-html5-backend';
import Order from './Order';
import { useSelector } from "react-redux";
import { Modal } from 'antd';
import { pharmacyOrderAPI } from '@/api/orderApi.jsx';

const statuses = ['receive', 'picking', 'finish'];

const DraggableOrderItem = React.memo(({ order, onStatusChange }) => {
  const [{ isDragging }, drag] = useDrag(() => ({
    type: 'ORDER',
    item: { id: order.orderId, status: order.status },
    collect: (monitor) => ({
      isDragging: !!monitor.isDragging(),
    }),
  }), [order.orderId, order.status]);

  const handleCheckClick = useCallback(() => {
    const currentIndex = order.status;
    const nextStatus = currentIndex + 1;
    if (nextStatus < statuses.length) {
      onStatusChange(order.orderId, nextStatus);
    }
  }, [order, onStatusChange]);

  return (
    <li
      ref={drag}
      className={`bg-blue-100 p-4 mb-2 rounded shadow flex items-center justify-between ${
        isDragging ? 'opacity-50' : ''
      }`}
    >
      <span>Order ID: {order.orderId}</span>
      <span>Amount: ${order.amount}</span>
      <Order order={order} onStatusChange={handleCheckClick} />
    </li>
  );
});

const StatusColumn = React.memo(({ status, orders, onStatusChange }) => {
  const [, drop] = useDrop(() => ({
    accept: 'ORDER',
    drop: (item) => onStatusChange(item.id, statuses.indexOf(status)),
  }), [status, onStatusChange]);

  return (
    <div className="flex-1" ref={drop}>
      <h2 className="text-xl font-semibold mb-4 capitalize">{status}</h2>
      <ul className="bg-white rounded-lg shadow p-4 min-h-[500px]">
        {orders.map((order) => (
          <DraggableOrderItem key={order.orderId} order={order} onStatusChange={onStatusChange} />
        ))}
      </ul>
    </div>
  );
});

const OrderHistory = React.memo(({ orders }) => (
  <div className="mt-8">
    <h2 className="text-2xl font-bold mb-4">Order History</h2>
    <ul className="bg-white rounded-lg shadow p-4">
      {orders.map((order) => (
        <li key={order.orderId} className="mb-2">
          Order ID: {order.orderId} - Amount: ${order.amount} - Status: {statuses[order.status]}
        </li>
      ))}
    </ul>
  </div>
));

const OrderPage = () => {
  const [orders, setOrders] = useState([]);
  const [confirmModal, setConfirmModal] = useState({ visible: false, orderId: null, newStatus: null });
  const dataFromRedux = useSelector(state => state.message);

  const ordersByStatus = useMemo(() => {
    return statuses.reduce((acc, status, index) => {
      acc[status] = orders.filter(order => order.status === index);
      return acc;
    }, {});
  }, [orders]);

  useEffect(() => {
    pharmacyOrderAPI.getOrderDetails(1).then((response) => {
      if (response.code === 1 && Array.isArray(response.data)) {
        setOrders(response.data);
      }
    });
  }, []);

  useEffect(() => {
    if (!dataFromRedux.orderId) return;
    setOrders(prevOrders => {
      if (!prevOrders.some(order => order.orderId === dataFromRedux.orderId)) {
        return [...prevOrders, { 
          orderId: dataFromRedux.orderId, 
          status: 0,
          amount: 0,
          userId: 'string',
          pharmacyId: 1
        }];
      }
      return prevOrders;
    });
  }, [dataFromRedux]);

  const handleStatusChange = useCallback((orderId, newStatus) => {
    const order = orders.find(o => o.orderId === orderId);
    if (order && order.status !== newStatus) {
      setConfirmModal({ visible: true, orderId, newStatus });
    }
  }, [orders]);

  const confirmStatusChange = useCallback(() => {
    setOrders(prevOrders => prevOrders.map(order => 
      order.orderId === confirmModal.orderId 
        ? { ...order, status: confirmModal.newStatus } 
        : order
    ));
    setConfirmModal({ visible: false, orderId: null, newStatus: null });
  }, [confirmModal]);

  const cancelStatusChange = useCallback(() => {
    setConfirmModal({ visible: false, orderId: null, newStatus: null });
  }, []);

  return (
    <DndProvider backend={HTML5Backend}>
      <div className="min-h-screen bg-gray-100 p-8">
        <h1 className="text-3xl font-bold mb-8 text-center">Order Management</h1>
        <div className="flex justify-between space-x-4">
          {statuses.map((status, index) => (
            <StatusColumn
              key={status}
              status={status}
              orders={ordersByStatus[status]}
              onStatusChange={handleStatusChange}
            />
          ))}
        </div>
        <OrderHistory orders={orders} />
        <Modal
          title="Confirm Status Change"
          open={confirmModal.visible}
          onOk={confirmStatusChange}
          onCancel={cancelStatusChange}
        >
          <p>Are you sure you want to change the status of order {confirmModal.orderId} to {statuses[confirmModal.newStatus]}?</p>
        </Modal>
      </div>
    </DndProvider>
  );
};

export default OrderPage;