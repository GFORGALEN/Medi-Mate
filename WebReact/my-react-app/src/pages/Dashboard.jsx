import React, { useState } from 'react';
import Tesseract from 'tesseract.js';

const Dashboard = () => {
  const [selectedImage, setSelectedImage] = useState(null);
  const [ocrResult, setOcrResult] = useState('');
  const [drugInfo, setDrugInfo] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const handleImageChange = (event) => {
    const file = event.target.files[0];
    if (file) {
      setSelectedImage(URL.createObjectURL(file));
    }
  };

  const handleUpload = () => {
    if (selectedImage) {
      setIsLoading(true);
      Tesseract.recognize(
        selectedImage,
        'eng',
        {
          logger: (m) => console.log(m),
        }
      ).then(({ data: { text } }) => {
        console.log('OCR Result:', text);
        setOcrResult(text);
        queryChatGPT(text);
      }).catch((error) => {
        console.error('OCR Error:', error);
        setIsLoading(false);
      });
    }
  };

  const queryChatGPT = async (text) => {
    // 在这里实现调用ChatGPT API的逻辑
    const prompt = `根据以下识别出的文字信息提供药品的详细信息: ${text}`;

    try {
      const response = await fetch('/api/chatgpt', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ prompt }),
      });

      const data = await response.json();
      setDrugInfo(data.message); // 假设API返回的数据包含message字段
    } catch (error) {
      console.error('Error querying ChatGPT:', error);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="p-4">
      <h1 className="text-2xl font-bold mb-4">Dashboard</h1>

      <div className="mb-4">
        <label htmlFor="imageUpload" className="block text-sm font-medium text-gray-700">
          Upload an Image
        </label>
        <input
          type="file"
          id="imageUpload"
          accept="image/*"
          onChange={handleImageChange}
          className="mt-1 block w-full text-sm text-gray-900 border border-gray-300 rounded-lg cursor-pointer bg-gray-50 focus:outline-none focus:border-blue-500"
        />
      </div>

      {selectedImage && (
        <div className="mb-4">
          <img
            src={selectedImage}
            alt="Selected"
            className="max-w-full h-auto rounded-lg"
          />
        </div>
      )}

      <button
        onClick={handleUpload}
        className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
        disabled={isLoading}
      >
        {isLoading ? 'Processing...' : 'Upload and Recognize'}
      </button>

      {ocrResult && (
        <div className="mt-4">
          <h2 className="text-xl font-bold">OCR Result</h2>
          <p>{ocrResult}</p>
        </div>
      )}

      {drugInfo && (
        <div className="mt-4">
          <h2 className="text-xl font-bold">Drug Information</h2>
          <p>{drugInfo}</p>
        </div>
      )}
    </div>
  );
};

export default Dashboard;
