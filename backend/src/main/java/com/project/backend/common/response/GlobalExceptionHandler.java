package com.project.backend.common.response;

import org.springframework.dao.InvalidDataAccessApiUsageException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.HttpMediaTypeNotAcceptableException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.server.MethodNotAllowedException;

@RestControllerAdvice
public class GlobalExceptionHandler {

    /**
     *
    @ExceptionHandler(HttpMediaTypeNotAcceptableException.class)
    public ResponseEntity<?> httpMediaTypeNotAcceptableExceptionHandler(HttpMediaTypeNotAcceptableException e){
        return new ResponseEntity<>(
                Message.HTTP_MEDIA_TYPE_NOT_ACCEPTABLE,
                HttpStatus.NOT_ACCEPTABLE
        );
    }

    @ExceptionHandler(MethodNotAllowedException.class)
    public ResponseEntity<?> MethodNotAllowedExceptionHandler(MethodNotAllowedException e){
        return new ResponseEntity<>(
                Message.METHOD_NOT_ALLOWED,
                HttpStatus.METHOD_NOT_ALLOWED
        );
    }


    @ExceptionHandler(InvalidDataAccessApiUsageException.class)
    public ResponseEntity<?> InvalidDataAccessApiUsageExceptionHandler(InvalidDataAccessApiUsageException e){
        return new ResponseEntity<>(
                Message.INVALID_DATA_ACCESS_API_USAGE,
                HttpStatus.BAD_REQUEST
        );
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<?> exceptionHandler(Exception e){
        return new ResponseEntity<>(
                Message.INTERNAL_SERVER_ERROR,
                HttpStatus.INTERNAL_SERVER_ERROR
        );
    }

    **/


    /**
     * 여기부터 범진이 커스텀 시작 
     * 메시지 = 범진이_잘못임_아무튼_무조건_범진이_잘못임
     * **/
    @ExceptionHandler(Exception.class)
    public ResponseEntity<?> exceptionHandler(Exception e){
        return new ResponseEntity<>(
                Message.범진이_잘못임_아무튼_무조건_범진이_잘못임,
                HttpStatus.INTERNAL_SERVER_ERROR
        );
    }

    @ExceptionHandler(HttpMediaTypeNotAcceptableException.class)
    public ResponseEntity<?> httpMediaTypeNotAcceptableExceptionHandler(HttpMediaTypeNotAcceptableException e){
        return new ResponseEntity<>(
                Message.범진이_잘못임_아무튼_무조건_범진이_잘못임,
                HttpStatus.NOT_ACCEPTABLE
        );
    }

    @ExceptionHandler(MethodNotAllowedException.class)
    public ResponseEntity<?> MethodNotAllowedExceptionHandler(MethodNotAllowedException e){
        return new ResponseEntity<>(
                Message.범진이_잘못임_아무튼_무조건_범진이_잘못임,
                HttpStatus.METHOD_NOT_ALLOWED
        );
    }


    @ExceptionHandler(InvalidDataAccessApiUsageException.class)
    public ResponseEntity<?> InvalidDataAccessApiUsageExceptionHandler(InvalidDataAccessApiUsageException e){
        return new ResponseEntity<>(
                Message.범진이_잘못임_아무튼_무조건_범진이_잘못임,
                HttpStatus.BAD_REQUEST
        );
    }
}
