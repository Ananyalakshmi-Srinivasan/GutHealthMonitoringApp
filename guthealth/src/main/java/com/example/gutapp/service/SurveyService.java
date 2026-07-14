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

    // get ID components of a response
    public Long getResponseID(SurveyResponse response) {
        return response.getSurveyID();
    }
    public Long getResponseDate(SurveyResponse response) {
        return response.getDateCompleted();
    }

    // get responses from Survey Response entity using ID
    public List<SurveyResponse> getResponseByID(Long ID) {
       return surveyRepository.findBySurveyID(ID);
    }

    public List<SurveyResponse> getResponseByDate(LocalDate date) {
        return surveyRepository.findBySurveyDate(date);
    }

    public List<SurveyResponse> getAllResponsesForCustomer(Long customerID) {
        List<SurveyResponse> responses = new ArrayList<SurveyResponse>();

        List<SurveyResponse> allResponses = surveyRepository.findAll();

        for (SurveyResponse response : allResponses){
            if (response.getCustomerID() == customerID)
            {
                responses.add(response);
            }
        }
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

    // update function to allow customers to update previous responses to surveys
    public SurveyResponse updateResponse(LocalDate date, SurveyResponse responseDetails) {
        SurveyResponse existingResponse = getResponseByDate(date);

        //save response
        existingResponse.setAttributes(responseDetails.getAttributes());
        return surveyRepository.save(existingResponse);

        return null;
    }
    boolean responseExists(LocalDate date) {

        if (getResponseByDate(date) != null) {
            return true;
        } else  {
            return false;
        }
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


