import  { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Table, Image, Pagination, Spin, Alert, Button, Modal, Input } from 'antd';
import { ArrowLeftOutlined, BoxPlotOutlined, SearchOutlined } from '@ant-design/icons';
import { getInventoryAPI } from '@/api/user/inventory';
import Pharmacy3DView from './Pharmacy3DView';

const { Search } = Input;

const PharmacyInventory = () => {
    const { pharmacyId } = useParams();
    const navigate = useNavigate();
    const [inventory, setInventory] = useState([]);
    const [filteredInventory, setFilteredInventory] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [pagination, setPagination] = useState({
        current: 1,
        pageSize: 10,
        total: 0
    });
    const [is3DViewVisible, setIs3DViewVisible] = useState(false);
    const [selectedProduct, setSelectedProduct] = useState(null);
    const [searchTerm, setSearchTerm] = useState('');

    useEffect(() => {
        fetchInventory();
    }, [pharmacyId, pagination.current, pagination.pageSize]);

    useEffect(() => {
        filterInventory();
    }, [inventory, searchTerm]);

    const fetchInventory = async () => {
        setLoading(true);
        try {
            const response = await getInventoryAPI(pharmacyId, pagination.current, pagination.pageSize);
            if (response && response.code === 1 && response.data) {
                setInventory(response.data.records);
                setFilteredInventory(response.data.records);
                setPagination(prev => ({
                    ...prev,
                    total: response.data.total
                }));
            } else {
                throw new Error('Unexpected response structure');
            }
        } catch (error) {
            console.error('Error fetching inventory:', error);
            setError('Failed to fetch inventory. Please try again later.');
        } finally {
            setLoading(false);
        }
    };

    const filterInventory = () => {
        const filtered = inventory.filter(item =>
            item.productName.toLowerCase().includes(searchTerm.toLowerCase()) ||
            item.manufacturerName.toLowerCase().includes(searchTerm.toLowerCase())
        );
        setFilteredInventory(filtered);
    };

    const handleSearch = (value) => {
        setSearchTerm(value);
    };

    const handleViewDetails = (product) => {
        setSelectedProduct(product);
        setIs3DViewVisible(true);
    };

    const columns = [
        {
            title: 'Image',
            dataIndex: 'imageSrc',
            key: 'imageSrc',
            render: (imageSrc) => <Image src={imageSrc} width={50} />,
        },
        {
            title: 'Product Name',
            dataIndex: 'productName',
            key: 'productName',
        },
        {
            title: 'Price',
            dataIndex: 'productPrice',
            key: 'productPrice',
            render: (price) => `$${price.toFixed(2)}`,
        },
        {
            title: 'Manufacturer',
            dataIndex: 'manufacturerName',
            key: 'manufacturerName',
        },
        {
            title: 'Stock Quantity',
            dataIndex: 'stockQuantity',
            key: 'stockQuantity',
        },
        {
            title: 'Shelf Number',
            dataIndex: 'shelfNumber',
            key: 'shelfNumber',
        },
        {
            title: 'Shelf Level',
            dataIndex: 'shelfLevel',
            key: 'shelfLevel',
        },
        {
            title: 'Action',
            key: 'action',
            render: (_, record) => (
                <Button type="link" onClick={() => handleViewDetails(record)}>
                    Details
                </Button>
            ),
        },
    ];

    const handlePageChange = (page, pageSize) => {
        setPagination(prev => ({
            ...prev,
            current: page,
            pageSize: pageSize
        }));
    };

    const handleGoBack = () => {
        navigate('/pharmacies');
    };

    const toggle3DView = () => {
        setIs3DViewVisible(!is3DViewVisible);
    };

    if (loading) {
        return (
            <div className="flex justify-center items-center h-screen">
                <Spin size="large" tip="Loading inventory..." />
            </div>
        );
    }

    if (error) {
        return (
            <div className="p-8">
                <Alert
                    message="Error"
                    description={error}
                    type="error"
                    showIcon
                    action={
                        <Button size="small" danger onClick={fetchInventory}>
                            Try Again
                        </Button>
                    }
                />
            </div>
        );
    }

    return (
        <div className="p-8">
            <div className="flex justify-between items-center mb-6">
                <h1 className="text-3xl font-bold">
                    Pharmacy Inventory
                </h1>
                <div>
                    <Button
                        type="primary"
                        icon={<BoxPlotOutlined />}
                        onClick={toggle3DView}
                        className="mr-4"
                    >
                        Toggle 3D View
                    </Button>
                    <Button type="primary" icon={<ArrowLeftOutlined />} onClick={handleGoBack}>
                        Back to Pharmacies
                    </Button>
                </div>
            </div>
            <div className="mb-6">
                <Search
                    placeholder="Search products or manufacturers"
                    onSearch={handleSearch}
                    enterButton={<SearchOutlined />}
                    size="large"
                    className="max-w-xl"
                />
            </div>
            {filteredInventory.length > 0 ? (
                <>
                    <Table
                        columns={columns}
                        dataSource={filteredInventory}
                        rowKey="productName"
                        pagination={false}
                    />
                    <Pagination
                        current={pagination.current}
                        pageSize={pagination.pageSize}
                        total={pagination.total}
                        onChange={handlePageChange}
                        className="mt-6 text-right"
                    />
                </>
            ) : (
                <Alert
                    message="No Data"
                    description="No inventory data available for this pharmacy or matching your search criteria."
                    type="info"
                    showIcon
                />
            )}
            <Modal
                title={`3D View - ${selectedProduct ? selectedProduct.productName : 'Inventory'}`}
                visible={is3DViewVisible}
                onCancel={() => {
                    setIs3DViewVisible(false);
                    setSelectedProduct(null);
                }}
                width={800}
                footer={null}
            >
                <div style={{ height: '600px' }}>
                    <Pharmacy3DView product={selectedProduct} />
                </div>
            </Modal>
        </div>
    );
};

export default PharmacyInventory;