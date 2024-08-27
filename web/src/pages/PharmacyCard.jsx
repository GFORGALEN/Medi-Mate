import  { useState, useCallback, useEffect } from 'react';
import { GoogleMap, Marker } from '@react-google-maps/api';
import { useNavigate } from 'react-router-dom';
import { Spin, Button, message } from 'antd';
import { LeftOutlined, RightOutlined } from '@ant-design/icons';
import { getImagePath, getGoogleMapsUrl } from '../utils/utils';
import { getPharmaciesAPI } from '@/api/user/pharmacy';
import useGoogleMapsApi from '@/hook/useGoogleMapsApi.jsx';

const PharmacyMapWithCards = () => {
    const navigate = useNavigate();
    const [currentIndex, setCurrentIndex] = useState(0);
    const [map, setMap] = useState(null);
    const [pharmacies, setPharmacies] = useState([]);
    const [loading, setLoading] = useState(true);
    const isMapLoaded = useGoogleMapsApi();

    useEffect(() => {
        const fetchPharmacies = async () => {
            try {
                const response = await getPharmaciesAPI();
                if (response.code === 1 && Array.isArray(response.data)) {
                    setPharmacies(response.data);
                } else {
                    throw new Error('Invalid response format');
                }
            } catch (error) {
                console.error('Error fetching pharmacies:', error);
                message.error('Failed to load pharmacy data');
            } finally {
                setLoading(false);
            }
        };

        fetchPharmacies();
    }, []);

    const mapContainerStyle = {
        width: '100%',
        height: '100vh'
    };

    const defaultCenter = { lat: -36.8485, lng: 174.7633 };

    const currentPharmacy = pharmacies[currentIndex] || null;
    const center = currentPharmacy
        ? { lat: parseFloat(currentPharmacy.latitude), lng: parseFloat(currentPharmacy.longitude) }
        : defaultCenter;

    const handleViewInventory = () => {
        if (currentPharmacy) {
            navigate(`/inventory/${currentPharmacy.pharmacyId}`);
        }
    };

    const handleNext = useCallback(() => {
        if (pharmacies.length > 0) {
            setCurrentIndex((prevIndex) => (prevIndex + 1) % pharmacies.length);
        }
    }, [pharmacies.length]);

    const handlePrevious = useCallback(() => {
        if (pharmacies.length > 0) {
            setCurrentIndex((prevIndex) => (prevIndex - 1 + pharmacies.length) % pharmacies.length);
        }
    }, [pharmacies.length]);

    useEffect(() => {
        if (map && currentPharmacy) {
            map.panTo(center);
        }
    }, [currentIndex, map, center, currentPharmacy]);

    const onMapLoad = useCallback((map) => {
        setMap(map);
    }, []);

    if (loading) {
        return (
            <div className="w-full h-screen flex items-center justify-center bg-gray-200">
                <Spin size="large" />
            </div>
        );
    }

    if (pharmacies.length === 0) {
        return (
            <div className="w-full h-screen flex items-center justify-center bg-gray-200">
                <p>No pharmacies data available.</p>
            </div>
        );
    }

    return (
        <div className="relative w-full">
            {isMapLoaded ? (
                <GoogleMap
                    mapContainerStyle={mapContainerStyle}
                    center={center}
                    zoom={15}
                    onLoad={onMapLoad}
                >
                    {pharmacies.map((pharmacy, index) => (
                        <Marker
                            key={pharmacy.pharmacyId}
                            position={{
                                lat: parseFloat(pharmacy.latitude),
                                lng: parseFloat(pharmacy.longitude)
                            }}
                            icon={index === currentIndex ? {
                                url: 'http://maps.google.com/mapfiles/ms/icons/blue-dot.png'
                            } : undefined}
                        />
                    ))}
                </GoogleMap>
            ) : (
                <div className="w-full h-full flex items-center justify-center bg-gray-200">
                    <Spin />
                </div>
            )}

            {currentPharmacy && (
                <div className="absolute bottom-0 left-0 right-0 bg-white shadow-md overflow-hidden">
                    <div className="flex p-4 items-center">
                        <Button icon={<LeftOutlined />} onClick={handlePrevious} className="mr-2" />
                        <div className="flex-grow flex">
                            <img
                                src={getImagePath(currentPharmacy.pharmacyName)}
                                alt={currentPharmacy.pharmacyName}
                                className="w-1/3 h-40 object-cover rounded-lg mr-4"
                            />
                            <div className="w-2/3">
                                <div className="text-xl text-indigo-500 font-semibold">
                                    {currentPharmacy.pharmacyName}
                                </div>
                                <a
                                    href={getGoogleMapsUrl(currentPharmacy.pharmacyAddress)}
                                    target="_blank"
                                    rel="noopener noreferrer"
                                    className="mt-2 block text-gray-500 text-base hover:text-indigo-600 transition duration-150 ease-in-out"
                                >
                                    {currentPharmacy.pharmacyAddress}
                                </a>
                                <button
                                    onClick={handleViewInventory}
                                    className="mt-4 w-full px-4 py-2 border border-transparent text-base font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-400 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition duration-150 ease-in-out"
                                >
                                    View Inventory
                                </button>
                            </div>
                        </div>
                        <Button icon={<RightOutlined />} onClick={handleNext} className="ml-2" />
                    </div>
                </div>
            )}
        </div>
    );
};

export default PharmacyMapWithCards;
