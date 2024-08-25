import React, { useState, useRef, useEffect } from 'react';
import { Canvas, useFrame, useLoader } from '@react-three/fiber';
import { OrbitControls } from '@react-three/drei';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';
import { useNavigate } from 'react-router-dom';

const pharmacyData = [
    { id: 1, name: '阳光大药房', modelUrl: 'asserts/models/pharmacy1.glb' },
    { id: 2, name: '康德乐大药房',modelUrl: 'asserts/models/pharmacy2.glb' },

];

const PharmacyModel = ({ modelUrl }) => {
    const groupRef = useRef();
    const gltf = useLoader(GLTFLoader, modelUrl);

    useFrame(() => {
        if (groupRef.current) {
            groupRef.current.rotation.y += 0.005;
        }
    });

    useEffect(() => {
        if (gltf.scene) {
            gltf.scene.scale.set(4, 4, 4);
            gltf.scene.position.set(0, -1, 0);
        }
    }, [gltf]);

    return (
        <group ref={groupRef}>
            <primitive object={gltf.scene} />
        </group>
    );
};

const PharmacyCard = ({ pharmacy, isSelected, onClick }) => {
    return (
        <div
            className={`pharmacy-card ${isSelected ? 'selected' : ''}`}
            onClick={onClick}
            style={{
                width: '300px',
                height: '400px',
                margin: '10px',
                border: isSelected ? '2px solid yellow' : '1px solid #ccc',
                borderRadius: '10px',
                overflow: 'hidden',
                cursor: 'pointer',
                display: 'flex',
                flexDirection: 'column'
            }}
        >
            <div style={{ height: '300px' }}>
                <Canvas camera={{ position: [0, 0, 5], fov: 60 }}>
                    <ambientLight intensity={0.7} />
                    <pointLight position={[10, 10, 10]} intensity={1} />
                    <PharmacyModel modelUrl={pharmacy.modelUrl} />
                    <OrbitControls enablePan={false} enableZoom={false} />
                </Canvas>
            </div>
            <div style={{
                padding: '10px',
                textAlign: 'center',
                backgroundColor: isSelected ? '#f0f0f0' : 'white'
            }}>
                <h3>{pharmacy.name}</h3>
            </div>
        </div>
    );
};

const PharmacySelector = () => {
    const [selectedPharmacy, setSelectedPharmacy] = useState(null);
    const navigate = useNavigate();

    const handleStoreClick = (id) => {
        setSelectedPharmacy(id);
        // 可以在这里添加导航逻辑
        // navigate(`/pharmacy/${id}`);
    };

    return (
        <div style={{
            display: 'flex',
            flexWrap: 'wrap',
            justifyContent: 'center',
            padding: '20px'
        }}>
            {pharmacyData.map((pharmacy) => (
                <PharmacyCard
                    key={pharmacy.id}
                    pharmacy={pharmacy}
                    isSelected={selectedPharmacy === pharmacy.id}
                    onClick={() => handleStoreClick(pharmacy.id)}
                />
            ))}
        </div>
    );
};

export default PharmacySelector;