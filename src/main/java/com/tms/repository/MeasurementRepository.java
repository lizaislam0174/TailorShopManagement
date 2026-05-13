package com.tms.repository;

import com.tms.entity.Measurement;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface MeasurementRepository extends JpaRepository<Measurement, Long> {


    List<Measurement> findByCustomerId(Long customerId);


    Optional<Measurement> findTopByCustomerIdOrderByCreatedAtDesc(Long customerId);
}

