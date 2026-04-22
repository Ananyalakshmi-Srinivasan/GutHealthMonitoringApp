package com.example.gutapp.repository;

import com.example.gutapp.models.EmailDetails;
public interface EmailService {

    // Method to send simple email
    String sendSimpleMail(EmailDetails details);

    // Method to send email with attachment
    String sendMailWithAttachment(EmailDetails details);
}