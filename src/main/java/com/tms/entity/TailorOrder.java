package com.tms.entity;


import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "orders")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TailorOrder {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String orderNo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id", nullable = false)
    private Customer customer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "employee_id")
    private Employee employee;

    private String dressType;
    private LocalDate orderDate;
    private LocalDate deliveryDate;
    private Integer quantity;
    private Double unitPrice;
    private Double totalAmount;
    private Double advanceAmount;
    private Double dueAmount;

    @Enumerated(EnumType.STRING)
    private OrderStatus status;

    @Column(length = 1000)
    private String notes;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @PrePersist
    public void prePersist() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();

        if (orderDate == null) {
            orderDate = LocalDate.now();
        }

        if (quantity == null) quantity = 1;
        if (unitPrice == null) unitPrice = 0.0;
        if (advanceAmount == null) advanceAmount = 0.0;

        totalAmount = quantity * unitPrice;
        dueAmount = totalAmount - advanceAmount;

        if (status == null) {
            status = OrderStatus.NEW;
        }
    }

    @PreUpdate
    public void preUpdate() {
        updatedAt = LocalDateTime.now();

        if (quantity == null) quantity = 1;
        if (unitPrice == null) unitPrice = 0.0;
        if (advanceAmount == null) advanceAmount = 0.0;

        totalAmount = quantity * unitPrice;
        dueAmount = totalAmount - advanceAmount;
    }
}