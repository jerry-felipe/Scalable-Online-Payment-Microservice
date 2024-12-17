package com.jerryfelipe.pagos.repository;

import com.jerryfelipe.pagos.model.CurrencyRate;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CurrencyRateRepository extends JpaRepository<CurrencyRate, Long> {
}
