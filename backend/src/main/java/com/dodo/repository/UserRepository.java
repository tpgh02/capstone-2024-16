package com.dodo.repository;

import java.util.Optional;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.dodo.domain.UserDomain;

@Repository
public interface UserRepository extends CrudRepository<UserDomain, String> {

    Optional<UserDomain> findByEmail(String email);
}