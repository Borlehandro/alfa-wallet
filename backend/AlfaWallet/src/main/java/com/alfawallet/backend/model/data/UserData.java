package com.alfawallet.backend.model.data;
import lombok.*;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "user_info")
@NoArgsConstructor
@RequiredArgsConstructor
public class UserData {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "UserIdGenerator")
    @SequenceGenerator(name = "UserIdGenerator", sequenceName = "user_id_sequence", allocationSize = 1)
    @Getter
    private Integer id;

    @NonNull
    @Getter
    @Setter
    @Column(name = "device_id", nullable = false, unique = true)
    private String deviceId;

    @OneToMany(mappedBy = "owner")
    @Getter
    private List<CardData> cards;
}
