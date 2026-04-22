package com.example.gutapp.models;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.databind.JsonNode;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.LocalDateTime;
@Getter
@Setter
@Data
@Entity(name = "mood_log") //table name
@Table
@JsonIgnoreProperties(ignoreUnknown = true)
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MoodLog {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "moodlogID")
    private Long moodLogID;

    @Column(name = "date_completed", nullable = false)
    private LocalDateTime dateCompleted;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(columnDefinition = "jsonb", nullable = false)
    private JsonNode emotions;

    @Column(columnDefinition = "text")
    private String journal;

    // many mood logs belong to one customer
    @ManyToOne
    @JoinColumn(name = "customerID", referencedColumnName = "customerID")
    private Customer customerID;
}