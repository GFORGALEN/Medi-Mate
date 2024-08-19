import {requestProduct} from "@/axios/requestProducts.jsx";

export function getProductsAPI(params) {
    return requestProduct({
        method: 'GET',
        url: "",
        params
    })
}