package com.tms.service;

import com.tms.entity.Payment;
import com.tms.entity.PaymentStatus;
import com.tms.entity.PaymentType;
import com.tms.entity.TailorOrder;
import com.tms.repository.OrderRepository;
import com.tms.repository.PaymentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class PaymentService {

    private final PaymentRepository paymentRepository;
    private final OrderRepository orderRepository;

    public List<Payment> findAll() {
        return paymentRepository.findAll();
    }

    public List<Payment> findAllActive() {
        return paymentRepository.findByStatusOrderByIdDesc(PaymentStatus.ACTIVE);
    }

    public Payment findById(Long id) {
        return paymentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Payment not found"));
    }

    public Payment save(Long id, Long orderId, Double amount, PaymentType paymentType, String note) {
        Payment payment = (id != null)
                ? findById(id)
                : new Payment();

        TailorOrder order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));

        payment.setOrder(order);
        payment.setAmount(amount);
        payment.setPaymentType(paymentType);
        payment.setNote(note);

        if (payment.getPaymentDate() == null) {
            payment.setPaymentDate(LocalDate.now());
        }

        if (payment.getStatus() == null) {
            payment.setStatus(PaymentStatus.ACTIVE);
        }

        double remainingDueBeforeSave = getRemainingDueForOrder(order, payment.getId());

        if (amount > remainingDueBeforeSave) {
            throw new RuntimeException("Payment exceeds due amount");
        }

        return paymentRepository.save(payment);
    }

    public void voidPayment(Long id) {
        Payment payment = findById(id);
        payment.setStatus(PaymentStatus.VOIDED);
        paymentRepository.save(payment);
    }

    public double getOrderTotal(Payment payment) {
        if (payment.getOrder() == null) return 0.0;

        Integer qty = payment.getOrder().getQuantity();
        Double unitPrice = payment.getOrder().getUnitPrice();

        return (qty != null ? qty : 0) * (unitPrice != null ? unitPrice : 0.0);
    }

    public double getPreviousPaid(Payment payment) {
        if (payment.getOrder() == null) return 0.0;

        double advance = payment.getOrder().getAdvanceAmount() != null
                ? payment.getOrder().getAdvanceAmount()
                : 0.0;

        double paymentSum = paymentRepository.sumPaymentsBeforeCurrent(payment.getOrder().getId(), payment.getId());
        return advance + paymentSum;
    }

    public double getRemainingDue(Payment payment) {
        double total = getOrderTotal(payment);
        double previousPaid = getPreviousPaid(payment);
        double current = payment.getAmount() != null ? payment.getAmount() : 0.0;

        return total - (previousPaid + current);
    }

    public double getRemainingDueForOrder(TailorOrder order, Long currentPaymentId) {
        double total = ((order.getQuantity() != null ? order.getQuantity() : 0)
                * (order.getUnitPrice() != null ? order.getUnitPrice() : 0.0));

        double advance = order.getAdvanceAmount() != null ? order.getAdvanceAmount() : 0.0;
        double paid = paymentRepository.sumPaymentsExcludingCurrent(order.getId(), currentPaymentId);

        return total - (advance + paid);
    }
}