package com.alfawallet.backend.domain.data;

import com.alfawallet.backend.dto.CardInfoDto;
import com.alfawallet.backend.yandex.dto.YandexApiFeatureDto;
import lombok.Data;
import lombok.NonNull;

@Data
public class FullCardInfo {

    @NonNull
    YandexApiFeatureDto feature;

    @NonNull
    CardInfoDto card;
}
