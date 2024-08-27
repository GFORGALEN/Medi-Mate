import React, { useState, useCallback, useEffect } from 'react';
import { GoogleMap, Marker } from '@react-google-maps/api';
import { Spin } from 'antd';
import { getPharmaciesAPI } from '@/api/user/pharmacy';
import useGoogleMapsApi from '@/hook/useGoogleMapsApi.jsx';
import PropTypes from 'prop-types';

const PharmacyMapWithCards = ({ onPharmaciesLoaded, currentIndex }) => {
    const [map, setMap] = useState(null);
    const [pharmacies, setPharmacies] = useState([]);
    const [loading, setLoading] = useState(true);
    const [center, setCenter] = useState({ lat: -36.8485, lng: 174.7633 }); // Default to Auckland
    const isMapLoaded = useGoogleMapsApi();

    useEffect(() => {
        const fetchPharmacies = async () => {
            try {
                const response = await getPharmaciesAPI();
                if (response.code === 1 && Array.isArray(response.data)) {
                    const validPharmacies = response.data.filter(pharmacy => {
                        const lat = parseFloat(pharmacy.latitude);
                        const lng = parseFloat(pharmacy.longitude);
                        return !isNaN(lat) && !isNaN(lng) && lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180;
                    });
                    setPharmacies(validPharmacies);
                    onPharmaciesLoaded(validPharmacies);
                    if (validPharmacies.length > 0) {
                        setCenter({
                            lat: parseFloat(validPharmacies[0].latitude),
                            lng: parseFloat(validPharmacies[0].longitude)
                        });
                    }
                } else {
                    throw new Error('Invalid response format');
                }
            } catch (error) {
                console.error('Error fetching pharmacies:', error);
            } finally {
                setLoading(false);
            }
        };

        fetchPharmacies();
    }, [onPharmaciesLoaded]);

    useEffect(() => {
        if (pharmacies.length > 0 && currentIndex >= 0 && currentIndex < pharmacies.length) {
            const newCenter = {
                lat: parseFloat(pharmacies[currentIndex].latitude),
                lng: parseFloat(pharmacies[currentIndex].longitude)
            };
            setCenter(newCenter);
            if (map) {
                map.panTo(newCenter);
            }
        }
    }, [currentIndex, pharmacies, map]);

    const onMapLoad = useCallback((map) => {
        setMap(map);
    }, []);

    if (loading || !isMapLoaded) {
        return (
            <div className="w-full h-screen flex items-center justify-center bg-gray-200">
                <Spin size="large" />
            </div>
        );
    }

    return (
        <div className="relative w-screen h-screen overflow-hidden">
            <GoogleMap
                mapContainerStyle={{
                    width: '100%',
                    height: '100%',
                }}
                center={center}
                zoom={18}
                onLoad={onMapLoad}
            >
                {pharmacies.map((pharmacy, index) => {
                    const position = {
                        lat: parseFloat(pharmacy.latitude),
                        lng: parseFloat(pharmacy.longitude)
                    };
                    return (
                        <Marker
                            key={pharmacy.pharmacyId}
                            position={position}
                            icon={{
                                url: index === currentIndex
                                    ? 'http://maps.google.com/mapfiles/ms/icons/blue-dot.png'
                                    : 'http://maps.google.com/mapfiles/ms/icons/red-dot.png',
                                scaledSize: new window.google.maps.Size(40, 40),
                            }}
                            animation={index === currentIndex ? window.google.maps.Animation.BOUNCE : null}
                        />
                    );
                })}
            </GoogleMap>
        </div>
    );
};

PharmacyMapWithCards.propTypes = {
    onPharmaciesLoaded: PropTypes.func.isRequired,
    currentIndex: PropTypes.number.isRequired,
};

export default PharmacyMapWithCards;