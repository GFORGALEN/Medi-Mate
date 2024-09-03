import React, { useRef, useCallback } from 'react';
import Webcam from 'react-webcam';

const WebcamCapture = ({ onCapture }) => {
  const webcamRef = useRef(null);

  const capture = useCallback(async () => {
    const imageSrc = webcamRef.current.getScreenshot();
    // 将 base64 转换为 Blob
    const res = await fetch(imageSrc);
    const blob = await res.blob();
    onCapture(blob);
  }, [onCapture]);

  return (
    <div className="relative w-full aspect-square mb-4">
      <Webcam
        audio={false}
        ref={webcamRef}
        screenshotFormat="image/jpeg"
        className="rounded-xl w-full h-full object-cover"
      />
      <button
        onClick={capture}
        className="absolute bottom-4 left-1/2 transform -translate-x-1/2 bg-white text-gray-800 font-bold px-4 py-2 rounded-full shadow-md text-sm"
      >
        拍照
      </button>
    </div>
  );
};

export default WebcamCapture;