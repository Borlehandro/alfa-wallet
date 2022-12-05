package com.alfawallet.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserDataDto {
    private String latitude;
    private String longitude;
    private String deviceId;
    private String timestamp;
}
