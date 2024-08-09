package com.friedchicken.service;

import com.friedchicken.pojo.vo.AI.AItextVO;

public interface AIService {
    AItextVO handlerText(String message);
}
