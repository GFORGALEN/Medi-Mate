import { useState } from 'react';
import { getPharmaciesAPI } from "@/api/user/pharmacy.jsx";

const TestPharmacies = () => {
    const [result, setResult] = useState(null);
    const [error, setError] = useState(null);

    const handleFetchPharmacies = async () => {
        try {
            setError(null);
            setResult(null);
            console.log('Fetching pharmacies...');
            const response = await getPharmaciesAPI();
            console.log('API Response:', response);
            setResult(JSON.stringify(response, null, 2));
        } catch (err) {
            console.error('Error fetching pharmacies:', err);
            setError(err.message || 'An error occurred');
        }
    };

    return (
        <div style={{ padding: '20px' }}>
            <h1>Test Pharmacies API</h1>
            <button onClick={handleFetchPharmacies} style={{ marginBottom: '20px' }}>
                Fetch Pharmacies
            </button>
            {error && (
                <div style={{ color: 'red', marginBottom: '20px' }}>
                    Error: {error}
                </div>
            )}
            {result && (
                <pre style={{ background: '#f0f0f0', padding: '10px', borderRadius: '5px' }}>
                    {result}
                </pre>
            )}
        </div>
    );
};

export default TestPharmacies;