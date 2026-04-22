package com.example.gutapp.repository;

import com.example.gutapp.models.Customer;
import org.springframework.data.jpa.repository.JpaRepository;


public interface CustomerRepository extends JpaRepository<Customer, Long> {
    // according to email find customer
    Customer findByEmail(String email);
    Customer findByCustomerID(Long customerID);
    boolean existsByEmail(String email);


}
