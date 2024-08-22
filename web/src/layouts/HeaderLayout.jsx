import React from 'react';

const HeaderLayout = () => {
    return (
        <div className="flex-grow text-center py-4">
            <h1 className="text-3xl font-semibold text-gray-800 tracking-wide">
                Welcome to
                <span className="text-blue-600 font-bold ml-2">
                    Medimate
                </span>
            </h1>
            <p className="text-lg text-gray-600 mt-2 font-light">
                Medicines Management System
            </p>
        </div>
    );
};

export default HeaderLayout;