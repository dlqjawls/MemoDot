package com.project.backend.common.util;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;


public final class CookieUtil {


    /**
     * request의 cookie에 accessToken이 있다면 반환
     * 없다면 null 반환
     * **/
    public static String extractCookieFromHttpServletRequest(HttpServletRequest request, String cookieName){

        if(request.getCookies() != null){
            Cookie[] cookies = request.getCookies();
            for(Cookie cookie : cookies){
                if(cookie.getName().equals(cookieName)){
                    return cookie.getValue();
                }
            }
        }
        return null;
    }
}

