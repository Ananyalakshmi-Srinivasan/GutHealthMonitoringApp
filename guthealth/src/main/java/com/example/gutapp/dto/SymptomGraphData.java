package com.example.gutapp.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
//automatically and secretly generate
//all the getters and setters for you during compilation!
@AllArgsConstructor
//automatically generate the constructor
//that contains date and score
public class SymptomGraphData {
    private String date;
    private int severityScore;
}