package com.alfawallet.backend.domain.service;

import com.alfawallet.backend.dto.CardDto;
import com.alfawallet.backend.dto.UserDataDto;
import com.alfawallet.backend.model.data.UserData;
import com.alfawallet.backend.model.repository.CardRepository;
import com.alfawallet.backend.model.repository.UserRepository;
import com.alfawallet.backend.yandex.YandexApiManager;
import com.alfawallet.backend.yandex.dto.YandexApiFeatureDto;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

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
    public List<CardDto> getAllCards(UserDataDto userData) {
        var latitude = userData.getLatitude();
        var longitude = userData.getLongitude();
        var userOpt = userRepository.getByDeviceId(userData.getDeviceId());
        if (userOpt.isEmpty()) {
            userRepository.save(new UserData(userData.getDeviceId()));
            return List.of();
        } else {
            var user = userOpt.get();
            List<YandexApiFeatureDto> features = new ArrayList<>();
            user.getCards().forEach((card) -> {
                var nearestFeature = yandexApiManager.searchByLocationAndCardName(
                        card.getName(),
                        latitude,
                        longitude
                ).getFeatures().stream().min(
                        Comparator.comparingDouble(
                                (item) ->
                                        distanceSquare(
                                                Double.valueOf(latitude),
                                                Double.valueOf(item.getGeometry().getCoordinates().get(0)),
                                                Double.valueOf(longitude),
                                                Double.valueOf(item.getGeometry().getCoordinates().get(1))
                                        )
                        )

                );
                nearestFeature.ifPresent(features::add);
            });
            return features.stream()
                    .sorted(
                            Comparator.comparingDouble(
                                    (item) ->
                                            distanceSquare(
                                                    Double.valueOf(latitude),
                                                    Double.valueOf(item.getGeometry().getCoordinates().get(0)),
                                                    Double.valueOf(longitude),
                                                    Double.valueOf(item.getGeometry().getCoordinates().get(1))
                                            )
                            )
                    )
                    .map((it) -> new CardDto())
                    .toList();
        }
    }

    private static Double distanceSquare(
            Double startLatitude,
            Double startLongitude,
            Double endLatitude,
            Double endLongitude
    ) {
        return Math.pow(startLatitude - endLatitude, 2) + Math.pow(startLongitude - endLongitude, 2);
    }
}
