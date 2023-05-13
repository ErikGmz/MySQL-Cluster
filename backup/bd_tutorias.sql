-- MySQL dump 10.13  Distrib 8.0.32, for Linux (x86_64)
--
-- Host: localhost    Database: bd_tutorias
-- ------------------------------------------------------
-- Server version	8.0.32-cluster

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `bd_tutorias`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `bd_tutorias` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `bd_tutorias`;

--
-- Table structure for table `Alumno`
--

DROP TABLE IF EXISTS `Alumno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Alumno` (
  `alumno_id` int NOT NULL AUTO_INCREMENT,
  `alumno_nombre` varchar(50) NOT NULL,
  `alumno_apellidos` varchar(150) NOT NULL,
  `plan_id` int NOT NULL,
  `alumno_semestre` int NOT NULL,
  `alumno_grupo` enum('A','B','C') NOT NULL,
  `alumno_grupo_numero` tinyint NOT NULL,
  `alumno_telefono` varchar(10) NOT NULL,
  `alumno_correo` varchar(100) NOT NULL,
  `alumno_contrasena` varchar(100) NOT NULL,
  `alumno_imagen` mediumblob NOT NULL,
  PRIMARY KEY (`alumno_id`,`alumno_semestre`,`alumno_grupo_numero`),
  CONSTRAINT `CK_alumno_grupo_numero` CHECK ((`alumno_grupo_numero` between 1 and 3)),
  CONSTRAINT `CK_alumno_semestre` CHECK ((`alumno_semestre` between 1 and 10))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50100 PARTITION BY RANGE (`alumno_semestre`)
SUBPARTITION BY HASH (`alumno_grupo_numero`)
(PARTITION p0 VALUES LESS THAN (6)
 (SUBPARTITION s0 ENGINE = InnoDB,
  SUBPARTITION s1 ENGINE = InnoDB,
  SUBPARTITION s2 ENGINE = InnoDB),
 PARTITION p2 VALUES LESS THAN (11)
 (SUBPARTITION s3 ENGINE = InnoDB,
  SUBPARTITION s4 ENGINE = InnoDB,
  SUBPARTITION s5 ENGINE = InnoDB)) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Alumno`
--

LOCK TABLES `Alumno` WRITE;
/*!40000 ALTER TABLE `Alumno` DISABLE KEYS */;
/*!40000 ALTER TABLE `Alumno` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_insertar_hijo_alumno` BEFORE INSERT ON `Alumno` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Plan_Estudio WHERE Plan_Estudio.plan_id = NEW.plan_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Plan_Estudio.';
    END IF;
    IF((SELECT COUNT(*) FROM Alumno WHERE Alumno.alumno_id = NEW.alumno_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (alumno_id) ya existe en la tabla Alumno.';
    END IF;
    SET NEW.alumno_grupo_numero = ORD(NEW.alumno_grupo) - 64;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_actualizar_hijo_alumno` BEFORE UPDATE ON `Alumno` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Plan_Estudio WHERE Plan_Estudio.plan_id = NEW.plan_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Plan_Estudio.';
    END IF;
    IF(OLD.alumno_id <> NEW.alumno_id AND (SELECT COUNT(*) FROM Alumno WHERE Alumno.alumno_id = NEW.alumno_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (alumno_id) ya existe en la tabla Alumno.';
    END IF;
    SET NEW.alumno_grupo_numero = ORD(NEW.alumno_grupo) - 64;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_actualizar_padre_alumno` AFTER UPDATE ON `Alumno` FOR EACH ROW BEGIN
    UPDATE Tutor SET Tutor.alumno_id = NEW.alumno_id WHERE Tutor.alumno_id = OLD.alumno_id;
    UPDATE Alumno_Solicitud SET Alumno_Solicitud.alumno_id = NEW.alumno_id WHERE Alumno_Solicitud.alumno_id = OLD.alumno_id;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_eliminar_padre_alumno` AFTER DELETE ON `Alumno` FOR EACH ROW BEGIN
    DELETE FROM Tutor WHERE Tutor.alumno_id = OLD.alumno_id;
    DELETE FROM Alumno_Solicitud WHERE Alumno_Solicitud.alumno_id = OLD.alumno_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Alumno_Solicitud`
--

DROP TABLE IF EXISTS `Alumno_Solicitud`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Alumno_Solicitud` (
  `alumno_id` int NOT NULL,
  `solicitud_id` int NOT NULL,
  `alumno_encargado` tinyint NOT NULL,
  `alumno_asistencia` tinyint NOT NULL,
  PRIMARY KEY (`alumno_id`,`solicitud_id`,`alumno_encargado`),
  CONSTRAINT `CK_alumno_asistencia` CHECK ((`alumno_asistencia` between 0 and 1)),
  CONSTRAINT `CK_alumno_encargado` CHECK ((`alumno_encargado` between 0 and 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50100 PARTITION BY LIST (`alumno_encargado`)
(PARTITION p0 VALUES IN (0) ENGINE = InnoDB,
 PARTITION p1 VALUES IN (1) ENGINE = InnoDB) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Alumno_Solicitud`
--

LOCK TABLES `Alumno_Solicitud` WRITE;
/*!40000 ALTER TABLE `Alumno_Solicitud` DISABLE KEYS */;
/*!40000 ALTER TABLE `Alumno_Solicitud` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_insertar_hijo_alumno_solicitud` BEFORE INSERT ON `Alumno_Solicitud` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Alumno WHERE Alumno.alumno_id = NEW.alumno_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Alumno.';
    END IF;
    IF(SELECT COUNT(*) FROM Solicitud WHERE Solicitud.solicitud_id = NEW.solicitud_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Solicitud.';
    END IF; 
    IF((SELECT COUNT(*) FROM Alumno_Solicitud WHERE Alumno_Solicitud.solicitud_id = NEW.solicitud_id AND Alumno_Solicitud.alumno_id = NEW.alumno_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (alumno_id, solicitud_id) ya existe en la tabla Alumno_Solicitud.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_actualizar_hijo_alumno_solicitud` BEFORE UPDATE ON `Alumno_Solicitud` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Alumno WHERE Alumno.alumno_id = NEW.alumno_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Alumno.';
    END IF;
    IF(SELECT COUNT(*) FROM Solicitud WHERE Solicitud.solicitud_id = NEW.solicitud_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Solicitud.';
    END IF; 
    IF((OLD.alumno_id <> NEW.alumno_id OR OLD.solicitud_id <> NEW.solicitud_id) AND (SELECT COUNT(*) FROM Alumno_Solicitud WHERE Alumno_Solicitud.solicitud_id = NEW.solicitud_id AND Alumno_Solicitud.alumno_id = NEW.alumno_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (alumno_id, solicitud_id) ya existe en la tabla Alumno_Solicitud.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Carrera`
--

DROP TABLE IF EXISTS `Carrera`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Carrera` (
  `carrera_id` int NOT NULL AUTO_INCREMENT,
  `centro_id` int NOT NULL,
  `carrera_nombre` varchar(255) NOT NULL,
  `carrera_duracion` int NOT NULL,
  `carrera_modalidad` enum('P','L','H') NOT NULL,
  `carrera_objetivo` text NOT NULL,
  `carrera_vigente` tinyint NOT NULL,
  PRIMARY KEY (`carrera_id`,`centro_id`,`carrera_duracion`),
  CONSTRAINT `CK_carrera_duracion` CHECK ((`carrera_duracion` between 8 and 10)),
  CONSTRAINT `CK_carrera_vigente` CHECK ((`carrera_vigente` between 0 and 1))
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50500 PARTITION BY RANGE  COLUMNS(centro_id)
SUBPARTITION BY HASH (`carrera_duracion`)
(PARTITION p0 VALUES LESS THAN (4)
 (SUBPARTITION s0 ENGINE = InnoDB,
  SUBPARTITION s1 ENGINE = InnoDB,
  SUBPARTITION s2 ENGINE = InnoDB),
 PARTITION p2 VALUES LESS THAN (7)
 (SUBPARTITION s3 ENGINE = InnoDB,
  SUBPARTITION s4 ENGINE = InnoDB,
  SUBPARTITION s5 ENGINE = InnoDB),
 PARTITION p3 VALUES LESS THAN (MAXVALUE)
 (SUBPARTITION s6 ENGINE = InnoDB,
  SUBPARTITION s7 ENGINE = InnoDB,
  SUBPARTITION s8 ENGINE = InnoDB)) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Carrera`
--

LOCK TABLES `Carrera` WRITE;
/*!40000 ALTER TABLE `Carrera` DISABLE KEYS */;
INSERT INTO `Carrera` VALUES (35,2,'Licenciatura en Biología',9,'P','Formar Biólogos capaces de generar y aplicar el conocimiento científico para\nsolucionar problemas y atender necesidades en las áreas de Biodiversidad,\nEcología e Investigación, desde una perspectiva de uso sustentable de los recursos\nnaturales, ética, humanista, emprendedora y con responsabilidad social',1),(44,3,'Ingeniería en Energías Renovables',9,'P','Formar Ingenieros en Energías Renovables capaces de implementar soluciones\na problemas energéticos a través del diseño, planeación y administración\nde sistemas de generación y transformación, que aprovechan las fuentes\nrenovables de energía, así como de su uso racional en el sector industrial\npara contribuir al desarrollo sustentable dentro de un marco creativo, ético y\nhumanista',1),(45,3,'Ingeniería en Diseño Mecánico',9,'P','Formar Ingenieros en Diseño Mecánico líderes en las áreas de Sistemas\nMecánicos y Procesos de Manufactura, con capacidad de administrar, diseñar,\nimplementar, adecuar y evaluar herramientas, máquinas, productos y\ncomponentes mecánicos, para solucionar problemas de Ingeniería, con base\nen criterios estructurales y de seguridad que permitan la transformación y\nempleo de la energía de manera racional, sustentable y eficiente, respetando la\nnormatividad correspondiente, desde una perspectiva humanista, con calidad\ny responsabilidad social',1),(46,3,'Ingeniería Automotriz',9,'P','Formar Ingenieros Automotrices capaces de innovar, desarrollar, implementar\ny evaluar sistemas relacionados con el ámbito automotriz para mejorar\nla eficiencia de la producción de vehículos y autopartes a nivel nacional e\ninternacional, con liderazgo, calidad, responsabilidad social y respeto al medio\nambiente',1),(47,3,'Ingeniería Biomédica',9,'P','Formar profesionistas en Ingeniería Biomédica con conocimientos\nmultidisciplinarios de ingeniería aplicados al cuidado de la salud, que le\npermiten diseñar, construir, implementar, innovar, mantener y gestionar\nequipos y sistemas biomédicos de diagnóstico y tratamiento, con sentido\nhumanista y de responsabilidad social',1),(48,3,'Ingeniería en Robótica',9,'P','Formar Ingenieros en Robótica líderes en su campo profesional con capacidad para\ndiseñar, desarrollar, innovar, implementar y optimizar procesos, productos y servicios\nen el área de la robótica que contribuyan en la solución de necesidades específicas en\nlos ámbitos de diseño y desarrollo de robots, sistemas de automatización, manufactura\ne integración de tecnologías, evaluación y desarrollo de proyectos en ingeniería con\ncalidad y respeto al medio ambiente en un marco ético y humanista',1),(49,3,'Ingeniería en Manufactura y Automatización Industrial',9,'P','Formar ingenieros líderes en su campo profesional con capacidad para diseñar,\ndesarrollar, innovar, implementar y optimizar procesos, productos y servicios en\nlas áreas de manufactura y automatización, que contribuyan en la solución de\nnecesidades específicas en los ámbitos de integración de sistemas de manufactura\navanzada; automatización y control industrial; diseño de sistemas de producción en\nla manufactura; así como la evaluación y desarrollo de proyectos en ingeniería con\ncalidad y respeto al medio ambiente en un marco ético y humanista',1),(60,2,'Ingeniería en Bioquímica',9,'P','Formar Ingenieros Bioquímicos creativos, con espíritu crítico y humanista para\ndiseñar, desarrollar, implementar y optimizar procesos, productos y servicios que\ninvolucren el aprovechamiento racional e integral de los recursos bióticos, y que\nsean capaces de resolver problemas en los ámbitos de ingeniería de procesos,\nsustentabilidad y ambiente, bioingeniería y alimentario',1),(61,2,'Ingeniería en Sistemas Computacionales',9,'P','Formar Ingenieros en Sistemas Computacionales que diseñen, desarrollen,\nimplementen, evalúen y automaticen sistemas en Software, Redes de Computadoras,\nAplicación de Hardware, Ingeniería de Datos y Aseguramiento de Sistemas, logrando\nadaptar las nuevas tecnologías a las necesidades que demanden las organizaciones\npúblicas o privadas desde un enfoque proactivo, ético, humanista y con responsabilidad\nsocial',1),(62,2,'Licenciatura en Matemáticas Aplicadas',9,'P','Formar Licenciados en Matemáticas Aplicadas capaces de diseñar modelos\ncuantitativos eficaces y confiables que incidan en la optimización de procesos\ny la toma de decisiones, y que describan fidedignamente fenómenos en las\nciencias y la tecnología para la resolución de problemas actuales en los ámbitos\nproductivo y de servicios; promover la enseñanza y el aprendizaje significativo\nde las matemáticas y física atendiendo las necesidades del ámbito de docencia,\nsiempre en el marco de la ética, humanismo y responsabilidad social',1),(64,2,'Químico Farmacéutico Biólogo',9,'P','Formar Químico Farmacéuticos Biólogos que se desempeñen honesta y\nresponsablemente en las áreas clínica, farmacéutica, industrial y de investigación,\npara contribuir al bienestar y desarrollo de la población local, nacional y global, en\nconcordancia con los principios éticos, humanistas y científicos',1),(67,2,'Ingeniería en Electrónica',9,'P','Formar Ingenieros en Electrónica capaces de diseñar, implementar, adaptar y mantener\nsistemas electrónicos en los ámbitos de control e instrumentación, diseño electrónico, sistemas\ndigitales y embebidos, internet de las cosas y telecomunicaciones de área local; contando con\nla capacidad de llevar a cabo la transferencia e innovación de tecnología electrónica, evaluar\nla pertinencia de proyectos y atender las necesidades de su entorno con ética, una visión\nhumanista y compromiso social',1),(69,2,'Ingeniero Industrial Estadístico',9,'P','Formar Ingenieros Industriales Estadísticos capaces de identificar, formular y\nresolver problemas en las áreas de Ingeniería Industrial, Estadística y Cómputo\nEstadístico, Administración y Automatización Industrial; así como innovar y\nemprender negocios, administrar, procesar, controlar y transmitir información\nde cadenas de valor, provenientes de la adecuada aplicación de conocimientos\ny habilidades en ingeniería, estadística, matemáticas, computación y\nadministración, con una perspectiva ética, humanista y con responsabilidad\nsocial',1),(81,2,'Licenciatura en Biotecnología',9,'P','Formar profesionistas capaces de desarrollar y aplicar herramientas\nbiotecnológicas que resuelvan problemas y atiendan necesidades de la\nsociedad en los ámbitos agrícola, forestal, pecuario, médico y farmacéutico,\nambiental, así como uso sostenible de la Biodiversidad del país. Esto con una\nperspectiva ética, humanista, emprendedora y con responsabilidad social',1),(88,2,'Licenciatura en Informática y Tecnologías Computacionales',9,'P','Formar Licenciados en Informática y Tecnologías Computacionales, capaces\nde analizar, diseñar e implementar soluciones basadas en Tecnologías de\nInformación que contribuyan a la creación de valor organizacional mediante el\ndesarrollo tecnológico en las áreas de programación e ingeniería de software,\ngestión de proyectos informáticos, tratamiento de la información y gestión de\nservicios digitales, de forma innovadora y humanista, con perspectiva ética y\nde responsabilidad social y ambiental',1),(33,1,'Médico Veterinario Zootecnista',10,'P','Formar Médicos Veterinarios Zootecnistas humanistas, reflexivos y socialmente\nresponsables, capaces de contribuir de manera decisiva a que los animales\ndomésticos se preserven sanos, con niveles óptimos de bienestar y desempeño\nproductivo, así como capaces de facilitar el desarrollo rural sustentable y evitar\nla transmisión de enfermedades al humano mediante el aseguramiento de la\ncalidad e inocuidad de alimentos y las acciones de la salud pública veterinaria,\nbajo el concepto de una salud',1),(66,2,'Ingeniería en Computación Inteligente',10,'P','Formar Ingenieros en Computación Inteligente, con conocimientos sólidos\nde los fundamentos matemáticos y teóricos de las Ciencias de la\nComputación, de Inteligencia Artificial e Industria de Software, a través de\nla concepción y creación de ambientes, facilidades y aplicaciones innovadoras\nde la computación, la construcción de software de base y de aplicaciones,\nelaboración de teorías y prácticas de modelos de realidades complejas y\nemprendimiento a fin de dar soluciones computacionales eficientes a\nproblemas reales y complejos; asimilar y adaptar nuevas tecnologías así como\nnuevas metodologías para el desarrollo de software, participar en equipos\nmultidisciplinarios y adaptarse a los rápidos cambios que se producen en las\nCiencias de la Computación y en la Industria de Software, con un alto sentido de\nresponsabilidad social, innovador y humanista',1),(41,1,'Ingeniería en Agronomía',8,'P','Formar Ingenieros Agrónomos con una visión integral, capaces de aplicar,\ninnovar y transmitir conocimientos pertinentes y socialmente relevantes\nque les permitan enfrentar, adaptar y solucionar problemas en diversas\nsituaciones y cambios del contexto agrícola, que respondan a las necesidades\nde producción, gestión de recursos e innovación agrícola, bajo los principios\nhumanísticos y el cuidado del medio ambiente',1),(92,1,'Ingeniería en Alimentos',8,'P','Formar Ingenieros en Alimentos con una visión integral, capaces de\notorgar valor agregado a materias primas agropecuarias, promoviendo el\ndesarrollo industrial a través de aplicar, adaptar, innovar o generar procesos\nde manufactura, gestión de calidad y seguridad alimentaria en empresas\nagroindustriales, respondiendo a las necesidades de desarrollo social y de\nglobalización; conscientes de la sustentabilidad y de aprovechamiento eficiente\nde los recursos bajo un enfoque de ética humanista y de responsabilidad social',1),(23,5,'Licenciatura en Urbanismo',9,'P','Formar Licenciados en Urbanismo con conocimientos, habilidades, actitudes y\nvalores para elaborar, gestionar, implementar y evaluar proyectos en los ámbitos de:\nPlaneación urbana y ordenamiento del territorio; Diseño urbano; e, Investigación\nurbana, en diferentes escalas territoriales, con el fin de contribuir al logro de\nciudades, asentamientos humanos y territorios sostenibles, seguros, incluyentes,\nasequibles, aportando un ambiente construido e inteligentes que mejoren la\ncalidad de vida de sus habitantes de forma ética, responsable y comprometida\ncon la sociedad y el medio ambiente',1),(25,5,'Licenciatura en Diseño de Moda en Indumentaria y Textiles',9,'P','Formar Licenciados en Diseño de Moda en Indumentaria y Textiles creativos,\ncon iniciativa y espíritu humanista, capaces de desarrollar productos y\nservicios de diseño de moda incluyente, rentable, sostenible y con identidad\nsociocultural, en los ámbitos de diseño e innovación, producción, desarrollo\ncomercial y comunicación, promoción y difusión de la moda, con impacto a\nnivel local, regional, nacional e internacional',1),(27,5,'Licenciatura en Diseño Gráfico',9,'P','Formar Licenciados en Diseño Gráfico capaces de analizar, generar, aplicar y\nevaluar estrategias de comunicación visual en los ámbitos de diseño gráfico de\nservicios y productos, reproducción de la imagen y de gestión estratégica para\nintervenir problemas complejos en entornos impresos y digitales, de forma\ncreativa, innovadora, ética, responsable, sostenible y con liderazgo',1),(28,5,'Licenciatura en Diseño de Interiores',9,'P','Formar Licenciados en Diseño de Interiores capaces de ofrecer soluciones de\ndiseño y construcción para habilitar, adecuar, re-utilizar y conservar espacios\ninteriores habitables bajo una relación íntima entre el espacio, el objeto y el\nhabitante mediante la aplicación de métodos y estrategias holísticas con la\nfinalidad de mejorar la calidad de vida del ser humano a través de su habitar,\ndesde una perspectiva emprendedora, ética, humanista y con responsabilidad\nsocial',1),(53,6,'Licenciatura en Comercio Internacional',9,'P','Formar Licenciados en Comercio Internacional capaces de analizar el entorno\neconómico y los tratados internacionales para detectar oportunidades de\ncomercio e inversión en los diversos mercados, estableciendo protocolos de\nnegocios en los diferentes ámbitos multiculturales; realizar las actividades\nde importación y exportación de acuerdo con los procedimientos de la\ngestión aduanera, así como el diseño e implementación de planes logísticos\ny la elaboración de contratos de mercadería internacional, con espíritu\nemprendedor, responsabilidad social y ética profesional',1),(21,5,'Arquitectura',10,'P','Formar Licenciados en Arquitectura altamente competentes en los ámbitos\ndel diseño arquitectónico-urbano y de la edificación de espacios habitables\npara planear, diseñar y construir espacios que permitan el desarrollo de\nciudades sustentables y que contribuyan al bienestar de la necesidades de la\nsociedad a nivel local, regional, nacional e internacional; con la capacidad para\ninterpretar los factores sociales, culturales, medio ambientales y tecnológicos\nconstructivos con el objeto de mejorar la calidad de vida del ser humano, con\nuna perspectiva ética y humanista, sensibles a los problemas del entorno',1),(22,5,'Ingeniería Civil',10,'P','Formar profesionales en la Ingeniería Civil capaces de planear y evaluar proyectos\nde ingeniería para diseñar, construir y mantener obras civiles en los ámbitos\nde las estructuras, cimentaciones, vías terrestres; así como obras hidráulicas y\nambientales, con la finalidad de atender los requerimientos de infraestructura\nque satisfagan las necesidades sociales, con criterios de sostenibilidad, factibilidad\ny seguridad; con una perspectiva ética y humanista, en un marco de pluralismo,\nautonomía, responsabilidad social, calidad e innovación',1),(31,4,'Médico Cirujano',10,'P','Formar Médicos Cirujanos altamente competentes en el cuidado de la salud\nindividual y colectiva, que respondan a las necesidades de atención médica\nderivadas de los perfiles epidemiológico y demográfico actuales; en la prevención,\ncuración y rehabilitación de los pacientes, en los ámbitos clínico, salud pública e\ninvestigación, a través de un trabajo interdisciplinario y multidisciplinario, con\nactitud ética y humanista',1),(32,4,'Médico Estomatólogo',10,'P','Formar Médicos Estomatólogos capaces de realizar acciones preventivas para la\npromoción de la salud bucal, además de desarrollar técnicas y métodos dirigidos\na diagnosticar, atender y resolver las patologías bucodentales de la población\nen general mediante el uso de equipo, instrumental y materiales odontológicos\nde vanguardia; además de involucrarse en la investigación de diversas áreas\nestomatológicas que le permitan actualizarse y generar conocimientos innovadores\npara su formación, con calidad humana y ética profesional',1),(29,5,'Licenciatura en Diseño Industrial',8,'P','Formar diseñadores industriales, capaces de diseñar y desarrollar de manera\nintegral productos y servicios caracterizados por su innovación, usabilidad,\nfactibilidad, rentabilidad, y responsabilidad hacia el medio ambiente y la\nsociedad y contribuir en la competitividad de las empresas, bajo un enfoque\nresponsable, ético y con espíritu emprendedor',1),(34,4,'Licenciatura en Terapia Física',8,'P','Formar Licenciados en Terapia Física competentes, capaces de participar en\nestrategias de prevención para personas con riesgo a desarrollar una discapacidad,\nofrecer servicios de valoración a individuos y poblaciones para diagnosticar, mantener\ny restaurar el máximo movimiento y la capacidad funcional durante todo el ciclo de\nvida, para la reintegración social de las personas con alguna discapacidad, colaborar\ncon equipos inter y multidisciplinarios en los ámbitos de prevención, rehabilitación y\ngestión terapéutica, con apoyo de los avances tecnológicos en fisioterapia, desde una\nperspectiva ética, científica, humanista, emprendedora y con responsabilidad social',1),(36,4,'Licenciatura en Optometría',8,'P','Formar Licenciados en Optometría capacitados para prevenir y diagnosticar:\nametropías, alteraciones funcionales binoculares, deficiencias visuales-perceptuales\ny alteraciones de la salud ocular; así como realizar el tratamiento y/o rehabilitación\npor medio de sistemas ópticos, entrenamiento visual-perceptual y terapéutica\ntópica en enfermedades del segmento anterior; aplicando tratamientos oftálmicos\ninnovadores e involucrándose en actividades de investigación que permitan\nestar a la vanguardia en el ejercicio de la profesión con actitud ética, humanista y\ncomprometidos con la sociedad',1),(38,4,'Licenciatura en Enfermería',8,'P','Formar Licenciados en Enfermería capaces de otorgar cuidados integrales a\nla persona en todas las etapas de vida y promover el autocuidado, a través del\nproceso de enfermería y aplicar las bases científicas de la disciplina con el apoyo\nde la tecnología en los ámbitos asistencial, educación para la salud, investigación\ny administración; con un sentido humanista, de servicio y responsabilidad social',1),(39,4,'Licenciatura en Nutrición',8,'P','Formar Licenciados en Nutrición competentes y líderes en su campo profesional,\nque se desempeñen con calidad y rigor científico en el diagnóstico del estado\nnutricio en individuos sanos, en riesgo y enfermos, la modificación de conductas\ny hábitos relacionados con la alimentación, la administración de servicios de\nalimentos y la implementación de programas de alimentación y nutrición,\ntanto de forma individualizada como colectiva; con capacidad para trabajar en\ngrupos inter y multidisciplinarios, así como actitud de servicio y conscientes de la\nresponsabilidad ética y social en su desempeño profesional',1),(40,4,'Licenciatura en Cultura Física y Deporte',8,'P','Formar licenciados en cultura física y deporte que prescriban ejercicio físico\nadaptado a las características de cada grupo poblacional, a través del diseño,\norganización, aplicación, supervisión y evaluación de planes y sesiones de actividad\nfísica en los ámbitos del deporte, la salud, la educación física y la gestión deportiva,\ncon una perspectiva humanista, ética, colaborativa e inclusiva a fin de fomentar\nestilos de vida saludable en la población',1),(51,6,'Contador Público',8,'P','Formar Contadores Públicos altamente capacitados en la presentación, análisis,\ninterpretación y auditoría, de estados financieros; en la aplicación de las\ndisposiciones fiscales; determinación correcta del costo en productos y servicios;\ny en la administración y gestión de los recursos financieros; siendo competitivos\nen el sector público y privado, para una adecuada toma de decisiones, con\nsentido ético, de liderazgo y de responsabilidad social, beneficiando el desarrollo\neconómico y social',1),(52,6,'Licenciatura en Administración de Empresas',8,'P','Formar Licenciados en Administración de Empresas con capacidad para desarrollar\nsoluciones estratégicas integrales a problemas administrativos, organizacionales,\nde recursos humanos, financieros, de mercadotecnia y de operaciones en los\námbitos de la gestión organizacional y de dirección de proyectos empresariales\ncon actitud ética, responsable, humanista y comprometida con el desarrollo\nsustentable',1),(54,6,'Licenciatura en Administración de la Producción y Servicios',8,'P','Formar Licenciados en Administración de la Producción y Servicios, capaces de\ncoordinar las áreas funcionales de la empresa con el área de operación, a través del\nanálisis, evaluación, diseño y aplicación de estrategias organizacionales, mediante\nla administración de procesos, de materiales, de calidad y de capital, para optimizar\nresultados de los sistemas productivos de bienes y servicios que generen ventajas\ncompetitivas dentro de un mercado global, con una perspectiva de responsabilidad\nsocial, ética y humanista inherentes al desempeño de su profesión, de manera\ninnovadora, asertiva y con alto sentido de liderazgo',1),(55,6,'Licenciatura en Administración Financiera',8,'P','Formar Licenciados en Administración Financiera competentes y especializados\nque les permita administrar, gestionar, evaluar y establecer estrategias para\nincrementar la riqueza, administrando el riesgo, en los ámbitos del Sistema\nFinanciero, de Negocios, de las Finanzas públicas e Internacionales, con\ncapacidad emprendedora y una sólida formación ética con perspectiva\nhumanista y de responsabilidad social comprometidos con el desarrollo local,\nregional y nacional',1),(56,6,'Licenciatura en Relaciones Industriales',8,'P','Formar Licenciados en Relaciones Industriales, capaces de desarrollar diferentes\ntécnicas para la organización del trabajo y la gestión avanzada del capital humano\nque eleven la calidad de vida del trabajador, promuevan la productividad y faciliten\nel crecimiento sostenible de las organizaciones, en las áreas de Administración de\nRecursos Humanos, Desarrollo de Personal, Gestión Laboral, Producción y Calidad,\nen un marco de equidad con una actitud comprometida hacia el desarrollo\nsostenible, orientación humanista y sensibilidad hacia su entorno',1),(57,6,'Licenciatura en Economía',8,'P','Formar Licenciados en Economía capaces de evaluar y proponer planes,\nprogramas y proyectos en los ámbitos de economía de la empresa, economía\nfinanciera, economía pública, economía internacional, crecimiento y desarrollo\neconómico con la finalidad de resolver problemas económicos y sociales de\ncrecimiento y desarrollo sustentable, así como, determinar el impacto de las\nvariables económico financieras a nivel internacional, nacional y local, de forma\nética, crítica, plural, con sentido humanista y de responsabilidad social',1),(59,6,'Licenciatura en Mercadotecnia',8,'P','Formar licenciados en Mercadotecnia, líderes en la dirección estratégica de marketing\ny ventas, Inteligencia de mercados, generación de valor para el cliente, promoción y\ndistribución, y creatividad y generación de negocios, así como el emprendimiento\nde un negocio con enfoque humanista, sostenible, global y ético que fomenten la\ncalidad de vida de los clientes para lograr una sociedad más equitativa y justa',1),(77,6,'Licenciatura en Gestión Turística',8,'P','Formar Licenciados en Gestión Turística con conocimiento de las dimensiones\ndel turismo y de sus principales estructuras socio-políticas y administrativas,\nhábiles en la toma de decisiones sustentadas en la investigación, capaces de\nrealizar de manera eficiente y sostenible actividades directivas y de gestión en\nlos ámbitos de planificación pública de destinos, de desarrollo de productos\ny actividades turísticas, alojamiento, alimentos y bebidas, intermediación,\ntransportación y logística; ofreciendo servicios de consultoría y apoyo al sector\npúblico y empresarial, todo ello con sentido ético y de responsabilidad social\npara el desempeño de sus funciones',1),(10,9,'Licenciatura en Letras Hispánicas',9,'P','Formar Licenciados en Letras Hispánicas capaces de analizar, reflexionar y\nprofundizar en los distintos ámbitos de estudio de la lengua y la literatura desde sus orígenes, desarrollo y hasta nuestros días, y su relación con otras disciplinas para su implementación en la enseñanza, la filología, la asesoría lingüística, la difusión y la\ndivulgación de la lengua y la literatura, la crítica y los procesos de creación a través de\nmetodologías de investigación con pensamiento crítico y empatía ante la diversidad\nsociocultural contemporánea, ética profesional y humanismo',1),(12,9,'Licenciatura en Artes Cinematográficas y Audiovisuales',9,'P','Formar Licenciados en Artes Cinematográficas y Audiovisuales con\nconocimientos y habilidades en realización, producción, gestión, distribución\ny análisis del fenómeno cinematográfico, para crear obras y productos\naudiovisuales con un sentido crítico, ético y responsable socialmente',1),(15,8,'Licenciatura en Trabajo Social',9,'P','Formar profesionistas en Trabajo Social capaces de analizar, diagnosticar y sistematizar\nfenómenos sociales para diseñar, aplicar y evaluar modelos de intervención en\nlos diferentes niveles de actuación: individual, familiar, grupal y comunitario de\nmanera innovadora; con la finalidad de promover cambios sociales en los ámbitos\nde bienestar social, promoción social y emergente, en el sector público, privado y\nen las organizaciones de la sociedad civil, bajo un enfoque multi y transdisciplinar\ncon humanismo, perspectiva de género, responsabilidad social y ambiental, ética\nprofesional y empatía ante la diversidad sociocultural contemporánea',1),(71,8,'Licenciatura en Psicología',9,'P','Formar Licenciados en Psicología con conocimientos teóricos y metodológicos\nsobre el comportamiento humano, con habilidades para integrar los avances de\nla investigación científica a su práctica psicológica, tanto en la evaluación del\ncomportamiento de los individuos como en su intervención en diferentes ámbitos\ny etapas de su vida, en las diferentes áreas de aplicación de la psicología clínica y\nde la salud, educativa, del trabajo y las organizaciones, social y comunitaria. Con\nactitudes de colaboración y trabajo interdisciplinario con otros; valores éticos,\nhumanistas y con perspectiva de género',1),(74,8,'Licenciatura en Ciencias Políticas y Administración Pública',9,'P','Formar Licenciadas/os en Ciencias Políticas y Administración Pública analíticos y críticos, capaces de examinar\ny exponer científicamente los problemas y fenómenos políticos, sociales y gubernamentales para responder\na las necesidades de nuestra colectividad y tener una gestión pública de calidad y una sociedad democrática,\njusta, plural y participativa; mediante el diseño, implementación y evaluación de políticas públicas y modelos de\nacción colectiva, participación ciudadana, integración y colaboración institucional favoreciendo la transparencia\ny rendición de cuentas, vinculada a los principios de gobierno abierto y la gobernanza con una perspectiva de\ngénero, ética, humanista y con apego a la responsabilidad y sustentabilidad social',1),(78,9,'Licenciatura en Estudios del Arte y Gestión Cultural',9,'P','Formar Licenciados en Estudios del Arte y Gestión Cultural competentes en el análisis,\ndiseño, implementación y evaluación de programas de cultura y educación artística\npertinentes e innovadores a través de la gestión de proyectos, promoción, difusión\ny el fomento de las artes y la cultura en todos los ámbitos de la vida social; así como\ncon diferentes herramientas en estudios del arte, investigación y metodologías, de\npatrimonio y de gestión que les permitan desempeñarse desde una perspectiva\ncrítica, contemporánea, con humanismo, ética, responsabilidad social, perspectiva de\ngénero y desde una mirada incluyente basada en el respeto',1),(86,7,'Licenciatura en Agronegocios',9,'P','Formar Licenciados en Agronegocios capaces de gestionar, desarrollar, evaluar\ne implementar proyectos productivos que impulsen la competitividad del sector\nagroalimentario con un enfoque empresarial a través de diferentes estrategias\nque permitan mejorar la comercialización de los productos y servicios, así como\nla integración de cadenas productivas desde una perspectiva de desarrollo\nsostenible e innovadora, que dé respuesta a las necesidades de la industria, de\nuna manera ética, humanista y responsable socialmente',1),(87,7,'Licenciatura en Comercio Electrónico',9,'P','Formar Licenciados en Comercio Electrónico que identifiquen y satisfagan\nlas necesidades económicas de las empresas a través de la eficiente gestión\ndel e-Commerce, mediante diversos intermediarios electrónicos, plataformas\ntransaccionales y herramientas digitales para comercializar de forma segura\nproductos físicos y virtuales, a través de la implementación de estrategias\nelectrónicas para la arquitectura de marca y posicionamiento online; así como la\nadministración de recursos humanos, tecnológicos, económicos y de información\nque promuevan el desarrollo de sitios virtuales caracterizados por su rentabilidad,\nsustentabilidad y rendimiento optimizado de acuerdo al entorno de los mercados\ny necesidades sociales. Desde una perspectiva ética, humanista, autónoma, de\ncalidad y responsabilidad social',1),(14,8,'Licenciatura en Docencia de Francés y Español como Lenguas Extranjeras',10,'P','Formar profesionistas capaces de diseñar, implementar y evaluar experiencias\nformativas para los procesos de enseñanza y aprendizaje de francés y español como\nlenguas extranjeras, así como de difundir las culturas inherentes a dichos idiomas\nen diferentes contextos, modalidades y niveles educativos con fines lingüísticos y\ncomunicativos a través de una perspectiva humanista y de compromiso ante las\nnecesidades actuales de la sociedad',1),(17,8,'Licenciatura en Derecho',10,'P','Formar Licenciados en Derecho altamente cualificados en el conocimiento del\norden jurídico nacional e internacional, su interpretación y argumentación, con la\ncapacidad de prever y resolver los problemas jurídicos en el ámbito de lo público,\nprivado y lo social, con un enfoque de respeto de la juridicidad, el pluralismo y\nlos derechos humanos, con responsabilidad social, perspectiva humanista y de\ngénero',1),(79,9,'Licenciatura en Música',10,'P','Formar Licenciados en Música creativos y autocríticos, con un alto sentido de\nautonomía y responsabilidad social, capaces de realizar interpretaciones de alto valor\nestético e implementar proyectos educativos que promuevan el desarrollo de la\nsensibilidad y la expresión musical',1),(13,8,'Licenciado en Sociología',8,'P','Formar al Licenciado en Sociología como investigador y profesionista capaz\nde aplicar los conceptos y perspectivas sociológicas en el análisis de diversas\nproblemáticas sociales, en diferentes contextos sociales y en colaboración con\notras disciplinas; de identificar y diagnosticar los fenómenos sociales y prever sus\nimpactos en la sociedad; de diseñar proyectos de investigación, en la elaboración\nde programas de política social, así como en el análisis de las instituciones y las\norganizaciones, que podrá aplicar en la práctica académica, en instituciones\npúblicas, privadas o en la asesoría profesional independiente, con un alto sentido\nde compromiso y responsabilidad social',1),(18,8,'Licenciatura en Comunicación e Información',8,'P','Formar Licenciados en Comunicación e Información, conscientes de las\nproblemáticas sociales, políticas y culturales contemporáneas, capaces de generar\nplanes, programas y productos comunicativos para desempeñarse en los ámbitos\nde la comunicación pública, el periodismo y la realización de narrativas en soportes\nmediáticos que promuevan una comunicación democrática y sostenible, con una\nperspectiva humanista, de justicia y responsabilidad social',1),(20,8,'Licenciatura en Asesoría Psicopedagógica',8,'P','Formar Licenciados en Asesoría Psicopedagógica con los conocimientos,\nhabilidades, actitudes y valores necesarios para el manejo de los elementos teóricos\ny metodológicos en los ámbitos de Orientación e intervención psicopedagógica;\nDocencia, currículo y evaluación; así como, Gestión y política educativa; que atiendan\nnecesidades de formación a partir del diseño, implementación y evaluación de\nprogramas, en los contextos de Educación Formal y Socioeducativo, con una\nperspectiva interdisciplinaria, humanista y comprometida con el desarrollo de la\nsociedad',1),(70,8,'Licenciatura en Historia',8,'P','Formar Licenciados en Historia capaces de valorar y generar conocimiento\nhistórico que contribuya a la comprensión del presente de manera crítica a través\nde la investigación; de transmitir el saber histórico de forma integral y creativa\npor medio de la docencia y la divulgación; así como participar en la gestión\ny conservación del patrimonio histórico, con apertura y respeto a la diversidad\ncultural',1),(72,8,'Licenciatura en Filosofía',8,'P','Formar Licenciados y Licenciadas en Filosofía con un conocimiento integral\ny reflexivo del saber filosófico disciplinar que les permita analizar, interpretar,\ntransmitir, promover y aplicar la filosofía en problemáticas ambientales, bioéticas,\nde género, de la ciencia con la tecnología y la sociedad, antropológicas, estéticas\ny epistemológicas, a través de la docencia, la investigación y la divulgación para\nque sean capaces de generar nuevos conocimientos e interpretaciones críticohumanistas con un criterio metodológico-filosófico, apoyándose en otras\ndisciplinas científicas y sociales, que les permita formarse una conciencia crítica de\nla sociedad y la cultura para contribuir al diálogo argumentativo y ético, resultado\nde sus investigaciones',1),(73,8,'Licenciatura en Docencia del Idioma Inglés',8,'P','Formar Licenciados en la Docencia del Idioma Inglés íntegros y comprometidos\ncon la educación, quienes dominan el idioma inglés como lengua de\ncomunicación global, así como los conocimientos y habilidades lingüísticas,\nmetodológicas, tecnológicas y culturales en la docencia del inglés en los\ndiferentes niveles educativos; con cualidades humanistas y principios éticos\nque les permitan responder a las problemáticas sociales en sus ámbitos de\ndesempeño a nivel regional, nacional e internacional',1),(84,7,'Licenciatura en Administración y Gestión Fiscal de PyMEs',8,'P','Formar Licenciados en Administración y Gestión Fiscal de PyMEs capaces de\naplicar correctamente la legislación fiscal vigente; implementar la dirección\nadministrativa eficiente en las Pequeñas y Medianas Empresas y proporcionar\nasesoría fiscal relacionada en materia laboral, seguridad social, legal y tributación\ndel comercio exterior con la finalidad de incrementar el desarrollo, productividad\ny competitividad en las organizaciones públicas y privadas desde una perspectiva\nética, humanista, emprendedora y con responsabilidad social',1),(85,7,'Licenciatura en Logística Empresarial',8,'P','Formar Licenciados en Logística Empresarial altamente capacitados en la gestión\nde la cadena de suministro y sus procesos logísticos asociados al movimiento\nde mercancías, aprovisionamiento, almacenamiento, distribución, transporte,\ntrámites aduanales y comercialización de bienes y servicios; incidiendo en la\ndirección empresarial y en la implementación adecuada de la normatividad\nvigente, para ofrecer soluciones innovadoras y sustentables en las organizaciones\npúblicas y privadas, mejorando su desempeño e índice de calidad, con una\nperspectiva humanista, ética y socialmente responsable',1),(93,8,'Licenciatura en Comunicación Corporativa Estratégica',8,'P','Formar Licenciados en Comunicación Corporativa Estratégica que diseñen,\nimplementen y evalúen estrategias y programas de comunicación integral para\nentidades de tipo empresarial, público y social, en los ámbitos de relaciones públicas,\nalianzas estratégicas y networking; comunicación interna para la productividad y\nel desarrollo de las organizaciones y las personas; imagen y reputación para la\nciudadanía corporativa y la sostenibilidad social; así como gestión de medios,\nadministración de redes sociales y producción de contenidos multiplataforma; a\ntravés de una sólida formación teórica, metodológica y práctica, con perspectiva\nhumanista, multicultural, incluyente y ética',1),(94,9,'Licenciatura en Actuación',8,'P','Formar Licenciados en Actuación, con un amplio conocimiento de los procesos\ncreativos y el quehacer escénico del actor, así como de los principios de dirección\nescénica, gestión y producción de proyectos artísticos y enseñanza del teatro\nen nivel básico y medio superior; con la finalidad de formar actores críticos\nque puedan desempeñarse sólidamente en la interpretación, desarrollen\npropuestas que contribuyan a la renovación de la escena con compromiso\nsocial, ético y humanista',1);
/*!40000 ALTER TABLE `Carrera` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_insertar_hijo_carrera` BEFORE INSERT ON `Carrera` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Centro WHERE Centro.centro_id = NEW.centro_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Centro.';
    END IF;
    IF((SELECT COUNT(*) FROM Carrera WHERE Carrera.carrera_id = NEW.carrera_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (carrera_id) ya existe en la tabla Carrera.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_actualizar_hijo_carrera` BEFORE UPDATE ON `Carrera` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Centro WHERE Centro.centro_id = NEW.centro_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Centro.';
    END IF;
    IF(OLD.carrera_id <> NEW.carrera_id AND (SELECT COUNT(*) FROM Carrera WHERE Carrera.carrera_id = NEW.carrera_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (carrera_id) ya existe en la tabla Carrera.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_actualizar_padre_carrera` AFTER UPDATE ON `Carrera` FOR EACH ROW BEGIN
    UPDATE Plan_Estudio SET Plan_Estudio.carrera_id = NEW.carrera_id WHERE Plan_Estudio.carrera_id = OLD.carrera_id;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `restringir_eliminar_padre_carrera` AFTER DELETE ON `Carrera` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Plan_Estudio WHERE Plan_Estudio.carrera_id = OLD.carrera_id) <> 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede eliminar el registro. La llave foránea existe en la tabla Plan_Estudio.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Centro`
--

DROP TABLE IF EXISTS `Centro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Centro` (
  `centro_id` int NOT NULL AUTO_INCREMENT,
  `centro_nombre` varchar(255) NOT NULL,
  `centro_acronimo` varchar(10) NOT NULL,
  `centro_direccion` tinytext NOT NULL,
  `centro_telefono` varchar(10) NOT NULL,
  `centro_extension` varchar(5) NOT NULL,
  `centro_vigente` tinyint NOT NULL,
  PRIMARY KEY (`centro_id`),
  CONSTRAINT `CK_centro_vigente` CHECK ((`centro_vigente` between 0 and 1))
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50100 PARTITION BY RANGE (`centro_id`)
(PARTITION p0 VALUES LESS THAN (6) ENGINE = InnoDB,
 PARTITION p1 VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Centro`
--

LOCK TABLES `Centro` WRITE;
/*!40000 ALTER TABLE `Centro` DISABLE KEYS */;
INSERT INTO `Centro` VALUES (1,'Centro de Ciencias Agropecuarias','CCA','Carr. Jesus Maria - Posta Zootécnica, 20900 Jesús María, Ags.','4499107400','50012',1),(2,'Centro de Ciencias Básicas','CCB','Avenida Universidad # 940, Universidad Autónoma de Aguascalientes, 20130 Aguascalientes, Ags.','4499108400','8400',1),(3,'Centro de Ciencias de la Ingeniería','CCI','Avenida Mahatma Gahndi 6601 El Gigante, 20340 Aguascalientes, Ags.','4499107400','9510',1),(4,'Centro de Ciencias de la Salud','CCS','101, Ciudad Universitaria, Universidad Autónoma de Aguascalientes, 20100 Aguascalientes, Ags.','4499108430','8430',1),(5,'Centro de Ciencias del Diseño y de la Construcción','CCDC','Avenida Universidad # 940, Universidad Autónoma de Aguascalientes, 20130 Aguascalientes, Ags.','4499107400','10013',1),(6,'Centro de Ciencias Económicas y Administrativas','CCEA','Av. Aguascalientes Nte, Universidad Autónoma de Aguascalientes, 20130 Aguascalientes, Ags.','4499107400','55012',1),(7,'Centro de Ciencias Empresariales','CCE','Avenida Mahatma Gahndi 6601 El Gigante, 20340 Aguascalientes, Ags.','4499107400','9530',1),(8,'Centro de Ciencias Sociales y Humanidades','CCSH','Avenida Universidad # 940, Universidad Autónoma de Aguascalientes, 20130 Aguascalientes, Ags.','4499107400','8480',1),(9,'Centro de las Artes y la Cultura','CAC','Avenida Universidad # 940, Universidad Autónoma de Aguascalientes, 20130 Aguascalientes, Ags.','4499107400','58012',1);
/*!40000 ALTER TABLE `Centro` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_actualizar_padre_centro` AFTER UPDATE ON `Centro` FOR EACH ROW BEGIN
    UPDATE Carrera SET Carrera.centro_id = NEW.centro_id WHERE Carrera.centro_id = OLD.centro_id;
    UPDATE Departamento SET Departamento.centro_id = NEW.centro_id WHERE Departamento.centro_id = OLD.centro_id;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `restringir_eliminar_padre_centro` AFTER DELETE ON `Centro` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Carrera WHERE Carrera.centro_id = OLD.centro_id) <> 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede eliminar el registro. La llave foránea existe en la tabla Carrera.';
    END IF;
    IF(SELECT COUNT(*) FROM Departamento WHERE Departamento.centro_id = OLD.centro_id) <> 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede eliminar el registro. La llave foránea existe en la tabla Departamento.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Departamento`
--

DROP TABLE IF EXISTS `Departamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Departamento` (
  `departamento_id` int NOT NULL AUTO_INCREMENT,
  `departamento_nombre` varchar(255) NOT NULL,
  `centro_id` int NOT NULL,
  PRIMARY KEY (`departamento_id`,`centro_id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50100 PARTITION BY RANGE (`centro_id`)
(PARTITION p0 VALUES LESS THAN (6) ENGINE = InnoDB,
 PARTITION p1 VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Departamento`
--

LOCK TABLES `Departamento` WRITE;
/*!40000 ALTER TABLE `Departamento` DISABLE KEYS */;
INSERT INTO `Departamento` VALUES (1,'Departamento de Ciencias Agronómicas',1),(2,'Departamento de Ciencias de los Alimentos',1),(3,'Departamento de Ciencias Veterinarias',1),(4,'Departamento de Biología',2),(5,'Departamento de Ciencias de la Computación',2),(6,'Departamento de Estadística',2),(7,'Departamento de Fisiología y Farmacología',2),(8,'Departamento de Ingeniería Bioquímica',2),(9,'Departamento de Matemáticas y Física',2),(10,'Departamento de Microbiología',2),(11,'Departamento de Morfología',2),(12,'Departamento de Química',2),(13,'Departamento de Sistemas de Información',2),(14,'Departamento de Sistemas Electrónicos',2),(15,'Departamento de Ingeniería Automotriz',3),(16,'Departamento de Ingeniería Biomédica',3),(17,'Departamento de Ingeniería Robótica',3),(18,'Departamento de Cultura Física y Salud Pública',4),(19,'Departamento de Enfermería',4),(20,'Departamento de Estomatología',4),(21,'Departamento de Medicina',4),(22,'Departamento de Nutrición',4),(23,'Departamento de Optometría',4),(24,'Departamento de Terapia Física',4),(25,'Departamento de Arquitectura',5),(26,'Departamento de Diseño de Interiores',5),(27,'Departamento de Diseño de Moda',5),(28,'Departamento de Diseño Gráfico',5),(29,'Departamento de Diseño Industrial',5),(30,'Departamento de Ingeniería Civil',5),(31,'Departamento de Urbanismo',5),(32,'Departamento de Administración',6),(33,'Departamento de Contaduría',6),(34,'Departamento de Economía',6),(35,'Departamento de Finanzas',6),(36,'Departamento de Mercadotecnia',6),(37,'Departamento de Recursos Humanos',6),(38,'Departamento de Turismo',6),(39,'Departamento de Administración y Gestión Fiscal de PyMEs',7),(40,'Departamento de Agronegocios',7),(41,'Departamento de Comercio Electrónico',7),(42,'Departamento de Logística Empresarial',7),(43,'Departamento de Ciencias Políticas y Administración Pública',8),(44,'Departamento de Comunicación',8),(45,'Departamento de Derecho',8),(46,'Departamento de Educación',8),(47,'Departamento de Filosofía',8),(48,'Departamento de Historia',8),(49,'Departamento de Idiomas',8),(50,'Departamento de Psicología',8),(51,'Departamento de Sociología',8),(52,'Departamento de Trabajo Social',8),(53,'Departamento de Arte y Gestión Cultural',9),(54,'Departamento de Artes Escénicas y Audiovisuales',9),(55,'Departamento de Letras',9),(56,'Departamento de Música',9),(57,'',9);
/*!40000 ALTER TABLE `Departamento` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_insertar_hijo_departamento` BEFORE INSERT ON `Departamento` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Centro WHERE Centro.centro_id = NEW.centro_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Centro.';
    END IF;
    IF((SELECT COUNT(*) FROM Departamento WHERE Departamento.departamento_id = NEW.departamento_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (departamento_id) ya existe en la tabla Departamento.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_actualizar_hijo_departamento` BEFORE UPDATE ON `Departamento` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Centro WHERE Centro.centro_id = NEW.centro_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Centro.';
    END IF;
    IF(OLD.departamento_id <> NEW.departamento_id AND (SELECT COUNT(*) FROM Departamento WHERE Departamento.departamento_id = NEW.departamento_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (departamento_id) ya existe en la tabla Departamento.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_actualizar_padre_departamento` AFTER UPDATE ON `Departamento` FOR EACH ROW BEGIN
    UPDATE Materia SET Materia.departamento_id = NEW.departamento_id WHERE Materia.departamento_id = OLD.departamento_id;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `restringir_eliminar_padre_departamento` AFTER DELETE ON `Departamento` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Materia WHERE Materia.departamento_id = OLD.departamento_id) <> 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede eliminar el registro. La llave foránea existe en la tabla Materia.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Materia`
--

DROP TABLE IF EXISTS `Materia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Materia` (
  `materia_id` int NOT NULL AUTO_INCREMENT,
  `materia_nombre` varchar(255) NOT NULL,
  `departamento_id` int NOT NULL,
  `materia_descripcion` text NOT NULL,
  `materia_vigente` tinyint NOT NULL,
  PRIMARY KEY (`materia_id`,`departamento_id`),
  CONSTRAINT `CK_materia_vigente` CHECK ((`materia_vigente` between 0 and 5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50100 PARTITION BY RANGE (`departamento_id`)
(PARTITION p0 VALUES LESS THAN (29) ENGINE = InnoDB,
 PARTITION p1 VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Materia`
--

LOCK TABLES `Materia` WRITE;
/*!40000 ALTER TABLE `Materia` DISABLE KEYS */;
/*!40000 ALTER TABLE `Materia` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_insertar_hijo_materia` BEFORE INSERT ON `Materia` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Departamento WHERE Departamento.departamento_id = NEW.departamento_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Departamento.';
    END IF;
    IF((SELECT COUNT(*) FROM Materia WHERE Materia.materia_id = NEW.materia_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (materia_id) ya existe en la tabla Materia.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_actualizar_hijo_materia` BEFORE UPDATE ON `Materia` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Departamento WHERE Departamento.departamento_id = NEW.departamento_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Departamento.';
    END IF;
    IF(OLD.materia_id <> NEW.materia_id AND (SELECT COUNT(*) FROM Materia WHERE Materia.materia_id = NEW.materia_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (materia_id) ya existe en la tabla Materia.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_actualizar_padre_materia` AFTER UPDATE ON `Materia` FOR EACH ROW BEGIN
    UPDATE Solicitud SET Solicitud.materia_id = NEW.materia_id WHERE Solicitud.materia_id = OLD.materia_id;
    UPDATE Materia_Tutor SET Materia_Tutor.materia_id = NEW.materia_id WHERE Materia_Tutor.materia_id = OLD.materia_id;
    UPDATE Materia_Plan SET Materia_Plan.materia_id = NEW.materia_id WHERE Materia_Plan.materia_id = OLD.materia_id;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_eliminar_padre_materia` AFTER DELETE ON `Materia` FOR EACH ROW BEGIN
    DELETE FROM Solicitud WHERE Solicitud.materia_id = OLD.materia_id;
    DELETE FROM Materia_Tutor WHERE Materia_Tutor.materia_id = OLD.materia_id;  
    DELETE FROM Materia_Plan WHERE Materia_Plan.materia_id = OLD.materia_id;  
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Materia_Plan`
--

DROP TABLE IF EXISTS `Materia_Plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Materia_Plan` (
  `materia_id` int NOT NULL,
  `plan_id` int NOT NULL,
  `semestre` int NOT NULL,
  PRIMARY KEY (`materia_id`,`plan_id`,`semestre`),
  CONSTRAINT `CK_semestre` CHECK ((`semestre` between 1 and 10))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50100 PARTITION BY RANGE (`semestre`)
(PARTITION p0 VALUES LESS THAN (3) ENGINE = InnoDB,
 PARTITION p1 VALUES LESS THAN (7) ENGINE = InnoDB,
 PARTITION p2 VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Materia_Plan`
--

LOCK TABLES `Materia_Plan` WRITE;
/*!40000 ALTER TABLE `Materia_Plan` DISABLE KEYS */;
/*!40000 ALTER TABLE `Materia_Plan` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_insertar_hijo_materia_plan` BEFORE INSERT ON `Materia_Plan` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Materia WHERE Materia.materia_id = NEW.materia_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Materia.';
    END IF;   
    IF(SELECT COUNT(*) FROM Plan_Estudio WHERE Plan_Estudio.plan_id = NEW.plan_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Plan_Estudio.';
    END IF;   
    IF((SELECT COUNT(*) FROM Materia_Plan WHERE Materia_Plan.plan_id = NEW.plan_id AND Materia_Plan.materia_id = NEW.materia_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (materia_id, plan_id) ya existe en la tabla Materia_Plan.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_actualizar_hijo_materia_plan` BEFORE UPDATE ON `Materia_Plan` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Materia WHERE Materia.materia_id = NEW.materia_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Materia.';
    END IF;
    IF(SELECT COUNT(*) FROM Plan_Estudio WHERE Plan_Estudio.plan_id = NEW.plan_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Plan_Estudio.';
    END IF; 
    IF((OLD.materia_id <> NEW.materia_id OR OLD.plan_id <> NEW.plan_id) AND (SELECT COUNT(*) FROM Materia_Plan WHERE Materia_Plan.plan_id = NEW.plan_id AND Materia_Plan.materia_id = NEW.materia_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (materia_id, plan_id) ya existe en la tabla Materia_Plan.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Materia_Tutor`
--

DROP TABLE IF EXISTS `Materia_Tutor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Materia_Tutor` (
  `tutor_id` int NOT NULL,
  `materia_id` int NOT NULL,
  `promedio_materia` decimal(10,0) NOT NULL,
  PRIMARY KEY (`tutor_id`,`materia_id`,`promedio_materia`),
  CONSTRAINT `CK_promedio_materia` CHECK ((`promedio_materia` between 8 and 10))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50100 PARTITION BY RANGE (floor(`promedio_materia`))
(PARTITION p0 VALUES LESS THAN (9) ENGINE = InnoDB,
 PARTITION p1 VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Materia_Tutor`
--

LOCK TABLES `Materia_Tutor` WRITE;
/*!40000 ALTER TABLE `Materia_Tutor` DISABLE KEYS */;
/*!40000 ALTER TABLE `Materia_Tutor` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_insertar_hijo_materia_tutor` BEFORE INSERT ON `Materia_Tutor` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Tutor WHERE Tutor.tutor_id = NEW.tutor_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Tutor.';
    END IF;   
    IF(SELECT COUNT(*) FROM Materia WHERE Materia.materia_id = NEW.materia_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Materia.';
    END IF; 
    IF((SELECT COUNT(*) FROM Materia_Tutor WHERE Materia_Tutor.materia_id = NEW.materia_id AND Materia_Tutor.tutor_id = NEW.tutor_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (tutor_id, materia_id) ya existe en la tabla Materia_Tutor.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_actualizar_hijo_materia_tutor` BEFORE UPDATE ON `Materia_Tutor` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Tutor WHERE Tutor.tutor_id = NEW.tutor_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Tutor.';
    END IF;
    IF(SELECT COUNT(*) FROM Materia WHERE Materia.materia_id = NEW.materia_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Materia.';
    END IF; 
    IF((OLD.tutor_id <> NEW.tutor_id OR OLD.materia_id <> NEW.materia_id) AND (SELECT COUNT(*) FROM Materia_Tutor WHERE Materia_Tutor.materia_id = NEW.materia_id AND Materia_Tutor.tutor_id = NEW.tutor_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (tutor_id, materia_id) ya existe en la tabla Materia_Tutor.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Plan_Estudio`
--

DROP TABLE IF EXISTS `Plan_Estudio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Plan_Estudio` (
  `plan_id` int NOT NULL,
  `carrera_id` int NOT NULL,
  `plan_fecha_inicio` datetime NOT NULL,
  `plan_fecha_fin` datetime NOT NULL,
  PRIMARY KEY (`plan_id`,`carrera_id`),
  CONSTRAINT `CK_restriccion_fechas` CHECK ((`plan_fecha_fin` > `plan_fecha_inicio`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50100 PARTITION BY RANGE (`carrera_id`)
(PARTITION p0 VALUES LESS THAN (21) ENGINE = InnoDB,
 PARTITION p1 VALUES LESS THAN (43) ENGINE = InnoDB,
 PARTITION p2 VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Plan_Estudio`
--

LOCK TABLES `Plan_Estudio` WRITE;
/*!40000 ALTER TABLE `Plan_Estudio` DISABLE KEYS */;
/*!40000 ALTER TABLE `Plan_Estudio` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_insertar_hijo_plan_estudio` BEFORE INSERT ON `Plan_Estudio` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Carrera WHERE Carrera.carrera_id = NEW.carrera_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Carrera.';
    END IF;
    IF((SELECT COUNT(*) FROM Plan_Estudio WHERE Plan_Estudio.plan_id = NEW.plan_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (plan_id) ya existe en la tabla Plan_Estudio.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_actualizar_hijo_plan_estudio` BEFORE UPDATE ON `Plan_Estudio` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Carrera WHERE Carrera.carrera_id = NEW.carrera_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Carrera.';
    END IF;
    IF(OLD.plan_id <> NEW.plan_id AND (SELECT COUNT(*) FROM Plan_Estudio WHERE Plan_Estudio.plan_id = NEW.plan_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (plan_id) ya existe en la tabla Plan_Estudio.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_actualizar_padre_plan_estudio` AFTER UPDATE ON `Plan_Estudio` FOR EACH ROW BEGIN
    UPDATE Alumno SET Alumno.plan_id = NEW.plan_id WHERE Alumno.plan_id = OLD.plan_id;
    UPDATE Materia_Plan SET Materia_Plan.plan_id = NEW.plan_id WHERE Materia_Plan.plan_id = OLD.plan_id;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_eliminar_padre_plan_estudio` AFTER DELETE ON `Plan_Estudio` FOR EACH ROW BEGIN
    DELETE FROM Alumno WHERE Alumno.plan_id = OLD.plan_id;
    DELETE FROM Materia_Plan WHERE Materia_Plan.plan_id = OLD.plan_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Solicitud`
--

DROP TABLE IF EXISTS `Solicitud`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Solicitud` (
  `solicitud_id` int NOT NULL AUTO_INCREMENT,
  `tutor_id` int DEFAULT NULL,
  `solicitud_fecha` datetime NOT NULL,
  `solicitud_urgencia` varchar(1) NOT NULL,
  `materia_id` int NOT NULL,
  `solicitud_tema` varchar(200) NOT NULL,
  `solicitud_descripcion` text NOT NULL,
  `solicitud_fecha_programacion` datetime DEFAULT NULL,
  `solicitud_lugar` varchar(200) DEFAULT NULL,
  `solicitud_modalidad` enum('P','L') NOT NULL,
  `solicitud_vigente` tinyint NOT NULL,
  `asesoria_evidencia` mediumblob,
  `asesoria_calificacion` float DEFAULT NULL,
  PRIMARY KEY (`solicitud_id`,`solicitud_urgencia`,`solicitud_vigente`),
  CONSTRAINT `CK_asesoria_calificacion` CHECK ((`asesoria_calificacion` between 0 and 5)),
  CONSTRAINT `CK_restriccion_fechas_solicitud` CHECK ((`solicitud_fecha` <= `solicitud_fecha_programacion`)),
  CONSTRAINT `CK_solicitud_urgencia` CHECK ((`solicitud_urgencia` in (_utf8mb4'U',_utf8mb4'E'))),
  CONSTRAINT `CK_solicitud_vigente` CHECK ((`solicitud_vigente` between 0 and 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50500 PARTITION BY LIST  COLUMNS(solicitud_urgencia)
SUBPARTITION BY HASH (`solicitud_vigente`)
(PARTITION p0 VALUES IN ('U')
 (SUBPARTITION s0 ENGINE = InnoDB,
  SUBPARTITION s1 ENGINE = InnoDB),
 PARTITION p2 VALUES IN ('E')
 (SUBPARTITION s2 ENGINE = InnoDB,
  SUBPARTITION s3 ENGINE = InnoDB)) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Solicitud`
--

LOCK TABLES `Solicitud` WRITE;
/*!40000 ALTER TABLE `Solicitud` DISABLE KEYS */;
/*!40000 ALTER TABLE `Solicitud` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_insertar_hijo_solicitud` BEFORE INSERT ON `Solicitud` FOR EACH ROW BEGIN
    IF(NEW.tutor_id IS NOT NULL) THEN
        IF(SELECT COUNT(*) FROM Tutor WHERE Tutor.tutor_id = NEW.tutor_id) = 0 THEN
            SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Tutor.';
        END IF;
        IF(SELECT COUNT(*) FROM Materia WHERE Materia.materia_id = NEW.materia_id) = 0 THEN
            SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Materia.';
        END IF; 
    END IF;
    IF((SELECT COUNT(*) FROM Solicitud WHERE Solicitud.solicitud_id = NEW.solicitud_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (solicitud_id) ya existe en la tabla Solicitud.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_actualizar_hijo_solicitud` BEFORE UPDATE ON `Solicitud` FOR EACH ROW BEGIN
    IF(NEW.tutor_id IS NOT NULL) THEN
        IF(SELECT COUNT(*) FROM Tutor WHERE Tutor.tutor_id = NEW.tutor_id) = 0 THEN
            SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Tutor.';
        END IF;
        IF(SELECT COUNT(*) FROM Materia WHERE Materia.materia_id = NEW.materia_id) = 0 THEN
            SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Materia.';
        END IF; 
    END IF;
    IF(OLD.solicitud_id <> NEW.solicitud_id AND (SELECT COUNT(*) FROM Solicitud WHERE Solicitud.solicitud_id = NEW.solicitud_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (solicitud_id) ya existe en la tabla Solicitud.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_actualizar_padre_solicitud` AFTER UPDATE ON `Solicitud` FOR EACH ROW BEGIN
    UPDATE Alumno_Solicitud SET Alumno_Solicitud.solicitud_id = NEW.solicitud_id WHERE Alumno_Solicitud.Solicitud_id = OLD.solicitud_id;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_eliminar_padre_solicitud` AFTER DELETE ON `Solicitud` FOR EACH ROW BEGIN
    DELETE FROM Alumno_Solicitud WHERE Alumno_Solicitud.Solicitud_id = OLD.solicitud_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Tutor`
--

DROP TABLE IF EXISTS `Tutor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tutor` (
  `tutor_id` int NOT NULL AUTO_INCREMENT,
  `alumno_id` int NOT NULL,
  `tutor_promedio` decimal(10,0) NOT NULL,
  `tutor_fecha_inscripcion` datetime NOT NULL,
  `tutor_fecha_finalizacion` datetime DEFAULT NULL,
  `tutor_programa` enum('S','V') NOT NULL,
  `tutor_programa_numero` tinyint NOT NULL,
  `tutor_calificacion` float DEFAULT NULL,
  `tutor_vigente` tinyint NOT NULL,
  PRIMARY KEY (`tutor_id`,`tutor_programa_numero`,`tutor_promedio`),
  CONSTRAINT `CK_tutor_calificacion` CHECK ((`tutor_calificacion` between 0 and 5)),
  CONSTRAINT `CK_tutor_programa_numero` CHECK ((`tutor_programa_numero` between 1 and 2)),
  CONSTRAINT `CK_tutor_promedio` CHECK ((`tutor_promedio` between 8 and 10)),
  CONSTRAINT `CK_tutor_vigente` CHECK ((`tutor_vigente` between 0 and 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50100 PARTITION BY RANGE (floor(`tutor_promedio`))
SUBPARTITION BY HASH (`tutor_programa_numero`)
(PARTITION p0 VALUES LESS THAN (9)
 (SUBPARTITION s0 ENGINE = InnoDB,
  SUBPARTITION s1 ENGINE = InnoDB),
 PARTITION p2 VALUES LESS THAN MAXVALUE
 (SUBPARTITION s2 ENGINE = InnoDB,
  SUBPARTITION s3 ENGINE = InnoDB)) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tutor`
--

LOCK TABLES `Tutor` WRITE;
/*!40000 ALTER TABLE `Tutor` DISABLE KEYS */;
/*!40000 ALTER TABLE `Tutor` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_insertar_hijo_tutor` BEFORE INSERT ON `Tutor` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Alumno WHERE Alumno.alumno_id = NEW.alumno_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Alumno.';
    END IF;
    IF((SELECT COUNT(*) FROM Tutor WHERE Tutor.tutor_id = NEW.tutor_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (tutor_id) ya existe en la tabla Tutor.';
    END IF;
    IF NEW.tutor_programa = "S" THEN
        SET NEW.tutor_programa_numero = 1;
    ELSE
        SET NEW.tutor_programa_numero = 2;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_actualizar_hijo_tutor` BEFORE UPDATE ON `Tutor` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Alumno WHERE Alumno.alumno_id = NEW.alumno_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Alumno.';
    END IF;
    IF(OLD.tutor_id <> NEW.tutor_id AND (SELECT COUNT(*) FROM Tutor WHERE Tutor.tutor_id = NEW.tutor_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (tutor_id) ya existe en la tabla Tutor.';
    END IF;
    IF NEW.tutor_programa = "S" THEN
        SET NEW.tutor_programa_numero = 1;
    ELSE
        SET NEW.tutor_programa_numero = 2;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_actualizar_padre_tutor` AFTER UPDATE ON `Tutor` FOR EACH ROW BEGIN
    UPDATE Materia_Tutor SET Materia_Tutor.tutor_id = NEW.tutor_id WHERE Materia_Tutor.tutor_id = OLD.tutor_id;
    UPDATE Solicitud SET Solicitud.tutor_id = NEW.tutor_id WHERE Solicitud.tutor_id = OLD.tutor_id;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_eliminar_padre_tutor` AFTER DELETE ON `Tutor` FOR EACH ROW BEGIN
    DELETE FROM Materia_Tutor WHERE Materia_Tutor.tutor_id = OLD.tutor_id;
    DELETE FROM Solicitud WHERE Solicitud.tutor_id = OLD.tutor_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Current Database: `bd_tutorias`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `bd_tutorias` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `bd_tutorias`;

--
-- Table structure for table `Alumno`
--

DROP TABLE IF EXISTS `Alumno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Alumno` (
  `alumno_id` int NOT NULL AUTO_INCREMENT,
  `alumno_nombre` varchar(50) NOT NULL,
  `alumno_apellidos` varchar(150) NOT NULL,
  `plan_id` int NOT NULL,
  `alumno_semestre` int NOT NULL,
  `alumno_grupo` enum('A','B','C') NOT NULL,
  `alumno_grupo_numero` tinyint NOT NULL,
  `alumno_telefono` varchar(10) NOT NULL,
  `alumno_correo` varchar(100) NOT NULL,
  `alumno_contrasena` varchar(100) NOT NULL,
  `alumno_imagen` mediumblob NOT NULL,
  PRIMARY KEY (`alumno_id`,`alumno_semestre`,`alumno_grupo_numero`),
  CONSTRAINT `CK_alumno_grupo_numero` CHECK ((`alumno_grupo_numero` between 1 and 3)),
  CONSTRAINT `CK_alumno_semestre` CHECK ((`alumno_semestre` between 1 and 10))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50100 PARTITION BY RANGE (`alumno_semestre`)
SUBPARTITION BY HASH (`alumno_grupo_numero`)
(PARTITION p0 VALUES LESS THAN (6)
 (SUBPARTITION s0 ENGINE = InnoDB,
  SUBPARTITION s1 ENGINE = InnoDB,
  SUBPARTITION s2 ENGINE = InnoDB),
 PARTITION p2 VALUES LESS THAN (11)
 (SUBPARTITION s3 ENGINE = InnoDB,
  SUBPARTITION s4 ENGINE = InnoDB,
  SUBPARTITION s5 ENGINE = InnoDB)) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Alumno`
--

LOCK TABLES `Alumno` WRITE;
/*!40000 ALTER TABLE `Alumno` DISABLE KEYS */;
/*!40000 ALTER TABLE `Alumno` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_insertar_hijo_alumno` BEFORE INSERT ON `Alumno` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Plan_Estudio WHERE Plan_Estudio.plan_id = NEW.plan_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Plan_Estudio.';
    END IF;
    IF((SELECT COUNT(*) FROM Alumno WHERE Alumno.alumno_id = NEW.alumno_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (alumno_id) ya existe en la tabla Alumno.';
    END IF;
    SET NEW.alumno_grupo_numero = ORD(NEW.alumno_grupo) - 64;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_actualizar_hijo_alumno` BEFORE UPDATE ON `Alumno` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Plan_Estudio WHERE Plan_Estudio.plan_id = NEW.plan_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Plan_Estudio.';
    END IF;
    IF(OLD.alumno_id <> NEW.alumno_id AND (SELECT COUNT(*) FROM Alumno WHERE Alumno.alumno_id = NEW.alumno_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (alumno_id) ya existe en la tabla Alumno.';
    END IF;
    SET NEW.alumno_grupo_numero = ORD(NEW.alumno_grupo) - 64;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_actualizar_padre_alumno` AFTER UPDATE ON `Alumno` FOR EACH ROW BEGIN
    UPDATE Tutor SET Tutor.alumno_id = NEW.alumno_id WHERE Tutor.alumno_id = OLD.alumno_id;
    UPDATE Alumno_Solicitud SET Alumno_Solicitud.alumno_id = NEW.alumno_id WHERE Alumno_Solicitud.alumno_id = OLD.alumno_id;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_eliminar_padre_alumno` AFTER DELETE ON `Alumno` FOR EACH ROW BEGIN
    DELETE FROM Tutor WHERE Tutor.alumno_id = OLD.alumno_id;
    DELETE FROM Alumno_Solicitud WHERE Alumno_Solicitud.alumno_id = OLD.alumno_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Alumno_Solicitud`
--

DROP TABLE IF EXISTS `Alumno_Solicitud`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Alumno_Solicitud` (
  `alumno_id` int NOT NULL,
  `solicitud_id` int NOT NULL,
  `alumno_encargado` tinyint NOT NULL,
  `alumno_asistencia` tinyint NOT NULL,
  PRIMARY KEY (`alumno_id`,`solicitud_id`,`alumno_encargado`),
  CONSTRAINT `CK_alumno_asistencia` CHECK ((`alumno_asistencia` between 0 and 1)),
  CONSTRAINT `CK_alumno_encargado` CHECK ((`alumno_encargado` between 0 and 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50100 PARTITION BY LIST (`alumno_encargado`)
(PARTITION p0 VALUES IN (0) ENGINE = InnoDB,
 PARTITION p1 VALUES IN (1) ENGINE = InnoDB) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Alumno_Solicitud`
--

LOCK TABLES `Alumno_Solicitud` WRITE;
/*!40000 ALTER TABLE `Alumno_Solicitud` DISABLE KEYS */;
/*!40000 ALTER TABLE `Alumno_Solicitud` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_insertar_hijo_alumno_solicitud` BEFORE INSERT ON `Alumno_Solicitud` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Alumno WHERE Alumno.alumno_id = NEW.alumno_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Alumno.';
    END IF;
    IF(SELECT COUNT(*) FROM Solicitud WHERE Solicitud.solicitud_id = NEW.solicitud_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Solicitud.';
    END IF; 
    IF((SELECT COUNT(*) FROM Alumno_Solicitud WHERE Alumno_Solicitud.solicitud_id = NEW.solicitud_id AND Alumno_Solicitud.alumno_id = NEW.alumno_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (alumno_id, solicitud_id) ya existe en la tabla Alumno_Solicitud.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_actualizar_hijo_alumno_solicitud` BEFORE UPDATE ON `Alumno_Solicitud` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Alumno WHERE Alumno.alumno_id = NEW.alumno_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Alumno.';
    END IF;
    IF(SELECT COUNT(*) FROM Solicitud WHERE Solicitud.solicitud_id = NEW.solicitud_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Solicitud.';
    END IF; 
    IF((OLD.alumno_id <> NEW.alumno_id OR OLD.solicitud_id <> NEW.solicitud_id) AND (SELECT COUNT(*) FROM Alumno_Solicitud WHERE Alumno_Solicitud.solicitud_id = NEW.solicitud_id AND Alumno_Solicitud.alumno_id = NEW.alumno_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (alumno_id, solicitud_id) ya existe en la tabla Alumno_Solicitud.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Carrera`
--

DROP TABLE IF EXISTS `Carrera`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Carrera` (
  `carrera_id` int NOT NULL AUTO_INCREMENT,
  `centro_id` int NOT NULL,
  `carrera_nombre` varchar(255) NOT NULL,
  `carrera_duracion` int NOT NULL,
  `carrera_modalidad` enum('P','L','H') NOT NULL,
  `carrera_objetivo` text NOT NULL,
  `carrera_vigente` tinyint NOT NULL,
  PRIMARY KEY (`carrera_id`,`centro_id`,`carrera_duracion`),
  CONSTRAINT `CK_carrera_duracion` CHECK ((`carrera_duracion` between 8 and 10)),
  CONSTRAINT `CK_carrera_vigente` CHECK ((`carrera_vigente` between 0 and 1))
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50500 PARTITION BY RANGE  COLUMNS(centro_id)
SUBPARTITION BY HASH (`carrera_duracion`)
(PARTITION p0 VALUES LESS THAN (4)
 (SUBPARTITION s0 ENGINE = InnoDB,
  SUBPARTITION s1 ENGINE = InnoDB,
  SUBPARTITION s2 ENGINE = InnoDB),
 PARTITION p2 VALUES LESS THAN (7)
 (SUBPARTITION s3 ENGINE = InnoDB,
  SUBPARTITION s4 ENGINE = InnoDB,
  SUBPARTITION s5 ENGINE = InnoDB),
 PARTITION p3 VALUES LESS THAN (MAXVALUE)
 (SUBPARTITION s6 ENGINE = InnoDB,
  SUBPARTITION s7 ENGINE = InnoDB,
  SUBPARTITION s8 ENGINE = InnoDB)) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Carrera`
--

LOCK TABLES `Carrera` WRITE;
/*!40000 ALTER TABLE `Carrera` DISABLE KEYS */;
INSERT INTO `Carrera` VALUES (35,2,'Licenciatura en Biología',9,'P','Formar Biólogos capaces de generar y aplicar el conocimiento científico para\nsolucionar problemas y atender necesidades en las áreas de Biodiversidad,\nEcología e Investigación, desde una perspectiva de uso sustentable de los recursos\nnaturales, ética, humanista, emprendedora y con responsabilidad social',1),(44,3,'Ingeniería en Energías Renovables',9,'P','Formar Ingenieros en Energías Renovables capaces de implementar soluciones\na problemas energéticos a través del diseño, planeación y administración\nde sistemas de generación y transformación, que aprovechan las fuentes\nrenovables de energía, así como de su uso racional en el sector industrial\npara contribuir al desarrollo sustentable dentro de un marco creativo, ético y\nhumanista',1),(45,3,'Ingeniería en Diseño Mecánico',9,'P','Formar Ingenieros en Diseño Mecánico líderes en las áreas de Sistemas\nMecánicos y Procesos de Manufactura, con capacidad de administrar, diseñar,\nimplementar, adecuar y evaluar herramientas, máquinas, productos y\ncomponentes mecánicos, para solucionar problemas de Ingeniería, con base\nen criterios estructurales y de seguridad que permitan la transformación y\nempleo de la energía de manera racional, sustentable y eficiente, respetando la\nnormatividad correspondiente, desde una perspectiva humanista, con calidad\ny responsabilidad social',1),(46,3,'Ingeniería Automotriz',9,'P','Formar Ingenieros Automotrices capaces de innovar, desarrollar, implementar\ny evaluar sistemas relacionados con el ámbito automotriz para mejorar\nla eficiencia de la producción de vehículos y autopartes a nivel nacional e\ninternacional, con liderazgo, calidad, responsabilidad social y respeto al medio\nambiente',1),(47,3,'Ingeniería Biomédica',9,'P','Formar profesionistas en Ingeniería Biomédica con conocimientos\nmultidisciplinarios de ingeniería aplicados al cuidado de la salud, que le\npermiten diseñar, construir, implementar, innovar, mantener y gestionar\nequipos y sistemas biomédicos de diagnóstico y tratamiento, con sentido\nhumanista y de responsabilidad social',1),(48,3,'Ingeniería en Robótica',9,'P','Formar Ingenieros en Robótica líderes en su campo profesional con capacidad para\ndiseñar, desarrollar, innovar, implementar y optimizar procesos, productos y servicios\nen el área de la robótica que contribuyan en la solución de necesidades específicas en\nlos ámbitos de diseño y desarrollo de robots, sistemas de automatización, manufactura\ne integración de tecnologías, evaluación y desarrollo de proyectos en ingeniería con\ncalidad y respeto al medio ambiente en un marco ético y humanista',1),(49,3,'Ingeniería en Manufactura y Automatización Industrial',9,'P','Formar ingenieros líderes en su campo profesional con capacidad para diseñar,\ndesarrollar, innovar, implementar y optimizar procesos, productos y servicios en\nlas áreas de manufactura y automatización, que contribuyan en la solución de\nnecesidades específicas en los ámbitos de integración de sistemas de manufactura\navanzada; automatización y control industrial; diseño de sistemas de producción en\nla manufactura; así como la evaluación y desarrollo de proyectos en ingeniería con\ncalidad y respeto al medio ambiente en un marco ético y humanista',1),(60,2,'Ingeniería en Bioquímica',9,'P','Formar Ingenieros Bioquímicos creativos, con espíritu crítico y humanista para\ndiseñar, desarrollar, implementar y optimizar procesos, productos y servicios que\ninvolucren el aprovechamiento racional e integral de los recursos bióticos, y que\nsean capaces de resolver problemas en los ámbitos de ingeniería de procesos,\nsustentabilidad y ambiente, bioingeniería y alimentario',1),(61,2,'Ingeniería en Sistemas Computacionales',9,'P','Formar Ingenieros en Sistemas Computacionales que diseñen, desarrollen,\nimplementen, evalúen y automaticen sistemas en Software, Redes de Computadoras,\nAplicación de Hardware, Ingeniería de Datos y Aseguramiento de Sistemas, logrando\nadaptar las nuevas tecnologías a las necesidades que demanden las organizaciones\npúblicas o privadas desde un enfoque proactivo, ético, humanista y con responsabilidad\nsocial',1),(62,2,'Licenciatura en Matemáticas Aplicadas',9,'P','Formar Licenciados en Matemáticas Aplicadas capaces de diseñar modelos\ncuantitativos eficaces y confiables que incidan en la optimización de procesos\ny la toma de decisiones, y que describan fidedignamente fenómenos en las\nciencias y la tecnología para la resolución de problemas actuales en los ámbitos\nproductivo y de servicios; promover la enseñanza y el aprendizaje significativo\nde las matemáticas y física atendiendo las necesidades del ámbito de docencia,\nsiempre en el marco de la ética, humanismo y responsabilidad social',1),(64,2,'Químico Farmacéutico Biólogo',9,'P','Formar Químico Farmacéuticos Biólogos que se desempeñen honesta y\nresponsablemente en las áreas clínica, farmacéutica, industrial y de investigación,\npara contribuir al bienestar y desarrollo de la población local, nacional y global, en\nconcordancia con los principios éticos, humanistas y científicos',1),(67,2,'Ingeniería en Electrónica',9,'P','Formar Ingenieros en Electrónica capaces de diseñar, implementar, adaptar y mantener\nsistemas electrónicos en los ámbitos de control e instrumentación, diseño electrónico, sistemas\ndigitales y embebidos, internet de las cosas y telecomunicaciones de área local; contando con\nla capacidad de llevar a cabo la transferencia e innovación de tecnología electrónica, evaluar\nla pertinencia de proyectos y atender las necesidades de su entorno con ética, una visión\nhumanista y compromiso social',1),(69,2,'Ingeniero Industrial Estadístico',9,'P','Formar Ingenieros Industriales Estadísticos capaces de identificar, formular y\nresolver problemas en las áreas de Ingeniería Industrial, Estadística y Cómputo\nEstadístico, Administración y Automatización Industrial; así como innovar y\nemprender negocios, administrar, procesar, controlar y transmitir información\nde cadenas de valor, provenientes de la adecuada aplicación de conocimientos\ny habilidades en ingeniería, estadística, matemáticas, computación y\nadministración, con una perspectiva ética, humanista y con responsabilidad\nsocial',1),(81,2,'Licenciatura en Biotecnología',9,'P','Formar profesionistas capaces de desarrollar y aplicar herramientas\nbiotecnológicas que resuelvan problemas y atiendan necesidades de la\nsociedad en los ámbitos agrícola, forestal, pecuario, médico y farmacéutico,\nambiental, así como uso sostenible de la Biodiversidad del país. Esto con una\nperspectiva ética, humanista, emprendedora y con responsabilidad social',1),(88,2,'Licenciatura en Informática y Tecnologías Computacionales',9,'P','Formar Licenciados en Informática y Tecnologías Computacionales, capaces\nde analizar, diseñar e implementar soluciones basadas en Tecnologías de\nInformación que contribuyan a la creación de valor organizacional mediante el\ndesarrollo tecnológico en las áreas de programación e ingeniería de software,\ngestión de proyectos informáticos, tratamiento de la información y gestión de\nservicios digitales, de forma innovadora y humanista, con perspectiva ética y\nde responsabilidad social y ambiental',1),(33,1,'Médico Veterinario Zootecnista',10,'P','Formar Médicos Veterinarios Zootecnistas humanistas, reflexivos y socialmente\nresponsables, capaces de contribuir de manera decisiva a que los animales\ndomésticos se preserven sanos, con niveles óptimos de bienestar y desempeño\nproductivo, así como capaces de facilitar el desarrollo rural sustentable y evitar\nla transmisión de enfermedades al humano mediante el aseguramiento de la\ncalidad e inocuidad de alimentos y las acciones de la salud pública veterinaria,\nbajo el concepto de una salud',1),(66,2,'Ingeniería en Computación Inteligente',10,'P','Formar Ingenieros en Computación Inteligente, con conocimientos sólidos\nde los fundamentos matemáticos y teóricos de las Ciencias de la\nComputación, de Inteligencia Artificial e Industria de Software, a través de\nla concepción y creación de ambientes, facilidades y aplicaciones innovadoras\nde la computación, la construcción de software de base y de aplicaciones,\nelaboración de teorías y prácticas de modelos de realidades complejas y\nemprendimiento a fin de dar soluciones computacionales eficientes a\nproblemas reales y complejos; asimilar y adaptar nuevas tecnologías así como\nnuevas metodologías para el desarrollo de software, participar en equipos\nmultidisciplinarios y adaptarse a los rápidos cambios que se producen en las\nCiencias de la Computación y en la Industria de Software, con un alto sentido de\nresponsabilidad social, innovador y humanista',1),(41,1,'Ingeniería en Agronomía',8,'P','Formar Ingenieros Agrónomos con una visión integral, capaces de aplicar,\ninnovar y transmitir conocimientos pertinentes y socialmente relevantes\nque les permitan enfrentar, adaptar y solucionar problemas en diversas\nsituaciones y cambios del contexto agrícola, que respondan a las necesidades\nde producción, gestión de recursos e innovación agrícola, bajo los principios\nhumanísticos y el cuidado del medio ambiente',1),(92,1,'Ingeniería en Alimentos',8,'P','Formar Ingenieros en Alimentos con una visión integral, capaces de\notorgar valor agregado a materias primas agropecuarias, promoviendo el\ndesarrollo industrial a través de aplicar, adaptar, innovar o generar procesos\nde manufactura, gestión de calidad y seguridad alimentaria en empresas\nagroindustriales, respondiendo a las necesidades de desarrollo social y de\nglobalización; conscientes de la sustentabilidad y de aprovechamiento eficiente\nde los recursos bajo un enfoque de ética humanista y de responsabilidad social',1),(23,5,'Licenciatura en Urbanismo',9,'P','Formar Licenciados en Urbanismo con conocimientos, habilidades, actitudes y\nvalores para elaborar, gestionar, implementar y evaluar proyectos en los ámbitos de:\nPlaneación urbana y ordenamiento del territorio; Diseño urbano; e, Investigación\nurbana, en diferentes escalas territoriales, con el fin de contribuir al logro de\nciudades, asentamientos humanos y territorios sostenibles, seguros, incluyentes,\nasequibles, aportando un ambiente construido e inteligentes que mejoren la\ncalidad de vida de sus habitantes de forma ética, responsable y comprometida\ncon la sociedad y el medio ambiente',1),(25,5,'Licenciatura en Diseño de Moda en Indumentaria y Textiles',9,'P','Formar Licenciados en Diseño de Moda en Indumentaria y Textiles creativos,\ncon iniciativa y espíritu humanista, capaces de desarrollar productos y\nservicios de diseño de moda incluyente, rentable, sostenible y con identidad\nsociocultural, en los ámbitos de diseño e innovación, producción, desarrollo\ncomercial y comunicación, promoción y difusión de la moda, con impacto a\nnivel local, regional, nacional e internacional',1),(27,5,'Licenciatura en Diseño Gráfico',9,'P','Formar Licenciados en Diseño Gráfico capaces de analizar, generar, aplicar y\nevaluar estrategias de comunicación visual en los ámbitos de diseño gráfico de\nservicios y productos, reproducción de la imagen y de gestión estratégica para\nintervenir problemas complejos en entornos impresos y digitales, de forma\ncreativa, innovadora, ética, responsable, sostenible y con liderazgo',1),(28,5,'Licenciatura en Diseño de Interiores',9,'P','Formar Licenciados en Diseño de Interiores capaces de ofrecer soluciones de\ndiseño y construcción para habilitar, adecuar, re-utilizar y conservar espacios\ninteriores habitables bajo una relación íntima entre el espacio, el objeto y el\nhabitante mediante la aplicación de métodos y estrategias holísticas con la\nfinalidad de mejorar la calidad de vida del ser humano a través de su habitar,\ndesde una perspectiva emprendedora, ética, humanista y con responsabilidad\nsocial',1),(53,6,'Licenciatura en Comercio Internacional',9,'P','Formar Licenciados en Comercio Internacional capaces de analizar el entorno\neconómico y los tratados internacionales para detectar oportunidades de\ncomercio e inversión en los diversos mercados, estableciendo protocolos de\nnegocios en los diferentes ámbitos multiculturales; realizar las actividades\nde importación y exportación de acuerdo con los procedimientos de la\ngestión aduanera, así como el diseño e implementación de planes logísticos\ny la elaboración de contratos de mercadería internacional, con espíritu\nemprendedor, responsabilidad social y ética profesional',1),(21,5,'Arquitectura',10,'P','Formar Licenciados en Arquitectura altamente competentes en los ámbitos\ndel diseño arquitectónico-urbano y de la edificación de espacios habitables\npara planear, diseñar y construir espacios que permitan el desarrollo de\nciudades sustentables y que contribuyan al bienestar de la necesidades de la\nsociedad a nivel local, regional, nacional e internacional; con la capacidad para\ninterpretar los factores sociales, culturales, medio ambientales y tecnológicos\nconstructivos con el objeto de mejorar la calidad de vida del ser humano, con\nuna perspectiva ética y humanista, sensibles a los problemas del entorno',1),(22,5,'Ingeniería Civil',10,'P','Formar profesionales en la Ingeniería Civil capaces de planear y evaluar proyectos\nde ingeniería para diseñar, construir y mantener obras civiles en los ámbitos\nde las estructuras, cimentaciones, vías terrestres; así como obras hidráulicas y\nambientales, con la finalidad de atender los requerimientos de infraestructura\nque satisfagan las necesidades sociales, con criterios de sostenibilidad, factibilidad\ny seguridad; con una perspectiva ética y humanista, en un marco de pluralismo,\nautonomía, responsabilidad social, calidad e innovación',1),(31,4,'Médico Cirujano',10,'P','Formar Médicos Cirujanos altamente competentes en el cuidado de la salud\nindividual y colectiva, que respondan a las necesidades de atención médica\nderivadas de los perfiles epidemiológico y demográfico actuales; en la prevención,\ncuración y rehabilitación de los pacientes, en los ámbitos clínico, salud pública e\ninvestigación, a través de un trabajo interdisciplinario y multidisciplinario, con\nactitud ética y humanista',1),(32,4,'Médico Estomatólogo',10,'P','Formar Médicos Estomatólogos capaces de realizar acciones preventivas para la\npromoción de la salud bucal, además de desarrollar técnicas y métodos dirigidos\na diagnosticar, atender y resolver las patologías bucodentales de la población\nen general mediante el uso de equipo, instrumental y materiales odontológicos\nde vanguardia; además de involucrarse en la investigación de diversas áreas\nestomatológicas que le permitan actualizarse y generar conocimientos innovadores\npara su formación, con calidad humana y ética profesional',1),(29,5,'Licenciatura en Diseño Industrial',8,'P','Formar diseñadores industriales, capaces de diseñar y desarrollar de manera\nintegral productos y servicios caracterizados por su innovación, usabilidad,\nfactibilidad, rentabilidad, y responsabilidad hacia el medio ambiente y la\nsociedad y contribuir en la competitividad de las empresas, bajo un enfoque\nresponsable, ético y con espíritu emprendedor',1),(34,4,'Licenciatura en Terapia Física',8,'P','Formar Licenciados en Terapia Física competentes, capaces de participar en\nestrategias de prevención para personas con riesgo a desarrollar una discapacidad,\nofrecer servicios de valoración a individuos y poblaciones para diagnosticar, mantener\ny restaurar el máximo movimiento y la capacidad funcional durante todo el ciclo de\nvida, para la reintegración social de las personas con alguna discapacidad, colaborar\ncon equipos inter y multidisciplinarios en los ámbitos de prevención, rehabilitación y\ngestión terapéutica, con apoyo de los avances tecnológicos en fisioterapia, desde una\nperspectiva ética, científica, humanista, emprendedora y con responsabilidad social',1),(36,4,'Licenciatura en Optometría',8,'P','Formar Licenciados en Optometría capacitados para prevenir y diagnosticar:\nametropías, alteraciones funcionales binoculares, deficiencias visuales-perceptuales\ny alteraciones de la salud ocular; así como realizar el tratamiento y/o rehabilitación\npor medio de sistemas ópticos, entrenamiento visual-perceptual y terapéutica\ntópica en enfermedades del segmento anterior; aplicando tratamientos oftálmicos\ninnovadores e involucrándose en actividades de investigación que permitan\nestar a la vanguardia en el ejercicio de la profesión con actitud ética, humanista y\ncomprometidos con la sociedad',1),(38,4,'Licenciatura en Enfermería',8,'P','Formar Licenciados en Enfermería capaces de otorgar cuidados integrales a\nla persona en todas las etapas de vida y promover el autocuidado, a través del\nproceso de enfermería y aplicar las bases científicas de la disciplina con el apoyo\nde la tecnología en los ámbitos asistencial, educación para la salud, investigación\ny administración; con un sentido humanista, de servicio y responsabilidad social',1),(39,4,'Licenciatura en Nutrición',8,'P','Formar Licenciados en Nutrición competentes y líderes en su campo profesional,\nque se desempeñen con calidad y rigor científico en el diagnóstico del estado\nnutricio en individuos sanos, en riesgo y enfermos, la modificación de conductas\ny hábitos relacionados con la alimentación, la administración de servicios de\nalimentos y la implementación de programas de alimentación y nutrición,\ntanto de forma individualizada como colectiva; con capacidad para trabajar en\ngrupos inter y multidisciplinarios, así como actitud de servicio y conscientes de la\nresponsabilidad ética y social en su desempeño profesional',1),(40,4,'Licenciatura en Cultura Física y Deporte',8,'P','Formar licenciados en cultura física y deporte que prescriban ejercicio físico\nadaptado a las características de cada grupo poblacional, a través del diseño,\norganización, aplicación, supervisión y evaluación de planes y sesiones de actividad\nfísica en los ámbitos del deporte, la salud, la educación física y la gestión deportiva,\ncon una perspectiva humanista, ética, colaborativa e inclusiva a fin de fomentar\nestilos de vida saludable en la población',1),(51,6,'Contador Público',8,'P','Formar Contadores Públicos altamente capacitados en la presentación, análisis,\ninterpretación y auditoría, de estados financieros; en la aplicación de las\ndisposiciones fiscales; determinación correcta del costo en productos y servicios;\ny en la administración y gestión de los recursos financieros; siendo competitivos\nen el sector público y privado, para una adecuada toma de decisiones, con\nsentido ético, de liderazgo y de responsabilidad social, beneficiando el desarrollo\neconómico y social',1),(52,6,'Licenciatura en Administración de Empresas',8,'P','Formar Licenciados en Administración de Empresas con capacidad para desarrollar\nsoluciones estratégicas integrales a problemas administrativos, organizacionales,\nde recursos humanos, financieros, de mercadotecnia y de operaciones en los\námbitos de la gestión organizacional y de dirección de proyectos empresariales\ncon actitud ética, responsable, humanista y comprometida con el desarrollo\nsustentable',1),(54,6,'Licenciatura en Administración de la Producción y Servicios',8,'P','Formar Licenciados en Administración de la Producción y Servicios, capaces de\ncoordinar las áreas funcionales de la empresa con el área de operación, a través del\nanálisis, evaluación, diseño y aplicación de estrategias organizacionales, mediante\nla administración de procesos, de materiales, de calidad y de capital, para optimizar\nresultados de los sistemas productivos de bienes y servicios que generen ventajas\ncompetitivas dentro de un mercado global, con una perspectiva de responsabilidad\nsocial, ética y humanista inherentes al desempeño de su profesión, de manera\ninnovadora, asertiva y con alto sentido de liderazgo',1),(55,6,'Licenciatura en Administración Financiera',8,'P','Formar Licenciados en Administración Financiera competentes y especializados\nque les permita administrar, gestionar, evaluar y establecer estrategias para\nincrementar la riqueza, administrando el riesgo, en los ámbitos del Sistema\nFinanciero, de Negocios, de las Finanzas públicas e Internacionales, con\ncapacidad emprendedora y una sólida formación ética con perspectiva\nhumanista y de responsabilidad social comprometidos con el desarrollo local,\nregional y nacional',1),(56,6,'Licenciatura en Relaciones Industriales',8,'P','Formar Licenciados en Relaciones Industriales, capaces de desarrollar diferentes\ntécnicas para la organización del trabajo y la gestión avanzada del capital humano\nque eleven la calidad de vida del trabajador, promuevan la productividad y faciliten\nel crecimiento sostenible de las organizaciones, en las áreas de Administración de\nRecursos Humanos, Desarrollo de Personal, Gestión Laboral, Producción y Calidad,\nen un marco de equidad con una actitud comprometida hacia el desarrollo\nsostenible, orientación humanista y sensibilidad hacia su entorno',1),(57,6,'Licenciatura en Economía',8,'P','Formar Licenciados en Economía capaces de evaluar y proponer planes,\nprogramas y proyectos en los ámbitos de economía de la empresa, economía\nfinanciera, economía pública, economía internacional, crecimiento y desarrollo\neconómico con la finalidad de resolver problemas económicos y sociales de\ncrecimiento y desarrollo sustentable, así como, determinar el impacto de las\nvariables económico financieras a nivel internacional, nacional y local, de forma\nética, crítica, plural, con sentido humanista y de responsabilidad social',1),(59,6,'Licenciatura en Mercadotecnia',8,'P','Formar licenciados en Mercadotecnia, líderes en la dirección estratégica de marketing\ny ventas, Inteligencia de mercados, generación de valor para el cliente, promoción y\ndistribución, y creatividad y generación de negocios, así como el emprendimiento\nde un negocio con enfoque humanista, sostenible, global y ético que fomenten la\ncalidad de vida de los clientes para lograr una sociedad más equitativa y justa',1),(77,6,'Licenciatura en Gestión Turística',8,'P','Formar Licenciados en Gestión Turística con conocimiento de las dimensiones\ndel turismo y de sus principales estructuras socio-políticas y administrativas,\nhábiles en la toma de decisiones sustentadas en la investigación, capaces de\nrealizar de manera eficiente y sostenible actividades directivas y de gestión en\nlos ámbitos de planificación pública de destinos, de desarrollo de productos\ny actividades turísticas, alojamiento, alimentos y bebidas, intermediación,\ntransportación y logística; ofreciendo servicios de consultoría y apoyo al sector\npúblico y empresarial, todo ello con sentido ético y de responsabilidad social\npara el desempeño de sus funciones',1),(10,9,'Licenciatura en Letras Hispánicas',9,'P','Formar Licenciados en Letras Hispánicas capaces de analizar, reflexionar y\nprofundizar en los distintos ámbitos de estudio de la lengua y la literatura desde sus orígenes, desarrollo y hasta nuestros días, y su relación con otras disciplinas para su implementación en la enseñanza, la filología, la asesoría lingüística, la difusión y la\ndivulgación de la lengua y la literatura, la crítica y los procesos de creación a través de\nmetodologías de investigación con pensamiento crítico y empatía ante la diversidad\nsociocultural contemporánea, ética profesional y humanismo',1),(12,9,'Licenciatura en Artes Cinematográficas y Audiovisuales',9,'P','Formar Licenciados en Artes Cinematográficas y Audiovisuales con\nconocimientos y habilidades en realización, producción, gestión, distribución\ny análisis del fenómeno cinematográfico, para crear obras y productos\naudiovisuales con un sentido crítico, ético y responsable socialmente',1),(15,8,'Licenciatura en Trabajo Social',9,'P','Formar profesionistas en Trabajo Social capaces de analizar, diagnosticar y sistematizar\nfenómenos sociales para diseñar, aplicar y evaluar modelos de intervención en\nlos diferentes niveles de actuación: individual, familiar, grupal y comunitario de\nmanera innovadora; con la finalidad de promover cambios sociales en los ámbitos\nde bienestar social, promoción social y emergente, en el sector público, privado y\nen las organizaciones de la sociedad civil, bajo un enfoque multi y transdisciplinar\ncon humanismo, perspectiva de género, responsabilidad social y ambiental, ética\nprofesional y empatía ante la diversidad sociocultural contemporánea',1),(71,8,'Licenciatura en Psicología',9,'P','Formar Licenciados en Psicología con conocimientos teóricos y metodológicos\nsobre el comportamiento humano, con habilidades para integrar los avances de\nla investigación científica a su práctica psicológica, tanto en la evaluación del\ncomportamiento de los individuos como en su intervención en diferentes ámbitos\ny etapas de su vida, en las diferentes áreas de aplicación de la psicología clínica y\nde la salud, educativa, del trabajo y las organizaciones, social y comunitaria. Con\nactitudes de colaboración y trabajo interdisciplinario con otros; valores éticos,\nhumanistas y con perspectiva de género',1),(74,8,'Licenciatura en Ciencias Políticas y Administración Pública',9,'P','Formar Licenciadas/os en Ciencias Políticas y Administración Pública analíticos y críticos, capaces de examinar\ny exponer científicamente los problemas y fenómenos políticos, sociales y gubernamentales para responder\na las necesidades de nuestra colectividad y tener una gestión pública de calidad y una sociedad democrática,\njusta, plural y participativa; mediante el diseño, implementación y evaluación de políticas públicas y modelos de\nacción colectiva, participación ciudadana, integración y colaboración institucional favoreciendo la transparencia\ny rendición de cuentas, vinculada a los principios de gobierno abierto y la gobernanza con una perspectiva de\ngénero, ética, humanista y con apego a la responsabilidad y sustentabilidad social',1),(78,9,'Licenciatura en Estudios del Arte y Gestión Cultural',9,'P','Formar Licenciados en Estudios del Arte y Gestión Cultural competentes en el análisis,\ndiseño, implementación y evaluación de programas de cultura y educación artística\npertinentes e innovadores a través de la gestión de proyectos, promoción, difusión\ny el fomento de las artes y la cultura en todos los ámbitos de la vida social; así como\ncon diferentes herramientas en estudios del arte, investigación y metodologías, de\npatrimonio y de gestión que les permitan desempeñarse desde una perspectiva\ncrítica, contemporánea, con humanismo, ética, responsabilidad social, perspectiva de\ngénero y desde una mirada incluyente basada en el respeto',1),(86,7,'Licenciatura en Agronegocios',9,'P','Formar Licenciados en Agronegocios capaces de gestionar, desarrollar, evaluar\ne implementar proyectos productivos que impulsen la competitividad del sector\nagroalimentario con un enfoque empresarial a través de diferentes estrategias\nque permitan mejorar la comercialización de los productos y servicios, así como\nla integración de cadenas productivas desde una perspectiva de desarrollo\nsostenible e innovadora, que dé respuesta a las necesidades de la industria, de\nuna manera ética, humanista y responsable socialmente',1),(87,7,'Licenciatura en Comercio Electrónico',9,'P','Formar Licenciados en Comercio Electrónico que identifiquen y satisfagan\nlas necesidades económicas de las empresas a través de la eficiente gestión\ndel e-Commerce, mediante diversos intermediarios electrónicos, plataformas\ntransaccionales y herramientas digitales para comercializar de forma segura\nproductos físicos y virtuales, a través de la implementación de estrategias\nelectrónicas para la arquitectura de marca y posicionamiento online; así como la\nadministración de recursos humanos, tecnológicos, económicos y de información\nque promuevan el desarrollo de sitios virtuales caracterizados por su rentabilidad,\nsustentabilidad y rendimiento optimizado de acuerdo al entorno de los mercados\ny necesidades sociales. Desde una perspectiva ética, humanista, autónoma, de\ncalidad y responsabilidad social',1),(14,8,'Licenciatura en Docencia de Francés y Español como Lenguas Extranjeras',10,'P','Formar profesionistas capaces de diseñar, implementar y evaluar experiencias\nformativas para los procesos de enseñanza y aprendizaje de francés y español como\nlenguas extranjeras, así como de difundir las culturas inherentes a dichos idiomas\nen diferentes contextos, modalidades y niveles educativos con fines lingüísticos y\ncomunicativos a través de una perspectiva humanista y de compromiso ante las\nnecesidades actuales de la sociedad',1),(17,8,'Licenciatura en Derecho',10,'P','Formar Licenciados en Derecho altamente cualificados en el conocimiento del\norden jurídico nacional e internacional, su interpretación y argumentación, con la\ncapacidad de prever y resolver los problemas jurídicos en el ámbito de lo público,\nprivado y lo social, con un enfoque de respeto de la juridicidad, el pluralismo y\nlos derechos humanos, con responsabilidad social, perspectiva humanista y de\ngénero',1),(79,9,'Licenciatura en Música',10,'P','Formar Licenciados en Música creativos y autocríticos, con un alto sentido de\nautonomía y responsabilidad social, capaces de realizar interpretaciones de alto valor\nestético e implementar proyectos educativos que promuevan el desarrollo de la\nsensibilidad y la expresión musical',1),(13,8,'Licenciado en Sociología',8,'P','Formar al Licenciado en Sociología como investigador y profesionista capaz\nde aplicar los conceptos y perspectivas sociológicas en el análisis de diversas\nproblemáticas sociales, en diferentes contextos sociales y en colaboración con\notras disciplinas; de identificar y diagnosticar los fenómenos sociales y prever sus\nimpactos en la sociedad; de diseñar proyectos de investigación, en la elaboración\nde programas de política social, así como en el análisis de las instituciones y las\norganizaciones, que podrá aplicar en la práctica académica, en instituciones\npúblicas, privadas o en la asesoría profesional independiente, con un alto sentido\nde compromiso y responsabilidad social',1),(18,8,'Licenciatura en Comunicación e Información',8,'P','Formar Licenciados en Comunicación e Información, conscientes de las\nproblemáticas sociales, políticas y culturales contemporáneas, capaces de generar\nplanes, programas y productos comunicativos para desempeñarse en los ámbitos\nde la comunicación pública, el periodismo y la realización de narrativas en soportes\nmediáticos que promuevan una comunicación democrática y sostenible, con una\nperspectiva humanista, de justicia y responsabilidad social',1),(20,8,'Licenciatura en Asesoría Psicopedagógica',8,'P','Formar Licenciados en Asesoría Psicopedagógica con los conocimientos,\nhabilidades, actitudes y valores necesarios para el manejo de los elementos teóricos\ny metodológicos en los ámbitos de Orientación e intervención psicopedagógica;\nDocencia, currículo y evaluación; así como, Gestión y política educativa; que atiendan\nnecesidades de formación a partir del diseño, implementación y evaluación de\nprogramas, en los contextos de Educación Formal y Socioeducativo, con una\nperspectiva interdisciplinaria, humanista y comprometida con el desarrollo de la\nsociedad',1),(70,8,'Licenciatura en Historia',8,'P','Formar Licenciados en Historia capaces de valorar y generar conocimiento\nhistórico que contribuya a la comprensión del presente de manera crítica a través\nde la investigación; de transmitir el saber histórico de forma integral y creativa\npor medio de la docencia y la divulgación; así como participar en la gestión\ny conservación del patrimonio histórico, con apertura y respeto a la diversidad\ncultural',1),(72,8,'Licenciatura en Filosofía',8,'P','Formar Licenciados y Licenciadas en Filosofía con un conocimiento integral\ny reflexivo del saber filosófico disciplinar que les permita analizar, interpretar,\ntransmitir, promover y aplicar la filosofía en problemáticas ambientales, bioéticas,\nde género, de la ciencia con la tecnología y la sociedad, antropológicas, estéticas\ny epistemológicas, a través de la docencia, la investigación y la divulgación para\nque sean capaces de generar nuevos conocimientos e interpretaciones críticohumanistas con un criterio metodológico-filosófico, apoyándose en otras\ndisciplinas científicas y sociales, que les permita formarse una conciencia crítica de\nla sociedad y la cultura para contribuir al diálogo argumentativo y ético, resultado\nde sus investigaciones',1),(73,8,'Licenciatura en Docencia del Idioma Inglés',8,'P','Formar Licenciados en la Docencia del Idioma Inglés íntegros y comprometidos\ncon la educación, quienes dominan el idioma inglés como lengua de\ncomunicación global, así como los conocimientos y habilidades lingüísticas,\nmetodológicas, tecnológicas y culturales en la docencia del inglés en los\ndiferentes niveles educativos; con cualidades humanistas y principios éticos\nque les permitan responder a las problemáticas sociales en sus ámbitos de\ndesempeño a nivel regional, nacional e internacional',1),(84,7,'Licenciatura en Administración y Gestión Fiscal de PyMEs',8,'P','Formar Licenciados en Administración y Gestión Fiscal de PyMEs capaces de\naplicar correctamente la legislación fiscal vigente; implementar la dirección\nadministrativa eficiente en las Pequeñas y Medianas Empresas y proporcionar\nasesoría fiscal relacionada en materia laboral, seguridad social, legal y tributación\ndel comercio exterior con la finalidad de incrementar el desarrollo, productividad\ny competitividad en las organizaciones públicas y privadas desde una perspectiva\nética, humanista, emprendedora y con responsabilidad social',1),(85,7,'Licenciatura en Logística Empresarial',8,'P','Formar Licenciados en Logística Empresarial altamente capacitados en la gestión\nde la cadena de suministro y sus procesos logísticos asociados al movimiento\nde mercancías, aprovisionamiento, almacenamiento, distribución, transporte,\ntrámites aduanales y comercialización de bienes y servicios; incidiendo en la\ndirección empresarial y en la implementación adecuada de la normatividad\nvigente, para ofrecer soluciones innovadoras y sustentables en las organizaciones\npúblicas y privadas, mejorando su desempeño e índice de calidad, con una\nperspectiva humanista, ética y socialmente responsable',1),(93,8,'Licenciatura en Comunicación Corporativa Estratégica',8,'P','Formar Licenciados en Comunicación Corporativa Estratégica que diseñen,\nimplementen y evalúen estrategias y programas de comunicación integral para\nentidades de tipo empresarial, público y social, en los ámbitos de relaciones públicas,\nalianzas estratégicas y networking; comunicación interna para la productividad y\nel desarrollo de las organizaciones y las personas; imagen y reputación para la\nciudadanía corporativa y la sostenibilidad social; así como gestión de medios,\nadministración de redes sociales y producción de contenidos multiplataforma; a\ntravés de una sólida formación teórica, metodológica y práctica, con perspectiva\nhumanista, multicultural, incluyente y ética',1),(94,9,'Licenciatura en Actuación',8,'P','Formar Licenciados en Actuación, con un amplio conocimiento de los procesos\ncreativos y el quehacer escénico del actor, así como de los principios de dirección\nescénica, gestión y producción de proyectos artísticos y enseñanza del teatro\nen nivel básico y medio superior; con la finalidad de formar actores críticos\nque puedan desempeñarse sólidamente en la interpretación, desarrollen\npropuestas que contribuyan a la renovación de la escena con compromiso\nsocial, ético y humanista',1);
/*!40000 ALTER TABLE `Carrera` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_insertar_hijo_carrera` BEFORE INSERT ON `Carrera` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Centro WHERE Centro.centro_id = NEW.centro_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Centro.';
    END IF;
    IF((SELECT COUNT(*) FROM Carrera WHERE Carrera.carrera_id = NEW.carrera_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (carrera_id) ya existe en la tabla Carrera.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_actualizar_hijo_carrera` BEFORE UPDATE ON `Carrera` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Centro WHERE Centro.centro_id = NEW.centro_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Centro.';
    END IF;
    IF(OLD.carrera_id <> NEW.carrera_id AND (SELECT COUNT(*) FROM Carrera WHERE Carrera.carrera_id = NEW.carrera_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (carrera_id) ya existe en la tabla Carrera.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_actualizar_padre_carrera` AFTER UPDATE ON `Carrera` FOR EACH ROW BEGIN
    UPDATE Plan_Estudio SET Plan_Estudio.carrera_id = NEW.carrera_id WHERE Plan_Estudio.carrera_id = OLD.carrera_id;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `restringir_eliminar_padre_carrera` AFTER DELETE ON `Carrera` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Plan_Estudio WHERE Plan_Estudio.carrera_id = OLD.carrera_id) <> 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede eliminar el registro. La llave foránea existe en la tabla Plan_Estudio.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Centro`
--

DROP TABLE IF EXISTS `Centro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Centro` (
  `centro_id` int NOT NULL AUTO_INCREMENT,
  `centro_nombre` varchar(255) NOT NULL,
  `centro_acronimo` varchar(10) NOT NULL,
  `centro_direccion` tinytext NOT NULL,
  `centro_telefono` varchar(10) NOT NULL,
  `centro_extension` varchar(5) NOT NULL,
  `centro_vigente` tinyint NOT NULL,
  PRIMARY KEY (`centro_id`),
  CONSTRAINT `CK_centro_vigente` CHECK ((`centro_vigente` between 0 and 1))
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50100 PARTITION BY RANGE (`centro_id`)
(PARTITION p0 VALUES LESS THAN (6) ENGINE = InnoDB,
 PARTITION p1 VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Centro`
--

LOCK TABLES `Centro` WRITE;
/*!40000 ALTER TABLE `Centro` DISABLE KEYS */;
INSERT INTO `Centro` VALUES (1,'Centro de Ciencias Agropecuarias','CCA','Carr. Jesus Maria - Posta Zootécnica, 20900 Jesús María, Ags.','4499107400','50012',1),(2,'Centro de Ciencias Básicas','CCB','Avenida Universidad # 940, Universidad Autónoma de Aguascalientes, 20130 Aguascalientes, Ags.','4499108400','8400',1),(3,'Centro de Ciencias de la Ingeniería','CCI','Avenida Mahatma Gahndi 6601 El Gigante, 20340 Aguascalientes, Ags.','4499107400','9510',1),(4,'Centro de Ciencias de la Salud','CCS','101, Ciudad Universitaria, Universidad Autónoma de Aguascalientes, 20100 Aguascalientes, Ags.','4499108430','8430',1),(5,'Centro de Ciencias del Diseño y de la Construcción','CCDC','Avenida Universidad # 940, Universidad Autónoma de Aguascalientes, 20130 Aguascalientes, Ags.','4499107400','10013',1),(6,'Centro de Ciencias Económicas y Administrativas','CCEA','Av. Aguascalientes Nte, Universidad Autónoma de Aguascalientes, 20130 Aguascalientes, Ags.','4499107400','55012',1),(7,'Centro de Ciencias Empresariales','CCE','Avenida Mahatma Gahndi 6601 El Gigante, 20340 Aguascalientes, Ags.','4499107400','9530',1),(8,'Centro de Ciencias Sociales y Humanidades','CCSH','Avenida Universidad # 940, Universidad Autónoma de Aguascalientes, 20130 Aguascalientes, Ags.','4499107400','8480',1),(9,'Centro de las Artes y la Cultura','CAC','Avenida Universidad # 940, Universidad Autónoma de Aguascalientes, 20130 Aguascalientes, Ags.','4499107400','58012',1);
/*!40000 ALTER TABLE `Centro` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_actualizar_padre_centro` AFTER UPDATE ON `Centro` FOR EACH ROW BEGIN
    UPDATE Carrera SET Carrera.centro_id = NEW.centro_id WHERE Carrera.centro_id = OLD.centro_id;
    UPDATE Departamento SET Departamento.centro_id = NEW.centro_id WHERE Departamento.centro_id = OLD.centro_id;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `restringir_eliminar_padre_centro` AFTER DELETE ON `Centro` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Carrera WHERE Carrera.centro_id = OLD.centro_id) <> 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede eliminar el registro. La llave foránea existe en la tabla Carrera.';
    END IF;
    IF(SELECT COUNT(*) FROM Departamento WHERE Departamento.centro_id = OLD.centro_id) <> 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede eliminar el registro. La llave foránea existe en la tabla Departamento.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Departamento`
--

DROP TABLE IF EXISTS `Departamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Departamento` (
  `departamento_id` int NOT NULL AUTO_INCREMENT,
  `departamento_nombre` varchar(255) NOT NULL,
  `centro_id` int NOT NULL,
  PRIMARY KEY (`departamento_id`,`centro_id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50100 PARTITION BY RANGE (`centro_id`)
(PARTITION p0 VALUES LESS THAN (6) ENGINE = InnoDB,
 PARTITION p1 VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Departamento`
--

LOCK TABLES `Departamento` WRITE;
/*!40000 ALTER TABLE `Departamento` DISABLE KEYS */;
INSERT INTO `Departamento` VALUES (1,'Departamento de Ciencias Agronómicas',1),(2,'Departamento de Ciencias de los Alimentos',1),(3,'Departamento de Ciencias Veterinarias',1),(4,'Departamento de Biología',2),(5,'Departamento de Ciencias de la Computación',2),(6,'Departamento de Estadística',2),(7,'Departamento de Fisiología y Farmacología',2),(8,'Departamento de Ingeniería Bioquímica',2),(9,'Departamento de Matemáticas y Física',2),(10,'Departamento de Microbiología',2),(11,'Departamento de Morfología',2),(12,'Departamento de Química',2),(13,'Departamento de Sistemas de Información',2),(14,'Departamento de Sistemas Electrónicos',2),(15,'Departamento de Ingeniería Automotriz',3),(16,'Departamento de Ingeniería Biomédica',3),(17,'Departamento de Ingeniería Robótica',3),(18,'Departamento de Cultura Física y Salud Pública',4),(19,'Departamento de Enfermería',4),(20,'Departamento de Estomatología',4),(21,'Departamento de Medicina',4),(22,'Departamento de Nutrición',4),(23,'Departamento de Optometría',4),(24,'Departamento de Terapia Física',4),(25,'Departamento de Arquitectura',5),(26,'Departamento de Diseño de Interiores',5),(27,'Departamento de Diseño de Moda',5),(28,'Departamento de Diseño Gráfico',5),(29,'Departamento de Diseño Industrial',5),(30,'Departamento de Ingeniería Civil',5),(31,'Departamento de Urbanismo',5),(32,'Departamento de Administración',6),(33,'Departamento de Contaduría',6),(34,'Departamento de Economía',6),(35,'Departamento de Finanzas',6),(36,'Departamento de Mercadotecnia',6),(37,'Departamento de Recursos Humanos',6),(38,'Departamento de Turismo',6),(39,'Departamento de Administración y Gestión Fiscal de PyMEs',7),(40,'Departamento de Agronegocios',7),(41,'Departamento de Comercio Electrónico',7),(42,'Departamento de Logística Empresarial',7),(43,'Departamento de Ciencias Políticas y Administración Pública',8),(44,'Departamento de Comunicación',8),(45,'Departamento de Derecho',8),(46,'Departamento de Educación',8),(47,'Departamento de Filosofía',8),(48,'Departamento de Historia',8),(49,'Departamento de Idiomas',8),(50,'Departamento de Psicología',8),(51,'Departamento de Sociología',8),(52,'Departamento de Trabajo Social',8),(53,'Departamento de Arte y Gestión Cultural',9),(54,'Departamento de Artes Escénicas y Audiovisuales',9),(55,'Departamento de Letras',9),(56,'Departamento de Música',9),(57,'',9);
/*!40000 ALTER TABLE `Departamento` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_insertar_hijo_departamento` BEFORE INSERT ON `Departamento` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Centro WHERE Centro.centro_id = NEW.centro_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Centro.';
    END IF;
    IF((SELECT COUNT(*) FROM Departamento WHERE Departamento.departamento_id = NEW.departamento_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (departamento_id) ya existe en la tabla Departamento.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_actualizar_hijo_departamento` BEFORE UPDATE ON `Departamento` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Centro WHERE Centro.centro_id = NEW.centro_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Centro.';
    END IF;
    IF(OLD.departamento_id <> NEW.departamento_id AND (SELECT COUNT(*) FROM Departamento WHERE Departamento.departamento_id = NEW.departamento_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (departamento_id) ya existe en la tabla Departamento.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_actualizar_padre_departamento` AFTER UPDATE ON `Departamento` FOR EACH ROW BEGIN
    UPDATE Materia SET Materia.departamento_id = NEW.departamento_id WHERE Materia.departamento_id = OLD.departamento_id;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `restringir_eliminar_padre_departamento` AFTER DELETE ON `Departamento` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Materia WHERE Materia.departamento_id = OLD.departamento_id) <> 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede eliminar el registro. La llave foránea existe en la tabla Materia.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Materia`
--

DROP TABLE IF EXISTS `Materia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Materia` (
  `materia_id` int NOT NULL AUTO_INCREMENT,
  `materia_nombre` varchar(255) NOT NULL,
  `departamento_id` int NOT NULL,
  `materia_descripcion` text NOT NULL,
  `materia_vigente` tinyint NOT NULL,
  PRIMARY KEY (`materia_id`,`departamento_id`),
  CONSTRAINT `CK_materia_vigente` CHECK ((`materia_vigente` between 0 and 5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50100 PARTITION BY RANGE (`departamento_id`)
(PARTITION p0 VALUES LESS THAN (29) ENGINE = InnoDB,
 PARTITION p1 VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Materia`
--

LOCK TABLES `Materia` WRITE;
/*!40000 ALTER TABLE `Materia` DISABLE KEYS */;
/*!40000 ALTER TABLE `Materia` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_insertar_hijo_materia` BEFORE INSERT ON `Materia` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Departamento WHERE Departamento.departamento_id = NEW.departamento_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Departamento.';
    END IF;
    IF((SELECT COUNT(*) FROM Materia WHERE Materia.materia_id = NEW.materia_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (materia_id) ya existe en la tabla Materia.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_actualizar_hijo_materia` BEFORE UPDATE ON `Materia` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Departamento WHERE Departamento.departamento_id = NEW.departamento_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Departamento.';
    END IF;
    IF(OLD.materia_id <> NEW.materia_id AND (SELECT COUNT(*) FROM Materia WHERE Materia.materia_id = NEW.materia_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (materia_id) ya existe en la tabla Materia.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_actualizar_padre_materia` AFTER UPDATE ON `Materia` FOR EACH ROW BEGIN
    UPDATE Solicitud SET Solicitud.materia_id = NEW.materia_id WHERE Solicitud.materia_id = OLD.materia_id;
    UPDATE Materia_Tutor SET Materia_Tutor.materia_id = NEW.materia_id WHERE Materia_Tutor.materia_id = OLD.materia_id;
    UPDATE Materia_Plan SET Materia_Plan.materia_id = NEW.materia_id WHERE Materia_Plan.materia_id = OLD.materia_id;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_eliminar_padre_materia` AFTER DELETE ON `Materia` FOR EACH ROW BEGIN
    DELETE FROM Solicitud WHERE Solicitud.materia_id = OLD.materia_id;
    DELETE FROM Materia_Tutor WHERE Materia_Tutor.materia_id = OLD.materia_id;  
    DELETE FROM Materia_Plan WHERE Materia_Plan.materia_id = OLD.materia_id;  
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Materia_Plan`
--

DROP TABLE IF EXISTS `Materia_Plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Materia_Plan` (
  `materia_id` int NOT NULL,
  `plan_id` int NOT NULL,
  `semestre` int NOT NULL,
  PRIMARY KEY (`materia_id`,`plan_id`,`semestre`),
  CONSTRAINT `CK_semestre` CHECK ((`semestre` between 1 and 10))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50100 PARTITION BY RANGE (`semestre`)
(PARTITION p0 VALUES LESS THAN (3) ENGINE = InnoDB,
 PARTITION p1 VALUES LESS THAN (7) ENGINE = InnoDB,
 PARTITION p2 VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Materia_Plan`
--

LOCK TABLES `Materia_Plan` WRITE;
/*!40000 ALTER TABLE `Materia_Plan` DISABLE KEYS */;
/*!40000 ALTER TABLE `Materia_Plan` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_insertar_hijo_materia_plan` BEFORE INSERT ON `Materia_Plan` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Materia WHERE Materia.materia_id = NEW.materia_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Materia.';
    END IF;   
    IF(SELECT COUNT(*) FROM Plan_Estudio WHERE Plan_Estudio.plan_id = NEW.plan_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Plan_Estudio.';
    END IF;   
    IF((SELECT COUNT(*) FROM Materia_Plan WHERE Materia_Plan.plan_id = NEW.plan_id AND Materia_Plan.materia_id = NEW.materia_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (materia_id, plan_id) ya existe en la tabla Materia_Plan.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_actualizar_hijo_materia_plan` BEFORE UPDATE ON `Materia_Plan` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Materia WHERE Materia.materia_id = NEW.materia_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Materia.';
    END IF;
    IF(SELECT COUNT(*) FROM Plan_Estudio WHERE Plan_Estudio.plan_id = NEW.plan_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Plan_Estudio.';
    END IF; 
    IF((OLD.materia_id <> NEW.materia_id OR OLD.plan_id <> NEW.plan_id) AND (SELECT COUNT(*) FROM Materia_Plan WHERE Materia_Plan.plan_id = NEW.plan_id AND Materia_Plan.materia_id = NEW.materia_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (materia_id, plan_id) ya existe en la tabla Materia_Plan.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Materia_Tutor`
--

DROP TABLE IF EXISTS `Materia_Tutor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Materia_Tutor` (
  `tutor_id` int NOT NULL,
  `materia_id` int NOT NULL,
  `promedio_materia` decimal(10,0) NOT NULL,
  PRIMARY KEY (`tutor_id`,`materia_id`,`promedio_materia`),
  CONSTRAINT `CK_promedio_materia` CHECK ((`promedio_materia` between 8 and 10))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50100 PARTITION BY RANGE (floor(`promedio_materia`))
(PARTITION p0 VALUES LESS THAN (9) ENGINE = InnoDB,
 PARTITION p1 VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Materia_Tutor`
--

LOCK TABLES `Materia_Tutor` WRITE;
/*!40000 ALTER TABLE `Materia_Tutor` DISABLE KEYS */;
/*!40000 ALTER TABLE `Materia_Tutor` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_insertar_hijo_materia_tutor` BEFORE INSERT ON `Materia_Tutor` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Tutor WHERE Tutor.tutor_id = NEW.tutor_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Tutor.';
    END IF;   
    IF(SELECT COUNT(*) FROM Materia WHERE Materia.materia_id = NEW.materia_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Materia.';
    END IF; 
    IF((SELECT COUNT(*) FROM Materia_Tutor WHERE Materia_Tutor.materia_id = NEW.materia_id AND Materia_Tutor.tutor_id = NEW.tutor_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (tutor_id, materia_id) ya existe en la tabla Materia_Tutor.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_actualizar_hijo_materia_tutor` BEFORE UPDATE ON `Materia_Tutor` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Tutor WHERE Tutor.tutor_id = NEW.tutor_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Tutor.';
    END IF;
    IF(SELECT COUNT(*) FROM Materia WHERE Materia.materia_id = NEW.materia_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Materia.';
    END IF; 
    IF((OLD.tutor_id <> NEW.tutor_id OR OLD.materia_id <> NEW.materia_id) AND (SELECT COUNT(*) FROM Materia_Tutor WHERE Materia_Tutor.materia_id = NEW.materia_id AND Materia_Tutor.tutor_id = NEW.tutor_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (tutor_id, materia_id) ya existe en la tabla Materia_Tutor.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Plan_Estudio`
--

DROP TABLE IF EXISTS `Plan_Estudio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Plan_Estudio` (
  `plan_id` int NOT NULL,
  `carrera_id` int NOT NULL,
  `plan_fecha_inicio` datetime NOT NULL,
  `plan_fecha_fin` datetime NOT NULL,
  PRIMARY KEY (`plan_id`,`carrera_id`),
  CONSTRAINT `CK_restriccion_fechas` CHECK ((`plan_fecha_fin` > `plan_fecha_inicio`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50100 PARTITION BY RANGE (`carrera_id`)
(PARTITION p0 VALUES LESS THAN (21) ENGINE = InnoDB,
 PARTITION p1 VALUES LESS THAN (43) ENGINE = InnoDB,
 PARTITION p2 VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Plan_Estudio`
--

LOCK TABLES `Plan_Estudio` WRITE;
/*!40000 ALTER TABLE `Plan_Estudio` DISABLE KEYS */;
/*!40000 ALTER TABLE `Plan_Estudio` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_insertar_hijo_plan_estudio` BEFORE INSERT ON `Plan_Estudio` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Carrera WHERE Carrera.carrera_id = NEW.carrera_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Carrera.';
    END IF;
    IF((SELECT COUNT(*) FROM Plan_Estudio WHERE Plan_Estudio.plan_id = NEW.plan_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (plan_id) ya existe en la tabla Plan_Estudio.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_actualizar_hijo_plan_estudio` BEFORE UPDATE ON `Plan_Estudio` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Carrera WHERE Carrera.carrera_id = NEW.carrera_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Carrera.';
    END IF;
    IF(OLD.plan_id <> NEW.plan_id AND (SELECT COUNT(*) FROM Plan_Estudio WHERE Plan_Estudio.plan_id = NEW.plan_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (plan_id) ya existe en la tabla Plan_Estudio.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_actualizar_padre_plan_estudio` AFTER UPDATE ON `Plan_Estudio` FOR EACH ROW BEGIN
    UPDATE Alumno SET Alumno.plan_id = NEW.plan_id WHERE Alumno.plan_id = OLD.plan_id;
    UPDATE Materia_Plan SET Materia_Plan.plan_id = NEW.plan_id WHERE Materia_Plan.plan_id = OLD.plan_id;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_eliminar_padre_plan_estudio` AFTER DELETE ON `Plan_Estudio` FOR EACH ROW BEGIN
    DELETE FROM Alumno WHERE Alumno.plan_id = OLD.plan_id;
    DELETE FROM Materia_Plan WHERE Materia_Plan.plan_id = OLD.plan_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Solicitud`
--

DROP TABLE IF EXISTS `Solicitud`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Solicitud` (
  `solicitud_id` int NOT NULL AUTO_INCREMENT,
  `tutor_id` int DEFAULT NULL,
  `solicitud_fecha` datetime NOT NULL,
  `solicitud_urgencia` varchar(1) NOT NULL,
  `materia_id` int NOT NULL,
  `solicitud_tema` varchar(200) NOT NULL,
  `solicitud_descripcion` text NOT NULL,
  `solicitud_fecha_programacion` datetime DEFAULT NULL,
  `solicitud_lugar` varchar(200) DEFAULT NULL,
  `solicitud_modalidad` enum('P','L') NOT NULL,
  `solicitud_vigente` tinyint NOT NULL,
  `asesoria_evidencia` mediumblob,
  `asesoria_calificacion` float DEFAULT NULL,
  PRIMARY KEY (`solicitud_id`,`solicitud_urgencia`,`solicitud_vigente`),
  CONSTRAINT `CK_asesoria_calificacion` CHECK ((`asesoria_calificacion` between 0 and 5)),
  CONSTRAINT `CK_restriccion_fechas_solicitud` CHECK ((`solicitud_fecha` <= `solicitud_fecha_programacion`)),
  CONSTRAINT `CK_solicitud_urgencia` CHECK ((`solicitud_urgencia` in (_utf8mb4'U',_utf8mb4'E'))),
  CONSTRAINT `CK_solicitud_vigente` CHECK ((`solicitud_vigente` between 0 and 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50500 PARTITION BY LIST  COLUMNS(solicitud_urgencia)
SUBPARTITION BY HASH (`solicitud_vigente`)
(PARTITION p0 VALUES IN ('U')
 (SUBPARTITION s0 ENGINE = InnoDB,
  SUBPARTITION s1 ENGINE = InnoDB),
 PARTITION p2 VALUES IN ('E')
 (SUBPARTITION s2 ENGINE = InnoDB,
  SUBPARTITION s3 ENGINE = InnoDB)) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Solicitud`
--

LOCK TABLES `Solicitud` WRITE;
/*!40000 ALTER TABLE `Solicitud` DISABLE KEYS */;
/*!40000 ALTER TABLE `Solicitud` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_insertar_hijo_solicitud` BEFORE INSERT ON `Solicitud` FOR EACH ROW BEGIN
    IF(NEW.tutor_id IS NOT NULL) THEN
        IF(SELECT COUNT(*) FROM Tutor WHERE Tutor.tutor_id = NEW.tutor_id) = 0 THEN
            SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Tutor.';
        END IF;
        IF(SELECT COUNT(*) FROM Materia WHERE Materia.materia_id = NEW.materia_id) = 0 THEN
            SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Materia.';
        END IF; 
    END IF;
    IF((SELECT COUNT(*) FROM Solicitud WHERE Solicitud.solicitud_id = NEW.solicitud_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (solicitud_id) ya existe en la tabla Solicitud.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_actualizar_hijo_solicitud` BEFORE UPDATE ON `Solicitud` FOR EACH ROW BEGIN
    IF(NEW.tutor_id IS NOT NULL) THEN
        IF(SELECT COUNT(*) FROM Tutor WHERE Tutor.tutor_id = NEW.tutor_id) = 0 THEN
            SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Tutor.';
        END IF;
        IF(SELECT COUNT(*) FROM Materia WHERE Materia.materia_id = NEW.materia_id) = 0 THEN
            SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Materia.';
        END IF; 
    END IF;
    IF(OLD.solicitud_id <> NEW.solicitud_id AND (SELECT COUNT(*) FROM Solicitud WHERE Solicitud.solicitud_id = NEW.solicitud_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (solicitud_id) ya existe en la tabla Solicitud.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_actualizar_padre_solicitud` AFTER UPDATE ON `Solicitud` FOR EACH ROW BEGIN
    UPDATE Alumno_Solicitud SET Alumno_Solicitud.solicitud_id = NEW.solicitud_id WHERE Alumno_Solicitud.Solicitud_id = OLD.solicitud_id;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_eliminar_padre_solicitud` AFTER DELETE ON `Solicitud` FOR EACH ROW BEGIN
    DELETE FROM Alumno_Solicitud WHERE Alumno_Solicitud.Solicitud_id = OLD.solicitud_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Tutor`
--

DROP TABLE IF EXISTS `Tutor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tutor` (
  `tutor_id` int NOT NULL AUTO_INCREMENT,
  `alumno_id` int NOT NULL,
  `tutor_promedio` decimal(10,0) NOT NULL,
  `tutor_fecha_inscripcion` datetime NOT NULL,
  `tutor_fecha_finalizacion` datetime DEFAULT NULL,
  `tutor_programa` enum('S','V') NOT NULL,
  `tutor_programa_numero` tinyint NOT NULL,
  `tutor_calificacion` float DEFAULT NULL,
  `tutor_vigente` tinyint NOT NULL,
  PRIMARY KEY (`tutor_id`,`tutor_programa_numero`,`tutor_promedio`),
  CONSTRAINT `CK_tutor_calificacion` CHECK ((`tutor_calificacion` between 0 and 5)),
  CONSTRAINT `CK_tutor_programa_numero` CHECK ((`tutor_programa_numero` between 1 and 2)),
  CONSTRAINT `CK_tutor_promedio` CHECK ((`tutor_promedio` between 8 and 10)),
  CONSTRAINT `CK_tutor_vigente` CHECK ((`tutor_vigente` between 0 and 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50100 PARTITION BY RANGE (floor(`tutor_promedio`))
SUBPARTITION BY HASH (`tutor_programa_numero`)
(PARTITION p0 VALUES LESS THAN (9)
 (SUBPARTITION s0 ENGINE = InnoDB,
  SUBPARTITION s1 ENGINE = InnoDB),
 PARTITION p2 VALUES LESS THAN MAXVALUE
 (SUBPARTITION s2 ENGINE = InnoDB,
  SUBPARTITION s3 ENGINE = InnoDB)) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tutor`
--

LOCK TABLES `Tutor` WRITE;
/*!40000 ALTER TABLE `Tutor` DISABLE KEYS */;
/*!40000 ALTER TABLE `Tutor` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_insertar_hijo_tutor` BEFORE INSERT ON `Tutor` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Alumno WHERE Alumno.alumno_id = NEW.alumno_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Alumno.';
    END IF;
    IF((SELECT COUNT(*) FROM Tutor WHERE Tutor.tutor_id = NEW.tutor_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (tutor_id) ya existe en la tabla Tutor.';
    END IF;
    IF NEW.tutor_programa = "S" THEN
        SET NEW.tutor_programa_numero = 1;
    ELSE
        SET NEW.tutor_programa_numero = 2;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_actualizar_hijo_tutor` BEFORE UPDATE ON `Tutor` FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Alumno WHERE Alumno.alumno_id = NEW.alumno_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Alumno.';
    END IF;
    IF(OLD.tutor_id <> NEW.tutor_id AND (SELECT COUNT(*) FROM Tutor WHERE Tutor.tutor_id = NEW.tutor_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (tutor_id) ya existe en la tabla Tutor.';
    END IF;
    IF NEW.tutor_programa = "S" THEN
        SET NEW.tutor_programa_numero = 1;
    ELSE
        SET NEW.tutor_programa_numero = 2;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_actualizar_padre_tutor` AFTER UPDATE ON `Tutor` FOR EACH ROW BEGIN
    UPDATE Materia_Tutor SET Materia_Tutor.tutor_id = NEW.tutor_id WHERE Materia_Tutor.tutor_id = OLD.tutor_id;
    UPDATE Solicitud SET Solicitud.tutor_id = NEW.tutor_id WHERE Solicitud.tutor_id = OLD.tutor_id;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cascada_eliminar_padre_tutor` AFTER DELETE ON `Tutor` FOR EACH ROW BEGIN
    DELETE FROM Materia_Tutor WHERE Materia_Tutor.tutor_id = OLD.tutor_id;
    DELETE FROM Solicitud WHERE Solicitud.tutor_id = OLD.tutor_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-05-13  3:46:29
