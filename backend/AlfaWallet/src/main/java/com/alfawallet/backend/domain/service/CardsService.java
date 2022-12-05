package com.alfawallet.backend.domain.service;

import com.alfawallet.backend.model.repository.CardRepository;
import com.alfawallet.backend.model.repository.UserRepository;
import org.springframework.stereotype.Service;

@Service
public class CardsService {

    private final CardRepository cardRepository;
    private final UserRepository userRepository;

    public CardsService(CardRepository cardRepository, UserRepository userRepository) {
        this.cardRepository = cardRepository;
        this.userRepository = userRepository;
    }



}
