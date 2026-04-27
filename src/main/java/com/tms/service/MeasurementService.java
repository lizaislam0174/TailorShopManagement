package com.tms.service;



import com.tms.entity.Measurement;
import com.tms.repository.MeasurementRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

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

    public void delete(Long id) {
        measurementRepository.deleteById(id);
    }
}