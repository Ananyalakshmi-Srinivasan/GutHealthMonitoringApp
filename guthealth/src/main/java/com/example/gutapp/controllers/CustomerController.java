package com.example.gutapp.controllers;

import com.example.gutapp.models.*;
import com.example.gutapp.service.*;
import org.springframework.web.bind.annotation.*;
//import com.example.gutapp.controllers.*;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import java.util.Map;
import com.example.gutapp.dto.LoginResponse;

@RestController
@RequestMapping("/api/customer")
public class CustomerController {


    //instantiates the customer service entity to ues the functions.
    private final CustomerService customerService;

    //constructor of class
    public CustomerController(CustomerService customerService) {
        this.customerService = customerService;
    }

    //Update registration interface
    //@PostMapping is used to send data to the server to create a new resource.
    //Here we are using to save a response in the database.
    // It handles HTTP POST requests sent to the /signup URL. ---> used in flutter component to send post requests
    @PostMapping("/signup")
    public ResponseEntity<?> saveResponse(@RequestBody Customer newCustomer) {
        try {
            //Try to register
            Customer savedCustomer = customerService.createCustomer(newCustomer);

            //After successful registration, a success message and the data will be returned
            LoginResponse response = new LoginResponse(
                    savedCustomer.getCustomerID(),
                    savedCustomer.getEmail(),
                    savedCustomer.getFirstName()
            );
            return ResponseEntity.ok(response);

        } catch (IllegalArgumentException e) {
            //If the Service detects a duplicate email address and throws an exception
            //this will be intercepted here
            //a 400 Bad Request status code and
            //detailed error information will be returned to the frontend.
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // Add login interface
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> credentials) {
        //Extract email and password from the JSON sent from the front end
        String email = credentials.get("email");
        String password = credentials.get("password");

        // Verify the password at the Service layer
        Customer customer = customerService.authenticateCustomer(email, password);

        //Verification failed (account does not exist or password is incorrect)
        //returning a 401 Unauthorized status code.
        if (customer == null) {
            return ResponseEntity
                    .status(HttpStatus.UNAUTHORIZED)
                    .body("Invalid email or password");
        }

        //Verification successful
        LoginResponse response = new LoginResponse(
                customer.getCustomerID(),
                customer.getEmail(),
                customer.getFirstName()
        );
        return ResponseEntity.ok(response);
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<String> forgotPassword(@RequestBody Map<String, String> request) {
        String email = request.get("email");
        String newPassword = request.get("newPassword");

        Customer updated = customerService.updatePassword(email, newPassword);
        if (updated == null) {
            return ResponseEntity.badRequest().body("Customer not found");
        }

        return ResponseEntity.ok("Password reset successful");
    }
}
