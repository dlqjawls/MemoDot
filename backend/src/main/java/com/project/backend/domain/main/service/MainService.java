package com.project.backend.domain.main.service;

import com.project.backend.domain.user.entity.User;
import com.project.backend.domain.user.entity.UserRoleType;
import com.project.backend.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class MainService {

    private final UserRepository userRepository;
    private final BCryptPasswordEncoder encoder;


    /**
     * 관리자 생성
     * **/
    public ResponseEntity<?> registerAdmin() {
        User admin = new User();
//        admin.setId(Long.MAX_VALUE);
        admin.setRole(UserRoleType.ADMIN);
        admin.setUsername("admin");
        admin.setPassword(encoder.encode("admin"));
        //                Long.MAX_VALUE,

        User registeredAdmin = userRepository.save(admin);
        if(registeredAdmin.getId() == null){
            return new ResponseEntity<>("관리자 등록 실패", HttpStatus.BAD_REQUEST);
        }

        return new ResponseEntity<>("OK", HttpStatus.OK);
    }

}
