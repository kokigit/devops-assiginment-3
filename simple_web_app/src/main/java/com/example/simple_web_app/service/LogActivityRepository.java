package com.example.simple_web_app.service;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface LogActivityRepository extends CrudRepository<LogActivity, Integer> {

}
