package com.jerryfelipe.pagos.service;

import com.jerryfelipe.pagos.model.PaymentTransaction;
import com.jerryfelipe.pagos.model.User;
import com.jerryfelipe.pagos.model.PaymentGatewayCredential;
import com.jerryfelipe.pagos.repository.PaymentTransactionRepository;
import com.jerryfelipe.pagos.repository.CurrencyRateRepository;

import java.util.List;

public class PaymentTransactionService {
    private PaymentTransactionRepository transactionRepository;
    private CurrencyRateRepository currencyRateRepository;

    public PaymentTransactionService(PaymentTransactionRepository transactionRepository, CurrencyRateRepository currencyRateRepository) {
        this.transactionRepository = transactionRepository;
        this.currencyRateRepository = currencyRateRepository;
    }

    public PaymentTransaction createTransaction(User user, double amount, String currency, PaymentGatewayCredential credential) {
        // Validaciones y lógica para crear la transacción
        String transactionId = "TXN" + System.currentTimeMillis();
        PaymentTransaction transaction = new PaymentTransaction(transactionId, user, amount, currency, credential, "PENDING");
        return transactionRepository.save(transaction);
    }

    public PaymentTransaction processTransaction(PaymentTransaction transaction) {
        // Lógica para procesar la transacción con la pasarela de pago
        transaction.setStatus("COMPLETED");
        return transactionRepository.save(transaction);
    }

    public List<PaymentTransaction> getTransactionsByUser(User user) {
        return transactionRepository.findByUser(user);
    }

	public Object getAllTransactions() {
		// TODO Auto-generated method stub
		return null;
	}

	public Object saveTransaction(PaymentTransaction transaction) {
		// TODO Auto-generated method stub
		return null;
	}
}
