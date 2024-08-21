
import { useEffect, useState } from 'react';
import {Table, Input, message, Modal, Button,Select } from 'antd';
import { PlusCircleOutlined } from '@ant-design/icons';
import { SearchOutlined } from '@ant-design/icons';
import { getProductsAPI, getAllManufacturersAPI } from "@/api/user/Products.jsx";
import { Link, useNavigate } from 'react-router-dom';

const { Search } = Input;
const { Option } = Select;

const Products = () => {
    const [products, setProducts] = useState([]);
    const [loading, setLoading] = useState(false);
    const [params, setParams] = useState({
        page: 1,
        pageSize: 15,
        productName: "",
        productId: "",
        manufacturerName: "",
    });
    const [total, setTotal] = useState(0);
    const [modalVisible, setModalVisible] = useState(false);
    const [selectedImage, setSelectedImage] = useState('');
    const [manufacturers, setManufacturers] = useState([]);
    const [searchTerm, setSearchTerm] = useState("");
    const navigate = useNavigate();

    const fetchProducts = async () => {
        setLoading(true);
        try {
            const response = await getProductsAPI(params);
            if (response && response.data) {
                const filteredProducts = response.data.records.filter(product =>
                    (!params.manufacturerName || product.manufacturerName === params.manufacturerName) &&
                    (!params.productName || product.productName.toLowerCase().includes(params.productName.toLowerCase()))
                );
                setProducts(() => {
                    return filteredProducts
                });
                setTotal(()=>{
                    return response.data.total
                }); // 使用API返回的总数

                if (params.productName && params.manufacturerName && filteredProducts.length === 0) {
                    message.warning(`No products found for "${params.productName}" under the selected manufacturer.`);
                }
            }
        } catch (error) {
            console.error('Error fetching products:', error);
            message.error('Failed to fetch products. Please try again later.');
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
            } else {
                throw new Error("Data is not in the expected format");
            }
        } catch (error) {
            console.error('Error fetching manufacturers:', error);
            message.error(`Failed to fetch manufacturers: ${error.message}`);
        }
    };

    useEffect(() => {
        fetchProducts();
    }, [params]);

    useEffect(() => {
        fetchManufacturers();
    }, []);

    const handleTableChange = (pagination) => {
        setParams(prev => ({
            ...prev,
            page: pagination.current,
            pageSize: pagination.pageSize,
        }));
    };

    const handleSearch = (value) => {
        setSearchTerm(value);
        setParams(prev => ({
            ...prev,
            page: 1,
            productName: value,
        }));
    };

    const handleManufacturerChange = (value) => {
        setParams(prev => ({
            ...prev,
            page: 1,
            manufacturerName: value,
            productName: searchTerm, // Keep the current search term
        }));
    };

    const showImage = (imageSrc) => {
        setSelectedImage(imageSrc);
        setModalVisible(true);
    };

    const handleAddNew = () => {
        navigate(`/products/new`);
    };

    const columns = [
        {
            title: 'Product Name',
            dataIndex: 'productName',
            key: 'name',
            fixed: 'left',
            width: 200,
            ellipsis: true,
            render: (text) => <span className="text-base">{text}</span>
        },
        {
            title: 'Price',
            dataIndex: 'productPrice',
            key: 'price',

            ellipsis: true,
            render: (text) => <span className="text-base">${text}</span>
        },
        {
            title: 'Image',
            dataIndex: 'imageSrc',
            key: 'image',

            ellipsis: true,
            render: (imageSrc) => (
                <img
                    src={imageSrc}
                    alt="Product"
                    className="w-16 h-16 object-contain cursor-pointer"
                    onClick={() => showImage(imageSrc)}
                />
            )
        },
        {
            title: 'Manufacturer Name',
            dataIndex: 'manufacturerName',
            key: 'ManufacturerName',

            ellipsis: true,
            render: (text) => <span className="text-base">{text}</span>
        },
        {
            title: 'General Information',
            dataIndex: 'generalInformation',
            key: 'generalInformation',
            width: 200,
            ellipsis: true,
            render: (text) => <span className="text-base">{text}</span>
        },
        {
            title: 'Warnings',
            dataIndex: 'warnings',
            key: 'warnings',
            width: 200,
            ellipsis: true,
            render: (text) => <span className="text-base">{text}</span>

        },
        {
            title: 'Common Use',
            dataIndex: 'commonUse',
            key: 'commonUse',

            ellipsis: true,
            render: (text) => <span className="text-base">{text}</span>
        },
        {
            title: 'Ingredients',
            dataIndex: 'ingredients',
            key: 'ingredients',
            render: (text) => <span className="text-base">{text}</span>,
            ellipsis: true
        },
        {
            title: 'Directions',
            dataIndex: 'directions',
            key: 'directions',
            render: (text) => <span className="text-base">{text}</span>,
            ellipsis: true
        }, {
            title: 'Summary',
            dataIndex: 'summary',
            key: 'summary',
            render: (text) => <span className="text-base">{text}</span>,
            ellipsis: true
        },
        {
            title: 'Action',
            key: 'operation',
            fixed: 'right',
            render: (_, record) => (
                <span>
                    <Link to={`/products/productDetail/view/${record.productId}`} className="text-blue-600 hover:text-blue-800 mr-4">
                        Details
                    </Link>
                </span>
            ),
            ellipsis: true
        },
    ];

    return (
        <div className="font-poppins p-4 bg-white rounded-lg shadow">
            <div className="flex justify-between items-center mb-16">
                <div className="flex items-center space-x-4 w-full max-w-4xl">
                    <Search
                        placeholder="Search products"
                        onSearch={handleSearch}
                        enterButton={<SearchOutlined />}
                        size="large"
                        className="flex-grow"
                    />
                    <Select
                        style={{ width: 200 }}
                        placeholder="Select Manufacturer"
                        onChange={handleManufacturerChange}
                        value={params.manufacturerName}
                        size="large"
                    >
                        <Option value="">All Manufacturers</Option>
                        {manufacturers.map(manufacturer => (
                            <Option key={manufacturer} value={manufacturer}>{manufacturer}</Option>
                        ))}
                    </Select>
                </div>
                <Button
                    type="primary"
                    icon={<PlusCircleOutlined />}
                    onClick={handleAddNew}
                    size="large"
                >
                    Add New Product
                </Button>
            </div>
            <Table
                columns={columns}
                dataSource={products}
                loading={loading}
                pagination={{
                    current: params.page,
                    pageSize: params.pageSize,
                    total: total,
                    showSizeChanger: true,
                    showQuickJumper: true,
                }}
                onChange={handleTableChange}
                scroll={{ x: '100vw', y: 'calc(100vh - 410px)' }}
                rowKey="productId"
                className="text-base"
            />
            <Modal
                open={modalVisible}
                footer={null}
                onCancel={() => setModalVisible(false)}
            >
                <img alt="Product" className="w-full" src={selectedImage}/>
            </Modal>
        </div>
    );
};

export default Products;