package com.alfawallet.backend.model.data;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "card")
@NoArgsConstructor
@RequiredArgsConstructor
public class CardData {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "CardIdGenerator")
    @SequenceGenerator(name = "CardIdGenerator", sequenceName = "card_id_sequence", allocationSize = 1)
    @Getter
    private Integer id;

    @NonNull
    @Getter
    @Setter
    @Column(nullable = false)
    private String name;

    @NonNull
    @Getter
    @Setter
    @Column(nullable = false)
    private String code;

    @NonNull
    @Getter
    @Setter
    @Column(nullable = false)
    private Boolean hidden;

    @NonNull
    @Getter
    @Setter
    @ManyToOne(optional = false)
    @JoinColumn(name = "owner_id")
    private UserData owner;
}
