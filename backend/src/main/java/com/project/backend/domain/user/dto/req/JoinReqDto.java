package com.project.backend.domain.user.dto.req;

import com.project.backend.domain.user.entity.User;
import com.project.backend.domain.user.entity.UserRoleType;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.validator.constraints.Length;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@Valid
public class JoinReqDto {

    @NotBlank
    @Length(min = 4, max = 16)
    private String username;

    @NotBlank
    @Length(min = 4, max = 16)
    private String password;

    @NotBlank
    @Length(min = 4, max = 16)
    private String passwordCheck;

    public static User toNewUser(JoinReqDto dto, BCryptPasswordEncoder encoder) {
        User newUser = new User();
        newUser.setUsername(dto.getUsername());
        newUser.setPassword(encoder.encode(dto.getPassword()));
        newUser.setRole(UserRoleType.USER);
        return newUser;
    }
}
