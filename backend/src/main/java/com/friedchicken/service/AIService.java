package com.friedchicken.service;

import com.friedchicken.pojo.dto.AI.AIimageDTO;
import com.friedchicken.pojo.vo.AI.AItextVO;

public interface AIService {
    AItextVO handlerText(String message);

    AItextVO analyzeImage(AIimageDTO aiimageDTO);
}
