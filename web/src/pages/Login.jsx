import React, { useEffect, useRef, useState } from 'react';
import * as THREE from 'three';
import { TextGeometry } from 'three/examples/jsm/geometries/TextGeometry';
import { FontLoader } from 'three/examples/jsm/loaders/FontLoader';
import { motion } from 'framer-motion';
import { SmileOutlined } from '@ant-design/icons';
import { notification } from "antd";
import useLogin from "@/hook/useLogin.jsx";

// Error Boundary Component
class ErrorBoundary extends React.Component {
    constructor(props) {
        super(props);
        this.state = { hasError: false };
    }

    static getDerivedStateFromError(error) {
        return { hasError: true };
    }

    componentDidCatch(error, errorInfo) {
        console.error("Caught an error:", error, errorInfo);
    }

    render() {
        if (this.state.hasError) {
            return <h1>Something went wrong. Please refresh the page.</h1>;
        }

        return this.props.children;
    }
}

// Three.js Component
const ThreeJSBackground = () => {
    const mountRef = useRef(null);

    useEffect(() => {
        let scene, camera, renderer, textMesh, starField;
        let isDragging = false;
        let previousMousePosition = { x: 0, y: 0 };

        const init = () => {
            scene = new THREE.Scene();
            camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
            renderer = new THREE.WebGLRenderer({ antialias: true });

            renderer.setSize(window.innerWidth, window.innerHeight);
            renderer.setClearColor(0x000000, 1);
            mountRef.current.appendChild(renderer.domElement);

            camera.position.z = 5;

            // Create stars
            const starsGeometry = new THREE.BufferGeometry();
            const starsMaterial = new THREE.PointsMaterial({ color: 0xFFFFFF, size: 0.02 });

            const starsVertices = [];
            for (let i = 0; i < 20000; i++) {
                const x = (Math.random() - 0.5) * 2000;
                const y = (Math.random() - 0.5) * 2000;
                const z = -Math.random() * 2000;
                starsVertices.push(x, y, z);
            }

            starsGeometry.setAttribute('position', new THREE.Float32BufferAttribute(starsVertices, 3));
            starField = new THREE.Points(starsGeometry, starsMaterial);
            scene.add(starField);

            // Create "medimate" text
            const loader = new FontLoader();
            loader.load('https://threejs.org/examples/fonts/helvetiker_regular.typeface.json', (font) => {
                const textGeometry = new TextGeometry('M E D I  M A T E', {
                    font: font,
                    size: 0.5,
                    height: 0.1,
                    curveSegments: 12,
                    bevelEnabled: true,
                    bevelThickness: 0.01,
                    bevelSize: 0.01,
                    bevelOffset: 0,
                    bevelSegments: 5
                });

                const textMaterial = new THREE.MeshPhongMaterial({
                    color: 0xFFFFFF,
                    emissive: 0x888888,
                    specular: 0xFFFFFF,
                    shininess: 100
                });
                textMesh = new THREE.Mesh(textGeometry, textMaterial);

                textGeometry.center();
                textMesh.position.x = -2; // Move text to the left side
                scene.add(textMesh);

                // Add directional light for better visibility
                const directionalLight = new THREE.DirectionalLight(0xFFFFFF, 1);
                directionalLight.position.set(5, 5, 5);
                scene.add(directionalLight);

                // Add ambient light
                const ambientLight = new THREE.AmbientLight(0xFFFFFF, 0.5);
                scene.add(ambientLight);
            });
        };

        const handleMouseDown = (event) => {
            isDragging = true;
            previousMousePosition = {
                x: event.clientX,
                y: event.clientY
            };
        };

        const handleMouseMove = (event) => {
            if (!isDragging) return;

            const deltaMove = {
                x: event.clientX - previousMousePosition.x,
                y: event.clientY - previousMousePosition.y
            };

            if (textMesh) {
                textMesh.rotation.y += deltaMove.x * 0.005;
                textMesh.rotation.x += deltaMove.y * 0.005;
            }

            previousMousePosition = {
                x: event.clientX,
                y: event.clientY
            };
        };

        const handleMouseUp = () => {
            isDragging = false;
        };

        const animate = () => {
            requestAnimationFrame(animate);
            if (starField) starField.rotation.y += 0.0003;
            if (textMesh) textMesh.rotation.y +=  0.004;
            renderer.render(scene, camera);
        };

        const handleResize = () => {
            camera.aspect = window.innerWidth / window.innerHeight;
            camera.updateProjectionMatrix();
            renderer.setSize(window.innerWidth, window.innerHeight);
        };

        init();
        animate();

        window.addEventListener('resize', handleResize);
        window.addEventListener('mousedown', handleMouseDown);
        window.addEventListener('mousemove', handleMouseMove);
        window.addEventListener('mouseup', handleMouseUp);

        return () => {
            window.removeEventListener('resize', handleResize);
            window.removeEventListener('mousedown', handleMouseDown);
            window.removeEventListener('mousemove', handleMouseMove);
            window.removeEventListener('mouseup', handleMouseUp);
            scene.remove(starField);
            scene.remove(textMesh);
            renderer.dispose();
            if (mountRef.current) {
                mountRef.current.removeChild(renderer.domElement);
            }
        };
    }, []);

    return <div ref={mountRef} style={{ position: 'absolute', top: 0, left: 0, width: '100%', height: '100%' }} />;
};

// Main Component
const InteractiveStarryLogin = () => {
    const {
        email, setEmail,
        password, setPassword,
        error,
        isLoading,
        handleSubmit
    } = useLogin();

    const [api, contextHolder] = notification.useNotification();

    const openNotification = (message) => {
        api.open({
            message: 'Login Error',
            description: message,
            icon: <SmileOutlined style={{ color: '#f5222d' }} />,
        });
    };

    useEffect(() => {
        if (error) {
            openNotification(error);
        }
    }, [error]);

    return (
        <ErrorBoundary>
            <div className="relative w-full h-screen">
                <ThreeJSBackground />
                <div className="absolute inset-0 flex items-center justify-center">
                    <div className="w-full flex justify-end pr-96">
                        <motion.div
                            initial={{ opacity: 0, x: 50 }}
                            animate={{ opacity: 1, x: 0 }}
                            transition={{ duration: 0.5 }}
                            className="w-full max-w-sm bg-black bg-opacity-50 p-6 rounded-lg backdrop-filter backdrop-blur-lg shadow-xl"
                            style={{ width: '25%' }}
                        >
                            <h2 className="text-2xl font-bold text-white mb-4 text-center">Login to Medimate</h2>
                            <form onSubmit={handleSubmit} className="space-y-4">
                                <div>
                                    <label htmlFor="email" className="block text-white mb-1 text-sm">Email</label>
                                    <input
                                        type="email"
                                        id="email"
                                        value={email}
                                        onChange={(e) => setEmail(e.target.value)}
                                        className="w-full px-3 py-2 bg-white bg-opacity-20 rounded text-white placeholder-gray-300 text-sm"
                                        placeholder="Enter your email"
                                        required
                                    />
                                </div>
                                <div>
                                    <label htmlFor="password" className="block text-white mb-1 text-sm">Password</label>
                                    <input
                                        type="password"
                                        id="password"
                                        value={password}
                                        onChange={(e) => setPassword(e.target.value)}
                                        className="w-full px-3 py-2 bg-white bg-opacity-20 rounded text-white placeholder-gray-300 text-sm"
                                        placeholder="Enter your password"
                                        required
                                    />
                                </div>
                                <button
                                    type="submit"
                                    className="w-full bg-blue-500 text-white py-2 rounded hover:bg-blue-600 transition duration-300 text-sm"
                                    disabled={isLoading}
                                >
                                    {isLoading ? 'Signing In...' : 'Sign In'}
                                </button>
                            </form>
                        </motion.div>
                    </div>
                </div>
                {contextHolder}
            </div>
        </ErrorBoundary>
    );
};

export default InteractiveStarryLogin;