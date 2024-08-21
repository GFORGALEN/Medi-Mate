import  { useState, useEffect } from 'react';
import { Layout, Card, Spin, Select, message } from 'antd';
import ReactECharts from 'echarts-for-react';
import { getProductsAPI, getAllManufacturersAPI } from "@/api/user/Products.jsx";
import * as echarts from 'echarts';
import 'echarts-gl';

const { Content } = Layout;
const { Option } = Select;

const ProductAnalytics = () => {
    const [loading, setLoading] = useState(true);
    const [products, setProducts] = useState([]);
    const [manufacturers, setManufacturers] = useState([]);
    const [selectedManufacturer, setSelectedManufacturer] = useState("");

    useEffect(() => {
        fetchData();
        fetchManufacturers();
    }, []);

    const fetchData = async () => {
        setLoading(true);
        try {
            const response = await getProductsAPI({ page: 1, pageSize: 1000 });
            if (response && response.data && response.data.records) {
                setProducts(response.data.records);
            }
        } catch (error) {
            console.error('Error fetching products:', error);
            message.error('Failed to fetch product data. Please try again later.');
        } finally {
            setLoading(false);
        }
    };

    const fetchManufacturers = async () => {
        try {
            const response = await getAllManufacturersAPI();
            if (response && response.data && Array.isArray(response.data.records)) {
                const uniqueManufacturers = [...new Set(response.data.records.map(item => item.manufacturerName))];
                setManufacturers(uniqueManufacturers);
            }
        } catch (error) {
            console.error('Error fetching manufacturers:', error);
            message.error('Failed to fetch manufacturers. Please try again later.');
        }
    };

    const handleManufacturerChange = (value) => {
        setSelectedManufacturer(value);
    };
    const get3DScatterOption = () => {
        const data = filteredProducts.map(product => [
            parseFloat(product.productPrice),
            product.generalInformation ? product.generalInformation.length : 0,
            1, // 初始值为1，后面会更新
            product.productName // 用于tooltip显示
        ]);
        const priceCount = {};
        data.forEach(item => {
            const price = item[0];
            priceCount[price] = (priceCount[price] || 0) + 1;
        });
        data.forEach(item => {
            item[2] = priceCount[item[0]];
        });

        return {
            title: { text: '3D View: Price, Info Length & Product Count', left: 'center' },
            tooltip: {
                formatter: (params) => {
                    const data = params.data;
                    return `Product: ${data[3]}<br/>Price: $${data[0]}<br/>Info Length: ${data[1]}<br/>Product Count: ${data[2]}`;
                }
            },
            xAxis3D: { name: 'Price ($)', type: 'value' },
            yAxis3D: { name: 'Info Length', type: 'value' },
            zAxis3D: { name: 'Product Count', type: 'value' },
            grid3D: {
                viewControl: {
                    projection: 'orthographic'
                }
            },
            series: [{
                type: 'scatter3D',
                data: data,
                symbolSize: 5,
                itemStyle: {
                    color: (params) => {
                        // 基于价格设置颜色
                        const price = params.data[0];
                        return new echarts.graphic.RadialGradient(0.4, 0.3, 1, [{
                            offset: 0, color: 'rgb(129, 227, 238)'
                        }, {
                            offset: 1, color: `rgb(25, 183, 207)`
                        }]);
                    }
                }
            }]
        };
    };
    const filteredProducts = selectedManufacturer
        ? products.filter(product => product.manufacturerName === selectedManufacturer)
        : products;

    const getPriceDistributionOption = () => {
        const priceRanges = [0, 10, 20, 50, 100, 200, 500, 1000];
        const distribution = priceRanges.map((range, index) => {
            const nextRange = priceRanges[index + 1] || Infinity;
            const count = filteredProducts.filter(product => {
                const price = parseFloat(product.productPrice);
                return price >= range && price < nextRange;
            }).length;
            return { range: `$${range}${nextRange === Infinity ? '+' : ` - $${nextRange}`}`, count };
        });


        return {
            title: { text: 'Product Price Distribution', left: 'center' },
            tooltip: { trigger: 'axis' },
            xAxis: { type: 'category', data: distribution.map(d => d.range) },
            yAxis: { type: 'value', name: 'Number of Products' },
            series: [{
                name: 'Products',
                type: 'bar',
                data: distribution.map(d => d.count),
                itemStyle: { color: '#5470c6' }
            }]
        };
    };

    const getTopManufacturersOption = () => {
        const manufacturerCounts = products.reduce((acc, product) => {
            acc[product.manufacturerName] = (acc[product.manufacturerName] || 0) + 1;
            return acc;
        }, {});

        const sortedManufacturers = Object.entries(manufacturerCounts)
            .sort((a, b) => b[1] - a[1])
            .slice(0, 10);

        return {
            title: { text: 'Top 10 Manufacturers by Product Count', left: 'center' },
            tooltip: { trigger: 'axis' },
            xAxis: { type: 'value', name: 'Number of Products' },
            yAxis: { type: 'category', data: sortedManufacturers.map(m => m[0]) },
            series: [{
                name: 'Products',
                type: 'bar',
                data: sortedManufacturers.map(m => m[1]),
                itemStyle: { color: '#91cc75' }
            }]
        };
    };

    const getPriceVsProductCountOption = () => {
        const priceGroups = filteredProducts.reduce((acc, product) => {
            const price = Math.floor(parseFloat(product.productPrice) / 10) * 10;
            acc[price] = (acc[price] || 0) + 1;
            return acc;
        }, {});

        const data = Object.entries(priceGroups)
            .map(([price, count]) => [parseFloat(price), count])
            .sort((a, b) => a[0] - b[0]);

        return {
            title: { text: 'Price vs Product Count', left: 'center' },
            tooltip: { trigger: 'axis' },
            xAxis: { type: 'value', name: 'Price ($)', min: 'dataMin', max: 'dataMax' },
            yAxis: { type: 'value', name: 'Number of Products' },
            series: [{
                name: 'Products',
                type: 'scatter',
                data: data,
                symbolSize: 10,
                itemStyle: { color: '#ee6666' }
            }]
        };
    };

    return (
        <Layout>
            <Content className="p-6">
                <h1 className="text-2xl font-bold mb-6">Product Analytics</h1>
                <Select
                    style={{ width: 200, marginBottom: 20 }}
                    placeholder="Select Manufacturer"
                    onChange={handleManufacturerChange}
                    value={selectedManufacturer}
                >
                    <Option value="">All Manufacturers</Option>
                    {manufacturers.map(manufacturer => (
                        <Option key={manufacturer} value={manufacturer}>{manufacturer}</Option>
                    ))}
                </Select>
                {loading ? (
                    <Spin size="large" />
                ) : (
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <Card title="Price Distribution">
                            <ReactECharts option={getPriceDistributionOption()} style={{ height: '400px' }} />
                        </Card>
                        <Card title="Top 10 Manufacturers">
                            <ReactECharts option={getTopManufacturersOption()} style={{ height: '400px' }} />
                        </Card>
                        <Card title="Price vs Product Count" className="col-span-1 md:col-span-2">
                            <ReactECharts option={getPriceVsProductCountOption()} style={{ height: '400px' }} />
                        </Card>
                        <Card title="3D Scatter Plot" className="col-span-1 md:col-span-2">
                            <ReactECharts
                                option={get3DScatterOption()}
                                style={{ height: '600px' }}
                                echarts={echarts}
                            />
                        </Card>
                    </div>
                )}
            </Content>
        </Layout>
    );
};

export default ProductAnalytics;