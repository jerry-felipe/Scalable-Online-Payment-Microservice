package com.jerryfelipe.pagos.repository;

import com.jerryfelipe.pagos.model.PaymentTransaction;
import com.jerryfelipe.pagos.model.User;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

public interface PaymentTransactionRepository extends JpaRepository<PaymentTransaction, Long> {

	List<PaymentTransaction> findByUser(User user);
}
