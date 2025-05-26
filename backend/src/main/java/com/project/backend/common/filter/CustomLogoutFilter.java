package com.project.backend.common.filter;

import com.project.backend.common.util.CookieUtil;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.GenericFilterBean;

import java.io.IOException;

@Component
public class CustomLogoutFilter extends GenericFilterBean {

    private final String LOGOUT_PATH = "/users/logout";
    private final String LOGOUT_METHOD = "POST";

    private final StringRedisTemplate stringRedisTemplate;
    private static CookieUtil cookieUtil;

    public CustomLogoutFilter(StringRedisTemplate stringRedisTemplate) {
        this.stringRedisTemplate = stringRedisTemplate;
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        filter((HttpServletRequest) request, (HttpServletResponse) response, chain);
    }

    public void filter(HttpServletRequest request, HttpServletResponse response, FilterChain chain) throws ServletException, IOException {
        
        // 로그아웃 경로, 메서드 확인
        if(!request.getRequestURI().equalsIgnoreCase(LOGOUT_PATH) || !request.getMethod().equalsIgnoreCase(LOGOUT_METHOD)){
            chain.doFilter(request, response);
            return;
        }
        
        // 쿠키에서 리프레시 토큰 획득
        String refreshTokenFromCookie = CookieUtil.extractCookieFromHttpServletRequest(request, "refreshToken");
        if(refreshTokenFromCookie == null){
            response.setStatus(401);
            return;
        }

        // Security Context에서 userId 획득
        Long userId = (Long) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if(userId == null){
            chain.doFilter(request, response);
            return;
        }

        // freshTokenKey 빌드
        String refreshTokenKey = String.format("refreshToken:%d",userId);
        // redis에 refreshToken이 없으면 리턴
        if(!stringRedisTemplate.delete(refreshTokenKey)){
          chain.doFilter(request, response);
          return;
        }

        chain.doFilter(request, response);
    }
}
