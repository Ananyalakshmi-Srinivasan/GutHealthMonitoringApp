package com.example.gutapp.service;

import com.example.gutapp.models.Customer;
import com.example.gutapp.models.MoodLog;
import com.example.gutapp.repository.MoodLogRepository;
import com.example.gutapp.repository.CustomerRepository;

import java.time.LocalDate;
import java.util.Optional;
import java.util.List;

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

        LocalDate date = LocalDate.now();

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

        LocalDate date = LocalDate.now();

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
    void testGetMoodByDate() {

        MoodLog moodLog = new MoodLog();
        LocalDate now = LocalDate.now();

        moodLog.setDateCompleted(now);

        when(moodLogRepository.findByDateCompleted(now))
                .thenReturn(List.of(moodLog));

        List<MoodLog> result = moodLogService.getMoodByDate(now);

        assertEquals(1, result.size());
        verify(moodLogRepository).findByDateCompleted(now);
    }

     //Update mood
    @Test
    void testUpdateMood() throws Exception {
        LocalDate now = LocalDate.now();


        String jsonString = "{ \"Sad\": 8 }";
        JsonNode emotionsNode = objectMapper.readTree(jsonString);

        MoodLog existing = new MoodLog();
        existing.setEmotions(emotionsNode);
        existing.setJournal("Old mood");

        Customer customer = customerService.getCustomerByID(1L); // pull dummy customer
        moodLogService.createMood(existing,now,customer);

        when(moodLogRepository.findByDateCompleted(now))
                .thenReturn(List.of(existing));

        when(moodLogRepository.save(any(MoodLog.class)))
                .thenReturn(existing);

        String updatedJson = "{ \"Happy\": 1 }";
        JsonNode newNode = objectMapper.readTree(jsonString);

        existing.setEmotions(newNode);
        String journal = "Updated mood";
        existing.setJournal(journal);

        when(moodLogRepository.findByDateCompleted(now))
                .thenReturn(List.of(existing));
        when(moodLogRepository.save(any(MoodLog.class)))
                .thenReturn(existing);

        //call update
        MoodLog updated = moodLogService.updateMood(customer,existing,newNode,journal);

        assertEquals(existing.getEmotions(), updated.getEmotions());
        assertEquals("Updated mood", updated.getJournal());
    }
}