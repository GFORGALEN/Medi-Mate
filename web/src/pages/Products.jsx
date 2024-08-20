import {useEffect, useState} from 'react';
import {Table, Input, message, Modal} from 'antd';
import {SearchOutlined} from '@ant-design/icons';
import {getProductsAPI} from "@/api/user/Products.jsx";

const {Search} = Input;

const Products = () => {
    const [products, setProducts] = useState([]);
    const [loading, setLoading] = useState(false);
    const [params, setParams] = useState({
        page: 1,
        pageSize: 15,
        productName: "",
    });
    const [total, setTotal] = useState(0);
    const [modalVisible, setModalVisible] = useState(false);
    const [selectedImage, setSelectedImage] = useState('');

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

    const columns = [
        {
            title: 'Product Name',
            dataIndex: 'productName',
            key: 'name',
            fixed: 'left',
            ellipsis: true,
            render: (text) => <span className="text-base font-medium">{text}</span>
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
            title: 'Id',
            dataIndex: 'productId',
            key: 'id',

            ellipsis: true
        },
        {
            title: 'Manufacturer Name',
            dataIndex: 'manufacturerName',
            key: 'ManufacturerName',

            ellipsis: true
        },
        {
            title: 'General Information',
            dataIndex: 'generalInformation',
            key: 'generalInformation',

            ellipsis: true
        },
        {
            title: 'Warnings',
            dataIndex: 'warnings',
            key: 'warnings',

            ellipsis: true
        },
        {
            title: 'Common Use',
            dataIndex: 'commonUse',
            key: 'commonUse',

            ellipsis: true
        },
        {
            title: 'Ingredients',
            dataIndex: 'ingredients',
            key: 'ingredients',

            ellipsis: true
        },
        {
            title: 'Directions',
            dataIndex: 'directions',
            key: 'directions',

            ellipsis: true
        }, {
            title: 'Summary',
            dataIndex: 'summary',
            key: 'summary',

            ellipsis: true
        },
        {
            title: 'Action',
            key: 'operation',
            fixed: 'right',
            render: () => <a className="text-blue-600 hover:text-blue-800">Details</a>,
            ellipsis: true
        },
    ];

    return (
        <div className="font-poppins p-4 bg-white rounded-lg shadow">
            <Search
                placeholder="Search products"
                onSearch={handleSearch}
                enterButton={<SearchOutlined/>}
                size="large"
                className="w-full max-w-4xl"
            />
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
                scroll={{x: 'max-content', y: 'calc(100vh - 450px)'}}
                rowKey="productId"
                className="text-base"
                sticky
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