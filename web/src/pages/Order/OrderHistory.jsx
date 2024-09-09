import React from 'react';
import { Button } from 'antd';

const statuses = ['receive', 'picking', 'finish'];

const OrderHistory = React.memo(({ orders, onDeleteOrder }) => (
    <div className="mt-8">
        <h2 className="text-2xl font-bold mb-4">Order History</h2>
        <ul className="bg-white rounded-lg shadow p-4">
            {orders.map((order) => (
                <li key={order.orderId} className="mb-2 flex justify-between items-center">
          <span>
            Order ID: {order.orderId} - Amount: ${order.amount} - Status: {statuses[order.status]}
          </span>
                    <Button onClick={() => onDeleteOrder(order.orderId)} type="danger" size="small">
                        Delete
                    </Button>
                </li>
            ))}
        </ul>
    </div>
));

export default OrderHistory;
//这个是你新建的orderhistory.jsx文件 主要展示订单的历史