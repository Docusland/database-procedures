-- MySQL Script generated by MySQL Workbench
-- Thu Jul  2 15:09:11 2020
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`pays`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`pays` ;

CREATE TABLE IF NOT EXISTS `mydb`.`pays` (
  `id_pays` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id_pays`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`categorie`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`categorie` ;

CREATE TABLE IF NOT EXISTS `mydb`.`categorie` (
  `id_categorie` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_categorie`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`groupes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`groupes` ;

CREATE TABLE IF NOT EXISTS `mydb`.`groupes` (
  `id_groupe` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `tarif` FLOAT NULL,
  `description` LONGTEXT NULL,
  `pays_id_pays` INT NOT NULL,
  `categorie_id_categorie` INT NOT NULL,
  PRIMARY KEY (`id_groupe`),
  UNIQUE INDEX `id_UNIQUE` (`id_groupe` ASC) ,
  INDEX `fk_groupes_pays1_idx` (`pays_id_pays` ASC) ,
  INDEX `fk_groupes_categorie1_idx` (`categorie_id_categorie` ASC) ,
  CONSTRAINT `fk_groupes_pays1`
    FOREIGN KEY (`pays_id_pays`)
    REFERENCES `mydb`.`pays` (`id_pays`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_groupes_categorie1`
    FOREIGN KEY (`categorie_id_categorie`)
    REFERENCES `mydb`.`categorie` (`id_categorie`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`musiciens`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`musiciens` ;

CREATE TABLE IF NOT EXISTS `mydb`.`musiciens` (
  `id_musicien` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(100) NOT NULL,
  `prenom` VARCHAR(100) NULL,
  `descriptif` LONGTEXT NULL,
  PRIMARY KEY (`id_musicien`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`photos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`photos` ;

CREATE TABLE IF NOT EXISTS `mydb`.`photos` (
  `id_photos` INT NOT NULL AUTO_INCREMENT,
  `photo` VARCHAR(255) NULL,
  `groupes_id_groupe` INT NOT NULL,
  PRIMARY KEY (`id_photos`),
  INDEX `fk_photos_groupes1_idx` (`groupes_id_groupe` ASC) ,
  CONSTRAINT `fk_photos_groupes1`
    FOREIGN KEY (`groupes_id_groupe`)
    REFERENCES `mydb`.`groupes` (`id_groupe`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`instruments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`instruments` ;

CREATE TABLE IF NOT EXISTS `mydb`.`instruments` (
  `id_instrument` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id_instrument`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`musiciens_instruments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`musiciens_instruments` ;

CREATE TABLE IF NOT EXISTS `mydb`.`musiciens_instruments` (
  `musiciens_id_musicien` INT NOT NULL,
  `instruments_id_instrument` INT NOT NULL,
  PRIMARY KEY (`musiciens_id_musicien`, `instruments_id_instrument`),
  INDEX `fk_musiciens_has_instruments_instruments1_idx` (`instruments_id_instrument` ASC) ,
  INDEX `fk_musiciens_has_instruments_musiciens1_idx` (`musiciens_id_musicien` ASC) ,
  CONSTRAINT `fk_musiciens_has_instruments_musiciens1`
    FOREIGN KEY (`musiciens_id_musicien`)
    REFERENCES `mydb`.`musiciens` (`id_musicien`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_musiciens_has_instruments_instruments1`
    FOREIGN KEY (`instruments_id_instrument`)
    REFERENCES `mydb`.`instruments` (`id_instrument`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`groupes_musiciens`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`groupes_musiciens` ;

CREATE TABLE IF NOT EXISTS `mydb`.`groupes_musiciens` (
  `groupes_id_groupe` INT NOT NULL,
  `musiciens_id_musicien` INT NOT NULL,
  PRIMARY KEY (`groupes_id_groupe`, `musiciens_id_musicien`),
  INDEX `fk_groupes_has_musiciens_musiciens1_idx` (`musiciens_id_musicien` ASC) ,
  INDEX `fk_groupes_has_musiciens_groupes1_idx` (`groupes_id_groupe` ASC) ,
  CONSTRAINT `fk_groupes_has_musiciens_groupes1`
    FOREIGN KEY (`groupes_id_groupe`)
    REFERENCES `mydb`.`groupes` (`id_groupe`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_groupes_has_musiciens_musiciens1`
    FOREIGN KEY (`musiciens_id_musicien`)
    REFERENCES `mydb`.`musiciens` (`id_musicien`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`groupes_instruments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`groupes_instruments` ;

CREATE TABLE IF NOT EXISTS `mydb`.`groupes_instruments` (
  `groupes_id_groupe` INT NOT NULL,
  `instruments_id_instrument` INT NOT NULL,
  PRIMARY KEY (`groupes_id_groupe`, `instruments_id_instrument`),
  INDEX `fk_groupes_has_instruments_instruments1_idx` (`instruments_id_instrument` ASC) ,
  INDEX `fk_groupes_has_instruments_groupes1_idx` (`groupes_id_groupe` ASC) ,
  CONSTRAINT `fk_groupes_has_instruments_groupes1`
    FOREIGN KEY (`groupes_id_groupe`)
    REFERENCES `mydb`.`groupes` (`id_groupe`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_groupes_has_instruments_instruments1`
    FOREIGN KEY (`instruments_id_instrument`)
    REFERENCES `mydb`.`instruments` (`id_instrument`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
