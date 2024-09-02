import React, { useState, useRef, useCallback, useEffect } from 'react';
import CameraIcon from '../../../assets/icons/camera.svg';
import Clipboard from '../../../assets/icons/clipboard.svg';

const PhotoCapture = () => {
  const [cameraState, setCameraState] = useState('closed');
  const [photoDataUrl, setPhotoDataUrl] = useState(null);
  const [error, setError] = useState(null);
  const [stream, setStream] = useState(null);
  const videoRef = useRef(null);
  const canvasRef = useRef(null);

  const openCamera = useCallback(async () => {
    try {
      console.log("Attempting to access camera...");
      const mediaStream = await navigator.mediaDevices.getUserMedia({ video: true });
      setStream(mediaStream);
      setCameraState('preview');
      console.log("Camera access granted");
    } catch (err) {
      console.error("Error accessing the camera:", err);
      setError(`无法访问摄像头: ${err.message}`);
    }
  }, []);

  useEffect(() => {
    if (cameraState === 'preview' && videoRef.current && stream) {
      videoRef.current.srcObject = stream;
    }
  }, [cameraState, stream]);

  const takePhoto = useCallback(() => {
    if (videoRef.current && canvasRef.current) {
      const context = canvasRef.current.getContext('2d');
      context.drawImage(videoRef.current, 0, 0, canvasRef.current.width, canvasRef.current.height);
      const dataUrl = canvasRef.current.toDataURL('image/jpeg');
      setPhotoDataUrl(dataUrl);
      setCameraState('captured');
      console.log("Photo captured");
    } else {
      console.error("Video or canvas ref is null");
      setError("无法捕获照片");
    }
  }, []);

  const retakePhoto = useCallback(() => {
    setPhotoDataUrl(null);
    setCameraState('preview');
    console.log("Retaking photo");
  }, []);

  const closeCamera = useCallback(() => {
    if (stream) {
      stream.getTracks().forEach(track => track.stop());
    }
    setStream(null);
    setPhotoDataUrl(null);
    setCameraState('closed');
    setError(null);
    console.log("Camera closed");
  }, [stream]);

  useEffect(() => {
    return () => {
      if (stream) {
        stream.getTracks().forEach(track => track.stop());
      }
    };
  }, [stream]);

  const savePhoto = useCallback(() => {
    if (photoDataUrl) {
      const link = document.createElement('a');
      link.href = photoDataUrl;
      link.download = 'photo.jpg';
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      console.log("Photo saved");
    }
  }, [photoDataUrl]);

  return (
    <div className="flex items-center justify-center min-h-screen bg-gray-100">
      <div className="space-y-4 sm:space-y-0 sm:space-x-4 flex flex-col sm:flex-row">
        <button
          onClick={cameraState === 'closed' ? openCamera : (cameraState === 'preview' ? takePhoto : retakePhoto)}
          className="w-40 h-40 bg-white text-gray-800 font-bold text-xl rounded-xl shadow-md focus:outline-none focus:ring-2 focus:ring-gray-300 transition duration-300 ease-in-out transform hover:scale-105 hover:bg-gray-50 flex flex-col items-center justify-center"
        >
          {cameraState === 'closed' && (
            <>
              <img src={CameraIcon} alt="Camera" className="w-20 h-20 mb-4" />
              <span>打开相机</span>
            </>
          )}
          {cameraState === 'preview' && <span>拍照</span>}
          {cameraState === 'captured' && <span>重拍</span>}
        </button>
        <button className="w-40 h-40 bg-white text-gray-800 font-bold text-xl rounded-xl shadow-md focus:outline-none focus:ring-2 focus:ring-gray-300 transition duration-300 ease-in-out transform hover:scale-105 hover:bg-gray-50 flex flex-col items-center justify-center">
          <img src={Clipboard} alt="Clipboard" className="w-20 h-20 mb-4" />
          <span>Record</span>
        </button>
      </div>
      {cameraState !== 'closed' && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center">
          <div className="bg-white p-4 rounded-lg max-w-lg w-full">
            {cameraState === 'preview' && stream && (
              <video ref={videoRef} autoPlay playsInline className="w-full mb-4 rounded" style={{display: 'block'}} />
            )}
            {cameraState === 'captured' && (
              <img src={photoDataUrl} alt="Captured" className="w-full mb-4 rounded" />
            )}
            <canvas ref={canvasRef} style={{ display: 'none' }} width="640" height="480" />
            <div className="flex justify-center space-x-4">
              {cameraState === 'captured' && (
                <button onClick={savePhoto} className="px-4 py-2 bg-green-500 text-white rounded hover:bg-green-600">
                  保存照片
                </button>
              )}
              <button onClick={closeCamera} className="px-4 py-2 bg-red-500 text-white rounded hover:bg-red-600">
                关闭相机
              </button>
            </div>
            {error && <div className="mt-4 text-red-500">{error}</div>}
            <div className="mt-4 text-sm text-gray-600">
              Camera State: {cameraState}<br />
              Video Ref: {videoRef.current ? 'Available' : 'Not Available'}<br />
              Stream: {stream ? 'Available' : 'Not Available'}
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default PhotoCapture;