package com.tms.service;

import com.tms.entity.OrderStatus;
import com.tms.entity.TailorOrder;
import com.tms.repository.OrderRepository;
import com.tms.repository.PaymentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderRepository orderRepository;
    private final PaymentRepository paymentRepository;

    public List<TailorOrder> findAll() {
        return orderRepository.findAll();
    }

    public TailorOrder save(TailorOrder order) {
        if (order.getOrderNo() == null || order.getOrderNo().isBlank()) {
            order.setOrderNo(generateOrderNo());
        }
        return orderRepository.save(order);
    }

    public TailorOrder findById(Long id) {
        return orderRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Order not found"));
    }

    public void delete(Long id) {
        if (!paymentRepository.findByOrderId(id).isEmpty()) {
            throw new RuntimeException("Cannot delete order. Payments exist!");
        }
        orderRepository.deleteById(id);
    }

    public long countAll() {
        return orderRepository.count();
    }

    public long countByStatus(OrderStatus status) {
        return orderRepository.findByStatus(status).size();
    }

    public double calculateTotalAmount(TailorOrder order) {
        int quantity = order.getQuantity() != null ? order.getQuantity() : 0;
        double unitPrice = order.getUnitPrice() != null ? order.getUnitPrice() : 0.0;
        return quantity * unitPrice;
    }

    public double calculateDueAmount(TailorOrder order) {
        double total = calculateTotalAmount(order);
        double advance = order.getAdvanceAmount() != null ? order.getAdvanceAmount() : 0.0;
        return total - advance;
    }

    private String generateOrderNo() {
        long count = orderRepository.count() + 1;
        return "ORD-" + String.format("%06d", count);
    }
}