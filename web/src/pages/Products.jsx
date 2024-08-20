import { useEffect, useState } from 'react';
import {Table, Input, message, Modal, Button} from 'antd';
import { PlusCircleOutlined } from '@ant-design/icons';
import { SearchOutlined } from '@ant-design/icons';
import { getProductsAPI } from "@/api/user/Products.jsx";
import { Link } from 'react-router-dom';
import { useNavigate } from 'react-router-dom';
const { Search } = Input;

const Products = () => {
    const [products, setProducts] = useState([]);
    const [loading, setLoading] = useState(false);
    const [params, setParams] = useState({
        page: 1,
        pageSize: 15,
        productName: "",
        productId: "",
    });
    const [total, setTotal] = useState(0);
    const [modalVisible, setModalVisible] = useState(false);
    const [selectedImage, setSelectedImage] = useState('');
    const navigate = useNavigate();

    const fetchProducts = async () => {
        setLoading(true);
        try {
            const response = await getProductsAPI(params);
            if (response && response.data) {
                setProducts(response.data.records);
                setTotal(response.data.total);
            }
        } catch (error) {
            console.error('Error fetching products:', error);
            message.error('Failed to fetch products. Please try again later.');
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchProducts();
    }, [params]);

    const handleTableChange = (pagination) => {
        setParams(prev => ({
            ...prev,
            page: pagination.current,
            pageSize: pagination.pageSize,
        }));
    };

    const handleSearch = (value) => {
        setParams(prev => ({
            ...prev,
            page: 1,
            productName: value,
        }));
    };

    const showImage = (imageSrc) => {
        setSelectedImage(imageSrc);
        setModalVisible(true);
    };
//使用的是/api/products/changeProducts
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
        },        {
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
                <Search
                    placeholder="Search products"
                    onSearch={handleSearch}
                    enterButton={<SearchOutlined />}
                    size="large"
                    className="w-full max-w-4xl"

                />
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
                scroll={{ x: '100vw', y: 'calc(100vh - 450px)' }}
                rowKey="productId"
                className="text-base"
            />
            <Modal
                open={modalVisible}
                footer={null}
                onCancel={() => setModalVisible(false)}
            >
                <img alt="Product" className="w-full" src={selectedImage} />
            </Modal>
        </div>
    );
};

export default Products;