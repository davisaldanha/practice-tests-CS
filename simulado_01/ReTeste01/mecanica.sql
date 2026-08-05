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
-- Table `mydb`.`cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`cliente` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `endereco` VARCHAR(100) NULL,
  `contato` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`veiculos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`veiculos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `placa` VARCHAR(15) NOT NULL,
  `modelo` VARCHAR(45) NOT NULL,
  `marca` VARCHAR(45) NOT NULL,
  `ano` INT NOT NULL,
  `cor` VARCHAR(45) NOT NULL,
  `cliente_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_veiculos_cliente_idx` (`cliente_id` ASC) VISIBLE,
  CONSTRAINT `fk_veiculos_cliente`
    FOREIGN KEY (`cliente_id`)
    REFERENCES `mydb`.`cliente` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ordem_servico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ordem_servico` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `data_abertura` DATETIME NULL,
  `data_conclusao_previsto` DATETIME NOT NULL,
  `data_conclusao_real` DATETIME NULL,
  `status` VARCHAR(45) NULL,
  `veiculos_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_ordem_servico_veiculos1_idx` (`veiculos_id` ASC) VISIBLE,
  CONSTRAINT `fk_ordem_servico_veiculos1`
    FOREIGN KEY (`veiculos_id`)
    REFERENCES `mydb`.`veiculos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`servicos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`servicos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `tempo_estimado` VARCHAR(45) NOT NULL,
  `valor_mao_obra` FLOAT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`fornecedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`fornecedor` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NULL,
  `endereco` VARCHAR(100) NULL,
  `contato` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`pecas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`pecas` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NULL,
  `quantidade` INT NULL,
  `preco` FLOAT NULL,
  `fornecedor_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_pecas_fornecedor1_idx` (`fornecedor_id` ASC) VISIBLE,
  CONSTRAINT `fk_pecas_fornecedor1`
    FOREIGN KEY (`fornecedor_id`)
    REFERENCES `mydb`.`fornecedor` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`pecas_ordem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`pecas_ordem` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `quantidade` INT NULL,
  `preco` FLOAT NULL,
  `pecas_id` INT NOT NULL,
  `servicos_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_pecas_ordem_pecas1_idx` (`pecas_id` ASC) VISIBLE,
  INDEX `fk_pecas_ordem_servicos1_idx` (`servicos_id` ASC) VISIBLE,
  CONSTRAINT `fk_pecas_ordem_pecas1`
    FOREIGN KEY (`pecas_id`)
    REFERENCES `mydb`.`pecas` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pecas_ordem_servicos1`
    FOREIGN KEY (`servicos_id`)
    REFERENCES `mydb`.`servicos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`mecanicos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`mecanicos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NULL,
  `contato` VARCHAR(45) NULL,
  `mecanicos_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_mecanicos_mecanicos1_idx` (`mecanicos_id` ASC) VISIBLE,
  CONSTRAINT `fk_mecanicos_mecanicos1`
    FOREIGN KEY (`mecanicos_id`)
    REFERENCES `mydb`.`mecanicos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`servico_realizado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`servico_realizado` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `valor_mao_obra` FLOAT NOT NULL,
  `ordem_servico_id` INT NOT NULL,
  `servicos_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_servico_realizado_ordem_servico1_idx` (`ordem_servico_id` ASC) VISIBLE,
  INDEX `fk_servico_realizado_servicos1_idx` (`servicos_id` ASC) VISIBLE,
  CONSTRAINT `fk_servico_realizado_ordem_servico1`
    FOREIGN KEY (`ordem_servico_id`)
    REFERENCES `mydb`.`ordem_servico` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_servico_realizado_servicos1`
    FOREIGN KEY (`servicos_id`)
    REFERENCES `mydb`.`servicos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`mecanico_ordem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`mecanico_ordem` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `mecanicos_id` INT NOT NULL,
  `ordem_servico_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_mecanico_ordem_mecanicos1_idx` (`mecanicos_id` ASC) VISIBLE,
  INDEX `fk_mecanico_ordem_ordem_servico1_idx` (`ordem_servico_id` ASC) VISIBLE,
  CONSTRAINT `fk_mecanico_ordem_mecanicos1`
    FOREIGN KEY (`mecanicos_id`)
    REFERENCES `mydb`.`mecanicos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_mecanico_ordem_ordem_servico1`
    FOREIGN KEY (`ordem_servico_id`)
    REFERENCES `mydb`.`ordem_servico` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`especialidades`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`especialidades` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`mecanico_especialidade`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`mecanico_especialidade` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `especialidades_id` INT NOT NULL,
  `mecanicos_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_mecanico_especialidade_especialidades1_idx` (`especialidades_id` ASC) VISIBLE,
  INDEX `fk_mecanico_especialidade_mecanicos1_idx` (`mecanicos_id` ASC) VISIBLE,
  CONSTRAINT `fk_mecanico_especialidade_especialidades1`
    FOREIGN KEY (`especialidades_id`)
    REFERENCES `mydb`.`especialidades` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_mecanico_especialidade_mecanicos1`
    FOREIGN KEY (`mecanicos_id`)
    REFERENCES `mydb`.`mecanicos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`avaliacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`avaliacao` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nota` INT NULL,
  `comentario` VARCHAR(255) NULL,
  `ordem_servico_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_avaliacao_ordem_servico1_idx` (`ordem_servico_id` ASC) VISIBLE,
  UNIQUE INDEX `ordem_servico_id_UNIQUE` (`ordem_servico_id` ASC) VISIBLE,
  CONSTRAINT `fk_avaliacao_ordem_servico1`
    FOREIGN KEY (`ordem_servico_id`)
    REFERENCES `mydb`.`ordem_servico` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
