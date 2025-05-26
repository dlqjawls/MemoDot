package com.project.backend.domain.post.dto.req;

import com.project.backend.domain.post.entity.Post;
import com.project.backend.domain.user.entity.User;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Valid
public class CreatePostReqDto {

    @NotBlank
    private String title;

    @NotBlank
    private String content;

    public static Post toPost(CreatePostReqDto dto, User user){
        Post post = new Post();
        post.setTitle(dto.getTitle());
        post.setContent(dto.getContent());
        post.setWriter(user);
        return post;
    }
}
