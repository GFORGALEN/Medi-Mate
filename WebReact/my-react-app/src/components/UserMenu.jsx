import React, { useState } from 'react';

function UserMenu() {
  const [isOpen, setIsOpen] = useState(false);

  const toggleMenu = () => {
    setIsOpen(!isOpen);
  };

  return (
    <div className="relative">
      <button onClick={toggleMenu} className="focus:outline-none">
        <span className="text-gray-400 hover:text-white">User</span>
      </button>
      {isOpen && (
        <div className="absolute right-0 mt-2 w-48 bg-white text-black rounded shadow-lg">
          <a href="/profile" className="block px-4 py-2 hover:bg-gray-100">Profile</a>
          <a href="/Settings" className="block px-4 py-2 hover:bg-gray-100">Settings</a>
          <a href="/login" className="block px-4 py-2 text-red-600 hover:bg-gray-100">Logout</a>
        </div>
      )}
    </div>
  );
}

export default UserMenu;
