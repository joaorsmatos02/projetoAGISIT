package com.demo.microservice.bootstorage.domain.repository;

import com.demo.microservice.bootstorage.domain.model.Operation;

import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

/**
 * Created by Arpit Khandelwal.
 */
public interface OperationRepository extends MongoRepository<Operation, String> {
}
