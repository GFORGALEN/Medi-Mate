import React, { useEffect, useState } from 'react';
import Order from './Order';
import { useSelector } from "react-redux";

const initialOrders = [
  { id: '3392b041-d673-48d9-a2b0-1e3b2e376704', status: 'receive' },
];

const statuses = ['receive', 'picking', 'finish'];

const OrderPage = () => {
  const [orders, setOrders] = useState(initialOrders);

  const dataFromRedux = useSelector(state => state.message);
  const getOrdersForStatus = (status) => orders.filter(order => order.status === status);
  useEffect(() => {
    if (!dataFromRedux.orderId) return;
    setOrders(prevOrders => [...prevOrders, { id: dataFromRedux.orderId, status: 'receive' }]);
  }, [dataFromRedux]);



  const handleStatusChange = (orderId) => {
    setOrders(prevOrders => prevOrders.map(order => {
      if (order.id === orderId) {
        const currentStatusIndex = statuses.indexOf(order.status);
        const nextStatus = statuses[currentStatusIndex + 1] || order.status;
        return { ...order, status: nextStatus };
      }
      return order;
    }));
  };

  return (
    <div className="min-h-screen bg-gray-100 p-8">
      <h1 className="text-3xl font-bold mb-8 text-center">Order Management</h1>
      <div className="flex justify-between space-x-4">
        {statuses.map((status) => (
          <div key={status} className="flex-1">
            <h2 className="text-xl font-semibold mb-4 capitalize">{status}</h2>
            <ul className="bg-white rounded-lg shadow p-4 min-h-[500px]">
              {getOrdersForStatus(status).map((order) => (
                <li key={order.id} className="bg-blue-100 p-4 mb-2 rounded shadow flex items-center justify-between">
                  <span>{order.id}</span>
                  <Order order={order} onStatusChange={handleStatusChange} />
                </li>
              ))}
            </ul>
          </div>
        ))}
      </div>
    </div>
  );
};

export default OrderPage;