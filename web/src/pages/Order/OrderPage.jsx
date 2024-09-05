import React, { useState } from 'react';
import Order from './Order';


const initialOrders = [
    { id: '1', status: 'receive', content: 'Order #001' },
    { id: '2', status: 'receive', content: 'Order #002' },
    { id: '3', status: 'receive', content: 'Order #003' },
    { id: '4', status: 'receive', content: 'Order #004' },
    { id: '4', status: 'receive', content: 'Order #004' },

];

const statuses = ['receive', 'picking', 'finish']; // The order of statuses matters

const OrderPage = () => {
    const [orders, setOrders] = useState(initialOrders);
    
    const getOrdersForStatus = (status) => orders.filter(order => order.status === status);

    return (
        <div className="min-h-screen bg-gray-100 p-8">
            <h1 className="text-3xl font-bold mb-8 text-center">Order Management</h1>
            <div className="flex justify-between space-x-4">
                {statuses.map((status, statusIndex) => (
                    <div key={status} className="flex-1">
                        <h2 className="text-xl font-semibold mb-4 capitalize">{status}</h2>
                        <ul className="bg-white rounded-lg shadow p-4 min-h-[500px]">
                            {getOrdersForStatus(status).map((order) => (
                                <li key={order.id} className="bg-blue-100 p-4 mb-2 rounded shadow flex items-center justify-between">
                                    <span>{order.content}</span>
                                    <Order />
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