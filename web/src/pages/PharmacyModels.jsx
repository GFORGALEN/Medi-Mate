import React, { useRef, useEffect } from 'react';
import { useFrame, useLoader } from '@react-three/fiber';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';

const createPharmacyModel = (modelPath, scale = [1, 1, 1], position = [0, -1, 0]) => {
    return () => {
        const groupRef = useRef();
        const gltf = useLoader(GLTFLoader, modelPath);

        useFrame(() => {
            if (groupRef.current) {
                groupRef.current.rotation.y += 0.005;
            }
        });

        useEffect(() => {
            if (gltf.scene) {
                gltf.scene.scale.set(...scale);
                gltf.scene.position.set(...position);
            }
        }, [gltf]);

        return (
            <group ref={groupRef}>
                <primitive object={gltf.scene} />
            </group>
        );
    };
};

export const PharmacyModel1 = createPharmacyModel('assets/models/pharmacy7.glb');
export const PharmacyModel2 = createPharmacyModel('assets/models/pharmacy5.glb');
export const PharmacyModel3 = createPharmacyModel('assets/models/pharmacy3.glb');
export const PharmacyModel4 = createPharmacyModel('assets/models/pharmacy4.glb', [2, 2, 2], [0, -0.75, 0]);
export const PharmacyModel5 = createPharmacyModel('assets/models/pharmacy2.glb', [3, 3, 3]);

export const ModelComponents = [PharmacyModel1, PharmacyModel2, PharmacyModel3, PharmacyModel4, PharmacyModel5];