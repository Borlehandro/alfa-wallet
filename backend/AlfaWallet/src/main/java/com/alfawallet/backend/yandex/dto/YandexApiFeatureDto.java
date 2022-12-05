package com.alfawallet.backend.yandex.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class YandexApiFeatureDto {

    YandexApiGeometryDto geometry;
    YandexApiFeaturePropertiesDto properties;
}
