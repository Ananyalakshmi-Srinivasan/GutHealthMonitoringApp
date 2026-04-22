package com.example.gutapp.models;

import jakarta.persistence.*;
import java.util.List;
import lombok.*;

// lombok generates Getter and Setter methods for our attributes. don't hvae to write it ourselves

@Data
// @Data is a convenient shortcut annotation that bundles the features of @ToString,
// @EqualsAndHashCode, @Getter / @Setter and @RequiredArgsConstructor together:
// In other words, @Data generates all the boilerplate that is normally associated with
// simple POJOs (Plain Old Java Objects) and beans:
// Getters for all fields, setters for all non-final fields and appropriate toString, equals and hashCode implementations that involve the fields of the class, and a constructor that initializes all final fields, as well as all non-final fields with no initializer that have been marked with @NonNull, in order to ensure the field is never null.
@Getter
@Setter
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "customer")
public class Customer {
    // @Id is to marks the field directly below it as the Primary Key (the unique identifier) for this db table
    @Id
    // Tells the database to automatically generate the value
    // for the primary key whenever a new Customer is saved
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "customerID")
    // The actual Java variable that stores the generated primary key
    private Long customerID;

    @Column(name = "firstname", nullable = false)
    private String firstName;
    @Column(name = "lastname", nullable = false)
    private String lastName;

    // Maps to the email column
    // nullable = false makes it mandatory
    // unique = true ensures no two customers in the database can register with the exact same email address
    @Column(name = "email", unique = true, nullable = false)
    private String email;

    // Maps to the password column and makes it a mandatory field.
    @Column(name = "password", nullable = false)
    private String password;

    // @OneToMany needs to be a container (like a list) as it needs to be able to contain many ides

    //One Customer can have many Survey Responses and Mood Logs
    @OneToMany(
            // which column in this table are they linked by (i.e. states that customerId column will be the foreign key
            mappedBy = "customerID",
            // If save/update/delete a Customer,
            // those exact same actions automatically be applied to all of their associated SurveyResponse objects
            cascade = CascadeType.ALL,
            // If remove a SurveyResponse from the responses list in Java,
            // it will be permanently deleted from the database table
            orphanRemoval = true
    )
    // consists of all the survey entities it will be linked with
    private List<SurveyResponse> responses;

    @OneToMany(mappedBy = "customerID",
            cascade = CascadeType.ALL,
            orphanRemoval = true)
    private List<MoodLog> moodLogs;

}