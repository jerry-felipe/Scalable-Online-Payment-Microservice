package com.jerryfelipe.pagos.service;

import com.jerryfelipe.pagos.model.CurrencyRate;
import com.jerryfelipe.pagos.repository.CurrencyRateRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CurrencyRateService {

    @Autowired
    private CurrencyRateRepository repository;

    public List<CurrencyRate> getAllRates() {
        return repository.findAll();
    }
}
