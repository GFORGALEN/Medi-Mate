import React, { useEffect, useState, useCallback } from 'react';
import { DndProvider, useDrag, useDrop } from 'react-dnd';
import { HTML5Backend } from 'react-dnd-html5-backend';
import Order from './Order';
import { useSelector } from "react-redux";
import { Modal } from 'antd';

const initialOrders = [
  { id: '3392b041-d673-48d9-a2b0-1e3b2e376704', status: 'receive' },
];

const statuses = ['receive', 'picking', 'finish'];

const DraggableOrderItem = React.memo(({ order, onStatusChange }) => {
  const [{ isDragging }, drag] = useDrag(() => ({
    type: 'ORDER',
    item: { id: order.id, status: order.status },
    collect: (monitor) => ({
      isDragging: !!monitor.isDragging(),
    }),
  }), [order.id, order.status]);

  const handleCheckClick = useCallback(() => {
    const currentIndex = statuses.indexOf(order.status);
    const nextStatus = statuses[currentIndex + 1];
    if (nextStatus) {
      onStatusChange(order.id, nextStatus);
    }
  }, [order, onStatusChange]);

  return (
      <li
          ref={drag}
          className={`bg-blue-100 p-4 mb-2 rounded shadow flex items-center justify-between ${
              isDragging ? 'opacity-50' : ''
          }`}
      >
        <span>{order.id}</span>
        <Order order={order} onStatusChange={handleCheckClick} />
      </li>
  );
});

const StatusColumn = React.memo(({ status, orders, onStatusChange }) => {
  const [, drop] = useDrop(() => ({
    accept: 'ORDER',
    drop: (item) => onStatusChange(item.id, status),
  }), [status, onStatusChange]);

  return (
      <div className="flex-1" ref={drop}>
        <h2 className="text-xl font-semibold mb-4 capitalize">{status}</h2>
        <ul className="bg-white rounded-lg shadow p-4 min-h-[500px]">
          {orders.map((order) => (
              <DraggableOrderItem key={order.id} order={order} onStatusChange={onStatusChange} />
          ))}
        </ul>
      </div>
  );
});

const OrderHistory = ({ orders }) => (
    <div className="mt-8">
      <h2 className="text-2xl font-bold mb-4">Order History</h2>
      <ul className="bg-white rounded-lg shadow p-4">
        {orders.map((order) => (
            <li key={order.id} className="mb-2">
              Order ID: {order.id} - Status: {order.status}
            </li>
        ))}
      </ul>
    </div>
);

const OrderPage = () => {
  const [orders, setOrders] = useState(initialOrders);
  const [confirmModal, setConfirmModal] = useState({ visible: false, orderId: null, newStatus: null });
  const dataFromRedux = useSelector(state => state.message);

  const getOrdersForStatus = useCallback((status) =>
          orders.filter(order => order.status === status),
      [orders]);

  useEffect(() => {
    if (!dataFromRedux.orderId) return;
    setOrders(prevOrders => {
      const newOrders = [...prevOrders];
      if (!newOrders.some(order => order.id === dataFromRedux.orderId)) {
        newOrders.push({ id: dataFromRedux.orderId, status: 'receive' });
      }
      return newOrders;
    });
  }, [dataFromRedux]);

  const handleStatusChange = useCallback((orderId, newStatus) => {
    const order = orders.find(o => o.id === orderId);
    if (order && order.status !== newStatus) {
      setConfirmModal({ visible: true, orderId, newStatus });
    }
  }, [orders]);

  const confirmStatusChange = useCallback(() => {
    setOrders(prevOrders => prevOrders.map(order => {
      if (order.id === confirmModal.orderId) {
        return { ...order, status: confirmModal.newStatus };
      }
      return order;
    }));
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
            {statuses.map((status) => (
                <StatusColumn
                    key={status}
                    status={status}
                    orders={getOrdersForStatus(status)}
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
            <p>Are you sure you want to change the status of order {confirmModal.orderId} to {confirmModal.newStatus}?</p>
          </Modal>
        </div>
      </DndProvider>
  );
};

export default OrderPage;