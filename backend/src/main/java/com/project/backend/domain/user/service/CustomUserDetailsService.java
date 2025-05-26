package com.project.backend.domain.user.service;

import com.project.backend.domain.user.entity.CustomUserDetails;
import com.project.backend.domain.user.entity.User;
import com.project.backend.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    /**
     * 유저를 조회하여
     * CustomUserDetails 객체를 리턴
     * **/
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        
        // 유저 조회  
        Optional<User> optionalUser = userRepository.findByUsername(username);
        if(optionalUser.isEmpty()){
            User user = new User();
            user.setUsername("");
            user.setPassword("");
            return new CustomUserDetails(user);
        }
        User user = optionalUser.get();
        
        // userdetails 객체 리턴
        return new CustomUserDetails(user);
    }
}
