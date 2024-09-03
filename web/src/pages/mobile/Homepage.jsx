import React, { useState } from 'react';
import WebcamCapture from './WebcamCapture';
import ImagePreview from './ImagePreview';
import CameraIcon from '../../../assets/icons/camera.svg';
import Clipboard from '../../../assets/icons/clipboard.svg';

const PhotoCapture = () => {
  const [showCamera, setShowCamera] = useState(false);
  const [capturedImage, setCapturedImage] = useState(null);
  const [uploading, setUploading] = useState(false);
  const [uploadStatus, setUploadStatus] = useState(null);

  const handleCapture = (imageSrc) => {
    setCapturedImage(imageSrc);
    setShowCamera(false);
  };

  const handleRetake = () => {
    setCapturedImage(null);
    setUploadStatus(null);
  };

  return (
    <div className="flex items-center justify-center min-h-screen bg-gray-100 p-4">
      <div className="w-full max-w-md">
        {showCamera ? (
          <WebcamCapture onCapture={handleCapture} />
        ) : capturedImage ? (
          <ImagePreview 
            imageSrc={capturedImage} 
            onRetake={handleRetake}
            uploading={uploading}
            setUploading={setUploading}
            setUploadStatus={setUploadStatus}
          />
        ) : (
          <div className="grid grid-cols-2 gap-4">
            <button
              onClick={() => setShowCamera(true)}
              className="aspect-square bg-white text-gray-800 font-bold text-lg rounded-xl shadow-md focus:outline-none focus:ring-2 focus:ring-gray-300 transition duration-300 ease-in-out transform hover:scale-105 hover:bg-gray-50 flex flex-col items-center justify-center"
            >
              <img src={CameraIcon} alt="Camera" className="w-1/2 h-1/2 mb-2" />
              <span>打开相机</span>
            </button>
            <button className="aspect-square bg-white text-gray-800 font-bold text-lg rounded-xl shadow-md focus:outline-none focus:ring-2 focus:ring-gray-300 transition duration-300 ease-in-out transform hover:scale-105 hover:bg-gray-50 flex flex-col items-center justify-center">
              <img src={Clipboard} alt="Clipboard" className="w-1/2 h-1/2 mb-2" />
              <span>Record</span>
            </button>
          </div>
        )}
        {uploadStatus && (
          <div className={`mt-4 p-2 rounded ${uploadStatus === '上传成功' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}`}>
            {uploadStatus}
          </div>
        )}
      </div>
    </div>
  );
};

export default PhotoCapture;