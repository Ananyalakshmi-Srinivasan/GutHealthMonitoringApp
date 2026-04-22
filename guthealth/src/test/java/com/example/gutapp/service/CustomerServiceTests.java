package com.example.gutapp.service;

import com.example.gutapp.models.Customer;
import com.example.gutapp.repository.CustomerRepository;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;


class CustomerServiceTests {

    @Mock
    private CustomerRepository customerRepository;

    private Customer customer;

    @InjectMocks
    private CustomerService customerService;

    @BeforeEach
    void setUp() {
        //Initialize all fields with @Mock and @InjectMocks annotations in the current test class
        MockitoAnnotations.openMocks(this);

        //Instantiate and initialize a standard Customer object for subsequent testing reuse
        customer = new Customer();
        customer.setCustomerID(1L);
        customer.setFirstName("John");
        customer.setLastName("Doe");
        customer.setEmail("john.doe@example.com");
        customer.setPassword("password123");
    }

    // Get all customers
    @Test
    void testGetAllCustomers() {

        Customer anotherCustomer = new Customer();
        anotherCustomer.setCustomerID(2L);

        when(customerRepository.findAll())
                .thenReturn(Arrays.asList(customer, anotherCustomer));

        //Execute real service layer logic
        List<Customer> result = customerService.getAllCustomers();

        assertNotNull(result);
        //Two were inserted as dummy data
        assertEquals(2, result.size());
    }

    // Get customer by email
    @Test
    void testGetCustomerByEmail() {

        when(customerRepository.findByEmail("john.doe@example.com"))
                .thenReturn(customer);

        Customer result = customerService.getCustomerByEmail("john.doe@example.com");

        assertNotNull(result);
        //The firstName of the returned object must be 'John'
        assertEquals("John", result.getFirstName());
    }

    // Create customer
    @Test
    void testCreateCustomer() {
        //Prepare the request parameter object to be passed to the service method
        Customer request = new Customer();
        request.setFirstName("Alice");
        request.setLastName("Smith");
        request.setEmail("alice@example.com");
        request.setPassword("12345");

        //Return the object passed to the save method
        when(customerRepository.save(any(Customer.class)))
                .thenAnswer(i -> i.getArguments()[0]);

        //Execute the target method with the request object
        Customer created = customerService.createCustomer(request);

        assertNotNull(created);
        //The new customer's name was successfully assigned to "Alice"
        assertEquals("Alice", created.getFirstName());
        //The new customer's email has been successfully assigned
        assertEquals("alice@example.com", created.getEmail());

        //Ensure the save() method of the fake repository is called once
        //The parameter passed is a Customer object
        verify(customerRepository).save(any(Customer.class));
    }

    // Update first name
    @Test
    void testUpdateFirstName() {

        String email = "john.doe@example.com";
        String newName = "Johnny";

        when(customerRepository.existsByEmail(email))
                .thenReturn(true);
        when(customerRepository.findByEmail(email))
                .thenReturn(customer);
        when(customerRepository.save(any(Customer.class)))
                .thenAnswer(i -> i.getArguments()[0]);
        //Try to update the name
        Customer updated = customerService.updateFirstName(email, newName);

        assertNotNull(updated);
        //Verify whether the customer's firstName has really been changed to 'Johnny'
        assertEquals(newName, updated.getFirstName());
        //Verify that the customerRepository.save() method was called
        verify(customerRepository).save(customer);
    }

    // Update last name
    @Test
    void testUpdateLastName() {

        String email = "john.doe@example.com";
        String newLastName = "Smith";

        //Assuming the email exists
        when(customerRepository.existsByEmail(email))
                .thenReturn(true);
        //Return the initialized mock data object
        when(customerRepository.findByEmail(email))
                .thenReturn(customer);
        //Use thenAnswer to dynamically return the saved object
        when(customerRepository.save(any(Customer.class)))
                .thenAnswer(i -> i.getArguments()[0]);

        //Execute target method
        Customer updated = customerService.updateLastName(email, newLastName);

        //Assertion Verification
        assertNotNull(updated);
        //Verify if the LastName has been successfully modified
        assertEquals(newLastName, updated.getLastName());

        //Ensure that the save operation has been executed
        verify(customerRepository).save(customer);
    }

    // Update email
    @Test
    void testUpdateEmail() {

        String currentEmail = "john.doe@example.com";
        String newEmail = "john.new@example.com";

        //Assuming the email exists
        when(customerRepository.existsByEmail(currentEmail))
                .thenReturn(true);
        //Return a pre-initialized fake data object based on the old email
        when(customerRepository.findByEmail(currentEmail))
                .thenReturn(customer);
        //Use thenAnswer to dynamically return the saved object
        when(customerRepository.save(any(Customer.class)))
                .thenAnswer(i -> i.getArguments()[0]);

        //Execute target method
        Customer updated = customerService.updateEmail(currentEmail, newEmail);

        assertNotNull(updated);
        //Focus on verifying whether the email has been successfully changed to the new address
        assertEquals(newEmail, updated.getEmail());

        //Ensure that the save operation has been executed
        verify(customerRepository).save(customer);
    }

    // Update password
    @Test
    void testUpdatePassword() {

        String email = "john.doe@example.com";
        String newPassword = "newSecurePassword123";

        //Assuming the email exists
        when(customerRepository.existsByEmail(email))
                .thenReturn(true);
        //Return the initialized mock data object
        when(customerRepository.findByEmail(email))
                .thenReturn(customer);
        //Use thenAnswer to dynamically return the saved object
        when(customerRepository.save(any(Customer.class)))
                .thenAnswer(i -> i.getArguments()[0]);

        //Execute target method
        Customer updated = customerService.updatePassword(email, newPassword);

        assertNotNull(updated);

        // should not stay as the original password
        assertNotEquals("password123", updated.getPassword());

        // should not be stored as plain text
        assertNotEquals(newPassword, updated.getPassword());

        // encoded password should look like a bcrypt hash
        assertTrue(updated.getPassword().startsWith("$2"));
    }

    // Delete customer by email
    @Test
    void testDeleteCustomerByEmail() {

        String email = "john.doe@example.com";

        when(customerRepository.findByEmail(email))
                .thenReturn(customer);
        //Execute a void delete method
        customerService.deleteCustomerByEmail(email);
        //Verify that findByEmail was indeed called first to check the data
        verify(customerRepository).findByEmail(email);
        //Verify that the system ultimately calls deleteById
        //also the passed ID is the correct 1L
        verify(customerRepository).deleteById(1L);
    }
}
