import {createSlice} from '@reduxjs/toolkit';

export const messageSlice = createSlice({
    name: 'message',
    initialState: {
        orderId: "3392b041-d673-48d9-a2b0-1e3b2e376704"
    },
    reducers: {
        setOrderId: (state, action) => {
            state.orderId = action.payload;
        }
    },
});

export const {setOrderId} = messageSlice.actions;

export default messageSlice.reducer;
