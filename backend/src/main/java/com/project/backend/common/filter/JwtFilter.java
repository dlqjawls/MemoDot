package com.project.backend.common.filter;

import com.project.backend.common.util.CookieUtil;
import com.project.backend.common.util.JwtUtil;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Arrays;

@Component
public class JwtFilter extends OncePerRequestFilter {

    private static final String[] PUBLIC_URL = {"/users/login", "/users/join", "/k6/gen-script"};

    private final JwtUtil jwtUtil;

    public JwtFilter(JwtUtil jwtUtil) {
        this.jwtUtil = jwtUtil;
    }
    
    /** 필터링 여부 검증 **/
    public static boolean isPublicUrl(HttpServletRequest request){
        String requestUrl = request.getRequestURI();
        return Arrays.stream(PUBLIC_URL).anyMatch(url -> url.equalsIgnoreCase(requestUrl));
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {

        // PUBLIC_URL 에 속하면 필터 패스
        if(isPublicUrl(request)){
            filterChain.doFilter(request, response);
            return;
        }


//        if(request.getCookies() != null){
//            Cookie[] cookies = request.getCookies();
//            for(Cookie cookie : cookies){
//                if(cookie.getName().equals("accessToken")){
//                    System.out.println("accessToken Value : " + cookie.getValue());
//                }
//                System.out.println("cookie name " + cookie.getName());
//                System.out.println("cookie value " + cookie.getValue());
//            }
//        }




        // accessToken Parse
//        String authToken = request.getHeader("Authorization"); // Bearer 로 시작하지 않음을 전제, Bearer 로 시작 시 파싱 로직 추가
        String accessToken = CookieUtil.extractCookieFromHttpServletRequest(request, "accessToken");


        // authToken 검증
        if(accessToken == null || jwtUtil.isExpired(accessToken)){
            filterChain.doFilter(request, response);
            return;
        }

        // userId 파싱
        Long userId = jwtUtil.getId(accessToken);

        // security Context에 담을 토큰 생성
        UsernamePasswordAuthenticationToken usernamePasswordAuthenticationToken =
                new UsernamePasswordAuthenticationToken(userId, null);

        // Security Context에 저장
        SecurityContextHolder.getContext().setAuthentication(usernamePasswordAuthenticationToken);

//        usernamePasswordAuthenticationToken.setDetails();  // 필요 시 추가 유저 정보 저장

        // Invoke Next Filter
        filterChain.doFilter(request, response);
    }
}
