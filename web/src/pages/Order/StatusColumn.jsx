import React from 'react';
import { useDrop } from 'react-dnd';
import DraggableOrderItem from './DraggableOrderItem';

const StatusColumn = React.memo(({ status, orders, onStatusChange, onViewDetails, onDeleteOrder }) => {
    const [, drop] = useDrop(() => ({
        accept: 'ORDER',
        drop: (item) => onStatusChange(item.id, ['receive', 'picking', 'finish'].indexOf(status)),
    }), [status, onStatusChange]);

    return (
        <div className="flex-1" ref={drop}>
            <h2 className="text-xl font-semibold mb-4 capitalize">{status}</h2>
            <ul className="bg-white rounded-lg shadow p-4 min-h-[500px]">
                {orders.map((order) => (
                    <DraggableOrderItem
                        key={order.orderId}
                        order={order}
                        onStatusChange={onStatusChange}
                        onViewDetails={onViewDetails}
                        onDeleteOrder={onDeleteOrder}
                    />
                ))}
            </ul>
        </div>
    );
});

export default StatusColumn;
//这个是分离出来的用来控制每个按键功能的