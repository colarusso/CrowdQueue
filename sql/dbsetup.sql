-- phpMyAdmin SQL Dump
-- version 2.11.11.3
-- http://www.phpmyadmin.net
--
-- Host: 45.40.164.17
-- Generation Time: Mar 20, 2016 at 06:44 PM
-- Server version: 5.5.43
-- PHP Version: 5.1.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `crowdqueue`
--

-- --------------------------------------------------------

--
-- Table structure for table `questions`
--

CREATE TABLE `questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` int(11) NOT NULL,
  `session` int(11) NOT NULL,
  `votes` int(11) NOT NULL DEFAULT '0',
  `ups` int(11) NOT NULL DEFAULT '0',
  `downs` int(11) NOT NULL DEFAULT '0',
  `score` float NOT NULL DEFAULT '0.5',
  `mid_score` float NOT NULL,
  `content` longtext CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=171 ;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `code` varchar(11) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `title` varchar(200) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `type` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `length` float NOT NULL,
  `maxpp` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=58 ;

-- --------------------------------------------------------

--
-- Table structure for table `session_user`
--

CREATE TABLE `session_user` (
  `session` int(11) NOT NULL,
  `user` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`session`,`user`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hex` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1161 ;

-- --------------------------------------------------------

--
-- Table structure for table `votes`
--

CREATE TABLE `votes` (
  `user` int(11) NOT NULL,
  `session` int(11) NOT NULL,
  `question` int(11) NOT NULL,
  `vote` float NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user`,`question`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
