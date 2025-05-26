package com.project.backend.domain.user.service;

import com.project.backend.domain.user.dto.req.JoinReqDto;
import com.project.backend.domain.user.entity.User;
import com.project.backend.domain.user.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final BCryptPasswordEncoder encoder;

    /** 회원가입 **/
    @Transactional
    public ResponseEntity<?> join(JoinReqDto dto) {
        
        // 유저네임 존재 여부 검증
        if(userRepository.existsByUsername(dto.getUsername())){
//            return new ResponseDto(StatusCode.BAD_REQUEST, Message.USER_ALREADY_EXISTS);
            return new ResponseEntity<>("USER_ALREADY_EXISTS", HttpStatus.BAD_REQUEST);
        }
        
        // 비밀번호 일치 여부 검증
        if(!dto.getPassword().equals(dto.getPasswordCheck())){
//            return new ResponseDto(StatusCode.BAD_REQUEST, Message.PASSWORD_NOT_MATCHES);
            return new ResponseEntity<>("PASSWORD_NOT_MATCHES", HttpStatus.BAD_REQUEST);
        }

        // 유저 빌드 및 저장
        User newUser = JoinReqDto.toNewUser(dto, encoder);
        userRepository.save(newUser);

        // 응답
//        return new ResponseDto(StatusCode.OK, Message.OK);
        return new ResponseEntity<>("OK", HttpStatus.OK);
    }
}
