package com.alfawallet.backend.yandex.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class YandexApiResponseDto {

    List<YandexApiFeatureDto> features;
}
