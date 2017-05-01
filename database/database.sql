-- MySQL Script generated by MySQL Workbench
-- Mon May  1 21:36:00 2017
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema reservation_service
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema reservation_service
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `reservation_service` DEFAULT CHARACTER SET utf8 ;
USE `reservation_service` ;

-- -----------------------------------------------------
-- Table `reservation_service`.`laboratory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `reservation_service`.`laboratory` (
  `id` BIGINT(8) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `duration` TIME NOT NULL,
  `group` VARCHAR(33) NOT NULL COMMENT 'group - OpenStack group id\n',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `reservation_service`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `reservation_service`.`users` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user` VARCHAR(33) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `reservation_service`.`team`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `reservation_service`.`team` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `users_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_team_users1_idx` (`users_id` ASC),
  CONSTRAINT `fk_team_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `reservation_service`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `reservation_service`.`reservation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `reservation_service`.`reservation` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NULL,
  `start` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tenat_id` VARCHAR(45) NULL,
  `status` ENUM('active', 'nonactive', 'building') NULL DEFAULT 'nonactive',
  `users_id` BIGINT NOT NULL,
  `team_id` BIGINT NOT NULL,
  `laboratory_id` BIGINT(8) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_reservation_users1_idx` (`users_id` ASC),
  INDEX `fk_reservation_team1_idx` (`team_id` ASC),
  INDEX `fk_reservation_laboratory1_idx` (`laboratory_id` ASC),
  UNIQUE INDEX `tenat_id_UNIQUE` (`tenat_id` ASC),
  CONSTRAINT `fk_reservation_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `reservation_service`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reservation_team1`
    FOREIGN KEY (`team_id`)
    REFERENCES `reservation_service`.`team` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reservation_laboratory1`
    FOREIGN KEY (`laboratory_id`)
    REFERENCES `reservation_service`.`laboratory` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `reservation_service`.`template`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `reservation_service`.`template` (
  `id` BIGINT(8) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(250) NOT NULL,
  `data` TEXT NOT NULL,
  `laboratory_id` BIGINT(8) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC),
  INDEX `fk_template_laboratory1_idx` (`laboratory_id` ASC),
  CONSTRAINT `fk_template_laboratory1`
    FOREIGN KEY (`laboratory_id`)
    REFERENCES `reservation_service`.`laboratory` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `reservation_service`.`periods`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `reservation_service`.`periods` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `start` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `stop` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `laboratory_id` BIGINT(8) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_periods_laboratory1_idx` (`laboratory_id` ASC),
  CONSTRAINT `fk_periods_laboratory1`
    FOREIGN KEY (`laboratory_id`)
    REFERENCES `reservation_service`.`laboratory` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `reservation_service`.`system`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `reservation_service`.`system` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `project` VARCHAR(45) NULL,
  `role_lab` VARCHAR(45) NULL,
  `role_student` VARCHAR(45) NULL,
  `role_moderator` VARCHAR(45) NULL,
  `group_student` VARCHAR(45) NULL,
  `group_moderator` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
