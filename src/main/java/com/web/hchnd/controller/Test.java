package com.web.hchnd.controller;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;

public class Test {
    public static void main(String[] args){
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

        String password = "mypassword";

        String hash1 = encoder.encode(password);
        String hash2 = encoder.encode(password);

        System.out.println("Hash 1: " + hash1);
        System.out.println("Hash 2: " + hash2);

        boolean match1 = encoder.matches(password, hash1);
        boolean match2 = encoder.matches(password, hash2);

        System.out.println("Match 1: " + match1);
        System.out.println("Match 2: " + match2);

        System.out.println("############################################");
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

        LocalDateTime ldt = LocalDateTime.parse("2023-10-12 15:19:32", formatter).plusMonths(6);
        System.out.println(ldt);

        String p = "test.jpeg";
        int point = p.indexOf(".");
        System.out.println(p.substring(point));
    }
}
