package com.martonverhoczki.taytayserver.user.repository;

import com.martonverhoczki.taytayserver.user.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
}
