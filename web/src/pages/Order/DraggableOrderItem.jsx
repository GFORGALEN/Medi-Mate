import React, { useState, useEffect } from 'react';
import { useDrag } from 'react-dnd';
import { Button, Tag } from 'antd';
import Order from './Order';

const calculateWaitTime = (createdAt) => {
    const now = new Date();
    const created = new Date(createdAt);
    const diffInSeconds = Math.floor((now - created) / 1000);

    if (diffInSeconds < 60) {
        return `${diffInSeconds}s`;
    } else if (diffInSeconds < 3600) {
        const minutes = Math.floor(diffInSeconds / 60);
        const seconds = diffInSeconds % 60;
        return `${minutes}m ${seconds}s`;
    } else {
        const hours = Math.floor(diffInSeconds / 3600);
        const minutes = Math.floor((diffInSeconds % 3600) / 60);
        const seconds = diffInSeconds % 60;
        return `${hours}h ${minutes}m ${seconds}s`;
    }
};

const getWaitTimeColor = (seconds) => {
    if (seconds < 180) return 'green';
    if (seconds < 360) return 'orange';
    return 'red';
};

const DraggableOrderItem = React.memo(({ order, onStatusChange, onViewDetails, onDeleteOrder }) => {
    const [waitTime, setWaitTime] = useState(calculateWaitTime(order.createdAt));
    const [waitTimeInSeconds, setWaitTimeInSeconds] = useState(0);

    useEffect(() => {
        const updateWaitTime = () => {
            const now = new Date();
            const created = new Date(order.createdAt);
            const diffInSeconds = Math.floor((now - created) / 1000);
            setWaitTimeInSeconds(diffInSeconds);
            setWaitTime(calculateWaitTime(order.createdAt));
        };

        // Initial update
        updateWaitTime();

        // Update every second
        const timer = setInterval(updateWaitTime, 1000);

        // Cleanup
        return () => clearInterval(timer);
    }, [order.createdAt]);

    const [{ isDragging }, drag] = useDrag(() => ({
        type: 'ORDER',
        item: { id: order.orderId, status: order.status },
        collect: (monitor) => ({
            isDragging: !!monitor.isDragging(),
        }),
    }), [order.orderId, order.status]);

    const waitTimeColor = getWaitTimeColor(waitTimeInSeconds);

    return (
        <li
            ref={drag}
            className={`bg-blue-100 p-4 mb-4 rounded shadow flex flex-col sm:flex-row items-center justify-between gap-4 sm:gap-0 ${
                isDragging ? 'opacity-50' : ''
            }`}
        >
            <div className="flex flex-col sm:flex-row sm:items-center sm:space-x-6 flex-grow">
                <span className="text-sm sm:text-base">Order ID: {order.orderId}</span>
                <span className="text-sm sm:text-base">User ID: {order.userId}</span>
                <span className="text-sm sm:text-base">Amount: ${order.amount}</span>
            </div>
            <div className="flex items-center space-x-4">
                <Tag color={waitTimeColor} className="text-xs sm:text-sm">
                    Wait: {waitTime}
                </Tag>
                <Order order={order} onStatusChange={onStatusChange} />
                <Button onClick={() => onViewDetails(order.orderId)} className="bg-blue-500 text-white text-xs sm:text-sm">
                    View Details
                </Button>
                <Button onClick={() => onDeleteOrder(order.orderId)} type="danger" className="bg-red-500 text-white text-xs sm:text-sm">
                    Delete
                </Button>
            </div>
        </li>
    );
});

export default DraggableOrderItem;
//这个是每一个订单的功能以及样式 展示出了order的id userid amount等信息