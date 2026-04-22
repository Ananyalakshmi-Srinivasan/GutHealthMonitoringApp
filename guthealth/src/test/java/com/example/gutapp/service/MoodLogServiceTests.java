package com.example.gutapp.service;

import com.example.gutapp.models.Customer;
import com.example.gutapp.models.MoodLog;
import com.example.gutapp.repository.MoodLogRepository;
import com.example.gutapp.repository.CustomerRepository;

import java.time.LocalDateTime;
import java.util.Optional;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

class MoodLogServiceTests {

    @InjectMocks
    private MoodLogService moodLogService;
    @InjectMocks
    private CustomerService customerService;

    @Mock
    private MoodLogRepository moodLogRepository;
    @Mock
    private CustomerRepository customerRepository;

    private ObjectMapper objectMapper;
    private Customer customer;

    @BeforeEach
    void setup() {
        MockitoAnnotations.openMocks(this);
        objectMapper = new ObjectMapper();

        customer = new Customer();
        customer.setCustomerID(1L);
    }

    //Mood only (allowed)
    @Test
    void testCreateMoodEmotionOnly() throws Exception {

        String jsonString = "{ \"happy\": 5 }";
        JsonNode emotionsNode = objectMapper.readTree(jsonString);

        MoodLog request = new MoodLog();
        request.setEmotions(emotionsNode);
        request.setJournal(null);

        LocalDateTime date = LocalDateTime.now();

        when(moodLogRepository.save(any(MoodLog.class)))
                .thenAnswer(i -> i.getArguments()[0]);

        MoodLog created = moodLogService.createMood(request, date, customer);

        assertEquals(emotionsNode, created.getEmotions());
        assertNull(created.getJournal());
        assertEquals(customer, created.getCustomerID());

        verify(moodLogRepository).save(any(MoodLog.class));
    }

    //Mood + Journal (allowed)
    @Test
    void testCreateMoodWithJournal() throws Exception {

        String journalEntry = "Good day";
        String jsonString = "{ \"happy\": 5 }";
        JsonNode emotionsNode = objectMapper.readTree(jsonString);

        MoodLog request = new MoodLog();
        request.setEmotions(emotionsNode);
        request.setJournal(journalEntry);

        LocalDateTime date = LocalDateTime.now();

        when(moodLogRepository.save(any(MoodLog.class)))
                .thenAnswer(i -> i.getArguments()[0]);

        MoodLog created = moodLogService.createMood(request, date, customer);

        assertEquals(emotionsNode, created.getEmotions());
        assertEquals(journalEntry, created.getJournal());
        assertEquals(customer, created.getCustomerID());

        verify(moodLogRepository).save(any(MoodLog.class));
    }

    //Get mood by ID
    @Test
    void testGetMoodByID() {

        MoodLog moodLog = new MoodLog();
        moodLog.setJournal("Existing mood");

        when(moodLogRepository.findByMoodLogID(1L))
                .thenReturn(Optional.of(moodLog));

        Optional<MoodLog> result = moodLogService.getMoodByID(1L);

        assertTrue(result.isPresent());
        assertEquals("Existing mood", result.get().getJournal());
    }

     //Update mood
    @Test
    void testUpdateMood() throws Exception {

        String jsonString = "{ \"sad\": 2 }";
        JsonNode emotionsNode = objectMapper.readTree(jsonString);

        MoodLog existing = new MoodLog();
        existing.setJournal("Old mood");

        MoodLog request = new MoodLog();
        request.setEmotions(emotionsNode);
        request.setJournal("Updated mood");

        when(moodLogRepository.findById(1L))
                .thenReturn(Optional.of(existing));

        when(moodLogRepository.save(any(MoodLog.class)))
                .thenReturn(existing);

        MoodLog updated = moodLogService.updateMood(1L, request);

        assertEquals("Updated mood", updated.getJournal());

        verify(moodLogRepository).save(existing);
    }
}