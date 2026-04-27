package com.tms.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity
@Table(name = "payments")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Payment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id", nullable = false)
    private TailorOrder order;

    private Double amount;

    @Enumerated(EnumType.STRING)
    private PaymentType paymentType;

    @Column(length = 1000)
    private String note;

    private LocalDate paymentDate;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private PaymentStatus status;

    @PrePersist
    public void prePersist() {
        if (paymentDate == null) {
            paymentDate = LocalDate.now();
        }
        if (status == null) {
            status = PaymentStatus.ACTIVE;
        }
    }
}