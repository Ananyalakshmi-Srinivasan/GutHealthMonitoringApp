package com.example.gutapp.service;

import com.example.gutapp.models.Customer;
import com.example.gutapp.models.MoodLog;
import com.example.gutapp.repository.MoodLogRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;

@Service
public class MoodLogService {

    private final MoodLogRepository moodLogRepository;

    public MoodLogService(MoodLogRepository moodLogRepository) {
        this.moodLogRepository = moodLogRepository;
    }

    // get mood log
    public Optional<MoodLog> getMoodByID(Long ID) {
        return moodLogRepository.findByMoodLogID(ID);
    }

    // create new mood
    public MoodLog createMood(MoodLog request, LocalDateTime date, Customer customer) {

        MoodLog newMood = new MoodLog();
        newMood.setDateCompleted(date);
        newMood.setEmotions(request.getEmotions());
        newMood.setJournal(request.getJournal());
        newMood.setCustomerID(customer);

        return moodLogRepository.save(newMood);
    }

    // update existing mood
    public MoodLog updateMood(Long ID, MoodLog moodLog) {
        Optional<MoodLog> mood = moodLogRepository.findById(ID);
        if (mood.isPresent()) {
            MoodLog existingMood = mood.get();
            existingMood.setEmotions(moodLog.getEmotions());
            existingMood.setJournal(moodLog.getJournal());
            return moodLogRepository.save(existingMood);
        }
        System.out.println("MoodLog not found with id: " + ID);
        return null;
    }

    //deletes mood log.

    public void deleteMoodLogById(Long id) {
        moodLogRepository.deleteById(id);
    }

    public void deleteAllMoodLog(Long id) {
        moodLogRepository.deleteAll();
    }

}