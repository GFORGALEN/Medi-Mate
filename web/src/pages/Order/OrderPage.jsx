import {pharmacyOrderAPI} from "@/api/orderApi.jsx";
import {useEffect, useState} from "react";

const OrderPage = () => {
    const [orders, setOrders] = useState([]);
    useEffect(() => {
        pharmacyOrderAPI.getOrderDetails(1).then((response) => {
            if (response.code === 1 && Array.isArray(response.data)) {
                setOrders(response.data);
            }
        });
    }, []);


    return (
        <div className="min-h-screen p-8">
            <h1 className="text-2xl font-bold text-gray-800">Order Page</h1>
            { orders && orders?.map((order) => (
                 <div>{order?.id}</div>
            ))
            }
        </div>
    );
};

export default OrderPage;