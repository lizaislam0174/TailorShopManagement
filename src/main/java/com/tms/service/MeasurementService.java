package com.tms.service;

import com.tms.entity.Measurement;
import com.tms.repository.MeasurementRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MeasurementService {

    private final MeasurementRepository measurementRepository;

    public List<Measurement> findAll() {
        return measurementRepository.findAll();
    }

    public Measurement save(Measurement measurement) {
        return measurementRepository.save(measurement);
    }

    public Measurement findById(Long id) {
        return measurementRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Measurement not found"));
    }

    // NEW — used by Flutter to load the form
    public Optional<Measurement> findLatestByCustomerId(Long customerId) {
        return measurementRepository.findTopByCustomerIdOrderByCreatedAtDesc(customerId);
    }

    // NEW — create or update: if customer already has a measurement, update it
    public Measurement createOrUpdate(Measurement measurement) {
        Optional<Measurement> existing = measurementRepository
                .findTopByCustomerIdOrderByCreatedAtDesc(
                        measurement.getCustomer().getId());

        if (existing.isPresent()) {
            // Overwrite the existing record
            measurement.setId(existing.get().getId());
        }
        return measurementRepository.save(measurement);
    }

    public void delete(Long id) {
        measurementRepository.deleteById(id);
    }
}
