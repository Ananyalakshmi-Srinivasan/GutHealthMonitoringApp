package com.example.gutapp.service;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import org.springframework.stereotype.Service;

@Service
public class NotificationService {

    public String sendBiweeklySymptomReminder() throws Exception {
        Message message = Message.builder()
                .setTopic("biweekly_symptom_reminder")
                .setNotification(Notification.builder()
                        .setTitle("Log your symptoms")
                        .setBody("Please complete your symptom log for this two-week check-in.")
                        .build())
                .putData("route", "/survey")
                .putData("type", "symptom_reminder")
                .build();

        return FirebaseMessaging.getInstance().send(message);
    }
}

