package com.project.backend.domain.post.dto.res;


import com.fasterxml.jackson.annotation.JsonFormat;
import com.project.backend.domain.post.entity.Post;
import com.project.backend.domain.user.dto.res.UserDto;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
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
public class GetPostResDto {

    @NotNull
    private Long id;

    @NotNull
    private UserDto writer;

    @NotNull
    private String title;

    @NotNull
    private String content;

    @NotNull
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createdAt;

    @NotNull
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updatedAt;

    public static GetPostResDto toPost(Post post){
            GetPostResDto dto = new GetPostResDto(
                    post.getId(),
                    UserDto.toUserDto(post.getWriter()),
                    post.getTitle(),
                    post.getContent(),
                    post.getCreatedAt(),
                    post.getUpdatedAt()
            );
            return dto;
        }
}
