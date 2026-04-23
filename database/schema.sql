-- UJ Campus Finder — Starter Database Schema
-- This is a draft structure. Team members will finalize columns and constraints.

CREATE DATABASE IF NOT EXISTS lost_found_db;
USE lost_found_db;

-- --------------------------------------------------------
-- Table: reports
-- Stores lost and found item reports submitted by students
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS reports (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    type        ENUM('lost', 'found') NOT NULL,
    title       VARCHAR(150)          NOT NULL,
    description TEXT,
    location    VARCHAR(200),
    image_path  VARCHAR(300),          -- optional image upload
    contact     VARCHAR(100),
    status      ENUM('open', 'resolved') NOT NULL DEFAULT 'open',
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------
-- Table: claim_requests
-- Stores requests from students claiming a found item
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS claim_requests (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    report_id   INT          NOT NULL,
    claimant    VARCHAR(100) NOT NULL,
    message     TEXT,
    status      ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (report_id) REFERENCES reports(id) ON DELETE CASCADE
);

-- --------------------------------------------------------
-- Table: contact_messages
-- Stores help/contact form submissions
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS contact_messages (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    email      VARCHAR(150) NOT NULL,
    subject    VARCHAR(200),
    message    TEXT         NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
