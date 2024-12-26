package com.ecommerce.customers.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.Random;

/**
 * @author Fabian Feichter
 */
@RestController
public class CustomersController {

    private final String[] names = {
            "Hans", "Anna", "Paul", "Maria", "John", "Jane",
            "Alex", "Lucy", "Michael", "Emily", "Chris", "Sara"
    };

    private final Random random = new Random();

    @GetMapping("/{customerId}")
    public Customer getCustomers(@PathVariable Integer customerId) {
        String randomName = getRandomName();
        return new Customer(customerId, randomName);
    }

    private String getRandomName() {
        int index = random.nextInt(names.length);
        return names[index];
    }

    public record Customer(Integer id, String name) {
    }
}