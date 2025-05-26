package com.project.backend.domain.user.dto.req;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.validator.constraints.Length;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@Valid
public class LoginReqDto {

    @NotBlank
    @Length(min = 4, max = 16)
    private String username;

    @NotBlank
    @Length(min = 4, max = 16)
    private String password;
}
