package com.alfawallet.backend.yandex;

import com.alfawallet.backend.yandex.dto.YandexApiResponseDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;

@Component
public class YandexApiManager {

    @Autowired
    private WebClient yandexApiClient;

    public YandexApiResponseDto searchByLocationAndCardName(String name, String latitude, String longitude) {
        return yandexApiClient
                .get()
                .uri(uriBuilder -> uriBuilder
                        // TODO: Move to properties
                        .queryParam("apikey", "36765562-ed22-42e0-8daf-53cfbb2ed68f")
                        .queryParam("text", name)
                        .queryParam("lang", "ru_RU")
                        .queryParam("type", "biz")
                        .queryParam("ll", longitude + "," + latitude)
                        .queryParam("spn", "0.004500,0.004500")
                        .queryParam("rspn", 1)
                        .build()
                )
                .retrieve()
                .bodyToMono(YandexApiResponseDto.class)
                .cache()
                .block();
    }
}
