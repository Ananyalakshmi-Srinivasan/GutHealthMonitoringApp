package com.example.gutapp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.gutapp.models.MoodLog;
import java.util.*;

import java.time.LocalDate;


public interface MoodLogRepository extends JpaRepository<MoodLog, Long> {
    //Find a customer's mood record for a specific day
//    Optional<MoodLog> findByMoodLogID(long moodlogID);
    List<MoodLog> findByDateCompleted(LocalDate dateCompleted);

    void deleteByDateCompleted(LocalDate dateCompleted);

}
