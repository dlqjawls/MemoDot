package com.project.backend.domain.user.controller;

import com.project.backend.domain.user.dto.req.JoinReqDto;
import com.project.backend.domain.user.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;
    
    /**
     * 회원가입
     * **/
    @PostMapping("/join")
    public ResponseEntity<?> join(@Valid @RequestBody JoinReqDto dto){
        return userService.join(dto);
    }

    /**
     * accessToken 재발급
     * **/

}
