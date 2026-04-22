package com.example.gutapp.models;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.databind.JsonNode; // allows jsonb
import jakarta.persistence.*;
import lombok.*;
//import org.hibernate.annotations.TypeDef; // deprecated !!!
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import java.time.LocalDate;


@Getter
@Setter
@Data
@Entity(name="survey_response")
@Table
@JsonIgnoreProperties(ignoreUnknown = true)
@AllArgsConstructor
@NoArgsConstructor
@Builder
//@TypeDef(name = "jsonb", typeClass = JsonNode)
// @org.hibernate.annotations.TypeDef and @org.hibernate.annotations.TypeDefs allows you to declare custom type definitions.
// These annotations can be placed at the class or package level.
// Note that these definitions are be global for the session factory (even when defined at the class level). Type definitions have to be defined before any usage. If the type is used on a single entity, you can plance the definition on the entity itself. Otherwise, it is recommended to place the definition a the package level
// since the entity processing order is not guaranteed.
public class SurveyResponse {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name="surveyID")
    private Long surveyID;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(columnDefinition = "jsonb", nullable = false)
    private JsonNode attributes;
    //JPA doesn’t know how to store JsonNode by default. --> so needed to add hibernate types library

    @Column(name= "date_completed")
    private LocalDate dateCompleted; // the week of the survey it appears on.

    // links to customer table --> many surveys can be dispatched to one customer
    @ManyToOne
    @JoinColumn(name = "customerID", referencedColumnName = "customerID") // creates foreign key
    private Customer customerID; // the type of this column is a customer entity.

}