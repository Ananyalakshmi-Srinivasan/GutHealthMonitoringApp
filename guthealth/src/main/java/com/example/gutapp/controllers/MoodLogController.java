package com.example.gutapp.controllers;

import com.example.gutapp.models.MoodLog;
import com.example.gutapp.models.Customer;
import com.example.gutapp.service.MoodLogService;
import com.example.gutapp.service.CustomerService;

import org.springframework.web.bind.annotation.*;
import java.time.LocalDateTime;

@RestController
@RequestMapping("/api/mood")
public class MoodLogController {

    private final MoodLogService moodLogService;
    private final CustomerService customerService;

    public MoodLogController(MoodLogService moodLogService,
                             CustomerService customerService) {
        this.moodLogService = moodLogService;
        this.customerService = customerService;
    }

    @PostMapping("/submit") // uses same url mood log file to save mood.
    //get frontend JSON, get current date, get current customer (dummy), use service
    public MoodLog saveMood(@RequestBody MoodLog moodLog) {

        LocalDateTime today = LocalDateTime.now();

        Long customerID = 1L; // dummy user -- should give this id in the front end
        Customer customer = customerService.getCustomerByID(customerID);
        return moodLogService.createMood(moodLog, today, customer);
    }
}