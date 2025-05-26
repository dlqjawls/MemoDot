package com.project.backend.domain.post.controller;

import com.project.backend.domain.post.dto.req.CreatePostReqDto;
import com.project.backend.domain.post.dto.req.PatchPostReqDto;
import com.project.backend.domain.post.dto.res.PostDto;
import com.project.backend.domain.post.service.PostService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/posts")
@RequiredArgsConstructor
public class PostController {

    private final PostService postService;

    /** 특정 게시물 조회 **/
    @GetMapping("/{postId}")
    public ResponseEntity<Object> getPostOfUser(@AuthenticationPrincipal Long userId,
                                                    @PathVariable("postId") Long postId){
        return postService.getPostOfUser(userId, postId);
    }

    /** 유저의 모든 게시물 조회 **/
    @GetMapping("/all-post-of-user")
    public ResponseEntity<List<PostDto>> allPostOfUser(@AuthenticationPrincipal Long userId){
        return postService.allPostOfUser(userId);
    }
    
    /** 새 게시물 생성 **/
    @PostMapping("")
    public ResponseEntity<?> createPost(@AuthenticationPrincipal Long userId,
                                  @Valid @RequestBody CreatePostReqDto dto){
        return postService.createPost(userId, dto);
    }

    /** 기존 게시물 수정 **/
    @PutMapping("")
    public ResponseEntity<?> updatePost(@AuthenticationPrincipal Long userId,
                                  @Valid @RequestBody PatchPostReqDto dto){
        return postService.updatePost(userId, dto);
    }

    /** 기존 게시물 삭제 **/
    @DeleteMapping("/{postId}")
    public ResponseEntity<?> deletePost(@AuthenticationPrincipal Long userId,
                                 @PathVariable("postId") Long postId){
        return postService.deletePost(userId, postId);
    }
}
