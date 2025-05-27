package com.project.backend.domain.main.service;

import com.project.backend.domain.user.entity.User;
import com.project.backend.domain.user.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.Random;

@Service
@RequiredArgsConstructor
@Slf4j
public class EasterEggService {

    private final UserRepository userRepository;

    /**
     * 랜덤 유저 삭제
     * **/
    @Transactional
    public ResponseEntity<?> deleteRandomUser() {

        Random random = new Random();

        long total = userRepository.count();
        if (total == 0) {
            return new ResponseEntity<>("NO_USER", HttpStatus.NOT_FOUND);
        }

        int offset = random.nextInt((int)total);
        Page<User> page = userRepository.findAll(PageRequest.of(offset, 1));
        page.getContent()
                .stream()
                .findFirst()
                .ifPresent(userRepository::delete);

        return new ResponseEntity<>("DELETED", HttpStatus.OK);
    }
}
