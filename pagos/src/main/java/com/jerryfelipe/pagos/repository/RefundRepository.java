package com.jerryfelipe.pagos.repository;

import com.jerryfelipe.pagos.model.Refund;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RefundRepository extends JpaRepository<Refund, Long> {
}
