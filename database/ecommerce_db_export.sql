-- MySQL dump 10.13  Distrib 5.7.39, for osx10.12 (x86_64)
--
-- Host: localhost    Database: ecommerce_db
-- ------------------------------------------------------
-- Server version	5.7.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE DATABASE IF NOT EXISTS `ecommerce_db`;
USE `ecommerce_db`;

--
-- Table structure for table `cart_items`
--

DROP TABLE IF EXISTS `cart_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `selected_color` varchar(50) DEFAULT NULL,
  `selected_size` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_product_color` (`user_id`,`product_id`,`selected_color`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Running','2025-11-20 12:06:17'),(2,'Fitness','2025-11-20 12:06:17'),(3,'Swimming','2025-11-20 12:06:17'),(4,'Cycling','2025-11-20 12:06:17'),(5,'Football','2025-11-20 12:06:17'),(6,'Basketball','2025-11-20 12:06:17'),(7,'Tennis','2025-11-20 12:06:17'),(8,'Hiking','2025-11-20 12:06:17');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `selected_color` varchar(50) DEFAULT NULL,
  `selected_size` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `status` enum('pending','completed','cancelled') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `original_price` decimal(10,2) DEFAULT NULL,
  `category_id` int(11) NOT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `discount_percentage` int(11) DEFAULT '0',
  `stock` int(11) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `available_colors` varchar(500) DEFAULT NULL,
  `available_sizes` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Kalenji Running Shoes','Lightweight and comfortable running shoes for all terrains',49.99,69.99,1,'https://i.pinimg.com/736x/f4/de/b4/f4deb4014f79cf29f0cfc3d82990aff5.jpg',29,50,'2025-11-20 12:06:17','2025-11-27 11:23:32',NULL,'38,39,40,41,42,43,44,45,49'),(2,'Breathable Running T-Shirt','Technical anti-sweat t-shirt for running',12.99,19.99,1,'https://i.pinimg.com/736x/ff/17/c1/ff17c19edfb5cb278b7677a2dd41c73c.jpg',35,100,'2025-11-20 12:06:17','2025-11-27 11:05:49','Black,White,Blue,Gray,Red','XS,S,M,L,XL'),(3,'Running Shorts','Light and airy shorts for running',14.99,NULL,1,'https://i.pinimg.com/1200x/de/cf/0c/decf0c4a3f43f56cae869ba340743e62.jpg',0,75,'2025-11-20 12:06:17','2025-11-27 10:59:57',NULL,'XS,S,M,L,XL'),(4,'Adjustable Dumbbells 2x10kg','Pair of adjustable 2x10kg dumbbells for weight training',79.99,99.99,2,'https://i.pinimg.com/736x/85/c9/db/85c9db51bdfe52b599e261f177ddda0e.jpg',20,30,'2025-11-20 12:06:17','2025-11-21 13:13:59',NULL,NULL),(5,'Premium Yoga Mat','Non-slip yoga mat 6mm thick',24.99,34.99,2,'https://i.pinimg.com/736x/05/48/51/054851f574632c04fe23ded48673c3ca.jpg',29,60,'2025-11-20 12:06:17','2025-11-27 11:05:51','Purple,Blue,Pink,Green,Black','XS,S,M,L,XL'),(6,'Professional Jump Rope','Professional jump rope with ball bearings',9.99,NULL,2,'https://i.pinimg.com/736x/4f/7a/d9/4f7ad9402c8655e0ad4d8a65f247f377.jpg',0,80,'2025-11-20 12:06:17','2025-11-21 13:33:54',NULL,NULL),(7,'Anti-Fog Swimming Goggles','Swimming goggles with anti-fog treatment',15.99,24.99,3,'https://i.pinimg.com/736x/81/69/8b/81698bee00f2a513e7284fee41cb7905.jpg',36,40,'2025-11-20 12:06:17','2025-11-21 13:33:54',NULL,NULL),(8,'Silicone Swim Cap','Soft and resistant silicone swim cap',4.99,NULL,3,'https://i.pinimg.com/1200x/18/9f/73/189f73d1f078e2a567be43e8757f3a4a.jpg',0,100,'2025-11-20 12:06:17','2025-11-27 10:55:16','Blue,Red,Black,White,Pink,Sky Blue,Yellow,Gray',NULL),(9,'Men\'s Swim Trunks','Elastic polyester swim trunks',19.99,29.99,3,'https://i.pinimg.com/736x/26/90/b4/2690b4e688392840a05af872d43bc58c.jpg',33,50,'2025-11-20 12:06:17','2025-11-27 10:59:57',NULL,'XS,S,M,L,XL'),(10,'Road Bike Helmet','Aerated bike helmet with optimized ventilation system',39.99,59.99,4,'https://i.pinimg.com/736x/02/fb/21/02fb21e80301533576ba069d0bb7f0ce.jpg',33,35,'2025-11-20 12:06:17','2025-11-21 13:33:54',NULL,NULL),(11,'Pro Cycling Jersey','Breathable cycling jersey with rear pockets',34.99,49.99,4,'https://i.pinimg.com/736x/22/72/06/2272067948311d13f1037bba255ce989.jpg',30,45,'2025-11-20 12:06:17','2025-11-27 10:59:57',NULL,'XS,S,M,L,XL'),(12,'Gel Bike Gloves','Bike gloves with gel protection for comfort',12.99,NULL,4,'https://i.pinimg.com/1200x/ca/61/f1/ca61f18fcf99f724a30b36a43d082ed9.jpg',0,60,'2025-11-20 12:06:17','2025-11-21 13:33:54',NULL,NULL),(13,'Professional Football','Size 5 football in synthetic leather',24.99,39.99,5,'https://i.pinimg.com/736x/65/d1/bd/65d1bdf42dc3062f1d01622580380b09.jpg',38,40,'2025-11-20 12:06:17','2025-11-21 13:33:54',NULL,NULL),(14,'Football Cleats','Football shoes with molded cleats for grass fields',59.99,89.99,5,'https://i.pinimg.com/1200x/09/99/a0/0999a06a94005d46259f400f6332b009.jpg',33,25,'2025-11-20 12:06:17','2025-11-27 11:04:11',NULL,'38,39,40,41,42,43,44,45,46'),(15,'Shin Guards','Lightweight and resistant shin guards',8.99,NULL,5,'https://i.pinimg.com/736x/7c/f0/1a/7cf01a9debc2a546eec7872c1a7f2d45.jpg',0,70,'2025-11-20 12:06:17','2025-11-21 13:33:54',NULL,NULL),(16,'Spalding Basketball','Official size 7 basketball',29.99,44.99,6,'https://i.pinimg.com/736x/03/5d/09/035d0998ee4ee2834fbf5dbbb4fbbbdd.jpg',33,30,'2025-11-20 12:06:17','2025-11-21 13:33:54',NULL,NULL),(17,'Air Basketball Shoes','Basketball shoes with air cushioning for jumps',89.99,129.99,6,'https://i.pinimg.com/1200x/c7/be/97/c7be978b3c986192037a9f6735271dc3.jpg',31,20,'2025-11-20 12:06:17','2025-11-27 11:04:11',NULL,'38,39,40,41,42,43,44,45,46'),(18,'Basketball Jersey','Breathable polyester basketball jersey',19.99,NULL,6,'https://i.pinimg.com/1200x/f0/89/2d/f0892d52afba903a8ba6a5dbf857e07e.jpg',0,55,'2025-11-20 12:06:17','2025-11-27 10:59:57',NULL,'XS,S,M,L,XL'),(19,'Professional Tennis Racket','Graphite tennis racket with pre-installed strings',79.99,119.99,7,'https://i.pinimg.com/1200x/4d/26/38/4d26383fda8c791ed9f19d67ba0bae7a.jpg',33,15,'2025-11-20 12:06:17','2025-11-21 13:33:54',NULL,NULL),(20,'Tennis Balls x4','Tube of 4 pressurized tennis balls',7.99,12.99,7,'https://i.pinimg.com/1200x/37/31/11/3731115e12c774133e834c1586ea9646.jpg',38,100,'2025-11-20 12:06:17','2025-11-21 13:33:54',NULL,NULL),(21,'Court Tennis Shoes','Tennis shoes for hard court',54.99,NULL,7,'https://i.pinimg.com/1200x/32/43/2c/32432c8c9fe144cbdfbcb1db4d4500c3.jpg',0,30,'2025-11-20 12:06:17','2025-11-27 11:04:11',NULL,'38,39,40,41,42,43,44,45,46'),(22,'40L Hiking Backpack','Hiking backpack with ventilation system',69.99,99.99,8,'https://i.pinimg.com/1200x/0e/e3/ca/0ee3cac1394eaad10ad6df5e817dccd3.jpg',30,25,'2025-11-20 12:06:17','2025-11-21 13:33:54',NULL,NULL),(23,'Hiking Boots','Waterproof and breathable hiking boots',89.99,129.99,8,'https://i.pinimg.com/1200x/fd/a6/b5/fda6b54404622cf9dc4190f972915ddb.jpg',31,20,'2025-11-20 12:06:17','2025-11-27 11:04:11',NULL,'38,39,40,41,42,43,44,45,46'),(24,'Telescopic Trekking Poles','Pair of adjustable trekking poles',39.99,NULL,8,'https://i.pinimg.com/1200x/22/25/39/222539c6121d8976c735d0b650f4d4ef.jpg',0,35,'2025-11-20 12:06:17','2025-11-21 13:33:54',NULL,NULL),(25,'Compression Running Socks','Comfortable compression socks designed to improve blood circulation, reduce fatigue, and support long-distance running.',14.99,19.99,1,'https://i.pinimg.com/1200x/50/6f/c9/506fc9ee36537b80d30bb5699fb92080.jpg',25,120,'2025-11-23 21:44:54','2025-11-27 10:59:57',NULL,'XS,S,M,L,XL'),(26,'Bike Bottle Cage + Bottle','Lightweight bottle cage with a 600ml BPA-free bottle, designed for secure hydration during cycling rides.',12.99,17.99,4,'https://i.pinimg.com/1200x/c4/5a/4b/c45a4b76abe096b15ee64d6f2bb8f4fb.jpg',28,90,'2025-11-23 21:49:07','2025-11-23 21:49:07',NULL,NULL);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ratings`
--

DROP TABLE IF EXISTS `ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ratings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `rating` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_product` (`user_id`,`product_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `ratings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ratings_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ratings`
--

LOCK TABLES `ratings` WRITE;
/*!40000 ALTER TABLE `ratings` DISABLE KEYS */;
/*!40000 ALTER TABLE `ratings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nickname` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('user','admin') DEFAULT 'user',
  `is_banned` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Admin','admin@example.com','$2a$10$QQYRf652GLFRL0ncnpUXKeyEakh1uGbBvEWtzZ36RfU1YcAs2J25C','admin',0,'2025-11-20 10:40:30','2025-11-20 11:48:40');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'ecommerce_db'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-27 12:46:31
