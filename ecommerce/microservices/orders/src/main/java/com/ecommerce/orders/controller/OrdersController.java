package com.ecommerce.orders.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.Random;

/**
 * @author Fabian Feichter
 */
@RestController
public class OrdersController {

    private final String[] orderNames = {
            "MacBook Pro", "iPhone 14", "Samsung Galaxy S21",
            "Sony WH-1000XM4", "Dell XPS 13", "PlayStation 5",
            "Kindle Paperwhite", "Nikon D3500", "Apple Watch Series 10",
            "LG OLED TV", "GoPro Hero 13", "Bose SoundLink"
    };

    private final Random random = new Random();

    @GetMapping("/{orderId}")
    public Order getOrder(@PathVariable String orderId) {
        String randomOrderName = getRandomOrderName();
        return new Order(orderId, randomOrderName);
    }

    private String getRandomOrderName() {
        int index = random.nextInt(orderNames.length);
        return orderNames[index];
    }

    public record Order(String id, String name) {
    }
}