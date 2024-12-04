package com.jerryfelipe.pagos.repository;

import com.jerryfelipe.pagos.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PaymentRepository extends JpaRepository<Payment, Long> {
}
