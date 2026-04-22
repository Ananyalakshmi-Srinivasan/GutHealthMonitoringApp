package com.example.gutapp.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class LoginResponse {
    private Long customerId;
    private String email;
    private String firstName;
}