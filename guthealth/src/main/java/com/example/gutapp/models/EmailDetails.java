package com.example.gutapp.models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class EmailDetails {

    private String recipient; // stores recipient
    private String msgBody; // contains body of message (text)
    private String subject;
    private String attachment; // csv files!!
}