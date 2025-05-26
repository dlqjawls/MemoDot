package com.project.backend.domain.user.dto.res;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.project.backend.domain.user.entity.User;
import com.project.backend.domain.user.entity.UserRoleType;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Valid
public class UserDto {

    private Long id;

    private String username;

    private UserRoleType role;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createdAt;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updatedAt;

    public static UserDto toUserDto(User user){
        UserDto dto = new UserDto(
                user.getId(),
                user.getUsername(),
                user.getRole(),
                user.getCreatedAt(),
                user.getUpdatedAt()
        );
        return dto;
    }
}
