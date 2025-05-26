package com.project.backend.common.filter;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.project.backend.common.util.JwtUtil;
import com.project.backend.domain.user.dto.req.LoginReqDto;
import com.project.backend.domain.user.entity.CustomUserDetails;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.AbstractAuthenticationProcessingFilter;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
@Slf4j
public class CustomLoginFilter extends AbstractAuthenticationProcessingFilter {

    private final String LOGIN_PATH = "/users/login";
    private final String LOGIN_METHOD = "POST";

    private final ObjectMapper objectMapper;
    private final StringRedisTemplate stringRedisTemplate;
    private final JwtUtil jwtUtil;

    private final AuthenticationManager authenticationManager;

    /** 생성자 **/
    public CustomLoginFilter(ObjectMapper objectMapper, AuthenticationManager authenticationManager, StringRedisTemplate stringRedisTemplate, JwtUtil jwtUtil) {
        super("/users/login", authenticationManager);
        this.objectMapper = objectMapper;
        this.authenticationManager = authenticationManager;
        this.stringRedisTemplate = stringRedisTemplate;
        this.jwtUtil = jwtUtil;
    }
    
    /**
     * 에러 시 
     * AuthenticationException
     * IOException
     * ServletException 발생
     * **/
    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException, IOException, ServletException {

        String requestUri = request.getRequestURI();
        String requestMethod = request.getMethod();

        // 로그인 경로, 메소드 일치 검증
        if(!requestUri.equalsIgnoreCase(LOGIN_PATH) || !requestMethod.equalsIgnoreCase(LOGIN_METHOD)){
            return null;
        }

        String username;
        String password;

        // LoginReqDto 파싱
        try{
            LoginReqDto dto = objectMapper.readValue(request.getInputStream(), LoginReqDto.class);
            username = dto.getUsername().replaceAll(" ", "");
            password = dto.getPassword().replaceAll(" ", "");
        }catch(Exception exception){
            response.setStatus(400);
            return null;
        }

        log.info("username : {}", username);
        log.info("password {} ", password);

        // security context에 저장할 token 생성
        UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(username, password);
        log.info("[CustomLoginFilter] authenticationManager");
        return this.authenticationManager.authenticate(authenticationToken);
    }
    
    /** 로그인 성공 시 핸들링 **/
    @Override
    protected void successfulAuthentication(HttpServletRequest request, HttpServletResponse response, FilterChain chain, Authentication authResult) throws IOException, ServletException {

        // userId 획득
        CustomUserDetails customUserDetails = (CustomUserDetails) authResult.getPrincipal();

        Long userId = customUserDetails.getId();

        // security context에 저장
        SecurityContextHolder.getContext().setAuthentication(new UsernamePasswordAuthenticationToken(userId, null));
        
        // access,refresh token 생성
        String accessToken = jwtUtil.generateAccessToken(userId);
        String refreshToken = jwtUtil.generateRefreshToken(userId);

        // refresh token 저장. 단, 기존의 토큰이 존재 한다면 삭제 후 저장
        String refreshTokenKey = String.format("refreshToken:%d", userId);
        stringRedisTemplate.opsForValue().set(refreshTokenKey, refreshToken);

        response.setStatus(200);
        response.setContentType("application/json");

        Cookie accessTokenCookie = new Cookie("accessToken", accessToken);
        Cookie refreshTokenCookie = new Cookie("refreshToken", refreshToken);

        accessTokenCookie.setPath("/");
        refreshTokenCookie.setPath("/");

        accessTokenCookie.setMaxAge(60 * 10);
        refreshTokenCookie.setMaxAge(60 * 60);

//        accessTokenCookie.setSecure(true);
//        refreshTokenCookie.setSecure(true);

//        accessTokenCookie.setHttpOnly(true);
//        refreshTokenCookie.setHttpOnly(true);

        response.addCookie(accessTokenCookie);
        response.addCookie(refreshTokenCookie);
    }

    /** 로그인 실패 시 핸들링 **/
    @Override
    protected void unsuccessfulAuthentication(HttpServletRequest request, HttpServletResponse response, AuthenticationException failed) throws IOException, ServletException {
        response.setStatus(401);
    }
}
