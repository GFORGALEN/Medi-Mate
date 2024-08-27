import { useState, useEffect } from 'react';
import { message, Spin } from 'antd';
import { LeftOutlined, RightOutlined } from '@ant-design/icons';
import { getPharmaciesAPI } from '@/api/user/pharmacy';
import useGoogleMapsApi from '@/hook/useGoogleMapsApi';
import PharmacyCard from './PharmacyCard';

const Pharmacies = () => {
    const [pharmacies, setPharmacies] = useState([]);
    const [loading, setLoading] = useState(false);
    const [currentIndex, setCurrentIndex] = useState(0);
    const isMapLoaded = useGoogleMapsApi();

    useEffect(() => {
        fetchPharmacies();
    }, []);

    const fetchPharmacies = async () => {
        setLoading(true);
        try {
            const response = await getPharmaciesAPI();
            if (response.code === 1 && Array.isArray(response.data)) {
                setPharmacies(response.data);
            } else {
                throw new Error('Invalid response format');
            }
        } catch (error) {
            console.error('Error fetching pharmacies:', error);
            message.error('Error fetching pharmacies. Please try again later.');
        } finally {
            setLoading(false);
        }
    };

    // const handlePrev = () => {
    //     setCurrentIndex((prevIndex) => (prevIndex > 0 ? prevIndex - 1 : pharmacies.length - 1));
    // };
    //
    // const handleNext = () => {
    //     setCurrentIndex((prevIndex) => (prevIndex < pharmacies.length - 1 ? prevIndex + 1 : 0));
    // };

    return (
        <div className="p-8 relative bg-gray-100">
            <h1 className="text-4xl font-bold text-center mb-12 text-purple-400">Physical Pharmacy</h1>
            <Spin spinning={loading}>
                {pharmacies.length > 0 && (
                    <div className="relative">
                        <div className="grid grid-cols-1 gap-8">
                            {pharmacies[currentIndex] && (
                                <PharmacyCard
                                    key={pharmacies[currentIndex].pharmacyId}
                                    pharmacy={pharmacies[currentIndex]}
                                    index={currentIndex}
                                    isMapLoaded={isMapLoaded}
                                />
                            )}
                        </div>
                        {/*<button*/}
                        {/*    className="absolute left-4 top-1/2 transform -translate-y-1/2 bg-white rounded-full p-4 shadow-lg hover:bg-gray-100 transition duration-300"*/}
                        {/*    onClick={handlePrev}*/}
                        {/*>*/}
                        {/*    <LeftOutlined className="text-3xl"/>*/}
                        {/*</button>*/}
                        {/*<button*/}
                        {/*    className="absolute right-4 top-1/2 transform -translate-y-1/2 bg-white rounded-full p-4 shadow-lg hover:bg-gray-100 transition duration-300"*/}
                        {/*    onClick={handleNext}*/}
                        {/*>*/}
                        {/*    <RightOutlined className="text-3xl"/>*/}
                        {/*</button>*/}
                    </div>
                )}
            </Spin>
        </div>
    );
};

export default Pharmacies;