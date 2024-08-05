package com.friedchicken.utils;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Component
public class JwtUtil {

    @Value("${fc.jwt.admin-secret-key}")
    private String adminSecretKey;

    @Value("${fc.jwt.admin-ttl}")
    private long adminTtl;

    @Value("${fc.jwt.user-secret-key}")
    private String userSecretKey;

    @Value("${fc.jwt.user-ttl}")
    private long userTtl;

    public String generateAdminToken(String username,Map<String, Object> claims) {
        return generateToken(username, adminSecretKey, adminTtl,claims);
    }

    public String generateUserToken(String username,Map<String, Object> claims) {
        return generateToken(username, userSecretKey, userTtl,claims);
    }

    private String generateToken(String username, String secretKey, long ttl,Map<String, Object> claims) {
        return Jwts.builder()
                .setClaims(claims)
                .setSubject(username)
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + ttl))
                .signWith(SignatureAlgorithm.HS256, secretKey)
                .compact();
    }

    public boolean validateToken(String token, String secretKey) {
        try {
            Jwts.parser().setSigningKey(secretKey).parseClaimsJws(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public String getUsernameFromToken(String token, String secretKey) {
        Claims claims = Jwts.parser().setSigningKey(secretKey).parseClaimsJws(token).getBody();
        return claims.getSubject();
    }
}
