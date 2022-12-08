package com.alfawallet.backend.model.repository;

import com.alfawallet.backend.model.data.CardData;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CardRepository extends JpaRepository<CardData, Integer> {

}
