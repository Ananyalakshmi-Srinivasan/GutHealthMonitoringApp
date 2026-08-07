package com.example.gutapp.service;

import com.example.gutapp.dto.SymptomGraphData;
import com.example.gutapp.models.Customer;
import com.example.gutapp.models.SurveyResponse;
import com.example.gutapp.repository.*;
import org.springframework.stereotype.Service;
import java.time.LocalDate;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.databind.JsonNode; // allows jsonb
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;


import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class SurveyService {
    private final SurveyRepository surveyRepository;
    public SurveyService(SurveyRepository surveyRepository) {
        this.surveyRepository = surveyRepository;
    }

    public LocalDate getResponseDate(SurveyResponse response) {
        return response.getDateCompleted();
    }

    public List<SurveyResponse> getResponseByDate(LocalDate date) {
        return surveyRepository.findByDateCompleted(date);
    }
    public List<SurveyResponse> getAllResponses() {
        return surveyRepository.findAll();
    }
    public List<SurveyResponse> getAllResponsesForCustomer(Customer customer) {
        List<SurveyResponse> responses = new ArrayList<SurveyResponse>();

        List<SurveyResponse> allResponses = getAllResponses();

        for (SurveyResponse response : allResponses){
            if (response.getCustomerID() == customer)
            {
                responses.add(response);

            }
        }
        return responses;
    }

    // creates a response to be added when survey submitted.
    public SurveyResponse createResponse(SurveyResponse request, LocalDate date, Customer customer) {
        SurveyResponse response = new SurveyResponse();
        response.setDateCompleted(date);
        response.setAttributes(request.getAttributes());
        response.setCustomerID(customer);
        return surveyRepository.save(response);
    }

    // update function to allow customers to update previous responses to surveys

//    @Query(value = "UPDATE survey_response SET attributes = :symptomDetails WHERE date_completed = :date IN (SELECT date_completed FROM survey_response WHERE customer = :customer)", nativeQuery = true)
//    public SurveyResponse updateResponse(@Param("date")LocalDate date, @Param("symptomDetails")JsonNode symptomDetails, @Param("customer")Customer customer, SurveyResponse response) {
//        return response;
//    }

    public SurveyResponse updateResponse(Customer customer, SurveyResponse existing, JsonNode update) {
        existing.setAttributes(update);
        existing.setCustomerID(customer);
        return surveyRepository.save(existing);
    }

    boolean responseExists(LocalDate date) {

        if (getResponseByDate(date) != null) {
            return true;
        } else  {
            return false;
        }
    }



    // delete Survey Responses
    public void deleteSurveyResponse(LocalDate date) {
        surveyRepository.deleteByDateCompleted(date);
    }
    public void deleteAllResponses() {
        surveyRepository.deleteAll();
    }

//    public List<SymptomGraphData> getRealGraphDataForSymptom(Long customerId, String symptomName) {
//
//        //Call the Repository and execute the efficient SQL you just wrote.
//        List<Object[]> rawData = surveyRepository.findSymptomGraphData(customerId, symptomName);
//
//        List<SymptomGraphData> graphDataList = new ArrayList<>();
//
//        //Convert Object[] to DTO
//        for (Object[] row : rawData) {
//            if (row[0] != null && row[1] != null) {
//                String date = (String) row[0]; //The SQL statement uses CAST AS TEXT, so the string must be a String.
//                int score = (Integer) row[1];  //Since the SQL statement uses CAST AS INTEGER, the value here must be an Integer.
//
//                graphDataList.add(new SymptomGraphData(date, score));
//            }
//        }
//        return graphDataList;
//    }
}


