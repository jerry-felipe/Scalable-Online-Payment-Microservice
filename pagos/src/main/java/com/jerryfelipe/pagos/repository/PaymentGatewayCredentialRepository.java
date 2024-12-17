package com.jerryfelipe.pagos.repository;

import com.jerryfelipe.pagos.model.PaymentGatewayCredential;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PaymentGatewayCredentialRepository extends JpaRepository<PaymentGatewayCredential, Long> {
}
