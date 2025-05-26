package com.project.backend.common.util;

import com.project.backend.domain.user.entity.UserRoleType;
import io.jsonwebtoken.Jwts;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Date;

@Component
public class JwtUtil {
    
    /** 필드 **/
    private final Long ACCESS_TOKEN_EXPIRATION = 1000 * 60 * 10L; // 10분
    private final Long REFRESH_TOKEN_EXPIRATION = 1000 * 60 * 60L; // 60분

    private final SecretKey secretKey;
    private final String SECRET = "THISISNOTSECRETKEYTHISISNOTSECRETKEY";

    /** Parser **/
    public JwtUtil(){
        // 배포 시 EXPIRATION 필드들을 환경변수화 가능 + secret
        this.secretKey = new SecretKeySpec(SECRET.getBytes(StandardCharsets.UTF_8), Jwts.SIG.HS256.key().build().getAlgorithm());
    }
    
    /** 만료 여부 검증 **/
    public boolean isExpired(String token){
        return Jwts.parser().verifyWith(secretKey).build().parseSignedClaims(token).getPayload().getExpiration().before(new Date());
    }

    /** ID 획득 **/
    public Long getId(String token){
        return Jwts.parser().verifyWith(secretKey).build().parseSignedClaims(token).getPayload().get("id", Long.class);
    }
    /** ROLE 획득 **/
    public UserRoleType getRole(String token){
        return Jwts.parser().verifyWith(secretKey).build().parseSignedClaims(token).getPayload().get("role", UserRoleType.class);
    }





    /** Access Token 발급 **/
    public String generateAccessToken(Long id){
        return Jwts.builder()
                .claim("id", id)
                .issuer("337")
                .issuedAt(new java.sql.Date(System.currentTimeMillis()))
                .expiration(new java.sql.Date(System.currentTimeMillis() + ACCESS_TOKEN_EXPIRATION))
                .signWith(secretKey)
                .compact();
    }

    /** Refresh Token 발급 **/
    public String generateRefreshToken(Long id){
        return Jwts.builder()
                .claim("id", id)
                .issuer("337")
                .issuedAt(new java.sql.Date(System.currentTimeMillis()))
                .expiration(new java.sql.Date(System.currentTimeMillis() + REFRESH_TOKEN_EXPIRATION))
                .signWith(secretKey)
                .compact();
    }
}
