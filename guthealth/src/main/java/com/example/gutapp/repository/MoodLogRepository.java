package com.example.gutapp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.gutapp.models.MoodLog;
import java.util.*;


public interface MoodLogRepository extends JpaRepository<MoodLog, Long> {
    //Find a customer's mood record for a specific day
    Optional<MoodLog> findByMoodLogID(long moodlogID);
}
