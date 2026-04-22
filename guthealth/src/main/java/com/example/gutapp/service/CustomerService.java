package com.example.gutapp.service;

import com.example.gutapp.models.*;


import com.example.gutapp.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.util.List;

@Service
public class CustomerService {
    private final CustomerRepository customerRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    public CustomerService(CustomerRepository customerRepository) {
        this.customerRepository = customerRepository;
        this.passwordEncoder = new BCryptPasswordEncoder();
    }

    // get customers

    public List<Customer> getAllCustomers() {
        return customerRepository.findAll();
    }

    public Customer getCustomerByEmail(String email) {
        return customerRepository.findByEmail(email);
    }

    public Customer getCustomerByID(Long id) {
        return customerRepository.findByCustomerID(id);
    }

    //create a customer entity

    public Customer createCustomer(Customer customer) {

        //Check if the email already exists before registration
        if (customerExists(customer.getEmail())) {
            throw new IllegalArgumentException("Email is already registered!");
        }

        Customer newCustomer = new Customer();
        List<SurveyResponse> responseList = newCustomer.getResponses();
        List<MoodLog> emotionLogList = newCustomer.getMoodLogs();


        newCustomer.setFirstName(customer.getFirstName());
        newCustomer.setLastName(customer.getLastName());
        newCustomer.setEmail(customer.getEmail());
        newCustomer.setPassword(passwordEncoder.encode(customer.getPassword()));
        newCustomer.setResponses(responseList);
        newCustomer.setMoodLogs(emotionLogList);

        return customerRepository.save(newCustomer);
    }

    //Add login logic
    public boolean verifyLogin(String email, String rawPassword) {
        //Reuse the written method to find users
        Customer customer = getCustomerByEmail(email);

        if (customer != null) {
            //Compare password with the hashed stored password
            return passwordEncoder.matches(rawPassword, customer.getPassword());
        }
        return false;
    }

    //update details
    //update existing customer entities.
    public Customer updateFirstName(String email, String newName) {
        if (customerExists(email)) {
            Customer customer = getCustomerByEmail(email);
            customer.setFirstName(newName);
            return customerRepository.save(customer);
        }

        System.out.println("Customer not found!!!!");
        return null;
    }

    public Customer updateLastName(String email, String newName) {
        if (customerExists(email)) {
            Customer customer = getCustomerByEmail(email);
            customer.setLastName(newName);
            return customerRepository.save(customer);
        }

        System.out.println("Customer not found!!!!");
        return null;
    }

    public Customer updateEmail(String currentEmail, String newEmail) {
        if (customerExists(currentEmail)) {
            Customer customer = getCustomerByEmail(currentEmail);
            customer.setEmail(newEmail);
            return customerRepository.save(customer);
        }

        System.out.println("Customer not found!!!!");
        return null;
    }

    public Customer updatePassword(String email, String newPassword) {
        if (customerExists(email)) {
            Customer customer = getCustomerByEmail(email);
            customer.setPassword(passwordEncoder.encode(newPassword));
            return customerRepository.save(customer);
        }
        System.out.println("Customer not found!!!!");
        return null;
    }

    // checks if a customer exists or not.

    boolean customerExists(String email) {
        return customerRepository.existsByEmail(email);
    }

    public void deleteCustomerByEmail(String email) {
        Customer customer = getCustomerByEmail(email);
        customerRepository.deleteById(customer.getCustomerID());
    }

    //deletes customers.

    public void deleteCustomerById(Long id) {
        customerRepository.deleteById(id);
    }

    public void deleteAllCustomers(Long id) {
        customerRepository.deleteAll();
    }

    public Customer authenticateCustomer(String email, String rawPassword) {
        Customer customer = getCustomerByEmail(email);

        if (customer != null && passwordEncoder.matches(rawPassword, customer.getPassword())) {
            return customer;
        }

        return null;
    }

}