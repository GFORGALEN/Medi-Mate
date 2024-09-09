import React from 'react';
import { Button } from 'antd';
import jsPDF from 'jspdf';
import 'jspdf-autotable';

const GenerateReceiptButton = ({ order }) => {
    const generateReceipt = () => {
        if (!order) return;

        const doc = new jsPDF();

        // 添加公司标题
        doc.setFontSize(20);
        doc.text('MediMate', 105, 15, null, null, 'center');

        // 添加订单信息
        doc.setFontSize(12);
        doc.text(`Order ID: ${order.orderId}`, 14, 30);
        doc.text(`Order Date: ${new Date(order.createdAt).toLocaleString()}`, 14, 40);
        doc.text(`User ID: ${order.userId}`, 14, 50);

        // 准备表格数据
        const tableColumn = ["Product", "Quantity", "Price", "Total"];
        const tableRows = order.items.map(item => [
            item.productName,
            item.quantity,
            `$${item.price.toFixed(2)}`,
            `$${(item.quantity * item.price).toFixed(2)}`
        ]);

        // 生成表格
        doc.autoTable({
            head: [tableColumn],
            body: tableRows,
            startY: 60,
            styles: { fontSize: 10 },
            columnStyles: { 0: { cellWidth: 80 }, 1: { cellWidth: 30 }, 2: { cellWidth: 40 }, 3: { cellWidth: 40 } }
        });

        // 添加总计
        const total = order.items.reduce((sum, item) => sum + item.quantity * item.price, 0);
        doc.text(`Total: $${total.toFixed(2)}`, 150, doc.lastAutoTable.finalY + 10);

        // 保存PDF文件
        doc.save(`receipt_${order.orderId}.pdf`);
    };

    return (
        <Button onClick={generateReceipt} type="primary">
            Generate Receipt
        </Button>
    );
};

export default GenerateReceiptButton;