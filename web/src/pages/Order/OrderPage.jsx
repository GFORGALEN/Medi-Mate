import { useState } from 'react';
import Order from './Order';


const initialOrders = [
    { id: '1', status: 'receive' },
    { id: '2', status: 'receive' },
    { id: '3', status: 'receive' },
    { id: '4', status: 'receive' },
    { id: '5', status: 'receive' },
  ];
  
  const statuses = ['receive', 'picking', 'finish'];
  
  const OrderPage = () => {
    const [orders, setOrders] = useState(initialOrders);
  
    const getOrdersForStatus = (status) => orders.filter(order => order.status === status);
  
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
                    <span>Order {order.id}</span>
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