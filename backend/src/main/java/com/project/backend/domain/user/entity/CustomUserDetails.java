package com.project.backend.domain.user.entity;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;

@RequiredArgsConstructor
public class CustomUserDetails implements UserDetails {

    private final User user;

    public UserRoleType getRole(){
        return user.getRole();
    }

    public Long getId(){
        return user.getId();
    }

    @Override
    public String getUsername() {
        return user.getUsername();
    }



    /** 사용하지 않음 **/

    @Override
    public String getPassword() {
        return user.getPassword();
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return null;
    }
}
