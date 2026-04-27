package com.tms.controller;

import com.tms.entity.TailorOrder;
import com.tms.repository.EmployeeRepository;
import com.tms.service.CustomerService;
import com.tms.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/orders")
@CrossOrigin(origins = "*")
public class OrderController {

    private final OrderService orderService;
    private final CustomerService customerService;
    private final EmployeeRepository employeeRepository;

    // ✅ Get all orders
    @GetMapping
    public List<TailorOrder> list() {
        return orderService.findAll();
    }

    // ✅ Get by ID
    @GetMapping("/{id}")
    public TailorOrder getById(@PathVariable Long id) {
        return orderService.findById(id);
    }

    // ✅ Create
    @PostMapping
    public TailorOrder create(@RequestBody TailorOrder order) {

        order.setCustomer(
                customerService.findById(order.getCustomer().getId())
        );

        if (order.getEmployee() != null && order.getEmployee().getId() != null) {
            order.setEmployee(
                    employeeRepository.findById(order.getEmployee().getId()).orElse(null)
            );
        } else {
            order.setEmployee(null);
        }

        // Auto-generate orderNo if not provided
        if (order.getOrderNo() == null || order.getOrderNo().isEmpty()) {
            order.setOrderNo("ORD-" + System.currentTimeMillis());
        }

        // Set dressType from notes if provided
        if (order.getDressType() == null && order.getNotes() != null) {
            order.setDressType(order.getNotes());
        }

        // Fix totalAmount - use unitPrice if totalAmount sent directly
        if (order.getUnitPrice() == null || order.getUnitPrice() == 0.0) {
            if (order.getTotalAmount() != null) {
                order.setUnitPrice(order.getTotalAmount());
                order.setQuantity(1);
            }
        }

        return orderService.save(order);
    }

    // ✅ Update
    @PutMapping("/{id}")
    public TailorOrder update(@PathVariable Long id, @RequestBody TailorOrder order) {

        order.setId(id);

        order.setCustomer(
                customerService.findById(order.getCustomer().getId())
        );

        if (order.getEmployee() != null && order.getEmployee().getId() != null) {
            order.setEmployee(
                    employeeRepository.findById(order.getEmployee().getId()).orElse(null)
            );
        } else {
            order.setEmployee(null);
        }

        if (order.getOrderNo() == null || order.getOrderNo().isEmpty()) {
            order.setOrderNo("ORD-" + System.currentTimeMillis());
        }

        return orderService.save(order);
    }

    // ✅ Delete
    @DeleteMapping("/{id}")
    public String delete(@PathVariable Long id) {
        orderService.delete(id);
        return "Order deleted successfully";
    }

    // ✅ Invoice API
    @GetMapping("/invoice/{id}")
    public Map<String, Object> getInvoice(@PathVariable Long id) {

        TailorOrder order = orderService.findById(id);

        double totalAmount = orderService.calculateTotalAmount(order);
        double advanceAmount = order.getAdvanceAmount() != null ? order.getAdvanceAmount() : 0.0;
        double dueAmount = totalAmount - advanceAmount;

        Map<String, Object> data = new HashMap<>();
        data.put("order", order);
        data.put("totalAmount", totalAmount);
        data.put("dueAmount", dueAmount);

        return data;
    }
}