package com.friedchicken.service;

import com.friedchicken.pojo.dto.AI.AIimageDTO;
import com.friedchicken.pojo.vo.AI.AItextVO;

public interface AiService {
    AItextVO handlerText(String message);

    AItextVO analyzeImageUrl(AIimageDTO aiimageDTO);

    AItextVO analyzeImage(byte[] imageData);
}
