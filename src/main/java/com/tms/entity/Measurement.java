package com.tms.entity;


import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "measurements")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Measurement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id", nullable = false)
    private Customer customer;

    private String measurementType;
    private Double neck;
    private Double chest;
    private Double waist;
    private Double hip;
    private Double shoulder;
    private Double sleeveLength;
    private Double shirtLength;
    private Double pantLength;
    private Double thigh;
    private Double bottomOpening;
    private Double bust;
    private Double underBust;
    private Double frontNeckDepth;
    private Double backNeckDepth;
    private Double armhole;
    private Double kameezLength;
    private Double salwarLength;

    @Column(length = 1000)
    private String notes;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @PrePersist
    public void prePersist() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    public void preUpdate() {
        updatedAt = LocalDateTime.now();
    }
}