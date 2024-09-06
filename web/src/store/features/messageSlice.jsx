import {createSlice} from '@reduxjs/toolkit';

export const messageSlice = createSlice({
    name: 'message',
    initialState: {
        orderId: ""
    },
    reducers: {
        setOrderId: (state, action) => {
            state.orderId = action.payload;
        }
    },
});

export const {setOrderId} = messageSlice.actions;

export default messageSlice.reducer;
