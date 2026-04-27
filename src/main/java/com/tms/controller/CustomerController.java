//package com.tms.controller;
//
//
//import com.tms.entity.Customer;
//import com.tms.service.CustomerService;
//import lombok.RequiredArgsConstructor;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.*;
//
//@Controller
//@RequiredArgsConstructor
//@RequestMapping("/customers")
//public class CustomerController {
//
//    private final CustomerService customerService;
//
//    @GetMapping
//    public String list(Model model) {
//        model.addAttribute("customers", customerService.findAll());
//        return "customer/list";
//    }
//
//    @GetMapping("/create")
//    public String createForm(Model model) {
//        model.addAttribute("customer", new Customer());
//        return "customer/form";
//    }
//
//    @PostMapping("/save")
//    public String save(@ModelAttribute Customer customer) {
//        customerService.save(customer);
//        return "redirect:/customers";
//    }
//
//    @GetMapping("/edit/{id}")
//    public String edit(@PathVariable Long id, Model model) {
//        model.addAttribute("customer", customerService.findById(id));
//        return "customer/form";
//    }
//
//    @GetMapping("/delete/{id}")
//    public String delete(@PathVariable Long id) {
//        customerService.delete(id);
//        return "redirect:/customers";
//    }
//}

package com.tms.controller;

import com.tms.entity.Customer;
import com.tms.service.CustomerService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/customers")
public class CustomerController {

    private final CustomerService customerService;

    @GetMapping
    public List<Customer> list() {
        return customerService.findAll();
    }

    @GetMapping("/{id}")
    public Customer getById(@PathVariable Long id) {
        return customerService.findById(id);
    }

    @PostMapping
    public Customer create(@RequestBody Customer customer) {
        return customerService.save(customer);
    }

    @PutMapping("/{id}")
    public Customer update(@PathVariable Long id, @RequestBody Customer customer) {
        customer.setId(id);
        return customerService.save(customer);
    }

    @DeleteMapping("/{id}")
    public String delete(@PathVariable Long id) {
        customerService.delete(id);
        return "Customer deleted successfully";
    }
}