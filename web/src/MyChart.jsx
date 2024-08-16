import React from 'react';
import ReactECharts from 'echarts-for-react';

const MyChart = () => {
    const option = {
        title: {
            text: 'ECharts Example'
        },
        tooltip: {},
        xAxis: {
            data: ['Shirts', 'Cardigans', 'Chiffons', 'Pants', 'Heels', 'Socks']
        },
        yAxis: {},
        series: [
            {
                name: 'Sales',
                type: 'bar',
                data: [5, 20, 36, 10, 10, 20]
            }
        ]
    };

    return <ReactECharts option={option} />;
};

export default MyChart;
