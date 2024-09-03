import { requestInventory } from "@/axios/requestInventory";

export function getInventoryAPI(pharmacyId, page, pageSize) {
    return requestInventory({
        method: 'POST',
        data: {
            pharmacyId,
            page,
            pageSize
        }
    });
}