import axios from 'axios';
import { dataURItoBlob } from '@/utils/dataURItoBlob.jsx';
import {APP_API_URL} from "@/../config.js";

export const uploadImage = async (imageBlob) => {
  const formData = new FormData();
  formData.append('file', imageBlob, 'image.jpg');

  try {
    const response = await axios.post(`${APP_API_URL}/message/image`, formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    });
    console.log('上传成功:', response.data);
    return response.data;
  } catch (error) {
    console.error('上传错误:', error);
    if (error.response) {
      console.error('错误响应数据:', error.response.data);
      console.error('错误响应状态:', error.response.status);
      throw new Error(`上传失败: ${error.response.data.message || JSON.stringify(error.response.data) || '未知错误'}`);
    } else if (error.request) {
      console.error('没有收到服务器响应:', error.request);
      throw new Error('服务器没有响应，请稍后重试');
    } else {
      console.error('请求设置错误:', error.message);
      throw new Error(`请求设置错误: ${error.message}`);
    }
  }
};