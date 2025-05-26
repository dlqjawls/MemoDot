package com.project.backend.common.response;

import lombok.AllArgsConstructor;

@AllArgsConstructor
public class ResponseDto {

    private StatusCode statusCode;

    private Object message;
}
