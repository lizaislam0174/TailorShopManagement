package com.tms.controller;

import com.tms.entity.OrderStatus;
import com.tms.repository.EmployeeRepository;
import com.tms.service.CustomerService;
import com.tms.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/dashboard")
public class DashboardController {

    private final CustomerService customerService;
    private final OrderService orderService;
    private final EmployeeRepository employeeRepository;

    @GetMapping
    public Map<String, Object> getDashboardData() {

        Map<String, Object> data = new HashMap<>();

        data.put("totalCustomers", customerService.findAll().size());
        data.put("totalEmployees", employeeRepository.count());
        data.put("totalOrders", orderService.countAll());
        data.put("pendingOrders", orderService.countByStatus(OrderStatus.NEW));
        data.put("deliveredOrders", orderService.countByStatus(OrderStatus.DELIVERED));

        return data;
    }
}