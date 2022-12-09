package com.alfawallet.backend.domain.service;

import com.alfawallet.backend.domain.data.FullCardInfo;
import com.alfawallet.backend.dto.BaseRequestDto;
import com.alfawallet.backend.dto.CardInfoDto;
import com.alfawallet.backend.dto.CardToAddDto;
import com.alfawallet.backend.model.data.CardData;
import com.alfawallet.backend.model.data.UserData;
import com.alfawallet.backend.model.repository.CardRepository;
import com.alfawallet.backend.model.repository.UserRepository;
import com.alfawallet.backend.yandex.YandexApiManager;
import com.alfawallet.backend.yandex.dto.YandexApiCompanyMetadataDto;
import com.alfawallet.backend.yandex.dto.YandexApiFeatureDto;
import com.alfawallet.backend.yandex.dto.YandexApiFeaturePropertiesDto;
import com.alfawallet.backend.yandex.dto.YandexApiGeometryDto;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

@Service
public class CardService {

    private final CardRepository cardRepository;
    private final UserRepository userRepository;
    private final YandexApiManager yandexApiManager;


    public CardService(CardRepository cardRepository, UserRepository userRepository, YandexApiManager yandexApiManager) {
        this.cardRepository = cardRepository;
        this.userRepository = userRepository;
        this.yandexApiManager = yandexApiManager;
    }

    @Transactional
    public List<CardInfoDto> getAllCards(BaseRequestDto base) {
        var latitude = base.getLocation().getLatitude();
        var longitude = base.getLocation().getLongitude();
        var userOpt = userRepository.getByDeviceId(base.getDeviceId());
        if (userOpt.isEmpty()) {
            userRepository.save(new UserData(base.getDeviceId(), new ArrayList<>()));
            return List.of();
        } else {
            var user = userOpt.get();
            List<FullCardInfo> cardsFullInfo = new ArrayList<>();
            var allCards = user.getCards();
            allCards.forEach((card) -> {
                var allFeatures = yandexApiManager.searchByLocationAndCardName(
                        card.getName(),
                        latitude,
                        longitude
                ).getFeatures();
                var nearestFeature = allFeatures.stream().min(
                        Comparator.comparingDouble(
                                (item) ->
                                        distanceSquare(
                                                Double.valueOf(latitude),
                                                Double.valueOf(item.getGeometry().getCoordinates().get(1)),
                                                Double.valueOf(longitude),
                                                Double.valueOf(item.getGeometry().getCoordinates().get(0))
                                        )
                        )

                );
                YandexApiFeatureDto featureToAdd;
                // Add very far fake feature
                featureToAdd = nearestFeature.orElseGet(() -> new YandexApiFeatureDto(
                        new YandexApiGeometryDto(
                                List.of("0.0", "0.0")
                        ),
                        new YandexApiFeaturePropertiesDto(
                                new YandexApiCompanyMetadataDto(
                                        "fake"
                                )
                        )
                ));
                cardsFullInfo.add(
                        new FullCardInfo(
                                featureToAdd,
                                new CardInfoDto(
                                        card.getId().toString(),
                                        card.getName(),
                                        card.getCode(),
                                        card.getHidden()
                                )
                        )
                );
            });
            return cardsFullInfo.stream()
                    .sorted(
                            Comparator.comparingDouble(
                                    (item) ->
                                            distanceSquare(
                                                    Double.valueOf(latitude),
                                                    Double.valueOf(item.getFeature().getGeometry().getCoordinates().get(1)),
                                                    Double.valueOf(longitude),
                                                    Double.valueOf(item.getFeature().getGeometry().getCoordinates().get(0))
                                            )
                            )
                    )
                    .map(FullCardInfo::getCard)
                    .toList();
        }
    }

    @Transactional
    public List<CardInfoDto> addCard(BaseRequestDto base, CardToAddDto card) {
        var userOpt = userRepository.getByDeviceId(base.getDeviceId());
        UserData user;
        if (userOpt.isEmpty()) {
            user = userRepository.save(new UserData(base.getDeviceId(), new ArrayList<>()));
        } else {
            user = userOpt.get();
        }
        var cardData = new CardData(card.getName(), card.getBarcode(), false, user);
        cardRepository.save(cardData);
        user.getCards().add(cardData);
        if (user.getCards().size() == 1) {
            return List.of(
                    new CardInfoDto(
                            cardData.getId().toString(),
                            cardData.getName(),
                            cardData.getCode(),
                            cardData.getHidden()
                    )
            );
        } else {
            userRepository.save(user);
            return getAllCards(base);
        }
    }

    @Transactional
    public List<CardInfoDto> deleteCard(BaseRequestDto base, Integer cardToDeleteId) {
        var cardOpt = cardRepository.findById(cardToDeleteId);
        if (cardOpt.isEmpty()) {
            throw new IllegalArgumentException("Incorrect id:" + cardToDeleteId);
        }
        var card = cardOpt.get();
        var userOpt = userRepository.getByDeviceId(base.getDeviceId());
        if (userOpt.isEmpty()) {
            throw new IllegalArgumentException("User with id " + base.getDeviceId() + " does not exist.");
        }
        var user = userOpt.get();
        if (!card.getOwner().getId().equals(user.getId())) {
            throw new IllegalArgumentException("Incorrect id:" + cardToDeleteId);
        }
        cardRepository.delete(card);
        user.getCards().remove(card);
        userRepository.save(user);
        return getAllCards(base);
    }

    @Transactional
    public List<CardInfoDto> updateCard(BaseRequestDto base, CardInfoDto updatedCard) {
        var cardOpt = cardRepository.findById(Integer.valueOf(updatedCard.getId()));
        if (cardOpt.isEmpty()) {
            throw new IllegalArgumentException("Incorrect id:" + updatedCard.getId());
        }
        var card = cardOpt.get();
        var userOpt = userRepository.getByDeviceId(base.getDeviceId());
        if (userOpt.isEmpty()) {
            throw new IllegalArgumentException("User with id " + base.getDeviceId() + " does not exist.");
        }
        var user = userOpt.get();
        if (!card.getOwner().getId().equals(user.getId())) {
            throw new IllegalArgumentException("Incorrect id:" + updatedCard.getId());
        }
        var cardIndex = user.getCards().indexOf(card);
        card.setName(updatedCard.getName());
        card.setHidden(updatedCard.getHidden());
        card.setCode(updatedCard.getBarcode());
        cardRepository.save(card);
        user.getCards().set(cardIndex, card);
        userRepository.save(user);
        return getAllCards(base);
    }

    private static Double distanceSquare(
            Double startLatitude,
            Double endLatitude,
            Double startLongitude,
            Double endLongitude
    ) {
        return Math.pow(startLatitude - endLatitude, 2) + Math.pow(startLongitude - endLongitude, 2);
    }
}
