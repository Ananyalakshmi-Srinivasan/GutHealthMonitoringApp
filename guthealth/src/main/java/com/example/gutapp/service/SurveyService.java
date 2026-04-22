package com.example.gutapp.service;

import com.example.gutapp.dto.SymptomGraphData;
import com.example.gutapp.models.Customer;
import com.example.gutapp.models.SurveyResponse;
import com.example.gutapp.repository.*;
import org.springframework.stereotype.Service;
import java.time.LocalDate;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class SurveyService {
    private final SurveyRepository surveyRepository;

    public SurveyService(SurveyRepository surveyRepository) {
        this.surveyRepository = surveyRepository;
    }

    // get responses from Survey Response entity
    public List<SurveyResponse> getResponseByID(Long ID) {
       return surveyRepository.findBySurveyID(ID);
    }

    public List<SurveyResponse> getAllResponses() {
        return surveyRepository.findAll();
    }

    // creates a response to be added when survey submitted.
    public SurveyResponse createResponse(SurveyResponse request, LocalDate date, Customer customer) {
        SurveyResponse response = new SurveyResponse();
        response.setAttributes(request.getAttributes());
        response.setDateCompleted(date);
        response.setCustomerID(customer);
        return surveyRepository.save(response);
    }

    //update function to allow customers to update previous responses to surveys
    // (no implementation in front end yet but this can be extended in the future)
    public SurveyResponse updateResponse(Long id, SurveyResponse responseDetails) {
        Optional<SurveyResponse> response = surveyRepository.findById(id);
        //save response
        if (response.isPresent()) {
            SurveyResponse existingResponse = response.get();
            existingResponse.setAttributes(responseDetails.getAttributes());
            return surveyRepository.save(existingResponse);
        }
        return null;
    }

    // delete Survey Responses
    public void deleteSurveyResponse(Long id) {
        surveyRepository.deleteById(id);
    }
    public void deleteAllResponses() {
        surveyRepository.deleteAll();
    }

    public List<SymptomGraphData> getRealGraphDataForSymptom(Long customerId, String symptomName) {

        //Call the Repository and execute the efficient SQL you just wrote.
        List<Object[]> rawData = surveyRepository.findSymptomGraphData(customerId, symptomName);

        List<SymptomGraphData> graphDataList = new ArrayList<>();

        //Convert Object[] to DTO
        for (Object[] row : rawData) {
            if (row[0] != null && row[1] != null) {
                String date = (String) row[0]; //The SQL statement uses CAST AS TEXT, so the string must be a String.
                int score = (Integer) row[1];  //Since the SQL statement uses CAST AS INTEGER, the value here must be an Integer.

                graphDataList.add(new SymptomGraphData(date, score));
            }
        }
        return graphDataList;
    }
}


