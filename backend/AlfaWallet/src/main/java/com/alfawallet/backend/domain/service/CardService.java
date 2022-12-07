package com.alfawallet.backend.domain.service;

import com.alfawallet.backend.domain.data.FullCardInfo;
import com.alfawallet.backend.dto.BaseRequestDto;
import com.alfawallet.backend.dto.CardInfoDto;
import com.alfawallet.backend.model.data.UserData;
import com.alfawallet.backend.model.repository.CardRepository;
import com.alfawallet.backend.model.repository.UserRepository;
import com.alfawallet.backend.yandex.YandexApiManager;
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
            userRepository.save(new UserData(base.getDeviceId()));
            return List.of();
        } else {
            var user = userOpt.get();
            List<FullCardInfo> cardsFullInfo = new ArrayList<>();
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
                nearestFeature.ifPresent(yandexApiFeatureDto -> cardsFullInfo.add(
                        new FullCardInfo(
                                yandexApiFeatureDto,
                                new CardInfoDto(
                                        card.getId().toString(),
                                        card.getName(),
                                        card.getCode(),
                                        card.getHidden()
                                )
                        )
                ));
            });
            return cardsFullInfo.stream()
                    .sorted(
                            Comparator.comparingDouble(
                                    (item) ->
                                            distanceSquare(
                                                    Double.valueOf(latitude),
                                                    Double.valueOf(item.getFeature().getGeometry().getCoordinates().get(0)),
                                                    Double.valueOf(longitude),
                                                    Double.valueOf(item.getFeature().getGeometry().getCoordinates().get(1))
                                            )
                            )
                    )
                    .map(FullCardInfo::getCard)
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
