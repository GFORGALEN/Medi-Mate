import { useRef } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import { OrbitControls, Text } from '@react-three/drei';
import * as THREE from 'three';

const Shelf = ({ position, size, color }) => {
    return (
        <mesh position={position}>
            <boxGeometry args={size} />
            <meshStandardMaterial color={color} />
        </mesh>
    );
};

const Product = ({ position, size, color, label }) => {
    const mesh = useRef();

    useFrame(() => {
        mesh.current.rotation.y += 0.01;
    });

    return (
        <group position={position}>
            <mesh ref={mesh}>
                <boxGeometry args={size} />
                <meshStandardMaterial color={color} />
            </mesh>
            <Text
                position={[0, size[1] / 2 + 0.1, 0]}
                color="black"
                anchorX="center"
                anchorY="bottom"
                fontSize={0.15}
            >
                {label}
            </Text>
        </group>
    );
};

const Pharmacy3DView = ({ product }) => {
    const shelfColors = {
        A: '#FFA07A',
        B: '#98FB98',
        C: '#87CEFA',
        D: '#DDA0DD',
        E: '#F0E68C'
    };

    const shelfSize = [5, 3, 1];
    const cellSize = [0.8, 0.8, 0.8];
    const shelfPosition = [0, 1.5, 0];

    const getProductPosition = (shelfNumber, shelfLevel) => {
        const x = (shelfNumber.charCodeAt(0) - 65) * 1 - 2;
        const y = (shelfLevel - 1) * 0.9 + 0.4;
        return [x, y, 0.5];
    };

    return (
        <Canvas camera={{ position: [0, 2, 5], fov: 60 }} style={{ height: '600px' }}>
            <ambientLight intensity={0.5} />
            <pointLight position={[10, 10, 10]} />
            <OrbitControls />

            {/* Main shelf */}
            <Shelf position={shelfPosition} size={shelfSize} color="#8B4513" />

            {/* Shelf divisions */}
            {Object.keys(shelfColors).map((shelfLetter, index) => (
                <Shelf
                    key={shelfLetter}
                    position={[(index - 2) * 1, 1.5, 0]}
                    size={[0.9, 2.9, 0.9]}
                    color={shelfColors[shelfLetter]}
                />
            ))}

            {/* Product */}
            {product && (
                <Product
                    position={getProductPosition(product.shelfNumber, product.shelfLevel)}
                    size={cellSize}
                    color="red"
                    label={product.productName}
                />
            )}
        </Canvas>
    );
};

export default Pharmacy3DView;