import React from 'react';

const HeaderLayout = () => {
    return (
        <div className="flex-grow text-center py-4">
            <h1 className="text-4xl font-semibold text-gray-800 tracking-wide font-poppins">
                <span className="text-blue-600 font-bold ml-2">
                    Medimate
                </span>
                {' '}Management System 
            </h1>
        </div>
    );
};

export default HeaderLayout;