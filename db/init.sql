CREATE DATABASE IF NOT EXISTS innovatech;
USE innovatech;

CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL
);

-- Innovatech Database Initialization Script
-- Version 1.1