package com.tms.controller;

import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class LoginController {

    @PostMapping("/login")
    public Map<String, Object> login(@RequestBody Map<String, String> body) {
        String username = body.get("username");
        String password = body.get("password");

        Map<String, Object> response = new HashMap<>();

        if ("admin".equals(username) && "1234".equals(password)) {
            response.put("status", "success");
            response.put("message", "Login successful");
            response.put("user", username);
            response.put("token", "admin-token-12345");
            response.put("role", "ADMIN");
        } else {
            response.put("status", "error");
            response.put("message", "Invalid username or password");
        }

        return response;
    }

    @PostMapping("/logout")
    public Map<String, String> logout() {
        Map<String, String> response = new HashMap<>();
        response.put("message", "Logged out successfully");
        return response;
    }
}