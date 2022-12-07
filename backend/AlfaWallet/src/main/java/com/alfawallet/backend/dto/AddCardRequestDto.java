package com.alfawallet.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AddCardRequestDto {
    CardToAddDto card;
    BaseRequestDto base;
}
