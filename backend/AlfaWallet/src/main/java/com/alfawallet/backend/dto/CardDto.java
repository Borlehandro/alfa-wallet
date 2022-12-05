package com.alfawallet.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CardDto {
    private String id;
    private String name;
    private String barcode;
    private Boolean hidden;
}
