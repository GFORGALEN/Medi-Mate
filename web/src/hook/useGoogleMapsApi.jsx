import { useState, useEffect } from 'react';
import { GOOGLE_MAPS_API_KEY } from '@/../config.js';

const useGoogleMapsApi = () => {
    const [isLoaded, setIsLoaded] = useState(false);

    useEffect(() => {
        if (!window.google) {
            const script = document.createElement('script');
            script.src = `https://maps.googleapis.com/maps/api/js?key=${GOOGLE_MAPS_API_KEY}`;
            script.async = true;
            script.onload = () => setIsLoaded(true);
            script.onerror = () => {
                console.error('Failed to load Google Maps API');
                setIsLoaded(false);
            };
            document.body.appendChild(script);
        } else {
            setIsLoaded(true);
        }
    }, []);

    return isLoaded;
};

export default useGoogleMapsApi;