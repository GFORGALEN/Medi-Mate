import React from 'react';
import { Button } from 'antd';
import jsPDF from 'jspdf';
import 'jspdf-autotable';

const GenerateReportButton = ({ orders }) => {
    const generatePDF = () => {
        const doc = new jsPDF();

        // 添加标题
        doc.setFontSize(18);
        doc.text('Order Report', 14, 22);

        // 准备表格数据
        const tableColumn = ["Order ID", "User ID", "Amount", "Status", "Pharmacy ID"];
        const tableRows = orders.map(order => [
            order.orderId,
            order.userId,
            `$${order.amount.toFixed(2)}`,
            ['receive', 'picking', 'finish'][order.status],
            order.pharmacyId
        ]);

        // 生成表格
        doc.autoTable({
            head: [tableColumn],
            body: tableRows,
            startY: 30,
            styles: { fontSize: 12, cellPadding: 2, overflow: 'linebreak' },
            columnStyles: { 0: { cellWidth: 40 }, 1: { cellWidth: 40 }, 2: { cellWidth: 30 }, 3: { cellWidth: 30 }, 4: { cellWidth: 30 } }
        });

        // 保存PDF文件
        doc.save('order_report.pdf');
    };

    return (
        <Button onClick={generatePDF} type="primary">
            Generate Report
        </Button>
    );
};

export default GenerateReportButton;