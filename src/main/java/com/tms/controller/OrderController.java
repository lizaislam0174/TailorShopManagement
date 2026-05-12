package com.tms.controller;

import com.tms.entity.OrderStatus;
import com.tms.entity.TailorOrder;
import com.tms.repository.EmployeeRepository;
import com.tms.service.CustomerService;
import com.tms.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
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

        if (order.getCustomer() != null && order.getCustomer().getId() != null) {
            order.setCustomer(customerService.findById(order.getCustomer().getId()));
        }

        if (order.getEmployee() != null && order.getEmployee().getId() != null) {
            order.setEmployee(employeeRepository.findById(order.getEmployee().getId()).orElse(null));
        } else {
            order.setEmployee(null);
        }

        if (order.getDressType() == null && order.getNotes() != null) {
            order.setDressType(order.getNotes());
        }

        if (order.getUnitPrice() == null || order.getUnitPrice() == 0.0) {
            if (order.getTotalAmount() != null) {
                order.setUnitPrice(order.getTotalAmount());
                order.setQuantity(1);
            }
        }

        return orderService.save(order);
    }

    // ✅ Update (full)
    @PutMapping("/{id}")
    public TailorOrder update(@PathVariable Long id, @RequestBody TailorOrder order) {
        order.setId(id);

        if (order.getCustomer() != null && order.getCustomer().getId() != null) {
            order.setCustomer(customerService.findById(order.getCustomer().getId()));
        }

        if (order.getEmployee() != null && order.getEmployee().getId() != null) {
            order.setEmployee(employeeRepository.findById(order.getEmployee().getId()).orElse(null));
        } else {
            order.setEmployee(null);
        }

        return orderService.save(order);
    }

    // ✅ NEW — Update status only: PUT /api/orders/{id}/status
    // Body: { "status": "IN_PROGRESS" }
    @PutMapping("/{id}/status")
    public ResponseEntity<TailorOrder> updateStatus(
            @PathVariable Long id,
            @RequestBody Map<String, String> body) {

        String statusStr = body.get("status");
        if (statusStr == null || statusStr.isBlank()) {
            return ResponseEntity.badRequest().build();
        }

        OrderStatus newStatus;
        try {
            newStatus = OrderStatus.valueOf(statusStr.toUpperCase());
        } catch (IllegalArgumentException e) {
            // Return 400 with a clear message if status value is invalid
            return ResponseEntity.badRequest().build();
        }

        TailorOrder updated = orderService.updateStatus(id, newStatus);
        return ResponseEntity.ok(updated);
    }

    // ✅ Delete
    @DeleteMapping("/{id}")
    public String delete(@PathVariable Long id) {
        orderService.delete(id);
        return "Order deleted successfully";
    }

    // ✅ Invoice
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