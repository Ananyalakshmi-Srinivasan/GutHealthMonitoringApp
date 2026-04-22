package com.example.gutapp.controllers;

import com.example.gutapp.service.NotificationService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {

    private final NotificationService notificationService;

    public NotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    @PostMapping("/test-biweekly-reminder")
    public ResponseEntity<String> sendTestReminder() {
        try {
            String messageId = notificationService.sendBiweeklySymptomReminder();
            return ResponseEntity.ok("Reminder sent. Firebase message ID: " + messageId);
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                    .body("Failed to send reminder: " + e.getMessage());
        }
    }
}

