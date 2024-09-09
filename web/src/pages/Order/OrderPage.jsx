import React, { useEffect, useState, useCallback, useMemo } from 'react';
import { DndProvider } from 'react-dnd';
import { HTML5Backend } from 'react-dnd-html5-backend';
import { useSelector } from "react-redux";
import { pharmacyOrderAPI } from '@/api/orderApi.jsx';
import StatusColumn from './StatusColumn';
import OrderHistory from './OrderHistory';
import OrderDetailModal from './OrderDetailModal';

const statuses = ['receive', 'picking', 'finish'];

const OrderPage = () => {
  const [orders, setOrders] = useState([]);
  const [detailModalVisible, setDetailModalVisible] = useState(false);
  const [selectedOrderId, setSelectedOrderId] = useState(null);
  const dataFromRedux = useSelector(state => state.message);

  const addTimestampToOrder = (order) => ({
    ...order,
    createdAt: order.createdAt || new Date().toISOString()
  });
  useEffect(() => {
    pharmacyOrderAPI.getOrderDetails(1).then((response) => {
      if (response.code === 1 && Array.isArray(response.data)) {
        setOrders(response.data);
      }
    });
  }, []);
  const ordersByStatus = useMemo(() => {
    return statuses.reduce((acc, status, index) => {
      acc[status] = orders
          .filter(order => order.status === index)
          .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt)); // 按创建时间降序排序
      return acc;
    }, {});
  }, [orders]);

  useEffect(() => {
    pharmacyOrderAPI.getOrderDetails(1).then((response) => {
      if (response.code === 1 && Array.isArray(response.data)) {
        const ordersWithTimestamp = response.data.map(addTimestampToOrder);
        setOrders(ordersWithTimestamp);
      }
    });
  }, []);

  useEffect(() => {
    if (!dataFromRedux.orderId) return;
    setOrders(prevOrders => {
      if (!prevOrders.some(order => order.orderId === dataFromRedux.orderId)) {
        const newOrder = addTimestampToOrder({
          orderId: dataFromRedux.orderId,
          status: 0,
          amount: 0,
          userId: 'string',
          pharmacyId: 1,
        });
        return [...prevOrders, newOrder];
      }
      return prevOrders;
    });
  }, [dataFromRedux]);

  const handleDeleteOrder = useCallback((orderId) => {
    setOrders(prevOrders => prevOrders.filter(order => order.orderId !== orderId));
    // 如果需要，这里可以添加调用后端 API 删除订单的逻辑
  }, []);

  const handleStatusChange = useCallback((orderId, newStatus) => {
    setOrders(prevOrders => prevOrders.map(order =>
        order.orderId === orderId ? { ...order, status: newStatus } : order
    ));
  }, []);

  const handleViewDetails = useCallback((orderId) => {
    setSelectedOrderId(orderId);
    setDetailModalVisible(true);
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
                    orders={ordersByStatus[status]}
                    onStatusChange={handleStatusChange}
                    onViewDetails={handleViewDetails}
                    onDeleteOrder={handleDeleteOrder}
                />
            ))}
          </div>
          <OrderHistory orders={orders} onDeleteOrder={handleDeleteOrder} />
          <OrderDetailModal
              orderId={selectedOrderId}
              visible={detailModalVisible}
              onClose={() => setDetailModalVisible(false)}
          />
        </div>
      </DndProvider>
  );
};

export default OrderPage;
//这个是主页面用来展示其他组件功能的