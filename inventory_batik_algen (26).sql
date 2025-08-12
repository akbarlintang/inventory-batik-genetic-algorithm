-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 12, 2025 at 11:52 AM
-- Server version: 8.0.30
-- PHP Version: 8.3.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `inventory_batik_algen`
--

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int NOT NULL,
  `name` varchar(150) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add user', 4, 'add_user'),
(14, 'Can change user', 4, 'change_user'),
(15, 'Can delete user', 4, 'delete_user'),
(16, 'Can view user', 4, 'view_user'),
(17, 'Can add content type', 5, 'add_contenttype'),
(18, 'Can change content type', 5, 'change_contenttype'),
(19, 'Can delete content type', 5, 'delete_contenttype'),
(20, 'Can view content type', 5, 'view_contenttype'),
(21, 'Can add session', 6, 'add_session'),
(22, 'Can change session', 6, 'change_session'),
(23, 'Can delete session', 6, 'delete_session'),
(24, 'Can view session', 6, 'view_session'),
(25, 'Can add item', 7, 'add_item'),
(26, 'Can change item', 7, 'change_item'),
(27, 'Can delete item', 7, 'delete_item'),
(28, 'Can view item', 7, 'view_item'),
(29, 'Can add outlet', 8, 'add_outlet'),
(30, 'Can change outlet', 8, 'change_outlet'),
(31, 'Can delete outlet', 8, 'delete_outlet'),
(32, 'Can view outlet', 8, 'view_outlet'),
(33, 'Can add purchase', 9, 'add_purchase'),
(34, 'Can change purchase', 9, 'change_purchase'),
(35, 'Can delete purchase', 9, 'delete_purchase'),
(36, 'Can view purchase', 9, 'view_purchase'),
(37, 'Can add sales', 10, 'add_sales'),
(38, 'Can change sales', 10, 'change_sales'),
(39, 'Can delete sales', 10, 'delete_sales'),
(40, 'Can view sales', 10, 'view_sales'),
(41, 'Can add transaction', 11, 'add_transaction'),
(42, 'Can change transaction', 11, 'change_transaction'),
(43, 'Can delete transaction', 11, 'delete_transaction'),
(44, 'Can view transaction', 11, 'view_transaction'),
(45, 'Can add production', 12, 'add_production'),
(46, 'Can change production', 12, 'change_production'),
(47, 'Can delete production', 12, 'delete_production'),
(48, 'Can view production', 12, 'view_production'),
(49, 'Can add stock', 13, 'add_stock'),
(50, 'Can change stock', 13, 'change_stock'),
(51, 'Can delete stock', 13, 'delete_stock'),
(52, 'Can view stock', 13, 'view_stock'),
(53, 'Can add recipe', 14, 'add_recipe'),
(54, 'Can change recipe', 14, 'change_recipe'),
(55, 'Can delete recipe', 14, 'delete_recipe'),
(56, 'Can view recipe', 14, 'view_recipe'),
(57, 'Can add material', 15, 'add_material'),
(58, 'Can change material', 15, 'change_material'),
(59, 'Can delete material', 15, 'delete_material'),
(60, 'Can view material', 15, 'view_material'),
(61, 'Can add employee', 16, 'add_employee'),
(62, 'Can change employee', 16, 'change_employee'),
(63, 'Can delete employee', 16, 'delete_employee'),
(64, 'Can view employee', 16, 'view_employee'),
(65, 'Can add outlet item', 17, 'add_outletitem'),
(66, 'Can change outlet item', 17, 'change_outletitem'),
(67, 'Can delete outlet item', 17, 'delete_outletitem'),
(68, 'Can view outlet item', 17, 'view_outletitem');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user`
--

CREATE TABLE `auth_user` (
  `id` int NOT NULL,
  `password` varchar(128) COLLATE utf8mb4_general_ci NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `first_name` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `last_name` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(254) COLLATE utf8mb4_general_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `role` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'admin',
  `outlet` bigint DEFAULT NULL,
  `date_joined` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auth_user`
--

INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `role`, `outlet`, `date_joined`) VALUES
(1, 'pbkdf2_sha256$260000$msRc2UxRnMN4TydoLVgEmd$/jR3LZI1Z/074P+udEdoAOGqsdXHOqkfjycLxRO89dA=', '2025-07-26 19:40:03.804134', 0, 'admin', '', '', '', 0, 1, 'superadmin', NULL, '2024-08-08 14:05:12.935467'),
(8, 'pbkdf2_sha256$260000$DloVg8YN9WpvWsDjfWxvoJ$FUA8f568TBLomMn/9VPM7NrWPYpzdg92Ssu2el0VSOU=', '2025-07-26 19:50:30.830279', 0, 'adminsoki', '', '', 'soki@gmail.com', 0, 1, 'admin', NULL, '2024-12-20 13:10:52.126152'),
(9, 'pbkdf2_sha256$260000$ZnPOnOl60A47wG7wakcvMj$+YPey7Uw8AtuZYBbgyvSHDMNjHk7tNCMhZxynxyF7/U=', '2025-01-04 11:51:43.944851', 0, 'adminratu', '', '', 'ratu@gmail.com', 0, 1, 'admin', NULL, '2024-12-20 13:38:50.900545'),
(10, 'pbkdf2_sha256$260000$X3qlbsHrj8jRxbYSLgKGiR$wQvCzFS6zsgpziNTXAmhY9kb0So6I/ugS87iUfQM/To=', '2025-07-12 13:10:50.949789', 0, 'adminsarirejeki', '', '', 'sarirejeki@gmail.com', 0, 1, 'admin', NULL, '2024-12-20 13:44:37.543315');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_groups`
--

CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_user_permissions`
--

CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext COLLATE utf8mb4_general_ci,
  `object_repr` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `action_flag` smallint UNSIGNED NOT NULL,
  `change_message` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int NOT NULL,
  `app_label` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `model` varchar(100) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(4, 'auth', 'user'),
(5, 'contenttypes', 'contenttype'),
(16, 'inventory', 'employee'),
(7, 'inventory', 'item'),
(15, 'inventory', 'material'),
(8, 'inventory', 'outlet'),
(17, 'inventory', 'outletitem'),
(12, 'inventory', 'production'),
(9, 'inventory', 'purchase'),
(14, 'inventory', 'recipe'),
(10, 'inventory', 'sales'),
(13, 'inventory', 'stock'),
(11, 'inventory', 'transaction'),
(6, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL,
  `app` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2023-08-24 12:34:00.575247'),
(2, 'auth', '0001_initial', '2023-08-24 12:34:01.984574'),
(3, 'admin', '0001_initial', '2023-08-24 12:34:02.321640'),
(4, 'admin', '0002_logentry_remove_auto_add', '2023-08-24 12:34:02.334653'),
(5, 'admin', '0003_logentry_add_action_flag_choices', '2023-08-24 12:34:02.347656'),
(6, 'contenttypes', '0002_remove_content_type_name', '2023-08-24 12:34:02.549718'),
(7, 'auth', '0002_alter_permission_name_max_length', '2023-08-24 12:34:02.687749'),
(8, 'auth', '0003_alter_user_email_max_length', '2023-08-24 12:34:02.719756'),
(9, 'auth', '0004_alter_user_username_opts', '2023-08-24 12:34:02.732768'),
(10, 'auth', '0005_alter_user_last_login_null', '2023-08-24 12:34:02.838792'),
(11, 'auth', '0006_require_contenttypes_0002', '2023-08-24 12:34:02.845784'),
(12, 'auth', '0007_alter_validators_add_error_messages', '2023-08-24 12:34:02.858797'),
(13, 'auth', '0008_alter_user_username_max_length', '2023-08-24 12:34:02.888794'),
(14, 'auth', '0009_alter_user_last_name_max_length', '2023-08-24 12:34:02.917801'),
(15, 'auth', '0010_alter_group_name_max_length', '2023-08-24 12:34:02.951808'),
(16, 'auth', '0011_update_proxy_permissions', '2023-08-24 12:34:02.964811'),
(17, 'auth', '0012_alter_user_first_name_max_length', '2023-08-24 12:34:02.994827'),
(18, 'inventory', '0001_initial', '2023-08-24 12:34:03.437938'),
(19, 'sessions', '0001_initial', '2023-08-24 12:34:03.589963'),
(20, 'inventory', '0002_auto_20230824_2211', '2023-08-24 15:11:11.043978'),
(21, 'inventory', '0003_auto_20230825_1339', '2023-08-25 06:39:15.177803'),
(22, 'inventory', '0004_auto_20230825_1344', '2023-08-25 06:44:51.024978'),
(23, 'inventory', '0005_alter_outlet_id', '2023-08-25 12:24:20.166742'),
(24, 'inventory', '0006_alter_outlet_id', '2023-08-25 12:27:39.720596'),
(25, 'inventory', '0002_stock_production', '2023-08-29 16:25:57.893402'),
(26, 'inventory', '0003_auto_20230901_1948', '2023-09-01 12:48:32.312408'),
(27, 'inventory', '0004_material_recipe', '2023-10-20 12:42:44.641830'),
(28, 'inventory', '0002_customuser', '2024-12-20 12:34:34.841095'),
(29, 'inventory', '0003_auto_20241220_1934', '2024-12-20 12:34:34.972349'),
(30, 'inventory', '0004_auto_20241220_1936', '2024-12-20 12:36:35.881960'),
(31, 'inventory', '0005_rename_outlet_id_employee_outlet', '2024-12-20 12:37:11.121552'),
(32, 'inventory', '0006_employee_role', '2024-12-20 12:40:06.345650'),
(33, 'inventory', '0007_auto_20241220_2004', '2024-12-20 13:04:40.376928'),
(34, 'inventory', '0008_auto_20241220_2007', '2024-12-20 13:07:49.939964'),
(35, 'inventory', '0009_transaction_stock', '2024-12-21 10:58:55.755419'),
(36, 'inventory', '0010_alter_stock_user_id', '2024-12-21 11:02:05.285422'),
(37, 'inventory', '0011_outletitem', '2025-03-08 15:24:13.241114'),
(38, 'inventory', '0012_auto_20250712_1942', '2025-07-12 12:42:49.495253'),
(39, 'inventory', '0012_item_biaya_simpan', '2025-07-13 04:59:09.822759');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) COLLATE utf8mb4_general_ci NOT NULL,
  `session_data` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('03uvoq2itxrz2ssi4y48ma79dtjy5gul', '.eJxVjEEOwiAQRe_C2hDGYgGX7j0DmWEGqRpISrsy3l2bdKHb_977LxVxXUpcu8xxYnVWoA6_G2F6SN0A37Hemk6tLvNEelP0Tru-NpbnZXf_Dgr28q0HdkLgcBhD8nmQ4BmsnNwxgUlegvUBEI2lzCTgKJjAFsSNxGCyB_X-AOqdOAw:1tH27G:TDm2Mb7FUZRaVGvCMxI_9tsW_jT3dZXbQKWHwmLc6Bw', '2024-12-13 14:37:06.263570'),
('1kr5o29s7g0dv6nflhwjgjt6xitbwduj', '.eJxVjEEOwiAQRe_C2pAOoAMu3XsGMsyAVA1NSrsy3l2bdKHb_977LxVpXWpce57jKOqsQB1-t0T8yG0Dcqd2mzRPbZnHpDdF77Tr6yT5edndv4NKvX5rDEMhlAx-SCgFnLenYDNiKBaNB2Jkh16MUCEycCTPlDm4wgBik3p_AORzOGs:1teDkZ:bFX21f-hIxum9J7T5S3bG3nhNldKU2G38pRzZnQLa0Q', '2025-02-15 13:41:31.906800'),
('1pupdzoyowpq1zbocel5feh4jvnezmf0', '.eJxVjDsOwyAQBe9CHSE-WgMp0-cMaGHZ4CTCkrErK3ePkFwk7ZuZd4iI-1bj3ssaZxJXocXld0uYX6UNQE9sj0XmpW3rnORQ5Em7vC9U3rfT_Tuo2Ouo2U9Kc0BljLUKOJDzqBGSZe0SBCRtwJN13pAtYICz5-RDnhBsKOLzBdSmN7E:1sd8Gn:201OoeBgiA87kpnpFqgayETnkJnJzfVsG6qvlIR3_ak', '2024-08-25 13:06:01.085802'),
('2notpwyhgmlmv2se0pmy77ea2xkh5e9l', '.eJxVjEsOAiEQBe_C2hAalI9L956BNN0gowaSYWZlvLtOMgvdvqp6LxFxXWpcR57jxOIsvDj8bgnpkdsG-I7t1iX1tsxTkpsidzrktXN-Xnb376DiqN9a68LZgaKCxhtLBCoklzJaUAieDVMInAqDRbYIxqMLx5MN7AugNuL9AQB0OGA:1tRPJp:ERCauy7yUbE1dmAR2cvdLsfzl5FnZchWTx7pB7xcFog', '2025-01-11 05:24:57.138690'),
('2y92vy363iwj6ac84y77edmnen340133', '.eJxVjEsOAiEQBe_C2hAalI9L956BNN0gowaSYWZlvLtOMgvdvqp6LxFxXWpcR57jxOIsvDj8bgnpkdsG-I7t1iX1tsxTkpsidzrktXN-Xnb376DiqN9a68LZgaKCxhtLBCoklzJaUAieDVMInAqDRbYIxqMLx5MN7AugNuL9AQB0OGA:1tYQVb:rKbBU5qoU817Egu2FsHRwKNb-7QbSThnIHm7mZMZPxI', '2025-01-30 14:06:07.518231'),
('4jmaknq3j9xst1jmgyn7tgsxss4t8oyb', '.eJxVjMsOwiAUBf-FtSFcKhRcuu83kPugUjU0Ke3K-O_apAvdnpk5L5VwW0vaWl7SJOqiQJ1-N0J-5LoDuWO9zZrnui4T6V3RB216mCU_r4f7d1CwlW8doAeOxiGBMTaeMXTOZUGOI-IYPXgkMuAjhJzZs_SGqPNixUdr2Kr3B9oeN-4:1tOb17:4dlLyCUNEUzdxVH3ytLJYlvJa0I-rvTF8XON_Locf64', '2025-01-03 11:18:01.899647'),
('59g11f2pwrqud6bgc3xz7bjn8fxm8y8r', '.eJxVjEsOAiEQBe_C2hAalI9L956BNN0gowaSYWZlvLtOMgvdvqp6LxFxXWpcR57jxOIsvDj8bgnpkdsG-I7t1iX1tsxTkpsidzrktXN-Xnb376DiqN9a68LZgaKCxhtLBCoklzJaUAieDVMInAqDRbYIxqMLx5MN7AugNuL9AQB0OGA:1tqwTA:rTAdBoOecEylIU0Wl9EyCmbtCoVAmKSKN45KHN5p0sU', '2025-03-22 15:52:08.361898'),
('69r1qzv9pfr92ygcuahf4pnsnd2ismua', '.eJxVjEEOwiAQRe_C2pAOoAMu3XsGMsyAVA1NSrsy3l2bdKHb_977LxVpXWpce57jKOqsQB1-t0T8yG0Dcqd2mzRPbZnHpDdF77Tr6yT5edndv4NKvX5rDEMhlAx-SCgFnLenYDNiKBaNB2Jkh16MUCEycCTPlDm4wgBik3p_AORzOGs:1twBFU:RJrL3qCyG9ZvdCBPv0MukGqrWIU7Ul-5meFtf2nU_fc', '2025-04-06 02:39:40.773347'),
('6j02rfhacc9laudzino3xmmkg2plxq1v', '.eJxVjEEOwiAQRe_C2pAOoAMu3XsGMsyAVA1NSrsy3l2bdKHb_977LxVpXWpce57jKOqsQB1-t0T8yG0Dcqd2mzRPbZnHpDdF77Tr6yT5edndv4NKvX5rDEMhlAx-SCgFnLenYDNiKBaNB2Jkh16MUCEycCTPlDm4wgBik3p_AORzOGs:1tqxCx:Fmk-y0gSdumIHc0XrRaXs8Ku34r_65qwSyX4Y5aVH7Q', '2025-03-22 16:39:27.894420'),
('7exekv69pp9zmbsmgq1ceh4kvqlb7kq8', '.eJxVjEEOwiAQRe_C2pAOoAMu3XsGMsyAVA1NSrsy3l2bdKHb_977LxVpXWpce57jKOqsQB1-t0T8yG0Dcqd2mzRPbZnHpDdF77Tr6yT5edndv4NKvX5rDEMhlAx-SCgFnLenYDNiKBaNB2Jkh16MUCEycCTPlDm4wgBik3p_AORzOGs:1uQIE6:SrR3DZ8sC75xTVVZL2jTVwN0rbtYdB9qt5Ver8qTXs4', '2025-06-28 04:10:42.744614'),
('7sl8a679gakvaqbcef5xzh9zxhzc3369', '.eJxVjEsOAiEQBe_C2hAalI9L956BNN0gowaSYWZlvLtOMgvdvqp6LxFxXWpcR57jxOIsvDj8bgnpkdsG-I7t1iX1tsxTkpsidzrktXN-Xnb376DiqN9a68LZgaKCxhtLBCoklzJaUAieDVMInAqDRbYIxqMLx5MN7AugNuL9AQB0OGA:1tZ9Mk:sYZeqCH33vSmw8myNkg-6He1q3BhJOFXoATvQnNJMNY', '2025-02-01 13:59:58.178739'),
('8tyjpb222r2qon3e1crviwdg4nge1oow', '.eJxVjEEOwiAQRe_C2pAOoAMu3XsGMsyAVA1NSrsy3l2bdKHb_977LxVpXWpce57jKOqsQB1-t0T8yG0Dcqd2mzRPbZnHpDdF77Tr6yT5edndv4NKvX5rDEMhlAx-SCgFnLenYDNiKBaNB2Jkh16MUCEycCTPlDm4wgBik3p_AORzOGs:1uKTwH:maUqk8RMpPiFLmdVdsSODjWYpuk5i3SsTYDAv9B3Gjo', '2025-06-12 03:28:17.274308'),
('9fagyrhotlipwnbiv5rfsgi1jr9e1nlx', '.eJxVjMEOwiAQRP-FsyGwlAoevfsNZHfZStXQpLQn47_bJj1o5jbvzbxVwnUpaW0ypzGri7JGnX5LQn5K3Ul-YL1Pmqe6zCPpXdEHbfo2ZXldD_fvoGAr21qGAXoTOoIshJbOmP0WRCZrTGTwnXMAkQXIsQ_OBhOYIvbko0VRny8qizik:1tOdKN:udf4bB0vB8mNKj4RceE4GfZnUp1KX1xd2z0y-D2ZyDw', '2025-01-03 13:46:03.346574'),
('a83c33y0e45yhwg0h3fhoemstusn9iwn', '.eJxVjEEOwiAQRe_C2pAOoAMu3XsGMsyAVA1NSrsy3l2bdKHb_977LxVpXWpce57jKOqsQB1-t0T8yG0Dcqd2mzRPbZnHpDdF77Tr6yT5edndv4NKvX5rDEMhlAx-SCgFnLenYDNiKBaNB2Jkh16MUCEycCTPlDm4wgBik3p_AORzOGs:1uYNv7:w4mT4g3GpNYCzjx8q2TABDLC9Lpv-I3flrZgdw9vD4k', '2025-07-20 11:52:33.306022'),
('d1jcoqpral2iz24headlveamwwgp9fbz', '.eJxVjEEOwiAQRe_C2pAOoAMu3XsGMsyAVA1NSrsy3l2bdKHb_977LxVpXWpce57jKOqsQB1-t0T8yG0Dcqd2mzRPbZnHpDdF77Tr6yT5edndv4NKvX5rDEMhlAx-SCgFnLenYDNiKBaNB2Jkh16MUCEycCTPlDm4wgBik3p_AORzOGs:1tZ90P:GUcR8A9n37JgoxrFn-MEkf0N5gFvRUWQ6S93Lp50IIA', '2025-02-01 13:36:53.605956'),
('g3qopr71s1dmx2bb1smfrn49ukuvsv91', '.eJxVjEEOwiAQRe_C2hDGYgGX7j0DmWEGqRpISrsy3l2bdKHb_977LxVxXUpcu8xxYnVWoA6_G2F6SN0A37Hemk6tLvNEelP0Tru-NpbnZXf_Dgr28q0HdkLgcBhD8nmQ4BmsnNwxgUlegvUBEI2lzCTgKJjAFsSNxGCyB_X-AOqdOAw:1tErsy:-gxxrfrv4MJBgvGbkniQknZ1EcpGiFHi5OZT_aMOqFo', '2024-12-07 15:17:24.563376'),
('ha72pr7s0sql54rthb82wab4rbfhugz4', '.eJxVjEEOwiAQRe_C2pAOoAMu3XsGMsyAVA1NSrsy3l2bdKHb_977LxVpXWpce57jKOqsQB1-t0T8yG0Dcqd2mzRPbZnHpDdF77Tr6yT5edndv4NKvX5rDEMhlAx-SCgFnLenYDNiKBaNB2Jkh16MUCEycCTPlDm4wgBik3p_AORzOGs:1uAARi:todBumYVToZGl486gRisk2qWYDUYbWqpZVfZTonBs6c', '2025-05-14 16:38:06.535664'),
('i6aqw8fbj48pwt04opgfim0rc2er0vf5', '.eJxVjEEOwiAQRe_C2pAOoAMu3XsGMsyAVA1NSrsy3l2bdKHb_977LxVpXWpce57jKOqsQB1-t0T8yG0Dcqd2mzRPbZnHpDdF77Tr6yT5edndv4NKvX5rDEMhlAx-SCgFnLenYDNiKBaNB2Jkh16MUCEycCTPlDm4wgBik3p_AORzOGs:1tU2VP:ZxACoPoydiC3OWXmoVoj1VApRIK9tRlD-gIBZj4vlIs', '2025-01-18 11:39:47.965603'),
('ke2pv7hy9qyb7zsj0ozhrgbs3r78daot', '.eJxVjEEOwiAQRe_C2pAOoAMu3XsGMsyAVA1NSrsy3l2bdKHb_977LxVpXWpce57jKOqsQB1-t0T8yG0Dcqd2mzRPbZnHpDdF77Tr6yT5edndv4NKvX5rDEMhlAx-SCgFnLenYDNiKBaNB2Jkh16MUCEycCTPlDm4wgBik3p_AORzOGs:1uadMM:p7DK_AWFjGciYcCz62tBTg0wslvWS-XMXem82jjwsag', '2025-07-26 16:45:58.612676'),
('kqhj9z51in6m8ed5pcue8qtpexe19hm4', '.eJxVjEEOwiAQRe_C2pAOoAMu3XsGMsyAVA1NSrsy3l2bdKHb_977LxVpXWpce57jKOqsQB1-t0T8yG0Dcqd2mzRPbZnHpDdF77Tr6yT5edndv4NKvX5rDEMhlAx-SCgFnLenYDNiKBaNB2Jkh16MUCEycCTPlDm4wgBik3p_AORzOGs:1tne3X:lHBJ2pbS4Hhb5FbuR9QyJHwA0IpY1LooQoGvl4yOo20', '2025-03-13 13:36:03.132469'),
('ksf1d9bt2br2qu4iszdmr361umncnauq', 'eyJvdXRsZXRfaWQiOiJhbGwiLCJvdXRsZXRfbmFtZSI6IlNlbXVhIENhYmFuZyJ9:1qbMRp:MyehZ72mACvMNUK0oJZCQ1cRBRsRxqYNgFYzA4NZhyU', '2023-09-13 14:45:33.940274'),
('q5ti7tyornb6kmlvue38d4dterwkcrlk', '.eJxVjEEOwiAQRe_C2hDGYgGX7j0DmWEGqRpISrsy3l2bdKHb_977LxVxXUpcu8xxYnVWoA6_G2F6SN0A37Hemk6tLvNEelP0Tru-NpbnZXf_Dgr28q0HdkLgcBhD8nmQ4BmsnNwxgUlegvUBEI2lzCTgKJjAFsSNxGCyB_X-AOqdOAw:1tJBLu:twQ8oeLZ79vc8KnZCCzm48-cTZxmQys3a8Sov8fLG6A', '2024-12-19 12:53:06.615036'),
('rcuv8vdz3l2rq56e4tq81zqo0izd7aon', '.eJxVjMEOwiAQRP-FsyGwlAoevfsNZHfZStXQpLQn47_bJj1o5jbvzbxVwnUpaW0ypzGri7JGnX5LQn5K3Ul-YL1Pmqe6zCPpXdEHbfo2ZXldD_fvoGAr21qGAXoTOoIshJbOmP0WRCZrTGTwnXMAkQXIsQ_OBhOYIvbko0VRny8qizik:1uaa0A:yLIOiiw1xXk3evXdQSDt2zXp4XPK6HQ31qcP0ikpPsE', '2025-07-26 13:10:50.952787'),
('t33wuocdwc084fc40q1mz6qy9klugc3w', '.eJxVjEEOwiAQRe_C2hDGYgGX7j0DmWEGqRpISrsy3l2bdKHb_977LxVxXUpcu8xxYnVWoA6_G2F6SN0A37Hemk6tLvNEelP0Tru-NpbnZXf_Dgr28q0HdkLgcBhD8nmQ4BmsnNwxgUlegvUBEI2lzCTgKJjAFsSNxGCyB_X-AOqdOAw:1tH2kj:F_E61T9aaF19n_7MnrSajfif8WnK0hAqK0t_0G5H9X8', '2024-12-13 15:17:53.195755'),
('u1w4nkg5mjzqxzif3bbt858syhza36zd', '.eJxVjEEOwiAQRe_C2pAOoAMu3XsGMsyAVA1NSrsy3l2bdKHb_977LxVpXWpce57jKOqsQB1-t0T8yG0Dcqd2mzRPbZnHpDdF77Tr6yT5edndv4NKvX5rDEMhlAx-SCgFnLenYDNiKBaNB2Jkh16MUCEycCTPlDm4wgBik3p_AORzOGs:1ufkkV:vIsschf88wvsLExQtfInhFSeB5DMnZg1BpbMni9oUDM', '2025-08-09 19:40:03.871889'),
('vxw9hwwh5jhfax8zxfa8h6gq0y87oyzu', '.eJxVjEsOAiEQBe_C2hAalI9L956BNN0gowaSYWZlvLtOMgvdvqp6LxFxXWpcR57jxOIsvDj8bgnpkdsG-I7t1iX1tsxTkpsidzrktXN-Xnb376DiqN9a68LZgaKCxhtLBCoklzJaUAieDVMInAqDRbYIxqMLx5MN7AugNuL9AQB0OGA:1ufkuc:ZA_uRhojT6XjzaY-c0IzPmmdspt2Z7iy8bL1hRJz1GQ', '2025-08-09 19:50:30.838661'),
('z7btooo443em5w84k8nu0ojif6m1wv8x', '.eJxVjEsOAiEQBe_C2hAalI9L956BNN0gowaSYWZlvLtOMgvdvqp6LxFxXWpcR57jxOIsvDj8bgnpkdsG-I7t1iX1tsxTkpsidzrktXN-Xnb376DiqN9a68LZgaKCxhtLBCoklzJaUAieDVMInAqDRbYIxqMLx5MN7AugNuL9AQB0OGA:1uaZTw:yhtcMkbprm4yQzpc9dNCiKWN6XeERdA_ELIa04Uz744', '2025-07-26 12:37:32.506279'),
('z7te0cv42688ivhmpom0udcc4s0tcgl4', '.eJxVjDsOwyAQRO9CHSHzsWFTpvcZ0LJAcBKBZOwqyt2DJRdJOfPezJs53Lfs9hZXtwR2ZcAuv51HesZygPDAcq-catnWxfND4SdtfK4hvm6n-3eQseW-1nYEiAiSQGEIMCTt1RSlSsmAESRND0aEwY9RS_TCdnGiBEBorPXs8wXlLDf9:1tU2gx:2_4vhbzdIfQdkpLSMjAfa4HQTChZX_XF0G70o8QON9g', '2025-01-18 11:51:43.947850');

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `id` bigint NOT NULL,
  `user_id` int NOT NULL,
  `role` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `outlet_id` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`id`, `user_id`, `role`, `outlet_id`) VALUES
(5, 8, 'admin', 5),
(7, 1, 'superadmin', 3),
(8, 9, 'admin', 6),
(9, 10, 'admin', 7);

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `id` bigint NOT NULL,
  `user_id` int NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `image` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `price` int NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `biaya_pesan` int DEFAULT NULL,
  `lead_time` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`id`, `user_id`, `code`, `name`, `image`, `description`, `price`, `type`, `created_at`, `updated_at`, `biaya_pesan`, `lead_time`) VALUES
(1, 1, 'YABD-001', 'Yasmin BYUR Dress', '', 'Yasmin BYUR Dress Normal Size', 57000, 'jadi', '2024-12-05 12:56:09.071873', '2025-06-27 17:29:43.939980', 3000, 3),
(2, 1, 'YABD-002', 'Yasmin BYUR Dress Jumbo', '', 'Yasmin BYUR Dress Jumbo Size', 60500, 'jadi', '2024-12-05 13:51:03.803905', '2025-06-27 17:29:47.539307', 3000, 2),
(3, 1, 'YUBD-001', 'Yulia BYUR Dress', '', 'Yulia BYUR Dress Normal Size', 55000, 'jadi', '2024-12-05 14:05:18.908919', '2025-06-27 17:29:51.316164', 3000, 2),
(4, 1, 'YUBD-001', 'Yulia BYUR Dress Jumbo', '', 'Yulia BYUR Dress Jumbo Size', 59500, 'jadi', '2024-12-12 14:10:59.318758', '2025-06-27 17:29:56.402333', 3000, 2),
(5, 1, 'LSB-001', 'Long Suit BYUR', '', 'Long Suit BYUR Normal Size', 62500, 'jadi', '2024-12-12 14:28:47.673086', '2025-06-27 17:29:59.242947', 3000, 3);

-- --------------------------------------------------------

--
-- Table structure for table `materials`
--

CREATE TABLE `materials` (
  `id` bigint NOT NULL,
  `user_id` int NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `image` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `price` int NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `unit` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `biaya_pesan` int DEFAULT NULL,
  `lead_time` int DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `materials`
--

INSERT INTO `materials` (`id`, `user_id`, `code`, `name`, `image`, `description`, `price`, `type`, `unit`, `biaya_pesan`, `lead_time`, `created_at`, `updated_at`) VALUES
(1, 1, 'C-01', 'Color A', 'img/items/pewarna_batik.jpg', 'Color A', 10000, NULL, 'kg', 1000, 2, '2023-10-20 12:59:30.929828', '2025-02-01 11:33:41.383600'),
(2, 1, 'C-02', 'Color B', '', 'Color B', 10000, NULL, 'kg', 1000, 2, '2023-10-20 13:00:36.450210', '2025-02-01 11:33:37.185871'),
(3, 1, 'C-03', 'Color C', '', 'Color C', 12000, NULL, 'kg', 1500, 3, '2023-10-20 13:00:51.665929', '2025-02-01 11:33:50.622420'),
(4, 1, 'PDF-01', 'Plain Dobby Fabric', 'img/items/kain_dobby_polos.jpg', 'Plain Dobby Fabric', 25000, NULL, 'meter', 2500, 3, '2023-10-20 13:16:15.801941', '2025-02-01 11:34:48.050387'),
(5, 1, 'PCF-01', 'Plain Cotton Fabric', '', 'Plain Cotton Fabric', 20000, NULL, 'meter', 2500, 3, '2023-10-20 13:17:34.216826', '2025-02-01 11:35:14.646460');

-- --------------------------------------------------------

--
-- Table structure for table `outlets`
--

CREATE TABLE `outlets` (
  `id` bigint NOT NULL,
  `user_id` int NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `address` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `outlets`
--

INSERT INTO `outlets` (`id`, `user_id`, `name`, `address`, `created_at`, `updated_at`) VALUES
(3, 1, 'Central Warehouse', 'Sragen', '2023-08-29 16:55:45.201393', '2023-08-29 16:55:45.201393'),
(5, 1, 'Soki Store', 'Pekalongan', '2024-12-05 13:10:50.086021', '2024-12-05 13:10:50.086021'),
(6, 1, 'Ratu Store', 'Pekalongan', '2024-12-05 13:32:49.618204', '2024-12-05 13:32:49.618204'),
(7, 1, 'Sari Rejeki Store', 'Pekalongan', '2024-12-05 13:40:49.063313', '2024-12-05 13:40:49.063313');

-- --------------------------------------------------------

--
-- Table structure for table `outlet_items`
--

CREATE TABLE `outlet_items` (
  `id` bigint NOT NULL,
  `price` int NOT NULL,
  `lead_time` int DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `item_id` bigint NOT NULL,
  `outlet_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `outlet_items`
--

INSERT INTO `outlet_items` (`id`, `price`, `lead_time`, `created_at`, `updated_at`, `item_id`, `outlet_id`) VALUES
(1, 57000, 2, '2025-03-08 22:24:45.000000', '2025-03-08 22:24:45.000000', 1, 5),
(2, 57000, 3, '2025-03-08 22:24:45.000000', '2025-03-08 22:24:45.000000', 1, 6),
(3, 57000, 2, '2025-03-08 22:24:45.000000', '2025-03-08 22:24:45.000000', 1, 7),
(4, 60500, 2, '2025-03-08 22:24:45.000000', '2025-03-08 22:24:45.000000', 2, 5),
(5, 60500, 3, '2025-03-08 22:24:45.000000', '2025-03-08 22:24:45.000000', 2, 6),
(6, 60500, 2, '2025-03-08 22:24:45.000000', '2025-03-08 22:24:45.000000', 2, 7),
(7, 55000, 2, '2025-03-08 22:24:45.000000', '2025-03-08 22:24:45.000000', 3, 5),
(8, 55000, 3, '2025-03-08 22:24:45.000000', '2025-03-08 22:24:45.000000', 3, 6),
(9, 55000, 2, '2025-03-08 22:24:45.000000', '2025-03-08 22:24:45.000000', 3, 7),
(10, 59500, 2, '2025-03-08 22:24:45.000000', '2025-03-08 22:24:45.000000', 4, 5),
(11, 59500, 3, '2025-03-08 22:24:45.000000', '2025-03-08 22:24:45.000000', 4, 6),
(12, 59500, 2, '2025-03-08 22:24:45.000000', '2025-03-08 22:24:45.000000', 4, 7),
(13, 62500, 2, '2025-03-08 22:24:45.000000', '2025-03-08 22:24:45.000000', 5, 5),
(14, 62500, 3, '2025-03-08 22:24:45.000000', '2025-03-08 22:24:45.000000', 5, 6),
(15, 62500, 2, '2025-03-08 22:24:45.000000', '2025-03-08 22:24:45.000000', 5, 7),
(21, 57000, 1, '2025-03-08 22:24:45.000000', '2025-03-08 22:24:45.000000', 1, 3),
(22, 60500, 2, '2025-03-08 22:24:45.000000', '2025-03-08 22:24:45.000000', 2, 3),
(23, 55000, 1, '2025-03-08 22:24:45.000000', '2025-03-08 22:24:45.000000', 3, 3),
(24, 59500, 2, '2025-03-08 22:24:45.000000', '2025-03-08 22:24:45.000000', 4, 3),
(25, 62500, 1, '2025-03-08 22:24:45.000000', '2025-03-08 22:24:45.000000', 5, 3);

-- --------------------------------------------------------

--
-- Table structure for table `productions`
--

CREATE TABLE `productions` (
  `id` bigint NOT NULL,
  `user_id` int NOT NULL,
  `amount` int NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `item_id` bigint NOT NULL,
  `outlet_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `productions`
--

INSERT INTO `productions` (`id`, `user_id`, `amount`, `created_at`, `updated_at`, `item_id`, `outlet_id`) VALUES
(1, 1, 100, '2025-01-18 13:43:54.989124', '2025-01-18 13:43:54.989124', 1, 3);

-- --------------------------------------------------------

--
-- Table structure for table `purchases`
--

CREATE TABLE `purchases` (
  `id` bigint NOT NULL,
  `user_id` int NOT NULL,
  `price` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `amount` int NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `item_id` bigint NOT NULL,
  `outlet_id` bigint NOT NULL,
  `unit` varchar(255) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `purchases`
--

INSERT INTO `purchases` (`id`, `user_id`, `price`, `amount`, `created_at`, `updated_at`, `item_id`, `outlet_id`, `unit`) VALUES
(1, 1, '57000', 20000, '2024-06-01 00:00:00.000000', '2024-07-08 00:00:00.000000', 1, 3, 'PCS'),
(2, 1, '57000', 114, '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 1, 5, 'PCS'),
(3, 1, '57000', 107, '2024-06-01 00:00:00.000000', '2024-06-01 00:00:00.000000', 1, 5, 'PCS'),
(4, 1, '57000', 117, '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 1, 5, 'PCS'),
(5, 1, '57000', 310, '2024-06-05 00:00:00.000000', '2024-06-05 00:00:00.000000', 1, 5, 'PCS'),
(6, 1, '57000', 248, '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 1, 5, 'PCS'),
(7, 1, '57000', 240, '2024-06-07 00:00:00.000000', '2024-06-07 00:00:00.000000', 1, 5, 'PCS'),
(8, 1, '57000', 262, '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 1, 5, 'PCS'),
(9, 1, '57000', 341, '2024-07-25 00:00:00.000000', '2024-07-25 00:00:00.000000', 1, 5, 'PCS'),
(10, 1, '57000', 167, '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 1, 5, 'PCS'),
(11, 1, '57000', 263, '2024-07-26 00:00:00.000000', '2024-07-26 00:00:00.000000', 1, 5, 'PCS'),
(12, 1, '57000', 303, '2024-06-17 00:00:00.000000', '2024-06-17 00:00:00.000000', 1, 5, 'PCS'),
(13, 1, '57000', 234, '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 1, 5, 'PCS'),
(14, 1, '57000', 283, '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 1, 5, 'PCS'),
(15, 1, '57000', 263, '2024-07-25 00:00:00.000000', '2024-07-25 00:00:00.000000', 1, 5, 'PCS'),
(16, 1, '57000', 253, '2024-07-21 00:00:00.000000', '2024-07-21 00:00:00.000000', 1, 5, 'PCS'),
(17, 1, '57000', 115, '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 1, 5, 'PCS'),
(18, 1, '57000', 315, '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 1, 5, 'PCS'),
(19, 1, '57000', 485, '2024-07-18 00:00:00.000000', '2024-07-18 00:00:00.000000', 1, 5, 'PCS'),
(20, 1, '57000', 379, '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 1, 5, 'PCS'),
(22, 1, '57000', 416, '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 1, 5, 'PCS'),
(23, 1, '57000', 206, '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 1, 5, 'PCS'),
(24, 1, '57000', 422, '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 1, 5, 'PCS'),
(25, 1, '57000', 53, '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 1, 5, 'PCS'),
(26, 1, '60500', 30000, '2024-06-01 00:00:00.000000', '2024-07-10 00:00:00.000000', 2, 3, 'PCS'),
(27, 1, '60500', 108, '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 2, 5, 'PCS'),
(28, 1, '60500', 161, '2024-07-03 00:00:00.000000', '2024-07-03 00:00:00.000000', 2, 5, 'PCS'),
(29, 1, '60500', 227, '2024-06-17 00:00:00.000000', '2024-06-17 00:00:00.000000', 2, 5, 'PCS'),
(30, 1, '60500', 243, '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 2, 5, 'PCS'),
(31, 1, '60500', 135, '2024-07-26 00:00:00.000000', '2024-07-26 00:00:00.000000', 2, 5, 'PCS'),
(32, 1, '60500', 442, '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 2, 5, 'PCS'),
(33, 1, '60500', 184, '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 2, 5, 'PCS'),
(34, 1, '60500', 159, '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 2, 5, 'PCS'),
(35, 1, '60500', 259, '2024-07-18 00:00:00.000000', '2024-07-18 00:00:00.000000', 2, 5, 'PCS'),
(36, 1, '60500', 464, '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 2, 5, 'PCS'),
(37, 1, '60500', 185, '2024-07-07 00:00:00.000000', '2024-07-07 00:00:00.000000', 2, 5, 'PCS'),
(38, 1, '60500', 490, '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 2, 5, 'PCS'),
(39, 1, '60500', 421, '2024-06-20 00:00:00.000000', '2024-06-20 00:00:00.000000', 2, 5, 'PCS'),
(40, 1, '60500', 252, '2024-06-30 00:00:00.000000', '2024-06-30 00:00:00.000000', 2, 5, 'PCS'),
(41, 1, '60500', 193, '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 2, 5, 'PCS'),
(42, 1, '60500', 375, '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 2, 5, 'PCS'),
(43, 1, '60500', 164, '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 2, 5, 'PCS'),
(44, 1, '55000', 15000, '2024-06-01 00:00:00.000000', '2024-07-20 00:00:00.000000', 3, 3, 'PCS'),
(45, 1, '55000', 151, '2024-07-21 00:00:00.000000', '2024-07-21 00:00:00.000000', 3, 5, 'PCS'),
(46, 1, '55000', 225, '2024-07-07 00:00:00.000000', '2024-07-07 00:00:00.000000', 3, 5, 'PCS'),
(47, 1, '55000', 314, '2024-07-07 00:00:00.000000', '2024-07-07 00:00:00.000000', 3, 5, 'PCS'),
(48, 1, '55000', 271, '2024-07-03 00:00:00.000000', '2024-07-03 00:00:00.000000', 3, 5, 'PCS'),
(49, 1, '55000', 308, '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 3, 5, 'PCS'),
(50, 1, '55000', 370, '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 3, 5, 'PCS'),
(51, 1, '55000', 123, '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 3, 5, 'PCS'),
(52, 1, '55000', 168, '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 3, 5, 'PCS'),
(53, 1, '55000', 231, '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 3, 5, 'PCS'),
(54, 1, '55000', 491, '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 3, 5, 'PCS'),
(55, 1, '55000', 201, '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 3, 5, 'PCS'),
(56, 1, '55000', 100, '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 3, 5, 'PCS'),
(57, 1, '55000', 131, '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 3, 5, 'PCS'),
(58, 1, '55000', 393, '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 3, 5, 'PCS'),
(59, 1, '55000', 220, '2024-07-14 00:00:00.000000', '2024-07-14 00:00:00.000000', 3, 5, 'PCS'),
(60, 1, '55000', 278, '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 3, 5, 'PCS'),
(61, 1, '55000', 479, '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 3, 5, 'PCS'),
(62, 1, '55000', 242, '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 3, 5, 'PCS'),
(64, 1, '55000', 397, '2024-07-30 00:00:00.000000', '2024-07-30 00:00:00.000000', 3, 5, 'PCS'),
(65, 1, '55000', 275, '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 3, 5, 'PCS'),
(66, 1, '55000', 264, '2024-07-18 00:00:00.000000', '2024-07-18 00:00:00.000000', 3, 5, 'PCS'),
(67, 1, '55000', 363, '2024-06-19 00:00:00.000000', '2024-06-19 00:00:00.000000', 3, 5, 'PCS'),
(68, 1, '55000', 146, '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 3, 5, 'PCS'),
(69, 1, '55000', 382, '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 3, 5, 'PCS'),
(70, 1, '55000', 388, '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 3, 5, 'PCS'),
(71, 1, '59500', 10000, '2024-06-01 00:00:00.000000', '2024-07-08 00:00:00.000000', 4, 3, 'PCS'),
(72, 1, '59500', 216, '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 4, 5, 'PCS'),
(73, 1, '59500', 183, '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 4, 5, 'PCS'),
(74, 1, '59500', 142, '2024-06-13 00:00:00.000000', '2024-06-13 00:00:00.000000', 4, 5, 'PCS'),
(75, 1, '59500', 454, '2024-06-23 00:00:00.000000', '2024-06-23 00:00:00.000000', 4, 5, 'PCS'),
(76, 1, '59500', 387, '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 4, 5, 'PCS'),
(77, 1, '59500', 472, '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 4, 5, 'PCS'),
(78, 1, '59500', 239, '2024-06-30 00:00:00.000000', '2024-06-30 00:00:00.000000', 4, 5, 'PCS'),
(79, 1, '59500', 242, '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 4, 5, 'PCS'),
(80, 1, '59500', 350, '2024-06-01 00:00:00.000000', '2024-06-01 00:00:00.000000', 4, 5, 'PCS'),
(81, 1, '59500', 283, '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 4, 5, 'PCS'),
(82, 1, '59500', 179, '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 4, 5, 'PCS'),
(83, 1, '59500', 234, '2024-07-30 00:00:00.000000', '2024-07-30 00:00:00.000000', 4, 5, 'PCS'),
(84, 1, '59500', 200, '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 4, 5, 'PCS'),
(85, 1, '59500', 264, '2024-06-13 00:00:00.000000', '2024-06-13 00:00:00.000000', 4, 5, 'PCS'),
(86, 1, '59500', 215, '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 4, 5, 'PCS'),
(87, 1, '59500', 265, '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 4, 5, 'PCS'),
(88, 1, '59500', 395, '2024-07-31 00:00:00.000000', '2024-07-31 00:00:00.000000', 4, 5, 'PCS'),
(89, 1, '62500', 15000, '2024-06-01 00:00:00.000000', '2024-06-09 00:00:00.000000', 5, 3, 'PCS'),
(90, 1, '62500', 349, '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 5, 5, 'PCS'),
(91, 1, '62500', 104, '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 5, 5, 'PCS'),
(92, 1, '62500', 211, '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 5, 5, 'PCS'),
(93, 1, '62500', 409, '2024-06-20 00:00:00.000000', '2024-06-20 00:00:00.000000', 5, 5, 'PCS'),
(94, 1, '62500', 349, '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 5, 5, 'PCS'),
(95, 1, '62500', 179, '2024-06-17 00:00:00.000000', '2024-06-17 00:00:00.000000', 5, 5, 'PCS'),
(96, 1, '62500', 132, '2024-06-12 00:00:00.000000', '2024-06-12 00:00:00.000000', 5, 5, 'PCS'),
(97, 1, '62500', 338, '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 5, 5, 'PCS'),
(98, 1, '62500', 104, '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 5, 5, 'PCS'),
(99, 1, '57000', 289, '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 1, 6, 'PCS'),
(100, 1, '57000', 182, '2024-07-06 00:00:00.000000', '2024-07-06 00:00:00.000000', 1, 6, 'PCS'),
(101, 1, '57000', 108, '2024-06-13 00:00:00.000000', '2024-06-13 00:00:00.000000', 1, 6, 'PCS'),
(102, 1, '57000', 226, '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 1, 6, 'PCS'),
(103, 1, '57000', 424, '2024-06-09 00:00:00.000000', '2024-06-09 00:00:00.000000', 1, 6, 'PCS'),
(104, 1, '57000', 302, '2024-07-14 00:00:00.000000', '2024-07-14 00:00:00.000000', 1, 6, 'PCS'),
(105, 1, '57000', 137, '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 1, 6, 'PCS'),
(106, 1, '57000', 162, '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 1, 6, 'PCS'),
(107, 1, '57000', 399, '2024-06-06 00:00:00.000000', '2024-06-06 00:00:00.000000', 1, 6, 'PCS'),
(108, 1, '57000', 436, '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 1, 6, 'PCS'),
(109, 1, '57000', 152, '2024-07-30 00:00:00.000000', '2024-07-30 00:00:00.000000', 1, 6, 'PCS'),
(110, 1, '57000', 431, '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 1, 6, 'PCS'),
(111, 1, '57000', 260, '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 1, 6, 'PCS'),
(112, 1, '57000', 164, '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 1, 6, 'PCS'),
(113, 1, '57000', 185, '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 1, 6, 'PCS'),
(115, 1, '57000', 473, '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 1, 6, 'PCS'),
(116, 1, '57000', 260, '2024-06-19 00:00:00.000000', '2024-06-19 00:00:00.000000', 1, 6, 'PCS'),
(117, 1, '57000', 263, '2024-06-01 00:00:00.000000', '2024-06-01 00:00:00.000000', 1, 6, 'PCS'),
(118, 1, '57000', 189, '2024-07-16 00:00:00.000000', '2024-07-16 00:00:00.000000', 1, 6, 'PCS'),
(119, 1, '57000', 344, '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 1, 6, 'PCS'),
(120, 1, '57000', 429, '2024-06-07 00:00:00.000000', '2024-06-07 00:00:00.000000', 1, 6, 'PCS'),
(121, 1, '57000', 141, '2024-07-03 00:00:00.000000', '2024-07-03 00:00:00.000000', 1, 6, 'PCS'),
(122, 1, '57000', 240, '2024-06-20 00:00:00.000000', '2024-06-20 00:00:00.000000', 1, 6, 'PCS'),
(123, 1, '57000', 146, '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 1, 6, 'PCS'),
(124, 1, '57000', 421, '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 1, 6, 'PCS'),
(125, 1, '57000', 182, '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 1, 6, 'PCS'),
(126, 1, '57000', 115, '2024-06-06 00:00:00.000000', '2024-06-06 00:00:00.000000', 1, 6, 'PCS'),
(127, 1, '57000', 349, '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 1, 6, 'PCS'),
(128, 1, '57000', 246, '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 1, 6, 'PCS'),
(129, 1, '57000', 488, '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 1, 6, 'PCS'),
(130, 1, '57000', 483, '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 1, 6, 'PCS'),
(131, 1, '57000', 274, '2024-07-19 00:00:00.000000', '2024-07-19 00:00:00.000000', 1, 6, 'PCS'),
(133, 1, '57000', 242, '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 1, 6, 'PCS'),
(134, 1, '57000', 268, '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 1, 6, 'PCS'),
(135, 1, '57000', 55, '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 1, 6, 'PCS'),
(136, 1, '60500', 371, '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 2, 6, 'PCS'),
(138, 1, '60500', 478, '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 2, 6, 'PCS'),
(139, 1, '60500', 175, '2024-06-19 00:00:00.000000', '2024-06-19 00:00:00.000000', 2, 6, 'PCS'),
(140, 1, '60500', 218, '2024-07-07 00:00:00.000000', '2024-07-07 00:00:00.000000', 2, 6, 'PCS'),
(141, 1, '60500', 435, '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 2, 6, 'PCS'),
(142, 1, '60500', 358, '2024-07-12 00:00:00.000000', '2024-07-12 00:00:00.000000', 2, 6, 'PCS'),
(143, 1, '60500', 119, '2024-06-19 00:00:00.000000', '2024-06-19 00:00:00.000000', 2, 6, 'PCS'),
(144, 1, '60500', 242, '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 2, 6, 'PCS'),
(145, 1, '60500', 378, '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 2, 6, 'PCS'),
(146, 1, '60500', 354, '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 2, 6, 'PCS'),
(147, 1, '60500', 190, '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 2, 6, 'PCS'),
(148, 1, '60500', 439, '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 2, 6, 'PCS'),
(149, 1, '60500', 394, '2024-06-13 00:00:00.000000', '2024-06-13 00:00:00.000000', 2, 6, 'PCS'),
(150, 1, '60500', 308, '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 2, 6, 'PCS'),
(151, 1, '60500', 144, '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 2, 6, 'PCS'),
(152, 1, '60500', 351, '2024-07-27 00:00:00.000000', '2024-07-27 00:00:00.000000', 2, 6, 'PCS'),
(153, 1, '60500', 138, '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 2, 6, 'PCS'),
(154, 1, '60500', 185, '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 2, 6, 'PCS'),
(155, 1, '60500', 138, '2024-07-08 00:00:00.000000', '2024-07-08 00:00:00.000000', 2, 6, 'PCS'),
(157, 1, '60500', 253, '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 2, 6, 'PCS'),
(158, 1, '60500', 392, '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 2, 6, 'PCS'),
(159, 1, '60500', 399, '2024-06-06 00:00:00.000000', '2024-06-06 00:00:00.000000', 2, 6, 'PCS'),
(160, 1, '60500', 450, '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 2, 6, 'PCS'),
(161, 1, '60500', 119, '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 2, 6, 'PCS'),
(162, 1, '60500', 226, '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 2, 6, 'PCS'),
(163, 1, '60500', 203, '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 2, 6, 'PCS'),
(164, 1, '60500', 214, '2024-07-25 00:00:00.000000', '2024-07-25 00:00:00.000000', 2, 6, 'PCS'),
(165, 1, '60500', 473, '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 2, 6, 'PCS'),
(166, 1, '60500', 37, '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 2, 6, 'PCS'),
(167, 1, '55000', 122, '2024-07-23 00:00:00.000000', '2024-07-23 00:00:00.000000', 3, 6, 'PCS'),
(168, 1, '55000', 160, '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 3, 6, 'PCS'),
(169, 1, '55000', 383, '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 3, 6, 'PCS'),
(170, 1, '55000', 287, '2024-06-09 00:00:00.000000', '2024-06-09 00:00:00.000000', 3, 6, 'PCS'),
(171, 1, '55000', 476, '2024-07-19 00:00:00.000000', '2024-07-19 00:00:00.000000', 3, 6, 'PCS'),
(172, 1, '55000', 258, '2024-07-31 00:00:00.000000', '2024-07-31 00:00:00.000000', 3, 6, 'PCS'),
(173, 1, '55000', 299, '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 3, 6, 'PCS'),
(174, 1, '59500', 142, '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 4, 6, 'PCS'),
(176, 1, '59500', 416, '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 4, 6, 'PCS'),
(177, 1, '59500', 355, '2024-06-09 00:00:00.000000', '2024-06-09 00:00:00.000000', 4, 6, 'PCS'),
(178, 1, '59500', 436, '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 4, 6, 'PCS'),
(179, 1, '59500', 482, '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 4, 6, 'PCS'),
(180, 1, '59500', 401, '2024-06-01 00:00:00.000000', '2024-06-01 00:00:00.000000', 4, 6, 'PCS'),
(181, 1, '59500', 472, '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 4, 6, 'PCS'),
(182, 1, '59500', 111, '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 4, 6, 'PCS'),
(183, 1, '59500', 202, '2024-06-17 00:00:00.000000', '2024-06-17 00:00:00.000000', 4, 6, 'PCS'),
(184, 1, '59500', 141, '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 4, 6, 'PCS'),
(185, 1, '59500', 71, '2024-07-16 00:00:00.000000', '2024-07-16 00:00:00.000000', 4, 6, 'PCS'),
(186, 1, '62500', 286, '2024-07-16 00:00:00.000000', '2024-07-16 00:00:00.000000', 5, 6, 'PCS'),
(187, 1, '62500', 452, '2024-07-06 00:00:00.000000', '2024-07-06 00:00:00.000000', 5, 6, 'PCS'),
(188, 1, '62500', 436, '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 5, 6, 'PCS'),
(189, 1, '62500', 131, '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 5, 6, 'PCS'),
(190, 1, '62500', 184, '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 5, 6, 'PCS'),
(191, 1, '62500', 479, '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 5, 6, 'PCS'),
(192, 1, '62500', 184, '2024-06-09 00:00:00.000000', '2024-06-09 00:00:00.000000', 5, 6, 'PCS'),
(193, 1, '62500', 292, '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 5, 6, 'PCS'),
(194, 1, '62500', 237, '2024-07-21 00:00:00.000000', '2024-07-21 00:00:00.000000', 5, 6, 'PCS'),
(196, 1, '62500', 377, '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 5, 6, 'PCS'),
(197, 1, '62500', 285, '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 5, 6, 'PCS'),
(198, 1, '62500', 434, '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 5, 6, 'PCS'),
(199, 1, '62500', 387, '2024-07-03 00:00:00.000000', '2024-07-03 00:00:00.000000', 5, 6, 'PCS'),
(200, 1, '62500', 358, '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 5, 6, 'PCS'),
(201, 1, '62500', 109, '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 5, 6, 'PCS'),
(202, 1, '62500', 150, '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 5, 6, 'PCS'),
(203, 1, '62500', 403, '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 5, 6, 'PCS'),
(204, 1, '62500', 489, '2024-06-14 00:00:00.000000', '2024-06-14 00:00:00.000000', 5, 6, 'PCS'),
(205, 1, '62500', 378, '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 5, 6, 'PCS'),
(206, 1, '62500', 280, '2024-07-13 00:00:00.000000', '2024-07-13 00:00:00.000000', 5, 6, 'PCS'),
(207, 1, '62500', 149, '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 5, 6, 'PCS'),
(208, 1, '62500', 47, '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 5, 6, 'PCS'),
(209, 1, '57000', 372, '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 1, 7, 'PCS'),
(210, 1, '57000', 273, '2024-07-26 00:00:00.000000', '2024-07-26 00:00:00.000000', 1, 7, 'PCS'),
(211, 1, '57000', 376, '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 1, 7, 'PCS'),
(212, 1, '57000', 436, '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 1, 7, 'PCS'),
(213, 1, '57000', 287, '2024-06-13 00:00:00.000000', '2024-06-13 00:00:00.000000', 1, 7, 'PCS'),
(214, 1, '57000', 131, '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 1, 7, 'PCS'),
(215, 1, '57000', 477, '2024-07-27 00:00:00.000000', '2024-07-27 00:00:00.000000', 1, 7, 'PCS'),
(216, 1, '57000', 193, '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 1, 7, 'PCS'),
(217, 1, '57000', 94, '2024-07-19 00:00:00.000000', '2024-07-19 00:00:00.000000', 1, 7, 'PCS'),
(218, 1, '60500', 206, '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 2, 7, 'PCS'),
(219, 1, '60500', 109, '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 2, 7, 'PCS'),
(220, 1, '60500', 277, '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 2, 7, 'PCS'),
(221, 1, '60500', 239, '2024-06-20 00:00:00.000000', '2024-06-20 00:00:00.000000', 2, 7, 'PCS'),
(222, 1, '60500', 257, '2024-07-23 00:00:00.000000', '2024-07-23 00:00:00.000000', 2, 7, 'PCS'),
(223, 1, '60500', 119, '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 2, 7, 'PCS'),
(224, 1, '60500', 361, '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 2, 7, 'PCS'),
(225, 1, '60500', 356, '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 2, 7, 'PCS'),
(226, 1, '60500', 254, '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 2, 7, 'PCS'),
(228, 1, '60500', 355, '2024-07-26 00:00:00.000000', '2024-07-26 00:00:00.000000', 2, 7, 'PCS'),
(229, 1, '60500', 198, '2024-06-12 00:00:00.000000', '2024-06-12 00:00:00.000000', 2, 7, 'PCS'),
(230, 1, '60500', 149, '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 2, 7, 'PCS'),
(231, 1, '60500', 339, '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 2, 7, 'PCS'),
(232, 1, '60500', 133, '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 2, 7, 'PCS'),
(233, 1, '60500', 414, '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 2, 7, 'PCS'),
(234, 1, '60500', 424, '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 2, 7, 'PCS'),
(235, 1, '60500', 338, '2024-06-12 00:00:00.000000', '2024-06-12 00:00:00.000000', 2, 7, 'PCS'),
(236, 1, '60500', 172, '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 2, 7, 'PCS'),
(237, 1, '60500', 215, '2024-06-14 00:00:00.000000', '2024-06-14 00:00:00.000000', 2, 7, 'PCS'),
(238, 1, '60500', 417, '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 2, 7, 'PCS'),
(239, 1, '60500', 388, '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 2, 7, 'PCS'),
(240, 1, '60500', 156, '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 2, 7, 'PCS'),
(241, 1, '60500', 223, '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 2, 7, 'PCS'),
(242, 1, '60500', 316, '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 2, 7, 'PCS'),
(243, 1, '60500', 413, '2024-06-04 00:00:00.000000', '2024-06-04 00:00:00.000000', 2, 7, 'PCS'),
(244, 1, '60500', 122, '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 2, 7, 'PCS'),
(245, 1, '60500', 218, '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 2, 7, 'PCS'),
(246, 1, '60500', 175, '2024-07-06 00:00:00.000000', '2024-07-06 00:00:00.000000', 2, 7, 'PCS'),
(247, 1, '60500', 14, '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 2, 7, 'PCS'),
(248, 1, '55000', 473, '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 3, 7, 'PCS'),
(249, 1, '55000', 119, '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 3, 7, 'PCS'),
(250, 1, '55000', 418, '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 3, 7, 'PCS'),
(252, 1, '55000', 237, '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 3, 7, 'PCS'),
(253, 1, '55000', 286, '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 3, 7, 'PCS'),
(254, 1, '55000', 148, '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 3, 7, 'PCS'),
(255, 1, '55000', 483, '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 3, 7, 'PCS'),
(256, 1, '55000', 148, '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 3, 7, 'PCS'),
(257, 1, '55000', 285, '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 3, 7, 'PCS'),
(258, 1, '55000', 227, '2024-07-14 00:00:00.000000', '2024-07-14 00:00:00.000000', 3, 7, 'PCS'),
(259, 1, '55000', 209, '2024-07-06 00:00:00.000000', '2024-07-06 00:00:00.000000', 3, 7, 'PCS'),
(260, 1, '55000', 317, '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 3, 7, 'PCS'),
(261, 1, '55000', 191, '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 3, 7, 'PCS'),
(262, 1, '55000', 446, '2024-06-09 00:00:00.000000', '2024-06-09 00:00:00.000000', 3, 7, 'PCS'),
(263, 1, '55000', 219, '2024-06-01 00:00:00.000000', '2024-06-01 00:00:00.000000', 3, 7, 'PCS'),
(264, 1, '55000', 417, '2024-07-13 00:00:00.000000', '2024-07-13 00:00:00.000000', 3, 7, 'PCS'),
(265, 1, '55000', 291, '2024-07-19 00:00:00.000000', '2024-07-19 00:00:00.000000', 3, 7, 'PCS'),
(266, 1, '55000', 412, '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 3, 7, 'PCS'),
(267, 1, '55000', 317, '2024-07-27 00:00:00.000000', '2024-07-27 00:00:00.000000', 3, 7, 'PCS'),
(268, 1, '55000', 287, '2024-07-25 00:00:00.000000', '2024-07-25 00:00:00.000000', 3, 7, 'PCS'),
(269, 1, '55000', 174, '2024-06-04 00:00:00.000000', '2024-06-04 00:00:00.000000', 3, 7, 'PCS'),
(270, 1, '59500', 164, '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 4, 7, 'PCS'),
(271, 1, '59500', 366, '2024-07-14 00:00:00.000000', '2024-07-14 00:00:00.000000', 4, 7, 'PCS'),
(272, 1, '59500', 381, '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 4, 7, 'PCS'),
(273, 1, '59500', 354, '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 4, 7, 'PCS'),
(274, 1, '59500', 214, '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 4, 7, 'PCS'),
(275, 1, '59500', 334, '2024-07-31 00:00:00.000000', '2024-07-31 00:00:00.000000', 4, 7, 'PCS'),
(276, 1, '59500', 238, '2024-07-31 00:00:00.000000', '2024-07-31 00:00:00.000000', 4, 7, 'PCS'),
(277, 1, '62500', 298, '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 5, 7, 'PCS');

-- --------------------------------------------------------

--
-- Table structure for table `recipes`
--

CREATE TABLE `recipes` (
  `id` bigint NOT NULL,
  `amount` int NOT NULL,
  `unit` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `item_id` bigint NOT NULL,
  `material_id` bigint DEFAULT NULL,
  `outlet_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `recipes`
--

INSERT INTO `recipes` (`id`, `amount`, `unit`, `created_at`, `updated_at`, `item_id`, `material_id`, `outlet_id`) VALUES
(4, 1, 'UnitTypes.KG', '2023-10-20 13:29:52.456954', '2023-10-20 13:29:52.456954', 9, 4, 3),
(6, 1, 'UnitTypes.KG', '2023-10-20 13:41:46.134925', '2023-10-20 13:41:46.134925', 9, 1, 3),
(7, 1, 'UnitTypes.KG', '2023-10-20 13:42:02.118888', '2023-10-20 13:42:02.118888', 9, 3, 3);

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `id` bigint NOT NULL,
  `user_id` int NOT NULL,
  `price` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `amount` int NOT NULL,
  `unit` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `item_id` bigint NOT NULL,
  `outlet_id` bigint NOT NULL,
  `buyer_id` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sales`
--

INSERT INTO `sales` (`id`, `user_id`, `price`, `amount`, `unit`, `created_at`, `updated_at`, `item_id`, `outlet_id`, `buyer_id`) VALUES
(1, 1, '57000', 114, 'pcs', '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 1, 3, 5),
(2, 1, '57000', 107, 'pcs', '2024-06-01 00:00:00.000000', '2024-06-01 00:00:00.000000', 1, 3, 5),
(3, 1, '57000', 117, 'pcs', '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 1, 3, 5),
(4, 1, '57000', 310, 'pcs', '2024-06-05 00:00:00.000000', '2024-06-05 00:00:00.000000', 1, 3, 5),
(5, 1, '57000', 248, 'pcs', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 1, 3, 5),
(6, 1, '57000', 240, 'pcs', '2024-06-07 00:00:00.000000', '2024-06-07 00:00:00.000000', 1, 3, 5),
(7, 1, '57000', 262, 'pcs', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 1, 3, 5),
(8, 1, '57000', 341, 'pcs', '2024-07-25 00:00:00.000000', '2024-07-25 00:00:00.000000', 1, 3, 5),
(9, 1, '57000', 167, 'pcs', '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 1, 3, 5),
(10, 1, '57000', 263, 'pcs', '2024-07-26 00:00:00.000000', '2024-07-26 00:00:00.000000', 1, 3, 5),
(11, 1, '57000', 303, 'pcs', '2024-06-17 00:00:00.000000', '2024-06-17 00:00:00.000000', 1, 3, 5),
(12, 1, '57000', 234, 'pcs', '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 1, 3, 5),
(13, 1, '57000', 283, 'pcs', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 1, 3, 5),
(14, 1, '57000', 263, 'pcs', '2024-07-25 00:00:00.000000', '2024-07-25 00:00:00.000000', 1, 3, 5),
(15, 1, '57000', 253, 'pcs', '2024-07-21 00:00:00.000000', '2024-07-21 00:00:00.000000', 1, 3, 5),
(16, 1, '57000', 115, 'pcs', '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 1, 3, 5),
(17, 1, '57000', 315, 'pcs', '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 1, 3, 5),
(18, 1, '57000', 485, 'pcs', '2024-07-18 00:00:00.000000', '2024-07-18 00:00:00.000000', 1, 3, 5),
(19, 1, '57000', 379, 'pcs', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 1, 3, 5),
(20, 1, '57000', 416, 'pcs', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 1, 3, 5),
(21, 1, '57000', 206, 'pcs', '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 1, 3, 5),
(22, 1, '57000', 422, 'pcs', '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 1, 3, 5),
(23, 1, '57000', 53, 'pcs', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 1, 3, 5),
(24, 1, '60500', 108, 'pcs', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 2, 3, 5),
(25, 1, '60500', 161, 'pcs', '2024-07-03 00:00:00.000000', '2024-07-03 00:00:00.000000', 2, 3, 5),
(26, 1, '60500', 227, 'pcs', '2024-06-17 00:00:00.000000', '2024-06-17 00:00:00.000000', 2, 3, 5),
(27, 1, '60500', 243, 'pcs', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 2, 3, 5),
(28, 1, '60500', 135, 'pcs', '2024-07-26 00:00:00.000000', '2024-07-26 00:00:00.000000', 2, 3, 5),
(29, 1, '60500', 442, 'pcs', '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 2, 3, 5),
(30, 1, '60500', 184, 'pcs', '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 2, 3, 5),
(31, 1, '60500', 159, 'pcs', '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 2, 3, 5),
(32, 1, '60500', 259, 'pcs', '2024-07-18 00:00:00.000000', '2024-07-18 00:00:00.000000', 2, 3, 5),
(33, 1, '60500', 464, 'pcs', '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 2, 3, 5),
(34, 1, '60500', 185, 'pcs', '2024-07-07 00:00:00.000000', '2024-07-07 00:00:00.000000', 2, 3, 5),
(35, 1, '60500', 490, 'pcs', '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 2, 3, 5),
(36, 1, '60500', 421, 'pcs', '2024-06-20 00:00:00.000000', '2024-06-20 00:00:00.000000', 2, 3, 5),
(37, 1, '60500', 252, 'pcs', '2024-06-30 00:00:00.000000', '2024-06-30 00:00:00.000000', 2, 3, 5),
(38, 1, '60500', 193, 'pcs', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 2, 3, 5),
(39, 1, '60500', 375, 'pcs', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 2, 3, 5),
(40, 1, '60500', 164, 'pcs', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 2, 3, 5),
(41, 1, '55000', 151, 'pcs', '2024-07-21 00:00:00.000000', '2024-07-21 00:00:00.000000', 3, 3, 5),
(42, 1, '55000', 225, 'pcs', '2024-07-07 00:00:00.000000', '2024-07-07 00:00:00.000000', 3, 3, 5),
(43, 1, '55000', 314, 'pcs', '2024-07-07 00:00:00.000000', '2024-07-07 00:00:00.000000', 3, 3, 5),
(44, 1, '55000', 271, 'pcs', '2024-07-03 00:00:00.000000', '2024-07-03 00:00:00.000000', 3, 3, 5),
(45, 1, '55000', 308, 'pcs', '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 3, 3, 5),
(46, 1, '55000', 370, 'pcs', '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 3, 3, 5),
(47, 1, '55000', 123, 'pcs', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 3, 3, 5),
(48, 1, '55000', 168, 'pcs', '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 3, 3, 5),
(49, 1, '55000', 231, 'pcs', '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 3, 3, 5),
(50, 1, '55000', 491, 'pcs', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 3, 3, 5),
(51, 1, '55000', 201, 'pcs', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 3, 3, 5),
(52, 1, '55000', 100, 'pcs', '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 3, 3, 5),
(53, 1, '55000', 131, 'pcs', '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 3, 3, 5),
(54, 1, '55000', 393, 'pcs', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 3, 3, 5),
(55, 1, '55000', 220, 'pcs', '2024-07-14 00:00:00.000000', '2024-07-14 00:00:00.000000', 3, 3, 5),
(56, 1, '55000', 278, 'pcs', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 3, 3, 5),
(57, 1, '55000', 479, 'pcs', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 3, 3, 5),
(58, 1, '55000', 242, 'pcs', '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 3, 3, 5),
(59, 1, '55000', 397, 'pcs', '2024-07-30 00:00:00.000000', '2024-07-30 00:00:00.000000', 3, 3, 5),
(60, 1, '55000', 275, 'pcs', '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 3, 3, 5),
(61, 1, '55000', 264, 'pcs', '2024-07-18 00:00:00.000000', '2024-07-18 00:00:00.000000', 3, 3, 5),
(62, 1, '55000', 363, 'pcs', '2024-06-19 00:00:00.000000', '2024-06-19 00:00:00.000000', 3, 3, 5),
(63, 1, '55000', 146, 'pcs', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 3, 3, 5),
(64, 1, '55000', 382, 'pcs', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 3, 3, 5),
(65, 1, '55000', 388, 'pcs', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 3, 3, 5),
(66, 1, '59500', 216, 'pcs', '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 4, 3, 5),
(67, 1, '59500', 183, 'pcs', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 4, 3, 5),
(68, 1, '59500', 142, 'pcs', '2024-06-13 00:00:00.000000', '2024-06-13 00:00:00.000000', 4, 3, 5),
(69, 1, '59500', 454, 'pcs', '2024-06-23 00:00:00.000000', '2024-06-23 00:00:00.000000', 4, 3, 5),
(70, 1, '59500', 387, 'pcs', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 4, 3, 5),
(71, 1, '59500', 472, 'pcs', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 4, 3, 5),
(72, 1, '59500', 239, 'pcs', '2024-06-30 00:00:00.000000', '2024-06-30 00:00:00.000000', 4, 3, 5),
(73, 1, '59500', 242, 'pcs', '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 4, 3, 5),
(74, 1, '59500', 350, 'pcs', '2024-06-01 00:00:00.000000', '2024-06-01 00:00:00.000000', 4, 3, 5),
(75, 1, '59500', 283, 'pcs', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 4, 3, 5),
(76, 1, '59500', 179, 'pcs', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 4, 3, 5),
(77, 1, '59500', 234, 'pcs', '2024-07-30 00:00:00.000000', '2024-07-30 00:00:00.000000', 4, 3, 5),
(78, 1, '59500', 200, 'pcs', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 4, 3, 5),
(79, 1, '59500', 264, 'pcs', '2024-06-13 00:00:00.000000', '2024-06-13 00:00:00.000000', 4, 3, 5),
(80, 1, '59500', 215, 'pcs', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 4, 3, 5),
(81, 1, '59500', 265, 'pcs', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 4, 3, 5),
(82, 1, '59500', 395, 'pcs', '2024-07-31 00:00:00.000000', '2024-07-31 00:00:00.000000', 4, 3, 5),
(83, 1, '62500', 349, 'pcs', '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 5, 3, 5),
(84, 1, '62500', 104, 'pcs', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 5, 3, 5),
(85, 1, '62500', 211, 'pcs', '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 5, 3, 5),
(86, 1, '62500', 409, 'pcs', '2024-06-20 00:00:00.000000', '2024-06-20 00:00:00.000000', 5, 3, 5),
(87, 1, '62500', 349, 'pcs', '2024-06-01 00:00:00.000000', '2024-06-02 00:00:00.000000', 5, 3, 5),
(88, 1, '62500', 179, 'pcs', '2024-06-17 00:00:00.000000', '2024-06-17 00:00:00.000000', 5, 3, 5),
(89, 1, '62500', 132, 'pcs', '2024-06-12 00:00:00.000000', '2024-06-12 00:00:00.000000', 5, 3, 5),
(90, 1, '62500', 338, 'pcs', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 5, 3, 5),
(91, 1, '62500', 104, 'pcs', '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 5, 3, 5),
(92, 1, '57000', 289, 'pcs', '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 1, 3, 6),
(93, 1, '57000', 182, 'pcs', '2024-07-06 00:00:00.000000', '2024-07-06 00:00:00.000000', 1, 3, 6),
(94, 1, '57000', 108, 'pcs', '2024-06-13 00:00:00.000000', '2024-06-13 00:00:00.000000', 1, 3, 6),
(95, 1, '57000', 226, 'pcs', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 1, 3, 6),
(96, 1, '57000', 424, 'pcs', '2024-06-09 00:00:00.000000', '2024-06-09 00:00:00.000000', 1, 3, 6),
(97, 1, '57000', 302, 'pcs', '2024-07-14 00:00:00.000000', '2024-07-14 00:00:00.000000', 1, 3, 6),
(98, 1, '57000', 137, 'pcs', '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 1, 3, 6),
(99, 1, '57000', 162, 'pcs', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 1, 3, 6),
(100, 1, '57000', 399, 'pcs', '2024-06-06 00:00:00.000000', '2024-06-06 00:00:00.000000', 1, 3, 6),
(101, 1, '57000', 436, 'pcs', '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 1, 3, 6),
(102, 1, '57000', 152, 'pcs', '2024-07-30 00:00:00.000000', '2024-07-30 00:00:00.000000', 1, 3, 6),
(103, 1, '57000', 431, 'pcs', '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 1, 3, 6),
(104, 1, '57000', 260, 'pcs', '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 1, 3, 6),
(105, 1, '57000', 164, 'pcs', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 1, 3, 6),
(106, 1, '57000', 185, 'pcs', '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 1, 3, 6),
(107, 1, '57000', 473, 'pcs', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 1, 3, 6),
(108, 1, '57000', 260, 'pcs', '2024-06-19 00:00:00.000000', '2024-06-19 00:00:00.000000', 1, 3, 6),
(109, 1, '57000', 263, 'pcs', '2024-06-01 00:00:00.000000', '2024-06-01 00:00:00.000000', 1, 3, 6),
(110, 1, '57000', 189, 'pcs', '2024-07-16 00:00:00.000000', '2024-07-16 00:00:00.000000', 1, 3, 6),
(111, 1, '57000', 344, 'pcs', '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 1, 3, 6),
(112, 1, '57000', 429, 'pcs', '2024-06-07 00:00:00.000000', '2024-06-07 00:00:00.000000', 1, 3, 6),
(113, 1, '57000', 141, 'pcs', '2024-07-03 00:00:00.000000', '2024-07-03 00:00:00.000000', 1, 3, 6),
(114, 1, '57000', 240, 'pcs', '2024-06-20 00:00:00.000000', '2024-06-20 00:00:00.000000', 1, 3, 6),
(115, 1, '57000', 146, 'pcs', '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 1, 3, 6),
(116, 1, '57000', 421, 'pcs', '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 1, 3, 6),
(117, 1, '57000', 182, 'pcs', '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 1, 3, 6),
(118, 1, '57000', 115, 'pcs', '2024-06-06 00:00:00.000000', '2024-06-06 00:00:00.000000', 1, 3, 6),
(119, 1, '57000', 349, 'pcs', '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 1, 3, 6),
(120, 1, '57000', 246, 'pcs', '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 1, 3, 6),
(121, 1, '57000', 488, 'pcs', '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 1, 3, 6),
(122, 1, '57000', 483, 'pcs', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 1, 3, 6),
(123, 1, '57000', 274, 'pcs', '2024-07-19 00:00:00.000000', '2024-07-19 00:00:00.000000', 1, 3, 6),
(124, 1, '57000', 242, 'pcs', '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 1, 3, 6),
(125, 1, '57000', 268, 'pcs', '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 1, 3, 6),
(126, 1, '57000', 55, 'pcs', '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 1, 3, 6),
(127, 1, '60500', 371, 'pcs', '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 2, 3, 6),
(128, 1, '60500', 478, 'pcs', '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 2, 3, 6),
(129, 1, '60500', 175, 'pcs', '2024-06-19 00:00:00.000000', '2024-06-19 00:00:00.000000', 2, 3, 6),
(130, 1, '60500', 218, 'pcs', '2024-07-07 00:00:00.000000', '2024-07-07 00:00:00.000000', 2, 3, 6),
(131, 1, '60500', 435, 'pcs', '2024-06-01 00:00:00.000000', '2024-06-02 00:00:00.000000', 2, 3, 6),
(132, 1, '60500', 358, 'pcs', '2024-07-12 00:00:00.000000', '2024-07-12 00:00:00.000000', 2, 3, 6),
(133, 1, '60500', 119, 'pcs', '2024-06-19 00:00:00.000000', '2024-06-19 00:00:00.000000', 2, 3, 6),
(134, 1, '60500', 242, 'pcs', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 2, 3, 6),
(135, 1, '60500', 378, 'pcs', '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 2, 3, 6),
(136, 1, '60500', 354, 'pcs', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 2, 3, 6),
(137, 1, '60500', 190, 'pcs', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 2, 3, 6),
(138, 1, '60500', 439, 'pcs', '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 2, 3, 6),
(139, 1, '60500', 394, 'pcs', '2024-06-13 00:00:00.000000', '2024-06-13 00:00:00.000000', 2, 3, 6),
(140, 1, '60500', 308, 'pcs', '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 2, 3, 6),
(141, 1, '60500', 144, 'pcs', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 2, 3, 6),
(142, 1, '60500', 351, 'pcs', '2024-07-27 00:00:00.000000', '2024-07-27 00:00:00.000000', 2, 3, 6),
(143, 1, '60500', 138, 'pcs', '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 2, 3, 6),
(144, 1, '60500', 185, 'pcs', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 2, 3, 6),
(145, 1, '60500', 138, 'pcs', '2024-07-08 00:00:00.000000', '2024-07-08 00:00:00.000000', 2, 3, 6),
(146, 1, '60500', 253, 'pcs', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 2, 3, 6),
(147, 1, '60500', 392, 'pcs', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 2, 3, 6),
(148, 1, '60500', 399, 'pcs', '2024-06-06 00:00:00.000000', '2024-06-06 00:00:00.000000', 2, 3, 6),
(149, 1, '60500', 450, 'pcs', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 2, 3, 6),
(150, 1, '60500', 119, 'pcs', '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 2, 3, 6),
(151, 1, '60500', 226, 'pcs', '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 2, 3, 6),
(152, 1, '60500', 203, 'pcs', '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 2, 3, 6),
(153, 1, '60500', 214, 'pcs', '2024-07-25 00:00:00.000000', '2024-07-25 00:00:00.000000', 2, 3, 6),
(154, 1, '60500', 473, 'pcs', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 2, 3, 6),
(155, 1, '60500', 37, 'pcs', '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 2, 3, 6),
(156, 1, '55000', 122, 'pcs', '2024-07-23 00:00:00.000000', '2024-07-23 00:00:00.000000', 3, 3, 6),
(157, 1, '55000', 160, 'pcs', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 3, 3, 6),
(158, 1, '55000', 383, 'pcs', '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 3, 3, 6),
(159, 1, '55000', 287, 'pcs', '2024-06-09 00:00:00.000000', '2024-06-09 00:00:00.000000', 3, 3, 6),
(160, 1, '55000', 476, 'pcs', '2024-07-19 00:00:00.000000', '2024-07-19 00:00:00.000000', 3, 3, 6),
(161, 1, '55000', 258, 'pcs', '2024-07-31 00:00:00.000000', '2024-07-31 00:00:00.000000', 3, 3, 6),
(162, 1, '55000', 299, 'pcs', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 3, 3, 6),
(163, 1, '59500', 142, 'pcs', '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 4, 3, 6),
(164, 1, '59500', 416, 'pcs', '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 4, 3, 6),
(165, 1, '59500', 355, 'pcs', '2024-06-09 00:00:00.000000', '2024-06-09 00:00:00.000000', 4, 3, 6),
(166, 1, '59500', 436, 'pcs', '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 4, 3, 6),
(167, 1, '59500', 482, 'pcs', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 4, 3, 6),
(168, 1, '59500', 401, 'pcs', '2024-06-01 00:00:00.000000', '2024-06-01 00:00:00.000000', 4, 3, 6),
(169, 1, '59500', 472, 'pcs', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 4, 3, 6),
(170, 1, '59500', 111, 'pcs', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 4, 3, 6),
(171, 1, '59500', 202, 'pcs', '2024-06-17 00:00:00.000000', '2024-06-17 00:00:00.000000', 4, 3, 6),
(172, 1, '59500', 141, 'pcs', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 4, 3, 6),
(173, 1, '59500', 71, 'pcs', '2024-07-16 00:00:00.000000', '2024-07-16 00:00:00.000000', 4, 3, 6),
(174, 1, '62500', 286, 'pcs', '2024-07-16 00:00:00.000000', '2024-07-16 00:00:00.000000', 5, 3, 6),
(175, 1, '62500', 452, 'pcs', '2024-07-06 00:00:00.000000', '2024-07-06 00:00:00.000000', 5, 3, 6),
(176, 1, '62500', 436, 'pcs', '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 5, 3, 6),
(177, 1, '62500', 131, 'pcs', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 5, 3, 6),
(178, 1, '62500', 184, 'pcs', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 5, 3, 6),
(179, 1, '62500', 479, 'pcs', '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 5, 3, 6),
(180, 1, '62500', 184, 'pcs', '2024-06-09 00:00:00.000000', '2024-06-09 00:00:00.000000', 5, 3, 6),
(181, 1, '62500', 292, 'pcs', '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 5, 3, 6),
(182, 1, '62500', 237, 'pcs', '2024-07-21 00:00:00.000000', '2024-07-21 00:00:00.000000', 5, 3, 6),
(183, 1, '62500', 377, 'pcs', '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 5, 3, 6),
(184, 1, '62500', 285, 'pcs', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 5, 3, 6),
(185, 1, '62500', 434, 'pcs', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 5, 3, 6),
(186, 1, '62500', 387, 'pcs', '2024-07-03 00:00:00.000000', '2024-07-03 00:00:00.000000', 5, 3, 6),
(187, 1, '62500', 358, 'pcs', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 5, 3, 6),
(188, 1, '62500', 109, 'pcs', '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 5, 3, 6),
(189, 1, '62500', 150, 'pcs', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 5, 3, 6),
(190, 1, '62500', 403, 'pcs', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 5, 3, 6),
(191, 1, '62500', 489, 'pcs', '2024-06-14 00:00:00.000000', '2024-06-14 00:00:00.000000', 5, 3, 6),
(192, 1, '62500', 378, 'pcs', '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 5, 3, 6),
(193, 1, '62500', 280, 'pcs', '2024-07-13 00:00:00.000000', '2024-07-13 00:00:00.000000', 5, 3, 6),
(194, 1, '62500', 149, 'pcs', '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 5, 3, 6),
(195, 1, '62500', 47, 'pcs', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 5, 3, 6),
(196, 1, '57000', 372, 'pcs', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 1, 3, 7),
(197, 1, '57000', 273, 'pcs', '2024-07-26 00:00:00.000000', '2024-07-26 00:00:00.000000', 1, 3, 7),
(198, 1, '57000', 376, 'pcs', '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 1, 3, 7),
(199, 1, '57000', 436, 'pcs', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 1, 3, 7),
(200, 1, '57000', 287, 'pcs', '2024-06-13 00:00:00.000000', '2024-06-13 00:00:00.000000', 1, 3, 7),
(201, 1, '57000', 131, 'pcs', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 1, 3, 7),
(202, 1, '57000', 477, 'pcs', '2024-07-27 00:00:00.000000', '2024-07-27 00:00:00.000000', 1, 3, 7),
(203, 1, '57000', 193, 'pcs', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 1, 3, 7),
(204, 1, '57000', 94, 'pcs', '2024-07-19 00:00:00.000000', '2024-07-19 00:00:00.000000', 1, 3, 7),
(205, 1, '60500', 206, 'pcs', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 2, 3, 7),
(206, 1, '60500', 109, 'pcs', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 2, 3, 7),
(207, 1, '60500', 277, 'pcs', '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 2, 3, 7),
(208, 1, '60500', 239, 'pcs', '2024-06-20 00:00:00.000000', '2024-06-20 00:00:00.000000', 2, 3, 7),
(209, 1, '60500', 257, 'pcs', '2024-07-23 00:00:00.000000', '2024-07-23 00:00:00.000000', 2, 3, 7),
(210, 1, '60500', 119, 'pcs', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 2, 3, 7),
(211, 1, '60500', 361, 'pcs', '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 2, 3, 7),
(212, 1, '60500', 356, 'pcs', '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 2, 3, 7),
(213, 1, '60500', 254, 'pcs', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 2, 3, 7),
(214, 1, '60500', 355, 'pcs', '2024-07-26 00:00:00.000000', '2024-07-26 00:00:00.000000', 2, 3, 7),
(215, 1, '60500', 198, 'pcs', '2024-06-12 00:00:00.000000', '2024-06-12 00:00:00.000000', 2, 3, 7),
(216, 1, '60500', 149, 'pcs', '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 2, 3, 7),
(217, 1, '60500', 339, 'pcs', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 2, 3, 7),
(218, 1, '60500', 133, 'pcs', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 2, 3, 7),
(219, 1, '60500', 414, 'pcs', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 2, 3, 7),
(220, 1, '60500', 424, 'pcs', '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 2, 3, 7),
(221, 1, '60500', 338, 'pcs', '2024-06-12 00:00:00.000000', '2024-06-12 00:00:00.000000', 2, 3, 7),
(222, 1, '60500', 172, 'pcs', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 2, 3, 7),
(223, 1, '60500', 215, 'pcs', '2024-06-14 00:00:00.000000', '2024-06-14 00:00:00.000000', 2, 3, 7),
(224, 1, '60500', 417, 'pcs', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 2, 3, 7),
(225, 1, '60500', 388, 'pcs', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 2, 3, 7),
(226, 1, '60500', 156, 'pcs', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 2, 3, 7),
(227, 1, '60500', 223, 'pcs', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 2, 3, 7),
(228, 1, '60500', 316, 'pcs', '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 2, 3, 7),
(229, 1, '60500', 413, 'pcs', '2024-06-04 00:00:00.000000', '2024-06-04 00:00:00.000000', 2, 3, 7),
(230, 1, '60500', 122, 'pcs', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 2, 3, 7),
(231, 1, '60500', 218, 'pcs', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 2, 3, 7),
(232, 1, '60500', 175, 'pcs', '2024-07-06 00:00:00.000000', '2024-07-06 00:00:00.000000', 2, 3, 7),
(233, 1, '60500', 14, 'pcs', '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 2, 3, 7),
(234, 1, '55000', 473, 'pcs', '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 3, 3, 7),
(235, 1, '55000', 119, 'pcs', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 3, 3, 7),
(236, 1, '55000', 418, 'pcs', '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 3, 3, 7),
(237, 1, '55000', 237, 'pcs', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 3, 3, 7),
(238, 1, '55000', 286, 'pcs', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 3, 3, 7),
(239, 1, '55000', 148, 'pcs', '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 3, 3, 7),
(240, 1, '55000', 483, 'pcs', '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 3, 3, 7),
(241, 1, '55000', 148, 'pcs', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 3, 3, 7),
(242, 1, '55000', 285, 'pcs', '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 3, 3, 7),
(243, 1, '55000', 227, 'pcs', '2024-07-14 00:00:00.000000', '2024-07-14 00:00:00.000000', 3, 3, 7),
(244, 1, '55000', 209, 'pcs', '2024-07-06 00:00:00.000000', '2024-07-06 00:00:00.000000', 3, 3, 7),
(245, 1, '55000', 317, 'pcs', '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 3, 3, 7),
(246, 1, '55000', 191, 'pcs', '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 3, 3, 7),
(247, 1, '55000', 446, 'pcs', '2024-06-09 00:00:00.000000', '2024-06-09 00:00:00.000000', 3, 3, 7),
(248, 1, '55000', 219, 'pcs', '2024-06-01 00:00:00.000000', '2024-06-01 00:00:00.000000', 3, 3, 7),
(249, 1, '55000', 417, 'pcs', '2024-07-13 00:00:00.000000', '2024-07-13 00:00:00.000000', 3, 3, 7),
(250, 1, '55000', 291, 'pcs', '2024-07-19 00:00:00.000000', '2024-07-19 00:00:00.000000', 3, 3, 7),
(251, 1, '55000', 412, 'pcs', '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 3, 3, 7),
(252, 1, '55000', 317, 'pcs', '2024-07-27 00:00:00.000000', '2024-07-27 00:00:00.000000', 3, 3, 7),
(253, 1, '55000', 287, 'pcs', '2024-07-25 00:00:00.000000', '2024-07-25 00:00:00.000000', 3, 3, 7),
(254, 1, '55000', 174, 'pcs', '2024-06-04 00:00:00.000000', '2024-06-04 00:00:00.000000', 3, 3, 7),
(255, 1, '59500', 164, 'pcs', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 4, 3, 7),
(256, 1, '59500', 366, 'pcs', '2024-07-14 00:00:00.000000', '2024-07-14 00:00:00.000000', 4, 3, 7),
(257, 1, '59500', 381, 'pcs', '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 4, 3, 7),
(258, 1, '59500', 354, 'pcs', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 4, 3, 7),
(259, 1, '59500', 214, 'pcs', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 4, 3, 7),
(260, 1, '59500', 334, 'pcs', '2024-07-31 00:00:00.000000', '2024-07-31 00:00:00.000000', 4, 3, 7),
(261, 1, '59500', 238, 'pcs', '2024-07-31 00:00:00.000000', '2024-07-31 00:00:00.000000', 4, 3, 7),
(262, 1, '62500', 298, 'pcs', '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 5, 3, 7),
(263, 1, '57000', 300, 'pcs', '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 1, 5, NULL),
(264, 1, '57000', 283, 'pcs', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 1, 5, NULL),
(265, 1, '57000', 165, 'pcs', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 1, 5, NULL),
(266, 1, '57000', 285, 'pcs', '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 1, 5, NULL),
(267, 1, '57000', 266, 'pcs', '2024-07-31 00:00:00.000000', '2024-07-31 00:00:00.000000', 1, 5, NULL),
(268, 1, '57000', 170, 'pcs', '2024-07-19 00:00:00.000000', '2024-07-19 00:00:00.000000', 1, 5, NULL),
(269, 1, '57000', 163, 'pcs', '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 1, 5, NULL),
(270, 1, '57000', 173, 'pcs', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 1, 5, NULL),
(271, 1, '57000', 197, 'pcs', '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 1, 5, NULL),
(272, 1, '57000', 283, 'pcs', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 1, 5, NULL),
(273, 1, '57000', 215, 'pcs', '2024-07-23 00:00:00.000000', '2024-07-23 00:00:00.000000', 1, 5, NULL),
(274, 1, '57000', 131, 'pcs', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 1, 5, NULL),
(275, 1, '57000', 199, 'pcs', '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 1, 5, NULL),
(276, 1, '57000', 199, 'pcs', '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 1, 5, NULL),
(277, 1, '57000', 188, 'pcs', '2024-07-29 00:00:00.000000', '2024-07-29 00:00:00.000000', 1, 5, NULL),
(278, 1, '57000', 236, 'pcs', '2024-07-08 00:00:00.000000', '2024-07-08 00:00:00.000000', 1, 5, NULL),
(279, 1, '57000', 278, 'pcs', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 1, 5, NULL),
(280, 1, '57000', 239, 'pcs', '2024-06-20 00:00:00.000000', '2024-06-20 00:00:00.000000', 1, 5, NULL),
(281, 1, '57000', 108, 'pcs', '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 1, 5, NULL),
(282, 1, '57000', 190, 'pcs', '2024-06-12 00:00:00.000000', '2024-06-12 00:00:00.000000', 1, 5, NULL),
(283, 1, '57000', 149, 'pcs', '2024-06-17 00:00:00.000000', '2024-06-17 00:00:00.000000', 1, 5, NULL),
(284, 1, '57000', 122, 'pcs', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 1, 5, NULL),
(285, 1, '57000', 196, 'pcs', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 1, 5, NULL),
(286, 1, '57000', 221, 'pcs', '2024-06-04 00:00:00.000000', '2024-06-04 00:00:00.000000', 1, 5, NULL),
(287, 1, '57000', 286, 'pcs', '2024-06-06 00:00:00.000000', '2024-06-06 00:00:00.000000', 1, 5, NULL),
(288, 1, '57000', 240, 'pcs', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 1, 5, NULL),
(289, 1, '57000', 209, 'pcs', '2024-07-06 00:00:00.000000', '2024-07-06 00:00:00.000000', 1, 5, NULL),
(290, 1, '57000', 205, 'pcs', '2024-07-29 00:00:00.000000', '2024-07-29 00:00:00.000000', 1, 5, NULL),
(291, 1, '60500', 264, 'pcs', '2024-07-21 00:00:00.000000', '2024-07-21 00:00:00.000000', 2, 5, NULL),
(292, 1, '60500', 182, 'pcs', '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 2, 5, NULL),
(293, 1, '60500', 200, 'pcs', '2024-07-29 00:00:00.000000', '2024-07-29 00:00:00.000000', 2, 5, NULL),
(294, 1, '60500', 296, 'pcs', '2024-06-23 00:00:00.000000', '2024-06-23 00:00:00.000000', 2, 5, NULL),
(295, 1, '60500', 223, 'pcs', '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 2, 5, NULL),
(296, 1, '60500', 218, 'pcs', '2024-07-29 00:00:00.000000', '2024-07-29 00:00:00.000000', 2, 5, NULL),
(297, 1, '60500', 160, 'pcs', '2024-06-20 00:00:00.000000', '2024-06-20 00:00:00.000000', 2, 5, NULL),
(298, 1, '60500', 275, 'pcs', '2024-06-23 00:00:00.000000', '2024-06-23 00:00:00.000000', 2, 5, NULL),
(299, 1, '60500', 143, 'pcs', '2024-07-26 00:00:00.000000', '2024-07-26 00:00:00.000000', 2, 5, NULL),
(300, 1, '60500', 103, 'pcs', '2024-07-13 00:00:00.000000', '2024-07-13 00:00:00.000000', 2, 5, NULL),
(301, 1, '60500', 272, 'pcs', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 2, 5, NULL),
(302, 1, '60500', 179, 'pcs', '2024-07-12 00:00:00.000000', '2024-07-12 00:00:00.000000', 2, 5, NULL),
(303, 1, '60500', 189, 'pcs', '2024-07-03 00:00:00.000000', '2024-07-03 00:00:00.000000', 2, 5, NULL),
(304, 1, '60500', 153, 'pcs', '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 2, 5, NULL),
(305, 1, '60500', 272, 'pcs', '2024-06-13 00:00:00.000000', '2024-06-13 00:00:00.000000', 2, 5, NULL),
(306, 1, '60500', 145, 'pcs', '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 2, 5, NULL),
(307, 1, '60500', 264, 'pcs', '2024-07-07 00:00:00.000000', '2024-07-07 00:00:00.000000', 2, 5, NULL),
(308, 1, '60500', 259, 'pcs', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 2, 5, NULL),
(309, 1, '60500', 211, 'pcs', '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 2, 5, NULL),
(310, 1, '60500', 209, 'pcs', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 2, 5, NULL),
(311, 1, '60500', 108, 'pcs', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 2, 5, NULL),
(312, 1, '60500', 137, 'pcs', '2024-07-31 00:00:00.000000', '2024-07-31 00:00:00.000000', 2, 5, NULL),
(313, 1, '55000', 246, 'pcs', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 3, 5, NULL),
(314, 1, '55000', 238, 'pcs', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 3, 5, NULL),
(315, 1, '55000', 195, 'pcs', '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 3, 5, NULL),
(316, 1, '55000', 232, 'pcs', '2024-06-28 00:00:00.000000', '2024-06-28 00:00:00.000000', 3, 5, NULL),
(317, 1, '55000', 228, 'pcs', '2024-07-27 00:00:00.000000', '2024-07-27 00:00:00.000000', 3, 5, NULL),
(318, 1, '55000', 162, 'pcs', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 3, 5, NULL),
(319, 1, '55000', 236, 'pcs', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 3, 5, NULL),
(320, 1, '55000', 203, 'pcs', '2024-07-23 00:00:00.000000', '2024-07-23 00:00:00.000000', 3, 5, NULL),
(321, 1, '55000', 234, 'pcs', '2024-06-07 00:00:00.000000', '2024-06-07 00:00:00.000000', 3, 5, NULL),
(322, 1, '55000', 169, 'pcs', '2024-07-30 00:00:00.000000', '2024-07-30 00:00:00.000000', 3, 5, NULL),
(323, 1, '55000', 115, 'pcs', '2024-07-18 00:00:00.000000', '2024-07-18 00:00:00.000000', 3, 5, NULL),
(324, 1, '55000', 174, 'pcs', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 3, 5, NULL),
(325, 1, '55000', 191, 'pcs', '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 3, 5, NULL),
(326, 1, '55000', 230, 'pcs', '2024-07-07 00:00:00.000000', '2024-07-07 00:00:00.000000', 3, 5, NULL),
(327, 1, '55000', 125, 'pcs', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 3, 5, NULL),
(328, 1, '55000', 222, 'pcs', '2024-06-09 00:00:00.000000', '2024-06-09 00:00:00.000000', 3, 5, NULL),
(329, 1, '55000', 123, 'pcs', '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 3, 5, NULL),
(330, 1, '55000', 107, 'pcs', '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 3, 5, NULL),
(331, 1, '55000', 194, 'pcs', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 3, 5, NULL),
(332, 1, '55000', 293, 'pcs', '2024-06-12 00:00:00.000000', '2024-06-12 00:00:00.000000', 3, 5, NULL),
(333, 1, '55000', 129, 'pcs', '2024-06-06 00:00:00.000000', '2024-06-06 00:00:00.000000', 3, 5, NULL),
(334, 1, '55000', 114, 'pcs', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 3, 5, NULL),
(335, 1, '55000', 146, 'pcs', '2024-06-09 00:00:00.000000', '2024-06-09 00:00:00.000000', 3, 5, NULL),
(336, 1, '55000', 272, 'pcs', '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 3, 5, NULL),
(337, 1, '55000', 128, 'pcs', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 3, 5, NULL),
(338, 1, '55000', 217, 'pcs', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 3, 5, NULL),
(339, 1, '55000', 300, 'pcs', '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 3, 5, NULL),
(340, 1, '55000', 207, 'pcs', '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 3, 5, NULL),
(341, 1, '55000', 286, 'pcs', '2024-07-13 00:00:00.000000', '2024-07-13 00:00:00.000000', 3, 5, NULL),
(342, 1, '55000', 109, 'pcs', '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 3, 5, NULL),
(343, 1, '55000', 118, 'pcs', '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 3, 5, NULL),
(344, 1, '55000', 259, 'pcs', '2024-07-25 00:00:00.000000', '2024-07-25 00:00:00.000000', 3, 5, NULL),
(345, 1, '55000', 258, 'pcs', '2024-07-27 00:00:00.000000', '2024-07-27 00:00:00.000000', 3, 5, NULL),
(346, 1, '55000', 232, 'pcs', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 3, 5, NULL),
(347, 1, '55000', 134, 'pcs', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 3, 5, NULL),
(348, 1, '55000', 85, 'pcs', '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 3, 5, NULL),
(349, 1, '59500', 236, 'pcs', '2024-06-01 00:00:00.000000', '2024-06-01 00:00:00.000000', 4, 5, NULL),
(350, 1, '59500', 174, 'pcs', '2024-07-21 00:00:00.000000', '2024-07-21 00:00:00.000000', 4, 5, NULL),
(351, 1, '59500', 139, 'pcs', '2024-07-18 00:00:00.000000', '2024-07-18 00:00:00.000000', 4, 5, NULL),
(352, 1, '59500', 213, 'pcs', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 4, 5, NULL),
(353, 1, '59500', 203, 'pcs', '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 4, 5, NULL),
(354, 1, '59500', 274, 'pcs', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 4, 5, NULL),
(355, 1, '59500', 246, 'pcs', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 4, 5, NULL),
(356, 1, '59500', 263, 'pcs', '2024-07-12 00:00:00.000000', '2024-07-12 00:00:00.000000', 4, 5, NULL),
(357, 1, '59500', 181, 'pcs', '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 4, 5, NULL),
(358, 1, '59500', 240, 'pcs', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 4, 5, NULL),
(359, 1, '59500', 225, 'pcs', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 4, 5, NULL),
(360, 1, '59500', 255, 'pcs', '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 4, 5, NULL),
(361, 1, '59500', 196, 'pcs', '2024-07-30 00:00:00.000000', '2024-07-30 00:00:00.000000', 4, 5, NULL),
(362, 1, '59500', 273, 'pcs', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 4, 5, NULL),
(363, 1, '59500', 185, 'pcs', '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 4, 5, NULL),
(364, 1, '59500', 245, 'pcs', '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 4, 5, NULL),
(365, 1, '59500', 264, 'pcs', '2024-06-01 00:00:00.000000', '2024-06-01 00:00:00.000000', 4, 5, NULL),
(366, 1, '59500', 187, 'pcs', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 4, 5, NULL),
(367, 1, '59500', 246, 'pcs', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 4, 5, NULL),
(368, 1, '59500', 152, 'pcs', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 4, 5, NULL),
(369, 1, '59500', 162, 'pcs', '2024-07-29 00:00:00.000000', '2024-07-29 00:00:00.000000', 4, 5, NULL),
(370, 1, '59500', 143, 'pcs', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 4, 5, NULL),
(371, 1, '59500', 18, 'pcs', '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 4, 5, NULL),
(372, 1, '62500', 130, 'pcs', '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 5, 5, NULL),
(373, 1, '62500', 243, 'pcs', '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 5, 5, NULL),
(374, 1, '62500', 137, 'pcs', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 5, 5, NULL),
(375, 1, '62500', 280, 'pcs', '2024-07-14 00:00:00.000000', '2024-07-14 00:00:00.000000', 5, 5, NULL),
(376, 1, '62500', 160, 'pcs', '2024-07-07 00:00:00.000000', '2024-07-07 00:00:00.000000', 5, 5, NULL),
(377, 1, '62500', 109, 'pcs', '2024-06-17 00:00:00.000000', '2024-06-17 00:00:00.000000', 5, 5, NULL),
(378, 1, '62500', 183, 'pcs', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 5, 5, NULL),
(379, 1, '62500', 188, 'pcs', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 5, 5, NULL),
(380, 1, '62500', 130, 'pcs', '2024-06-13 00:00:00.000000', '2024-06-13 00:00:00.000000', 5, 5, NULL),
(381, 1, '62500', 237, 'pcs', '2024-07-13 00:00:00.000000', '2024-07-13 00:00:00.000000', 5, 5, NULL),
(382, 1, '62500', 153, 'pcs', '2024-07-27 00:00:00.000000', '2024-07-27 00:00:00.000000', 5, 5, NULL),
(383, 1, '62500', 208, 'pcs', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 5, 5, NULL),
(384, 1, '62500', 17, 'pcs', '2024-06-23 00:00:00.000000', '2024-06-23 00:00:00.000000', 5, 5, NULL),
(385, 1, '57000', 261, 'pcs', '2024-06-14 00:00:00.000000', '2024-06-14 00:00:00.000000', 1, 6, NULL),
(386, 1, '57000', 149, 'pcs', '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 1, 6, NULL),
(387, 1, '57000', 188, 'pcs', '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 1, 6, NULL),
(388, 1, '57000', 287, 'pcs', '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 1, 6, NULL),
(389, 1, '57000', 156, 'pcs', '2024-06-07 00:00:00.000000', '2024-06-07 00:00:00.000000', 1, 6, NULL),
(390, 1, '57000', 211, 'pcs', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 1, 6, NULL),
(391, 1, '57000', 273, 'pcs', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 1, 6, NULL),
(392, 1, '57000', 132, 'pcs', '2024-06-07 00:00:00.000000', '2024-06-07 00:00:00.000000', 1, 6, NULL),
(393, 1, '57000', 223, 'pcs', '2024-07-29 00:00:00.000000', '2024-07-29 00:00:00.000000', 1, 6, NULL),
(394, 1, '57000', 132, 'pcs', '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 1, 6, NULL),
(395, 1, '57000', 232, 'pcs', '2024-07-08 00:00:00.000000', '2024-07-08 00:00:00.000000', 1, 6, NULL),
(396, 1, '57000', 142, 'pcs', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 1, 6, NULL),
(397, 1, '57000', 272, 'pcs', '2024-07-06 00:00:00.000000', '2024-07-06 00:00:00.000000', 1, 6, NULL),
(398, 1, '57000', 298, 'pcs', '2024-07-27 00:00:00.000000', '2024-07-27 00:00:00.000000', 1, 6, NULL),
(399, 1, '57000', 286, 'pcs', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 1, 6, NULL),
(400, 1, '57000', 165, 'pcs', '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 1, 6, NULL),
(401, 1, '57000', 248, 'pcs', '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 1, 6, NULL),
(402, 1, '57000', 203, 'pcs', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 1, 6, NULL),
(403, 1, '57000', 126, 'pcs', '2024-06-12 00:00:00.000000', '2024-06-12 00:00:00.000000', 1, 6, NULL),
(404, 1, '57000', 162, 'pcs', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 1, 6, NULL),
(405, 1, '57000', 239, 'pcs', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 1, 6, NULL),
(406, 1, '57000', 279, 'pcs', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 1, 6, NULL),
(407, 1, '57000', 282, 'pcs', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 1, 6, NULL),
(408, 1, '57000', 171, 'pcs', '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 1, 6, NULL),
(409, 1, '57000', 286, 'pcs', '2024-06-12 00:00:00.000000', '2024-06-12 00:00:00.000000', 1, 6, NULL),
(410, 1, '57000', 270, 'pcs', '2024-06-28 00:00:00.000000', '2024-06-28 00:00:00.000000', 1, 6, NULL),
(411, 1, '57000', 294, 'pcs', '2024-07-03 00:00:00.000000', '2024-07-03 00:00:00.000000', 1, 6, NULL),
(412, 1, '57000', 298, 'pcs', '2024-06-30 00:00:00.000000', '2024-06-30 00:00:00.000000', 1, 6, NULL),
(413, 1, '57000', 292, 'pcs', '2024-07-08 00:00:00.000000', '2024-07-08 00:00:00.000000', 1, 6, NULL),
(414, 1, '57000', 108, 'pcs', '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 1, 6, NULL),
(415, 1, '57000', 225, 'pcs', '2024-07-19 00:00:00.000000', '2024-07-19 00:00:00.000000', 1, 6, NULL),
(416, 1, '57000', 188, 'pcs', '2024-07-16 00:00:00.000000', '2024-07-16 00:00:00.000000', 1, 6, NULL),
(417, 1, '57000', 125, 'pcs', '2024-06-04 00:00:00.000000', '2024-06-04 00:00:00.000000', 1, 6, NULL),
(418, 1, '57000', 161, 'pcs', '2024-07-16 00:00:00.000000', '2024-07-16 00:00:00.000000', 1, 6, NULL),
(419, 1, '57000', 226, 'pcs', '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 1, 6, NULL),
(420, 1, '57000', 289, 'pcs', '2024-07-30 00:00:00.000000', '2024-07-30 00:00:00.000000', 1, 6, NULL),
(421, 1, '57000', 219, 'pcs', '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 1, 6, NULL),
(422, 1, '57000', 155, 'pcs', '2024-07-29 00:00:00.000000', '2024-07-29 00:00:00.000000', 1, 6, NULL),
(423, 1, '57000', 244, 'pcs', '2024-06-30 00:00:00.000000', '2024-06-30 00:00:00.000000', 1, 6, NULL),
(424, 1, '57000', 131, 'pcs', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 1, 6, NULL),
(425, 1, '57000', 177, 'pcs', '2024-07-16 00:00:00.000000', '2024-07-16 00:00:00.000000', 1, 6, NULL),
(426, 1, '57000', 148, 'pcs', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 1, 6, NULL),
(427, 1, '57000', 251, 'pcs', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 1, 6, NULL),
(428, 1, '57000', 113, 'pcs', '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 1, 6, NULL),
(429, 1, '57000', 136, 'pcs', '2024-07-03 00:00:00.000000', '2024-07-03 00:00:00.000000', 1, 6, NULL),
(430, 1, '57000', 12, 'pcs', '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 1, 6, NULL),
(431, 1, '60500', 226, 'pcs', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 2, 6, NULL),
(432, 1, '60500', 194, 'pcs', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 2, 6, NULL),
(433, 1, '60500', 127, 'pcs', '2024-06-12 00:00:00.000000', '2024-06-12 00:00:00.000000', 2, 6, NULL),
(434, 1, '60500', 271, 'pcs', '2024-07-16 00:00:00.000000', '2024-07-16 00:00:00.000000', 2, 6, NULL),
(435, 1, '60500', 131, 'pcs', '2024-07-18 00:00:00.000000', '2024-07-18 00:00:00.000000', 2, 6, NULL),
(436, 1, '60500', 277, 'pcs', '2024-07-06 00:00:00.000000', '2024-07-06 00:00:00.000000', 2, 6, NULL),
(437, 1, '60500', 291, 'pcs', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 2, 6, NULL),
(438, 1, '60500', 140, 'pcs', '2024-06-19 00:00:00.000000', '2024-06-19 00:00:00.000000', 2, 6, NULL),
(439, 1, '60500', 220, 'pcs', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 2, 6, NULL),
(440, 1, '60500', 228, 'pcs', '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 2, 6, NULL),
(441, 1, '60500', 219, 'pcs', '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 2, 6, NULL),
(442, 1, '60500', 135, 'pcs', '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 2, 6, NULL),
(443, 1, '60500', 134, 'pcs', '2024-06-05 00:00:00.000000', '2024-06-05 00:00:00.000000', 2, 6, NULL),
(444, 1, '60500', 174, 'pcs', '2024-06-05 00:00:00.000000', '2024-06-05 00:00:00.000000', 2, 6, NULL),
(445, 1, '60500', 270, 'pcs', '2024-07-19 00:00:00.000000', '2024-07-19 00:00:00.000000', 2, 6, NULL),
(446, 1, '60500', 107, 'pcs', '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 2, 6, NULL),
(447, 1, '60500', 186, 'pcs', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 2, 6, NULL),
(448, 1, '60500', 155, 'pcs', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 2, 6, NULL),
(449, 1, '60500', 160, 'pcs', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 2, 6, NULL),
(450, 1, '60500', 258, 'pcs', '2024-07-16 00:00:00.000000', '2024-07-16 00:00:00.000000', 2, 6, NULL),
(451, 1, '60500', 268, 'pcs', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 2, 6, NULL),
(452, 1, '60500', 293, 'pcs', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 2, 6, NULL),
(453, 1, '60500', 182, 'pcs', '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 2, 6, NULL),
(454, 1, '60500', 124, 'pcs', '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 2, 6, NULL),
(455, 1, '60500', 223, 'pcs', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 2, 6, NULL),
(456, 1, '60500', 112, 'pcs', '2024-07-13 00:00:00.000000', '2024-07-13 00:00:00.000000', 2, 6, NULL),
(457, 1, '60500', 121, 'pcs', '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 2, 6, NULL),
(458, 1, '60500', 259, 'pcs', '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 2, 6, NULL),
(459, 1, '60500', 178, 'pcs', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 2, 6, NULL),
(460, 1, '60500', 147, 'pcs', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 2, 6, NULL),
(461, 1, '60500', 205, 'pcs', '2024-07-29 00:00:00.000000', '2024-07-29 00:00:00.000000', 2, 6, NULL),
(462, 1, '60500', 276, 'pcs', '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 2, 6, NULL),
(463, 1, '60500', 133, 'pcs', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 2, 6, NULL),
(464, 1, '60500', 244, 'pcs', '2024-06-19 00:00:00.000000', '2024-06-19 00:00:00.000000', 2, 6, NULL),
(465, 1, '60500', 165, 'pcs', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 2, 6, NULL),
(466, 1, '60500', 137, 'pcs', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 2, 6, NULL),
(467, 1, '60500', 165, 'pcs', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 2, 6, NULL),
(468, 1, '60500', 108, 'pcs', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 2, 6, NULL),
(469, 1, '60500', 252, 'pcs', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 2, 6, NULL),
(470, 1, '60500', 250, 'pcs', '2024-07-26 00:00:00.000000', '2024-07-26 00:00:00.000000', 2, 6, NULL),
(471, 1, '60500', 276, 'pcs', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 2, 6, NULL),
(472, 1, '60500', 159, 'pcs', '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 2, 6, NULL),
(473, 1, '60500', 1, 'pcs', '2024-07-21 00:00:00.000000', '2024-07-21 00:00:00.000000', 2, 6, NULL),
(474, 1, '55000', 174, 'pcs', '2024-07-06 00:00:00.000000', '2024-07-06 00:00:00.000000', 3, 6, NULL),
(475, 1, '55000', 267, 'pcs', '2024-07-03 00:00:00.000000', '2024-07-03 00:00:00.000000', 3, 6, NULL),
(476, 1, '55000', 217, 'pcs', '2024-06-07 00:00:00.000000', '2024-06-07 00:00:00.000000', 3, 6, NULL),
(477, 1, '55000', 113, 'pcs', '2024-07-30 00:00:00.000000', '2024-07-30 00:00:00.000000', 3, 6, NULL),
(478, 1, '55000', 278, 'pcs', '2024-07-14 00:00:00.000000', '2024-07-14 00:00:00.000000', 3, 6, NULL),
(479, 1, '55000', 222, 'pcs', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 3, 6, NULL),
(480, 1, '55000', 115, 'pcs', '2024-06-14 00:00:00.000000', '2024-06-14 00:00:00.000000', 3, 6, NULL),
(481, 1, '55000', 289, 'pcs', '2024-06-14 00:00:00.000000', '2024-06-14 00:00:00.000000', 3, 6, NULL),
(482, 1, '55000', 153, 'pcs', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 3, 6, NULL),
(483, 1, '55000', 157, 'pcs', '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 3, 6, NULL),
(484, 1, '59500', 217, 'pcs', '2024-07-23 00:00:00.000000', '2024-07-23 00:00:00.000000', 4, 6, NULL),
(485, 1, '59500', 222, 'pcs', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 4, 6, NULL),
(486, 1, '59500', 191, 'pcs', '2024-06-05 00:00:00.000000', '2024-06-05 00:00:00.000000', 4, 6, NULL),
(487, 1, '59500', 237, 'pcs', '2024-06-12 00:00:00.000000', '2024-06-12 00:00:00.000000', 4, 6, NULL),
(488, 1, '59500', 186, 'pcs', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 4, 6, NULL),
(489, 1, '59500', 207, 'pcs', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 4, 6, NULL),
(490, 1, '59500', 134, 'pcs', '2024-06-14 00:00:00.000000', '2024-06-14 00:00:00.000000', 4, 6, NULL),
(491, 1, '59500', 187, 'pcs', '2024-06-23 00:00:00.000000', '2024-06-23 00:00:00.000000', 4, 6, NULL),
(492, 1, '59500', 291, 'pcs', '2024-06-30 00:00:00.000000', '2024-06-30 00:00:00.000000', 4, 6, NULL),
(493, 1, '59500', 102, 'pcs', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 4, 6, NULL),
(494, 1, '59500', 289, 'pcs', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 4, 6, NULL),
(495, 1, '59500', 165, 'pcs', '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 4, 6, NULL),
(496, 1, '59500', 291, 'pcs', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 4, 6, NULL),
(497, 1, '59500', 280, 'pcs', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 4, 6, NULL),
(498, 1, '59500', 230, 'pcs', '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 4, 6, NULL),
(499, 1, '62500', 291, 'pcs', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 5, 6, NULL),
(500, 1, '62500', 117, 'pcs', '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 5, 6, NULL),
(501, 1, '62500', 186, 'pcs', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 5, 6, NULL),
(502, 1, '62500', 175, 'pcs', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 5, 6, NULL);
INSERT INTO `sales` (`id`, `user_id`, `price`, `amount`, `unit`, `created_at`, `updated_at`, `item_id`, `outlet_id`, `buyer_id`) VALUES
(503, 1, '62500', 200, 'pcs', '2024-07-23 00:00:00.000000', '2024-07-23 00:00:00.000000', 5, 6, NULL),
(504, 1, '62500', 232, 'pcs', '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 5, 6, NULL),
(505, 1, '62500', 122, 'pcs', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 5, 6, NULL),
(506, 1, '62500', 189, 'pcs', '2024-06-14 00:00:00.000000', '2024-06-14 00:00:00.000000', 5, 6, NULL),
(507, 1, '62500', 135, 'pcs', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 5, 6, NULL),
(508, 1, '62500', 258, 'pcs', '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 5, 6, NULL),
(509, 1, '62500', 121, 'pcs', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 5, 6, NULL),
(510, 1, '62500', 199, 'pcs', '2024-06-09 00:00:00.000000', '2024-06-09 00:00:00.000000', 5, 6, NULL),
(511, 1, '62500', 119, 'pcs', '2024-06-12 00:00:00.000000', '2024-06-12 00:00:00.000000', 5, 6, NULL),
(512, 1, '62500', 217, 'pcs', '2024-06-20 00:00:00.000000', '2024-06-20 00:00:00.000000', 5, 6, NULL),
(513, 1, '62500', 127, 'pcs', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 5, 6, NULL),
(514, 1, '62500', 253, 'pcs', '2024-06-23 00:00:00.000000', '2024-06-23 00:00:00.000000', 5, 6, NULL),
(515, 1, '62500', 118, 'pcs', '2024-07-06 00:00:00.000000', '2024-07-06 00:00:00.000000', 5, 6, NULL),
(516, 1, '62500', 205, 'pcs', '2024-06-04 00:00:00.000000', '2024-06-04 00:00:00.000000', 5, 6, NULL),
(517, 1, '62500', 109, 'pcs', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 5, 6, NULL),
(518, 1, '62500', 253, 'pcs', '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 5, 6, NULL),
(519, 1, '62500', 149, 'pcs', '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 5, 6, NULL),
(520, 1, '62500', 235, 'pcs', '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 5, 6, NULL),
(521, 1, '62500', 183, 'pcs', '2024-07-29 00:00:00.000000', '2024-07-29 00:00:00.000000', 5, 6, NULL),
(522, 1, '62500', 204, 'pcs', '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 5, 6, NULL),
(523, 1, '62500', 214, 'pcs', '2024-06-12 00:00:00.000000', '2024-06-12 00:00:00.000000', 5, 6, NULL),
(524, 1, '62500', 110, 'pcs', '2024-07-13 00:00:00.000000', '2024-07-13 00:00:00.000000', 5, 6, NULL),
(525, 1, '62500', 117, 'pcs', '2024-06-04 00:00:00.000000', '2024-06-04 00:00:00.000000', 5, 6, NULL),
(526, 1, '62500', 236, 'pcs', '2024-07-21 00:00:00.000000', '2024-07-21 00:00:00.000000', 5, 6, NULL),
(527, 1, '62500', 284, 'pcs', '2024-06-07 00:00:00.000000', '2024-06-07 00:00:00.000000', 5, 6, NULL),
(528, 1, '62500', 248, 'pcs', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 5, 6, NULL),
(529, 1, '62500', 243, 'pcs', '2024-06-17 00:00:00.000000', '2024-06-17 00:00:00.000000', 5, 6, NULL),
(530, 1, '62500', 273, 'pcs', '2024-07-23 00:00:00.000000', '2024-07-23 00:00:00.000000', 5, 6, NULL),
(531, 1, '62500', 270, 'pcs', '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 5, 6, NULL),
(532, 1, '62500', 135, 'pcs', '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 5, 6, NULL),
(533, 1, '57000', 127, 'pcs', '2024-07-29 00:00:00.000000', '2024-07-29 00:00:00.000000', 1, 7, NULL),
(534, 1, '57000', 157, 'pcs', '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 1, 7, NULL),
(535, 1, '57000', 188, 'pcs', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 1, 7, NULL),
(536, 1, '57000', 169, 'pcs', '2024-07-13 00:00:00.000000', '2024-07-13 00:00:00.000000', 1, 7, NULL),
(537, 1, '57000', 233, 'pcs', '2024-07-14 00:00:00.000000', '2024-07-14 00:00:00.000000', 1, 7, NULL),
(538, 1, '57000', 263, 'pcs', '2024-06-09 00:00:00.000000', '2024-06-09 00:00:00.000000', 1, 7, NULL),
(539, 1, '57000', 144, 'pcs', '2024-06-13 00:00:00.000000', '2024-06-13 00:00:00.000000', 1, 7, NULL),
(540, 1, '57000', 211, 'pcs', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 1, 7, NULL),
(541, 1, '57000', 298, 'pcs', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 1, 7, NULL),
(542, 1, '57000', 272, 'pcs', '2024-06-30 00:00:00.000000', '2024-06-30 00:00:00.000000', 1, 7, NULL),
(543, 1, '57000', 192, 'pcs', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 1, 7, NULL),
(544, 1, '57000', 141, 'pcs', '2024-07-14 00:00:00.000000', '2024-07-14 00:00:00.000000', 1, 7, NULL),
(545, 1, '57000', 215, 'pcs', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 1, 7, NULL),
(546, 1, '57000', 29, 'pcs', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 1, 7, NULL),
(547, 1, '60500', 246, 'pcs', '2024-07-18 00:00:00.000000', '2024-07-18 00:00:00.000000', 2, 7, NULL),
(548, 1, '60500', 233, 'pcs', '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 2, 7, NULL),
(549, 1, '60500', 268, 'pcs', '2024-06-30 00:00:00.000000', '2024-06-30 00:00:00.000000', 2, 7, NULL),
(550, 1, '60500', 127, 'pcs', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 2, 7, NULL),
(551, 1, '60500', 247, 'pcs', '2024-06-14 00:00:00.000000', '2024-06-14 00:00:00.000000', 2, 7, NULL),
(552, 1, '60500', 113, 'pcs', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 2, 7, NULL),
(553, 1, '60500', 120, 'pcs', '2024-07-27 00:00:00.000000', '2024-07-27 00:00:00.000000', 2, 7, NULL),
(554, 1, '60500', 205, 'pcs', '2024-06-23 00:00:00.000000', '2024-06-23 00:00:00.000000', 2, 7, NULL),
(555, 1, '60500', 210, 'pcs', '2024-07-13 00:00:00.000000', '2024-07-13 00:00:00.000000', 2, 7, NULL),
(556, 1, '60500', 196, 'pcs', '2024-06-06 00:00:00.000000', '2024-06-06 00:00:00.000000', 2, 7, NULL),
(557, 1, '60500', 112, 'pcs', '2024-07-07 00:00:00.000000', '2024-07-07 00:00:00.000000', 2, 7, NULL),
(558, 1, '60500', 237, 'pcs', '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 2, 7, NULL),
(559, 1, '60500', 141, 'pcs', '2024-07-16 00:00:00.000000', '2024-07-16 00:00:00.000000', 2, 7, NULL),
(560, 1, '60500', 287, 'pcs', '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 2, 7, NULL),
(561, 1, '60500', 179, 'pcs', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 2, 7, NULL),
(562, 1, '60500', 219, 'pcs', '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 2, 7, NULL),
(563, 1, '60500', 191, 'pcs', '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 2, 7, NULL),
(564, 1, '60500', 164, 'pcs', '2024-06-14 00:00:00.000000', '2024-06-14 00:00:00.000000', 2, 7, NULL),
(565, 1, '60500', 177, 'pcs', '2024-06-19 00:00:00.000000', '2024-06-19 00:00:00.000000', 2, 7, NULL),
(566, 1, '60500', 147, 'pcs', '2024-07-08 00:00:00.000000', '2024-07-08 00:00:00.000000', 2, 7, NULL),
(567, 1, '60500', 246, 'pcs', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 2, 7, NULL),
(568, 1, '60500', 109, 'pcs', '2024-07-31 00:00:00.000000', '2024-07-31 00:00:00.000000', 2, 7, NULL),
(569, 1, '60500', 241, 'pcs', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 2, 7, NULL),
(570, 1, '60500', 192, 'pcs', '2024-06-01 00:00:00.000000', '2024-06-01 00:00:00.000000', 2, 7, NULL),
(571, 1, '60500', 264, 'pcs', '2024-07-18 00:00:00.000000', '2024-07-18 00:00:00.000000', 2, 7, NULL),
(572, 1, '60500', 172, 'pcs', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 2, 7, NULL),
(573, 1, '60500', 249, 'pcs', '2024-06-09 00:00:00.000000', '2024-06-09 00:00:00.000000', 2, 7, NULL),
(574, 1, '60500', 239, 'pcs', '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 2, 7, NULL),
(575, 1, '60500', 185, 'pcs', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 2, 7, NULL),
(576, 1, '60500', 212, 'pcs', '2024-06-30 00:00:00.000000', '2024-06-30 00:00:00.000000', 2, 7, NULL),
(577, 1, '60500', 143, 'pcs', '2024-07-21 00:00:00.000000', '2024-07-21 00:00:00.000000', 2, 7, NULL),
(578, 1, '60500', 240, 'pcs', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 2, 7, NULL),
(579, 1, '60500', 246, 'pcs', '2024-06-06 00:00:00.000000', '2024-06-06 00:00:00.000000', 2, 7, NULL),
(580, 1, '60500', 124, 'pcs', '2024-07-13 00:00:00.000000', '2024-07-13 00:00:00.000000', 2, 7, NULL),
(581, 1, '60500', 101, 'pcs', '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 2, 7, NULL),
(582, 1, '60500', 268, 'pcs', '2024-06-13 00:00:00.000000', '2024-06-13 00:00:00.000000', 2, 7, NULL),
(583, 1, '60500', 251, 'pcs', '2024-06-20 00:00:00.000000', '2024-06-20 00:00:00.000000', 2, 7, NULL),
(584, 1, '60500', 56, 'pcs', '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 2, 7, NULL),
(585, 1, '55000', 237, 'pcs', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 3, 7, NULL),
(586, 1, '55000', 284, 'pcs', '2024-07-21 00:00:00.000000', '2024-07-21 00:00:00.000000', 3, 7, NULL),
(587, 1, '55000', 149, 'pcs', '2024-07-21 00:00:00.000000', '2024-07-21 00:00:00.000000', 3, 7, NULL),
(588, 1, '55000', 276, 'pcs', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 3, 7, NULL),
(589, 1, '55000', 253, 'pcs', '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 3, 7, NULL),
(590, 1, '55000', 120, 'pcs', '2024-07-03 00:00:00.000000', '2024-07-03 00:00:00.000000', 3, 7, NULL),
(591, 1, '55000', 184, 'pcs', '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 3, 7, NULL),
(592, 1, '55000', 126, 'pcs', '2024-07-13 00:00:00.000000', '2024-07-13 00:00:00.000000', 3, 7, NULL),
(593, 1, '55000', 101, 'pcs', '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 3, 7, NULL),
(594, 1, '55000', 244, 'pcs', '2024-06-28 00:00:00.000000', '2024-06-28 00:00:00.000000', 3, 7, NULL),
(595, 1, '55000', 104, 'pcs', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 3, 7, NULL),
(596, 1, '55000', 159, 'pcs', '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 3, 7, NULL),
(597, 1, '55000', 209, 'pcs', '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 3, 7, NULL),
(598, 1, '55000', 201, 'pcs', '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 3, 7, NULL),
(599, 1, '55000', 180, 'pcs', '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 3, 7, NULL),
(600, 1, '55000', 220, 'pcs', '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 3, 7, NULL),
(601, 1, '55000', 161, 'pcs', '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 3, 7, NULL),
(602, 1, '55000', 197, 'pcs', '2024-07-12 00:00:00.000000', '2024-07-12 00:00:00.000000', 3, 7, NULL),
(603, 1, '55000', 123, 'pcs', '2024-07-31 00:00:00.000000', '2024-07-31 00:00:00.000000', 3, 7, NULL),
(604, 1, '55000', 241, 'pcs', '2024-07-14 00:00:00.000000', '2024-07-14 00:00:00.000000', 3, 7, NULL),
(605, 1, '55000', 117, 'pcs', '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 3, 7, NULL),
(606, 1, '55000', 250, 'pcs', '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 3, 7, NULL),
(607, 1, '55000', 249, 'pcs', '2024-07-16 00:00:00.000000', '2024-07-16 00:00:00.000000', 3, 7, NULL),
(608, 1, '55000', 297, 'pcs', '2024-07-12 00:00:00.000000', '2024-07-12 00:00:00.000000', 3, 7, NULL),
(609, 1, '55000', 226, 'pcs', '2024-07-08 00:00:00.000000', '2024-07-08 00:00:00.000000', 3, 7, NULL),
(610, 1, '55000', 167, 'pcs', '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 3, 7, NULL),
(611, 1, '55000', 187, 'pcs', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 3, 7, NULL),
(612, 1, '55000', 273, 'pcs', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 3, 7, NULL),
(613, 1, '55000', 228, 'pcs', '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 3, 7, NULL),
(614, 1, '55000', 296, 'pcs', '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 3, 7, NULL),
(615, 1, '55000', 45, 'pcs', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 3, 7, NULL),
(616, 1, '59500', 113, 'pcs', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 4, 7, NULL),
(617, 1, '59500', 258, 'pcs', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 4, 7, NULL),
(618, 1, '59500', 295, 'pcs', '2024-07-14 00:00:00.000000', '2024-07-14 00:00:00.000000', 4, 7, NULL),
(619, 1, '59500', 105, 'pcs', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 4, 7, NULL),
(620, 1, '59500', 160, 'pcs', '2024-06-06 00:00:00.000000', '2024-06-06 00:00:00.000000', 4, 7, NULL),
(621, 1, '59500', 295, 'pcs', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 4, 7, NULL),
(622, 1, '59500', 153, 'pcs', '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 4, 7, NULL),
(623, 1, '59500', 254, 'pcs', '2024-06-30 00:00:00.000000', '2024-06-30 00:00:00.000000', 4, 7, NULL),
(624, 1, '59500', 162, 'pcs', '2024-06-06 00:00:00.000000', '2024-06-06 00:00:00.000000', 4, 7, NULL),
(625, 1, '59500', 243, 'pcs', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 4, 7, NULL),
(626, 1, '59500', 13, 'pcs', '2024-07-21 00:00:00.000000', '2024-07-21 00:00:00.000000', 4, 7, NULL),
(627, 1, '62500', 237, 'pcs', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 5, 7, NULL),
(628, 1, '62500', 61, 'pcs', '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 5, 7, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `stocks`
--

CREATE TABLE `stocks` (
  `id` bigint NOT NULL,
  `amount` int NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `item_id` bigint NOT NULL,
  `outlet_id` bigint NOT NULL,
  `user_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stocks`
--

INSERT INTO `stocks` (`id`, `amount`, `created_at`, `updated_at`, `item_id`, `outlet_id`, `user_id`) VALUES
(4, 147, '2024-12-21 18:02:12.000000', '2025-01-18 13:43:54.995660', 1, 3, NULL),
(5, 0, '2024-12-21 18:02:25.000000', '2024-12-21 18:02:25.000000', 1, 6, NULL),
(6, 0, '2024-12-21 18:02:35.000000', '2024-12-21 18:02:35.000000', 1, 7, NULL),
(7, 0, '2024-12-21 18:02:48.000000', '2024-12-21 18:02:48.000000', 1, 5, NULL),
(8, 56, '2024-12-21 18:02:58.000000', '2024-12-21 18:02:58.000000', 2, 3, NULL),
(9, 0, '2024-12-21 18:03:08.000000', '2024-12-21 18:03:08.000000', 2, 6, NULL),
(10, 0, '2024-12-21 18:03:28.000000', '2024-12-21 18:03:28.000000', 2, 7, NULL),
(11, 0, '2024-12-21 18:03:38.000000', '2024-12-21 18:03:38.000000', 2, 5, NULL),
(12, 83, '2024-12-21 18:03:49.000000', '2024-12-21 18:03:49.000000', 3, 3, NULL),
(13, 0, '2024-12-21 18:04:10.000000', '2024-12-21 18:04:10.000000', 3, 6, NULL),
(14, 0, '2024-12-21 18:04:28.000000', '2024-12-21 18:04:28.000000', 3, 7, NULL),
(15, 0, '2024-12-21 18:04:38.000000', '2024-12-21 18:04:38.000000', 3, 5, NULL),
(16, 2842, '2024-12-21 18:04:52.000000', '2024-12-21 18:04:52.000000', 4, 3, NULL),
(17, 0, '2024-12-21 18:05:01.000000', '2024-12-21 18:05:01.000000', 4, 6, NULL),
(18, 0, '2024-12-21 18:05:11.000000', '2024-12-21 18:05:11.000000', 4, 7, NULL),
(19, 0, '2024-12-21 18:05:25.000000', '2024-12-21 18:05:25.000000', 4, 5, NULL),
(20, 263, '2024-12-21 18:05:41.000000', '2024-12-21 18:05:41.000000', 5, 3, NULL),
(21, 0, '2024-12-21 18:05:52.000000', '2024-12-21 18:05:52.000000', 5, 6, NULL),
(22, 0, '2024-12-21 18:06:21.000000', '2024-12-21 18:06:21.000000', 5, 7, NULL),
(23, 0, '2024-12-21 18:06:32.000000', '2024-12-21 18:06:32.000000', 5, 5, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` bigint NOT NULL,
  `user_id` int NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `item_id` bigint NOT NULL,
  `outlet_id` bigint NOT NULL,
  `purchase_id` bigint DEFAULT NULL,
  `sales_id` bigint DEFAULT NULL,
  `stock` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`id`, `user_id`, `type`, `created_at`, `updated_at`, `item_id`, `outlet_id`, `purchase_id`, `sales_id`, `stock`) VALUES
(1, 1, 'sales', '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 1, 3, NULL, 1, 5000),
(2, 1, 'sales', '2024-06-01 00:00:00.000000', '2024-06-01 00:00:00.000000', 1, 3, NULL, 2, 4886),
(3, 1, 'sales', '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 1, 3, NULL, 3, 4779),
(4, 1, 'sales', '2024-06-05 00:00:00.000000', '2024-06-05 00:00:00.000000', 1, 3, NULL, 4, 4662),
(5, 1, 'sales', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 1, 3, NULL, 5, 4352),
(6, 1, 'sales', '2024-06-07 00:00:00.000000', '2024-06-07 00:00:00.000000', 1, 3, NULL, 6, 4104),
(7, 1, 'sales', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 1, 3, NULL, 7, 3864),
(8, 1, 'sales', '2024-07-25 00:00:00.000000', '2024-07-25 00:00:00.000000', 1, 3, NULL, 8, 3602),
(9, 1, 'sales', '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 1, 3, NULL, 9, 3261),
(10, 1, 'sales', '2024-07-26 00:00:00.000000', '2024-07-26 00:00:00.000000', 1, 3, NULL, 10, 3094),
(11, 1, 'sales', '2024-06-17 00:00:00.000000', '2024-06-17 00:00:00.000000', 1, 3, NULL, 11, 2831),
(12, 1, 'sales', '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 1, 3, NULL, 12, 2528),
(13, 1, 'sales', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 1, 3, NULL, 13, 2294),
(14, 1, 'sales', '2024-07-25 00:00:00.000000', '2024-07-25 00:00:00.000000', 1, 3, NULL, 14, 2011),
(15, 1, 'sales', '2024-07-21 00:00:00.000000', '2024-07-21 00:00:00.000000', 1, 3, NULL, 15, 1748),
(16, 1, 'sales', '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 1, 3, NULL, 16, 1495),
(17, 1, 'sales', '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 1, 3, NULL, 17, 1380),
(18, 1, 'sales', '2024-07-18 00:00:00.000000', '2024-07-18 00:00:00.000000', 1, 3, NULL, 18, 1065),
(19, 1, 'sales', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 1, 3, NULL, 19, 580),
(20, 1, 'sales', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 1, 3, NULL, 20, 5201),
(21, 1, 'sales', '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 1, 3, NULL, 21, 4785),
(22, 1, 'sales', '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 1, 3, NULL, 22, 4579),
(23, 1, 'sales', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 1, 3, NULL, 23, 4157),
(24, 1, 'sales', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 2, 3, NULL, 24, 5000),
(25, 1, 'sales', '2024-07-03 00:00:00.000000', '2024-07-03 00:00:00.000000', 2, 3, NULL, 25, 4892),
(26, 1, 'sales', '2024-06-17 00:00:00.000000', '2024-06-17 00:00:00.000000', 2, 3, NULL, 26, 4731),
(27, 1, 'sales', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 2, 3, NULL, 27, 4504),
(28, 1, 'sales', '2024-07-26 00:00:00.000000', '2024-07-26 00:00:00.000000', 2, 3, NULL, 28, 4261),
(29, 1, 'sales', '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 2, 3, NULL, 29, 4126),
(30, 1, 'sales', '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 2, 3, NULL, 30, 3684),
(31, 1, 'sales', '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 2, 3, NULL, 31, 3500),
(32, 1, 'sales', '2024-07-18 00:00:00.000000', '2024-07-18 00:00:00.000000', 2, 3, NULL, 32, 3341),
(33, 1, 'sales', '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 2, 3, NULL, 33, 3082),
(34, 1, 'sales', '2024-07-07 00:00:00.000000', '2024-07-07 00:00:00.000000', 2, 3, NULL, 34, 2618),
(35, 1, 'sales', '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 2, 3, NULL, 35, 2433),
(36, 1, 'sales', '2024-06-20 00:00:00.000000', '2024-06-20 00:00:00.000000', 2, 3, NULL, 36, 1943),
(37, 1, 'sales', '2024-06-30 00:00:00.000000', '2024-06-30 00:00:00.000000', 2, 3, NULL, 37, 1522),
(38, 1, 'sales', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 2, 3, NULL, 38, 1270),
(39, 1, 'sales', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 2, 3, NULL, 39, 1077),
(40, 1, 'sales', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 2, 3, NULL, 40, 702),
(41, 1, 'sales', '2024-07-21 00:00:00.000000', '2024-07-21 00:00:00.000000', 3, 3, NULL, 41, 5000),
(42, 1, 'sales', '2024-07-07 00:00:00.000000', '2024-07-07 00:00:00.000000', 3, 3, NULL, 42, 4849),
(43, 1, 'sales', '2024-07-07 00:00:00.000000', '2024-07-07 00:00:00.000000', 3, 3, NULL, 43, 4624),
(44, 1, 'sales', '2024-07-03 00:00:00.000000', '2024-07-03 00:00:00.000000', 3, 3, NULL, 44, 4310),
(45, 1, 'sales', '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 3, 3, NULL, 45, 4039),
(46, 1, 'sales', '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 3, 3, NULL, 46, 3731),
(47, 1, 'sales', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 3, 3, NULL, 47, 3361),
(48, 1, 'sales', '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 3, 3, NULL, 48, 3238),
(49, 1, 'sales', '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 3, 3, NULL, 49, 3070),
(50, 1, 'sales', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 3, 3, NULL, 50, 2839),
(51, 1, 'sales', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 3, 3, NULL, 51, 2348),
(52, 1, 'sales', '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 3, 3, NULL, 52, 2147),
(53, 1, 'sales', '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 3, 3, NULL, 53, 2047),
(54, 1, 'sales', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 3, 3, NULL, 54, 1916),
(55, 1, 'sales', '2024-07-14 00:00:00.000000', '2024-07-14 00:00:00.000000', 3, 3, NULL, 55, 1523),
(56, 1, 'sales', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 3, 3, NULL, 56, 1303),
(57, 1, 'sales', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 3, 3, NULL, 57, 1025),
(58, 1, 'sales', '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 3, 3, NULL, 58, 546),
(59, 1, 'sales', '2024-07-30 00:00:00.000000', '2024-07-30 00:00:00.000000', 3, 3, NULL, 59, 5304),
(60, 1, 'sales', '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 3, 3, NULL, 60, 4907),
(61, 1, 'sales', '2024-07-18 00:00:00.000000', '2024-07-18 00:00:00.000000', 3, 3, NULL, 61, 4632),
(62, 1, 'sales', '2024-06-19 00:00:00.000000', '2024-06-19 00:00:00.000000', 3, 3, NULL, 62, 4368),
(63, 1, 'sales', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 3, 3, NULL, 63, 4005),
(64, 1, 'sales', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 3, 3, NULL, 64, 3859),
(65, 1, 'sales', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 3, 3, NULL, 65, 3477),
(66, 1, 'sales', '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 4, 3, NULL, 66, 5000),
(67, 1, 'sales', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 4, 3, NULL, 67, 4784),
(68, 1, 'sales', '2024-06-13 00:00:00.000000', '2024-06-13 00:00:00.000000', 4, 3, NULL, 68, 4601),
(69, 1, 'sales', '2024-06-23 00:00:00.000000', '2024-06-23 00:00:00.000000', 4, 3, NULL, 69, 4459),
(70, 1, 'sales', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 4, 3, NULL, 70, 4005),
(71, 1, 'sales', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 4, 3, NULL, 71, 3618),
(72, 1, 'sales', '2024-06-30 00:00:00.000000', '2024-06-30 00:00:00.000000', 4, 3, NULL, 72, 3146),
(73, 1, 'sales', '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 4, 3, NULL, 73, 2907),
(74, 1, 'sales', '2024-06-01 00:00:00.000000', '2024-06-01 00:00:00.000000', 4, 3, NULL, 74, 2665),
(75, 1, 'sales', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 4, 3, NULL, 75, 2315),
(76, 1, 'sales', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 4, 3, NULL, 76, 2032),
(77, 1, 'sales', '2024-07-30 00:00:00.000000', '2024-07-30 00:00:00.000000', 4, 3, NULL, 77, 1853),
(78, 1, 'sales', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 4, 3, NULL, 78, 1619),
(79, 1, 'sales', '2024-06-13 00:00:00.000000', '2024-06-13 00:00:00.000000', 4, 3, NULL, 79, 1419),
(80, 1, 'sales', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 4, 3, NULL, 80, 1155),
(81, 1, 'sales', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 4, 3, NULL, 81, 940),
(82, 1, 'sales', '2024-07-31 00:00:00.000000', '2024-07-31 00:00:00.000000', 4, 3, NULL, 82, 675),
(83, 1, 'sales', '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 5, 3, NULL, 83, 5000),
(84, 1, 'sales', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 5, 3, NULL, 84, 4651),
(85, 1, 'sales', '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 5, 3, NULL, 85, 4547),
(86, 1, 'sales', '2024-06-20 00:00:00.000000', '2024-06-20 00:00:00.000000', 5, 3, NULL, 86, 4336),
(87, 1, 'sales', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 5, 3, NULL, 87, 3927),
(88, 1, 'sales', '2024-06-17 00:00:00.000000', '2024-06-17 00:00:00.000000', 5, 3, NULL, 88, 3578),
(89, 1, 'sales', '2024-06-12 00:00:00.000000', '2024-06-12 00:00:00.000000', 5, 3, NULL, 89, 3399),
(90, 1, 'sales', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 5, 3, NULL, 90, 3267),
(91, 1, 'sales', '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 5, 3, NULL, 91, 2929),
(92, 1, 'sales', '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 1, 3, NULL, 92, 4104),
(93, 1, 'sales', '2024-07-06 00:00:00.000000', '2024-07-06 00:00:00.000000', 1, 3, NULL, 93, 3815),
(94, 1, 'sales', '2024-06-13 00:00:00.000000', '2024-06-13 00:00:00.000000', 1, 3, NULL, 94, 3633),
(95, 1, 'sales', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 1, 3, NULL, 95, 3525),
(96, 1, 'sales', '2024-06-09 00:00:00.000000', '2024-06-09 00:00:00.000000', 1, 3, NULL, 96, 3299),
(97, 1, 'sales', '2024-07-14 00:00:00.000000', '2024-07-14 00:00:00.000000', 1, 3, NULL, 97, 2875),
(98, 1, 'sales', '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 1, 3, NULL, 98, 2573),
(99, 1, 'sales', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 1, 3, NULL, 99, 2436),
(100, 1, 'sales', '2024-06-06 00:00:00.000000', '2024-06-06 00:00:00.000000', 1, 3, NULL, 100, 2274),
(101, 1, 'sales', '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 1, 3, NULL, 101, 1875),
(102, 1, 'sales', '2024-07-30 00:00:00.000000', '2024-07-30 00:00:00.000000', 1, 3, NULL, 102, 1439),
(103, 1, 'sales', '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 1, 3, NULL, 103, 1287),
(104, 1, 'sales', '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 1, 3, NULL, 104, 856),
(105, 1, 'sales', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 1, 3, NULL, 105, 596),
(106, 1, 'sales', '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 1, 3, NULL, 106, 432),
(107, 1, 'sales', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 1, 3, NULL, 107, 5247),
(108, 1, 'sales', '2024-06-19 00:00:00.000000', '2024-06-19 00:00:00.000000', 1, 3, NULL, 108, 4774),
(109, 1, 'sales', '2024-06-01 00:00:00.000000', '2024-06-01 00:00:00.000000', 1, 3, NULL, 109, 4514),
(110, 1, 'sales', '2024-07-16 00:00:00.000000', '2024-07-16 00:00:00.000000', 1, 3, NULL, 110, 4251),
(111, 1, 'sales', '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 1, 3, NULL, 111, 4062),
(112, 1, 'sales', '2024-06-07 00:00:00.000000', '2024-06-07 00:00:00.000000', 1, 3, NULL, 112, 3718),
(113, 1, 'sales', '2024-07-03 00:00:00.000000', '2024-07-03 00:00:00.000000', 1, 3, NULL, 113, 3289),
(114, 1, 'sales', '2024-06-20 00:00:00.000000', '2024-06-20 00:00:00.000000', 1, 3, NULL, 114, 3148),
(115, 1, 'sales', '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 1, 3, NULL, 115, 2908),
(116, 1, 'sales', '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 1, 3, NULL, 116, 2762),
(117, 1, 'sales', '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 1, 3, NULL, 117, 2341),
(118, 1, 'sales', '2024-06-06 00:00:00.000000', '2024-06-06 00:00:00.000000', 1, 3, NULL, 118, 2159),
(119, 1, 'sales', '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 1, 3, NULL, 119, 2044),
(120, 1, 'sales', '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 1, 3, NULL, 120, 1695),
(121, 1, 'sales', '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 1, 3, NULL, 121, 1449),
(122, 1, 'sales', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 1, 3, NULL, 122, 961),
(123, 1, 'sales', '2024-07-19 00:00:00.000000', '2024-07-19 00:00:00.000000', 1, 3, NULL, 123, 478),
(124, 1, 'sales', '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 1, 3, NULL, 124, 5204),
(125, 1, 'sales', '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 1, 3, NULL, 125, 4962),
(126, 1, 'sales', '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 1, 3, NULL, 126, 4694),
(127, 1, 'sales', '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 2, 3, NULL, 127, 538),
(128, 1, 'sales', '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 2, 3, NULL, 128, 5167),
(129, 1, 'sales', '2024-06-19 00:00:00.000000', '2024-06-19 00:00:00.000000', 2, 3, NULL, 129, 4689),
(130, 1, 'sales', '2024-07-07 00:00:00.000000', '2024-07-07 00:00:00.000000', 2, 3, NULL, 130, 4514),
(131, 1, 'sales', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 2, 3, NULL, 131, 4296),
(132, 1, 'sales', '2024-07-12 00:00:00.000000', '2024-07-12 00:00:00.000000', 2, 3, NULL, 132, 3861),
(133, 1, 'sales', '2024-06-19 00:00:00.000000', '2024-06-19 00:00:00.000000', 2, 3, NULL, 133, 3503),
(134, 1, 'sales', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 2, 3, NULL, 134, 3384),
(135, 1, 'sales', '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 2, 3, NULL, 135, 3142),
(136, 1, 'sales', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 2, 3, NULL, 136, 2764),
(137, 1, 'sales', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 2, 3, NULL, 137, 2410),
(138, 1, 'sales', '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 2, 3, NULL, 138, 2220),
(139, 1, 'sales', '2024-06-13 00:00:00.000000', '2024-06-13 00:00:00.000000', 2, 3, NULL, 139, 1781),
(140, 1, 'sales', '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 2, 3, NULL, 140, 1387),
(141, 1, 'sales', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 2, 3, NULL, 141, 1079),
(142, 1, 'sales', '2024-07-27 00:00:00.000000', '2024-07-27 00:00:00.000000', 2, 3, NULL, 142, 935),
(143, 1, 'sales', '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 2, 3, NULL, 143, 584),
(144, 1, 'sales', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 2, 3, NULL, 144, 446),
(145, 1, 'sales', '2024-07-08 00:00:00.000000', '2024-07-08 00:00:00.000000', 2, 3, NULL, 145, 261),
(146, 1, 'sales', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 2, 3, NULL, 146, 5123),
(147, 1, 'sales', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 2, 3, NULL, 147, 4870),
(148, 1, 'sales', '2024-06-06 00:00:00.000000', '2024-06-06 00:00:00.000000', 2, 3, NULL, 148, 4478),
(149, 1, 'sales', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 2, 3, NULL, 149, 4079),
(150, 1, 'sales', '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 2, 3, NULL, 150, 3629),
(151, 1, 'sales', '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 2, 3, NULL, 151, 3510),
(152, 1, 'sales', '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 2, 3, NULL, 152, 3284),
(153, 1, 'sales', '2024-07-25 00:00:00.000000', '2024-07-25 00:00:00.000000', 2, 3, NULL, 153, 3081),
(154, 1, 'sales', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 2, 3, NULL, 154, 2867),
(155, 1, 'sales', '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 2, 3, NULL, 155, 2394),
(156, 1, 'sales', '2024-07-23 00:00:00.000000', '2024-07-23 00:00:00.000000', 3, 3, NULL, 156, 3089),
(157, 1, 'sales', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 3, 3, NULL, 157, 2967),
(158, 1, 'sales', '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 3, 3, NULL, 158, 2807),
(159, 1, 'sales', '2024-06-09 00:00:00.000000', '2024-06-09 00:00:00.000000', 3, 3, NULL, 159, 2424),
(160, 1, 'sales', '2024-07-19 00:00:00.000000', '2024-07-19 00:00:00.000000', 3, 3, NULL, 160, 2137),
(161, 1, 'sales', '2024-07-31 00:00:00.000000', '2024-07-31 00:00:00.000000', 3, 3, NULL, 161, 1661),
(162, 1, 'sales', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 3, 3, NULL, 162, 1403),
(163, 1, 'sales', '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 4, 3, NULL, 163, 280),
(164, 1, 'sales', '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 4, 3, NULL, 164, 5138),
(165, 1, 'sales', '2024-06-09 00:00:00.000000', '2024-06-09 00:00:00.000000', 4, 3, NULL, 165, 4722),
(166, 1, 'sales', '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 4, 3, NULL, 166, 4367),
(167, 1, 'sales', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 4, 3, NULL, 167, 3931),
(168, 1, 'sales', '2024-06-01 00:00:00.000000', '2024-06-01 00:00:00.000000', 4, 3, NULL, 168, 3449),
(169, 1, 'sales', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 4, 3, NULL, 169, 3048),
(170, 1, 'sales', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 4, 3, NULL, 170, 2576),
(171, 1, 'sales', '2024-06-17 00:00:00.000000', '2024-06-17 00:00:00.000000', 4, 3, NULL, 171, 2465),
(172, 1, 'sales', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 4, 3, NULL, 172, 2263),
(173, 1, 'sales', '2024-07-16 00:00:00.000000', '2024-07-16 00:00:00.000000', 4, 3, NULL, 173, 2122),
(174, 1, 'sales', '2024-07-16 00:00:00.000000', '2024-07-16 00:00:00.000000', 5, 3, NULL, 174, 2825),
(175, 1, 'sales', '2024-07-06 00:00:00.000000', '2024-07-06 00:00:00.000000', 5, 3, NULL, 175, 2539),
(176, 1, 'sales', '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 5, 3, NULL, 176, 2087),
(177, 1, 'sales', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 5, 3, NULL, 177, 1651),
(178, 1, 'sales', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 5, 3, NULL, 178, 1520),
(179, 1, 'sales', '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 5, 3, NULL, 179, 1336),
(180, 1, 'sales', '2024-06-09 00:00:00.000000', '2024-06-09 00:00:00.000000', 5, 3, NULL, 180, 857),
(181, 1, 'sales', '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 5, 3, NULL, 181, 673),
(182, 1, 'sales', '2024-07-21 00:00:00.000000', '2024-07-21 00:00:00.000000', 5, 3, NULL, 182, 381),
(183, 1, 'sales', '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 5, 3, NULL, 183, 5144),
(184, 1, 'sales', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 5, 3, NULL, 184, 4767),
(185, 1, 'sales', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 5, 3, NULL, 185, 4482),
(186, 1, 'sales', '2024-07-03 00:00:00.000000', '2024-07-03 00:00:00.000000', 5, 3, NULL, 186, 4048),
(187, 1, 'sales', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 5, 3, NULL, 187, 3661),
(188, 1, 'sales', '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 5, 3, NULL, 188, 3303),
(189, 1, 'sales', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 5, 3, NULL, 189, 3194),
(190, 1, 'sales', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 5, 3, NULL, 190, 3044),
(191, 1, 'sales', '2024-06-14 00:00:00.000000', '2024-06-14 00:00:00.000000', 5, 3, NULL, 191, 2641),
(192, 1, 'sales', '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 5, 3, NULL, 192, 2152),
(193, 1, 'sales', '2024-07-13 00:00:00.000000', '2024-07-13 00:00:00.000000', 5, 3, NULL, 193, 1774),
(194, 1, 'sales', '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 5, 3, NULL, 194, 1494),
(195, 1, 'sales', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 5, 3, NULL, 195, 1345),
(196, 1, 'sales', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 1, 3, NULL, 196, 4639),
(197, 1, 'sales', '2024-07-26 00:00:00.000000', '2024-07-26 00:00:00.000000', 1, 3, NULL, 197, 4267),
(198, 1, 'sales', '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 1, 3, NULL, 198, 3994),
(199, 1, 'sales', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 1, 3, NULL, 199, 3618),
(200, 1, 'sales', '2024-06-13 00:00:00.000000', '2024-06-13 00:00:00.000000', 1, 3, NULL, 200, 3182),
(201, 1, 'sales', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 1, 3, NULL, 201, 2895),
(202, 1, 'sales', '2024-07-27 00:00:00.000000', '2024-07-27 00:00:00.000000', 1, 3, NULL, 202, 2764),
(203, 1, 'sales', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 1, 3, NULL, 203, 2287),
(204, 1, 'sales', '2024-07-19 00:00:00.000000', '2024-07-19 00:00:00.000000', 1, 3, NULL, 204, 2094),
(205, 1, 'sales', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 2, 3, NULL, 205, 2357),
(206, 1, 'sales', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 2, 3, NULL, 206, 2151),
(207, 1, 'sales', '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 2, 3, NULL, 207, 2042),
(208, 1, 'sales', '2024-06-20 00:00:00.000000', '2024-06-20 00:00:00.000000', 2, 3, NULL, 208, 1765),
(209, 1, 'sales', '2024-07-23 00:00:00.000000', '2024-07-23 00:00:00.000000', 2, 3, NULL, 209, 1526),
(210, 1, 'sales', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 2, 3, NULL, 210, 1269),
(211, 1, 'sales', '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 2, 3, NULL, 211, 1150),
(212, 1, 'sales', '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 2, 3, NULL, 212, 789),
(213, 1, 'sales', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 2, 3, NULL, 213, 433),
(214, 1, 'sales', '2024-07-26 00:00:00.000000', '2024-07-26 00:00:00.000000', 2, 3, NULL, 214, 5179),
(215, 1, 'sales', '2024-06-12 00:00:00.000000', '2024-06-12 00:00:00.000000', 2, 3, NULL, 215, 4824),
(216, 1, 'sales', '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 2, 3, NULL, 216, 4626),
(217, 1, 'sales', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 2, 3, NULL, 217, 4477),
(218, 1, 'sales', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 2, 3, NULL, 218, 4138),
(219, 1, 'sales', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 2, 3, NULL, 219, 4005),
(220, 1, 'sales', '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 2, 3, NULL, 220, 3591),
(221, 1, 'sales', '2024-06-12 00:00:00.000000', '2024-06-12 00:00:00.000000', 2, 3, NULL, 221, 3167),
(222, 1, 'sales', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 2, 3, NULL, 222, 2829),
(223, 1, 'sales', '2024-06-14 00:00:00.000000', '2024-06-14 00:00:00.000000', 2, 3, NULL, 223, 2657),
(224, 1, 'sales', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 2, 3, NULL, 224, 2442),
(225, 1, 'sales', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 2, 3, NULL, 225, 2025),
(226, 1, 'sales', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 2, 3, NULL, 226, 1637),
(227, 1, 'sales', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 2, 3, NULL, 227, 1481),
(228, 1, 'sales', '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 2, 3, NULL, 228, 1258),
(229, 1, 'sales', '2024-06-04 00:00:00.000000', '2024-06-04 00:00:00.000000', 2, 3, NULL, 229, 942),
(230, 1, 'sales', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 2, 3, NULL, 230, 529),
(231, 1, 'sales', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 2, 3, NULL, 231, 407),
(232, 1, 'sales', '2024-07-06 00:00:00.000000', '2024-07-06 00:00:00.000000', 2, 3, NULL, 232, 189),
(233, 1, 'sales', '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 2, 3, NULL, 233, 14),
(234, 1, 'sales', '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 3, 3, NULL, 234, 1104),
(235, 1, 'sales', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 3, 3, NULL, 235, 631),
(236, 1, 'sales', '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 3, 3, NULL, 236, 512),
(237, 1, 'sales', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 3, 3, NULL, 237, 5094),
(238, 1, 'sales', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 3, 3, NULL, 238, 4857),
(239, 1, 'sales', '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 3, 3, NULL, 239, 4571),
(240, 1, 'sales', '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 3, 3, NULL, 240, 4423),
(241, 1, 'sales', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 3, 3, NULL, 241, 3940),
(242, 1, 'sales', '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 3, 3, NULL, 242, 3792),
(243, 1, 'sales', '2024-07-14 00:00:00.000000', '2024-07-14 00:00:00.000000', 3, 3, NULL, 243, 3507),
(244, 1, 'sales', '2024-07-06 00:00:00.000000', '2024-07-06 00:00:00.000000', 3, 3, NULL, 244, 3280),
(245, 1, 'sales', '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 3, 3, NULL, 245, 3071),
(246, 1, 'sales', '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 3, 3, NULL, 246, 2754),
(247, 1, 'sales', '2024-06-09 00:00:00.000000', '2024-06-09 00:00:00.000000', 3, 3, NULL, 247, 2563),
(248, 1, 'sales', '2024-06-01 00:00:00.000000', '2024-06-01 00:00:00.000000', 3, 3, NULL, 248, 2117),
(249, 1, 'sales', '2024-07-13 00:00:00.000000', '2024-07-13 00:00:00.000000', 3, 3, NULL, 249, 1898),
(250, 1, 'sales', '2024-07-19 00:00:00.000000', '2024-07-19 00:00:00.000000', 3, 3, NULL, 250, 1481),
(251, 1, 'sales', '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 3, 3, NULL, 251, 1190),
(252, 1, 'sales', '2024-07-27 00:00:00.000000', '2024-07-27 00:00:00.000000', 3, 3, NULL, 252, 778),
(253, 1, 'sales', '2024-07-25 00:00:00.000000', '2024-07-25 00:00:00.000000', 3, 3, NULL, 253, 461),
(254, 1, 'sales', '2024-06-04 00:00:00.000000', '2024-06-04 00:00:00.000000', 3, 3, NULL, 254, 174),
(255, 1, 'sales', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 4, 3, NULL, 255, 2051),
(256, 1, 'sales', '2024-07-14 00:00:00.000000', '2024-07-14 00:00:00.000000', 4, 3, NULL, 256, 1887),
(257, 1, 'sales', '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 4, 3, NULL, 257, 1521),
(258, 1, 'sales', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 4, 3, NULL, 258, 1140),
(259, 1, 'sales', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 4, 3, NULL, 259, 786),
(260, 1, 'sales', '2024-07-31 00:00:00.000000', '2024-07-31 00:00:00.000000', 4, 3, NULL, 260, 572),
(261, 1, 'sales', '2024-07-31 00:00:00.000000', '2024-07-31 00:00:00.000000', 4, 3, NULL, 261, 238),
(262, 1, 'sales', '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 5, 3, NULL, 262, 1298),
(263, 1, 'sales', '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 1, 5, NULL, 263, 5896),
(264, 1, 'sales', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 1, 5, NULL, 264, 5596),
(265, 1, 'sales', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 1, 5, NULL, 265, 5313),
(266, 1, 'sales', '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 1, 5, NULL, 266, 5148),
(267, 1, 'sales', '2024-07-31 00:00:00.000000', '2024-07-31 00:00:00.000000', 1, 5, NULL, 267, 4863),
(268, 1, 'sales', '2024-07-19 00:00:00.000000', '2024-07-19 00:00:00.000000', 1, 5, NULL, 268, 4597),
(269, 1, 'sales', '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 1, 5, NULL, 269, 4427),
(270, 1, 'sales', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 1, 5, NULL, 270, 4264),
(271, 1, 'sales', '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 1, 5, NULL, 271, 4091),
(272, 1, 'sales', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 1, 5, NULL, 272, 3894),
(273, 1, 'sales', '2024-07-23 00:00:00.000000', '2024-07-23 00:00:00.000000', 1, 5, NULL, 273, 3611),
(274, 1, 'sales', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 1, 5, NULL, 274, 3396),
(275, 1, 'sales', '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 1, 5, NULL, 275, 3265),
(276, 1, 'sales', '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 1, 5, NULL, 276, 3066),
(277, 1, 'sales', '2024-07-29 00:00:00.000000', '2024-07-29 00:00:00.000000', 1, 5, NULL, 277, 2867),
(278, 1, 'sales', '2024-07-08 00:00:00.000000', '2024-07-08 00:00:00.000000', 1, 5, NULL, 278, 2679),
(279, 1, 'sales', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 1, 5, NULL, 279, 2443),
(280, 1, 'sales', '2024-06-20 00:00:00.000000', '2024-06-20 00:00:00.000000', 1, 5, NULL, 280, 2165),
(281, 1, 'sales', '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 1, 5, NULL, 281, 1926),
(282, 1, 'sales', '2024-06-12 00:00:00.000000', '2024-06-12 00:00:00.000000', 1, 5, NULL, 282, 1818),
(283, 1, 'sales', '2024-06-17 00:00:00.000000', '2024-06-17 00:00:00.000000', 1, 5, NULL, 283, 1628),
(284, 1, 'sales', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 1, 5, NULL, 284, 1479),
(285, 1, 'sales', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 1, 5, NULL, 285, 1357),
(286, 1, 'sales', '2024-06-04 00:00:00.000000', '2024-06-04 00:00:00.000000', 1, 5, NULL, 286, 1161),
(287, 1, 'sales', '2024-06-06 00:00:00.000000', '2024-06-06 00:00:00.000000', 1, 5, NULL, 287, 940),
(288, 1, 'sales', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 1, 5, NULL, 288, 654),
(289, 1, 'sales', '2024-07-06 00:00:00.000000', '2024-07-06 00:00:00.000000', 1, 5, NULL, 289, 414),
(290, 1, 'sales', '2024-07-29 00:00:00.000000', '2024-07-29 00:00:00.000000', 1, 5, NULL, 290, 205),
(291, 1, 'sales', '2024-07-21 00:00:00.000000', '2024-07-21 00:00:00.000000', 2, 5, NULL, 291, 4462),
(292, 1, 'sales', '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 2, 5, NULL, 292, 4198),
(293, 1, 'sales', '2024-07-29 00:00:00.000000', '2024-07-29 00:00:00.000000', 2, 5, NULL, 293, 4016),
(294, 1, 'sales', '2024-06-23 00:00:00.000000', '2024-06-23 00:00:00.000000', 2, 5, NULL, 294, 3816),
(295, 1, 'sales', '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 2, 5, NULL, 295, 3520),
(296, 1, 'sales', '2024-07-29 00:00:00.000000', '2024-07-29 00:00:00.000000', 2, 5, NULL, 296, 3297),
(297, 1, 'sales', '2024-06-20 00:00:00.000000', '2024-06-20 00:00:00.000000', 2, 5, NULL, 297, 3079),
(298, 1, 'sales', '2024-06-23 00:00:00.000000', '2024-06-23 00:00:00.000000', 2, 5, NULL, 298, 2919),
(299, 1, 'sales', '2024-07-26 00:00:00.000000', '2024-07-26 00:00:00.000000', 2, 5, NULL, 299, 2644),
(300, 1, 'sales', '2024-07-13 00:00:00.000000', '2024-07-13 00:00:00.000000', 2, 5, NULL, 300, 2501),
(301, 1, 'sales', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 2, 5, NULL, 301, 2398),
(302, 1, 'sales', '2024-07-12 00:00:00.000000', '2024-07-12 00:00:00.000000', 2, 5, NULL, 302, 2126),
(303, 1, 'sales', '2024-07-03 00:00:00.000000', '2024-07-03 00:00:00.000000', 2, 5, NULL, 303, 1947),
(304, 1, 'sales', '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 2, 5, NULL, 304, 1758),
(305, 1, 'sales', '2024-06-13 00:00:00.000000', '2024-06-13 00:00:00.000000', 2, 5, NULL, 305, 1605),
(306, 1, 'sales', '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 2, 5, NULL, 306, 1333),
(307, 1, 'sales', '2024-07-07 00:00:00.000000', '2024-07-07 00:00:00.000000', 2, 5, NULL, 307, 1188),
(308, 1, 'sales', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 2, 5, NULL, 308, 924),
(309, 1, 'sales', '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 2, 5, NULL, 309, 665),
(310, 1, 'sales', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 2, 5, NULL, 310, 454),
(311, 1, 'sales', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 2, 5, NULL, 311, 245),
(312, 1, 'sales', '2024-07-31 00:00:00.000000', '2024-07-31 00:00:00.000000', 2, 5, NULL, 312, 137),
(313, 1, 'sales', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 3, 5, NULL, 313, 6911),
(314, 1, 'sales', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 3, 5, NULL, 314, 6665),
(315, 1, 'sales', '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 3, 5, NULL, 315, 6427),
(316, 1, 'sales', '2024-06-28 00:00:00.000000', '2024-06-28 00:00:00.000000', 3, 5, NULL, 316, 6232),
(317, 1, 'sales', '2024-07-27 00:00:00.000000', '2024-07-27 00:00:00.000000', 3, 5, NULL, 317, 6000),
(318, 1, 'sales', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 3, 5, NULL, 318, 5772),
(319, 1, 'sales', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 3, 5, NULL, 319, 5610),
(320, 1, 'sales', '2024-07-23 00:00:00.000000', '2024-07-23 00:00:00.000000', 3, 5, NULL, 320, 5374),
(321, 1, 'sales', '2024-06-07 00:00:00.000000', '2024-06-07 00:00:00.000000', 3, 5, NULL, 321, 5171),
(322, 1, 'sales', '2024-07-30 00:00:00.000000', '2024-07-30 00:00:00.000000', 3, 5, NULL, 322, 4937),
(323, 1, 'sales', '2024-07-18 00:00:00.000000', '2024-07-18 00:00:00.000000', 3, 5, NULL, 323, 4768),
(324, 1, 'sales', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 3, 5, NULL, 324, 4653),
(325, 1, 'sales', '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 3, 5, NULL, 325, 4479),
(326, 1, 'sales', '2024-07-07 00:00:00.000000', '2024-07-07 00:00:00.000000', 3, 5, NULL, 326, 4288),
(327, 1, 'sales', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 3, 5, NULL, 327, 4058),
(328, 1, 'sales', '2024-06-09 00:00:00.000000', '2024-06-09 00:00:00.000000', 3, 5, NULL, 328, 3933),
(329, 1, 'sales', '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 3, 5, NULL, 329, 3711),
(330, 1, 'sales', '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 3, 5, NULL, 330, 3588),
(331, 1, 'sales', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 3, 5, NULL, 331, 3481),
(332, 1, 'sales', '2024-06-12 00:00:00.000000', '2024-06-12 00:00:00.000000', 3, 5, NULL, 332, 3287),
(333, 1, 'sales', '2024-06-06 00:00:00.000000', '2024-06-06 00:00:00.000000', 3, 5, NULL, 333, 2994),
(334, 1, 'sales', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 3, 5, NULL, 334, 2865),
(335, 1, 'sales', '2024-06-09 00:00:00.000000', '2024-06-09 00:00:00.000000', 3, 5, NULL, 335, 2751),
(336, 1, 'sales', '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 3, 5, NULL, 336, 2605),
(337, 1, 'sales', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 3, 5, NULL, 337, 2333),
(338, 1, 'sales', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 3, 5, NULL, 338, 2205),
(339, 1, 'sales', '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 3, 5, NULL, 339, 1988),
(340, 1, 'sales', '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 3, 5, NULL, 340, 1688),
(341, 1, 'sales', '2024-07-13 00:00:00.000000', '2024-07-13 00:00:00.000000', 3, 5, NULL, 341, 1481),
(342, 1, 'sales', '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 3, 5, NULL, 342, 1195),
(343, 1, 'sales', '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 3, 5, NULL, 343, 1086),
(344, 1, 'sales', '2024-07-25 00:00:00.000000', '2024-07-25 00:00:00.000000', 3, 5, NULL, 344, 968),
(345, 1, 'sales', '2024-07-27 00:00:00.000000', '2024-07-27 00:00:00.000000', 3, 5, NULL, 345, 709),
(346, 1, 'sales', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 3, 5, NULL, 346, 451),
(347, 1, 'sales', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 3, 5, NULL, 347, 219),
(348, 1, 'sales', '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 3, 5, NULL, 348, 85),
(349, 1, 'sales', '2024-06-01 00:00:00.000000', '2024-06-01 00:00:00.000000', 4, 5, NULL, 349, 4720),
(350, 1, 'sales', '2024-07-21 00:00:00.000000', '2024-07-21 00:00:00.000000', 4, 5, NULL, 350, 4484),
(351, 1, 'sales', '2024-07-18 00:00:00.000000', '2024-07-18 00:00:00.000000', 4, 5, NULL, 351, 4310),
(352, 1, 'sales', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 4, 5, NULL, 352, 4171),
(353, 1, 'sales', '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 4, 5, NULL, 353, 3958),
(354, 1, 'sales', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 4, 5, NULL, 354, 3755),
(355, 1, 'sales', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 4, 5, NULL, 355, 3481),
(356, 1, 'sales', '2024-07-12 00:00:00.000000', '2024-07-12 00:00:00.000000', 4, 5, NULL, 356, 3235),
(357, 1, 'sales', '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 4, 5, NULL, 357, 2972),
(358, 1, 'sales', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 4, 5, NULL, 358, 2791),
(359, 1, 'sales', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 4, 5, NULL, 359, 2551),
(360, 1, 'sales', '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 4, 5, NULL, 360, 2326),
(361, 1, 'sales', '2024-07-30 00:00:00.000000', '2024-07-30 00:00:00.000000', 4, 5, NULL, 361, 2071),
(362, 1, 'sales', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 4, 5, NULL, 362, 1875),
(363, 1, 'sales', '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 4, 5, NULL, 363, 1602),
(364, 1, 'sales', '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 4, 5, NULL, 364, 1417),
(365, 1, 'sales', '2024-06-01 00:00:00.000000', '2024-06-01 00:00:00.000000', 4, 5, NULL, 365, 1172),
(366, 1, 'sales', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 4, 5, NULL, 366, 908),
(367, 1, 'sales', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 4, 5, NULL, 367, 721),
(368, 1, 'sales', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 4, 5, NULL, 368, 475),
(369, 1, 'sales', '2024-07-29 00:00:00.000000', '2024-07-29 00:00:00.000000', 4, 5, NULL, 369, 323),
(370, 1, 'sales', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 4, 5, NULL, 370, 161),
(371, 1, 'sales', '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 4, 5, NULL, 371, 18),
(372, 1, 'sales', '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 5, 5, NULL, 372, 2175),
(373, 1, 'sales', '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 5, 5, NULL, 373, 2045),
(374, 1, 'sales', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 5, 5, NULL, 374, 1802),
(375, 1, 'sales', '2024-07-14 00:00:00.000000', '2024-07-14 00:00:00.000000', 5, 5, NULL, 375, 1665),
(376, 1, 'sales', '2024-07-07 00:00:00.000000', '2024-07-07 00:00:00.000000', 5, 5, NULL, 376, 1385),
(377, 1, 'sales', '2024-06-17 00:00:00.000000', '2024-06-17 00:00:00.000000', 5, 5, NULL, 377, 1225),
(378, 1, 'sales', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 5, 5, NULL, 378, 1116),
(379, 1, 'sales', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 5, 5, NULL, 379, 933),
(380, 1, 'sales', '2024-06-13 00:00:00.000000', '2024-06-13 00:00:00.000000', 5, 5, NULL, 380, 745),
(381, 1, 'sales', '2024-07-13 00:00:00.000000', '2024-07-13 00:00:00.000000', 5, 5, NULL, 381, 615),
(382, 1, 'sales', '2024-07-27 00:00:00.000000', '2024-07-27 00:00:00.000000', 5, 5, NULL, 382, 378),
(383, 1, 'sales', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 5, 5, NULL, 383, 225),
(384, 1, 'sales', '2024-06-23 00:00:00.000000', '2024-06-23 00:00:00.000000', 5, 5, NULL, 384, 17),
(385, 1, 'sales', '2024-06-14 00:00:00.000000', '2024-06-14 00:00:00.000000', 1, 6, NULL, 385, 9465),
(386, 1, 'sales', '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 1, 6, NULL, 386, 9204),
(387, 1, 'sales', '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 1, 6, NULL, 387, 9055),
(388, 1, 'sales', '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 1, 6, NULL, 388, 8867),
(389, 1, 'sales', '2024-06-07 00:00:00.000000', '2024-06-07 00:00:00.000000', 1, 6, NULL, 389, 8580),
(390, 1, 'sales', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 1, 6, NULL, 390, 8424),
(391, 1, 'sales', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 1, 6, NULL, 391, 8213),
(392, 1, 'sales', '2024-06-07 00:00:00.000000', '2024-06-07 00:00:00.000000', 1, 6, NULL, 392, 7940),
(393, 1, 'sales', '2024-07-29 00:00:00.000000', '2024-07-29 00:00:00.000000', 1, 6, NULL, 393, 7808),
(394, 1, 'sales', '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 1, 6, NULL, 394, 7585),
(395, 1, 'sales', '2024-07-08 00:00:00.000000', '2024-07-08 00:00:00.000000', 1, 6, NULL, 395, 7453),
(396, 1, 'sales', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 1, 6, NULL, 396, 7221),
(397, 1, 'sales', '2024-07-06 00:00:00.000000', '2024-07-06 00:00:00.000000', 1, 6, NULL, 397, 7079),
(398, 1, 'sales', '2024-07-27 00:00:00.000000', '2024-07-27 00:00:00.000000', 1, 6, NULL, 398, 6807),
(399, 1, 'sales', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 1, 6, NULL, 399, 6509),
(400, 1, 'sales', '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 1, 6, NULL, 400, 6223),
(401, 1, 'sales', '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 1, 6, NULL, 401, 6058),
(402, 1, 'sales', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 1, 6, NULL, 402, 5810),
(403, 1, 'sales', '2024-06-12 00:00:00.000000', '2024-06-12 00:00:00.000000', 1, 6, NULL, 403, 5607),
(404, 1, 'sales', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 1, 6, NULL, 404, 5481),
(405, 1, 'sales', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 1, 6, NULL, 405, 5319),
(406, 1, 'sales', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 1, 6, NULL, 406, 5080),
(407, 1, 'sales', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 1, 6, NULL, 407, 4801),
(408, 1, 'sales', '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 1, 6, NULL, 408, 4519),
(409, 1, 'sales', '2024-06-12 00:00:00.000000', '2024-06-12 00:00:00.000000', 1, 6, NULL, 409, 4348),
(410, 1, 'sales', '2024-06-28 00:00:00.000000', '2024-06-28 00:00:00.000000', 1, 6, NULL, 410, 4062),
(411, 1, 'sales', '2024-07-03 00:00:00.000000', '2024-07-03 00:00:00.000000', 1, 6, NULL, 411, 3792),
(412, 1, 'sales', '2024-06-30 00:00:00.000000', '2024-06-30 00:00:00.000000', 1, 6, NULL, 412, 3498),
(413, 1, 'sales', '2024-07-08 00:00:00.000000', '2024-07-08 00:00:00.000000', 1, 6, NULL, 413, 3200),
(414, 1, 'sales', '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 1, 6, NULL, 414, 2908),
(415, 1, 'sales', '2024-07-19 00:00:00.000000', '2024-07-19 00:00:00.000000', 1, 6, NULL, 415, 2800),
(416, 1, 'sales', '2024-07-16 00:00:00.000000', '2024-07-16 00:00:00.000000', 1, 6, NULL, 416, 2575),
(417, 1, 'sales', '2024-06-04 00:00:00.000000', '2024-06-04 00:00:00.000000', 1, 6, NULL, 417, 2387),
(418, 1, 'sales', '2024-07-16 00:00:00.000000', '2024-07-16 00:00:00.000000', 1, 6, NULL, 418, 2262),
(419, 1, 'sales', '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 1, 6, NULL, 419, 2101),
(420, 1, 'sales', '2024-07-30 00:00:00.000000', '2024-07-30 00:00:00.000000', 1, 6, NULL, 420, 1875),
(421, 1, 'sales', '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 1, 6, NULL, 421, 1586),
(422, 1, 'sales', '2024-07-29 00:00:00.000000', '2024-07-29 00:00:00.000000', 1, 6, NULL, 422, 1367),
(423, 1, 'sales', '2024-06-30 00:00:00.000000', '2024-06-30 00:00:00.000000', 1, 6, NULL, 423, 1212),
(424, 1, 'sales', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 1, 6, NULL, 424, 968),
(425, 1, 'sales', '2024-07-16 00:00:00.000000', '2024-07-16 00:00:00.000000', 1, 6, NULL, 425, 837),
(426, 1, 'sales', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 1, 6, NULL, 426, 660),
(427, 1, 'sales', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 1, 6, NULL, 427, 512),
(428, 1, 'sales', '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 1, 6, NULL, 428, 261),
(429, 1, 'sales', '2024-07-03 00:00:00.000000', '2024-07-03 00:00:00.000000', 1, 6, NULL, 429, 148),
(430, 1, 'sales', '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 1, 6, NULL, 430, 12),
(431, 1, 'sales', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 2, 6, NULL, 431, 8181),
(432, 1, 'sales', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 2, 6, NULL, 432, 7955),
(433, 1, 'sales', '2024-06-12 00:00:00.000000', '2024-06-12 00:00:00.000000', 2, 6, NULL, 433, 7761),
(434, 1, 'sales', '2024-07-16 00:00:00.000000', '2024-07-16 00:00:00.000000', 2, 6, NULL, 434, 7634),
(435, 1, 'sales', '2024-07-18 00:00:00.000000', '2024-07-18 00:00:00.000000', 2, 6, NULL, 435, 7363),
(436, 1, 'sales', '2024-07-06 00:00:00.000000', '2024-07-06 00:00:00.000000', 2, 6, NULL, 436, 7232),
(437, 1, 'sales', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 2, 6, NULL, 437, 6955),
(438, 1, 'sales', '2024-06-19 00:00:00.000000', '2024-06-19 00:00:00.000000', 2, 6, NULL, 438, 6664),
(439, 1, 'sales', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 2, 6, NULL, 439, 6524),
(440, 1, 'sales', '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 2, 6, NULL, 440, 6304),
(441, 1, 'sales', '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 2, 6, NULL, 441, 6076),
(442, 1, 'sales', '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 2, 6, NULL, 442, 5857),
(443, 1, 'sales', '2024-06-05 00:00:00.000000', '2024-06-05 00:00:00.000000', 2, 6, NULL, 443, 5722),
(444, 1, 'sales', '2024-06-05 00:00:00.000000', '2024-06-05 00:00:00.000000', 2, 6, NULL, 444, 5588),
(445, 1, 'sales', '2024-07-19 00:00:00.000000', '2024-07-19 00:00:00.000000', 2, 6, NULL, 445, 5414),
(446, 1, 'sales', '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 2, 6, NULL, 446, 5144),
(447, 1, 'sales', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 2, 6, NULL, 447, 5037),
(448, 1, 'sales', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 2, 6, NULL, 448, 4851),
(449, 1, 'sales', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 2, 6, NULL, 449, 4696),
(450, 1, 'sales', '2024-07-16 00:00:00.000000', '2024-07-16 00:00:00.000000', 2, 6, NULL, 450, 4536),
(451, 1, 'sales', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 2, 6, NULL, 451, 4278),
(452, 1, 'sales', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 2, 6, NULL, 452, 4010),
(453, 1, 'sales', '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 2, 6, NULL, 453, 3717),
(454, 1, 'sales', '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 2, 6, NULL, 454, 3535),
(455, 1, 'sales', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 2, 6, NULL, 455, 3411),
(456, 1, 'sales', '2024-07-13 00:00:00.000000', '2024-07-13 00:00:00.000000', 2, 6, NULL, 456, 3188),
(457, 1, 'sales', '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 2, 6, NULL, 457, 3076),
(458, 1, 'sales', '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 2, 6, NULL, 458, 2955),
(459, 1, 'sales', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 2, 6, NULL, 459, 2696),
(460, 1, 'sales', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 2, 6, NULL, 460, 2518),
(461, 1, 'sales', '2024-07-29 00:00:00.000000', '2024-07-29 00:00:00.000000', 2, 6, NULL, 461, 2371),
(462, 1, 'sales', '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 2, 6, NULL, 462, 2166),
(463, 1, 'sales', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 2, 6, NULL, 463, 1890),
(464, 1, 'sales', '2024-06-19 00:00:00.000000', '2024-06-19 00:00:00.000000', 2, 6, NULL, 464, 1757),
(465, 1, 'sales', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 2, 6, NULL, 465, 1513),
(466, 1, 'sales', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 2, 6, NULL, 466, 1348),
(467, 1, 'sales', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 2, 6, NULL, 467, 1211),
(468, 1, 'sales', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 2, 6, NULL, 468, 1046),
(469, 1, 'sales', '2024-07-11 00:00:00.000000', '2024-07-11 00:00:00.000000', 2, 6, NULL, 469, 938),
(470, 1, 'sales', '2024-07-26 00:00:00.000000', '2024-07-26 00:00:00.000000', 2, 6, NULL, 470, 686),
(471, 1, 'sales', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 2, 6, NULL, 471, 436),
(472, 1, 'sales', '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 2, 6, NULL, 472, 160),
(473, 1, 'sales', '2024-07-21 00:00:00.000000', '2024-07-21 00:00:00.000000', 2, 6, NULL, 473, 1),
(474, 1, 'sales', '2024-07-06 00:00:00.000000', '2024-07-06 00:00:00.000000', 3, 6, NULL, 474, 1985),
(475, 1, 'sales', '2024-07-03 00:00:00.000000', '2024-07-03 00:00:00.000000', 3, 6, NULL, 475, 1811),
(476, 1, 'sales', '2024-06-07 00:00:00.000000', '2024-06-07 00:00:00.000000', 3, 6, NULL, 476, 1544),
(477, 1, 'sales', '2024-07-30 00:00:00.000000', '2024-07-30 00:00:00.000000', 3, 6, NULL, 477, 1327),
(478, 1, 'sales', '2024-07-14 00:00:00.000000', '2024-07-14 00:00:00.000000', 3, 6, NULL, 478, 1214),
(479, 1, 'sales', '2024-06-03 00:00:00.000000', '2024-06-03 00:00:00.000000', 3, 6, NULL, 479, 936),
(480, 1, 'sales', '2024-06-14 00:00:00.000000', '2024-06-14 00:00:00.000000', 3, 6, NULL, 480, 714),
(481, 1, 'sales', '2024-06-14 00:00:00.000000', '2024-06-14 00:00:00.000000', 3, 6, NULL, 481, 599),
(482, 1, 'sales', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 3, 6, NULL, 482, 310),
(483, 1, 'sales', '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 3, 6, NULL, 483, 157),
(484, 1, 'sales', '2024-07-23 00:00:00.000000', '2024-07-23 00:00:00.000000', 4, 6, NULL, 484, 3229),
(485, 1, 'sales', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 4, 6, NULL, 485, 3012),
(486, 1, 'sales', '2024-06-05 00:00:00.000000', '2024-06-05 00:00:00.000000', 4, 6, NULL, 486, 2790),
(487, 1, 'sales', '2024-06-12 00:00:00.000000', '2024-06-12 00:00:00.000000', 4, 6, NULL, 487, 2599),
(488, 1, 'sales', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 4, 6, NULL, 488, 2362),
(489, 1, 'sales', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 4, 6, NULL, 489, 2176),
(490, 1, 'sales', '2024-06-14 00:00:00.000000', '2024-06-14 00:00:00.000000', 4, 6, NULL, 490, 1969),
(491, 1, 'sales', '2024-06-23 00:00:00.000000', '2024-06-23 00:00:00.000000', 4, 6, NULL, 491, 1835),
(492, 1, 'sales', '2024-06-30 00:00:00.000000', '2024-06-30 00:00:00.000000', 4, 6, NULL, 492, 1648),
(493, 1, 'sales', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 4, 6, NULL, 493, 1357),
(494, 1, 'sales', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 4, 6, NULL, 494, 1255),
(495, 1, 'sales', '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 4, 6, NULL, 495, 966),
(496, 1, 'sales', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 4, 6, NULL, 496, 801),
(497, 1, 'sales', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 4, 6, NULL, 497, 510),
(498, 1, 'sales', '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 4, 6, NULL, 498, 230),
(499, 1, 'sales', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 5, 6, NULL, 499, 6527),
(500, 1, 'sales', '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 5, 6, NULL, 500, 6236),
(501, 1, 'sales', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 5, 6, NULL, 501, 6119);
INSERT INTO `transactions` (`id`, `user_id`, `type`, `created_at`, `updated_at`, `item_id`, `outlet_id`, `purchase_id`, `sales_id`, `stock`) VALUES
(502, 1, 'sales', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 5, 6, NULL, 502, 5933),
(503, 1, 'sales', '2024-07-23 00:00:00.000000', '2024-07-23 00:00:00.000000', 5, 6, NULL, 503, 5758),
(504, 1, 'sales', '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 5, 6, NULL, 504, 5558),
(505, 1, 'sales', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 5, 6, NULL, 505, 5326),
(506, 1, 'sales', '2024-06-14 00:00:00.000000', '2024-06-14 00:00:00.000000', 5, 6, NULL, 506, 5204),
(507, 1, 'sales', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 5, 6, NULL, 507, 5015),
(508, 1, 'sales', '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 5, 6, NULL, 508, 4880),
(509, 1, 'sales', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 5, 6, NULL, 509, 4622),
(510, 1, 'sales', '2024-06-09 00:00:00.000000', '2024-06-09 00:00:00.000000', 5, 6, NULL, 510, 4501),
(511, 1, 'sales', '2024-06-12 00:00:00.000000', '2024-06-12 00:00:00.000000', 5, 6, NULL, 511, 4302),
(512, 1, 'sales', '2024-06-20 00:00:00.000000', '2024-06-20 00:00:00.000000', 5, 6, NULL, 512, 4183),
(513, 1, 'sales', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 5, 6, NULL, 513, 3966),
(514, 1, 'sales', '2024-06-23 00:00:00.000000', '2024-06-23 00:00:00.000000', 5, 6, NULL, 514, 3839),
(515, 1, 'sales', '2024-07-06 00:00:00.000000', '2024-07-06 00:00:00.000000', 5, 6, NULL, 515, 3586),
(516, 1, 'sales', '2024-06-04 00:00:00.000000', '2024-06-04 00:00:00.000000', 5, 6, NULL, 516, 3468),
(517, 1, 'sales', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 5, 6, NULL, 517, 3263),
(518, 1, 'sales', '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 5, 6, NULL, 518, 3154),
(519, 1, 'sales', '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 5, 6, NULL, 519, 2901),
(520, 1, 'sales', '2024-06-24 00:00:00.000000', '2024-06-24 00:00:00.000000', 5, 6, NULL, 520, 2752),
(521, 1, 'sales', '2024-07-29 00:00:00.000000', '2024-07-29 00:00:00.000000', 5, 6, NULL, 521, 2517),
(522, 1, 'sales', '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 5, 6, NULL, 522, 2334),
(523, 1, 'sales', '2024-06-12 00:00:00.000000', '2024-06-12 00:00:00.000000', 5, 6, NULL, 523, 2130),
(524, 1, 'sales', '2024-07-13 00:00:00.000000', '2024-07-13 00:00:00.000000', 5, 6, NULL, 524, 1916),
(525, 1, 'sales', '2024-06-04 00:00:00.000000', '2024-06-04 00:00:00.000000', 5, 6, NULL, 525, 1806),
(526, 1, 'sales', '2024-07-21 00:00:00.000000', '2024-07-21 00:00:00.000000', 5, 6, NULL, 526, 1689),
(527, 1, 'sales', '2024-06-07 00:00:00.000000', '2024-06-07 00:00:00.000000', 5, 6, NULL, 527, 1453),
(528, 1, 'sales', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 5, 6, NULL, 528, 1169),
(529, 1, 'sales', '2024-06-17 00:00:00.000000', '2024-06-17 00:00:00.000000', 5, 6, NULL, 529, 921),
(530, 1, 'sales', '2024-07-23 00:00:00.000000', '2024-07-23 00:00:00.000000', 5, 6, NULL, 530, 678),
(531, 1, 'sales', '2024-07-15 00:00:00.000000', '2024-07-15 00:00:00.000000', 5, 6, NULL, 531, 405),
(532, 1, 'sales', '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 5, 6, NULL, 532, 135),
(533, 1, 'sales', '2024-07-29 00:00:00.000000', '2024-07-29 00:00:00.000000', 1, 7, NULL, 533, 2639),
(534, 1, 'sales', '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 1, 7, NULL, 534, 2512),
(535, 1, 'sales', '2024-06-22 00:00:00.000000', '2024-06-22 00:00:00.000000', 1, 7, NULL, 535, 2355),
(536, 1, 'sales', '2024-07-13 00:00:00.000000', '2024-07-13 00:00:00.000000', 1, 7, NULL, 536, 2167),
(537, 1, 'sales', '2024-07-14 00:00:00.000000', '2024-07-14 00:00:00.000000', 1, 7, NULL, 537, 1998),
(538, 1, 'sales', '2024-06-09 00:00:00.000000', '2024-06-09 00:00:00.000000', 1, 7, NULL, 538, 1765),
(539, 1, 'sales', '2024-06-13 00:00:00.000000', '2024-06-13 00:00:00.000000', 1, 7, NULL, 539, 1502),
(540, 1, 'sales', '2024-06-16 00:00:00.000000', '2024-06-16 00:00:00.000000', 1, 7, NULL, 540, 1358),
(541, 1, 'sales', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 1, 7, NULL, 541, 1147),
(542, 1, 'sales', '2024-06-30 00:00:00.000000', '2024-06-30 00:00:00.000000', 1, 7, NULL, 542, 849),
(543, 1, 'sales', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 1, 7, NULL, 543, 577),
(544, 1, 'sales', '2024-07-14 00:00:00.000000', '2024-07-14 00:00:00.000000', 1, 7, NULL, 544, 385),
(545, 1, 'sales', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 1, 7, NULL, 545, 244),
(546, 1, 'sales', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 1, 7, NULL, 546, 29),
(547, 1, 'sales', '2024-07-18 00:00:00.000000', '2024-07-18 00:00:00.000000', 2, 7, NULL, 547, 7357),
(548, 1, 'sales', '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 2, 7, NULL, 548, 7111),
(549, 1, 'sales', '2024-06-30 00:00:00.000000', '2024-06-30 00:00:00.000000', 2, 7, NULL, 549, 6878),
(550, 1, 'sales', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 2, 7, NULL, 550, 6610),
(551, 1, 'sales', '2024-06-14 00:00:00.000000', '2024-06-14 00:00:00.000000', 2, 7, NULL, 551, 6483),
(552, 1, 'sales', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 2, 7, NULL, 552, 6236),
(553, 1, 'sales', '2024-07-27 00:00:00.000000', '2024-07-27 00:00:00.000000', 2, 7, NULL, 553, 6123),
(554, 1, 'sales', '2024-06-23 00:00:00.000000', '2024-06-23 00:00:00.000000', 2, 7, NULL, 554, 6003),
(555, 1, 'sales', '2024-07-13 00:00:00.000000', '2024-07-13 00:00:00.000000', 2, 7, NULL, 555, 5798),
(556, 1, 'sales', '2024-06-06 00:00:00.000000', '2024-06-06 00:00:00.000000', 2, 7, NULL, 556, 5588),
(557, 1, 'sales', '2024-07-07 00:00:00.000000', '2024-07-07 00:00:00.000000', 2, 7, NULL, 557, 5392),
(558, 1, 'sales', '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 2, 7, NULL, 558, 5280),
(559, 1, 'sales', '2024-07-16 00:00:00.000000', '2024-07-16 00:00:00.000000', 2, 7, NULL, 559, 5043),
(560, 1, 'sales', '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 2, 7, NULL, 560, 4902),
(561, 1, 'sales', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 2, 7, NULL, 561, 4615),
(562, 1, 'sales', '2024-07-04 00:00:00.000000', '2024-07-04 00:00:00.000000', 2, 7, NULL, 562, 4436),
(563, 1, 'sales', '2024-06-26 00:00:00.000000', '2024-06-26 00:00:00.000000', 2, 7, NULL, 563, 4217),
(564, 1, 'sales', '2024-06-14 00:00:00.000000', '2024-06-14 00:00:00.000000', 2, 7, NULL, 564, 4026),
(565, 1, 'sales', '2024-06-19 00:00:00.000000', '2024-06-19 00:00:00.000000', 2, 7, NULL, 565, 3862),
(566, 1, 'sales', '2024-07-08 00:00:00.000000', '2024-07-08 00:00:00.000000', 2, 7, NULL, 566, 3685),
(567, 1, 'sales', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 2, 7, NULL, 567, 3538),
(568, 1, 'sales', '2024-07-31 00:00:00.000000', '2024-07-31 00:00:00.000000', 2, 7, NULL, 568, 3292),
(569, 1, 'sales', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 2, 7, NULL, 569, 3183),
(570, 1, 'sales', '2024-06-01 00:00:00.000000', '2024-06-01 00:00:00.000000', 2, 7, NULL, 570, 2942),
(571, 1, 'sales', '2024-07-18 00:00:00.000000', '2024-07-18 00:00:00.000000', 2, 7, NULL, 571, 2750),
(572, 1, 'sales', '2024-06-25 00:00:00.000000', '2024-06-25 00:00:00.000000', 2, 7, NULL, 572, 2486),
(573, 1, 'sales', '2024-06-09 00:00:00.000000', '2024-06-09 00:00:00.000000', 2, 7, NULL, 573, 2314),
(574, 1, 'sales', '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 2, 7, NULL, 574, 2065),
(575, 1, 'sales', '2024-06-08 00:00:00.000000', '2024-06-08 00:00:00.000000', 2, 7, NULL, 575, 1826),
(576, 1, 'sales', '2024-06-30 00:00:00.000000', '2024-06-30 00:00:00.000000', 2, 7, NULL, 576, 1641),
(577, 1, 'sales', '2024-07-21 00:00:00.000000', '2024-07-21 00:00:00.000000', 2, 7, NULL, 577, 1429),
(578, 1, 'sales', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 2, 7, NULL, 578, 1286),
(579, 1, 'sales', '2024-06-06 00:00:00.000000', '2024-06-06 00:00:00.000000', 2, 7, NULL, 579, 1046),
(580, 1, 'sales', '2024-07-13 00:00:00.000000', '2024-07-13 00:00:00.000000', 2, 7, NULL, 580, 800),
(581, 1, 'sales', '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 2, 7, NULL, 581, 676),
(582, 1, 'sales', '2024-06-13 00:00:00.000000', '2024-06-13 00:00:00.000000', 2, 7, NULL, 582, 575),
(583, 1, 'sales', '2024-06-20 00:00:00.000000', '2024-06-20 00:00:00.000000', 2, 7, NULL, 583, 307),
(584, 1, 'sales', '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 2, 7, NULL, 584, 56),
(585, 1, 'sales', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 3, 7, NULL, 585, 6104),
(586, 1, 'sales', '2024-07-21 00:00:00.000000', '2024-07-21 00:00:00.000000', 3, 7, NULL, 586, 5867),
(587, 1, 'sales', '2024-07-21 00:00:00.000000', '2024-07-21 00:00:00.000000', 3, 7, NULL, 587, 5583),
(588, 1, 'sales', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 3, 7, NULL, 588, 5434),
(589, 1, 'sales', '2024-07-05 00:00:00.000000', '2024-07-05 00:00:00.000000', 3, 7, NULL, 589, 5158),
(590, 1, 'sales', '2024-07-03 00:00:00.000000', '2024-07-03 00:00:00.000000', 3, 7, NULL, 590, 4905),
(591, 1, 'sales', '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 3, 7, NULL, 591, 4785),
(592, 1, 'sales', '2024-07-13 00:00:00.000000', '2024-07-13 00:00:00.000000', 3, 7, NULL, 592, 4601),
(593, 1, 'sales', '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 3, 7, NULL, 593, 4475),
(594, 1, 'sales', '2024-06-28 00:00:00.000000', '2024-06-28 00:00:00.000000', 3, 7, NULL, 594, 4374),
(595, 1, 'sales', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 3, 7, NULL, 595, 4130),
(596, 1, 'sales', '2024-06-27 00:00:00.000000', '2024-06-27 00:00:00.000000', 3, 7, NULL, 596, 4026),
(597, 1, 'sales', '2024-06-10 00:00:00.000000', '2024-06-10 00:00:00.000000', 3, 7, NULL, 597, 3867),
(598, 1, 'sales', '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 3, 7, NULL, 598, 3658),
(599, 1, 'sales', '2024-06-11 00:00:00.000000', '2024-06-11 00:00:00.000000', 3, 7, NULL, 599, 3457),
(600, 1, 'sales', '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 3, 7, NULL, 600, 3277),
(601, 1, 'sales', '2024-07-22 00:00:00.000000', '2024-07-22 00:00:00.000000', 3, 7, NULL, 601, 3057),
(602, 1, 'sales', '2024-07-12 00:00:00.000000', '2024-07-12 00:00:00.000000', 3, 7, NULL, 602, 2896),
(603, 1, 'sales', '2024-07-31 00:00:00.000000', '2024-07-31 00:00:00.000000', 3, 7, NULL, 603, 2699),
(604, 1, 'sales', '2024-07-14 00:00:00.000000', '2024-07-14 00:00:00.000000', 3, 7, NULL, 604, 2576),
(605, 1, 'sales', '2024-07-20 00:00:00.000000', '2024-07-20 00:00:00.000000', 3, 7, NULL, 605, 2335),
(606, 1, 'sales', '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 3, 7, NULL, 606, 2218),
(607, 1, 'sales', '2024-07-16 00:00:00.000000', '2024-07-16 00:00:00.000000', 3, 7, NULL, 607, 1968),
(608, 1, 'sales', '2024-07-12 00:00:00.000000', '2024-07-12 00:00:00.000000', 3, 7, NULL, 608, 1719),
(609, 1, 'sales', '2024-07-08 00:00:00.000000', '2024-07-08 00:00:00.000000', 3, 7, NULL, 609, 1422),
(610, 1, 'sales', '2024-07-09 00:00:00.000000', '2024-07-09 00:00:00.000000', 3, 7, NULL, 610, 1196),
(611, 1, 'sales', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 3, 7, NULL, 611, 1029),
(612, 1, 'sales', '2024-07-02 00:00:00.000000', '2024-07-02 00:00:00.000000', 3, 7, NULL, 612, 842),
(613, 1, 'sales', '2024-07-17 00:00:00.000000', '2024-07-17 00:00:00.000000', 3, 7, NULL, 613, 569),
(614, 1, 'sales', '2024-06-15 00:00:00.000000', '2024-06-15 00:00:00.000000', 3, 7, NULL, 614, 341),
(615, 1, 'sales', '2024-06-02 00:00:00.000000', '2024-06-02 00:00:00.000000', 3, 7, NULL, 615, 45),
(616, 1, 'sales', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 4, 7, NULL, 616, 2051),
(617, 1, 'sales', '2024-07-24 00:00:00.000000', '2024-07-24 00:00:00.000000', 4, 7, NULL, 617, 1938),
(618, 1, 'sales', '2024-07-14 00:00:00.000000', '2024-07-14 00:00:00.000000', 4, 7, NULL, 618, 1680),
(619, 1, 'sales', '2024-07-28 00:00:00.000000', '2024-07-28 00:00:00.000000', 4, 7, NULL, 619, 1385),
(620, 1, 'sales', '2024-06-06 00:00:00.000000', '2024-06-06 00:00:00.000000', 4, 7, NULL, 620, 1280),
(621, 1, 'sales', '2024-07-01 00:00:00.000000', '2024-07-01 00:00:00.000000', 4, 7, NULL, 621, 1120),
(622, 1, 'sales', '2024-07-10 00:00:00.000000', '2024-07-10 00:00:00.000000', 4, 7, NULL, 622, 825),
(623, 1, 'sales', '2024-06-30 00:00:00.000000', '2024-06-30 00:00:00.000000', 4, 7, NULL, 623, 672),
(624, 1, 'sales', '2024-06-06 00:00:00.000000', '2024-06-06 00:00:00.000000', 4, 7, NULL, 624, 418),
(625, 1, 'sales', '2024-06-18 00:00:00.000000', '2024-06-18 00:00:00.000000', 4, 7, NULL, 625, 256),
(626, 1, 'sales', '2024-07-21 00:00:00.000000', '2024-07-21 00:00:00.000000', 4, 7, NULL, 626, 13),
(627, 1, 'sales', '2024-06-21 00:00:00.000000', '2024-06-21 00:00:00.000000', 5, 7, NULL, 627, 298),
(628, 1, 'sales', '2024-06-29 00:00:00.000000', '2024-06-29 00:00:00.000000', 5, 7, NULL, 628, 61);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indexes for table `auth_user`
--
ALTER TABLE `auth_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  ADD KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`);

--
-- Indexes for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  ADD KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`);

--
-- Indexes for table `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indexes for table `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD KEY `employee_outlet_id_cfdd65ab_fk_outlets_id` (`outlet_id`);

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `materials`
--
ALTER TABLE `materials`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `outlets`
--
ALTER TABLE `outlets`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `outlet_items`
--
ALTER TABLE `outlet_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `outlet_items_outlet_id_item_id_9a7b963a_uniq` (`outlet_id`,`item_id`),
  ADD KEY `outlet_items_item_id_af58b3e0_fk_items_id` (`item_id`);

--
-- Indexes for table `productions`
--
ALTER TABLE `productions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `productions_item_id_4156545d_fk_items_id` (`item_id`),
  ADD KEY `productions_outlet_id_35aad789_fk_outlets_id` (`outlet_id`);

--
-- Indexes for table `purchases`
--
ALTER TABLE `purchases`
  ADD PRIMARY KEY (`id`),
  ADD KEY `purchases_item_id_674e01f1_fk_items_id` (`item_id`),
  ADD KEY `purchases_outlet_id_c7300c4f_fk` (`outlet_id`);

--
-- Indexes for table `recipes`
--
ALTER TABLE `recipes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `recipes_item_id_3bd4bdaa_fk_items_id` (`item_id`),
  ADD KEY `recipes_material_id_0ae2771c_fk_materials_id` (`material_id`),
  ADD KEY `recipes_outlet_id_ff86729f_fk_outlets_id` (`outlet_id`);

--
-- Indexes for table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sales_item_id_e1e0f548_fk_items_id` (`item_id`),
  ADD KEY `sales_outlet_id_fba613ae_fk` (`outlet_id`),
  ADD KEY `sales_buyer_id_b929033d_fk_outlets_id` (`buyer_id`);

--
-- Indexes for table `stocks`
--
ALTER TABLE `stocks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `stocks_item_id_31ab3a71_fk_items_id` (`item_id`),
  ADD KEY `stocks_outlet_id_a3ac7af5_fk_outlets_id` (`outlet_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `transactions_item_id_6817dd0b_fk_items_id` (`item_id`),
  ADD KEY `transactions_purchase_id_96a24f1f_fk_purchases_id` (`purchase_id`),
  ADD KEY `transactions_sales_id_c965e09f_fk_sales_id` (`sales_id`),
  ADD KEY `transactions_outlet_id_7d089f78_fk` (`outlet_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;

--
-- AUTO_INCREMENT for table `auth_user`
--
ALTER TABLE `auth_user`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `employee`
--
ALTER TABLE `employee`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `materials`
--
ALTER TABLE `materials`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `outlets`
--
ALTER TABLE `outlets`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `outlet_items`
--
ALTER TABLE `outlet_items`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `productions`
--
ALTER TABLE `productions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `purchases`
--
ALTER TABLE `purchases`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=278;

--
-- AUTO_INCREMENT for table `recipes`
--
ALTER TABLE `recipes`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=629;

--
-- AUTO_INCREMENT for table `stocks`
--
ALTER TABLE `stocks`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=629;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `employee`
--
ALTER TABLE `employee`
  ADD CONSTRAINT `employee_outlet_id_cfdd65ab_fk_outlets_id` FOREIGN KEY (`outlet_id`) REFERENCES `outlets` (`id`),
  ADD CONSTRAINT `inventory_employee_user_id_df4f6208_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `outlet_items`
--
ALTER TABLE `outlet_items`
  ADD CONSTRAINT `outlet_items_item_id_af58b3e0_fk_items_id` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  ADD CONSTRAINT `outlet_items_outlet_id_8abdbe4e_fk_outlets_id` FOREIGN KEY (`outlet_id`) REFERENCES `outlets` (`id`);

--
-- Constraints for table `productions`
--
ALTER TABLE `productions`
  ADD CONSTRAINT `productions_item_id_4156545d_fk_items_id` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  ADD CONSTRAINT `productions_outlet_id_35aad789_fk_outlets_id` FOREIGN KEY (`outlet_id`) REFERENCES `outlets` (`id`);

--
-- Constraints for table `purchases`
--
ALTER TABLE `purchases`
  ADD CONSTRAINT `purchases_item_id_674e01f1_fk_items_id` FOREIGN KEY (`item_id`) REFERENCES `materials` (`id`),
  ADD CONSTRAINT `purchases_outlet_id_c7300c4f_fk` FOREIGN KEY (`outlet_id`) REFERENCES `outlets` (`id`);

--
-- Constraints for table `recipes`
--
ALTER TABLE `recipes`
  ADD CONSTRAINT `recipes_item_id_3bd4bdaa_fk_items_id` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  ADD CONSTRAINT `recipes_material_id_0ae2771c_fk_materials_id` FOREIGN KEY (`material_id`) REFERENCES `materials` (`id`),
  ADD CONSTRAINT `recipes_outlet_id_ff86729f_fk_outlets_id` FOREIGN KEY (`outlet_id`) REFERENCES `outlets` (`id`);

--
-- Constraints for table `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_buyer_id_b929033d_fk_outlets_id` FOREIGN KEY (`buyer_id`) REFERENCES `outlets` (`id`),
  ADD CONSTRAINT `sales_item_id_e1e0f548_fk_items_id` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  ADD CONSTRAINT `sales_outlet_id_fba613ae_fk` FOREIGN KEY (`outlet_id`) REFERENCES `outlets` (`id`);

--
-- Constraints for table `stocks`
--
ALTER TABLE `stocks`
  ADD CONSTRAINT `stocks_item_id_31ab3a71_fk_items_id` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  ADD CONSTRAINT `stocks_outlet_id_a3ac7af5_fk_outlets_id` FOREIGN KEY (`outlet_id`) REFERENCES `outlets` (`id`);

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_item_id_6817dd0b_fk_items_id` FOREIGN KEY (`item_id`) REFERENCES `materials` (`id`),
  ADD CONSTRAINT `transactions_outlet_id_7d089f78_fk` FOREIGN KEY (`outlet_id`) REFERENCES `outlets` (`id`),
  ADD CONSTRAINT `transactions_purchase_id_96a24f1f_fk_purchases_id` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`),
  ADD CONSTRAINT `transactions_sales_id_c965e09f_fk_sales_id` FOREIGN KEY (`sales_id`) REFERENCES `sales` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
