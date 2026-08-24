package com.example.gutapp.service;

import com.example.gutapp.models.Customer;
import com.example.gutapp.repository.CustomerRepository;
import com.example.gutapp.models.SurveyResponse;
import com.example.gutapp.repository.SurveyRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.verify;

class SurveyServiceTests {
    //Create an instance of SurveyService
    //automatically inject the mock repository into it
    @InjectMocks
    private SurveyService surveyService;
    @InjectMocks
    private CustomerService customerService;

    @Mock
    private SurveyRepository surveyRepository;
    @Mock
    private CustomerRepository customerRepository;

    private ObjectMapper objectMapper;

    @BeforeEach
    //Execute before each test run
    void setup() {
        MockitoAnnotations.openMocks(this);
         objectMapper = new ObjectMapper();
    }

    @Test
    public void testCreateResponse() throws Exception {
        String jsonString = "{ \"response\": \"2\" }";
        JsonNode attributesNode = objectMapper.readTree(jsonString);

        SurveyResponse response = new SurveyResponse();
        response.setAttributes(attributesNode);

        LocalDate date = LocalDate.now();
        // Mock repository save behavior
        when(surveyRepository.save(any(SurveyResponse.class))).thenReturn(response);

        Customer customer = customerService.getCustomerByID(1L);
        SurveyResponse created = surveyService.createResponse(response, date, customer);
        //Verify if the attributes are correct
        assertEquals(attributesNode, created.getAttributes());
        //Verify if the customer are correct
        assertEquals(customer, created.getCustomerID());

        //Verify repository call
        //Check if save() has been called
        verify(surveyRepository).save(any(SurveyResponse.class));
    }

    @Test
    void testGetResponseByDate() {

        SurveyResponse response = new SurveyResponse();
        LocalDate now = LocalDate.now();

        response.setDateCompleted(now);

        //Simulates a new entry to the response table
        //return a list containing response
        when(surveyRepository.findByDateCompleted(now)).thenReturn(List.of(response));
        //call service
        List<SurveyResponse> responses = surveyService.getResponseByDate(now);

        //check the size of the list
        assertEquals(1, responses.size());
        //Verify whether this method has been called before
        verify(surveyRepository).findByDateCompleted(now);
    }

    @Test
    //check updateResponse() when record exists  ---> write new test function.
    void testUpdateResponse() throws Exception {
        LocalDate now = LocalDate.now();

        //old JSON (existing data) -- create old existing data -- dummy data
        String oldJson = "{ \"response\": \"1\" }";
        JsonNode oldAttributes = objectMapper.readTree(oldJson);

        SurveyResponse existing = new SurveyResponse(); // create 'existing' record
        existing.setAttributes(oldAttributes); // set record with dummy data

        Customer customer = customerService.getCustomerByID(1L); // pull dummy customer
        surveyService.createResponse(existing,now,customer); // create dummy erecord

        System.out.println("old");
        System.out.println(existing.getAttributes());

        //the database found the response -- what does this do
        when(surveyRepository.findByDateCompleted(now)).thenReturn(List.of(existing));
        when(surveyRepository.save(any())).thenReturn(existing);

        //new JSON (update data)
        String newJson = "{ \"response\": \"3\" }"; // create dummy update data.
        JsonNode newAttributes = objectMapper.readTree(newJson);


        System.out.println("intermediate");
        System.out.println(existing.getAttributes());

        //the database found the response -- what does this do
        when(surveyRepository.findByDateCompleted(now)).thenReturn(List.of(existing));
        when(surveyRepository.save(any())).thenReturn(existing);

        //call update
        SurveyResponse result = surveyService.updateResponse(customer,existing,newAttributes);

        System.out.println(existing.getAttributes());

        //update successfully
        assertEquals(existing.getAttributes(), result.getAttributes());
    }

    //@Test
    // check when id not exits
//    void testUpdateResponseNotExists() {
//
//        LocalDate now = LocalDate.now();
//
//        when(surveyRepository.findByDateCompleted(now)).thenReturn(Optional.empty());
//
//        SurveyResponse update = new SurveyResponse();
//        SurveyResponse result = updateResponse(now, newAttributes,customer,update);
//        //return null
//        assertNull(result);
//    }

    @Test
    //Verify whether the SurveyService.getAllResponses() method works correctly
    void testGetAllResponses() {

        when(surveyRepository.findAll()).thenReturn(
                List.of(new SurveyResponse(), new SurveyResponse())
        );
        //save the result into the list
        List<SurveyResponse> result = surveyService.getAllResponses();

        //Check whether the returned data contains 2 records
        assertEquals(2, result.size());
    }

    @Test
    //check the deleteSurveyResponse() method
    void testDeleteSurveyResponse() {
        LocalDate now = LocalDate.now();
        //Check whether deleteById(1L) was actually called
        surveyService.deleteSurveyResponse(now);
        //Check whether the mock object's method has been executed
        verify(surveyRepository).deleteByDateCompleted(now);
    }

    @Test
    //check the deleteAllResponses() method
    void testDeleteAllResponses() {

        surveyService.deleteAllResponses();

        verify(surveyRepository).deleteAll();
    }
}
