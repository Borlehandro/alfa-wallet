package com.alfawallet.backend.yandex;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.WebClient;

@Configuration
class YandexApiConfig {

    @Bean
    public WebClient yandexApiClient() {
        return WebClient.create("https://search-maps.yandex.ru/v1/");
    }
}