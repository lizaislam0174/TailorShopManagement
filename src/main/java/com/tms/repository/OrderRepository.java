package com.tms.repository;

import com.tms.entity.OrderStatus;
import com.tms.entity.TailorOrder;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface OrderRepository extends JpaRepository<TailorOrder, Long> {
    Optional<TailorOrder> findByOrderNo(String orderNo);
    List<TailorOrder> findByStatus(OrderStatus status);
}