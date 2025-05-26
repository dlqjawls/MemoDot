package com.project.backend.domain.post.dto.res;

import com.project.backend.domain.post.entity.Post;
import com.project.backend.domain.user.dto.res.UserDto;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Valid
public class PostDto {

    private Long id;

    private String title;

    private String content;

    private UserDto writer;
    public static PostDto toPostDto(Post post){
        return new PostDto(
                post.getId(),
                post.getTitle(),
                post.getContent(),
                UserDto.toUserDto(post.getWriter())
        );
    }
}
