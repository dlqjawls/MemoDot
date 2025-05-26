package com.project.backend.domain.post.entity;

import com.project.backend.domain.base.CreateUpdateBaseTime;
import com.project.backend.domain.user.entity.User;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "posts")
public class Post extends CreateUpdateBaseTime {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "post_id")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "writer_id")
    private User writer;

    @Column(name = "title")
    private String title;

    @Column(name = "content")
    private String content;
}
