package com.alfawallet.backend.controllers;

import com.alfawallet.backend.domain.service.CardService;
import com.alfawallet.backend.dto.*;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/cards")
public class CardController {

    private final CardService cardService;

    public CardController(CardService cardService) {
        this.cardService = cardService;
    }

    @Operation(summary = "Get all user cards sorted by geolocation")
    @PostMapping(value = "/all")
    public List<CardInfoDto> cards(@RequestBody BaseRequestDto request) {
        return cardService.getAllCards(request);
    }

    @Operation(summary = "Add new card")
    @PostMapping
    public List<CardInfoDto> addCard(@RequestBody AddCardRequestDto request) {
        // TODO: Implement
        return cardService.getAllCards(request.getBase());
    }

    @Operation(summary = "Delete card by id")
    @PostMapping(value = "/delete/{id}")
    public List<CardInfoDto> deleteCard(
            @RequestBody BaseRequestDto request,
            @PathVariable(name = "id") Integer cardId
    ) {
        // TODO: Implement
        return cardService.getAllCards(request);
    }

    @Operation(summary = "Update current card")
    @PutMapping
    public List<CardInfoDto> updateCard(@RequestBody UpdateCardRequest request) {
        // TODO: Implement
        return cardService.getAllCards(request.getBase());
    }
}
