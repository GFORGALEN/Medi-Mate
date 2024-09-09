
import  requestOrder  from '../axios/requstOrder.jsx';
export const pharmacyOrderAPI = {
    getOrderDetails: (pharmacyId) => {
        return requestOrder({
            method: 'GET',
            url: `/pharmacyOrder/${pharmacyId}`
        });
    },
    getOrderDetail: (orderId) => {
        return requestOrder({
            method: 'GET',
            url: `/detailOrder/${orderId}`
        });
    }
};