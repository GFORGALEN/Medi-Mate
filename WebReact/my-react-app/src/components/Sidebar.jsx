import React from 'react';
import { Link } from 'react-router-dom';

const Sidebar = ({ isOpen }) => {
  return (
    <div className={`bg-gray-800 text-white h-full flex flex-col ${isOpen ? 'block' : 'hidden'}`}>
      <div className="flex items-center justify-center h-16 border-b border-gray-700">
        <h1 className="text-2xl font-bold">Mantis</h1>
      </div>
      <nav className="flex-grow">
        <ul>
          <li className="hover:bg-gray-700">
            <Link to="/dashboard" className="block px-4 py-2">Dashboard</Link>
          </li>
          <li className="hover:bg-gray-700">
            <Link to="/settings" className="block px-4 py-2">Settings</Link>
          </li>
          <li className="hover:bg-gray-700">
            <Link to="/profile" className="block px-4 py-2">Profile</Link>
          </li>
        </ul>
      </nav>
      <div className="p-4 border-t border-gray-700">
        <Link to="/login" className="block text-center bg-red-600 py-2 rounded">Logout</Link>
      </div>
    </div>
  );
};

export default Sidebar;
