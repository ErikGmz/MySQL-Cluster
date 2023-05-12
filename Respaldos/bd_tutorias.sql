CREATE DATABASE IF NOT EXISTS `bd_tutorias`;
USE `bd_tutorias`; 

DROP TRIGGER IF EXISTS `cascada_actualizar_padre_centro`;
DROP TRIGGER IF EXISTS `restringir_eliminar_padre_centro`;

DROP TRIGGER IF EXISTS `cascada_actualizar_padre_carrera`;
DROP TRIGGER IF EXISTS `restringir_eliminar_padre_carrera`;
DROP TRIGGER IF EXISTS `prevenir_insertar_hijo_carrera`;
DROP TRIGGER IF EXISTS `prevenir_actualizar_hijo_carrera`;

DROP TRIGGER IF EXISTS `cascada_actualizar_padre_alumno`;
DROP TRIGGER IF EXISTS `cascada_eliminar_padre_alumno`;
DROP TRIGGER IF EXISTS `prevenir_insertar_hijo_alumno`;
DROP TRIGGER IF EXISTS `prevenir_actualizar_hijo_alumno`;

DROP TRIGGER IF EXISTS `cascada_actualizar_padre_tutor`;
DROP TRIGGER IF EXISTS `cascada_eliminar_padre_tutor`;
DROP TRIGGER IF EXISTS `prevenir_insertar_hijo_tutor`;
DROP TRIGGER IF EXISTS `prevenir_actualizar_hijo_tutor`;

DROP TRIGGER IF EXISTS `cascada_actualizar_padre_departamento`;
DROP TRIGGER IF EXISTS `cascada_eliminar_padre_departamento`;
DROP TRIGGER IF EXISTS `prevenir_insertar_hijo_departamento`;
DROP TRIGGER IF EXISTS `prevenir_actualizar_hijo_departamento`;

DROP TRIGGER IF EXISTS `cascada_actualizar_padre_materia`;
DROP TRIGGER IF EXISTS `cascada_eliminar_padre_materia`;
DROP TRIGGER IF EXISTS `prevenir_insertar_hijo_materia`;
DROP TRIGGER IF EXISTS `prevenir_actualizar_hijo_materia`;

DROP TRIGGER IF EXISTS `cascada_actualizar_padre_plan_estudio`;
DROP TRIGGER IF EXISTS `cascada_eliminar_padre_plan_estudio`;
DROP TRIGGER IF EXISTS `prevenir_insertar_hijo_plan_estudio`;
DROP TRIGGER IF EXISTS `prevenir_actualizar_hijo_plan_estudio`;

DROP TRIGGER IF EXISTS `prevenir_insertar_hijo_materia_plan`;
DROP TRIGGER IF EXISTS `prevenir_actualizar_hijo_materia_plan`;

DROP TRIGGER IF EXISTS `prevenir_insertar_hijo_materia_tutor`;
DROP TRIGGER IF EXISTS `prevenir_actualizar_hijo_materia_tutor`;

DROP TRIGGER IF EXISTS `cascada_actualizar_padre_solicitud`;
DROP TRIGGER IF EXISTS `cascada_eliminar_padre_solicitud`;
DROP TRIGGER IF EXISTS `prevenir_insertar_hijo_solicitud`;
DROP TRIGGER IF EXISTS `prevenir_actualizar_hijo_solicitud`;

DROP TRIGGER IF EXISTS `prevenir_insertar_hijo_alumno_solicitud`;
DROP TRIGGER IF EXISTS `prevenir_actualizar_hijo_alumno_solicitud`;

DROP TABLE IF EXISTS `bd_tutorias`.`Alumno_Solicitud`;
DROP TABLE IF EXISTS `bd_tutorias`.`Solicitud`;
DROP TABLE IF EXISTS `bd_tutorias`.`Materia_Tutor`;
DROP TABLE IF EXISTS `bd_tutorias`.`Materia_Plan`;
DROP TABLE IF EXISTS `bd_tutorias`.`Plan_Estudio`;
DROP TABLE IF EXISTS `bd_tutorias`.`Materia`;
DROP TABLE IF EXISTS `bd_tutorias`.`Departamento`;
DROP TABLE IF EXISTS `bd_tutorias`.`Tutor`;
DROP TABLE IF EXISTS `bd_tutorias`.`Alumno`;
DROP TABLE IF EXISTS `bd_tutorias`.`Carrera`;
DROP TABLE IF EXISTS `bd_tutorias`.`Centro`;


#---------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE TABLE IF NOT EXISTS `bd_tutorias`.`Centro` (
  `centro_id` INT NOT NULL,
  `centro_nombre` VARCHAR(255) NOT NULL,
  `centro_acronimo` VARCHAR(10) NOT NULL,
  `centro_direccion` TINYTEXT NOT NULL,
  `centro_telefono` VARCHAR(10) NOT NULL,
  `centro_extension` VARCHAR(5) NOT NULL,
  `centro_vigente` TINYINT NOT NULL,
  PRIMARY KEY `PK_centro` (`centro_id`),
  CONSTRAINT `CK_centro_vigente` CHECK (`centro_vigente` BETWEEN 0 AND 1)
)
PARTITION BY RANGE(`centro_id`) (
    PARTITION `p0` VALUES LESS THAN (6),
    PARTITION `p1` VALUES LESS THAN MAXVALUE
);


#---------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE TABLE IF NOT EXISTS `bd_tutorias`.`Carrera` (
  `carrera_id` INT NOT NULL,
  `centro_id` INT NOT NULL,
  `carrera_nombre` VARCHAR(255) NOT NULL,
  `carrera_duracion` INT NOT NULL,
  `carrera_modalidad` ENUM('P', 'L', 'H') NOT NULL,
  `carrera_objetivo` TEXT NOT NULL,
  `carrera_vigente` TINYINT NOT NULL,
  PRIMARY KEY `PK_carrera` (`carrera_id`, `centro_id`, `carrera_duracion`),
  CONSTRAINT `CK_carrera_duracion` CHECK (`carrera_duracion` BETWEEN 8 AND 10),
  CONSTRAINT `CK_carrera_vigente` CHECK (`carrera_vigente` BETWEEN 0 AND 1)
)
PARTITION BY RANGE COLUMNS(`centro_id`) 
SUBPARTITION BY HASH(`carrera_duracion`) (
    PARTITION `p0` VALUES LESS THAN (4) (
        SUBPARTITION `s0`,
        SUBPARTITION `s1`,
        SUBPARTITION `s2`
    ),
    PARTITION `p2` VALUES LESS THAN (7) (
        SUBPARTITION `s3`,
        SUBPARTITION `s4`,
        SUBPARTITION `s5`
    ),
    PARTITION p3 VALUES LESS THAN MAXVALUE (
        SUBPARTITION `s6`,
        SUBPARTITION `s7`,
        SUBPARTITION `s8`
    )
);


#---------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE TABLE IF NOT EXISTS `bd_tutorias`.`Alumno` (
  `alumno_id` INT NOT NULL,
  `alumno_nombre` VARCHAR(50) NOT NULL,
  `alumno_apellidos` VARCHAR(150) NOT NULL,
  `carrera_id` INT NOT NULL,
  `alumno_semestre` INT NOT NULL,
  `alumno_grupo` ENUM('A', 'B', 'C') NOT NULL,
  `alumno_grupo_numero` TINYINT NOT NULL,
  `alumno_telefono` VARCHAR(10) NOT NULL,
  `alumno_correo` VARCHAR(100) NOT NULL,
  `alumno_contrasena` VARCHAR(100) NOT NULL,
  `alumno_imagen` MEDIUMBLOB NOT NULL,
  PRIMARY KEY `PK_alumno` (`alumno_id`, `alumno_semestre`, `alumno_grupo_numero`),  
  CONSTRAINT `CK_alumno_semestre` CHECK (`alumno_semestre` BETWEEN 1 AND 10),
  CONSTRAINT `CK_alumno_grupo_numero` CHECK (`alumno_grupo_numero` BETWEEN 1 AND 3)
)
PARTITION BY RANGE(`alumno_semestre`) 
SUBPARTITION BY HASH(`alumno_grupo_numero`) (
    PARTITION p0 VALUES LESS THAN (6) (
        SUBPARTITION s0,
        SUBPARTITION s1,
        SUBPARTITION s2
    ),
    PARTITION p2 VALUES LESS THAN (11) (
        SUBPARTITION s3,
        SUBPARTITION s4,
        SUBPARTITION s5
    )
);


#---------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE TABLE IF NOT EXISTS `bd_tutorias`.`Tutor` (
    `tutor_id` INT NOT NULL,
    `alumno_id` INT NOT NULL,
    `tutor_promedio` DECIMAL NOT NULL,
    `tutor_fecha_inscripcion` DATETIME NOT NULL,
    `tutor_fecha_finalizacion` DATETIME NULL,
    `tutor_programa` ENUM('S', 'V') NOT NULL,
    `tutor_programa_numero` TINYINT NOT NULL,
    `tutor_calificacion` FLOAT NULL,
    `tutor_vigente` TINYINT NOT NULL,
    PRIMARY KEY `PK_tutor` (`tutor_id`, `tutor_programa_numero`, `tutor_promedio`),
    CONSTRAINT `CK_tutor_promedio` CHECK (`tutor_promedio` BETWEEN 8 AND 10),
    CONSTRAINT `CK_tutor_programa_numero` CHECK (`tutor_programa_numero` BETWEEN 1 AND 2),
    CONSTRAINT `CK_tutor_calificacion` CHECK (`tutor_calificacion` BETWEEN 0 AND 5),
    CONSTRAINT `CK_tutor_vigente` CHECK (`tutor_vigente` BETWEEN 0 AND 1)
)
PARTITION BY RANGE(FLOOR(`tutor_promedio`)) 
SUBPARTITION BY HASH(`tutor_programa_numero`) (
    PARTITION `p0` VALUES LESS THAN (9) (
        SUBPARTITION `s0`,
        SUBPARTITION `s1`
    ),
    PARTITION `p2` VALUES LESS THAN MAXVALUE (
        SUBPARTITION `s2`,
        SUBPARTITION `s3`
    )
);


#---------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE TABLE IF NOT EXISTS `bd_tutorias`.`Departamento` (
  `departamento_id` INT NOT NULL,
  `departamento_nombre` VARCHAR(255) NOT NULL,
  `centro_id` INT NOT NULL,
  PRIMARY KEY `PK_departamento` (`departamento_id`, `centro_id`)
)
PARTITION BY RANGE(`centro_id`) (
    PARTITION p0 VALUES LESS THAN (6),
    PARTITION p1 VALUES LESS THAN MAXVALUE
);


#---------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE TABLE IF NOT EXISTS `bd_tutorias`.`Materia` (
  `materia_id` INT NOT NULL,
  `materia_nombre` VARCHAR(255) NOT NULL,
  `departamento_id` INT NOT NULL,
  `materia_descripcion` TEXT NOT NULL,
  `materia_vigente` TINYINT NOT NULL,
  PRIMARY KEY `PK_materia` (`materia_id`, `departamento_id`),
  CONSTRAINT `CK_materia_vigente` CHECK (`materia_vigente` BETWEEN 0 AND 5)
)
PARTITION BY RANGE(`departamento_id`) (
    PARTITION p0 VALUES LESS THAN (29),
    PARTITION p1 VALUES LESS THAN MAXVALUE
);


#---------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE TABLE IF NOT EXISTS `bd_tutorias`.`Plan_Estudio` (
  `plan_id` INT NOT NULL,
  `carrera_id` INT NOT NULL,
  `plan_fecha_inicio` DATETIME NOT NULL,
  `plan_fecha_fin` DATETIME NOT NULL,
  PRIMARY KEY `PK_plan_estudio` (`plan_id`, `carrera_id`),
  CONSTRAINT `CK_restriccion_fechas` CHECK (`plan_fecha_fin` > `plan_fecha_inicio`)
)
PARTITION BY RANGE(`carrera_id`) (
    PARTITION p0 VALUES LESS THAN (21),
    PARTITION p1 VALUES LESS THAN (43),
    PARTITION p2 VALUES LESS THAN MAXVALUE
);


#---------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE TABLE IF NOT EXISTS `bd_tutorias`.`Materia_Plan` (
  `materia_id` INT NOT NULL,
  `plan_id` INT NOT NULL,
  `semestre` INT NOT NULL,
  PRIMARY KEY `PK_materia_plan` (`materia_id`, `plan_id`, `semestre`),
  CONSTRAINT `CK_semestre` CHECK (`semestre` BETWEEN 1 AND 10)
)
PARTITION BY RANGE(`semestre`) (
    PARTITION p0 VALUES LESS THAN (3),
    PARTITION p1 VALUES LESS THAN (7),
    PARTITION p2 VALUES LESS THAN MAXVALUE
);


#---------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE TABLE IF NOT EXISTS `bd_tutorias`.`Materia_Tutor` (
  `tutor_id` INT NOT NULL,
  `materia_id` INT NOT NULL,
  `promedio_materia` DECIMAL NOT NULL,
  PRIMARY KEY `PK_materia_tutor` (`tutor_id`, `materia_id`, `promedio_materia`),
  CONSTRAINT `CK_promedio_materia` CHECK (`promedio_materia` BETWEEN 8 AND 10)
)
PARTITION BY RANGE(FLOOR(`promedio_materia`)) (
    PARTITION p0 VALUES LESS THAN (9),
    PARTITION p1 VALUES LESS THAN MAXVALUE
);


#---------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE TABLE IF NOT EXISTS `bd_tutorias`.`Solicitud` (
  `solicitud_id` INT NOT NULL,
  `tutor_id` INT NULL,
  `solicitud_fecha` DATETIME NOT NULL,
  `solicitud_urgencia` VARCHAR(1) NOT NULL,
  `materia_id` INT NOT NULL,
  `solicitud_tema` VARCHAR(200) NOT NULL,
  `solicitud_descripcion` TEXT NOT NULL,
  `solicitud_fecha_programacion` DATETIME NULL,
  `solicitud_lugar` VARCHAR(200) NULL,
  `solicitud_modalidad` ENUM('P', 'L') NOT NULL,
  `solicitud_vigente` TINYINT NOT NULL,
  `asesoria_evidencia` MEDIUMBLOB NULL,
  `asesoria_calificacion` FLOAT NULL,
  PRIMARY KEY `PK_solicitud` (`solicitud_id`, `solicitud_urgencia`, `solicitud_vigente`),
  CONSTRAINT `CK_solicitud_urgencia` CHECK (`solicitud_urgencia` IN('U', 'E')),
  CONSTRAINT `CK_restriccion_fechas_solicitud` CHECK (`solicitud_fecha` <= `solicitud_fecha_programacion`),
  CONSTRAINT `CK_solicitud_vigente` CHECK (`solicitud_vigente` BETWEEN 0 AND 1),
  CONSTRAINT `CK_asesoria_calificacion` CHECK (`asesoria_calificacion` BETWEEN 0 AND 5)
)
PARTITION BY LIST COLUMNS(`solicitud_urgencia`) 
SUBPARTITION BY HASH(`solicitud_vigente`) (
    PARTITION p0 VALUES IN ('U') (
        SUBPARTITION s0,
        SUBPARTITION s1
    ),
    PARTITION p2 VALUES IN ('E') (
        SUBPARTITION s2,
        SUBPARTITION s3
    )
);


#---------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE TABLE IF NOT EXISTS `bd_tutorias`.`Alumno_Solicitud` (
  `alumno_id` INT NOT NULL,
  `solicitud_id` INT NOT NULL,
  `alumno_encargado` TINYINT NOT NULL,
  `alumno_asistencia` TINYINT NOT NULL,
  PRIMARY KEY `PK_alumno_solicitud` (`alumno_id`, `solicitud_id`, `alumno_encargado`),
  CONSTRAINT `CK_alumno_encargado` CHECK (`alumno_encargado` BETWEEN 0 AND 1),
  CONSTRAINT `CK_alumno_asistencia` CHECK (`alumno_asistencia` BETWEEN 0 AND 1)
)
PARTITION BY LIST(`alumno_encargado`) (
    PARTITION p0 VALUES IN (0),
    PARTITION p1 VALUES IN (1)
);


#---------------------------------------------------------------------------------------------------------------------------------------------------------------


DELIMITER $$

CREATE TRIGGER `cascada_actualizar_padre_centro` AFTER UPDATE ON `Centro` 
FOR EACH ROW BEGIN
    UPDATE Carrera SET Carrera.centro_id = NEW.centro_id WHERE Carrera.centro_id = OLD.centro_id;
    UPDATE Departamento SET Departamento.centro_id = NEW.centro_id WHERE Departamento.centro_id = OLD.centro_id;
END$$

CREATE TRIGGER `restringir_eliminar_padre_centro` AFTER DELETE ON `Centro` 
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Carrera WHERE Carrera.centro_id = OLD.centro_id) <> 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede eliminar el registro. La llave foránea existe en la tabla Carrera.';
    END IF;

    IF(SELECT COUNT(*) FROM Departamento WHERE Departamento.centro_id = OLD.centro_id) <> 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede eliminar el registro. La llave foránea existe en la tabla Departamento.';
    END IF;
END$$


#----------------------------------------------------------------


CREATE TRIGGER `cascada_actualizar_padre_carrera` AFTER UPDATE ON `Carrera` 
FOR EACH ROW BEGIN
    UPDATE Alumno SET Alumno.carrera_id = NEW.carrera_id WHERE Alumno.carrera_id = OLD.carrera_id;
    UPDATE Plan_Estudio SET Plan_Estudio.carrera_id = NEW.carrera_id WHERE Plan_Estudio.carrera_id = OLD.carrera_id;
END$$

CREATE TRIGGER `restringir_eliminar_padre_carrera` AFTER DELETE ON `Carrera` 
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Alumno WHERE Alumno.carrera_id = OLD.carrera_id) <> 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede eliminar el registro. La llave foránea existe en la tabla Alumno.';
    END IF;

    IF(SELECT COUNT(*) FROM Plan_Estudio WHERE Plan_Estudio.carrera_id = OLD.carrera_id) <> 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede eliminar el registro. La llave foránea existe en la tabla Plan_Estudio.';
    END IF;
END$$

CREATE TRIGGER `prevenir_insertar_hijo_carrera` BEFORE INSERT ON `Carrera`
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Centro WHERE Centro.centro_id = NEW.centro_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Centro.';
    END IF;

    IF((SELECT COUNT(*) FROM Carrera WHERE Carrera.carrera_id = NEW.carrera_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (carrera_id) ya existe en la tabla Carrera.';
    END IF;
END$$

CREATE TRIGGER `prevenir_actualizar_hijo_carrera` BEFORE UPDATE ON `Carrera` 
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Centro WHERE Centro.centro_id = NEW.centro_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Centro.';
    END IF;

    IF(OLD.carrera_id <> NEW.carrera_id AND (SELECT COUNT(*) FROM Carrera WHERE Carrera.carrera_id = NEW.carrera_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (carrera_id) ya existe en la tabla Carrera.';
    END IF;
END$$


#----------------------------------------------------------------


CREATE TRIGGER `cascada_actualizar_padre_alumno` AFTER UPDATE ON `Alumno` 
FOR EACH ROW BEGIN
    UPDATE Tutor SET Tutor.alumno_id = NEW.alumno_id WHERE Tutor.alumno_id = OLD.alumno_id;
    UPDATE Alumno_Solicitud SET Alumno_Solicitud.alumno_id = NEW.alumno_id WHERE Alumno_Solicitud.alumno_id = OLD.alumno_id;
END$$

CREATE TRIGGER `cascada_eliminar_padre_alumno` AFTER DELETE ON `Alumno` 
FOR EACH ROW BEGIN
    DELETE FROM Tutor WHERE Tutor.alumno_id = OLD.alumno_id;
    DELETE FROM Alumno_Solicitud WHERE Alumno_Solicitud.alumno_id = OLD.alumno_id;
END$$

CREATE TRIGGER `prevenir_insertar_hijo_alumno` BEFORE INSERT ON `Alumno`
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Carrera WHERE Carrera.carrera_id = NEW.carrera_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Carrera.';
    END IF;

    IF((SELECT COUNT(*) FROM Alumno WHERE Alumno.alumno_id = NEW.alumno_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (alumno_id) ya existe en la tabla Alumno.';
    END IF;

    SET NEW.alumno_grupo_numero = ORD(NEW.alumno_grupo) - 64;
END$$

CREATE TRIGGER `prevenir_actualizar_hijo_alumno` BEFORE UPDATE ON `Alumno`
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Carrera WHERE Carrera.carrera_id = NEW.carrera_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Carrera.';
    END IF;

    IF(OLD.alumno_id <> NEW.alumno_id AND (SELECT COUNT(*) FROM Alumno WHERE Alumno.alumno_id = NEW.alumno_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (alumno_id) ya existe en la tabla Alumno.';
    END IF;

    SET NEW.alumno_grupo_numero = ORD(NEW.alumno_grupo) - 64;
END$$


#----------------------------------------------------------------


CREATE TRIGGER `cascada_actualizar_padre_tutor` AFTER UPDATE ON `Tutor` 
FOR EACH ROW BEGIN
    UPDATE Materia_Tutor SET Materia_Tutor.tutor_id = NEW.tutor_id WHERE Materia_Tutor.tutor_id = OLD.tutor_id;
    UPDATE Solicitud SET Solicitud.tutor_id = NEW.tutor_id WHERE Solicitud.tutor_id = OLD.tutor_id;
END$$

CREATE TRIGGER `cascada_eliminar_padre_tutor` AFTER DELETE ON `Tutor` 
FOR EACH ROW BEGIN
    DELETE FROM Materia_Tutor WHERE Materia_Tutor.tutor_id = OLD.tutor_id;
    DELETE FROM Solicitud WHERE Solicitud.tutor_id = OLD.tutor_id;
END$$

CREATE TRIGGER `prevenir_insertar_hijo_tutor` BEFORE INSERT ON `Tutor`
FOR EACH ROW BEGIN
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
END$$

CREATE TRIGGER `prevenir_actualizar_hijo_tutor` BEFORE UPDATE ON `Tutor`
FOR EACH ROW BEGIN
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
END$$


#----------------------------------------------------------------


CREATE TRIGGER `cascada_actualizar_padre_departamento` AFTER UPDATE ON `Departamento` 
FOR EACH ROW BEGIN
    UPDATE Materia SET Materia.departamento_id = NEW.departamento_id WHERE Materia.departamento_id = OLD.departamento_id;
END$$

CREATE TRIGGER `restringir_eliminar_padre_departamento` AFTER DELETE ON `Departamento` 
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Materia WHERE Materia.departamento_id = OLD.departamento_id) <> 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede eliminar el registro. La llave foránea existe en la tabla Materia.';
    END IF;
END$$

CREATE TRIGGER `prevenir_insertar_hijo_departamento` BEFORE INSERT ON `Departamento`
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Centro WHERE Centro.centro_id = NEW.centro_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Centro.';
    END IF;

    IF((SELECT COUNT(*) FROM Departamento WHERE Departamento.departamento_id = NEW.departamento_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (departamento_id) ya existe en la tabla Departamento.';
    END IF;
END$$

CREATE TRIGGER `prevenir_actualizar_hijo_departamento` BEFORE UPDATE ON `Departamento` 
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Centro WHERE Centro.centro_id = NEW.centro_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Centro.';
    END IF;

    IF(OLD.departamento_id <> NEW.departamento_id AND (SELECT COUNT(*) FROM Departamento WHERE Departamento.departamento_id = NEW.departamento_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (departamento_id) ya existe en la tabla Departamento.';
    END IF;
END$$


#----------------------------------------------------------------


CREATE TRIGGER `cascada_actualizar_padre_materia` AFTER UPDATE ON `Materia` 
FOR EACH ROW BEGIN
    UPDATE Solicitud SET Solicitud.materia_id = NEW.materia_id WHERE Solicitud.materia_id = OLD.materia_id;
    UPDATE Materia_Tutor SET Materia_Tutor.materia_id = NEW.materia_id WHERE Materia_Tutor.materia_id = OLD.materia_id;
    UPDATE Materia_Plan SET Materia_Plan.materia_id = NEW.materia_id WHERE Materia_Plan.materia_id = OLD.materia_id;
END$$

CREATE TRIGGER `cascada_eliminar_padre_materia` AFTER DELETE ON `Materia` 
FOR EACH ROW BEGIN
    DELETE FROM Solicitud WHERE Solicitud.materia_id = OLD.materia_id;
    DELETE FROM Materia_Tutor WHERE Materia_Tutor.materia_id = OLD.materia_id;  
    DELETE FROM Materia_Plan WHERE Materia_Plan.materia_id = OLD.materia_id;  
END$$

CREATE TRIGGER `prevenir_insertar_hijo_materia` BEFORE INSERT ON `Materia`
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Departamento WHERE Departamento.departamento_id = NEW.departamento_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Departamento.';
    END IF;

    IF((SELECT COUNT(*) FROM Materia WHERE Materia.materia_id = NEW.materia_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (materia_id) ya existe en la tabla Materia.';
    END IF;
END$$

CREATE TRIGGER `prevenir_actualizar_hijo_materia` BEFORE UPDATE ON `Materia` 
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Departamento WHERE Departamento.departamento_id = NEW.departamento_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Departamento.';
    END IF;

    IF(OLD.materia_id <> NEW.materia_id AND (SELECT COUNT(*) FROM Materia WHERE Materia.materia_id = NEW.materia_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (materia_id) ya existe en la tabla Materia.';
    END IF;
END$$


#----------------------------------------------------------------


CREATE TRIGGER `cascada_actualizar_padre_plan_estudio` AFTER UPDATE ON `Plan_Estudio` 
FOR EACH ROW BEGIN
    UPDATE Materia_Plan SET Materia_Plan.plan_id = NEW.plan_id WHERE Materia_Plan.plan_id = OLD.plan_id;
END$$

CREATE TRIGGER `cascada_eliminar_padre_plan_estudio` AFTER DELETE ON `Plan_Estudio` 
FOR EACH ROW BEGIN
    DELETE FROM Materia_Plan WHERE Materia_Plan.plan_id = OLD.plan_id;
END$$

CREATE TRIGGER `prevenir_insertar_hijo_plan_estudio` BEFORE INSERT ON `Plan_Estudio`
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Carrera WHERE Carrera.carrera_id = NEW.carrera_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Carrera.';
    END IF;

    IF((SELECT COUNT(*) FROM Plan_Estudio WHERE Plan_Estudio.plan_id = NEW.plan_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (plan_id) ya existe en la tabla Plan_Estudio.';
    END IF;
END$$

CREATE TRIGGER `prevenir_actualizar_hijo_plan_estudio` BEFORE UPDATE ON `Plan_Estudio`
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Carrera WHERE Carrera.carrera_id = NEW.carrera_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Carrera.';
    END IF;

    IF(OLD.plan_id <> NEW.plan_id AND (SELECT COUNT(*) FROM Plan_Estudio WHERE Plan_Estudio.plan_id = NEW.plan_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (plan_id) ya existe en la tabla Plan_Estudio.';
    END IF;
END$$


#----------------------------------------------------------------


CREATE TRIGGER `prevenir_insertar_hijo_materia_plan` BEFORE INSERT ON `Materia_Plan`
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Materia WHERE Materia.materia_id = NEW.materia_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Materia.';
    END IF;   

    IF(SELECT COUNT(*) FROM Plan_Estudio WHERE Plan_Estudio.plan_id = NEW.plan_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Plan_Estudio.';
    END IF;   

    IF((SELECT COUNT(*) FROM Materia_Plan WHERE Materia_Plan.plan_id = NEW.plan_id AND Materia_Plan.materia_id = NEW.materia_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (materia_id, plan_id) ya existe en la tabla Materia_Plan.';
    END IF;
END$$

CREATE TRIGGER `prevenir_actualizar_hijo_materia_plan` BEFORE UPDATE ON `Materia_Plan`
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Materia WHERE Materia.materia_id = NEW.materia_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Materia.';
    END IF;

    IF(SELECT COUNT(*) FROM Plan_Estudio WHERE Plan_Estudio.plan_id = NEW.plan_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Plan_Estudio.';
    END IF; 

    IF((OLD.materia_id <> NEW.materia_id OR OLD.plan_id <> NEW.plan_id) AND (SELECT COUNT(*) FROM Materia_Plan WHERE Materia_Plan.plan_id = NEW.plan_id AND Materia_Plan.materia_id = NEW.materia_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (materia_id, plan_id) ya existe en la tabla Materia_Plan.';
    END IF;
END$$


#----------------------------------------------------------------


CREATE TRIGGER `prevenir_insertar_hijo_materia_tutor` BEFORE INSERT ON `Materia_Tutor`
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Tutor WHERE Tutor.tutor_id = NEW.tutor_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Tutor.';
    END IF;   

    IF(SELECT COUNT(*) FROM Materia WHERE Materia.materia_id = NEW.materia_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Materia.';
    END IF; 

    IF((SELECT COUNT(*) FROM Materia_Tutor WHERE Materia_Tutor.materia_id = NEW.materia_id AND Materia_Tutor.tutor_id = NEW.tutor_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (tutor_id, materia_id) ya existe en la tabla Materia_Tutor.';
    END IF;
END$$

CREATE TRIGGER `prevenir_actualizar_hijo_materia_tutor` BEFORE UPDATE ON `Materia_Tutor`
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Tutor WHERE Tutor.tutor_id = NEW.tutor_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Tutor.';
    END IF;

    IF(SELECT COUNT(*) FROM Materia WHERE Materia.materia_id = NEW.materia_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Materia.';
    END IF; 

    IF((OLD.tutor_id <> NEW.tutor_id OR OLD.materia_id <> NEW.materia_id) AND (SELECT COUNT(*) FROM Materia_Tutor WHERE Materia_Tutor.materia_id = NEW.materia_id AND Materia_Tutor.tutor_id = NEW.tutor_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (tutor_id, materia_id) ya existe en la tabla Materia_Tutor.';
    END IF;
END$$


#----------------------------------------------------------------


CREATE TRIGGER `cascada_actualizar_padre_solicitud` AFTER UPDATE ON `Solicitud` 
FOR EACH ROW BEGIN
    UPDATE Alumno_Solicitud SET Alumno_Solicitud.solicitud_id = NEW.solicitud_id WHERE Alumno_Solicitud.Solicitud_id = OLD.solicitud_id;
END$$

CREATE TRIGGER `cascada_eliminar_padre_solicitud` AFTER DELETE ON `Solicitud` 
FOR EACH ROW BEGIN
    DELETE FROM Alumno_Solicitud WHERE Alumno_Solicitud.Solicitud_id = OLD.solicitud_id;
END$$

CREATE TRIGGER `prevenir_insertar_hijo_solicitud` BEFORE INSERT ON `Solicitud`
FOR EACH ROW BEGIN
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
END$$

CREATE TRIGGER `prevenir_actualizar_hijo_solicitud` BEFORE UPDATE ON `Solicitud`
FOR EACH ROW BEGIN
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
END$$


#----------------------------------------------------------------


CREATE TRIGGER `prevenir_insertar_hijo_alumno_solicitud` BEFORE INSERT ON `Alumno_Solicitud`
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Alumno WHERE Alumno.alumno_id = NEW.alumno_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Alumno.';
    END IF;

    IF(SELECT COUNT(*) FROM Solicitud WHERE Solicitud.solicitud_id = NEW.solicitud_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Solicitud.';
    END IF; 

    IF((SELECT COUNT(*) FROM Alumno_Solicitud WHERE Alumno_Solicitud.solicitud_id = NEW.solicitud_id AND Alumno_Solicitud.alumno_id = NEW.alumno_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (alumno_id, solicitud_id) ya existe en la tabla Alumno_Solicitud.';
    END IF;
END$$

CREATE TRIGGER `prevenir_actualizar_hijo_alumno_solicitud` BEFORE UPDATE ON `Alumno_Solicitud`
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Alumno WHERE Alumno.alumno_id = NEW.alumno_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Alumno.';
    END IF;

    IF(SELECT COUNT(*) FROM Solicitud WHERE Solicitud.solicitud_id = NEW.solicitud_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Solicitud.';
    END IF; 

    IF((OLD.alumno_id <> NEW.alumno_id OR OLD.solicitud_id <> NEW.solicitud_id) AND (SELECT COUNT(*) FROM Alumno_Solicitud WHERE Alumno_Solicitud.solicitud_id = NEW.solicitud_id AND Alumno_Solicitud.alumno_id = NEW.alumno_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (alumno_id, solicitud_id) ya existe en la tabla Alumno_Solicitud.';
    END IF;
END$$

DELIMITER ;


#---------------------------------------------------------------------------------------------------------------------------------------------------------------


INSERT INTO `bd_tutorias`.`Centro` VALUES 
(1, 'Centro de Ciencias Agropecuarias', 'CCA', 'Carr. Jesus Maria - Posta Zootécnica, 20900 Jesús María, Ags.', '4499107400', '50012', 1),
(2, 'Centro de Ciencias Básicas', 'CCB', 'Avenida Universidad # 940, Universidad Autónoma de Aguascalientes, 20130 Aguascalientes, Ags.', '4499108400', '8400', 1),
(3, 'Centro de Ciencias de la Ingeniería', 'CCI', 'Avenida Mahatma Gahndi 6601 El Gigante, 20340 Aguascalientes, Ags.', '4499107400', '9510', 1),
(4, 'Centro de Ciencias de la Salud', 'CCS', '101, Ciudad Universitaria, Universidad Autónoma de Aguascalientes, 20100 Aguascalientes, Ags.', '4499108430', '8430', 1),
(5, 'Centro de Ciencias del Diseño y de la Construcción', 'CCDC', 'Avenida Universidad # 940, Universidad Autónoma de Aguascalientes, 20130 Aguascalientes, Ags.', '4499107400', '10013', 1),
(6, 'Centro de Ciencias Económicas y Administrativas', 'CCEA', 'Av. Aguascalientes Nte, Universidad Autónoma de Aguascalientes, 20130 Aguascalientes, Ags.', '4499107400', '55012', 1),
(7, 'Centro de Ciencias Empresariales', 'CCE', 'Avenida Mahatma Gahndi 6601 El Gigante, 20340 Aguascalientes, Ags.', '4499107400', '9530', 1),
(8, 'Centro de Ciencias Sociales y Humanidades', 'CCSH', 'Avenida Universidad # 940, Universidad Autónoma de Aguascalientes, 20130 Aguascalientes, Ags.', '4499107400', '8480', 1),
(9, 'Centro de las Artes y la Cultura', 'CAC', 'Avenida Universidad # 940, Universidad Autónoma de Aguascalientes, 20130 Aguascalientes, Ags.', '4499107400', '58012', 1);


#----------------------------------------------------------------


INSERT INTO `bd_tutorias`.`Carrera` VALUES 
(10, 9, 'Licenciatura en Letras Hispánicas', 9, 'P', 
'Formar Licenciados en Letras Hispánicas capaces de analizar, reflexionar y
profundizar en los distintos ámbitos de estudio de la lengua y la literatura desde sus orígenes, desarrollo y hasta nuestros días, y su relación con otras disciplinas para su implementación en la enseñanza, la filología, la asesoría lingüística, la difusión y la
divulgación de la lengua y la literatura, la crítica y los procesos de creación a través de
metodologías de investigación con pensamiento crítico y empatía ante la diversidad
sociocultural contemporánea, ética profesional y humanismo', 1),

(12, 9, 'Licenciatura en Artes Cinematográficas y Audiovisuales', 9, 'P', 'Formar Licenciados en Artes Cinematográficas y Audiovisuales con
conocimientos y habilidades en realización, producción, gestión, distribución
y análisis del fenómeno cinematográfico, para crear obras y productos
audiovisuales con un sentido crítico, ético y responsable socialmente', 1),

(13, 8, 'Licenciado en Sociología', 8, 'P', 'Formar al Licenciado en Sociología como investigador y profesionista capaz
de aplicar los conceptos y perspectivas sociológicas en el análisis de diversas
problemáticas sociales, en diferentes contextos sociales y en colaboración con
otras disciplinas; de identificar y diagnosticar los fenómenos sociales y prever sus
impactos en la sociedad; de diseñar proyectos de investigación, en la elaboración
de programas de política social, así como en el análisis de las instituciones y las
organizaciones, que podrá aplicar en la práctica académica, en instituciones
públicas, privadas o en la asesoría profesional independiente, con un alto sentido
de compromiso y responsabilidad social', 1),

(14, 8, 'Licenciatura en Docencia de Francés y Español como Lenguas Extranjeras', 10, 'P', 
'Formar profesionistas capaces de diseñar, implementar y evaluar experiencias
formativas para los procesos de enseñanza y aprendizaje de francés y español como
lenguas extranjeras, así como de difundir las culturas inherentes a dichos idiomas
en diferentes contextos, modalidades y niveles educativos con fines lingüísticos y
comunicativos a través de una perspectiva humanista y de compromiso ante las
necesidades actuales de la sociedad', 1),

(15, 8, 'Licenciatura en Trabajo Social', 9, 'P', 
'Formar profesionistas en Trabajo Social capaces de analizar, diagnosticar y sistematizar
fenómenos sociales para diseñar, aplicar y evaluar modelos de intervención en
los diferentes niveles de actuación: individual, familiar, grupal y comunitario de
manera innovadora; con la finalidad de promover cambios sociales en los ámbitos
de bienestar social, promoción social y emergente, en el sector público, privado y
en las organizaciones de la sociedad civil, bajo un enfoque multi y transdisciplinar
con humanismo, perspectiva de género, responsabilidad social y ambiental, ética
profesional y empatía ante la diversidad sociocultural contemporánea', 1),

(17, 8, 'Licenciatura en Derecho', 10, 'P', 
'Formar Licenciados en Derecho altamente cualificados en el conocimiento del
orden jurídico nacional e internacional, su interpretación y argumentación, con la
capacidad de prever y resolver los problemas jurídicos en el ámbito de lo público,
privado y lo social, con un enfoque de respeto de la juridicidad, el pluralismo y
los derechos humanos, con responsabilidad social, perspectiva humanista y de
género', 1),

(18, 8, 'Licenciatura en Comunicación e Información', 8, 'P', 
'Formar Licenciados en Comunicación e Información, conscientes de las
problemáticas sociales, políticas y culturales contemporáneas, capaces de generar
planes, programas y productos comunicativos para desempeñarse en los ámbitos
de la comunicación pública, el periodismo y la realización de narrativas en soportes
mediáticos que promuevan una comunicación democrática y sostenible, con una
perspectiva humanista, de justicia y responsabilidad social', 
1),

(20, 8, 'Licenciatura en Asesoría Psicopedagógica', 8, 'P', 
'Formar Licenciados en Asesoría Psicopedagógica con los conocimientos,
habilidades, actitudes y valores necesarios para el manejo de los elementos teóricos
y metodológicos en los ámbitos de Orientación e intervención psicopedagógica;
Docencia, currículo y evaluación; así como, Gestión y política educativa; que atiendan
necesidades de formación a partir del diseño, implementación y evaluación de
programas, en los contextos de Educación Formal y Socioeducativo, con una
perspectiva interdisciplinaria, humanista y comprometida con el desarrollo de la
sociedad', 1),

(21, 5, 'Arquitectura', 10, 'P', 
'Formar Licenciados en Arquitectura altamente competentes en los ámbitos
del diseño arquitectónico-urbano y de la edificación de espacios habitables
para planear, diseñar y construir espacios que permitan el desarrollo de
ciudades sustentables y que contribuyan al bienestar de la necesidades de la
sociedad a nivel local, regional, nacional e internacional; con la capacidad para
interpretar los factores sociales, culturales, medio ambientales y tecnológicos
constructivos con el objeto de mejorar la calidad de vida del ser humano, con
una perspectiva ética y humanista, sensibles a los problemas del entorno', 1),

(22, 5, 'Ingeniería Civil', 10, 'P', 
'Formar profesionales en la Ingeniería Civil capaces de planear y evaluar proyectos
de ingeniería para diseñar, construir y mantener obras civiles en los ámbitos
de las estructuras, cimentaciones, vías terrestres; así como obras hidráulicas y
ambientales, con la finalidad de atender los requerimientos de infraestructura
que satisfagan las necesidades sociales, con criterios de sostenibilidad, factibilidad
y seguridad; con una perspectiva ética y humanista, en un marco de pluralismo,
autonomía, responsabilidad social, calidad e innovación', 1),

(23, 5, 'Licenciatura en Urbanismo', 9, 'P', 
'Formar Licenciados en Urbanismo con conocimientos, habilidades, actitudes y
valores para elaborar, gestionar, implementar y evaluar proyectos en los ámbitos de:
Planeación urbana y ordenamiento del territorio; Diseño urbano; e, Investigación
urbana, en diferentes escalas territoriales, con el fin de contribuir al logro de
ciudades, asentamientos humanos y territorios sostenibles, seguros, incluyentes,
asequibles, aportando un ambiente construido e inteligentes que mejoren la
calidad de vida de sus habitantes de forma ética, responsable y comprometida
con la sociedad y el medio ambiente', 1),

(25, 5, 'Licenciatura en Diseño de Moda en Indumentaria y Textiles', 9, 'P',
'Formar Licenciados en Diseño de Moda en Indumentaria y Textiles creativos,
con iniciativa y espíritu humanista, capaces de desarrollar productos y
servicios de diseño de moda incluyente, rentable, sostenible y con identidad
sociocultural, en los ámbitos de diseño e innovación, producción, desarrollo
comercial y comunicación, promoción y difusión de la moda, con impacto a
nivel local, regional, nacional e internacional', 1),

(27, 5, 'Licenciatura en Diseño Gráfico', 9, 'P', 
'Formar Licenciados en Diseño Gráfico capaces de analizar, generar, aplicar y
evaluar estrategias de comunicación visual en los ámbitos de diseño gráfico de
servicios y productos, reproducción de la imagen y de gestión estratégica para
intervenir problemas complejos en entornos impresos y digitales, de forma
creativa, innovadora, ética, responsable, sostenible y con liderazgo', 1),

(28, 5, 'Licenciatura en Diseño de Interiores', 9, 'P', 
'Formar Licenciados en Diseño de Interiores capaces de ofrecer soluciones de
diseño y construcción para habilitar, adecuar, re-utilizar y conservar espacios
interiores habitables bajo una relación íntima entre el espacio, el objeto y el
habitante mediante la aplicación de métodos y estrategias holísticas con la
finalidad de mejorar la calidad de vida del ser humano a través de su habitar,
desde una perspectiva emprendedora, ética, humanista y con responsabilidad
social', 1),

(29, 5, 'Licenciatura en Diseño Industrial', 8, 'P',
'Formar diseñadores industriales, capaces de diseñar y desarrollar de manera
integral productos y servicios caracterizados por su innovación, usabilidad,
factibilidad, rentabilidad, y responsabilidad hacia el medio ambiente y la
sociedad y contribuir en la competitividad de las empresas, bajo un enfoque
responsable, ético y con espíritu emprendedor', 1),

(31, 4, 'Médico Cirujano', 10, 'P', 
'Formar Médicos Cirujanos altamente competentes en el cuidado de la salud
individual y colectiva, que respondan a las necesidades de atención médica
derivadas de los perfiles epidemiológico y demográfico actuales; en la prevención,
curación y rehabilitación de los pacientes, en los ámbitos clínico, salud pública e
investigación, a través de un trabajo interdisciplinario y multidisciplinario, con
actitud ética y humanista', 1),

(32, 4, 'Médico Estomatólogo', 10, 'P',
'Formar Médicos Estomatólogos capaces de realizar acciones preventivas para la
promoción de la salud bucal, además de desarrollar técnicas y métodos dirigidos
a diagnosticar, atender y resolver las patologías bucodentales de la población
en general mediante el uso de equipo, instrumental y materiales odontológicos
de vanguardia; además de involucrarse en la investigación de diversas áreas
estomatológicas que le permitan actualizarse y generar conocimientos innovadores
para su formación, con calidad humana y ética profesional', 1),

(33, 1, 'Médico Veterinario Zootecnista', 10, 'P',
'Formar Médicos Veterinarios Zootecnistas humanistas, reflexivos y socialmente
responsables, capaces de contribuir de manera decisiva a que los animales
domésticos se preserven sanos, con niveles óptimos de bienestar y desempeño
productivo, así como capaces de facilitar el desarrollo rural sustentable y evitar
la transmisión de enfermedades al humano mediante el aseguramiento de la
calidad e inocuidad de alimentos y las acciones de la salud pública veterinaria,
bajo el concepto de una salud', 1),

(34, 4, 'Licenciatura en Terapia Física', 8, 'P',
'Formar Licenciados en Terapia Física competentes, capaces de participar en
estrategias de prevención para personas con riesgo a desarrollar una discapacidad,
ofrecer servicios de valoración a individuos y poblaciones para diagnosticar, mantener
y restaurar el máximo movimiento y la capacidad funcional durante todo el ciclo de
vida, para la reintegración social de las personas con alguna discapacidad, colaborar
con equipos inter y multidisciplinarios en los ámbitos de prevención, rehabilitación y
gestión terapéutica, con apoyo de los avances tecnológicos en fisioterapia, desde una
perspectiva ética, científica, humanista, emprendedora y con responsabilidad social', 1),

(35, 2, 'Licenciatura en Biología', 9, 'P', 
'Formar Biólogos capaces de generar y aplicar el conocimiento científico para
solucionar problemas y atender necesidades en las áreas de Biodiversidad,
Ecología e Investigación, desde una perspectiva de uso sustentable de los recursos
naturales, ética, humanista, emprendedora y con responsabilidad social', 1),

(36, 4, 'Licenciatura en Optometría', 8, 'P', 
'Formar Licenciados en Optometría capacitados para prevenir y diagnosticar:
ametropías, alteraciones funcionales binoculares, deficiencias visuales-perceptuales
y alteraciones de la salud ocular; así como realizar el tratamiento y/o rehabilitación
por medio de sistemas ópticos, entrenamiento visual-perceptual y terapéutica
tópica en enfermedades del segmento anterior; aplicando tratamientos oftálmicos
innovadores e involucrándose en actividades de investigación que permitan
estar a la vanguardia en el ejercicio de la profesión con actitud ética, humanista y
comprometidos con la sociedad', 1),

(38, 4, 'Licenciatura en Enfermería', 8, 'P', 
'Formar Licenciados en Enfermería capaces de otorgar cuidados integrales a
la persona en todas las etapas de vida y promover el autocuidado, a través del
proceso de enfermería y aplicar las bases científicas de la disciplina con el apoyo
de la tecnología en los ámbitos asistencial, educación para la salud, investigación
y administración; con un sentido humanista, de servicio y responsabilidad social', 1),

(39, 4, 'Licenciatura en Nutrición', 8, 'P', 
'Formar Licenciados en Nutrición competentes y líderes en su campo profesional,
que se desempeñen con calidad y rigor científico en el diagnóstico del estado
nutricio en individuos sanos, en riesgo y enfermos, la modificación de conductas
y hábitos relacionados con la alimentación, la administración de servicios de
alimentos y la implementación de programas de alimentación y nutrición,
tanto de forma individualizada como colectiva; con capacidad para trabajar en
grupos inter y multidisciplinarios, así como actitud de servicio y conscientes de la
responsabilidad ética y social en su desempeño profesional', 1),

(40, 4, 'Licenciatura en Cultura Física y Deporte', 8, 'P', 
'Formar licenciados en cultura física y deporte que prescriban ejercicio físico
adaptado a las características de cada grupo poblacional, a través del diseño,
organización, aplicación, supervisión y evaluación de planes y sesiones de actividad
física en los ámbitos del deporte, la salud, la educación física y la gestión deportiva,
con una perspectiva humanista, ética, colaborativa e inclusiva a fin de fomentar
estilos de vida saludable en la población', 1),

(41, 1, 'Ingeniería en Agronomía', 8, 'P', 
'Formar Ingenieros Agrónomos con una visión integral, capaces de aplicar,
innovar y transmitir conocimientos pertinentes y socialmente relevantes
que les permitan enfrentar, adaptar y solucionar problemas en diversas
situaciones y cambios del contexto agrícola, que respondan a las necesidades
de producción, gestión de recursos e innovación agrícola, bajo los principios
humanísticos y el cuidado del medio ambiente', 1),

(44, 3, 'Ingeniería en Energías Renovables', 9, 'P',
'Formar Ingenieros en Energías Renovables capaces de implementar soluciones
a problemas energéticos a través del diseño, planeación y administración
de sistemas de generación y transformación, que aprovechan las fuentes
renovables de energía, así como de su uso racional en el sector industrial
para contribuir al desarrollo sustentable dentro de un marco creativo, ético y
humanista', 1),

(45, 3, 'Ingeniería en Diseño Mecánico', 9, 'P', 
'Formar Ingenieros en Diseño Mecánico líderes en las áreas de Sistemas
Mecánicos y Procesos de Manufactura, con capacidad de administrar, diseñar,
implementar, adecuar y evaluar herramientas, máquinas, productos y
componentes mecánicos, para solucionar problemas de Ingeniería, con base
en criterios estructurales y de seguridad que permitan la transformación y
empleo de la energía de manera racional, sustentable y eficiente, respetando la
normatividad correspondiente, desde una perspectiva humanista, con calidad
y responsabilidad social', 1),

(46, 3, 'Ingeniería Automotriz', 9, 'P', 
'Formar Ingenieros Automotrices capaces de innovar, desarrollar, implementar
y evaluar sistemas relacionados con el ámbito automotriz para mejorar
la eficiencia de la producción de vehículos y autopartes a nivel nacional e
internacional, con liderazgo, calidad, responsabilidad social y respeto al medio
ambiente', 1),

(47, 3, 'Ingeniería Biomédica', 9, 'P', 
'Formar profesionistas en Ingeniería Biomédica con conocimientos
multidisciplinarios de ingeniería aplicados al cuidado de la salud, que le
permiten diseñar, construir, implementar, innovar, mantener y gestionar
equipos y sistemas biomédicos de diagnóstico y tratamiento, con sentido
humanista y de responsabilidad social', 1),

(48, 3, 'Ingeniería en Robótica', 9, 'P',
'Formar Ingenieros en Robótica líderes en su campo profesional con capacidad para
diseñar, desarrollar, innovar, implementar y optimizar procesos, productos y servicios
en el área de la robótica que contribuyan en la solución de necesidades específicas en
los ámbitos de diseño y desarrollo de robots, sistemas de automatización, manufactura
e integración de tecnologías, evaluación y desarrollo de proyectos en ingeniería con
calidad y respeto al medio ambiente en un marco ético y humanista', 1),

(49, 3, 'Ingeniería en Manufactura y Automatización Industrial', 9, 'P',
'Formar ingenieros líderes en su campo profesional con capacidad para diseñar,
desarrollar, innovar, implementar y optimizar procesos, productos y servicios en
las áreas de manufactura y automatización, que contribuyan en la solución de
necesidades específicas en los ámbitos de integración de sistemas de manufactura
avanzada; automatización y control industrial; diseño de sistemas de producción en
la manufactura; así como la evaluación y desarrollo de proyectos en ingeniería con
calidad y respeto al medio ambiente en un marco ético y humanista', 1),

(51, 6, 'Contador Público', 8, 'P', 
'Formar Contadores Públicos altamente capacitados en la presentación, análisis,
interpretación y auditoría, de estados financieros; en la aplicación de las
disposiciones fiscales; determinación correcta del costo en productos y servicios;
y en la administración y gestión de los recursos financieros; siendo competitivos
en el sector público y privado, para una adecuada toma de decisiones, con
sentido ético, de liderazgo y de responsabilidad social, beneficiando el desarrollo
económico y social', 1),

(52, 6, 'Licenciatura en Administración de Empresas', 8, 'P', 
'Formar Licenciados en Administración de Empresas con capacidad para desarrollar
soluciones estratégicas integrales a problemas administrativos, organizacionales,
de recursos humanos, financieros, de mercadotecnia y de operaciones en los
ámbitos de la gestión organizacional y de dirección de proyectos empresariales
con actitud ética, responsable, humanista y comprometida con el desarrollo
sustentable', 1),

(53, 6, 'Licenciatura en Comercio Internacional', 9, 'P', 
'Formar Licenciados en Comercio Internacional capaces de analizar el entorno
económico y los tratados internacionales para detectar oportunidades de
comercio e inversión en los diversos mercados, estableciendo protocolos de
negocios en los diferentes ámbitos multiculturales; realizar las actividades
de importación y exportación de acuerdo con los procedimientos de la
gestión aduanera, así como el diseño e implementación de planes logísticos
y la elaboración de contratos de mercadería internacional, con espíritu
emprendedor, responsabilidad social y ética profesional', 1),

(54, 6, 'Licenciatura en Administración de la Producción y Servicios', 8, 'P', 
'Formar Licenciados en Administración de la Producción y Servicios, capaces de
coordinar las áreas funcionales de la empresa con el área de operación, a través del
análisis, evaluación, diseño y aplicación de estrategias organizacionales, mediante
la administración de procesos, de materiales, de calidad y de capital, para optimizar
resultados de los sistemas productivos de bienes y servicios que generen ventajas
competitivas dentro de un mercado global, con una perspectiva de responsabilidad
social, ética y humanista inherentes al desempeño de su profesión, de manera
innovadora, asertiva y con alto sentido de liderazgo', 1),

(55, 6, 'Licenciatura en Administración Financiera', 8, 'P', 
'Formar Licenciados en Administración Financiera competentes y especializados
que les permita administrar, gestionar, evaluar y establecer estrategias para
incrementar la riqueza, administrando el riesgo, en los ámbitos del Sistema
Financiero, de Negocios, de las Finanzas públicas e Internacionales, con
capacidad emprendedora y una sólida formación ética con perspectiva
humanista y de responsabilidad social comprometidos con el desarrollo local,
regional y nacional', 1),

(56, 6, 'Licenciatura en Relaciones Industriales', 8, 'P', 
'Formar Licenciados en Relaciones Industriales, capaces de desarrollar diferentes
técnicas para la organización del trabajo y la gestión avanzada del capital humano
que eleven la calidad de vida del trabajador, promuevan la productividad y faciliten
el crecimiento sostenible de las organizaciones, en las áreas de Administración de
Recursos Humanos, Desarrollo de Personal, Gestión Laboral, Producción y Calidad,
en un marco de equidad con una actitud comprometida hacia el desarrollo
sostenible, orientación humanista y sensibilidad hacia su entorno', 1),

(57, 6, 'Licenciatura en Economía', 8, 'P', 
'Formar Licenciados en Economía capaces de evaluar y proponer planes,
programas y proyectos en los ámbitos de economía de la empresa, economía
financiera, economía pública, economía internacional, crecimiento y desarrollo
económico con la finalidad de resolver problemas económicos y sociales de
crecimiento y desarrollo sustentable, así como, determinar el impacto de las
variables económico financieras a nivel internacional, nacional y local, de forma
ética, crítica, plural, con sentido humanista y de responsabilidad social', 1),

(59, 6, 'Licenciatura en Mercadotecnia', 8, 'P', 
'Formar licenciados en Mercadotecnia, líderes en la dirección estratégica de marketing
y ventas, Inteligencia de mercados, generación de valor para el cliente, promoción y
distribución, y creatividad y generación de negocios, así como el emprendimiento
de un negocio con enfoque humanista, sostenible, global y ético que fomenten la
calidad de vida de los clientes para lograr una sociedad más equitativa y justa', 1),

(60, 2, 'Ingeniería en Bioquímica', 9, 'P', 
'Formar Ingenieros Bioquímicos creativos, con espíritu crítico y humanista para
diseñar, desarrollar, implementar y optimizar procesos, productos y servicios que
involucren el aprovechamiento racional e integral de los recursos bióticos, y que
sean capaces de resolver problemas en los ámbitos de ingeniería de procesos,
sustentabilidad y ambiente, bioingeniería y alimentario', 1),

(61, 2, 'Ingeniería en Sistemas Computacionales', 9, 'P', 
'Formar Ingenieros en Sistemas Computacionales que diseñen, desarrollen,
implementen, evalúen y automaticen sistemas en Software, Redes de Computadoras,
Aplicación de Hardware, Ingeniería de Datos y Aseguramiento de Sistemas, logrando
adaptar las nuevas tecnologías a las necesidades que demanden las organizaciones
públicas o privadas desde un enfoque proactivo, ético, humanista y con responsabilidad
social', 1),

(62, 2, 'Licenciatura en Matemáticas Aplicadas', 9, 'P', 
'Formar Licenciados en Matemáticas Aplicadas capaces de diseñar modelos
cuantitativos eficaces y confiables que incidan en la optimización de procesos
y la toma de decisiones, y que describan fidedignamente fenómenos en las
ciencias y la tecnología para la resolución de problemas actuales en los ámbitos
productivo y de servicios; promover la enseñanza y el aprendizaje significativo
de las matemáticas y física atendiendo las necesidades del ámbito de docencia,
siempre en el marco de la ética, humanismo y responsabilidad social', 1),

(64, 2, 'Químico Farmacéutico Biólogo', 9, 'P', 
'Formar Químico Farmacéuticos Biólogos que se desempeñen honesta y
responsablemente en las áreas clínica, farmacéutica, industrial y de investigación,
para contribuir al bienestar y desarrollo de la población local, nacional y global, en
concordancia con los principios éticos, humanistas y científicos', 1),

(66, 2, 'Ingeniería en Computación Inteligente', 10, 'P',
'Formar Ingenieros en Computación Inteligente, con conocimientos sólidos
de los fundamentos matemáticos y teóricos de las Ciencias de la
Computación, de Inteligencia Artificial e Industria de Software, a través de
la concepción y creación de ambientes, facilidades y aplicaciones innovadoras
de la computación, la construcción de software de base y de aplicaciones,
elaboración de teorías y prácticas de modelos de realidades complejas y
emprendimiento a fin de dar soluciones computacionales eficientes a
problemas reales y complejos; asimilar y adaptar nuevas tecnologías así como
nuevas metodologías para el desarrollo de software, participar en equipos
multidisciplinarios y adaptarse a los rápidos cambios que se producen en las
Ciencias de la Computación y en la Industria de Software, con un alto sentido de
responsabilidad social, innovador y humanista', 1),

(67, 2, 'Ingeniería en Electrónica', 9, 'P', 
'Formar Ingenieros en Electrónica capaces de diseñar, implementar, adaptar y mantener
sistemas electrónicos en los ámbitos de control e instrumentación, diseño electrónico, sistemas
digitales y embebidos, internet de las cosas y telecomunicaciones de área local; contando con
la capacidad de llevar a cabo la transferencia e innovación de tecnología electrónica, evaluar
la pertinencia de proyectos y atender las necesidades de su entorno con ética, una visión
humanista y compromiso social', 1),

(69, 2, 'Ingeniero Industrial Estadístico', 9, 'P', 
'Formar Ingenieros Industriales Estadísticos capaces de identificar, formular y
resolver problemas en las áreas de Ingeniería Industrial, Estadística y Cómputo
Estadístico, Administración y Automatización Industrial; así como innovar y
emprender negocios, administrar, procesar, controlar y transmitir información
de cadenas de valor, provenientes de la adecuada aplicación de conocimientos
y habilidades en ingeniería, estadística, matemáticas, computación y
administración, con una perspectiva ética, humanista y con responsabilidad
social', 1),

(70, 8, 'Licenciatura en Historia', 8, 'P', 
'Formar Licenciados en Historia capaces de valorar y generar conocimiento
histórico que contribuya a la comprensión del presente de manera crítica a través
de la investigación; de transmitir el saber histórico de forma integral y creativa
por medio de la docencia y la divulgación; así como participar en la gestión
y conservación del patrimonio histórico, con apertura y respeto a la diversidad
cultural', 1),

(71, 8, 'Licenciatura en Psicología', 9, 'P', 
'Formar Licenciados en Psicología con conocimientos teóricos y metodológicos
sobre el comportamiento humano, con habilidades para integrar los avances de
la investigación científica a su práctica psicológica, tanto en la evaluación del
comportamiento de los individuos como en su intervención en diferentes ámbitos
y etapas de su vida, en las diferentes áreas de aplicación de la psicología clínica y
de la salud, educativa, del trabajo y las organizaciones, social y comunitaria. Con
actitudes de colaboración y trabajo interdisciplinario con otros; valores éticos,
humanistas y con perspectiva de género', 1),

(72, 8, 'Licenciatura en Filosofía', 8, 'P', 
'Formar Licenciados y Licenciadas en Filosofía con un conocimiento integral
y reflexivo del saber filosófico disciplinar que les permita analizar, interpretar,
transmitir, promover y aplicar la filosofía en problemáticas ambientales, bioéticas,
de género, de la ciencia con la tecnología y la sociedad, antropológicas, estéticas
y epistemológicas, a través de la docencia, la investigación y la divulgación para
que sean capaces de generar nuevos conocimientos e interpretaciones críticohumanistas con un criterio metodológico-filosófico, apoyándose en otras
disciplinas científicas y sociales, que les permita formarse una conciencia crítica de
la sociedad y la cultura para contribuir al diálogo argumentativo y ético, resultado
de sus investigaciones', 1),

(73, 8, 'Licenciatura en Docencia del Idioma Inglés', 8, 'P', 
'Formar Licenciados en la Docencia del Idioma Inglés íntegros y comprometidos
con la educación, quienes dominan el idioma inglés como lengua de
comunicación global, así como los conocimientos y habilidades lingüísticas,
metodológicas, tecnológicas y culturales en la docencia del inglés en los
diferentes niveles educativos; con cualidades humanistas y principios éticos
que les permitan responder a las problemáticas sociales en sus ámbitos de
desempeño a nivel regional, nacional e internacional', 1),

(74, 8, 'Licenciatura en Ciencias Políticas y Administración Pública', 9, 'P',
'Formar Licenciadas/os en Ciencias Políticas y Administración Pública analíticos y críticos, capaces de examinar
y exponer científicamente los problemas y fenómenos políticos, sociales y gubernamentales para responder
a las necesidades de nuestra colectividad y tener una gestión pública de calidad y una sociedad democrática,
justa, plural y participativa; mediante el diseño, implementación y evaluación de políticas públicas y modelos de
acción colectiva, participación ciudadana, integración y colaboración institucional favoreciendo la transparencia
y rendición de cuentas, vinculada a los principios de gobierno abierto y la gobernanza con una perspectiva de
género, ética, humanista y con apego a la responsabilidad y sustentabilidad social', 1),

(77, 6, 'Licenciatura en Gestión Turística', 8, 'P', 
'Formar Licenciados en Gestión Turística con conocimiento de las dimensiones
del turismo y de sus principales estructuras socio-políticas y administrativas,
hábiles en la toma de decisiones sustentadas en la investigación, capaces de
realizar de manera eficiente y sostenible actividades directivas y de gestión en
los ámbitos de planificación pública de destinos, de desarrollo de productos
y actividades turísticas, alojamiento, alimentos y bebidas, intermediación,
transportación y logística; ofreciendo servicios de consultoría y apoyo al sector
público y empresarial, todo ello con sentido ético y de responsabilidad social
para el desempeño de sus funciones', 1),

(78, 9, 'Licenciatura en Estudios del Arte y Gestión Cultural', 9, 'P', 
'Formar Licenciados en Estudios del Arte y Gestión Cultural competentes en el análisis,
diseño, implementación y evaluación de programas de cultura y educación artística
pertinentes e innovadores a través de la gestión de proyectos, promoción, difusión
y el fomento de las artes y la cultura en todos los ámbitos de la vida social; así como
con diferentes herramientas en estudios del arte, investigación y metodologías, de
patrimonio y de gestión que les permitan desempeñarse desde una perspectiva
crítica, contemporánea, con humanismo, ética, responsabilidad social, perspectiva de
género y desde una mirada incluyente basada en el respeto', 1),

(79, 9, 'Licenciatura en Música', 10, 'P', 
'Formar Licenciados en Música creativos y autocríticos, con un alto sentido de
autonomía y responsabilidad social, capaces de realizar interpretaciones de alto valor
estético e implementar proyectos educativos que promuevan el desarrollo de la
sensibilidad y la expresión musical', 1),

(81, 2, 'Licenciatura en Biotecnología', 9, 'P', 
'Formar profesionistas capaces de desarrollar y aplicar herramientas
biotecnológicas que resuelvan problemas y atiendan necesidades de la
sociedad en los ámbitos agrícola, forestal, pecuario, médico y farmacéutico,
ambiental, así como uso sostenible de la Biodiversidad del país. Esto con una
perspectiva ética, humanista, emprendedora y con responsabilidad social', 1),

(84, 7, 'Licenciatura en Administración y Gestión Fiscal de PyMEs', 8, 'P', 
'Formar Licenciados en Administración y Gestión Fiscal de PyMEs capaces de
aplicar correctamente la legislación fiscal vigente; implementar la dirección
administrativa eficiente en las Pequeñas y Medianas Empresas y proporcionar
asesoría fiscal relacionada en materia laboral, seguridad social, legal y tributación
del comercio exterior con la finalidad de incrementar el desarrollo, productividad
y competitividad en las organizaciones públicas y privadas desde una perspectiva
ética, humanista, emprendedora y con responsabilidad social', 1),

(85, 7, 'Licenciatura en Logística Empresarial', 8, 'P', 
'Formar Licenciados en Logística Empresarial altamente capacitados en la gestión
de la cadena de suministro y sus procesos logísticos asociados al movimiento
de mercancías, aprovisionamiento, almacenamiento, distribución, transporte,
trámites aduanales y comercialización de bienes y servicios; incidiendo en la
dirección empresarial y en la implementación adecuada de la normatividad
vigente, para ofrecer soluciones innovadoras y sustentables en las organizaciones
públicas y privadas, mejorando su desempeño e índice de calidad, con una
perspectiva humanista, ética y socialmente responsable', 1),

(86, 7, 'Licenciatura en Agronegocios', 9, 'P', 
'Formar Licenciados en Agronegocios capaces de gestionar, desarrollar, evaluar
e implementar proyectos productivos que impulsen la competitividad del sector
agroalimentario con un enfoque empresarial a través de diferentes estrategias
que permitan mejorar la comercialización de los productos y servicios, así como
la integración de cadenas productivas desde una perspectiva de desarrollo
sostenible e innovadora, que dé respuesta a las necesidades de la industria, de
una manera ética, humanista y responsable socialmente', 1),

(87, 7, 'Licenciatura en Comercio Electrónico', 9, 'P', 
'Formar Licenciados en Comercio Electrónico que identifiquen y satisfagan
las necesidades económicas de las empresas a través de la eficiente gestión
del e-Commerce, mediante diversos intermediarios electrónicos, plataformas
transaccionales y herramientas digitales para comercializar de forma segura
productos físicos y virtuales, a través de la implementación de estrategias
electrónicas para la arquitectura de marca y posicionamiento online; así como la
administración de recursos humanos, tecnológicos, económicos y de información
que promuevan el desarrollo de sitios virtuales caracterizados por su rentabilidad,
sustentabilidad y rendimiento optimizado de acuerdo al entorno de los mercados
y necesidades sociales. Desde una perspectiva ética, humanista, autónoma, de
calidad y responsabilidad social', 1),

(88, 2, 'Licenciatura en Informática y Tecnologías Computacionales', 9, 'P', 
'Formar Licenciados en Informática y Tecnologías Computacionales, capaces
de analizar, diseñar e implementar soluciones basadas en Tecnologías de
Información que contribuyan a la creación de valor organizacional mediante el
desarrollo tecnológico en las áreas de programación e ingeniería de software,
gestión de proyectos informáticos, tratamiento de la información y gestión de
servicios digitales, de forma innovadora y humanista, con perspectiva ética y
de responsabilidad social y ambiental', 1),

(92, 1, 'Ingeniería en Alimentos', 8, 'P', 
'Formar Ingenieros en Alimentos con una visión integral, capaces de
otorgar valor agregado a materias primas agropecuarias, promoviendo el
desarrollo industrial a través de aplicar, adaptar, innovar o generar procesos
de manufactura, gestión de calidad y seguridad alimentaria en empresas
agroindustriales, respondiendo a las necesidades de desarrollo social y de
globalización; conscientes de la sustentabilidad y de aprovechamiento eficiente
de los recursos bajo un enfoque de ética humanista y de responsabilidad social', 1),

(93, 8, 'Licenciatura en Comunicación Corporativa Estratégica', 8, 'P', 
'Formar Licenciados en Comunicación Corporativa Estratégica que diseñen,
implementen y evalúen estrategias y programas de comunicación integral para
entidades de tipo empresarial, público y social, en los ámbitos de relaciones públicas,
alianzas estratégicas y networking; comunicación interna para la productividad y
el desarrollo de las organizaciones y las personas; imagen y reputación para la
ciudadanía corporativa y la sostenibilidad social; así como gestión de medios,
administración de redes sociales y producción de contenidos multiplataforma; a
través de una sólida formación teórica, metodológica y práctica, con perspectiva
humanista, multicultural, incluyente y ética', 1),

(94, 9, 'Licenciatura en Actuación', 8, 'P', 
'Formar Licenciados en Actuación, con un amplio conocimiento de los procesos
creativos y el quehacer escénico del actor, así como de los principios de dirección
escénica, gestión y producción de proyectos artísticos y enseñanza del teatro
en nivel básico y medio superior; con la finalidad de formar actores críticos
que puedan desempeñarse sólidamente en la interpretación, desarrollen
propuestas que contribuyan a la renovación de la escena con compromiso
social, ético y humanista', 1);


#----------------------------------------------------------------


INSERT INTO `bd_tutorias`.`Departamento` VALUES
(1, "Departamento de Ciencias Agronómicas", 1),
(2, "Departamento de Ciencias de los Alimentos", 1),
(3, "Departamento de Ciencias Veterinarias", 1),
(4, "Departamento de Biología", 2),
(5, "Departamento de Ciencias de la Computación", 2),
(6, "Departamento de Estadística", 2),
(7, "Departamento de Fisiología y Farmacología", 2),
(8, "Departamento de Ingeniería Bioquímica", 2),
(9, "Departamento de Matemáticas y Física", 2),
(10, "Departamento de Microbiología", 2),
(11, "Departamento de Morfología", 2),
(12, "Departamento de Química", 2),
(13, "Departamento de Sistemas de Información", 2),
(14, "Departamento de Sistemas Electrónicos", 2),
(15, "Departamento de Ingeniería Automotriz", 3),
(16, "Departamento de Ingeniería Biomédica", 3),
(17, "Departamento de Ingeniería Robótica", 3),
(18, "Departamento de Cultura Física y Salud Pública", 4),
(19, "Departamento de Enfermería", 4),
(20, "Departamento de Estomatología", 4),
(21, "Departamento de Medicina", 4),
(22, "Departamento de Nutrición", 4),
(23, "Departamento de Optometría", 4),
(24, "Departamento de Terapia Física", 4),
(25, "Departamento de Arquitectura", 5),
(26, "Departamento de Diseño de Interiores", 5),
(27, "Departamento de Diseño de Moda", 5),
(28, "Departamento de Diseño Gráfico", 5),
(29, "Departamento de Diseño Industrial", 5),
(30, "Departamento de Ingeniería Civil", 5),
(31, "Departamento de Urbanismo", 5),
(32, "Departamento de Administración", 6),
(33, "Departamento de Contaduría", 6),
(34, "Departamento de Economía", 6),
(35, "Departamento de Finanzas", 6),
(36, "Departamento de Mercadotecnia", 6),
(37, "Departamento de Recursos Humanos", 6),
(38, "Departamento de Turismo", 6),
(39, "Departamento de Administración y Gestión Fiscal de PyMEs", 7),
(40, "Departamento de Agronegocios", 7),
(41, "Departamento de Comercio Electrónico", 7),
(42, "Departamento de Logística Empresarial", 7),
(43, "Departamento de Ciencias Políticas y Administración Pública", 8),
(44, "Departamento de Comunicación", 8),
(45, "Departamento de Derecho", 8),
(46, "Departamento de Educación", 8),
(47, "Departamento de Filosofía", 8),
(48, "Departamento de Historia", 8),
(49, "Departamento de Idiomas", 8),
(50, "Departamento de Psicología", 8),
(51, "Departamento de Sociología", 8),
(52, "Departamento de Trabajo Social", 8),
(53, "Departamento de Arte y Gestión Cultural", 9),
(54, "Departamento de Artes Escénicas y Audiovisuales", 9),
(55, "Departamento de Letras", 9),
(56, "Departamento de Música", 9);

