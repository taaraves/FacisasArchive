CREATE DATABASE  IF NOT EXISTS `facisas_archive` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `facisas_archive`;
-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: facisas_archive
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `emprestimos`
--

DROP TABLE IF EXISTS `emprestimos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emprestimos` (
  `id_emprestimo` int NOT NULL AUTO_INCREMENT,
  `id_usuario_fk` int NOT NULL,
  `id_livro_fk` int NOT NULL,
  `data_saida` datetime DEFAULT CURRENT_TIMESTAMP,
  `data_prevista` date NOT NULL,
  `data_devolucao` datetime DEFAULT NULL,
  PRIMARY KEY (`id_emprestimo`),
  KEY `id_usuario_fk` (`id_usuario_fk`),
  KEY `id_livro_fk` (`id_livro_fk`),
  CONSTRAINT `emprestimos_ibfk_1` FOREIGN KEY (`id_usuario_fk`) REFERENCES `usuarios` (`id_usuario`),
  CONSTRAINT `emprestimos_ibfk_2` FOREIGN KEY (`id_livro_fk`) REFERENCES `livros` (`id_livro`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emprestimos`
--

LOCK TABLES `emprestimos` WRITE;
/*!40000 ALTER TABLE `emprestimos` DISABLE KEYS */;
INSERT INTO `emprestimos` VALUES (1,1,1,'2026-06-22 16:25:19','2026-06-29',NULL);
/*!40000 ALTER TABLE `emprestimos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_trava_horario_comercial` BEFORE INSERT ON `emprestimos` FOR EACH ROW BEGIN
    IF HOUR(CURTIME()) < 8 OR HOUR(CURTIME()) >= 18 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Operação negada! Fora do horário comercial (08h-18h).';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_limite_emprestimos` BEFORE INSERT ON `emprestimos` FOR EACH ROW BEGIN
    DECLARE v_qtd_ativos INT; DECLARE v_tipo_usuario VARCHAR(20);
    SELECT tipo INTO v_tipo_usuario FROM usuarios WHERE id_usuario = NEW.id_usuario_fk;
    SELECT COUNT(*) INTO v_qtd_ativos FROM emprestimos WHERE id_usuario_fk = NEW.id_usuario_fk AND data_devolucao IS NULL;
    IF v_tipo_usuario = 'ALUNO' AND v_qtd_ativos >= 3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Limite excedido! O aluno já possui 3 livros pendentes.'; END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `enderecos`
--

DROP TABLE IF EXISTS `enderecos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enderecos` (
  `id_endereco` int NOT NULL AUTO_INCREMENT,
  `logradouro` varchar(200) NOT NULL,
  `bairro` varchar(100) NOT NULL,
  `cidade` varchar(100) NOT NULL,
  `uf` char(2) NOT NULL,
  `id_usuario_fk` int NOT NULL,
  PRIMARY KEY (`id_endereco`),
  KEY `id_usuario_fk` (`id_usuario_fk`),
  CONSTRAINT `enderecos_ibfk_1` FOREIGN KEY (`id_usuario_fk`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enderecos`
--

LOCK TABLES `enderecos` WRITE;
/*!40000 ALTER TABLE `enderecos` DISABLE KEYS */;
/*!40000 ALTER TABLE `enderecos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `livros`
--

DROP TABLE IF EXISTS `livros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `livros` (
  `id_livro` int NOT NULL AUTO_INCREMENT,
  `titulo` varchar(200) NOT NULL,
  `autor` varchar(150) NOT NULL,
  `isbn` varchar(20) NOT NULL,
  `preco_custo` decimal(10,2) NOT NULL,
  `quantidade_estoque` int NOT NULL DEFAULT '0',
  `status` varchar(20) DEFAULT 'DISPONIVEL',
  PRIMARY KEY (`id_livro`),
  UNIQUE KEY `isbn` (`isbn`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `livros`
--

LOCK TABLES `livros` WRITE;
/*!40000 ALTER TABLE `livros` DISABLE KEYS */;
INSERT INTO `livros` VALUES (1,'Clean Code','Robert C. Martin','978013235',150.00,2,'DISPONIVEL'),(5,'Copa Pistão - O Inimigo Agora é Outro','Relampago Marquinhos','789456123789',89.80,70,'DISPONIVEL');
/*!40000 ALTER TABLE `livros` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_preventiva_estoque` BEFORE UPDATE ON `livros` FOR EACH ROW BEGIN
    IF NEW.quantidade_estoque < 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro Crítico: Estoque não pode ficar negativo.'; END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_auditoria_delecao` AFTER DELETE ON `livros` FOR EACH ROW BEGIN
    INSERT INTO log_auditoria (tabela_afetada, acao, usuario_responsavel, dados_antigos)
    VALUES ('livros', 'DELETE', USER(), CONCAT('ID: ', OLD.id_livro, ' | Titulo: ', OLD.titulo, ' | Preco: ', OLD.preco_custo));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `log_auditoria`
--

DROP TABLE IF EXISTS `log_auditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_auditoria` (
  `id_log` int NOT NULL AUTO_INCREMENT,
  `tabela_afetada` varchar(50) NOT NULL,
  `acao` varchar(50) NOT NULL,
  `usuario_responsavel` varchar(100) NOT NULL,
  `dados_antigos` text,
  `data_hora` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_auditoria`
--

LOCK TABLES `log_auditoria` WRITE;
/*!40000 ALTER TABLE `log_auditoria` DISABLE KEYS */;
INSERT INTO `log_auditoria` VALUES (1,'livros','DELETE','root@localhost','ID: 2 | Titulo: Sistemas de Banco de Dados | Preco: 200.00','2026-06-10 02:29:24'),(2,'livros','DELETE','usr_gerente@localhost','ID: 3 | Titulo: Clube de Pandoca | Preco: 45.56','2026-06-17 22:52:01'),(3,'livros','DELETE','usr_gerente@localhost','ID: 4 | Titulo: Copa Pistão | Preco: 45.55','2026-06-18 21:26:22'),(4,'livros','DELETE','usr_gerente@localhost','ID: 6 | Titulo: Copa Pitsão - O retorno | Preco: 50.55','2026-06-18 22:11:57');
/*!40000 ALTER TABLE `log_auditoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `multas`
--

DROP TABLE IF EXISTS `multas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `multas` (
  `id_multa` int NOT NULL AUTO_INCREMENT,
  `id_emprestimo_fk` int NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `pago` tinyint DEFAULT '0',
  PRIMARY KEY (`id_multa`),
  KEY `id_emprestimo_fk` (`id_emprestimo_fk`),
  CONSTRAINT `multas_ibfk_1` FOREIGN KEY (`id_emprestimo_fk`) REFERENCES `emprestimos` (`id_emprestimo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `multas`
--

LOCK TABLES `multas` WRITE;
/*!40000 ALTER TABLE `multas` DISABLE KEYS */;
/*!40000 ALTER TABLE `multas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) NOT NULL,
  `cpf` char(11) NOT NULL,
  `email` varchar(150) NOT NULL,
  `senha` varchar(255) NOT NULL,
  `tipo` enum('ALUNO','GERENTE','BIBLIOTECARIO','ESTAGIARIO') NOT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `cpf` (`cpf`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'Diego Aluno','11122233344','diego@teste.com','hash123','ALUNO');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_acervo_publico`
--

DROP TABLE IF EXISTS `vw_acervo_publico`;
/*!50001 DROP VIEW IF EXISTS `vw_acervo_publico`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_acervo_publico` AS SELECT 
 1 AS `id_livro`,
 1 AS `titulo`,
 1 AS `autor`,
 1 AS `isbn`,
 1 AS `quantidade_estoque`,
 1 AS `status`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_dashboard_financeiro`
--

DROP TABLE IF EXISTS `vw_dashboard_financeiro`;
/*!50001 DROP VIEW IF EXISTS `vw_dashboard_financeiro`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_dashboard_financeiro` AS SELECT 
 1 AS `total_arrecadado`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_livros_atrasados`
--

DROP TABLE IF EXISTS `vw_livros_atrasados`;
/*!50001 DROP VIEW IF EXISTS `vw_livros_atrasados`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_livros_atrasados` AS SELECT 
 1 AS `id_emprestimo`,
 1 AS `nome`,
 1 AS `email`,
 1 AS `titulo`,
 1 AS `data_prevista`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_ranking_leitura`
--

DROP TABLE IF EXISTS `vw_ranking_leitura`;
/*!50001 DROP VIEW IF EXISTS `vw_ranking_leitura`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_ranking_leitura` AS SELECT 
 1 AS `titulo`,
 1 AS `total_lidos`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'facisas_archive'
--

--
-- Dumping routines for database 'facisas_archive'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_calcular_multa` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_calcular_multa`(IN p_id_emprestimo INT, OUT p_valor_multa DECIMAL(10,2))
BEGIN
    DECLARE v_dias_atraso INT; DECLARE v_data_prevista DATE;
    SELECT data_prevista INTO v_data_prevista FROM emprestimos WHERE id_emprestimo = p_id_emprestimo;
    SET v_dias_atraso = DATEDIFF(CURDATE(), v_data_prevista);
    IF v_dias_atraso > 0 THEN SET p_valor_multa = v_dias_atraso * 2.00;
    ELSE SET p_valor_multa = 0.00; END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_renovar_emprestimo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_renovar_emprestimo`(IN p_id_emprestimo INT)
BEGIN
    DECLARE v_status_livro VARCHAR(20);
    SELECT l.status INTO v_status_livro FROM livros l JOIN emprestimos e ON l.id_livro = e.id_livro_fk WHERE e.id_emprestimo = p_id_emprestimo;
    IF v_status_livro = 'RESERVADO' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: O livro possui reserva para outro usuário.';
    ELSE UPDATE emprestimos SET data_prevista = DATE_ADD(data_prevista, INTERVAL 7 DAY) WHERE id_emprestimo = p_id_emprestimo; END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_transacao_cadastro_completo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_transacao_cadastro_completo`(IN p_nome VARCHAR(150), IN p_cpf CHAR(11), IN p_email VARCHAR(150), IN p_senha VARCHAR(255), IN p_tipo VARCHAR(20), IN p_logradouro VARCHAR(200), IN p_bairro VARCHAR(100), IN p_cidade VARCHAR(100), IN p_uf CHAR(2))
BEGIN
    DECLARE v_novo_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro no cadastro completo. Rollback executado.'; END;
    START TRANSACTION;
    INSERT INTO usuarios (nome, cpf, email, senha, tipo) VALUES (p_nome, p_cpf, p_email, p_senha, p_tipo);
    SET v_novo_id = LAST_INSERT_ID();
    INSERT INTO enderecos (logradouro, bairro, cidade, uf, id_usuario_fk) VALUES (p_logradouro, p_bairro, p_cidade, p_uf, v_novo_id);
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_transacao_emprestimo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_transacao_emprestimo`(IN p_id_usuario INT, IN p_id_livro INT)
BEGIN
    DECLARE v_estoque INT; DECLARE v_pendencias INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro na transação. Operação cancelada.';
    END;

    START TRANSACTION;
    SELECT COUNT(*) INTO v_pendencias FROM multas m JOIN emprestimos e ON m.id_emprestimo_fk = e.id_emprestimo
    WHERE e.id_usuario_fk = p_id_usuario AND m.pago = 0;
    
    IF v_pendencias > 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuário possui multas pendentes!'; END IF;

    SELECT quantidade_estoque INTO v_estoque FROM livros WHERE id_livro = p_id_livro;
    
    IF v_estoque <= 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Livro fora de estoque!';
    ELSE
        INSERT INTO emprestimos (id_usuario_fk, id_livro_fk, data_prevista) VALUES (p_id_usuario, p_id_livro, DATE_ADD(CURDATE(), INTERVAL 7 DAY));
        UPDATE livros SET quantidade_estoque = quantidade_estoque - 1 WHERE id_livro = p_id_livro;
        COMMIT;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `vw_acervo_publico`
--

/*!50001 DROP VIEW IF EXISTS `vw_acervo_publico`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_acervo_publico` AS select `livros`.`id_livro` AS `id_livro`,`livros`.`titulo` AS `titulo`,`livros`.`autor` AS `autor`,`livros`.`isbn` AS `isbn`,`livros`.`quantidade_estoque` AS `quantidade_estoque`,`livros`.`status` AS `status` from `livros` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_dashboard_financeiro`
--

/*!50001 DROP VIEW IF EXISTS `vw_dashboard_financeiro`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_dashboard_financeiro` AS select ifnull(sum(`multas`.`valor`),0) AS `total_arrecadado` from `multas` where (`multas`.`pago` = 1) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_livros_atrasados`
--

/*!50001 DROP VIEW IF EXISTS `vw_livros_atrasados`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_livros_atrasados` AS select `e`.`id_emprestimo` AS `id_emprestimo`,`u`.`nome` AS `nome`,`u`.`email` AS `email`,`l`.`titulo` AS `titulo`,`e`.`data_prevista` AS `data_prevista` from ((`emprestimos` `e` join `usuarios` `u` on((`e`.`id_usuario_fk` = `u`.`id_usuario`))) join `livros` `l` on((`e`.`id_livro_fk` = `l`.`id_livro`))) where ((`e`.`data_devolucao` is null) and (`e`.`data_prevista` < curdate())) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_ranking_leitura`
--

/*!50001 DROP VIEW IF EXISTS `vw_ranking_leitura`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_ranking_leitura` AS select `l`.`titulo` AS `titulo`,count(`e`.`id_livro_fk`) AS `total_lidos` from (`emprestimos` `e` join `livros` `l` on((`e`.`id_livro_fk` = `l`.`id_livro`))) group by `l`.`id_livro`,`l`.`titulo` order by `total_lidos` desc limit 10 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-22 17:17:25
