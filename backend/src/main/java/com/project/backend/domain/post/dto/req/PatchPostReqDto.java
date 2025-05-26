package com.project.backend.domain.post.dto.req;

import com.project.backend.domain.post.entity.Post;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Valid
public class PatchPostReqDto {

    @Positive
    @NotNull
    private Long postId;

    @NotBlank
    @Size(min = 0, max = 200)
    private String title;

    @NotBlank
    @Size(min = 0, max = 200)
    private String content;

    public static Post toUpdatedPost(PatchPostReqDto dto, Post postToUpdate){
        postToUpdate.setTitle(dto.getTitle());
        postToUpdate.setContent(dto.getContent());
        return postToUpdate;
    }
}
