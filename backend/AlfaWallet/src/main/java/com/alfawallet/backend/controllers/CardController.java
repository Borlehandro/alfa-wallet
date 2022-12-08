package com.alfawallet.backend.controllers;

import com.alfawallet.backend.domain.service.CardService;
import com.alfawallet.backend.dto.*;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/cards")
public class CardController {

    private final CardService cardService;

    public CardController(CardService cardService) {
        this.cardService = cardService;
    }

    @Operation(summary = "Get all user cards sorted by geolocation")
    @PostMapping(value = "/all")
    public CardsInfoResponse cards(@RequestBody BaseRequestDto request) {
        return new CardsInfoResponse(cardService.getAllCards(request));
    }

    @Operation(summary = "Add new card")
    @PostMapping(value = "/add")
    public CardsInfoResponse addCard(@RequestBody AddCardRequestDto request) {
        return new CardsInfoResponse(cardService.addCard(request.getBase(), request.getCard()));
    }

    @Operation(summary = "Delete card by id")
    @PostMapping(value = "/delete/{id}")
    public CardsInfoResponse deleteCard(
            @RequestBody BaseRequestDto request,
            @PathVariable(name = "id") Integer cardId
    ) {
        return new CardsInfoResponse(cardService.deleteCard(request, cardId));
    }

    @Operation(summary = "Update current card")
    @PostMapping(value = "/update")
    public CardsInfoResponse updateCard(@RequestBody UpdateCardRequest request) {
        return new CardsInfoResponse(cardService.updateCard(request.getBase(), request.getCard()));
    }
}
