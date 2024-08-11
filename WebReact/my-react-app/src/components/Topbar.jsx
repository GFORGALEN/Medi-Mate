import React from 'react';
import UserMenu from './UserMenu';

const Topbar = ({ toggleSidebar, isSidebarOpen }) => {
  return (
    <div className={`bg-white shadow h-16 flex items-center justify-between px-4 fixed top-0 ${isSidebarOpen ? 'left-64' : 'left-0'} right-0 transition-left duration-300 z-10`}>
      <button onClick={toggleSidebar} className="text-gray-500 hover:text-gray-700">
        <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
        </svg>
      </button>
      <UserMenu />
    </div>
  );
};

export default Topbar;
