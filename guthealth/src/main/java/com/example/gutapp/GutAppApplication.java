package com.example.gutapp;


import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
//@EntityScan(basePackages = "com.example.gutapp.model")
public class GutAppApplication {

	public static void main(String[] args) {	
		SpringApplication.run(GutAppApplication.class, args);
	}




}
