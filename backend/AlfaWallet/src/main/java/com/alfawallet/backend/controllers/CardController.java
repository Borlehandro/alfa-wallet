package com.alfawallet.backend.controllers;

import com.alfawallet.backend.dto.CardDto;
import com.alfawallet.backend.dto.UserDataDto;
import com.alfawallet.backend.service.CardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class CardController {

    @Autowired
    private final CardService cardService;

    public CardController(CardService cardService) {
        this.cardService = cardService;
    }

    @GetMapping(value = "/cards")
    public List<CardDto> cards(UserDataDto userData) {
        return cardService.getAllCards(userData);
    }

    @PostMapping(value = "cards/add")
    public List<CardDto> addCard(@RequestBody CardDto cardDto, @RequestParam String latitude, @RequestParam String longitude,
                                 @RequestParam Long deviceId, @RequestParam String timestamp) {
        return cardService.addCard(cardDto, latitude, longitude, deviceId, timestamp);
    }

    @PostMapping(value = "cards/delete")
    public List<CardDto> deleteCard(UserDataDto userData) {
        return cardService.deleteCard(userData);
    }
}
