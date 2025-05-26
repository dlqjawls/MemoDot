package com.project.backend.domain.post.service;

import com.project.backend.common.response.Message;
import com.project.backend.domain.post.dto.req.CreatePostReqDto;
import com.project.backend.domain.post.dto.req.PatchPostReqDto;
import com.project.backend.domain.post.dto.res.GetPostResDto;
import com.project.backend.domain.post.dto.res.PostDto;
import com.project.backend.domain.post.entity.Post;
import com.project.backend.domain.post.repository.PostRepository;
import com.project.backend.domain.user.entity.User;
import com.project.backend.domain.user.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Slf4j
@RequiredArgsConstructor
public class PostService {

    private final PostRepository postRepository;
    private final UserRepository userRepository;

    /**
     * 특정 게시물 조회
     * 글의 작성자 유무 확인
     *
     * **/
    public ResponseEntity<Object> getPostOfUser(Long userId, Long postId) {
        log.info("userId : {}, postId : {}", userId, postId);



        // 게시물 조회
        Optional<Post> optionalPost = postRepository.findById(postId);
        if(optionalPost.isEmpty()){
            return new ResponseEntity<>("POST_NOT_FOUND", HttpStatus.NOT_FOUND);
        }
        Post post = optionalPost.get();

        // 작성자 유무 검증
        if(!post.getWriter().getId().equals(userId)){
            return new ResponseEntity<>("NOT_POST_WRITER", HttpStatus.BAD_REQUEST);
        }

        // 반환
        return new ResponseEntity<>(GetPostResDto.toPost(post), HttpStatus.OK);

    }

    /** 유저의 모든 게시물 조회 **/
    public ResponseEntity<List<PostDto>> allPostOfUser(Long userId) {
        log.info("userId : {}", userId);

        return new ResponseEntity<>(postRepository.findByWriter_Id(userId).stream().map(PostDto::toPostDto).collect(Collectors.toList()), HttpStatus.OK);
    }


    /** 게시글 생성 **/
    @Transactional
    public ResponseEntity<Object> createPost(Long userId, CreatePostReqDto dto) {
        log.info("userId : {}, title : {}, content : {}", userId, dto.getTitle(), dto.getContent());

        // 유저 조회 검증
        Optional<User> optionalUser = userRepository.findById(userId);
        if(optionalUser.isEmpty()){
            return new ResponseEntity<>(Message.USER_NOT_FOUND, HttpStatus.NOT_FOUND);

        }
        User user = optionalUser.get();
        
        // 새로운 게시물 빌드 및 저장
        Post newPost = CreatePostReqDto.toPost(dto, user);
        postRepository.save(newPost);
        // 응답
        return new ResponseEntity<>(Message.OK, HttpStatus.OK);
    }

    /** 게시글 수정 **/
    @Transactional
    public ResponseEntity<?> updatePost(Long userId, PatchPostReqDto dto) {
        log.info("userId : {}, postId : {},  title : {}, content : {}", userId, dto.getPostId(), dto.getTitle(), dto.getContent());

        // 게시글 조회 검증
        Optional<Post> optionalPost = postRepository.findById(dto.getPostId());
       if(optionalPost.isEmpty()){
           return new ResponseEntity<>(Message.USER_NOT_FOUND, HttpStatus.NOT_FOUND);
       }
       Post originalPost = optionalPost.get();
       
       // 게시글 작성자 여부 검증
        if(!originalPost.getWriter().getId().equals(userId)){
            return new ResponseEntity<>(Message.NOT_WRITER_OF_THIS_POST, HttpStatus.BAD_REQUEST);
        }

        // 수정할 게시글 빌드 및 저장
       Post postToUpdate = PatchPostReqDto.toUpdatedPost(dto, originalPost);
       postRepository.save(postToUpdate);

       // 응답
        return new ResponseEntity<>(Message.OK, HttpStatus.OK);
    }
    
    /** 게시글 삭제 **/
    @Transactional
    public ResponseEntity<?> deletePost(Long userId, Long postId) {
        log.info("userId : {}, postId : {}", userId, postId);

        // 게시글 조회 검증
        Optional<Post> optionalPost = postRepository.findById(postId);
        if(optionalPost.isEmpty()){
            return new ResponseEntity<>(Message.POST_NOT_FOUND, HttpStatus.NOT_FOUND);
        }
        Post postToDelete = optionalPost.get();

        // 게시글 작성자 여부 검증
        if(!postToDelete.getWriter().getId().equals(userId)){
            return new ResponseEntity<>(Message.NOT_WRITER_OF_THIS_POST, HttpStatus.BAD_REQUEST);
        }

        // 게시글 삭제
        postRepository.delete(postToDelete);

        // 응답
        return new ResponseEntity<>(Message.OK, HttpStatus.OK);
    }

}
