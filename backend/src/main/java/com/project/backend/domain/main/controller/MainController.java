package com.project.backend.domain.main.controller;

import com.project.backend.domain.main.service.MainService;
import com.project.backend.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("")
public class MainController {

    private final MainService mainService;

    @GetMapping("")
    public ResponseEntity<?> home(){
        return ResponseEntity.ok("YB HOME PAGE");
    }

    @GetMapping("/register-admin")
    public ResponseEntity<?> registerAdmin(){
        return mainService.registerAdmin();
    }
}
