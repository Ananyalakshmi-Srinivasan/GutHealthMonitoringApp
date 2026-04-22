package com.example.gutapp.controllers;

import com.example.gutapp.dto.SymptomGraphData;
import com.example.gutapp.models.*;
import com.example.gutapp.service.*;
import com.fasterxml.jackson.databind.JsonNode;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.util.Iterator;
import java.util.List;

import java.util.Set;
import java.util.TreeSet;

@RestController
@RequestMapping("/api/response")
public class SurveyController {

    private final SurveyService surveyService;
    private final CustomerService customerService;
    // private final DateTimeController dTController;

    public SurveyController(SurveyService surveyService, CustomerService customerService) {
        this.surveyService = surveyService;
        this.customerService = customerService;
        //this.dTController = dtController;
    }


    // Flutter send POST /api/response/submit
    @PostMapping("/submit")
    public SurveyResponse saveResponse(@RequestBody SurveyResponse response) {
        LocalDate now = LocalDate.now();
        Long customerID = 1L;
        Customer customer = customerService.getCustomerByID(customerID);
        return surveyService.createResponse(response, now, customer); // 1 is the dummy customerid for now
    }

    @GetMapping("/export")
    public void exportSurveysToCSV(HttpServletResponse response) throws IOException {
        //Set the response type to CSV and trigger the browser to download.
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"survey_data.csv\"");

        //Get output stream
        PrintWriter writer = response.getWriter();

        //Resolves the issue of garbled special characters
        //when opening CSV files in some versions of Excel.
        writer.print('\uFEFF');

        //Write the CSV header (column names)
        writer.println("SurveyID,DateCompleted,CustomerID,SurveyAttributes(JSON)");

        //Get all data through Service
        List<SurveyResponse> surveys = surveyService.getAllResponses();

        //Iterate through the data and write it in CSV format.
        // Collect all the names of symptoms that have existed
        Set<String> allSymptoms = new TreeSet<>();
        for (SurveyResponse survey : surveys) {
            JsonNode attributes = survey.getAttributes();
            if (attributes != null) {
                Iterator<String> fieldNames = attributes.fieldNames();
                while (fieldNames.hasNext()) {
                    String fieldName = fieldNames.next();
                    if (attributes.get(fieldName).isNumber()) {
                        allSymptoms.add(fieldName);
                    }
                }
            }
        }

        // Generate dynamic table headers
        StringBuilder header = new StringBuilder("SurveyID,DateCompleted,CustomerID");
        for (String symptom : allSymptoms) {
            header.append(",").append(symptom); //Add additional symptom names as column headers
        }
        writer.println(header.toString());

        // Write data line by line
        for (SurveyResponse survey : surveys) {
            Long surveyID = survey.getSurveyID();
            String dateCompleted = survey.getDateCompleted() != null ? survey.getDateCompleted().toString() : "";

            //Securely obtain CustomerID
            String customerIDStr = (survey.getCustomerID() != null) ? survey.getCustomerID().getCustomerID().toString() : "N/A";

            //Securely handle JSON strings: Replace inner double quotes with two double quotes
            //and add outermost double quotes.
            String attributesJson = survey.getAttributes() != null ? survey.getAttributes().toString() : "{}";
            String escapedAttributes = "\"" + attributesJson.replace("\"", "\"\"") + "\"";
            // basic column
            StringBuilder row = new StringBuilder(String.format("%d,%s,%s", surveyID, dateCompleted, customerIDStr));
            JsonNode attributes = survey.getAttributes();

            // Find the scores in the current questionnaire according to the order of symptoms in the header.
            for (String symptom : allSymptoms) {
                row.append(","); // First add a comma and move to the next column

                // If this questionnaire contains this symptom & it is a number, fill in the score.
                if (attributes != null && attributes.has(symptom) && attributes.get(symptom).isNumber()) {
                    row.append(attributes.get(symptom).asInt());
                }
                // If this symptom is not present, enter nothing
            }

            //Write the concatenated line to the output stream.
            writer.printf("%d,%s,%s,%s\n", surveyID, dateCompleted, customerIDStr, escapedAttributes);
            writer.println(row.toString());
        }

        //Refresh and close the stream
        writer.flush();
        writer.close();
    }

    @GetMapping("/graph/{customerId}/{symptomName}")
    public List<SymptomGraphData> getSymptomGraphData(
            @PathVariable Long customerId,  //Extracting User ID from URL
            @PathVariable String symptomName) {

        //Pass the two extracted parameters directly to the Service
        return surveyService.getRealGraphDataForSymptom(customerId, symptomName);
    }
}
