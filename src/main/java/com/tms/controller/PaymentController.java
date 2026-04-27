package com.tms.controller;

import com.tms.entity.Payment;
import com.tms.entity.PaymentType;
import com.tms.service.OrderService;
import com.tms.service.PaymentService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/payments")
public class PaymentController {

    private final PaymentService paymentService;
    private final OrderService orderService;

    // ✅ Get all payments
    @GetMapping
    public List<Payment> list() {
        return paymentService.findAll();
    }

    // ✅ Get by ID
    @GetMapping("/{id}")
    public Payment getById(@PathVariable Long id) {
        return paymentService.findById(id);
    }

    // ✅ Create
    @PostMapping
    public Payment create(@RequestBody Payment payment) {

        return paymentService.save(
                null,
                payment.getOrder().getId(),
                payment.getAmount(),
                payment.getPaymentType(),
                payment.getNote()
        );
    }

    // ✅ Update
    @PutMapping("/{id}")
    public Payment update(@PathVariable Long id, @RequestBody Payment payment) {

        return paymentService.save(
                id,
                payment.getOrder().getId(),
                payment.getAmount(),
                payment.getPaymentType(),
                payment.getNote()
        );
    }

    // ✅ Delete / Void
    @DeleteMapping("/{id}")
    public String voidPayment(@PathVariable Long id) {
        paymentService.voidPayment(id);
        return "Payment voided successfully";
    }

    // ✅ Receipt API
    @GetMapping("/receipt/{id}")
    public Map<String, Object> getReceipt(@PathVariable Long id) {

        Payment payment = paymentService.findById(id);

        Map<String, Object> data = new HashMap<>();
        data.put("payment", payment);
        data.put("receiptNo", "RCV-" + String.format("%06d", payment.getId()));
        data.put("paymentDate", payment.getPaymentDate() != null ? payment.getPaymentDate() : LocalDate.now());
        data.put("totalAmount", paymentService.getOrderTotal(payment));
        data.put("previousPaid", paymentService.getPreviousPaid(payment));
        data.put("remainingDue", paymentService.getRemainingDue(payment));

        return data;
    }

    // ✅ Voucher API
    @GetMapping("/voucher/{id}")
    public Map<String, Object> getVoucher(@PathVariable Long id) {

        Payment payment = paymentService.findById(id);

        Map<String, Object> data = new HashMap<>();
        data.put("payment", payment);
        data.put("voucherNo", "RV-" + String.format("%06d", payment.getId()));
        data.put("paymentDate", payment.getPaymentDate() != null ? payment.getPaymentDate() : LocalDate.now());
        data.put("totalAmount", paymentService.getOrderTotal(payment));
        data.put("previousPaid", paymentService.getPreviousPaid(payment));
        data.put("remainingDue", paymentService.getRemainingDue(payment));

        return data;
    }
}