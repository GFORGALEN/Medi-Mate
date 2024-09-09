
// bin，这个组件是用来定义每个模块的 就是order id amount wait 那些每个订单的单独模块
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

const DraggableOrderItem = React.memo(({ order, onStatusChange, onViewDetails,onDeleteOrder}) => {
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

        // 初始更新
        updateWaitTime();

        // 设置定时器，每秒更新一次
        const timer = setInterval(updateWaitTime, 1000);

        // 清理函数
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
            className={`bg-blue-100 p-4 mb-2 rounded shadow flex items-center justify-between ${
                isDragging ? 'opacity-50' : ''
            }`}
        >
            <span>Order ID: {order.orderId}</span>
            <span>Amount: ${order.amount}</span>
            <Tag color={waitTimeColor}>Wait: {waitTime}</Tag>
            <Order order={order} onStatusChange={onStatusChange}/>
            <Button onClick={() => onViewDetails(order.orderId)} className="bg-blue-500 text-white mr-2">
                View Details
            </Button>
            <Button onClick={() => onDeleteOrder(order.orderId)} type="danger" className="bg-blue-500 text-white mr-2">
                Delete
            </Button>
        </li>
    );
});

export default DraggableOrderItem;