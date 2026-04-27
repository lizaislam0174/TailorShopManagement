package com.tms.repository;

import com.tms.entity.Payment;
import com.tms.entity.PaymentStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface PaymentRepository extends JpaRepository<Payment, Long> {

    List<Payment> findByStatusOrderByIdDesc(PaymentStatus status);

    @Query("""
           SELECT COALESCE(SUM(p.amount), 0)
           FROM Payment p
           WHERE p.order.id = :orderId
           AND p.status = 'ACTIVE'
           AND (:currentPaymentId IS NULL OR p.id <> :currentPaymentId)
           """)
    double sumPaymentsExcludingCurrent(@Param("orderId") Long orderId,
                                       @Param("currentPaymentId") Long currentPaymentId);

    @Query("""
           SELECT COALESCE(SUM(p.amount), 0)
           FROM Payment p
           WHERE p.order.id = :orderId
           AND p.status = 'ACTIVE'
           AND p.id < :currentPaymentId
           """)
    double sumPaymentsBeforeCurrent(@Param("orderId") Long orderId,
                                    @Param("currentPaymentId") Long currentPaymentId);

    List<Payment> findByOrderId(Long orderId);
}