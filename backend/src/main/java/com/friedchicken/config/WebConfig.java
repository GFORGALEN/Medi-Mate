package com.friedchicken.config;


import com.friedchicken.interceptor.LoginInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Autowired
    private LoginInterceptor loginInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(loginInterceptor).excludePathPatterns(
                "/api/user/login"
                ,"/api/user/register"
                ,"/api/user/google-login"
                ,"/swagger-ui/index.html#"
                ,"/swagger-ui.html",
                "/v3/api-docs/**",
                "/swagger-resources/**",
                "/webjars/**",
                "/swagger-ui/**");
    }
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("http://localhost:5174")  // 允许来自这个前端的请求
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true);
    }

}
