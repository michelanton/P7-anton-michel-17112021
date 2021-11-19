-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : ven. 19 nov. 2021 à 20:15
-- Version du serveur :  5.7.31
-- Version de PHP : 7.3.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `groupomania`
--

-- --------------------------------------------------------

--
-- Structure de la table `comments`
--

DROP TABLE IF EXISTS `comments`;
CREATE TABLE IF NOT EXISTS `comments` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL,
  `post_id` int(10) UNSIGNED NOT NULL,
  `comment` text NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `post_id` (`post_id`) USING BTREE,
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `comments`
--

INSERT INTO `comments` (`id`, `user_id`, `post_id`, `comment`, `date`) VALUES
(3, 132, 143, 'désolé, ce week-end j\'ai piscine...', '2021-11-14 21:03:49'),
(4, 133, 144, 'haha, moi aussi, mais sur le parking... ', '2021-11-14 21:05:54'),
(5, 133, 143, 'moi, j\'suis partant', '2021-11-14 21:06:12'),
(6, 134, 143, 'moi aussi , j\'en suis.', '2021-11-14 21:09:55'),
(7, 134, 145, 'oui... on est là', '2021-11-14 21:10:23'),
(8, 131, 145, 't pas tout seul Michel... t pas tout seul...', '2021-11-14 21:11:16'),
(10, 132, 145, 'vazy, entre... tu veux un café.. ?', '2021-11-14 21:13:21'),
(24, 131, 143, 'moi aussi.. j\'suis partent\n', '2021-11-15 19:00:34'),
(25, 131, 145, 'coucou', '2021-11-15 19:00:50'),
(28, 131, 143, 'alléé\n', '2021-11-17 00:32:11'),
(29, 146, 154, 'moi je veux bien... ', '2021-11-17 14:47:56');

-- --------------------------------------------------------

--
-- Structure de la table `posts`
--

DROP TABLE IF EXISTS `posts`;
CREATE TABLE IF NOT EXISTS `posts` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text,
  `media_url` varchar(150) DEFAULT NULL,
  `link` varchar(100) DEFAULT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=161 DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `posts`
--

INSERT INTO `posts` (`id`, `user_id`, `title`, `description`, `media_url`, `link`, `date`) VALUES
(143, 131, '\"Bowling\"', '\"qui pour un bowling ce week-end ??\"', 'http://localhost:3000/images/gif-sport.gif1636920055454.gif', NULL, '2021-11-14 21:00:55'),
(144, 132, '\"Chasse aux pokémons\"', '\"J\'ai attraper un pokémon devant la machine a café...\\nGG ..\"', 'http://localhost:3000/images/gif-manga.gif1636920200286.gif', NULL, '2021-11-14 21:03:20'),
(145, 133, '\"COUCOU\"', '\"Y-a quelqu\'un ??????\"', 'http://localhost:3000/images/gifs-humour-20.gif1636920311023.gif', NULL, '2021-11-14 21:05:11'),
(146, 134, '\"la pénurie !\"', '\"distributeur vide...  que fait la police ?\\nSniff\"', 'http://localhost:3000/images/rigolo021.gif1636920560424.gif', NULL, '2021-11-14 21:09:20'),
(154, 145, '\"covoiturage\"', '\"allé, on le fait !!!\\nquelqu\'un que ca intéresse\\n\"', 'http://localhost:3000/images/81x81-22537.gif1637004835770.gif', NULL, '2021-11-15 20:33:55');

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `pseudo` varchar(25) NOT NULL,
  `avatar_url` varchar(300) DEFAULT NULL,
  `date_user` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=148 DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `pseudo`, `avatar_url`, `date_user`) VALUES
(128, 'moderateur@groupomania.com', '$2b$10$OxQlXvV5A6Fc.5eA38vCr.n55U6r.vix800c7UWeMN.jQmmC.H1Au', 'MODERATEUR', 'http://localhost:3000/images/télécharger_(2).jfif1636857989542.jpg', '2021-11-14 03:46:29'),
(131, 'lulu@groupomania.com', '$2b$10$UOMcCATMd1KLBw78gkxVReSngEejZcJcBddOY1oHTy3Ezjd8Ke2uS', 'LULU', 'http://localhost:3000/images/gif-papillons-10.gif1636919674655.gif', '2021-11-14 20:54:34'),
(132, 'patrick@groupomania.com', '$2b$10$n9DRwZXZRdcxcpOI.CTBceITXLWxmLTERiSMtS5IWcshnhouVsgYa', 'PATRICK', 'http://localhost:3000/images/400-figurine-funko-pop-son-of-zorn-zorn-defender-of-zypheria-with-hot-sauce.jpg1636920109361.jpg', '2021-11-14 21:01:49'),
(133, 'michel@groupomania.com', '$2b$10$VJJRxbc3hx94ooxuwsdzo.bh1Bp127W6czv6aCDsKKr22.d4c9J8.', 'Michel', 'http://localhost:3000/images/gif-emoticone-13.gif1636920273301.gif', '2021-11-14 21:04:33'),
(134, 'valerie@groupomania.com', '$2b$10$.B6FQvWsLE8zyTJw2kpileAIy/1ypoN.osuy1nMQft.rve0mBZm1K', 'Val', 'http://localhost:3000/images/images.jfif1636920441681.jpg', '2021-11-14 21:07:21'),
(145, 'miriam@groupomania.com', '$2b$10$O/JukrsI8Tjeqwhhb8oZSOkmHD9nWDiYGMFFtVr9XF7025bUDMl9.', 'Miriam', 'http://localhost:3000/images/télécharger_(1).jfif1637004736419.jpg', '2021-11-15 20:32:16'),
(146, 'kevin@groupomania.com', '$2b$10$OwWSprlqoWt85y.1L4sriu/VJTlkSj4uOd3FYwfgf3cLDVCu3yvYm', 'Kevin', 'http://localhost:3000/images/coolSauce.JPG1637140855584.jpg', '2021-11-17 10:20:55');

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
