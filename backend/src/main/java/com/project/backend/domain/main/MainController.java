package com.project.backend.domain.main;

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

    @GetMapping("")
    public ResponseEntity<?> home(){
        return ResponseEntity.ok("YB HOME PAGE");
    }
}
