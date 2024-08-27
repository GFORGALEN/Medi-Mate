import { useState } from 'react';
import { Canvas } from '@react-three/fiber';
import { OrbitControls } from '@react-three/drei';
import { GoogleMap, Marker } from '@react-google-maps/api';
import { useNavigate } from 'react-router-dom';
import { Spin } from 'antd';
import { ModelComponents } from './PharmacyModels';
import { getImagePath, getGoogleMapsUrl } from '../utils/utils';
import PropTypes from "prop-types";

const PharmacyCard = ({ pharmacy, index, isMapLoaded }) => {
    const navigate = useNavigate();
    const [isImageExpanded, setIsImageExpanded] = useState(false);

    const mapContainerStyle = {
        width: '100%',
        height: '300px'
    };

    const center = {
        lat: parseFloat(pharmacy.latitude),
        lng: parseFloat(pharmacy.longitude)
    };

    const ModelComponent = ModelComponents[index % ModelComponents.length];

    const handleViewInventory = () => {
        navigate(`/inventory/${pharmacy.pharmacyId}`);
    };

    return (
        <div className="w-full bg-white rounded-xl shadow-md overflow-hidden mb-8">
            <div className="flex flex-col">
                <div
                    className="overflow-hidden cursor-pointer transition-all duration-300 ease-in-out"
                    style={{ height: isImageExpanded ? '85vh' : '40vh' }}
                    onClick={() => setIsImageExpanded(!isImageExpanded)}
                >
                    <img
                        src={getImagePath(pharmacy.pharmacyName)}
                        alt={pharmacy.pharmacyName}
                        className="w-full h-full object-cover"
                    />
                </div>
                <div className="p-8">
                    <div className="uppercase tracking-wide text-2xl text-indigo-500 font-semibold">
                        {pharmacy.pharmacyName}
                    </div>
                    <a
                        href={getGoogleMapsUrl(pharmacy.pharmacyAddress)}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="mt-2 text-gray-500 text-lg hover:text-indigo-600 transition duration-150 ease-in-out"
                    >
                        {pharmacy.pharmacyAddress}
                    </a>
                    <div className="h-96 relative bg-gray-100 mt-4">
                        <Canvas camera={{position: [0, 0, 5], fov: 60}}>
                            <ambientLight intensity={0.7}/>
                            <pointLight position={[10, 10, 10]} intensity={1}/>
                            <ModelComponent/>
                            <OrbitControls enablePan={false} enableZoom={false}/>
                        </Canvas>
                    </div>
                    <div className="mt-6 h-80">
                        {isMapLoaded ? (
                            <GoogleMap
                                mapContainerStyle={mapContainerStyle}
                                center={center}
                                zoom={15}
                            >
                                <Marker position={center}/>
                            </GoogleMap>
                        ) : (
                            <div className="w-full h-full flex items-center justify-center bg-gray-200">
                                <Spin/>
                            </div>
                        )}
                    </div>
                    <button
                        onClick={handleViewInventory}
                        className="mt-6 w-full px-6 py-3 border border-transparent text-lg font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-400 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition duration-150 ease-in-out"
                    >
                        View Inventory
                    </button>
                </div>
            </div>
        </div>
    );
};

PharmacyCard.propTypes = {
    pharmacy: PropTypes.shape({
        pharmacyId: PropTypes.string.isRequired,
        pharmacyName: PropTypes.string.isRequired,
        pharmacyAddress: PropTypes.string.isRequired,
        latitude: PropTypes.string.isRequired,
        longitude: PropTypes.string.isRequired,
    }).isRequired,
    index: PropTypes.number.isRequired,
    isMapLoaded: PropTypes.bool.isRequired,
};

export default PharmacyCard;