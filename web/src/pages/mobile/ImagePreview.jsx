import React from 'react';
import { uploadImage } from './ImageApi';

const ImagePreview = ({ imageBlob, onRetake, uploading, setUploading, setUploadStatus }) => {
  const handleUpload = async () => {
    setUploading(true);
    setUploadStatus(null);

    try {
      await uploadImage(imageBlob);
      setUploadStatus('上传成功');
    } catch (error) {
      console.error('上传过程中出现错误:', error);
      if (error.response && error.response.status === 500) {
        setUploadStatus('服务器内部错误，请稍后重试');
      } else {
        setUploadStatus(`上传失败: ${error.message}`);
      }
    } finally {
      setUploading(false);
    }
  };

  return (
    <div className="relative w-full aspect-square mb-4">
      <img 
        src={URL.createObjectURL(imageBlob)} 
        alt="Captured" 
        className="rounded-xl w-full h-full object-cover" 
      />
      <div className="absolute bottom-4 left-1/2 transform -translate-x-1/2 flex space-x-2">
        <button
          onClick={onRetake}
          className="bg-white text-gray-800 font-bold px-4 py-2 rounded-full shadow-md text-sm"
        >
          重拍
        </button>
        <button
          onClick={handleUpload}
          disabled={uploading}
          className="bg-blue-500 text-white font-bold px-4 py-2 rounded-full shadow-md text-sm disabled:bg-gray-400"
        >
          {uploading ? '上传中...' : '上传'}
        </button>
      </div>
    </div>
  );
};

export default ImagePreview;