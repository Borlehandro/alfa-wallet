package com.alfawallet.backend.model.repository;

import com.alfawallet.backend.model.data.UserData;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<UserData, Long> {

}
