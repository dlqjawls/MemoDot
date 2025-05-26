package com.project.backend.common.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.project.backend.common.filter.CustomLoginFilter;
import com.project.backend.common.filter.CustomLogoutFilter;
import com.project.backend.common.filter.JwtFilter;
import com.project.backend.common.util.JwtUtil;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.authentication.logout.LogoutFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;
import java.util.List;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

//    @Bean
//    public WebSecurityCustomizer webSecurityCustomizer() {
//        return (web) -> web.ignoring()
//                 Spring Security should completely ignore URLs starting with /resources/
//                .requestMatchers("/resources/**");
//    }
    
    /** 필드 **/
    private final AuthenticationConfiguration authenticationConfiguration;
    private final ObjectMapper objectMapper;
    private final JwtUtil jwtUtil;
    private final StringRedisTemplate stringRedisTemplate;

    /** 생성자 **/
    public SecurityConfig(AuthenticationConfiguration authenticationConfiguration, ObjectMapper objectMapper, JwtUtil jwtUtil, StringRedisTemplate stringRedisTemplate){
        this.authenticationConfiguration = authenticationConfiguration;
        this.objectMapper = objectMapper;
        this.jwtUtil = jwtUtil;
        this.stringRedisTemplate = stringRedisTemplate;
    }



    /** Filter Chain **/
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        
        // 필터 비활성화
        http.cors(AbstractHttpConfigurer::disable); // 개발용 임시 비활성화
//        http.cors(cors -> cors.configurationSource(corsConfigurationSource()));
        http.csrf(AbstractHttpConfigurer::disable);
        http.formLogin(AbstractHttpConfigurer::disable);
        http.httpBasic(AbstractHttpConfigurer::disable);
        http.sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS));

        /** 필더 추가 **/
        http.addFilterBefore(new JwtFilter(jwtUtil), UsernamePasswordAuthenticationFilter.class);
        http.addFilterAt(new CustomLoginFilter(objectMapper, authenticationManager(authenticationConfiguration), stringRedisTemplate, jwtUtil), UsernamePasswordAuthenticationFilter.class);
        http.addFilterAt(new CustomLogoutFilter(stringRedisTemplate), LogoutFilter.class);



        // 경로 권한 설정
        http.authorizeHttpRequests( auth -> auth
                // 회원가입, 로그인 경로 전체 허용
                .requestMatchers(HttpMethod.POST, "/users/join", "/users/login").permitAll()
                // 개발용 전체 경로 허용
                .requestMatchers("/**").permitAll()
        );
        return http.build();
    }
    
    /** CORS 설정 **/
    @Bean
    CorsConfigurationSource corsConfigurationSource(){
        CorsConfiguration corsConfiguration = new CorsConfiguration();
        corsConfiguration.setAllowedOriginPatterns(List.of("*")); // 개발용 임시 전체 허용
        corsConfiguration.setAllowedMethods(Arrays.asList("GET","POST","UPDATE","PATCH","DELETE","OPTIONS"));
        corsConfiguration.setAllowedHeaders(List.of("*")); // 개발용 임시 전체 허용
        corsConfiguration.setExposedHeaders(List.of("*")); // 개발용 임시 전체 허용
        corsConfiguration.setAllowCredentials(true);

        UrlBasedCorsConfigurationSource configurationSource = new UrlBasedCorsConfigurationSource();
        configurationSource.registerCorsConfiguration("/**", corsConfiguration);
        return configurationSource;
    }

    /** 비밀번호 암호화 **/
    @Bean
    BCryptPasswordEncoder bCryptPasswordEncoder(){
        return new BCryptPasswordEncoder();
    }

    /** AuthenticationManager 획득 **/
    @Bean
    AuthenticationManager authenticationManager(AuthenticationConfiguration authenticationConfiguration) throws Exception {
        return authenticationConfiguration.getAuthenticationManager();
    }

//    @Bean
//    CustomLoginFilter customLoginFilter() throws Exception {
//        CustomLoginFilter customLoginFilter = new CustomLoginFilter(objectMapper, authenticationManager(authenticationConfiguration), stringRedisTemplate, jwtUtil);
//        customLoginFilter.setAuthenticationManager(authenticationManager(authenticationConfiguration));
//        return customLoginFilter;
//    }
}
