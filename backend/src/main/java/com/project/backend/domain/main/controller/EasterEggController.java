package com.project.backend.domain.main.controller;

import com.project.backend.domain.main.service.EasterEggService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/egs")
public class EasterEggController {

    private final EasterEggService easterEggService;

    /**
     * 이스터 에그 하나쯤 있어야겠지?
     * 우리 프로젝트에 이스터 에그가 빠지면 섭하지?
     * **/

    @GetMapping("/delete-random-user")
    public ResponseEntity<?> deleteRandomUser(){
        return easterEggService.deleteRandomUser();
    }
}
