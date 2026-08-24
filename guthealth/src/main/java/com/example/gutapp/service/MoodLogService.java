package com.example.gutapp.service;

import com.example.gutapp.models.Customer;
import com.example.gutapp.models.MoodLog;
import com.example.gutapp.repository.MoodLogRepository;
import org.springframework.stereotype.Service;
import com.fasterxml.jackson.databind.JsonNode;

import java.time.LocalDate;
import java.util.Optional;
import java.util.List;

@Service
public class MoodLogService {

    private final MoodLogRepository moodLogRepository;

    public MoodLogService(MoodLogRepository moodLogRepository) {
        this.moodLogRepository = moodLogRepository;
    }

    public LocalDate getMoodDate(MoodLog moodLog) {
        return moodLog.getDateCompleted();
    }

    public List<MoodLog> getMoodByDate(LocalDate date) {
        return moodLogRepository.findByDateCompleted(date);
    }


    // create new mood
    public MoodLog createMood(MoodLog request, LocalDate date, Customer customer) {

        MoodLog newMood = new MoodLog();
        newMood.setDateCompleted(date);
        newMood.setEmotions(request.getEmotions());
        newMood.setJournal(request.getJournal());
        newMood.setCustomerID(customer);

        return moodLogRepository.save(newMood);
    }

    // update existing mood
    public MoodLog updateMood(Customer customer, MoodLog existing, JsonNode moodUpdate, String journalUpdate) {
        existing.setEmotions(moodUpdate);
        existing.setJournal(journalUpdate);
        existing.setCustomerID(customer);
        return moodLogRepository.save(existing);
    }

    boolean responseExists(LocalDate date) {

        if (getMoodByDate(date) != null) {
            return true;
        } else  {
            return false;
        }
    }

    //deletes mood log.

    public void deleteMoodLog(LocalDate date) {
        moodLogRepository.deleteByDateCompleted(date);
    }

    public void deleteAllMoodLog(Long id) {
        moodLogRepository.deleteAll();
    }

}