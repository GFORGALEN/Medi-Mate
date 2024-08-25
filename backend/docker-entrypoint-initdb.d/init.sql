CREATE TABLE `medicine` (
                            `product_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                            `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
                            `product_price` double DEFAULT NULL,
                            `manufacturer_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
                            `general_information` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
                            `warnings` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
                            `common_use` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
                            `ingredients` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
                            `directions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
                            `image_src` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
                            `summary` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
                            `created_at` timestamp NULL DEFAULT NULL,
                            `updated_at` timestamp NULL DEFAULT NULL,
                            PRIMARY KEY (`product_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `pharmacy` (
                            `pharmacy_id` int NOT NULL AUTO_INCREMENT,
                            `pharmacy_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                            `latitude` double NOT NULL,
                            `longitude` double NOT NULL,
                            `pharmacy_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                            PRIMARY KEY (`pharmacy_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `pharmacy_inventory` (
                                      `inventory_id` int NOT NULL AUTO_INCREMENT,
                                      `pharmacy_id` int NOT NULL,
                                      `product_id` varchar(255) NOT NULL,
                                      `stock_quantity` int DEFAULT '0',
                                      `shelf_number` varchar(5) NOT NULL,
                                      `shelf_level` int DEFAULT NULL,
                                      PRIMARY KEY (`inventory_id`),
                                      KEY `pharmacy_id` (`pharmacy_id`),
                                      KEY `product_id` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9381 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `user` (
                        `user_id` varchar(255) NOT NULL,
                        `email` varchar(100) NOT NULL,
                        `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                        `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                        `google_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
                        `nickname` varchar(255) DEFAULT NULL,
                        `user_pic` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
                        `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                        `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                        PRIMARY KEY (`user_id`,`email`) USING BTREE,
                        UNIQUE KEY `email` (`email`),
                        UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `user_favorites` (
                                  `favorite_id` int NOT NULL AUTO_INCREMENT,
                                  `user_id` int NOT NULL,
                                  `product_id` varchar(255) NOT NULL,
                                  `favorited_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                  PRIMARY KEY (`favorite_id`),
                                  UNIQUE KEY `user_product_unique` (`user_id`,`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `user_info` (
                             `user_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                             `birth_year` int DEFAULT NULL,
                             `user_weight` double DEFAULT NULL,
                             `user_height` double DEFAULT NULL,
                             PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

