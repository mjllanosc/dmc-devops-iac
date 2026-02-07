package com.example.saludo.controller;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@CrossOrigin(origins = "*")
public class SaludoController {

    @GetMapping("/saludo")
    public String saludo() {
        return "Hola Mundo desde Docker";
    }

    @GetMapping("/mostrar_secreto")
    public String mostrarSecreto() {
        String value = System.getenv("KEYVAULT_VALUE");
        if (value == null || value.isEmpty()) {
            return "Secreto no disponible (KEYVAULT_VALUE no configurada)";
        }
        return value;
    }
}
