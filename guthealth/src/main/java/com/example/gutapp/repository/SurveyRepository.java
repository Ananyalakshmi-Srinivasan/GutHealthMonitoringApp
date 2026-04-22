package com.example.gutapp.repository;

import com.example.gutapp.models.SurveyResponse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param; // 必须导入这个
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SurveyRepository extends JpaRepository<SurveyResponse, Long> {

    //can see all answer form this id
    List<SurveyResponse> findBySurveyID(Long surveyID);

    //Native SQL query specifically designed to provide data for front-end line charts
    //the return type is List<Object[]>, because only extracted two columns of data.
    @Query(value = "SELECT CAST(date_completed AS TEXT), CAST(attributes->>:symptomName AS INTEGER) " +
            "FROM survey_response " +
            "WHERE customerID = :customerId AND attributes->>:symptomName IS NOT NULL " +
            "ORDER BY date_completed ASC",
            nativeQuery = true)
    List<Object[]> findSymptomGraphData(@Param("customerId") Long customerId, @Param("symptomName") String symptomName);
}