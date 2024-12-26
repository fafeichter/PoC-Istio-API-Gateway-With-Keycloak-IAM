package com.ecommerce.orders.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author Fabian Feichter
 */
@RestController
public class GreetingController {

    @Value("${HOSTNAME:unknown}")
    private String podName;

    @GetMapping("/hello")
    public String getPodName(JwtAuthenticationToken authenticationToken) {
        Jwt jwt = (Jwt) authenticationToken.getCredentials();
        String userFullName = (String) jwt.getClaims().get("name");

        return "Hello from user '" + userFullName + "' and pod '" + podName + "'";
    }
}