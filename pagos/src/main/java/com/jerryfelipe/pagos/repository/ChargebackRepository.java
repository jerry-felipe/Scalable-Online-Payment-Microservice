package com.jerryfelipe.pagos.repository;

import com.jerryfelipe.pagos.model.Chargeback;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ChargebackRepository extends JpaRepository<Chargeback, Long> {
}
