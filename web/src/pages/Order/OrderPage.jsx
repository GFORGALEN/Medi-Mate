import { pharmacyOrderAPI } from "@/api/orderApi.jsx";
import { useEffect, useState, useRef } from "react";
import { Modal, Input, message, Table, Button, Select } from "antd";
import { useSelector } from "react-redux";
import generateReceipt from './PDFReceipt';
import generateReport from './PDFReport';

const { Option } = Select;
const OrderPage = () => {
    const [orders, setOrders] = useState({
        finishOrder: [],
        startPicking: [],
        finishPicking: []
    });
    const [currentPharmacy, setCurrentPharmacy] = useState(1);
    const [isModalVisible, setIsModalVisible] = useState(false);
    const [cancelReason, setCancelReason] = useState("");
    const [orderToCancel, setOrderToCancel] = useState(null);
    const [isConfirmModalVisible, setIsConfirmModalVisible] = useState(false);
    const [orderToUpdate, setOrderToUpdate] = useState(null);
    const [isEmailModalVisible, setIsEmailModalVisible] = useState(false);
    const [timers, setTimers] = useState({});
    const [isDetailsModalVisible, setIsDetailsModalVisible] = useState(false);
    const [orderDetails, setOrderDetails] = useState([]);
    const [totalAmount, setTotalAmount] = useState(0);

    const currentOrderId = useSelector(state => state.message.orderId);
    const timerRef = useRef();

    useEffect(() => {
        fetchOrders();
        return () => clearInterval(timerRef.current);
    }, [currentPharmacy,currentOrderId]);

    useEffect(() => {
        timerRef.current = setInterval(() => {
            setTimers(prevTimers => {
                const updatedTimers = { ...prevTimers };
                Object.keys(updatedTimers).forEach(orderId => {
                    updatedTimers[orderId] += 1;
                });
                return updatedTimers;
            });
        }, 1000);

        return () => clearInterval(timerRef.current);
    }, []);

    const fetchOrders = () => {
        pharmacyOrderAPI.getOrderDetails(currentPharmacy).then((response) => {
            if (response.code === 1 && Array.isArray(response.data)) {
                const sortedOrders = {
                    finishOrder: response.data.filter(order => order.status === 1),
                    startPicking: response.data.filter(order => order.status === 2),
                    finishPicking: response.data.filter(order => order.status === 3)
                };
                Object.keys(sortedOrders).forEach(key => {
                    sortedOrders[key] = sortedOrders[key].map(order => ({
                        ...order,
                        username: order.username || 'Unknown' // 如果 API 没有返回 username，使用 'Unknown'
                    }));
                });
                setOrders(sortedOrders);

                const newTimers = {};
                [...sortedOrders.finishOrder, ...sortedOrders.startPicking].forEach(order => {
                    if (!timers[order.orderId]) {
                        newTimers[order.orderId] = 0;
                    }
                });
                setTimers(prevTimers => ({ ...prevTimers, ...newTimers }));
            }
        });
    };
    const handlePharmacyChange = (value) => {
        setCurrentPharmacy(value);
    }
    const fetchOrderDetails = (orderId) => {
        pharmacyOrderAPI.getOrderDetail(orderId).then((response) => {
            if (response.code === 1 && Array.isArray(response.data)) {
                const orderDetailsWithUsername = response.data.map(item => ({
                    ...item,
                    username: item.username || 'UnKnown' // 确保每个项目都有 username
                }));
                setOrderDetails(orderDetailsWithUsername);
                const total = orderDetailsWithUsername.reduce((sum, item) => sum + item.price * item.quantity, 0);
                setTotalAmount(total);
                setIsDetailsModalVisible(true);
            } else {
                message.error("Failed to fetch order details");
            }
        }).catch((error) => {
            console.error("Error fetching order details:", error);
            message.error("Failed to fetch order details");
        });
    };

    const convertToNZTime = (dateString) => {
        const date = new Date(dateString);
        return date.toLocaleString("en-NZ", { timeZone: "Pacific/Auckland", hour12: false });
    };


    const showConfirmModal = (order, newStatus) => {
        setOrderToUpdate({ ...order, newStatus });
        setIsConfirmModalVisible(true);
    };

    const handleConfirmUpdate = () => {
        if (orderToUpdate) {
            if (orderToUpdate.newStatus === 3) {
                setIsConfirmModalVisible(false);
                setIsEmailModalVisible(true);
            } else {
                updateOrderStatus(orderToUpdate.orderId, orderToUpdate.newStatus, orderToUpdate.pharmacyId);
            }
        }
    };

    const handleEmailConfirm = () => {
        if (orderToUpdate) {
            updateOrderStatus(orderToUpdate.orderId, orderToUpdate.newStatus, orderToUpdate.pharmacyId);
            setIsEmailModalVisible(false);
        }
    };

    const updateOrderStatus = (orderId, newStatus, pharmacyId) => {
        pharmacyOrderAPI.updateOrderStatus(orderId, newStatus, pharmacyId)
            .then((response) => {
                if (response.code === 1) {
                    message.success(`Order ${orderId} updated to status ${newStatus}`);
                    if (newStatus === 3) {
                        setTimers(prevTimers => {
                            const { [orderId]: _, ...restTimers } = prevTimers;
                            return restTimers;
                        });
                    }
                    fetchOrders();
                }
            })
            .catch((error) => {
                message.error("Failed to update order status");
                console.error("Failed to update order status:", error);
            })
            .finally(() => {
                setIsConfirmModalVisible(false);
                setOrderToUpdate(null);
            });
    };

    const showCancelModal = (order) => {
        setOrderToCancel(order);
        setIsModalVisible(true);
    };

    const handleCancel = () => {
        setIsModalVisible(false);
        setIsConfirmModalVisible(false);
        setIsEmailModalVisible(false);
        setCancelReason("");
        setOrderToCancel(null);
        setOrderToUpdate(null);
    };

    const handleConfirmCancel = () => {
        if (orderToCancel && cancelReason) {
            pharmacyOrderAPI.updateOrderStatus(orderToCancel.orderId, 4, orderToCancel.pharmacyId, cancelReason)
                .then((response) => {
                    if (response.code === 1) {
                        message.success(`Order ${orderToCancel.orderId} cancelled successfully`);
                        setTimers(prevTimers => {
                            const { [orderToCancel.orderId]: _, ...restTimers } = prevTimers;
                            return restTimers;
                        });
                        fetchOrders();
                    }
                })
                .catch((error) => {
                    message.error("Failed to cancel order");
                    console.error("Failed to cancel order:", error);
                })
                .finally(() => {
                    setIsModalVisible(false);
                    setCancelReason("");
                    setOrderToCancel(null);
                });
        }
    };

    const getCardColor = (status) => {
        switch(status) {
            case 1: return 'bg-green-200';
            case 2: return 'bg-orange-200';
            case 3: return 'bg-red-200';
        }
    };

    const renderOrderCard = (order, actionText) => (
        <div key={order.orderId} className={`${getCardColor(order.status)} shadow-lg rounded-lg p-6 mb-4 transition duration-300 hover:shadow-xl`}>
            <p className="text-gray-700 mb-2">Username: {order.username}</p>
            <p className="text-lg font-semibold mb-2">Order ID: {order.orderId}</p>
            <p className="text-gray-700 mb-2">Pharmacy ID: {order.pharmacyId}</p>
            <p className="text-gray-700 mb-2">Created At: {convertToNZTime(order.createdAt)}</p>
            {/*<p className="text-gray-700 mb-2">Username: {order.username}</p>*/}
            {/*<p className="text-gray-700 mb-2">Total Amount: ${order.totalAmount?.toFixed(2) }</p>*/}
            <div className="flex justify-between items-center">
                <button
                    onClick={() => fetchOrderDetails(order.orderId)}
                    className="bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded transition duration-300 mr-2"
                >
                    View
                </button>
                {order.status !== 3 && (
                    <button
                        onClick={() => showConfirmModal(order, order.status + 1)}
                        className="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition duration-300 mr-2"
                    >
                        {actionText}
                    </button>
                )}
                <button
                    onClick={() => showCancelModal(order)}
                    className="bg-red-600 hover:bg-red-500 text-white font-bold py-2 px-4 rounded transition duration-200"
                >
                    Cancel Order
                </button>
            </div>
        </div>
    );

    const columns = [
        {
            title: 'Product Name',
            dataIndex: 'productName',
            key: 'productName',
        },
        {
            title: 'Quantity',
            dataIndex: 'quantity',
            key: 'quantity',
        },
        {
            title: 'Username',
            dataIndex: 'username',
            key: 'username',
        },
        {
            title: 'Price',
            dataIndex: 'price',
            key: 'price',
            render: (price) => `$${price.toFixed(2)}`,
        },
        {
            title: 'Total',
            key: 'total',
            render: (_, record) => `$${(record.price * record.quantity).toFixed(2)}`,
        },
        {
            title: 'Manufacturer',
            dataIndex: 'manufacturerName',
            key: 'manufacturerName',
        },
        {
            title: 'Image',
            dataIndex: 'imageSrc',
            key: 'imageSrc',
            render: (imageSrc) => <img src={imageSrc} alt="Product" style={{ width: '50px', height: '50px' }} />,
        },
    ];
    const handleGenerateReport = () => {
        generateReport([...orders.finishOrder, ...orders.startPicking, ...orders.finishPicking]);
    };

    const handleGenerateReceipt = () => {
        const currentOrderId = orderDetails[0]?.orderId;
        if (currentOrderId) {
            generateReceipt(currentOrderId);
        } else {
            message.error("No order selected for receipt generation");
        }
    };

    return (
        <div className="container mx-auto px-4 py-8 min-h-screen">
            <h1 className="text-3xl font-bold mb-6 text-gray-800">Order Management</h1>
            <p className="text-lg mb-6 text-gray-700">Current Order ID: <span
                className="font-semibold">{currentOrderId}</span></p>
            <Select
                value={currentPharmacy}
                onChange={handlePharmacyChange}
                style={{ width: 200 }}
            >
                <Option value={1}>MANUKAU</Option>
                <Option value={2}>New Market</Option>
                <Option value={3}>Mount Albert</Option>
                <Option value={4}>Albany</Option>
                <Option value={5}>CBD</Option>
            </Select>
            <div className="mb-6">
                <Button type="primary" onClick={handleGenerateReport}>Generate Order Report</Button>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div>
                    <h2 className="text-xl font-semibold mb-4 text-green-800">Finish Order</h2>
                    {orders.finishOrder.map(order => renderOrderCard(order, "Start Picking"))}
                </div>
                <div>
                    <h2 className="text-xl font-semibold mb-4 text-orange-500">Start Picking</h2>
                    {orders.startPicking.map(order => renderOrderCard(order, "Finish Picking"))}
                </div>
                <div>
                    <h2 className="text-xl font-semibold mb-4 text-red-600">Finish Picking</h2>
                    {orders.finishPicking.map(order => renderOrderCard(order, "Complete Order"))}
                </div>
            </div>

            <Modal
                title="Cancel Order"
                visible={isModalVisible}
                onOk={handleConfirmCancel}
                onCancel={handleCancel}
                okText="Confirm Cancellation"
                cancelText="Close"
            >
                <p className="mb-2">Please enter the reason for cancellation:</p>
                <Input.TextArea
                    value={cancelReason}
                    onChange={(e) => setCancelReason(e.target.value)}
                    rows={4}
                    className="w-full"
                />
            </Modal>

            <Modal
                title="Confirm Status Update"
                visible={isConfirmModalVisible}
                onOk={handleConfirmUpdate}
                onCancel={handleCancel}
                okText="Confirm"
                cancelText="Cancel"
            >
                <p>Are you sure you want to update the status of this order?</p>
            </Modal>

            <Modal
                title="Confirm Email to Customer"
                visible={isEmailModalVisible}
                onOk={handleEmailConfirm}
                onCancel={handleCancel}
                okText="Send Email and Update"
                cancelText="Cancel"
            >
                <p>Are you sure you want to send an email to the customer and update the order status?</p>
            </Modal>

            <Modal
                title="Order Details "

                visible={isDetailsModalVisible}
                onCancel={() => setIsDetailsModalVisible(false)}
                footer={[
                <Button key="close" onClick={() => setIsDetailsModalVisible(false)}>
                    Close
                </Button>,
                <Button key="download" type="primary" onClick={handleGenerateReceipt}>
                    Generate Receipt
                </Button>
            ]}
                width={1000}
                >
            <Table dataSource={orderDetails} columns={columns} rowKey="productId"/>
            <p className="text-right mt-4 text-lg font-semibold">Total Amount: ${totalAmount.toFixed(2)}</p>
        </Modal>
</div>
)
    ;
};

export default OrderPage;