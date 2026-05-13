package com.tms.controller;

import com.tms.entity.Measurement;
import com.tms.service.CustomerService;
import com.tms.service.MeasurementService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/measurements")
public class MeasurementController {

    private final MeasurementService measurementService;
    private final CustomerService customerService;

    @GetMapping
    public List<Measurement> list() {
        return measurementService.findAll();
    }

    @GetMapping("/{id}")
    public Measurement getById(@PathVariable Long id) {
        return measurementService.findById(id);
    }

    // NEW — Flutter calls this to load the measurement form
    @GetMapping("/customer/{customerId}")
    public ResponseEntity<Measurement> getByCustomerId(@PathVariable Long customerId) {
        return measurementService.findLatestByCustomerId(customerId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // UPDATED — now uses createOrUpdate so re-saving doesn't duplicate
    @PostMapping
    public Measurement create(@RequestBody Measurement measurement) {
        measurement.setCustomer(
                customerService.findById(measurement.getCustomer().getId())
        );
        return measurementService.createOrUpdate(measurement);
    }

    @PutMapping("/{id}")
    public Measurement update(@PathVariable Long id, @RequestBody Measurement measurement) {
        measurement.setId(id);
        measurement.setCustomer(
                customerService.findById(measurement.getCustomer().getId())
        );
        return measurementService.save(measurement);
    }

    @DeleteMapping("/{id}")
    public String delete(@PathVariable Long id) {
        measurementService.delete(id);
        return "Measurement deleted successfully";
    }

    @GetMapping("/token/{id}")
    public Map<String, Object> getToken(@PathVariable Long id) {
        Measurement m = measurementService.findById(id);
        Map<String, Object> data = new HashMap<>();
        data.put("measurement", m);
        data.put("tokenNo", "MT-" + String.format("%07d", m.getId()));
        return data;
    }
}

