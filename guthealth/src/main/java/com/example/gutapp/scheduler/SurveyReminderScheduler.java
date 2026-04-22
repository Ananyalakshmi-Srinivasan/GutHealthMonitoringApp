package com.example.gutapp.scheduler;

import com.example.gutapp.service.NotificationService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;

@Component
public class SurveyReminderScheduler {

    @Value("${notifications.reminder-anchor-date}")
    private String anchorDateValue;


    private final NotificationService NotificationService;

    public SurveyReminderScheduler(NotificationService notificationService) {
        this.NotificationService = notificationService;
    }

    @Scheduled(cron = "0 0 9 * * *", zone = "Europe/London")
    public void sendReminderIfDue() {
        LocalDate anchorDate = LocalDate.parse(anchorDateValue);
        LocalDate today = LocalDate.now(ZoneId.of("Europe/London"));

        long daysBetween = ChronoUnit.DAYS.between(anchorDate, today);

        if (daysBetween >= 0 && daysBetween % 14 == 0) {
            try {
                NotificationService.sendBiweeklySymptomReminder();
                System.out.println("Biweekly reminder sent.");
            } catch (Exception e) {
                System.err.println("Failed to send biweekly reminder: " + e.getMessage());
            }
        }
    }
}
