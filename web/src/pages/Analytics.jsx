import {useState, useEffect} from 'react';
import {Layout, Card, Spin, Select, message} from 'antd';
import ReactECharts from 'echarts-for-react';
import {getProductsAPI, getAllManufacturersAPI} from "@/api/user/products.jsx";
import * as echarts from 'echarts';
import 'echarts-gl';

const {Content} = Layout;
const {Option} = Select;

const ProductAnalytics = () => {
    const [loading, setLoading] = useState(true); // loading state  
    const [products, setProducts] = useState([]); // products state
    const [manufacturers, setManufacturers] = useState([]); // manufacturers state
    const [selectedManufacturer, setSelectedManufacturer] = useState(""); // selected manufacturer state

    useEffect(() => {
        fetchData();
        fetchManufacturers();
    }, []);

    const fetchData = async () => {
        setLoading(true);
        try {
            const response = await getProductsAPI({page: 1, pageSize: 1000});
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

    const filteredProducts = selectedManufacturer
        ? products.filter(product => product.manufacturerName === selectedManufacturer)
        : products;

    const get3DScatterOption = () => {
        const data = filteredProducts.map(product => {
            const price = parseFloat(product.productPrice);
            const infoLength = product.generalInformation ? product.generalInformation.length : 0;
            const ingredientsCount = product.ingredients ? product.ingredients.split(',').length : 0;
            return [price, infoLength, ingredientsCount, product.productName];
        });

        const maxPrice = Math.max(...data.map(item => item[0]));
        const maxInfoLength = Math.max(...data.map(item => item[1]));
        const maxIngredientsCount = Math.max(...data.map(item => item[2]));

        return {
            title: {text: '3D View: Price, Info Length & Ingredients Count', left: 'center'},
            tooltip: {
                formatter: (params) => {
                    const data = params.data;
                    return `Product: ${data[3]}<br/>Price: $${data[0].toFixed(2)}<br/>Info Length: ${data[1]}<br/>Ingredients Count: ${data[2]}`;
                }
            },
            xAxis3D: {name: 'Price ($)', type: 'value', max: maxPrice},
            yAxis3D: {name: 'Info Length', type: 'value', max: maxInfoLength},
            zAxis3D: {name: 'Ingredients Count', type: 'value', max: maxIngredientsCount},
            grid3D: {
                viewControl: {
                    projection: 'orthographic',
                    autoRotate: true,
                    autoRotateSpeed: 10,
                    damping: 0.8
                },
                light: {
                    main: {
                        intensity: 1.2,
                        shadow: true
                    },
                    ambient: {
                        intensity: 0.3
                    }
                }
            },
            series: [{
                type: 'scatter3D',
                data: data,
                symbolSize: 5,
                itemStyle: {
                    color: (params) => {
                        const price = params.data[0];
                        const normalizedPrice = price / maxPrice;
                        return new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                            offset: 0, color: `rgba(0, 255, 255, ${normalizedPrice})`
                        }, {
                            offset: 1, color: `rgba(0, 0, 255, ${normalizedPrice})`
                        }]);
                    },
                    opacity: 0.8,
                    shadowBlur: 10,
                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                },
                emphasis: {
                    itemStyle: {
                        opacity: 1
                    }
                }
            }]
        };
    };

    const getPriceDistributionOption = () => {
        const priceRanges = [0, 10, 20, 50, 100, 200, 500, 1000];
        const distribution = priceRanges.map((range, index) => {
            const nextRange = priceRanges[index + 1] || Infinity;
            const count = filteredProducts.filter(product => {
                const price = parseFloat(product.productPrice);
                return price >= range && price < nextRange;
            }).length;
            return {range: `$${range}${nextRange === Infinity ? '+' : ` - $${nextRange}`}`, count};
        });

        return {
            title: {text: 'Product Price Distribution', left: 'center'},
            tooltip: {trigger: 'axis'},
            xAxis: {type: 'category', data: distribution.map(d => d.range)},
            yAxis: {type: 'value', name: 'Number of Products'},
            series: [{
                name: 'Products',
                type: 'bar',
                data: distribution.map(d => d.count),
                itemStyle: {color: '#5470c6'}
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
            title: {text: 'Top 10 Manufacturers by Product Count', left: 'center'},
            tooltip: {trigger: 'axis'},
            xAxis: {type: 'value', name: 'Number of Products'},
            yAxis: {type: 'category', data: sortedManufacturers.map(m => m[0])},
            series: [{
                name: 'Products',
                type: 'bar',
                data: sortedManufacturers.map(m => m[1]),
                itemStyle: {color: '#91cc75'}
            }]
        };
    };

    const getPriceBoxPlotOption = () => {
        // 提取所有价格
        const prices = filteredProducts.map(product => parseFloat(product.productPrice)).sort((a, b) => a - b);
        
        // 计算四分位数和中位数
        const q1 = prices[Math.floor(prices.length * 0.25)];
        const median = prices[Math.floor(prices.length * 0.5)];
        const q3 = prices[Math.floor(prices.length * 0.75)];
        const iqr = q3 - q1;
        
        // 计算上下须的范围
        const lowerWhisker = Math.max(q1 - 1.5 * iqr, prices[0]);
        const upperWhisker = Math.min(q3 + 1.5 * iqr, prices[prices.length - 1]);
        
        // 找出异常值
        const outliers = prices.filter(price => price < lowerWhisker || price > upperWhisker);
    
        return {
            title: {text: 'Price Distribution', left: 'center'},
            tooltip: {
                formatter: function(params) {
                    if (params.seriesIndex === 1) {
                        return `$${params.data.toFixed(2)}`;
                    }
                    return `
                        Upper Whisker: $${upperWhisker.toFixed(2)}<br/>
                        Q3: $${q3.toFixed(2)}<br/>
                        Median: $${median.toFixed(2)}<br/>
                        Q1: $${q1.toFixed(2)}<br/>
                        Lower Whisker: $${lowerWhisker.toFixed(2)}
                    `;
                }
            },
            yAxis: {
                type: 'category',
                data: ['Price Distribution'],
                boundaryGap: true,
                nameGap: 30,
                splitArea: {show: false},
                axisLabel: {show: false},
                splitLine: {show: false}
            },
            xAxis: {
                type: 'value',
                name: 'Price ($)',
                splitArea: {show: true}
            },
            series: [
                {
                    name: 'boxplot',
                    type: 'boxplot',
                    data: [
                        [lowerWhisker, q1, median, q3, upperWhisker]
                    ],
                    itemStyle: {
                        color: '#91cc75',
                        borderColor: '#5470c6'
                    },
                    layout: 'horizontal'
                },
                {
                    name: 'outliers',
                    type: 'scatter',
                    data: outliers,
                    itemStyle: {
                        color: '#ee6666'
                    }
                }
            ]
        };
    };

    return (
        <Layout>
            <Content className="p-6">
                <h1 className="text-2xl font-bold mb-6">Product Analytics</h1>
                <Select
                    style={{width: 200, marginBottom: 20}}
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
                    <Spin size="large"/>
                ) : (
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <Card title="Price Distribution">
                            <ReactECharts option={getPriceDistributionOption()} style={{height: '400px'}}/>
                        </Card>
                        <Card title="Top 10 Manufacturers">
                            <ReactECharts option={getTopManufacturersOption()} style={{height: '400px'}}/>
                        </Card>
                        <Card title="Price Distribution" className="col-span-1 md:col-span-2">
                            <ReactECharts option={getPriceBoxPlotOption()} style={{height: '400px'}}/>
                        </Card>
                        <Card title="3D Scatter Plot" className="col-span-1 md:col-span-2">
                            <ReactECharts
                                option={get3DScatterOption()}
                                style={{height: '600px'}}
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