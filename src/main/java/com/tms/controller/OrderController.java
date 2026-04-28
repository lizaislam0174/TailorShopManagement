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

        // Set customer
        if (order.getCustomer() != null && order.getCustomer().getId() != null) {
            order.setCustomer(
                    customerService.findById(order.getCustomer().getId())
            );
        }

        // Set employee
        if (order.getEmployee() != null && order.getEmployee().getId() != null) {
            order.setEmployee(
                    employeeRepository.findById(order.getEmployee().getId()).orElse(null)
            );
        } else {
            order.setEmployee(null);
        }

        // NOTE: We REMOVED the System.currentTimeMillis() code here.
        // The orderService.save() method will now call generateOrderNo()
        // to create sequential numbers like ORD-000001.

        // Set dressType from notes if not provided
        if (order.getDressType() == null && order.getNotes() != null) {
            order.setDressType(order.getNotes());
        }

        // Fix unitPrice if only totalAmount was sent
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

        if (order.getCustomer() != null && order.getCustomer().getId() != null) {
            order.setCustomer(
                    customerService.findById(order.getCustomer().getId())
            );
        }

        if (order.getEmployee() != null && order.getEmployee().getId() != null) {
            order.setEmployee(
                    employeeRepository.findById(order.getEmployee().getId()).orElse(null)
            );
        } else {
            order.setEmployee(null);
        }

        // NOTE: We REMOVED the System.currentTimeMillis() code here as well.

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