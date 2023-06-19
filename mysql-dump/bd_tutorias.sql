CREATE DATABASE IF NOT EXISTS `bd_tutorias`;
USE `bd_tutorias`; 


#---------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE TABLE IF NOT EXISTS `bd_tutorias`.`Centro` (
  `centro_id` INT NOT NULL AUTO_INCREMENT,
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
  `carrera_id` INT NOT NULL AUTO_INCREMENT,
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
  `alumno_id` INT NOT NULL AUTO_INCREMENT,
  `alumno_nombre` VARCHAR(50) NOT NULL,
  `alumno_apellidos` VARCHAR(150) NOT NULL,
  `plan_id` INT NOT NULL,
  `alumno_semestre` INT NOT NULL,
  `alumno_grupo` ENUM('A', 'B', 'C') NOT NULL,
  `alumno_grupo_numero` TINYINT NOT NULL,
  `alumno_telefono` VARCHAR(10) NOT NULL,
  `alumno_correo` VARCHAR(100) NOT NULL,
  `alumno_contrasena` VARCHAR(100) NOT NULL,
  `alumno_imagen` MEDIUMBLOB NOT NULL,
  PRIMARY KEY `PK_alumno` (`alumno_id`, `alumno_semestre`, `alumno_grupo_numero`),  
  CONSTRAINT `CK_alumno_semestre` CHECK (`alumno_semestre` BETWEEN 1 AND 10),
  CONSTRAINT `CK_alumno_grupo_numero` CHECK (`alumno_grupo_numero` BETWEEN 0 AND 2)
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
    `tutor_id` INT NOT NULL AUTO_INCREMENT,
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
    CONSTRAINT `CK_tutor_programa_numero` CHECK (`tutor_programa_numero` BETWEEN 0 AND 1),
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
  `departamento_id` INT NOT NULL AUTO_INCREMENT,
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
  `materia_id` INT NOT NULL AUTO_INCREMENT,
  `materia_nombre` VARCHAR(255) NOT NULL,
  `departamento_id` INT NOT NULL,
  `materia_descripcion` TEXT NOT NULL,
  `materia_vigente` TINYINT NOT NULL,
  PRIMARY KEY `PK_materia` (`materia_id`, `departamento_id`),
  CONSTRAINT `CK_materia_vigente` CHECK (`materia_vigente` BETWEEN 0 AND 1)
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
  `solicitud_id` INT NOT NULL AUTO_INCREMENT,
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
  `solicitud_rechazados` VARCHAR(255) NULL,
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


INSERT IGNORE INTO `bd_tutorias`.`Centro` VALUES 
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


DROP TRIGGER IF EXISTS `prevenir_insertar_hijo_carrera`;

INSERT IGNORE INTO `bd_tutorias`.`Carrera` VALUES 
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


DROP TRIGGER IF EXISTS `prevenir_insertar_hijo_plan_estudio`;

INSERT INTO Plan_Estudio VALUES 
(1,41,'2016-01-01','2023-12-31'),
(101,92,'2017-01-01','2023-12-31'),
(201,33,'2015-01-01','2023-12-31'),
(301,60,'2019-01-01','2023-12-31'),
(401,66,'2017-01-01','2023-12-31'),
(501,67,'2019-01-01','2023-12-31'),
(601,61,'2016-01-01','2023-12-31'),
(701,69,'2019-01-01','2023-12-31'),
(801,35,'2019-01-01','2023-12-31'),
(901,81,'2017-01-01','2023-12-31'),
(1001,88,'2021-01-01','2023-12-31'),
(1101,62,'2015-01-01','2023-12-31'),
(1201,64,'2017-01-01','2023-12-31'),
(5801,94,'2020-01-01','2023-12-31'),
(5901,12,'2020-01-01','2023-12-31'),
(6001,78,'2016-01-01','2023-12-31'),
(6101,10,'2016-01-01','2023-12-31'),
(6201,79,'2017-01-01','2023-12-31');



#----------------------------------------------------------------


DROP TRIGGER IF EXISTS `prevenir_insertar_hijo_materia_plan`;

INSERT INTO Materia_Plan VALUES
(1,1,1),
(2,1,1),
(3,1,1),
(4,1,1),
(5,1,1),
(6,1,1),
(7,1,2),
(8,1,2),
(9,1,2),
(10,1,2),
(11,1,2),
(12,1,2),
(13,1,3),
(14,1,3),
(15,1,3),
(16,1,3),
(17,1,3),
(18,1,3),
(19,1,4),
(20,1,4),
(21,1,4),
(22,1,4),
(23,1,4),
(25,1,5),
(26,1,5),
(27,1,5),
(28,1,5),
(29,1,5),
(31,1,6),
(32,1,6),
(33,1,6),
(34,1,6),
(37,1,7),
(38,1,7),
(39,1,7),
(40,1,7),
(43,1,8),

(1001,101,1),
(1002,101,1),
(1003,101,1),
(1004,101,1),
(1005,101,1),
(1006,101,2),
(1007,101,2),
(1008,101,2),
(1009,101,2),
(1010,101,2),
(1011,101,3),
(1012,101,3),
(1013,101,3),
(1014,101,3),
(1015,101,3),
(1016,101,3),
(1017,101,4),
(1018,101,4),
(1019,101,4),
(1020,101,4),
(1021,101,4),
(1023,101,5),
(1024,101,5),
(1025,101,5),
(1026,101,5),
(1027,101,5),
(1030,101,6),
(1031,101,6),
(1032,101,6),
(1033,101,6),
(1034,101,6),
(1037,101,7),
(1038,101,7),
(1039,101,7),
(1040,101,7),
(1041,101,7),
(1043,101,8),

(2001,201,1),
(2002,201,1),
(2003,201,1),
(2004,201,1),
(2005,201,1),
(2006,201,2),
(2007,201,2),
(2008,201,2),
(2009,201,2),
(2010,201,2),
(2011,201,3),
(2012,201,3),
(2013,201,3),
(2014,201,3),
(2015,201,3),
(2016,201,4),
(2017,201,4),
(2018,201,4),
(2019,201,4),
(2020,201,4),
(2021,201,5),
(2022,201,5),
(2023,201,5),
(2024,201,5),
(2025,201,5),
(2027,201,6),
(2028,201,6),
(2029,201,6),
(2030,201,6),
(2031,201,6),
(2033,201,7),
(2034,201,7),
(2035,201,7),
(2036,201,7),
(2037,201,7),
(2039,201,8),
(2040,201,8),
(2041,201,8),
(2042,201,8),
(2043,201,8),
(2044,201,9),
(2045,201,9),
(2046,201,9),
(2047,201,9),
(2048,201,9),
(2049,201,10),
(2050,201,10),
(3001,301,1),
(3002,301,1),
(3003,301,1),
(3004,301,1),
(3005,301,2),
(3006,301,2),
(3007,301,2),
(3008,301,2),
(3009,301,2),
(3010,301,3),
(3011,301,3),
(3012,301,3),
(3013,301,3),
(3014,301,3),
(3015,301,4),
(3016,301,4),
(3017,301,4),
(3018,301,4),
(3019,301,4),
(3020,301,4),
(3021,301,5),
(3022,301,5),
(3023,301,5),
(3024,301,5),
(3025,301,5),
(3027,301,6),
(3028,301,6),
(3029,301,6),
(3030,301,6),
(3031,301,6),
(3032,301,7),
(3033,301,7),
(3034,301,7),
(3035,301,7),
(3036,301,7),
(3037,301,7),
(3038,301,8),
(3039,301,8),
(3040,301,8),
(3041,301,8),
(3042,301,8),
(3045,301,9),
(3046,301,9),
(3047,301,9),
(4001,401,1),
(4002,401,1),
(4003,401,1),
(4004,401,1),
(4005,401,1),
(4006,401,2),
(4007,401,2),
(4008,401,2),
(4009,401,2),
(4010,401,2),
(4011,401,2),
(4012,401,3),
(4013,401,3),
(4014,401,3),
(4015,401,3),
(4016,401,3),
(4017,401,3),
(4018,401,4),
(4019,401,4),
(4020,401,4),
(4021,401,4),
(4022,401,4),
(4023,401,4),
(4024,401,5),
(4025,401,5),
(4026,401,5),
(4027,401,5),
(4028,401,5),
(4029,401,5),
(4030,401,5),
(4031,401,6),
(4032,401,6),
(4033,401,6),
(4034,401,6),
(4035,401,6),
(4036,401,6),
(4037,401,7),
(4038,401,7),
(4039,401,7),
(4040,401,7),
(4041,401,7),
(4042,401,7),
(4043,401,7),
(4044,401,8),
(4045,401,8),
(4046,401,8),
(4047,401,8),
(4048,401,8),
(4049,401,8),
(4050,401,8),
(4051,401,9),
(4052,401,9),
(4053,401,9),
(4054,401,9),
(4055,401,9),
(4056,401,9),
(4057,401,10),
(5001,501,1),
(5002,501,1),
(5003,501,1),
(5004,501,1),
(5005,501,1),
(5006,501,2),
(5007,501,2),
(5008,501,2),
(5009,501,2),
(5010,501,2),
(5011,501,3),
(5012,501,3),
(5013,501,3),
(5014,501,3),
(5015,501,3),
(5016,501,3),
(5017,501,4),
(5018,501,4),
(5019,501,4),
(5020,501,4),
(5021,501,4),
(5022,501,4),
(5023,501,5),
(5024,501,5),
(5025,501,5),
(5026,501,5),
(5027,501,5),
(5028,501,5),
(5029,501,6),
(5030,501,6),
(5031,501,6),
(5032,501,6),
(5033,501,6),
(5034,501,6),
(5035,501,7),
(5036,501,7),
(5037,501,7),
(5038,501,7),
(5039,501,7),
(5040,501,7),
(5041,501,8),
(5042,501,8),
(5043,501,8),
(5044,501,8),
(5045,501,8),
(5046,501,8),
(5047,501,9),
(5048,501,9),
(5049,501,9),
(6001,601,1),
(6002,601,1),
(6003,601,1),
(6004,601,1),
(6005,601,1),
(6006,601,1),
(6007,601,2),
(6008,601,2),
(6009,601,2),
(6010,601,2),
(6011,601,2),
(6012,601,2),
(6013,601,3),
(6014,601,3),
(6015,601,3),
(6016,601,3),
(6017,601,3),
(6018,601,3),
(6019,601,4),
(6020,601,4),
(6021,601,4),
(6022,601,4),
(6023,601,4),
(6024,601,5),
(6025,601,5),
(6026,601,5),
(6027,601,5),
(6028,601,5),
(6029,601,5),
(6030,601,6),
(6031,601,6),
(6032,601,6),
(6033,601,6),
(6034,601,6),
(6035,601,7),
(6036,601,7),
(6037,601,7),
(6038,601,7),
(6039,601,7),
(6040,601,8),
(6041,601,8),
(6042,601,8),
(6043,601,8),
(6044,601,8),
(6046,601,9),
(6047,601,9),
(6048,601,9),
(6049,601,9),
(6050,601,9);


#----------------------------------------------------------------


DROP TRIGGER IF EXISTS `prevenir_insertar_hijo_alumno`;

INSERT INTO Alumno VALUES
(221001,'Laura Luciana','Montoya Aguilar',301,3,'A',0,'4491236754','al221001@edu.uaa.mx','al221001',''),
(221002,'Juan Carlos','Leal Hernández',301,3,'B',1,'4493696578','al221002@edu.uaa.mx','al221002',''),
(221003,'Martha','Palos Fiscal',301,5,'B',1,'4491234432','al221003@edu.uaa.mx','al221003',''),
(221004,'Gustavo','Vicencio Marea',401,3,'A',0,'4498021445','al221004@edu.uaa.mx','al221004',''),
(221005,'Adrián','Cardenas Rios',401,5,'B',1,'4495631010','al221005@edu.uaa.mx','al221005',''),
(221006,'Julia María','Cantú Figueroa',401,7,'B',1,'4493217485','al221006@edu.uaa.mx','al221006',''),
(221007,'Fernando','Najera Olguin',501,4,'A',0,'4492574896','al221007@edu.uaa.mx','al221007',''),
(221008,'Mario','Basurto',501,4,'A',0,'4498963356','al221008@edu.uaa.mx','al221008',''),
(221009,'Sofia','García Vargas',501,4,'A',0,'8675392415','al221009@edu.uaa.mx','al221009',''),
(221010,'Alejandro','Rodríguez Ríos',501,5,'B',1,'4098576213','al221010@edu.uaa.mx','al221010',''),
(221011,'Isabella','Torres González',501,5,'B',1,'5261938470','al221011@edu.uaa.mx','al221011',''),
(221012,'Diego','Martínez Delgado',601,1,'A',0,'9385716204','al221012@edu.uaa.mx','al221012',''),
(221013,'Valentina','Morales Ramírez',601,1,'B',1,'7123954680','al221013@edu.uaa.mx','al221013',''),
(221014,'Juan','Sánchez Méndez',601,2,'B',1,'3540682197','al221014@edu.uaa.mx','al221014',''),
(221015,'Camila','Flores Castro',601,2,'A',0,'6918240573','al221015@edu.uaa.mx','al221015',''),
(221016,'Samuel','Pérez Fernández',601,3,'A',0,'2408957361','al221016@edu.uaa.mx','al221016',''),
(226582,'Cynthia Maritza','Teran Carranza',601,9,'A',0,'4491808868','al226582@edu.uaa.mx','al226582',''),
(211694,'Israel Alejandro','Mora Gonzalez',601,9,'A',0,'4492848828','al211694@edu.uaa.mx','al211694',''),
(269314,'Eduardo','Davila Campos',601,8,'B',1,'4499205022','al269314@edu.uaa.mx','al269314',''),
(269686,'Erik Alejandro','Gomez Martinez',601,8,'B',1,'4491965071','al269686@edu.uaa.mx','al269686','');

#----------------------------------------------------------------


DROP TRIGGER IF EXISTS `prevenir_insertar_hijo_tutor`;

INSERT INTO Tutor VALUES
(1,221003,9,'2022-12-15 10:00:00',NULL,'S',0,NULL,1),
(2,221006,9,'2022-09-10 12:15:00',NULL,'V',1,NULL,1),
(3,221010,9,'2022-09-10 12:15:00',NULL,'V',1,NULL,1),
(4,221011,8,'2022-09-10 12:15:00',NULL,'S',0,NULL,1),
(5,226582,9,'2023-03-22 18:20:00',NULL,'S',0,NULL,1),
(6,211694,9,'2022-05-03 10:00:00',NULL,'V',1,NULL,1);


#----------------------------------------------------------------


DROP TRIGGER IF EXISTS `prevenir_insertar_hijo_materia_tutor`;

INSERT INTO Materia_Tutor VALUES
(1,3001,10),
(1,3002,9),
(1,3003,8),
(1,3004,10),
(1,3005,9),
(1,3006,9),
(1,3007,9),
(1,3008,10),
(1,3009,8),
(1,3010,9),
(1,3011,10),
(1,3012,9),
(1,3013,10),
(1,3014,8),
(1,3015,10),
(1,3016,8),
(1,3017,10),
(1,3018,10),
(1,3019,10),
(1,3020,10),
(2,4012,10),
(2,4013,10),
(2,4014,8),
(2,4015,10),
(2,4016,10),
(2,4017,9),
(2,4025,9),
(2,4026,10),
(2,4027,8),
(2,4028,10),
(2,4029,10),
(2,4030,10),
(2,4031,10),
(3,5017,10),
(3,5018,10),
(3,5019,8),
(3,5020,10),
(3,5021,10),
(3,5022,9),
(4,5018,10),
(4,5019,8),
(4,5020,10),
(4,5021,10),
(4,5022,9),
(5,6001,10),
(5,6002,9),
(5,6003,8),
(5,6004,10),
(5,6005,9),
(5,6006,9),
(5,6007,9),
(5,6008,10),
(5,6009,8),
(5,6010,9),
(5,6011,10),
(5,6012,9),
(5,6013,10),
(5,6040,8),
(5,6041,10),
(5,6042,8),
(5,6043,10),
(5,6044,10),
(6,6001,10),
(6,6002,9),
(6,6003,8),
(6,6004,10),
(6,6005,9),
(6,6006,9),
(6,6007,9),
(6,6030,10),
(6,6031,8),
(6,6033,9),
(6,6034,10),
(6,6012,9),
(6,6013,10),
(6,6040,8),
(6,6041,10),
(6,6042,8),
(6,6043,10),
(6,6044,10);


#----------------------------------------------------------------


DROP TRIGGER IF EXISTS `prevenir_insertar_hijo_solicitud`;

INSERT INTO Solicitud VALUES
(1,NULL,'2023-06-15 13:14:00','U',3010,'Límites y rangos','No entiendo como obtener los límites, rango y dominio de una función',NULL,NULL,'P',1, NULL, NULL, NULL),
(2,1,'2023-06-15 12:14:00','U',3011,'Repaso para 2do parcial.','Me gustaría ver un poco acerca del temario para descansar','2023-06-19','UAA, edificio 5-E','L',1, NULL, NULL, NULL),
(3,NULL,'2023-06-05 13:14:00','U',6001,'Balance General','Se me dificulta entender acerca de los activos y pasivos.',NULL,NULL,'P',1, NULL, NULL, NULL),
(4,6,'2023-06-01 09:14:00','E',6002,'Repaso para 1er Parcial','Me gustaría ver un poco acerca del temario para repasar para el próximo examen.','2023-06-24','Biblioteca Central','L',1, NULL, NULL, NULL),
(5,NULL,'2023-06-15 18:00:00','E',6003,'Límtes','Demostración  de porque es necesrio utilizar los límites para obtener el resultado deseado.',NULL,NULL,'P',1, NULL, NULL, NULL),
(6,5,'2023-06-15 12:14:00','U',6004,'Tabla periódica','Quisera conocer acerca de los distintos compuestos que se generam día con día.','2023-06-19','UAA, edificio 120','P',0, 'FA', 0, NULL);


#----------------------------------------------------------------


DROP TRIGGER IF EXISTS `prevenir_insertar_hijo_alumno_solicitud`;

INSERT INTO Alumno_Solicitud VALUES
(221001,1,1,0),
(221002,2,1,0),
(221012,3,1,0),
(221013,4,1,0),
(221012,5,1,0),
(221013,6,1,0);


#----------------------------------------------------------------


DROP TRIGGER IF EXISTS `prevenir_insertar_hijo_departamento`;

INSERT IGNORE INTO `bd_tutorias`.`Departamento` VALUES
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


#----------------------------------------------------------------


DROP TRIGGER IF EXISTS `prevenir_insertar_hijo_materia`;

/*----------------------------------------Centro de Ciencias Agropecuarias----------------------------------------*/
/*Ing. en Agronomía - Checar 14 si es compartida o no*/

/*Plan 2016, Carrera 41*/
/*id(1-1000), nombre, departamento, descripcion, vigente*/
/*1 - 43*/

INSERT INTO Materia VALUES 
(1,'Química',12,'Programa de Química para alumnos de primer semestre de Ing. en Agronomía, 2016.',1),
(2,'Matemáticas',9,'Programa de Matemáticas para alumnos de primer semestre de Ing. en Agronomía, 2016.',1),
(3,'Física',9,'Programa de Física para alumnos de primer semestre de Ing. en Agronomía, 2016.',1),
(4,'Botánica',4,'Programa de Botánica para alumnos de primer semestre de Ing. en Agronomía, 2016.',1),
(5,'Edafología',1,'Programa de Edafología para alumnos de primer semestre de Ing. en Agronomía, 2016.',1),
(6,'Introducción a la agronomía',1,'Programa de Introducción a la agronomía para alumnos de primer semestre de Ing. en Agronomía, 2016.',1),

(7,'Bioquímica',12,'Programa de Bioquímica para alumnos de segundo semestre de Ing. en Agronomía, 2016.',1),
(8,'Topografía',30,'Programa de Topografía para alumnos de segundo semestre de Ing. en Agronomía, 2016.',1),
(9,'Hidráulica',30,'Programa de Hidráulica para alumnos de segundo semestre de Ing. en Agronomía, 2016.',1),
(10,'Maquinaria agrícola',1,'Programa de Maquinaria agrícola para alumnos de segundo semestre de Ing. en Agronomía, 2016.',1),
(11,'Fertilidad de suelos',1,'Programa de Fertilidad de suelos para alumnos de segundo semestre de Ing. en Agronomía, 2016.',1),
(12,'Prod. de cultivos básicos y forrajeros',1,'Programa de Prod. de cultivos básicos y forrajeros para alumnos de segundo semestre de Ing. en Agronomía, 2016.',1),

(13,'Construcciones rurales',30,'Programa de Construcciones rurales para alumnos de tercer semestre de Ing. en Agronomía, 2016.',1),
(14,'Bioestadística (EST-B11)',6,'Programa de Bioestadística (EST-B11) para alumnos de tercer semestre de Ing. en Agronomía, 2016.',1),
(15,'Sistemas de riego',1,'Programa de Sistemas de riego para alumnos de tercer semestre de Ing. en Agronomía, 2016.',1),
(16,'Climatología y meteorología agrícola',1,'Programa de Climatología y meteorología agrícola para alumnos de tercer semestre de Ing. en Agronomía, 2016.',1),
(17,'Fisiología vegetal aplicada',1,'Programa de Fisiología vegetal aplicada para alumnos de tercer semestre de Ing. en Agronomía, 2016.',1),
(18,'Entomología agrícola',1,'Programa de Entomología agrícola para alumnos de tercer semestre de Ing. en Agronomía, 2016.',1),

(19,'Manejo sostenible de sistemas agrícolas',1,'Programa de Manejo sostenible de sistemas agrícolas para alumnos de cuarto semestre de Ing. en Agronomía, 2016.',1),
(20,'Fruticultura general',1,'Programa de Fruticultura general para alumnos de cuarto semestre de Ing. en Agronomía, 2016.',1),
(21,'Fitopatología',1,'Programa de Fitopatología para alumnos de cuarto semestre de Ing. en Agronomía, 2016.',1),
(22,'Nutrición vegetal',1,'Programa de Nutrición vegetal para alumnos de cuarto semestre de Ing. en Agronomía, 2016.',1),
(23,'Horticultura general',1,'Programa de Horticultura general para alumnos de cuarto semestre de Ing. en Agronomía, 2016.',1),
/*(24,'Optativa profesionalizante I',0,'Programa de Optativa profesionalizante I para alumnos de cuarto semestre de Ing. en Agronomía, 2016.',1),*/

(25,'Economía general',34,'Programa de Economía general para alumnos de quinto semestre de Ing. en Agronomía, 2016.',1),
(26,'Metodología de investigación',1,'Programa de Metodología de investigación para alumnos de quinto semestre de Ing. en Agronomía, 2016.',1),
(27,'Manejo integral de plagas',1,'Programa de Manejo integral de plagas para alumnos de quinto semestre de Ing. en Agronomía, 2016.',1),
(28,'Genética y mejoramiento vegetal',1,'Programa de Genética y mejoramiento vegetal para alumnos de quinto semestre de Ing. en Agronomía, 2016.',1),
(29,'Gest. y org. de la producc. agropecuaria',1,'Programa de Gest. y org. de la producc. agropecuaria para alumnos de quinto semestre de Ing. en Agronomía, 2016.',1),
/*(30,'Optativa profesionalizante II',12,'Programa de Optativa profesionalizante II para alumnos de quinto semestre de Ing. en Agronomía, 2016.',1),*/

(31,'Administración',32,'Programa de Administración para alumnos de sexto semestre de Ing. en Agronomía, 2016.',1),
(32,'Costos de producción',33,'Programa de Costos de producción para alumnos de sexto semestre de Ing. en Agronomía, 2016.',1),
(33,'Experimentación agrícola',1,'Programa de Experimentación agrícola para alumnos de sexto semestre de Ing. en Agronomía, 2016.',1),
(34,'Inocuidad alimentaria en prod. agrícola',1,'Programa de Inocuidad alimentaria en prod. agrícola para alumnos de sexto semestre de Ing. en Agronomía, 2016.',1),
/*(35,'Optativa profesionalizante III',12,'Programa de Optativa profesionalizante III para alumnos de sexto semestre de Ing. en Agronomía, 2016.',1),
(36,'Optativa profesionalizante IV',12,'Programa de Optativa profesionalizante IV para alumnos de sexto semestre de Ing. en Agronomía, 2016.',1),*/

(37,'Proyectos de inversión agrícolas',35,'Programa de Proyectos de inversión agrícolas para alumnos de séptimo semestre de Ing. en Agronomía, 2016.',1),
(38,'Ética profesional',47,'Programa de Ética profesional para alumnos de séptimo semestre de Ing. en Agronomía, 2016.',1),
(39,'Seminario de investigación',1,'Programa de Seminario de investigación para alumnos de séptimo semestre de Ing. en Agronomía, 2016.',1),
(40,'Fisiología poscosecha de prod. agrícolas',1,'Programa de Fisiología poscosecha de prod. agrícolas para alumnos de séptimo semestre de Ing. en Agronomía, 2016.',1),
/*(41,'Optativa profesionalizante V',1,'Programa de Optativa profesionalizante V para alumnos de séptimo semestre de Ing. en Agronomía, 2016.',1),
(42,'Optativa profesionalizante VI',1,'Programa de Optativa profesionalizante VI para alumnos de séptimo semestre de Ing. en Agronomía, 2016.',1),*/

(43,'Prácticas profesionales',1,'Programa de Prácticas profesionales para alumnos de octavo semestre de Ing. en Agronomía, 2016.',1);


/*Ing. en Alimentos - Listo checar si 2014 es compartida*/

/*Plan 2017, Carrera 92*/
/*id(1001-2000), nombre, departamento, descripcion, vigente*/
/*1 al 43*/

INSERT INTO Materia VALUES 
(1001,'Matemáticas Aplicadas',9,'Programa de Matemáticas Aplicadas para alumnos de primer semestre de Ing. en Alimentos, 2017.',1),
(1002,'Física Aplicada',9,'Programa de Física Aplicada para alumnos de primer semestre de Ing. en Alimentos, 2017.',1),
(1003,'Química Aplicada',12,'Programa de Química Aplicada para alumnos de primer semestre de Ing. en Alimentos, 2017.',1),
(1004,'Producción Vegetal',1,'Programa de Producción Vegetal para alumnos de primer semestre de Ing. en Alimentos, 2017.',1),
(1005,'Producción Animal',3,'Programa de Producción Animal para alumnos de primer semestre de Ing. en Alimentos, 2017.',1),

(1006,'Bioquímica General',12,'Programa de Bioquímica General para alumnos de segundo semestre de Ing. en Alimentos, 2017.',1),
(1007,'Termodinámica',8,'Programa de Termodinámica para alumnos de segundo semestre de Ing. en Alimentos, 2017.',1),
(1008,'Tecnología Poscosecha',1,'Programa de Tecnología Poscosecha para alumnos de segundo semestre de Ing. en Alimentos, 2017.',1),
(1009,'Factores de la Producción Animal',3,'Programa de Factores de la Producción Animal para alumnos de segundo semestre de Ing. en Alimentos, 2017.',1),
(1010,'Producción Agroindustrial',2,'Programa de Producción Agroindustrial para alumnos de segundo semestre de Ing. en Alimentos, 2017.',1),

(1011,'Microbiología',10,'Programa de Microbiología para alumnos de tercer semestre de Ing. en Alimentos, 2017.',1),
(1012,'Fisicoquímica',8,'Programa de Fisicoquímica para alumnos de tercer semestre de Ing. en Alimentos, 2017.',1),
(1013,'Agroindustrias de Primera Transformación',2,'Programa de Agroindustrias de Primera Transformación para alumnos de tercer semestre de Ing. en Alimentos, 2017.',1),
(1014,'Bioestadística I (EST-B11)',6,'Programa de Bioestadística I (EST-B11) para alumnos de tercer semestre de Ing. en Alimentos, 2017.',1),
(1015,'Int. a la Conservación de Alimentos',2,'Programa de Int. a la Conservación de Alimentos para alumnos de tercer semestre de Ing. en Alimentos, 2017.',1),
(1016,'Costos de Producción',33,'Programa de Costos de Producción para alumnos de tercer semestre de Ing. en Alimentos, 2017.',1),

(1017,'Balances de Materia y Energía',8,'Programa de Balances de Materia y Energía para alumnos de cuarto semestre de Ing. en Alimentos, 2017.',1),
(1018,'Métodos de Conservación de Alimentos',2,'Programa de Métodos de Conservación de Alimentos para alumnos de cuarto semestre de Ing. en Alimentos, 2017.',1),
(1019,'Análisis Sensorial',2,'Programa de Análisis Sensorial para alumnos de cuarto semestre de Ing. en Alimentos, 2017.',1),
(1020,'Desarrollo e Innovación de Alimentos',2,'Programa de Desarrollo e Innovación de Alimentos para alumnos de cuarto semestre de Ing. en Alimentos, 2017.',1),
(1021,'Mercadotecnia de Productos',36,'Programa de Mercadotecnia de Productos para alumnos de cuarto semestre de Ing. en Alimentos, 2017.',1),
/*(1022,'Optativa Profesionalizante I',0,'Programa de Optativa Profesionalizante I para alumnos de cuarto semestre de Ing. en Alimentos, 2017.',1),*/

(1023,'Flujo de Fluidos',8,'Programa de Flujo de Fluidos para alumnos de quinto semestre de Ing. en Alimentos, 2017.',1),
(1024,'Ingeniería de Métodos',2,'Programa de Ingeniería de Métodos para alumnos de quinto semestre de Ing. en Alimentos, 2017.',1),
(1025,'Proceso de Manufactura de Alimentos',2,'Programa de Proceso de Manufactura de Alimentos para alumnos de quinto semestre de Ing. en Alimentos, 2017.',1),
(1026,'Aditivos y Coadyuvantes en Alimentos',2,'Programa de Aditivos y Coadyuvantes en Alimentos para alumnos de quinto semestre de Ing. en Alimentos, 2017.',1),
(1027,'Calidad e Inocuidad en la Agroindustria',2,'Programa de Calidad e Inocuidad en la Agroindustria para alumnos de quinto semestre de Ing. en Alimentos, 2017.',1),
/*(1028,'Optativa Profesionalizante II',0,'Programa de Optativa Profesionalizante II para alumnos de quinto semestre de Ing. en Alimentos, 2017.',1),
//(1029,'Optativa Profesionalizante III',0,'Programa de Optativa Profesionalizante III para alumnos de quinto semestre de Ing. en Alimentos, 2017.',1),*/

(1030,'Transferencia de Calor',8,'Programa de Transferencia de Calor para alumnos de sexto semestre de Ing. en Alimentos, 2017.',1),
(1031,'Instalaciones y Servicios Agroindustriales',30,'Programa de Instalaciones y Servicios Agroindustriales para alumnos de sexto semestre de Ing. en Alimentos, 2017.',1),
(1032,'Ingeniería de Alimentos I',2,'Programa de Ingeniería de Alimentos I para alumnos de sexto semestre de Ing. en Alimentos, 2017.',1),
(1033,'Planeación y Control de Procesos Agroind',2,'Programa de Planeación y Control de Procesos Agroind para alumnos de sexto semestre de Ing. en Alimentos, 2017.',1),
(1034,'Ética Profesional',47,'Programa de Ética Profesional para alumnos de sexto semestre de Ing. en Alimentos, 2017.',1),
/*(1035,'Optativa Profesionalizante IV',0,'Programa de Optativa Profesionalizante IV para alumnos de sexto semestre de Ing. en Alimentos, 2017.',1),
//(1036,'Optativa Profesionalizante V',0,'Programa de Optativa Profesionalizante V para alumnos de sexto semestre de Ing. en Alimentos, 2017.',1),*/

(1037,'Programas de Control',2,'Programa de Programas de Control para alumnos de séptimo semestre de Ing. en Alimentos, 2017.',1),
(1038,'Diseño de Plantas Agroindustriales',2,'Programa de Diseño de Plantas Agroindustriales para alumnos de séptimo semestre de Ing. en Alimentos, 2017.',1),
(1039,'Ingeniería de Alimentos II',2,'Programa de Ingeniería de Alimentos II para alumnos de séptimo semestre de Ing. en Alimentos, 2017.',1),
(1040,'Tratamientos Térmicos',2,'Programa de Tratamientos Térmicos para alumnos de séptimo semestre de Ing. en Alimentos, 2017.',1),
(1041,'Plan de Negocios',32,'Programa de Plan de Negocios para alumnos de séptimo semestre de Ing. en Alimentos, 2017.',1),
/*(1042,'Optativa Profesionalizante VI',0,'Programa de Optativa Profesionalizante VI para alumnos de séptimo semestre de Ing. en Alimentos, 2017.',1),*/

(1043,'Proyecto Terminal',2,'Programa de Proyecto Terminal para alumnos de octavo semestre de Ing. en Alimentos, 2017.',1);


/*Médico Veterinario Zootecnista*/

/*Plan 2015, Carrera 33*/
/*id(2001-3000), nombre, departamento, descripcion, vigente*/
/*2001 - 2050 Checar 2033 si es compartida*/

INSERT INTO Materia VALUES 
(2001,'Bioquímica',12,'Programa de Biquímica para alumnos de primer semestre de Médico Veterinario Zootecnista, 2015.',1),
(2002,'Introd. a la Medicina Veterinaria y Zootecnia',3,'Programa de Introd. a la Medicina Veterinaria y Zootecnia para alumnos de primer semestre de Médico Veterinario Zootecnista, 2015.',1),
(2003,'Anatomía Veterinaria',3,'Programa de Anatomía Veterinaria para alumnos de primer semestre de Médico Veterinario Zootecnista, 2015.',1),
(2004,'Fisiología Veterinaria',3,'Programa de Fisiología Veterinaria para alumnos de primer semestre de Médico Veterinario Zootecnista, 2015.',1),
(2005,'Prácticas Médico Zootécnicas I',3,'Programa de Prácticas Médico Zootécnicas I para alumnos de primer semestre de Médico Veterinario Zootecnista, 2015.',1),

(2006,'Fisiología General',7,'Programa de Fisiología General para alumnos de segundo semestre de Médico Veterinario Zootecnista, 2015.',1),
(2007,'Manejo de Pasturas y Prod. de Forrajes',3,'Programa de Manejo de Pasturas y Prod. de Forrajes para alumnos de segundo semestre de Médico Veterinario Zootecnista, 2015.',1),
(2008,'Anatomía Veterinaria Clínica',3,'Programa de Anatomía Veterinaria Clínica para alumnos de segundo semestre de Médico Veterinario Zootecnista, 2015.',1),
(2009,'Bromatología y Nutrición Animal',3,'Programa de Bromatología y Nutrición Animal para alumnos de segundo semestre de Médico Veterinario Zootecnista, 2015.',1),
(2010,'Prácticas Médico Zootécnicas II',3,'Programa de Prácticas Médico Zootécnicas II para alumnos de segundo semestre de Médico Veterinario Zootecnista, 2015.',1),

(2011,'Biología Celular y Tisular Veterinaria',11,'Programa de Biología Celular y Tisular Veterinaria para alumnos de tercer semestre de Médico Veterinario Zootecnista, 2015.',1),
(2012,'Alimentación de los Animales Domésticos',3,'Programa de Alimentación de los Animales Domésticos para alumnos de tercer semestre de Médico Veterinario Zootecnista, 2015.',1),
(2013,'Farmacología Veterinaria',3,'Programa de Farmacología Veterinaria para alumnos de tercer semestre de Médico Veterinario Zootecnista, 2015.',1),
(2014,'Toxicología Clínica Veterinaria',3,'Programa de Toxicología Clínica Veterinaria para alumnos de tercer semestre de Médico Veterinario Zootecnista, 2015.',1),
(2015,'Prácticas Médico Zootécnicas III',3,'Programa de Prácticas Médico Zootécnicas III para alumnos de tercer semestre de Médico Veterinario Zootecnista, 2015.',1),

(2016,'Farmacología General',7,'Programa de Farmacología General para alumnos de cuarto semestre de Médico Veterinario Zootecnista, 2015.',1),
(2017,'Patología Veterinaria',3,'Programa de Patología Veterinaria para alumnos de cuarto semestre de Médico Veterinario Zootecnista, 2015.',1),
(2018,'Enfermedades Parasitarias de los Animales',3,'Programa de Enfermedades Parasitarias de los Animales para alumnos de cuarto semestre de Médico Veterinario Zootecnista, 2015.',1),
(2019,'Enfermedades Infecciosas de los Animales',3,'Programa de Enfermedades Infecciosas de los Animales para alumnos de cuarto semestre de Médico Veterinario Zootecnista, 2015.',1),
(2020,'Prácticas Médico Zootécnicas IV',3,'Programa de Prácticas Médico Zootécnicas IV para alumnos de cuarto semestre de Médico Veterinario Zootecnista, 2015.',1),

(2021,'Microbiología Veterinaria',10,'Programa de Microbiología Veterinaria para alumnos de quinto semestre de Médico Veterinario Zootecnista, 2015.',1),
(2022,'Patología Clínica Veterinaria',3,'Programa de Patología Clínica Veterinaria para alumnos de quinto semestre de Médico Veterinario Zootecnista, 2015.',1),
(2023,'Propedéutica Médico Veterinaria',3,'Programa de Propedéutica Médico Veterinaria para alumnos de quinto semestre de Médico Veterinario Zootecnista, 2015.',1),
(2024,'Diagnóstico Imagenológico Veterinario',3,'Programa de Diagnóstico Imagenológico Veterinario para alumnos de quinto semestre de Médico Veterinario Zootecnista, 2015.',1),
(2025,'Prácticas Médico Zootécnicas V',3,'Programa de Prácticas Médico Zootécnicas V para alumnos de quinto semestre de Médico Veterinario Zootecnista, 2015.',1),
/*(2026,'Optativa Profesionalizante I',0,'Programa de Optativa Profesionalizante para alumnos de quinto semestre de Médico Veterinario Zootecnista, 2015.',1),*/

(2027,'Inmunología Veterinaria',10,'Programa de Inmunología Veterinaria para alumnos de sexto semestre de Médico Veterinario Zootecnista, 2015.',1),
(2028,'Genética y Mejoramiento Animal',3,'Programa de Genética y Mejoramiento Animal para alumnos de sexto semestre de Médico Veterinario Zootecnista, 2015.',1),
(2029,'Reproducción Animal Asistida',3,'Programa de Reproducción Animal Asistida para alumnos de sexto semestre de Médico Veterinario Zootecnista, 2015.',1),
(2030,'Epizootiología',3,'Programa de Epizootiología para alumnos de sexto semestre de Médico Veterinario Zootecnista, 2015.',1),
(2031,'Prácticas Médico Zootécnicas VI',3,'Programa de Prácticas Médico Zootécnicas VI para alumnos de sexto semestre de Médico Veterinario Zootecnista, 2015.',1),
/*(2032,'Optativa Profesionalizante II',0,'Programa de Optativa Profesionalizante II para alumnos de sexto semestre de Médico Veterinario Zootecnista, 2015.',1),*/

(2033,'Bioestadística I (EST-B11)',6,'Programa de Bioestadística I (EST-B11) para alumnos de séptimo semestre de Médico Veterinario Zootecnista, 2015.',1),
(2034,'Investigación Pecuaria',3,'Programa de Investigación Pecuaria para alumnos de séptimo semestre de Médico Veterinario Zootecnista, 2015.',1),
(2035,'Cirugía Veterinaria',3,'Programa de Cirugía Veterinaria para alumnos de séptimo semestre de Médico Veterinario Zootecnista, 2015.',1),
(2036,'Calidad Sanitaria de Cárnicos y Lácteos',3,'Programa de Calidad Sanitaria de Cárnicos y Lácteos para alumnos de séptimo semestre de Médico Veterinario Zootecnista, 2015.',1),
(2037,'Prácticas Médico Zootécnicas VII',3,'Programa de Prácticas Médico Zootécnicas VII para alumnos de séptimo semestre de Médico Veterinario Zootecnista, 2015.',1),
/*(2038,'Optativa Profesionalizante III',0,'Programa de Optativa Profesionalizante III para alumnos de séptimo semestre de Médico Veterinario Zootecnista, 2015.',1),*/

(2039,'Formulación y Evaluación de Proyectos Pecuarios',35,'Programa de Formulación y Evaluación de Proyectos Pecuarios para alumnos de octavo semestre de Médico Veterinario Zootecnista, 2015.',1),
(2040,'Zootecnia y Clínica de Aves',3,'Programa de Zootecnia y Clínica de Aves para alumnos de octavo semestre de Médico Veterinario Zootecnista, 2015.',1),
(2041,'Zootecnia y Clínica de Equinos',3,'Programa de Zootecnia y Clínica de Equinos para alumnos de octavo semestre de Médico Veterinario Zootecnista, 2015.',1),
(2042,'Zootecnia y Clínica de Porcinos',3,'Programa de Zootecnia y Clínica de Porcinos para alumnos de octavo semestre de Médico Veterinario Zootecnista, 2015.',1),
(2043,'Prácticas Médico Zootécnicas VIII',3,'Programa de Prácticas Médico Zootécnicas VIII para alumnos de octavo semestre de Médico Veterinario Zootecnista, 2015.',1),

(2044,'Introd. a la Función Empresarial',35,'Programa de Introd. a la Función Empresarial para alumnos de noveno semestre de Médico Veterinario Zootecnista, 2015.',1),
(2045,'Zootecnia y Clínica de Perros y Gatos',3,'Programa de Zootecnia y Clínica de Perros y Gatos para alumnos de noveno semestre de Médico Veterinario Zootecnista, 2015.',1),
(2046,'Clínica de Rumiantes',3,'Programa de Clínica de Rumiantes para alumnos de noveno semestre de Médico Veterinario Zootecnista, 2015.',1),
(2047,'Zootecnia de Rumiantes',3,'Programa de Zootecnia de Rumiantes para alumnos de noveno semestre de Médico Veterinario Zootecnista, 2015.',1),
(2048,'Prácticas Médico Zootécnicas IX',3,'Programa de Prácticas Médico Zootécnicas IX para alumnos de noveno semestre de Médico Veterinario Zootecnista, 2015.',1),

(2049,'Prácticas Médico Zootécnicas X',3,'Programa de Prácticas Médico Zootécnicas X para alumnos de décimo semestre de Médico Veterinario Zootecnista, 2015.',1),
(2050,'Ética Profesional',47,'Programa de Ética Profesional para alumnos de décimo semestre de Médico Veterinario Zootecnista, 2015.',1);


/*----------------------------------------Centro de Ciencias Básicas----------------------------------------*/
/*Ing. Bioquímica*/

/*Plan 2019, Carrera 60*/
/*id(3001,4000), nombre, departamento, descripcion, vigente*/
/*1 a 47*/

INSERT INTO Materia VALUES 
(3001,'Precálculo',9,'Programa de Precálculo para alumnos de primer semestre de Ing. Bioquímica, 2019.',1),
(3002,'Química general (Q-CB2)',12,'Programa de Química general (Q-CB2) para alumnos de primer semestre de Ing. Bioquímica, 2019.',1),
(3003,'Química orgánica I (Q-CB2)',12,'Programa de Química orgánica I (Q-CB2) para alumnos de primer semestre de Ing. Bioquímica, 2019.',1),
(3004,'Fundamentos de ingeniería bioquímica',8,'Programa de Fundamentos de ingeniería bioquímica para alumnos de primer semestre de Ing. Bioquímica, 2019.',1),

(3005,'Cálculo diferencial (CD-A2)',9,'Programa de Cálculo diferencial (CD-A2) para alumnos de segundo semestre de Ing. Bioquímica, 2019.',1),
(3006,'Mecánica (M-A1)',9,'Programa de Mecánica (M-A1) para alumnos de segundo semestre de Ing. Bioquímica, 2019.',1),
(3007,'Biología celular',4,'Programa de Biología celular para alumnos de segundo semestre de Ing. Bioquímica, 2019.',1),
(3008,'Química orgánica II (Q-CB2)',12,'Programa de Química orgánica II (Q-CB2) para alumnos de segundo semestre de Ing. Bioquímica, 2019.',1),
(3009,'Investigación biotecnológica',8,'Programa de Investigación biotecnológica para alumnos de segundo semestre de Ing. Bioquímica, 2019.',1),

(3010,'Cálculo integral (CI-A2)',9,'Programa de Cálculo integral (CI-A2) para alumnos de tercer semestre de Ing. Bioquímica, 2019.',1),
(3011,'Electricidad y magnetismo (EM-A1)',9,'Programa de Electricidad y magnetismo (EM-A1) para alumnos de tercer semestre de Ing. Bioquímica, 2019.',1),
(3012,'Química analítica',12,'Programa de Química analítica para alumnos de tercer semestre de Ing. Bioquímica, 2019.',1),
(3013,'Bioquímica I',12,'Programa de Bioquímica I para alumnos de tercer semestre de Ing. Bioquímica, 2019.',1),
(3014,'Termodinámica (TD-1)',8,'Programa de Termodinámica (TD-1) para alumnos de tercer semestre de Ing. Bioquímica, 2019.',1),

(3015,'Ecuaciones diferenciales (ED-A2)',9,'Programa de Ecuaciones diferenciales (ED-A2) para alumnos de cuarto semestre de Ing. Bioquímica, 2019.',1),
(3016,'Estadística descriptiva y probabilidad (EST-C21)',6,'Programa de Estadística descriptiva y probabilidad (EST-C21) para alumnos de cuarto semestre de Ing. Bioquímica, 2019.',1),
(3017,'Análisis instrumental',12,'Programa de Análisis instrumental para alumnos de cuarto semestre de Ing. Bioquímica, 2019.',1),
(3018,'Bioquímica II',12,'Programa de Bioquímica II para alumnos de cuarto semestre de Ing. Bioquímica, 2019.',1),
(3019,'Fisicoquímica I (FQ-1)',8,'Programa de Fisicoquímica I (FQ-1) para alumnos de cuarto semestre de Ing. Bioquímica, 2019.',1),
(3020,'Balances de materia y energía (BME-1)',8,'Programa de Balances de materia y energía (BME-1) para alumnos de cuarto semestre de Ing. Bioquímica, 2019.',1),

(3021,'Inferencia estadística (EST-C22)',6,'Programa de Inferencia estadística (EST-C22) para alumnos de quinto semestre de Ing. Bioquímica, 2019.',1),
(3022,'Microbiología',10,'Programa de Microbiología para alumnos de quinto semestre de Ing. Bioquímica, 2019.',1),
(3023,'Fisicoquímica II (FQ-2)',8,'Programa de Fisicoquímica II (FQ-2) para alumnos de quinto semestre de Ing. Bioquímica, 2019.',1),
(3024,'Operaciones unitarias I',8,'Programa de Operaciones unitarias I para alumnos de quinto semestre de Ing. Bioquímica, 2019.',1),
(3025,'Tecnología farmacéutica',8,'Programa de Tecnología farmacéutica para alumnos de quinto semestre de Ing. Bioquímica, 2019.',1),
(3026,'Biología molecular e ingeniería genética',12,'Programa de Biología molecular e ingeniería genética para alumnos de quinto semestre de Ing. Bioquímica, 2019.',1),

(3027,'Operaciones unitarias II',8,'Programa de Operaciones unitarias II para alumnos de sexto semestre de Ing. Bioquímica, 2019.',1),
(3028,'Control estadístico de la calidad',8,'Programa de Control estadístico de la calidad para alumnos de sexto semestre de Ing. Bioquímica, 2019.',1),
(3029,'Biotecnología',8,'Programa de Biotecnología para alumnos de sexto semestre de Ing. Bioquímica, 2019.',1),
(3030,'Biotecnología ambiental',8,'Programa de Biotecnología ambiental para alumnos de sexto semestre de Ing. Bioquímica, 2019.',1),
(3031,'Bioquímica de los alimentos',8,'Programa de Bioquímica de los alimentos para alumnos de sexto semestre de Ing. Bioquímica, 2019.',1),

(3032,'Operaciones unitarias III',8,'Programa de Operaciones unitarias III para alumnos de séptimo semestre de Ing. Bioquímica, 2019.',1),
(3033,'Ingeniería de fermentaciones',8,'Programa de Ingeniería de fermentaciones para alumnos de séptimo semestre de Ing. Bioquímica, 2019.',1),
(3034,'Bioingeniería ambiental',8,'Programa de Bioingeniería ambiental para alumnos de séptimo semestre de Ing. Bioquímica, 2019.',1),
(3035,'Análisis de alimentos',8,'Programa de Análisis de alimentos para alumnos de séptimo semestre de Ing. Bioquímica, 2019.',1),
(3036,'Métodos de conservación de alimentos I',2,'Programa de Métodos de conservación de alimentos I para alumnos de séptimo semestre de Ing. Bioquímica, 2019.',1),
(3037,'HACCP en biotecnología',8,'Programa de HACCP en biotecnología para alumnos de séptimo semestre de Ing. Bioquímica, 2019.',1),

(3038,'Operaciones unitarias IV',8,'Programa de Operaciones unitarias IV para alumnos de octavo semestre de Ing. Bioquímica, 2019.',1),
(3039,'Ingeniería de servicios',8,'Programa de Ingeniería de servicios para alumnos de octavo semestre de Ing. Bioquímica, 2019.',1),
(3040,'Bioprocesos',8,'Programa de Bioprocesos para alumnos de octavo semestre de Ing. Bioquímica, 2019.',1),
(3041,'Instrumentación y control de bioprocesos',8,'Programa de Instrumentación y control de bioprocesos para alumnos de octavo semestre de Ing. Bioquímica, 2019.',1),
(3042,'Métodos de conservación de alimentos II',2,'Programa de Métodos de conservación de alimentos II para alumnos de octavo semestre de Ing. Bioquímica, 2019.',1),
/*(3043,'Optativa profesionalizante I',8,'Programa de Optativa profesionalizante I para alumnos de octavo semestre de Ing. Bioquímica, 2019.',1),
(3044,'Optativa profesionalizante II',8,'Programa de Optativa profesionalizante II para alumnos de octavo semestre de Ing. Bioquímica, 2019.',1),*/

(3045,'Ética profesional',47,'Programa de Ética profesional para alumnos de noveno semestre de Ing. Bioquímica, 2019.',1),
(3046,'Evaluación de proyectos de inversión',35,'Programa de Evaluación de proyectos de inversión para alumnos de noveno semestre de Ing. Bioquímica, 2019.',1),
(3047,'Introducción a la función empresarial ',32,'Programa de Introducción a la función empresarial  para alumnos de noveno semestre de Ing. Bioquímica, 2019.',1);


/*Ing. en Computación Inteligente*/

/*Plan 2017, Carrera 66*/
/*id(4001-5000), nombre, departamento, descripcion, vigente*/
/*1-59*/

INSERT INTO Materia VALUES 
(4001,'Lenguajes de Computación I',5,'Programa de Lenguajes de Computación I para alumnos de primer semestre de Ing. en Computación Inteligente, 2017.',1),
(4002,'Fundamentos de Estructuras Computacionales',5,'Programa de Fundamentos de Estructuras Computacionales para alumnos de primer semestre de Ing. en Computación Inteligente, 2017.',1),
(4003,'Cálculo Diferencial',9,'Programa de Cálculo Diferencial para alumnos de primer semestre de Ing. en Computación Inteligente, 2017.',1),
(4004,'Álgebra Superior',9,'Programa de Álgebra Superior para alumnos de primer semestre de Ing. en Computación Inteligente, 2017.',1),
(4005,'Contabilidad Básica',33,'Programa de Contabilidad Básica para alumnos de primer semestre de Ing. en Computación Inteligente, 2017.',1),

(4006,'Lenguajes de Computación II',5,'Programa de Lenguajes de Computación II para alumnos de segundo semestre de Ing. en Computación Inteligente, 2017.',1),
(4007,'Estructuras Computacionales',5,'Programa de Estructuras Computacionales para alumnos de segundo semestre de Ing. en Computación Inteligente, 2017.',1),
(4008,'Lógica Digital',14,'Programa de Lógica Digital para alumnos de segundo semestre de Ing. en Computación Inteligente, 2017.',1),
(4009,'Cálculo Integral',9,'Programa de Cálculo Integral para alumnos de segundo semestre de Ing. en Computación Inteligente, 2017.',1),
(4010,'Economía General',34,'Programa de Economía General para alumnos de segundo semestre de Ing. en Computación Inteligente, 2017.',1),
(4011,'Lenguajes de Computación II',5,'Programa de Lenguajes de Computación II para alumnos de segundo semestre de Ing. en Computación Inteligente, 2017.',1),

(4012,'Lenguajes de Computación III',5,'Programa de Lenguajes de Computación III para alumnos de tercer semestre de Ing. en Computación Inteligente, 2017.',1),
(4013,'Estructuras Computacionales Avanzadas',5,'Programa de Estructuras Computacionales Avanzadas para alumnos de tercer semestre de Ing. en Computación Inteligente, 2017.',1),
(4014,'Inteligencia Artificial',5,'Programa de Inteligencia Artificial para alumnos de tercer semestre de Ing. en Computación Inteligente, 2017.',1),
(4015,'Álgebra lineal (AL-A2)',9,'Programa de Álgebra lineal (AL-A2) para alumnos de tercer semestre de Ing. en Computación Inteligente, 2017.',1),
(4016,'Estadística descriptiva y probabilidad (EST-C21)',6,'Programa de Estadística descriptiva y probabilidad (EST-C21) para alumnos de tercer semestre de Ing. en Computación Inteligente, 2017.',1),
(4017,'Redacción Básica',55,'Programa de Redacción Básica para alumnos de tercer semestre de Ing. en Computación Inteligente, 2017.',1),

(4018,'Lenguajes de Computación IV',5,'Programa de Lenguajes de Computación IV para alumnos de cuarto semestre de Ing. en Computación Inteligente, 2017.',1),
(4019,'Programación Científica',5,'Programa de Programación Científica para alumnos de cuarto semestre de Ing. en Computación Inteligente, 2017.',1),
(4020,'Organización Computacional',14,'Programa de Organización Computacional para alumnos de cuarto semestre de Ing. en Computación Inteligente, 2017.',1),
(4021,'Análisis y Diseño',13,'Programa de Análisis y Diseño para alumnos de cuarto semestre de Ing. en Computación Inteligente, 2017.',1),
(4022,'Técnicas Inteligentes para Procesos de Desarrollo',13,'Programa de Técnicas Inteligentes para Procesos de Desarrollo para alumnos de cuarto semestre de Ing. en Computación Inteligente, 2017.',1),
(4023,'Mecánica',9,'Programa de Mecánica para alumnos de cuarto semestre de Ing. en Computación Inteligente, 2017.',1),


(4024,'Optimización Inteligente',5,'Programa de Optimización Inteligente para alumnos de quinto semestre de Ing. en Computación Inteligente, 2017.',1),
(4025,'Autómatas I',5,'Programa de Autómatas I para alumnos de quinto semestre de Ing. en Computación Inteligente, 2017.',1),
(4026,'Arquitectura Inteligente de Desarrollo Híbrido',5,'Programa de Arquitectura Inteligente de Desarrollo Híbrido para alumnos de quinto semestre de Ing. en Computación Inteligente, 2017.',1),
(4027,'Lenguajes Inteligentes',5,'Programa de Lenguajes Inteligentes para alumnos de quinto semestre de Ing. en Computación Inteligente, 2017.',1),
(4028,'Ecuaciones Diferenciales (ED-A3)',9,'Programa de Ecuaciones Diferenciales (ED-A3) para alumnos de quinto semestre de Ing. en Computación Inteligente, 2017.',1),
(4029,'Bases de Datos',13,'Programa de Bases de Datos para alumnos de quinto semestre de Ing. en Computación Inteligente, 2017.',1),
(4030,'Optimización Inteligente',5,'Programa de Optimización Inteligente para alumnos de quinto semestre de Ing. en Computación Inteligente, 2017.',1),

(4031,'Teoría de la Complejidad Computacional',5,'Programa de Teoría de la Complejidad Computacional para alumnos de sexto semestre de Ing. en Computación Inteligente, 2017.',1),
(4032,'Aprendizaje Inteligente',5,'Programa de Aprendizaje Inteligente para alumnos de sexto semestre de Ing. en Computación Inteligente, 2017.',1),
(4033,'Ética Profesional ',47,'Programa de Ética Profesional  para alumnos de sexto semestre de Ing. en Computación Inteligente, 2017.',1),
(4034,'Introducción a los Sistemas Operativos',14,'Programa de Introducción a los Sistemas Operativos para alumnos de sexto semestre de Ing. en Computación Inteligente, 2017.',1),
(4035,'Investigación de Operaciones (IO-A3)',9,'Programa de Investigación de Operaciones (IO-A3) para alumnos de sexto semestre de Ing. en Computación Inteligente, 2017.',1),
(4036,'Desarrollo de Emprendedores',32,'Programa de Desarrollo de Emprendedores para alumnos de sexto semestre de Ing. en Computación Inteligente, 2017.',1),

(4037,'Autómatas II',5,'Programa de Autómatas II para alumnos de séptimo semestre de Ing. en Computación Inteligente, 2017.',1),
(4038,'Desarrollo de Medios Digitales',5,'Programa de Desarrollo de Medios Digitales para alumnos de séptimo semestre de Ing. en Computación Inteligente, 2017.',1),
(4039,'Metaheurísticas I',5,'Programa de Metaheurísticas I para alumnos de séptimo semestre de Ing. en Computación Inteligente, 2017.',1),
(4040,'Evolución de Software Inteligente',5,'Programa de Evolución de Software Inteligente para alumnos de séptimo semestre de Ing. en Computación Inteligente, 2017.',1),
(4041,'Procesamiento de Imágenes',5,'Programa de Procesamiento de Imágenes para alumnos de séptimo semestre de Ing. en Computación Inteligente, 2017.',1),
(4042,'Lenguaje Ensamblador',14,'Programa de Lenguaje Ensamblador para alumnos de séptimo semestre de Ing. en Computación Inteligente, 2017.',1),
(4043,'Redes I',14,'Programa de Redes I para alumnos de séptimo semestre de Ing. en Computación Inteligente, 2017.',1),

(4044,'Metaheurísticas I',5,'Programa de Metaheurísticas I para alumnos de octavo semestre de Ing. en Computación Inteligente, 2017.',1),
(4045,'Graficación',5,'Programa de Graficación para alumnos de octavo semestre de Ing. en Computación Inteligente, 2017.',1),
(4046,'Sistemas Expertos Probabilísticos',5,'Programa de Sistemas Expertos Probabilísticos para alumnos de octavo semestre de Ing. en Computación Inteligente, 2017.',1),
(4047,'Metodología de desarrollo para dispositivos móviles',5,'Programa de Metodología de desarrollo para dispositivos móviles para alumnos de octavo semestre de Ing. en Computación Inteligente, 2017.',1),
(4048,'Redes II',14,'Programa de Redes II para alumnos de octavo semestre de Ing. en Computación Inteligente, 2017.',1),
(4049,'Administración de Software y Proyectos',13,'Programa de Administración de Software y Proyectos para alumnos de octavo semestre de Ing. en Computación Inteligente, 2017.',1),
(4050,'Derecho Informático',45,'Programa de Derecho Informático para alumnos de octavo semestre de Ing. en Computación Inteligente, 2017.',1),

(4051,'Teoría de Sistemas Interactivos',5,'Programa de Teoría de Sistemas Interactivos para alumnos de noveno semestre de Ing. en Computación Inteligente, 2017.',1),
(4052,'Seminario de Investigación I',5,'Programa de Seminario de Investigación I para alumnos de noveno semestre de Ing. en Computación Inteligente, 2017.',1),
(4053,'Servicios Web',5,'Programa de Servicios Web para alumnos de noveno semestre de Ing. en Computación Inteligente, 2017.',1),
(4054,'Paralelización de Algoritmos',5,'Programa de Paralelización de Algoritmos para alumnos de noveno semestre de Ing. en Computación Inteligente, 2017.',1),
(4055,'Seguridad e Integridad de Sistemas',14,'Programa de Seguridad e Integridad de Sistemas para alumnos de noveno semestre de Ing. en Computación Inteligente, 2017.',1),
(4056,'Minería de Datos',5,'Programa de Minería de Datos para alumnos de noveno semestre de Ing. en Computación Inteligente, 2017.',1),

(4057,'Seminario de Investigación I',5,'Programa de Seminario de Investigación I para alumnos de décimo semestre de Ing. en Computación Inteligente, 2017.',1);
/*(4058,'Optativa Profesionalizante I',5,'Programa de Optativa Profesionalizante I para alumnos de décimo semestre de Ing. en Computación Inteligente, 2017.',1),
(4059,'Optativa Profesionalizante II',5,'Programa de Optativa Profesionalizante II para alumnos de décimo semestre de Ing. en Computación Inteligente, 2017.',1);*/


/*Ing. en Electrónica*/
/*Plan 2019, Carrera 67*/
/*id(5001-6000), nombre, departamento, descripcion, vigente*/
/*1-51*/

INSERT INTO Materia VALUES 
(5001,'Introducción a la Ingeniería Electrónica',14,'Programa de Introducción a la Ingeniería Electrónica para alumnos de primer semestre de Ing. en Electrónica, 2019.',1),
(5002,'Programación en Lenguaje C',14,'Programa de Programación en Lenguaje C para alumnos de primer semestre de Ing. en Electrónica, 2019.',1),
(5003,'Álgebra',9,'Programa de Álgebra para alumnos de primer semestre de Ing. en Electrónica, 2019.',1),
(5004,'Mecánica (M-A1)',9,'Programa de Mecánica (M-A1) para alumnos de primer semestre de Ing. en Electrónica, 2019.',1),
(5005,'Taller de Redacción',55,'Programa de Taller de Redacción para alumnos de primer semestre de Ing. en Electrónica, 2019.',1),

(5006,'Introducción a los Sistemas Digitales',14,'Programa de Introducción a los Sistemas Digitales para alumnos de segundo semestre de Ing. en Electrónica, 2019.',1),
(5007,'Software de Diseño Electrónico ',14,'Programa de Software de Diseño Electrónico  para alumnos de segundo semestre de Ing. en Electrónica, 2019.',1),
(5008,'Programación C++',14,'Programa de Programación C++ para alumnos de segundo semestre de Ing. en Electrónica, 2019.',1),
(5009,'Álgebra Matricial',9,'Programa de Álgebra Matricial para alumnos de segundo semestre de Ing. en Electrónica, 2019.',1),
(5010,'Cálculo Diferencial e Integral (CDI-A1)',9,'Programa de Cálculo Diferencial e Integral (CDI-A1) para alumnos de segundo semestre de Ing. en Electrónica, 2019.',1),

(5011,'Sistemas Digitales Secuenciales',14,'Programa de Sistemas Digitales Secuenciales para alumnos de tercer semestre de Ing. en Electrónica, 2019.',1),
(5012,'Arquitectura de Computadoras',14,'Programa de Arquitectura de Computadoras para alumnos de tercer semestre de Ing. en Electrónica, 2019.',1),
(5013,'Cálculo Vectorial',9,'Programa de Cálculo Vectorial para alumnos de tercer semestre de Ing. en Electrónica, 2019.',1),
(5014,'Electricidad y Magnetismo (EM-A2)',9,'Programa de Electricidad y Magnetismo (EM-A2) para alumnos de tercer semestre de Ing. en Electrónica, 2019.',1),
(5015,'Estadística Descriptiva y Probabilidad (EST-C21)',6,'Programa de Estadística Descriptiva y Probabilidad (EST-C21) para alumnos de tercer semestre de Ing. en Electrónica, 2019.',1),
(5016,'Habilidades Directivas',32,'Programa de Habilidades Directivas para alumnos de tercer semestre de Ing. en Electrónica, 2019.',1),

(5017,'Aritmética de Computadoras',14,'Programa de Aritmética de Computadoras para alumnos de cuarto semestre de Ing. en Electrónica, 2019.',1),
(5018,'Circuitos Eléctricos en Corriente Directa',14,'Programa de Circuitos Eléctricos en Corriente Directa para alumnos de cuarto semestre de Ing. en Electrónica, 2019.',1),
(5019,'Lenguaje Ensamblador',14,'Programa de Lenguaje Ensamblador para alumnos de cuarto semestre de Ing. en Electrónica, 2019.',1),
(5020,'Química de Materiales (Q-CB1)',12,'Programa de Química de Materiales (Q-CB1) para alumnos de cuarto semestre de Ing. en Electrónica, 2019.',1),
(5021,'Ecuaciones Diferenciales (ED-A4)',9,'Programa de Ecuaciones Diferenciales (ED-A4) para alumnos de cuarto semestre de Ing. en Electrónica, 2019.',1),
(5022,'Ética Profesional',47,'Programa de Ética Profesional para alumnos de cuarto semestre de Ing. en Electrónica, 2019.',1),

(5023,'Sistemas Embebidos',14,'Programa de Sistemas Embebidos para alumnos de quinto semestre de Ing. en Electrónica, 2019.',1),
(5024,'Dispositivos Electrónicos Básicos',14,'Programa de Dispositivos Electrónicos Básicos para alumnos de quinto semestre de Ing. en Electrónica, 2019.',1),
(5025,'Circuitos Eléctricos en Corriente Alterna',14,'Programa de Circuitos Eléctricos en Corriente Alterna para alumnos de quinto semestre de Ing. en Electrónica, 2019.',1),
(5026,'Señales y Sistemas',14,'Programa de Señales y Sistemas para alumnos de quinto semestre de Ing. en Electrónica, 2019.',1),
(5027,'Teoría Electromagnética',9,'Programa de Teoría Electromagnética para alumnos de quinto semestre de Ing. en Electrónica, 2019.',1),
(5028,'Relaciones Multiculturales en la Industria',51,'Programa de Relaciones Multiculturales en la Industria para alumnos de quinto semestre de Ing. en Electrónica, 2019.',1),

(5029,'Cómputo para Ingeniería Electrónica',14,'Programa de Cómputo para Ingeniería Electrónica para alumnos de sexto semestre de Ing. en Electrónica, 2019.',1),
(5030,'Diseño de Amplificadores y Circuitos Electrónicos',14,'Programa de Diseño de Amplificadores y Circuitos Electrónicos para alumnos de sexto semestre de Ing. en Electrónica, 2019.',1),
(5031,'Electrónica de Potencia',14,'Programa de Electrónica de Potencia para alumnos de sexto semestre de Ing. en Electrónica, 2019.',1),
(5032,'Teoría de Control I',14,'Programa de Teoría de Control I para alumnos de sexto semestre de Ing. en Electrónica, 2019.',1),
(5033,'Control Industrial',14,'Programa de Control Industrial para alumnos de sexto semestre de Ing. en Electrónica, 2019.',1),
(5034,'Redes de Datos con Linux',14,'Programa de Redes de Datos con Linux para alumnos de sexto semestre de Ing. en Electrónica, 2019.',1),

(5035,'Sistemas Embebidos con Linux',14,'Programa de Sistemas Embebidos con Linux para alumnos de séptimo semestre de Ing. en Electrónica, 2019.',1),
(5036,'Amplificadores Operacionales',14,'Programa de Amplificadores Operacionales para alumnos de séptimo semestre de Ing. en Electrónica, 2019.',1),
(5037,'Máquinas Eléctricas',14,'Programa de Máquinas Eléctricas para alumnos de séptimo semestre de Ing. en Electrónica, 2019.',1),
(5038,'Sistemas de Comunicación Analógica',14,'Programa de Sistemas de Comunicación Analógica para alumnos de séptimo semestre de Ing. en Electrónica, 2019.',1),
(5039,'Teoría de Control II',14,'Programa de Teoría de Control II para alumnos de séptimo semestre de Ing. en Electrónica, 2019.',1),
(5040,'Instrumentación Electrónica',14,'Programa de Instrumentación Electrónica para alumnos de séptimo semestre de Ing. en Electrónica, 2019.',1),

(5041,'Internet de las cosas',14,'Programa de Internet de las cosas para alumnos de octavo semestre de Ing. en Electrónica, 2019.',1),
(5042,'Diseño de Circuitos Integrados Digitales',14,'Programa de Diseño de Circuitos Integrados Digitales para alumnos de octavo semestre de Ing. en Electrónica, 2019.',1),
(5043,'Sistemas de Comunicación Digital',14,'Programa de Sistemas de Comunicación Digital para alumnos de octavo semestre de Ing. en Electrónica, 2019.',1),
(5044,'Instrumentación Avanzada',14,'Programa de Instrumentación Avanzada para alumnos de octavo semestre de Ing. en Electrónica, 2019.',1),
(5045,'Control Discreto',14,'Programa de Control Discreto para alumnos de octavo semestre de Ing. en Electrónica, 2019.',1),
(5046,'Operaciones Financieras',35,'Programa de Operaciones Financieras para alumnos de octavo semestre de Ing. en Electrónica, 2019.',1),

(5047,'Diseño de Circuitos Integrados Analógicos',14,'Programa de Diseño de Circuitos Integrados Analógicos para alumnos de noveno semestre de Ing. en Electrónica, 2019.',1),
(5048,'Proyecto Integral de Electrónica',14,'Programa de Proyecto Integral de Electrónica para alumnos de noveno semestre de Ing. en Electrónica, 2019.',1),
(5049,'Evaluación de Proyectos de Inversión',35,'Programa de Evaluación de Proyectos de Inversión para alumnos de noveno semestre de Ing. en Electrónica, 2019.',1);
/*(5050,'Optativa profesionalizante I',14,'Programa de Optativa profesionalizante I para alumnos de noveno semestre de Ing. en Electrónica, 2019.',1),
(5051,'Optativa profesionalizante II',14,'Programa de Optativa profesionalizante II para alumnos de noveno semestre de Ing. en Electrónica, 2019.',1);*/


/*Ing. en Sistemas Computacionales*/
/*Plan 2016, Carrera 61*/
/*id(6001-7000), nombre, departamento, descripcion, vigente*/
/*1-51*/

INSERT INTO Materia VALUES 
(6001,'Contabilidad Básica',33,'Programa de Contabilidad Básica para alumnos de primer semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6002,'Álgebra',9,'Programa de Álgebra para alumnos de primer semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6003,'Cálculo Diferencial',9,'Programa de Cálculo Diferencial para alumnos de primer semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6004,'Química de Materiales',12,'Programa de Química de Materiales para alumnos de primer semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6005,'Introducción a la Ingeniería',14,'Programa de Introducción a la Ingeniería para alumnos de primer semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6006,'Lógica de Programación',14,'Programa de Lógica de Programación para alumnos de primer semestre de Ing. en Sistemas Computacionales, 2016.',1),

(6007,'Herramientas Financieras',35,'Programa de Herramientas Financieras para alumnos de segundo semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6008,'Redacción Básica',55,'Programa de Redacción Básica para alumnos de segundo semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6009,'Álgebra Lineal (AL-A1)',9,'Programa de Álgebra Lineal (AL-A1) para alumnos de segundo semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6010,'Cálculo Integral',9,'Programa de Cálculo Integral para alumnos de segundo semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6011,'Circuitos Lógicos',14,'Programa de Circuitos Lógicos para alumnos de segundo semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6012,'Programación I',14,'Programa de Programación I para alumnos de segundo semestre de Ing. en Sistemas Computacionales, 2016.',1),

(6013,'Métodos Numéricos',9,'Programa de Métodos Numéricos para alumnos de tercer semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6014,'Cálculo Vectorial',9,'Programa de Cálculo Vectorial para alumnos de tercer semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6015,'Organización Computacional',14,'Programa de Organización Computacional para alumnos de tercer semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6016,'Sistemas Operativos',14,'Programa de Sistemas Operativos para alumnos de tercer semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6017,'Estructuras de Datos',14,'Programa de Estructuras de Datos para alumnos de tercer semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6018,'Programación II',14,'Programa de Programación II para alumnos de tercer semestre de Ing. en Sistemas Computacionales, 2016.',1),

(6019,'Lenguaje Ensamblador',14,'Programa de Lenguaje Ensamblador para alumnos de cuarto semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6020,'Matemáticas Discretas',9,'Programa de Matemáticas Discretas para alumnos de cuarto semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6021,'UNIX',14,'Programa de UNIX para alumnos de cuarto semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6022,'Física',9,'Programa de Física para alumnos de cuarto semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6023,'Programación III',14,'Programa de Programación III para alumnos de cuarto semestre de Ing. en Sistemas Computacionales, 2016.',1),

(6024,'Ética Profesional',47,'Programa de Ética Profesional para alumnos de quinto semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6025,'Ecuaciones Diferenciales (ED-A1)',9,'Programa de Ecuaciones Diferenciales (ED-A1) para alumnos de quinto semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6026,'Circuitos Eléctricos',14,'Programa de Circuitos Eléctricos para alumnos de quinto semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6027,'Redes de Computadoras I',14,'Programa de Redes de Computadoras I para alumnos de quinto semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6028,'Programación de Sistemas Web',14,'Programa de Programación de Sistemas Web para alumnos de quinto semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6029,'Base de Datos',13,'Programa de Base de Datos para alumnos de quinto semestre de Ing. en Sistemas Computacionales, 2016.',1),

(6030,'Estadística Descriptiva y Probabilidad (EST-C21)',6,'Programa de Estadística Descriptiva y Probabilidad (EST-C21) para alumnos de sexto semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6031,'Electrónica I',14,'Programa de Electrónica I para alumnos de sexto semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6032,'Redes de Computadoras II',14,'Programa de Redes de Computadoras II para alumnos de sexto semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6033,'Tecnologías Web',14,'Programa de Tecnologías Web para alumnos de sexto semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6034,'Análisis y Diseño de Sistemas',13,'Programa de Análisis y Diseño de Sistemas para alumnos de sexto semestre de Ing. en Sistemas Computacionales, 2016.',1),

(6035,'Inferencia Estadística',6,'Programa de Inferencia Estadística para alumnos de séptimo semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6036,'Electrónica II',14,'Programa de Electrónica II para alumnos de séptimo semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6037,'Redes de Computadoras III',14,'Programa de Redes de Computadoras III para alumnos de séptimo semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6038,'Programación de Dispositivos Móviles',14,'Programa de Programación de Dispositivos Móviles para alumnos de séptimo semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6039,'Lenguajes de Bases de Datos',14,'Programa de Lenguajes de Bases de Datos para alumnos de séptimo semestre de Ing. en Sistemas Computacionales, 2016.',1),

(6040,'Compiladores I',14,'Programa de Compiladores I para alumnos de octavo semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6041,'Bases de Datos Distribuidas',14,'Programa de Bases de Datos Distribuidas para alumnos de octavo semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6042,'Instrumentación Electrónica',14,'Programa de Instrumentación Electrónica para alumnos de octavo semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6043,'Seminario de Sistemas Computacionales I',14,'Programa de Seminario de Sistemas Computacionales I para alumnos de octavo semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6044,'Investigación de Operaciones (IO-A1)',9,'Programa de Investigación de Operaciones (IO-A1) para alumnos de octavo semestre de Ing. en Sistemas Computacionales, 2016.',1),
/*(6045,'Optativa Profesionalizante Abierta I',14,'Programa de Optativa Profesionalizante Abierta I para alumnos de octavo semestre de Ing. en Sistemas Computacionales, 2016.',1),*/

(6046,'Desarrollo de Emprendedores',32,'Programa de Desarrollo de Emprendedores para alumnos de noveno semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6047,'Derecho Informático',45,'Programa de Derecho Informático para alumnos de noveno semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6048,'Compiladores II',14,'Programa de Compiladores II para alumnos de noveno semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6049,'Metodologías de Desarrollo de Sistemas',14,'Programa de Metodologías de Desarrollo de Sistemas para alumnos de noveno semestre de Ing. en Sistemas Computacionales, 2016.',1),
(6050,'Seminario de Sistemas Computacionales II',14,'Programa de Seminario de Sistemas Computacionales II para alumnos de noveno semestre de Ing. en Sistemas Computacionales, 2016.',1);
/*(6051,'Optativa Profesionalizante Abierta II',14,'Programa de Optativa Profesionalizante Abierta II para alumnos de noveno semestre de Ing. en Sistemas Computacionales, 2016.',1);*/


/*Ing. Industrial Estadístico*/

/*Plan 2019, Carrera 69*/
/*id(7001-8000), nombre, departamento, descripcion, vigente*/
/*1-52*/

INSERT INTO Materia VALUES 
(7001,'Taller de Estadística Industrial',6,'Programa de Taller de Estadística Industrial para alumnos de primer semestre de Ing. Industrial Estadístico, 2019.',1),
(7002,'Introducción a las TIC',13,'Programa de Introducción a las TIC para alumnos de primer semestre de Ing. Industrial Estadístico, 2019.',1),
(7003,'Cálculo Diferencial',9,'Programa de Cálculo Diferencial para alumnos de primer semestre de Ing. Industrial Estadístico, 2019.',1),
(7004,'Dibujo Industrial',28,'Programa de Dibujo Industrial para alumnos de primer semestre de Ing. Industrial Estadístico, 2019.',1),
(7005,'Administración',32,'Programa de Administración para alumnos de primer semestre de Ing. Industrial Estadístico, 2019.',1),
(7006,'Habilidades para la Vida',50,'Programa de Habilidades para la Vida para alumnos de primer semestre de Ing. Industrial Estadístico, 2019.',1),

(7007,'Taller de Metodología Estadística',6,'Programa de Taller de Metodología Estadística para alumnos de segundo semestre de Ing. Industrial Estadístico, 2019.',1),
(7008,'Informática para Ingeniería',13,'Programa de Informática para Ingeniería para alumnos de segundo semestre de Ing. Industrial Estadístico, 2019.',1),
(7009,'Instrumentación Industrial',14,'Programa de Instrumentación Industrial para alumnos de segundo semestre de Ing. Industrial Estadístico, 2019.',1),
(7010,'Cálculo Integral',9,'Programa de Cálculo Integral para alumnos de segundo semestre de Ing. Industrial Estadístico, 2019.',1),
(7011,'Sistemas de Producción',37,'Programa de Sistemas de Producción para alumnos de segundo semestre de Ing. Industrial Estadístico, 2019.',1),
(7012,'Contabilidad de Costos',33,'Programa de Contabilidad de Costos para alumnos de segundo semestre de Ing. Industrial Estadístico, 2019.',1),

(7013,'Cómputo Estadístico',6,'Programa de Cómputo Estadístico para alumnos de tercer semestre de Ing. Industrial Estadístico, 2019.',1),
(7014,'Probabilidad',6,'Programa de Probabilidad para alumnos de tercer semestre de Ing. Industrial Estadístico, 2019.',1),
(7015,'Álgebra Lineal (AL-A1)',9,'Programa de Álgebra Lineal (AL-A1) para alumnos de tercer semestre de Ing. Industrial Estadístico, 2019.',1),
(7016,'Materiales y Procesos de Manufactura',29,'Programa de Materiales y Procesos de Manufactura para alumnos de tercer semestre de Ing. Industrial Estadístico, 2019.',1),
(7017,'Localización, Distribución y Manejo de Materiales',37,'Programa de Localización, Distribución y Manejo de Materiales para alumnos de tercer semestre de Ing. Industrial Estadístico, 2019.',1),
(7018,'Ingeniería Económica',35,'Programa de Ingeniería Económica para alumnos de tercer semestre de Ing. Industrial Estadístico, 2019.',1),

(7019,'Estadística y Calidad',6,'Programa de Estadística y Calidad para alumnos de cuarto semestre de Ing. Industrial Estadístico, 2019.',1),
(7020,'Inferencia Estadística',6,'Programa de Inferencia Estadística para alumnos de cuarto semestre de Ing. Industrial Estadístico, 2019.',1),
(7021,'Cálculo Vectorial',9,'Programa de Cálculo Vectorial para alumnos de cuarto semestre de Ing. Industrial Estadístico, 2019.',1),
(7022,'Administración de Flujo de Materiales y Logística',37,'Programa de Administración de Flujo de Materiales y Logística para alumnos de cuarto semestre de Ing. Industrial Estadístico, 2019.',1),
(7023,'Ergonomía',29,'Programa de Ergonomía para alumnos de cuarto semestre de Ing. Industrial Estadístico, 2019.',1),
(7024,'Estrategias Comunicativas Gerenciales',44,'Programa de Estrategias Comunicativas Gerenciales para alumnos de cuarto semestre de Ing. Industrial Estadístico, 2019.',1),

(7025,'Administración de Proyectos Industriales',37,'Programa de Administración de Proyectos Industriales para alumnos de quinto semestre de Ing. Industrial Estadístico, 2019.',1),
(7026,'Aplicaciones Estadísticas a la Metrología del Trabajo',6,'Programa de Aplicaciones Estadísticas a la Metrología del Trabajo para alumnos de quinto semestre de Ing. Industrial Estadístico, 2019.',1),
(7027,'Análisis de Regresión',6,'Programa de Análisis de Regresión para alumnos de quinto semestre de Ing. Industrial Estadístico, 2019.',1),
(7028,'Bases de Datos Aplicadas',13,'Programa de Bases de Datos Aplicadas para alumnos de quinto semestre de Ing. Industrial Estadístico, 2019.',1),
(7029,'Mecánica (M-A1)',9,'Programa de Mecánica (M-A1) para alumnos de quinto semestre de Ing. Industrial Estadístico, 2019.',1),
(7030,'Investigación de Operaciones (IO-A1)',9,'Programa de Investigación de Operaciones (IO-A1) para alumnos de quinto semestre de Ing. Industrial Estadístico, 2019.',1),

(7031,'Control Estadístico de la Calidad',6,'Programa de Control Estadístico de la Calidad para alumnos de sexto semestre de Ing. Industrial Estadístico, 2019.',1),
(7032,'Muestreo',6,'Programa de Muestreo para alumnos de sexto semestre de Ing. Industrial Estadístico, 2019.',1),
(7033,'Instalaciones Eléctricas y Máquinas Eléctricas',14,'Programa de Instalaciones Eléctricas y Máquinas Eléctricas para alumnos de sexto semestre de Ing. Industrial Estadístico, 2019.',1),
(7034,'Administración de Operaciones',37,'Programa de Administración de Operaciones para alumnos de sexto semestre de Ing. Industrial Estadístico, 2019.',1),
(7035,'Desarrollo de Emprendedores',32,'Programa de Desarrollo de Emprendedores para alumnos de sexto semestre de Ing. Industrial Estadístico, 2019.',1),
(7036,'Ética Profesional',47,'Programa de Ética Profesional para alumnos de sexto semestre de Ing. Industrial Estadístico, 2019.',1),

(7037,'Laboratorio de Control Estadístico de la Calidad',6,'Programa de Laboratorio de Control Estadístico de la Calidad para alumnos de séptimo semestre de Ing. Industrial Estadístico, 2019.',1),
(7038,'Diseño Estadístico de Experimentos Industriales',6,'Programa de Diseño Estadístico de Experimentos Industriales para alumnos de séptimo semestre de Ing. Industrial Estadístico, 2019.',1),
(7039,'Métodos Multivariados',6,'Programa de Métodos Multivariados para alumnos de séptimo semestre de Ing. Industrial Estadístico, 2019.',1),
(7040,'Modelos Estocásticos',6,'Programa de Modelos Estocásticos para alumnos de séptimo semestre de Ing. Industrial Estadístico, 2019.',1),
(7041,'Automatización I',14,'Programa de Automatización I para alumnos de séptimo semestre de Ing. Industrial Estadístico, 2019.',1),
/*(7042,'Optativa Profesionalizante I',6,'Programa de Optativa Profesionalizante I para alumnos de séptimo semestre de Ing. Industrial Estadístico, 2019.',1),*/

(7043,'Estrategias Estadísticas Seis Sigma',6,'Programa de Estrategias Estadísticas Seis Sigma para alumnos de octavo semestre de Ing. Industrial Estadístico, 2019.',1),
(7044,'Estadística No Paramétrica',6,'Programa de Estadística No Paramétrica para alumnos de octavo semestre de Ing. Industrial Estadístico, 2019.',1),
(7045,'Simulación Estadística de Sistemas',6,'Programa de Simulación Estadística de Sistemas para alumnos de octavo semestre de Ing. Industrial Estadístico, 2019.',1),
(7046,'Automatización II',14,'Programa de Automatización II para alumnos de octavo semestre de Ing. Industrial Estadístico, 2019.',1),
(7047,'Seminario de Ingeniería de la Calidad',37,'Programa de Seminario de Ingeniería de la Calidad para alumnos de octavo semestre de Ing. Industrial Estadístico, 2019.',1),
(7048,'Manufactura Esbelta',37,'Programa de Manufactura Esbelta para alumnos de octavo semestre de Ing. Industrial Estadístico, 2019.',1),

(7049,'Confiabilidad de Componentes Industriales',6,'Programa de Confiabilidad de Componentes Industriales para alumnos de noveno semestre de Ing. Industrial Estadístico, 2019.',1),
(7050,'Diseño de Sistemas de Manufactura',6,'Programa de Diseño de Sistemas de Manufactura para alumnos de noveno semestre de Ing. Industrial Estadístico, 2019.',1),
(7051,'Administración de Mantenimiento',37,'Programa de Administración de Mantenimiento para alumnos de noveno semestre de Ing. Industrial Estadístico, 2019.',1);
/*(7052,'Optativa Profesionalizante II',6,'Programa de Optativa Profesionalizante II para alumnos de noveno semestre de Ing. Industrial Estadístico, 2019.',1);*/


/*Lic. en Biología*/

/*Plan 2019, Carrera 35*/
/*id(8001-9000), nombre, departamento, descripcion, vigente*/
/*1-43*/

INSERT INTO Materia VALUES 
(8001,'Biología celular',4,'Programa de Biología celular para alumnos de primer semestre de Lic. en Biología, 2019.',1),
(8002,'Diversidad Biológica (BIO-DB1)',4,'Programa de Diversidad Biológica (BIO-DB1) para alumnos de primer semestre de Lic. en Biología, 2019.',1),
(8003,'Desarrollo regional y medio ambiente',51,'Programa de Desarrollo regional y medio ambiente para alumnos de primer semestre de Lic. en Biología, 2019.',1),
(8004,'Elaboración de Protocolos científicos',4,'Programa de Elaboración de Protocolos científicos para alumnos de primer semestre de Lic. en Biología, 2019.',1),
(8005,'Química general (Q-CB3)',12,'Programa de Química general (Q-CB3) para alumnos de primer semestre de Lic. en Biología, 2019.',1),

(8006,'Biología de los Procariontes',4,'Programa de Biología de los Procariontes para alumnos de segundo semestre de Lic. en Biología, 2019.',1),
(8007,'Química orgánica',12,'Programa de Química orgánica para alumnos de segundo semestre de Lic. en Biología, 2019.',1),
(8008,'Fisicoquímica I',8,'Programa de Fisicoquímica I para alumnos de segundo semestre de Lic. en Biología, 2019.',1),
(8009,'Matemáticas básicas',9,'Programa de Matemáticas básicas para alumnos de segundo semestre de Lic. en Biología, 2019.',1),

(8010,'Introducción a la Sistemática',4,'Programa de Introducción a la Sistemática para alumnos de tercer semestre de Lic. en Biología, 2019.',1),
(8011,'Biología tisular',11,'Programa de Biología tisular para alumnos de tercer semestre de Lic. en Biología, 2019.',1),
(8012,'Sistemas de información geográfica',4,'Programa de Sistemas de información geográfica para alumnos de tercer semestre de Lic. en Biología, 2019.',1),
(8013,'Bioquímica I',12,'Programa de Bioquímica I para alumnos de tercer semestre de Lic. en Biología, 2019.',1),

(8014,'Botánica I',4,'Programa de Botánica I para alumnos de cuarto semestre de Lic. en Biología, 2019.',1),
(8015,'Biología de los Protozoarios',4,'Programa de Biología de los Protozoarios para alumnos de cuarto semestre de Lic. en Biología, 2019.',1),
(8016,'Biología molecular para Ciencias Biológicas',12,'Programa de Biología molecular para Ciencias Biológicas para alumnos de cuarto semestre de Lic. en Biología, 2019.',1),
(8017,'Probabilidad y Estadística (EST-C11)',6,'Programa de Probabilidad y Estadística (EST-C11) para alumnos de cuarto semestre de Lic. en Biología, 2019.',1),

(8018,'Botánica II',4,'Programa de Botánica II para alumnos de quinto semestre de Lic. en Biología, 2019.',1),
(8019,'Biología de los hongos',4,'Programa de Biología de los hongos para alumnos de quinto semestre de Lic. en Biología, 2019.',1),
(8020,'Invertebrados I',4,'Programa de Invertebrados I para alumnos de quinto semestre de Lic. en Biología, 2019.',1),
(8021,'Genética',12,'Programa de Genética para alumnos de quinto semestre de Lic. en Biología, 2019.',1),
(8022,'Métodos Estadísticos (EST-C12)',6,'Programa de Métodos Estadísticos (EST-C12) para alumnos de quinto semestre de Lic. en Biología, 2019.',1),


(8023,'Fisiología vegetal',12,'Programa de Fisiología vegetal para alumnos de sexto semestre de Lic. en Biología, 2019.',1),
(8024,'Biología del desarrollo animal',11,'Programa de Biología del desarrollo animal para alumnos de sexto semestre de Lic. en Biología, 2019.',1),
(8025,'Invertebrados II',4,'Programa de Invertebrados II para alumnos de sexto semestre de Lic. en Biología, 2019.',1),
(8026,'Anatomía comparada de los cordados',4,'Programa de Anatomía comparada de los cordados para alumnos de sexto semestre de Lic. en Biología, 2019.',1),
(8027,'Tesina I',4,'Programa de Tesina I para alumnos de sexto semestre de Lic. en Biología, 2019.',1),
(8028,'Informática para Ciencias Naturales',13,'Programa de Informática para Ciencias Naturales para alumnos de sexto semestre de Lic. en Biología, 2019.',1),

(8029,'Taxonomía vegetal',4,'Programa de Taxonomía vegetal para alumnos de séptimo semestre de Lic. en Biología, 2019.',1),
(8030,'Biología de vertebrados',4,'Programa de Biología de vertebrados para alumnos de séptimo semestre de Lic. en Biología, 2019.',1),
(8031,'Tesina II',4,'Programa de Tesina II para alumnos de séptimo semestre de Lic. en Biología, 2019.',1),
(8032,'Fisiología animal',7,'Programa de Fisiología animal para alumnos de séptimo semestre de Lic. en Biología, 2019.',1),
(8033,'Ética Profesional',47,'Programa de Ética Profesional para alumnos de séptimo semestre de Lic. en Biología, 2019.',1),
/*(8034,'Optativa Profesionalizante I',4,'Programa de Optativa Profesionalizante I para alumnos de séptimo semestre de Lic. en Biología, 2019.',1),*/

(8035,'Ecología de poblaciones y comunidades',4,'Programa de Ecología de poblaciones y comunidades para alumnos de octavo semestre de Lic. en Biología, 2019.',1),
(8036,'Biología evolutiva',4,'Programa de Biología evolutiva para alumnos de octavo semestre de Lic. en Biología, 2019.',1),
(8037,'Tesina III',4,'Programa de Tesina III para alumnos de octavo semestre de Lic. en Biología, 2019.',1),
(8038,'Desarrollo de emprendedores',32,'Programa de Desarrollo de emprendedores para alumnos de octavo semestre de Lic. en Biología, 2019.',1),

(8039,'Ecosistemas y manejo de recursos naturales',4,'Programa de Ecosistemas y manejo de recursos naturales para alumnos de noveno semestre de Lic. en Biología, 2019.',1),
(8040,'Filogenética y biología comparativa',4,'Programa de Filogenética y biología comparativa para alumnos de noveno semestre de Lic. en Biología, 2019.',1),
(8041,'Biogeografía y conservación',4,'Programa de Biogeografía y conservación para alumnos de noveno semestre de Lic. en Biología, 2019.',1),
(8042,'Bioproyectos',4,'Programa de Bioproyectos para alumnos de noveno semestre de Lic. en Biología, 2019.',1);
/*(8043,'Optativa Profesionalizante II',4,'Programa de Optativa Profesionalizante II para alumnos de noveno semestre de Lic. en Biología, 2019.',1);*/


/*Lic. en Biotecnología*/

/*Plan 2017, Carrera 81*/
/*id(9001-10000), nombre, departamento, descripcion, vigente*/
/*1-44*/

INSERT INTO Materia VALUES 
(9001,'Fundamentos de Biotecnología',12,'Programa de Fundamentos de Biotecnología para alumnos de primero semestre de Lic. en Biotecnología, 2017.',1),
(9002,'Química General (Q-CB1)',12,'Programa de Química General (Q-CB1) para alumnos de primero semestre de Lic. en Biotecnología, 2017.',1),
(9003,'Cálculo Diferencial (CD-A2)',9,'Programa de Cálculo Diferencial (CD-A2) para alumnos de primero semestre de Lic. en Biotecnología, 2017.',1),
(9004,'Biología Celular',4,'Programa de Biología Celular para alumnos de primero semestre de Lic. en Biotecnología, 2017.',1),
(9005,'Herramientas de Software para Biotecnología',5,'Programa de Herramientas de Software para Biotecnología para alumnos de primero semestre de Lic. en Biotecnología, 2017.',1),

(9006,'Química Orgánica (Q-CB1)',12,'Programa de Química Orgánica (Q-CB1) para alumnos de segundo semestre de Lic. en Biotecnología, 2017.',1),
(9007,'Diversidad Biológica',4,'Programa de Diversidad Biológica para alumnos de segundo semestre de Lic. en Biotecnología, 2017.',1),
(9008,'Probabilidad y Estadística (EST-C11)',6,'Programa de Probabilidad y Estadística (EST-C11) para alumnos de segundo semestre de Lic. en Biotecnología, 2017.',1),
(9009,'Cálculo Integral (CI-A2)',9,'Programa de Cálculo Integral (CI-A2) para alumnos de segundo semestre de Lic. en Biotecnología, 2017.',1),

(9010,'Fundamentos Teóricos de los Métodos Analíticos',12,'Programa de Fundamentos Teóricos de los Métodos Analíticos para alumnos de tercero semestre de Lic. en Biotecnología, 2017.',1),
(9011,'Bioquímica I (Q-CB2)',12,'Programa de Bioquímica I (Q-CB2) para alumnos de tercero semestre de Lic. en Biotecnología, 2017.',1),
(9012,'Métodos Estadísticos (EST-C12)',6,'Programa de Métodos Estadísticos (EST-C12) para alumnos de tercero semestre de Lic. en Biotecnología, 2017.',1),
(9013,'Fisicoquímica I',8,'Programa de Fisicoquímica I para alumnos de tercero semestre de Lic. en Biotecnología, 2017.',1),

(9014,'Genética',12,'Programa de Genética para alumnos de cuarto semestre de Lic. en Biotecnología, 2017.',1),
(9015,'Bioquímica II (Q-CB2)',12,'Programa de Bioquímica II (Q-CB2) para alumnos de cuarto semestre de Lic. en Biotecnología, 2017.',1),
(9016,'Biología Molecular',12,'Programa de Biología Molecular para alumnos de cuarto semestre de Lic. en Biotecnología, 2017.',1),
(9017,'Fisicoquímica II',8,'Programa de Fisicoquímica II para alumnos de cuarto semestre de Lic. en Biotecnología, 2017.',1),
(9018,'Ética Profesional',47,'Programa de Ética Profesional para alumnos de cuarto semestre de Lic. en Biotecnología, 2017.',1),

(9019,'Fitoquímica',12,'Programa de Fitoquímica para alumnos de quinto semestre de Lic. en Biotecnología, 2017.',1),
(9020,'Ingeniería Genética I',12,'Programa de Ingeniería Genética I para alumnos de quinto semestre de Lic. en Biotecnología, 2017.',1),
(9021,'Ingeniería Aplicada a los Procesos Biotecnológicos',8,'Programa de Ingeniería Aplicada a los Procesos Biotecnológicos para alumnos de quinto semestre de Lic. en Biotecnología, 2017.',1),
(9022,'Microbiología (I-CB1)',10,'Programa de Microbiología (I-CB1) para alumnos de quinto semestre de Lic. en Biotecnología, 2017.',1),
(9023,'Inmunología (I-CB1)',10,'Programa de Inmunología (I-CB1) para alumnos de quinto semestre de Lic. en Biotecnología, 2017.',1),

(9024,'Ingeniería Genética II',12,'Programa de Ingeniería Genética II para alumnos de sexto semestre de Lic. en Biotecnología, 2017.',1),
(9025,'Fisiología Vegetal',12,'Programa de Fisiología Vegetal para alumnos de sexto semestre de Lic. en Biotecnología, 2017.',1),
(9026,'Biotecnología Microbiana',8,'Programa de Biotecnología Microbiana para alumnos de sexto semestre de Lic. en Biotecnología, 2017.',1),
(9027,'Separación y Purifiacción de Productos Biotecnológicos',8,'Programa de Separación y Purifiacción de Productos Biotecnológicos para alumnos de sexto semestre de Lic. en Biotecnología, 2017.',1),
(9028,'Fisiología Animal',7,'Programa de Fisiología Animal para alumnos de sexto semestre de Lic. en Biotecnología, 2017.',1),

(9029,'Diagnóstico Molecular',12,'Programa de Diagnóstico Molecular para alumnos de séptimo semestre de Lic. en Biotecnología, 2017.',1),
(9030,'Biotecnología Vegetal',12,'Programa de Biotecnología Vegetal para alumnos de séptimo semestre de Lic. en Biotecnología, 2017.',1),
(9031,'Biotecnología Animal',12,'Programa de Biotecnología Animal para alumnos de séptimo semestre de Lic. en Biotecnología, 2017.',1),
(9032,'Proyecto Biotecnológico I',12,'Programa de Proyecto Biotecnológico I para alumnos de séptimo semestre de Lic. en Biotecnología, 2017.',1),
(9033,'Bioquímica de los Alimentos',8,'Programa de Bioquímica de los Alimentos para alumnos de séptimo semestre de Lic. en Biotecnología, 2017.',1),
(9034,'Toxicología Ambiental',7,'Programa de Toxicología Ambiental para alumnos de séptimo semestre de Lic. en Biotecnología, 2017.',1),

(9035,'Bioinformática',12,'Programa de Bioinformática para alumnos de octavo semestre de Lic. en Biotecnología, 2017.',1),
(9036,'Proyecto Biotecnológico II',12,'Programa de Proyecto Biotecnológico II para alumnos de octavo semestre de Lic. en Biotecnología, 2017.',1),
(9037,'Biotecnología Ambiental',8,'Programa de Biotecnología Ambiental para alumnos de octavo semestre de Lic. en Biotecnología, 2017.',1),
(9038,'Biotecnología de Alimentos',8,'Programa de Biotecnología de Alimentos para alumnos de octavo semestre de Lic. en Biotecnología, 2017.',1),
/*(9039,'Optativa Profesionalizante I',12,'Programa de Optativa Profesionalizante I para alumnos de octavo semestre de Lic. en Biotecnología, 2017.',1),*/

(9040,'Proyecto Biotecnológico III',12,'Programa de Proyecto Biotecnológico III para alumnos de noveno semestre de Lic. en Biotecnología, 2017.',1),
(9041,'Impacto Ambiental',4,'Programa de Impacto Ambiental para alumnos de noveno semestre de Lic. en Biotecnología, 2017.',1),
(9042,'Desarrollo de Emprendedores',32,'Programa de Desarrollo de Emprendedores para alumnos de noveno semestre de Lic. en Biotecnología, 2017.',1),
(9043,'Normatividad en Biotecnología',45,'Programa de Normatividad en Biotecnología para alumnos de noveno semestre de Lic. en Biotecnología, 2017.',1);
/*(9044,'Optativa Profesionalizante II',12,'Programa de Optativa Profesionalizante II para alumnos de noveno semestre de Lic. en Biotecnología, 2017.',1)*/


/*Lic. en Informática y Tecnologías Computacionales*/

/*Plan 2021, Carrera 88*/
/*id(10001-11000), nombre, departamento, descripcion, vigente*/
/*1-53*/

INSERT INTO Materia VALUES 
(10001,'Sistemas de Información en la Empresa',13,'Programa de Sistemas de Información en la Empresa para alumnos de primero semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10002,'Contabilidad Básica',33,'Programa de Contabilidad Básica para alumnos de primero semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10003,'Competencias Comunicativas',44,'Programa de Competencias Comunicativas para alumnos de primero semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10004,'Desarrollo del Pensamiento Matemático',9,'Programa de Desarrollo del Pensamiento Matemático para alumnos de primero semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10005,'Lógica de Programación',13,'Programa de Lógica de Programación para alumnos de primero semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),

(10006,'Administración de Recursos Humanos',37,'Programa de Administración de Recursos Humanos para alumnos de segundo semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10007,'Costos y Presupuestos',33,'Programa de Costos y Presupuestos para alumnos de segundo semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10008,'Taller de Redacción',55,'Programa de Taller de Redacción para alumnos de segundo semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10009,'Cálculo Diferencial e Integral (CDI-A2)',9,'Programa de Cálculo Diferencial e Integral (CDI-A2) para alumnos de segundo semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10010,'Programación Estructurada',13,'Programa de Programación Estructurada para alumnos de segundo semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10011,'Arquitectura Básica de Computadoras',14,'Programa de Arquitectura Básica de Computadoras para alumnos de segundo semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),

(10012,'Mezcla Promocional',36,'Programa de Mezcla Promocional para alumnos de tercer semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10013,'Proyectos de Inversión Privada',35,'Programa de Proyectos de Inversión Privada para alumnos de tercer semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10014,'Economía General',34,'Programa de Economía General para alumnos de tercer semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10015,'Probabilidad y Estadística (EST-B21)',6,'Programa de Probabilidad y Estadística (EST-B21) para alumnos de tercer semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10016,'Estructura de Datos',5,'Programa de Estructura de Datos para alumnos de tercer semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10017,'Programación Orientada a Objetos',13,'Programa de Programación Orientada a Objetos para alumnos de tercer semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),

(10018,'Métodos Estadísticos (EST-B22)',6,'Programa de Métodos Estadísticos (EST-B22) para alumnos de cuarto semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10019,'Base de Datos SQL',13,'Programa de Base de Datos SQL para alumnos de cuarto semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10020,'Algoritmia Computacional',13,'Programa de Algoritmia Computacional para alumnos de cuarto semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10021,'Programación Visual (C#)',13,'Programa de Programación Visual (C#) para alumnos de cuarto semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10022,'Modelado de Requerimientos',13,'Programa de Modelado de Requerimientos para alumnos de cuarto semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10023,'Sistemas Operativos',14,'Programa de Sistemas Operativos para alumnos de cuarto semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),

(10024,'SQL y PL / SQL',13,'Programa de SQL y PL / SQL para alumnos de quinto semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10025,'Programación Java',13,'Programa de Programación Java para alumnos de quinto semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10026,'Diseño de Software',13,'Programa de Diseño de Software para alumnos de quinto semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10027,'Redes de Tecnologías Informáticas',14,'Programa de Redes de Tecnologías Informáticas para alumnos de quinto semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10028,'Proyectos Tecnológicos',13,'Programa de Proyectos Tecnológicos para alumnos de quinto semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10029,'Derecho Informático',45,'Programa de Derecho Informático para alumnos de quinto semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),

(10030,'Desarrollo Web',13,'Programa de Desarrollo Web para alumnos de sexto semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10031,'Administración de la Calidad del Software',13,'Programa de Administración de la Calidad del Software para alumnos de sexto semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10032,'Seguridad Integral de Tecnologías Informáticas',14,'Programa de Seguridad Integral de Tecnologías Informáticas para alumnos de sexto semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10033,'Gestión de la Función Informática',13,'Programa de Gestión de la Función Informática para alumnos de sexto semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10034,'Ética Profesional',47,'Programa de Ética Profesional para alumnos de sexto semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10035,'Administración de Base de Datos',13,'Programa de Administración de Base de Datos para alumnos de sexto semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),

(10036,'Lenguajes de Programación Emergente',13,'Programa de Lenguajes de Programación Emergente para alumnos de séptimo semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10037,'Métodos de Desarrollo Ágil',13,'Programa de Métodos de Desarrollo Ágil para alumnos de séptimo semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10038,'Modelos de Soluciones Tecnológicas',13,'Programa de Modelos de Soluciones Tecnológicas para alumnos de séptimo semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10039,'Base de Datos no SQL',13,'Programa de Base de Datos no SQL para alumnos de séptimo semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10040,'Operación de Centros de Tecnologías Informáticas',13,'Programa de Operación de Centros de Tecnologías Informáticas para alumnos de séptimo semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
/*(10041,'Optativa Profesionalizante I',13,'Programa de Optativa Profesionalizante I para alumnos de séptimo semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),*/

(10042,'Portafolio de Proyectos Informáticos',13,'Programa de Portafolio de Proyectos Informáticos para alumnos de octavo semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10043,'Sistemas de Simulación',13,'Programa de Sistemas de Simulación para alumnos de octavo semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10044,'Tratamiento Avanzado de Datos',5,'Programa de Tratamiento Avanzado de Datos para alumnos de octavo semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10045,'Gestión Sustentable de Servicios de TICs',13,'Programa de Gestión Sustentable de Servicios de TICs para alumnos de octavo semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10046,'Desarrollo Móvil',13,'Programa de Desarrollo Móvil para alumnos de octavo semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10047,'Implantación y Mantenimiento de Sistemas',13,'Programa de Implantación y Mantenimiento de Sistemas para alumnos de octavo semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),

(10048,'Seminario de Investigación Informática',13,'Programa de Seminario de Investigación Informática para alumnos de noveno semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10049,'Desarrollo de Emprendedores',32,'Programa de Desarrollo de Emprendedores para alumnos de noveno semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10050,'Teoría de Técnicas Modernas en Informática',13,'Programa de Teoría de Técnicas Modernas en Informática para alumnos de noveno semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10051,'ecnologías Informáticas en la Nube',14,'Programa de ecnologías Informáticas en la Nube para alumnos de noveno semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1),
(10052,'Auditoría Informática',13,'Programa de Auditoría Informática para alumnos de noveno semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1);
/*(10053,'Optativa Profesionalizante II',13,'Programa de Optativa Profesionalizante II para alumnos de noveno semestre de Lic. en Informática y Tecnologías Computacionales, 2021.',1);*/


/*Lic. en Matemáticas Aplicadas*/

/*Plan 2015, Carrera 62*/
/*id(11001-12000), nombre, departamento, descripcion, vigente*/
/*1-47*/

INSERT INTO Materia VALUES 
(11001,'Lógica Matemática y Teoría de Conjuntos',9,'Programa de Lógica Matemática y Teoría de Conjuntos para alumnos de primer semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11002,'Sistemas Algebraicos y Ecuaciones Polinomiales',9,'Programa de Sistemas Algebraicos y Ecuaciones Polinomiales para alumnos de primer semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11003,'Geometría Analítica Vectorial',9,'Programa de Geometría Analítica Vectorial para alumnos de primer semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11004,'Lenguaje de Computación I',5,'Programa de Lenguaje de Computación I para alumnos de primer semestre de Lic. en Matemáticas Aplicadas, 2015.',1),

(11005,'Teoría de Matrices y Espacios Vectoriales',9,'Programa de Teoría de Matrices y Espacios Vectoriales para alumnos de segundo semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11006,'Cálculo Diferencial',9,'Programa de Cálculo Diferencial para alumnos de segundo semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11007,'Lenguaje de Computación II',5,'Programa de Lenguaje de Computación II para alumnos de segundo semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11008,'Matemáticas Financieras',9,'Programa de Matemáticas Financieras para alumnos de segundo semestre de Lic. en Matemáticas Aplicadas, 2015.',1),

(11009,'Teoría de Operadores Lineales y Formas Canónicas',9,'Programa de Teoría de Operadores Lineales y Formas Canónicas para alumnos de tercer semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11010,'Cálculo Integral',9,'Programa de Cálculo Integral para alumnos de tercer semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11011,'Análisis Numérico I',9,'Programa de Análisis Numérico I para alumnos de tercer semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11012,'Matemáticas Discretas',9,'Programa de Matemáticas Discretas para alumnos de tercer semestre de Lic. en Matemáticas Aplicadas, 2015.',1),


(11013,'Cálculo Diferencial Vectorial',9,'Programa de Cálculo Diferencial Vectorial para alumnos de cuarto semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11014,'Probabilidad',6,'Programa de Probabilidad para alumnos de cuarto semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11015,'Ecuaciones Diferenciales Ordinarias y Modelación',9,'Programa de Ecuaciones Diferenciales Ordinarias y Modelación para alumnos de cuarto semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11016,'Investigación de Operaciones I',9,'Programa de Investigación de Operaciones I para alumnos de cuarto semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11017,'Teoría de Juegos',9,'Programa de Teoría de Juegos para alumnos de cuarto semestre de Lic. en Matemáticas Aplicadas, 2015.',1),

(11018,'Cálculo Integral Vectorial',9,'Programa de Cálculo Integral Vectorial para alumnos de quinto semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11019,'Metaheurística I',5,'Programa de Metaheurística I para alumnos de quinto semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11020,'Investigación de Operaciones II',9,'Programa de Investigación de Operaciones II para alumnos de quinto semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11021,'Inferencia Estadística',6,'Programa de Inferencia Estadística para alumnos de quinto semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11022,'Mecánica',9,'Programa de Mecánica para alumnos de quinto semestre de Lic. en Matemáticas Aplicadas, 2015.',1),

(11023,'Análisis Matemático',9,'Programa de Análisis Matemático para alumnos de sexto semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11024,'Metaheurística II',5,'Programa de Metaheurística II para alumnos de sexto semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11025,'Investigación de Operaciones III',9,'Programa de Investigación de Operaciones III para alumnos de sexto semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11026,'Muestreo',6,'Programa de Muestreo para alumnos de sexto semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11027,'Calor Ondas y Fluidos',9,'Programa de Calor Ondas y Fluidos para alumnos de sexto semestre de Lic. en Matemáticas Aplicadas, 2015.',1),

(11028,'Teoría de Integración',9,'Programa de Teoría de Integración para alumnos de séptimo semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11029,'Sistemas Dinámicos',9,'Programa de Sistemas Dinámicos para alumnos de séptimo semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11030,'Análisis de Regresión',9,'Programa de Análisis de Regresión para alumnos de séptimo semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11031,'Electriciadad y Magnetismo',9,'Programa de Electriciadad y Magnetismo para alumnos de séptimo semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11032,'Ética Profesional',47,'Programa de Ética Profesional para alumnos de séptimo semestre de Lic. en Matemáticas Aplicadas, 2015.',1),

(11033,'Variable Compleja I',9,'Programa de Variable Compleja I para alumnos de octavo semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11034,'Análisis Numérico II',9,'Programa de Análisis Numérico II para alumnos de octavo semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11035,'Diseño y Análisis de Experimentos',6,'Programa de Diseño y Análisis de Experimentos para alumnos de octavo semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11036,'Óptica',9,'Programa de Óptica para alumnos de octavo semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11037,'Filosofía de la Investigación Científica',47,'Programa de Filosofía de la Investigación Científica para alumnos de octavo semestre de Lic. en Matemáticas Aplicadas, 2015.',1),

(11038,'Variable Compleja II',9,'Programa de Variable Compleja II para alumnos de noveno semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11039,'Álgebra Abstracta',9,'Programa de Álgebra Abstracta para alumnos de noveno semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11040,'Control Estadístico de Calidad',6,'Programa de Control Estadístico de Calidad para alumnos de noveno semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11041,'Modelos de Enseñanza',46,'Programa de Modelos de Enseñanza para alumnos de noveno semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
/*(11042,'Optativa Profesionalizante I',9,'Programa de Optativa Profesionalizante I para alumnos de noveno semestre de Lic. en Matemáticas Aplicadas, 2015.',1),*/

(11043,'Metodologías de la Investigación en Matemáticas',9,'Programa de Metodologías de la Investigación en Matemáticas para alumnos de décimo semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11044,'Simulación',9,'Programa de Simulación para alumnos de décimo semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11045,'Didáctica y Habilidades Docentes',46,'Programa de Didáctica y Habilidades Docentes para alumnos de décimo semestre de Lic. en Matemáticas Aplicadas, 2015.',1),
(11046,'Ecuaciones Diferenciales Parciales',9,'Programa de Ecuaciones Diferenciales Parciales para alumnos de décimo semestre de Lic. en Matemáticas Aplicadas, 2015.',1);
/*(11047,'Optativa Profesionalizante II',9,'Programa de Optativa Profesionalizante II para alumnos de décimo semestre de Lic. en Matemáticas Aplicadas, 2015.',1);*/


/*Químico Farmacéutico Biólogo*/

/*Plan 2017, Carrera 64*/
/*id(12001-13000), nombre, departamento, descripcion, vigente*/
/*1-49*/

INSERT INTO Materia VALUES 
(12001,'Cálculo Diferencial (CD-A2)',9,'Programa de Cálculo Diferencial (CD-A2) para alumnos de primer semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12002,'Química general I',12,'Programa de Química general I para alumnos de primer semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12003,'Química y sociedad',12,'Programa de Química y sociedad para alumnos de primer semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12004,'Química orgánica I',12,'Programa de Química orgánica I para alumnos de primer semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12005,'Morfología Humana',11,'Programa de Morfología Humana para alumnos de primer semestre de Químico Farmacéutico Biólogo, 2017.',1),

(12006,'Cálculo Integral (CI-A2)',9,'Programa de Cálculo Integral (CI-A2) para alumnos de segundo semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12007,'Mecánica (M-A2)',9,'Programa de Mecánica (M-A2) para alumnos de segundo semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12008,'Química general II',12,'Programa de Química general II para alumnos de segundo semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12009,'Química orgánica II',12,'Programa de Química orgánica II para alumnos de segundo semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12010,'Biología',4,'Programa de Biología para alumnos de segundo semestre de Químico Farmacéutico Biólogo, 2017.',1),

(12011,'Ecuaciones Diferenciales (ED-A2)',9,'Programa de Ecuaciones Diferenciales (ED-A2) para alumnos de tercer semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12012,'Fundamentos de óptica',9,'Programa de Fundamentos de óptica para alumnos de tercer semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12013,'Química analítica I',12,'Programa de Química analítica I para alumnos de tercer semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12014,'Química orgánica III',12,'Programa de Química orgánica III para alumnos de tercer semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12015,'Estructura de la materia y función molecular',12,'Programa de Estructura de la materia y función molecular para alumnos de tercer semestre de Químico Farmacéutico Biólogo, 2017.',1),

(12016,'Probabilidad y Estadística (EST-C11)',6,'Programa de Probabilidad y Estadística (EST-C11) para alumnos de cuarto semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12017,'Química analítica II',12,'Programa de Química analítica II para alumnos de cuarto semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12018,'Bioquímica (Q-CB1)',12,'Programa de Bioquímica (Q-CB1) para alumnos de cuarto semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12019,'Análisis Instrumental de fármacos',12,'Programa de Análisis Instrumental de fármacos para alumnos de cuarto semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12020,'Ética Profesional',47,'Programa de Ética Profesional para alumnos de cuarto semestre de Químico Farmacéutico Biólogo, 2017.',1),

(12021,'Métodos Estadísticos (EST-C12)',6,'Programa de Métodos Estadísticos (EST-C12) para alumnos de quinto semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12022,'Termodinámica (QFB)',8,'Programa de Termodinámica (QFB) para alumnos de quinto semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12023,'Bioquímica clínica',12,'Programa de Bioquímica clínica para alumnos de quinto semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12024,'Inmunología general',10,'Programa de Inmunología general para alumnos de quinto semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12025,'Bacteriología y Virología (BV-CB1)',10,'Programa de Bacteriología y Virología (BV-CB1) para alumnos de quinto semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12026,'Normativa y gestión de la calidad',37,'Programa de Normativa y gestión de la calidad para alumnos de quinto semestre de Químico Farmacéutico Biólogo, 2017.',1),

(12027,'Biología molecular para ciencias biológicas',12,'Programa de Biología molecular para ciencias biológicas para alumnos de sexto semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12028,'Parasitología y micología (PM-CB1)',10,'Programa de Parasitología y micología (PM-CB1) para alumnos de sexto semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12029,'Fisiología general',7,'Programa de Fisiología general para alumnos de sexto semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12030,'Farmacología general',7,'Programa de Farmacología general para alumnos de sexto semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12031,'Análisis Instrumental Avanzado',12,'Programa de Análisis Instrumental Avanzado para alumnos de sexto semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12032,'Química y marco jurídico',45,'Programa de Química y marco jurídico para alumnos de sexto semestre de Químico Farmacéutico Biólogo, 2017.',1),

(12033,'Química clínica I',12,'Programa de Química clínica I para alumnos de séptimo semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12034,'Hematología y banco de sangre',12,'Programa de Hematología y banco de sangre para alumnos de séptimo semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12035,'Inmunología molecular',10,'Programa de Inmunología molecular para alumnos de séptimo semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12036,'Toxicología',7,'Programa de Toxicología para alumnos de séptimo semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12037,'Química farmacéutica',12,'Programa de Química farmacéutica para alumnos de séptimo semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12038,'Desarrollo de emprendedores',32,'Programa de Desarrollo de emprendedores para alumnos de séptimo semestre de Químico Farmacéutico Biólogo, 2017.',1),

(12039,'Química clínica II',12,'Programa de Química clínica II para alumnos de octavo semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12040,'Elaboración de formulaciones farmacéuticas',12,'Programa de Elaboración de formulaciones farmacéuticas para alumnos de octavo semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12041,'Atención farmacéutica',12,'Programa de Atención farmacéutica para alumnos de octavo semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12042,'Farmacognosia y farmacoterapia',12,'Programa de Farmacognosia y farmacoterapia para alumnos de octavo semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12043,'Taller de Investigación I',12,'Programa de Taller de Investigación I para alumnos de octavo semestre de Químico Farmacéutico Biólogo, 2017.',1),
/*(12044,'Optativa profesionalizante I',12,'Programa de Optativa profesionalizante I para alumnos de octavo semestre de Químico Farmacéutico Biólogo, 2017.',1),*/

(12045,'Química clínica aplicada',12,'Programa de Química clínica aplicada para alumnos de noveno semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12046,'Farmacovigilancia y tecnovigilancia',12,'Programa de Farmacovigilancia y tecnovigilancia para alumnos de noveno semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12047,'Taller de Investigación II',12,'Programa de Taller de Investigación II para alumnos de noveno semestre de Químico Farmacéutico Biólogo, 2017.',1);
/*(12048,'Optativa profesionalizante II',12,'Programa de Optativa profesionalizante II para alumnos de noveno semestre de Químico Farmacéutico Biólogo, 2017.',1),
(12049,'Optativa profesionalizante III',12,'Programa de Optativa profesionalizante III para alumnos de noveno semestre de Químico Farmacéutico Biólogo, 2017.',1);*/



/*----------------------------------------Centro de las Artes y la Cultura----------------------------------------*/
/*Lic. en Actuación*/

/*Plan 2020, Carrera 94*/
/*id(58001-59000), nombre, departamento, descripcion, vigente*/
/*1-61*/

INSERT INTO Materia VALUES 
(58001,'El actor y su trabajo expresivo',54,'Programa de El actor y su trabajo expresivo para alumnos de primer semestre de Lic. en Actuación, 2020.',1),
(58002,'Recursos y habilidades vocales',54,'Programa de Recursos y habilidades vocales para alumnos de primer semestre de Lic. en Actuación, 2020.',1),
(58003,'Acondicionamiento físico para el actor',54,'Programa de Acondicionamiento físico para el actor para alumnos de primer semestre de Lic. en Actuación, 2020.',1),
(58004,'Esquema corporal, percepción y acción expresiva',54,'Programa de Esquema corporal, percepción y acción expresiva para alumnos de primer semestre de Lic. en Actuación, 2020.',1),
(58005,'Teatro y sociedad',54,'Programa de Teatro y sociedad para alumnos de primer semestre de Lic. en Actuación, 2020.',1),
(58006,'Historia del arte y la cultura I',48,'Programa de Historia del arte y la cultura I para alumnos de primer semestre de Lic. en Actuación, 2020.',1),
(58007,'Contexto social de México y el mundo',51,'Programa de Contexto social de México y el mundo para alumnos de primer semestre de Lic. en Actuación, 2020.',1),

(58008,'Creación de la ficción',54,'Programa de Creación de la ficción para alumnos de segundo semestre de Lic. en Actuación, 2020.',1),
(58009,'Recursos y habilidades vocales del actor',54,'Programa de Recursos y habilidades vocales del actor para alumnos de segundo semestre de Lic. en Actuación, 2020.',1),
(58010,'Danza clásica I',54,'Programa de Danza clásica I para alumnos de segundo semestre de Lic. en Actuación, 2020.',1),
(58011,'Movimiento de expresión dramática',54,'Programa de Movimiento de expresión dramática para alumnos de segundo semestre de Lic. en Actuación, 2020.',1),
(58012,'Teatro Grecolatino',54,'Programa de Teatro Grecolatino para alumnos de segundo semestre de Lic. en Actuación, 2020.',1),
(58013,'Apreciación de la actuación en cine',54,'Programa de Apreciación de la actuación en cine para alumnos de segundo semestre de Lic. en Actuación, 2020.',1),
(58014,'Historia del arte y la cultura II',48,'Programa de Historia del arte y la cultura II para alumnos de segundo semestre de Lic. en Actuación, 2020.',1),
(58015,'Redacción para las artes escénicas',55,'Programa de Redacción para las artes escénicas para alumnos de segundo semestre de Lic. en Actuación, 2020.',1),

(58016,'Introducción a la creación de personaje',54,'Programa de Introducción a la creación de personaje para alumnos de tercer semestre de Lic. en Actuación, 2020.',1),
(58017,'La voz para la escena',54,'Programa de La voz para la escena para alumnos de tercer semestre de Lic. en Actuación, 2020.',1),
(58018,'Danza clásica II',54,'Programa de Danza clásica II para alumnos de tercer semestre de Lic. en Actuación, 2020.',1),
(58019,'Movimiento escénico',54,'Programa de Movimiento escénico para alumnos de tercer semestre de Lic. en Actuación, 2020.',1),
(58020,'Teatro Isabelino y siglo de oro',54,'Programa de Teatro Isabelino y siglo de oro para alumnos de tercer semestre de Lic. en Actuación, 2020.',1),
(58021,'Teoría dramática I',54,'Programa de Teoría dramática I para alumnos de tercer semestre de Lic. en Actuación, 2020.',1),
(58022,'Marco jurídico de la cultura y el arte',45,'Programa de Marco jurídico de la cultura y el arte para alumnos de tercer semestre de Lic. en Actuación, 2020.',1),
(58023,'Filosofía del arte',47,'Programa de Filosofía del arte para alumnos de tercer semestre de Lic. en Actuación, 2020.',1),

(58024,'Creación de personaje',54,'Programa de Creación de personaje para alumnos de cuarto semestre de Lic. en Actuación, 2020.',1),
(58025,'La voz del personaje',54,'Programa de La voz del personaje para alumnos de cuarto semestre de Lic. en Actuación, 2020.',1),
(58026,'Danza contemporánea',54,'Programa de Danza contemporánea para alumnos de cuarto semestre de Lic. en Actuación, 2020.',1),
(58027,'Acrobacia en piso',54,'Programa de Acrobacia en piso para alumnos de cuarto semestre de Lic. en Actuación, 2020.',1),
(58028,'Teatro novohispano, neoclasicismo y romanticismo',54,'Programa de Teatro novohispano, neoclasicismo y romanticismo para alumnos de cuarto semestre de Lic. en Actuación, 2020.',1),
(58029,'Teoría dramática II',54,'Programa de Teoría dramática II para alumnos de cuarto semestre de Lic. en Actuación, 2020.',1),
(58030,'Desarrollo de emprendedores',32,'Programa de Desarrollo de emprendedores para alumnos de cuarto semestre de Lic. en Actuación, 2020.',1),
(58031,'Pedagogía y didáctica',46,'Programa de Pedagogía y didáctica para alumnos de cuarto semestre de Lic. en Actuación, 2020.',1),

(58032,'Creación de personaje realista',54,'Programa de Creación de personaje realista para alumnos de quinto semestre de Lic. en Actuación, 2020.',1),
(58033,'Herramientas psicológicas para la creación del personaje',50,'Programa de Herramientas psicológicas para la creación del personaje para alumnos de quinto semestre de Lic. en Actuación, 2020.',1),
(58034,'Acrobacia aérea',54,'Programa de Acrobacia aérea para alumnos de quinto semestre de Lic. en Actuación, 2020.',1),
(58035,'Teatro moderno y contemporáneo',54,'Programa de Teatro moderno y contemporáneo para alumnos de quinto semestre de Lic. en Actuación, 2020.',1),
(58036,'Taller de dramaturgia',54,'Programa de Taller de dramaturgia para alumnos de quinto semestre de Lic. en Actuación, 2020.',1),
(58037,'Apreciación musical',54,'Programa de Apreciación musical para alumnos de quinto semestre de Lic. en Actuación, 2020.',1),
(58038,'Introducción a la dirección escénica',54,'Programa de Introducción a la dirección escénica para alumnos de quinto semestre de Lic. en Actuación, 2020.',1),
(58039,'Diseño e implementación de programas',46,'Programa de Diseño e implementación de programas para alumnos de quinto semestre de Lic. en Actuación, 2020.',1),

(58040,'Creación de personaje no realista',54,'Programa de Creación de personaje no realista para alumnos de sexto semestre de Lic. en Actuación, 2020.',1),
(58041,'Herramientas y recursos del actor',54,'Programa de Herramientas y recursos del actor para alumnos de sexto semestre de Lic. en Actuación, 2020.',1),
(58042,'Iniciación al canto',56,'Programa de Iniciación al canto para alumnos de sexto semestre de Lic. en Actuación, 2020.',1),
(58043,'Combate escénico',54,'Programa de Combate escénico para alumnos de sexto semestre de Lic. en Actuación, 2020.',1),
(58044,'Teatro Mexicano',54,'Programa de Teatro Mexicano para alumnos de sexto semestre de Lic. en Actuación, 2020.',1),
(58045,'Introducción a la producción escénica',54,'Programa de Introducción a la producción escénica para alumnos de sexto semestre de Lic. en Actuación, 2020.',1),
(58046,'Dirección escénica',54,'Programa de Dirección escénica para alumnos de sexto semestre de Lic. en Actuación, 2020.',1),
(58047,'Didáctica del teatro',54,'Programa de Didáctica del teatro para alumnos de sexto semestre de Lic. en Actuación, 2020.',1),
/*(58048,'Optativa Profesionalizante I',9,'Programa de Optativa Profesionalizante I para alumnos de sexto semestre de Lic. en Actuación, 2020.',1),*/

(58049,'Laboratorio de puesta en escena final',54,'Programa de Laboratorio de puesta en escena final para alumnos de séptimo semestre de Lic. en Actuación, 2020.',1),
(58050,'Introducción a la actuación frente a cámaras',54,'Programa de Introducción a la actuación frente a cámaras para alumnos de séptimo semestre de Lic. en Actuación, 2020.',1),
(58051,'Canto',56,'Programa de Canto para alumnos de séptimo semestre de Lic. en Actuación, 2020.',1),
(58052,'Mantenimiento y entrenamiento del actor',54,'Programa de Mantenimiento y entrenamiento del actor para alumnos de séptimo semestre de Lic. en Actuación, 2020.',1),
(58053,'Nuevas dramaturgias y teatralidades',54,'Programa de Nuevas dramaturgias y teatralidades para alumnos de séptimo semestre de Lic. en Actuación, 2020.',1),
(58054,'Ética Profesional',47,'Programa de Ética Profesional para alumnos de séptimo semestre de Lic. en Actuación, 2020.',1),
(58055,'Producción escénica para la puesta en escena final',54,'Programa de Producción escénica para la puesta en escena final para alumnos de séptimo semestre de Lic. en Actuación, 2020.',1),
(58056,'Práctica de la docencia del teatro',54,'Programa de Práctica de la docencia del teatro para alumnos de séptimo semestre de Lic. en Actuación, 2020.',1),

(58057,'Puesta en escena final',54,'Programa de Puesta en escena final para alumnos de octavo semestre de Lic. en Actuación, 2020.',1),
(58058,'Producción ejecutiva',54,'Programa de Producción ejecutiva para alumnos de octavo semestre de Lic. en Actuación, 2020.',1),
(58059,'Análisis del espectáculo',54,'Programa de Análisis del espectáculo para alumnos de octavo semestre de Lic. en Actuación, 2020.',1),
(58060,'Actuación frente a cámaras',54,'Programa de Actuación frente a cámaras para alumnos de octavo semestre de Lic. en Actuación, 2020.',1);
/*(58061,'Optativa Profesionalizante II',0,'Programa de Optativa Profesionalizante II para alumnos de octavo semestre de Lic. en Actuación, 2020.',1);*/


/*Lic. en Artes Cinematográficas y Audiovisuales*/

/*Plan 2020, Carrera 12*/
/*id(59001-60000), nombre, departamento, descripcion, vigente*/
/*1-51*/

INSERT INTO Materia VALUES 
(59001,'Inicios del Cine mundial',54,'Programa de Inicios del Cine mundial para alumnos de primer semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59002,'Preámbulos socioculturales de la Cinematografía',51,'Programa de Preámbulos socioculturales de la Cinematografía para alumnos de primer semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59003,'Contexto histórico para el discurso cinematográfico',48,'Programa de Contexto histórico para el discurso cinematográfico para alumnos de primer semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59004,'Apreciación de Arte, Imagen y Sonido',53,'Programa de Apreciación de Arte, Imagen y Sonido para alumnos de primer semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59005,'Fotografía fija: set y estudio',44,'Programa de Fotografía fija: set y estudio para alumnos de primer semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59006,'Géneros literarios narrativos',55,'Programa de Géneros literarios narrativos para alumnos de primer semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),

(59007,'Lenguaje cinematográfico',54,'Programa de Lenguaje cinematográfico para alumnos de segundo semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59008,'Diseño de producción',54,'Programa de Diseño de producción para alumnos de segundo semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59009,'Cine moderno y contemporáneo',54,'Programa de Cine moderno y contemporáneo para alumnos de segundo semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59010,'Inicios del Cine mexicano',54,'Programa de Inicios del Cine mexicano para alumnos de segundo semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59011,'Metodología de la investigación sociocultural en el Cine',51,'Programa de Metodología de la investigación sociocultural en el Cine para alumnos de segundo semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59012,'Modelos narrativos de escritura creativa',55,'Programa de Modelos narrativos de escritura creativa para alumnos de segundo semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),

(59013,'Taller de guion: estructuras de ficción y no ficción',54,'Programa de Taller de guion: estructuras de ficción y no ficción para alumnos de tercer semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59014,'Lenguaje cinematográfico del Cine actual',54,'Programa de Lenguaje cinematográfico del Cine actual para alumnos de tercer semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59015,'Desarrollo de la producción',54,'Programa de Desarrollo de la producción para alumnos de tercer semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59016,'Cine mexicano moderno y contemporáneo',54,'Programa de Cine mexicano moderno y contemporáneo para alumnos de tercer semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59017,'Teorías de Imagen y Sonido',54,'Programa de Teorías de Imagen y Sonido para alumnos de tercer semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59018,'Legislación cinematográfica y derechos de autor',45,'Programa de Legislación cinematográfica y derechos de autor para alumnos de tercer semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),

(59019,'Taller de guion: géneros cinematográficos',54,'Programa de Taller de guion: géneros cinematográficos para alumnos de cuarto semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59020,'Técnica y composición de la Cinefotografía',54,'Programa de Técnica y composición de la Cinefotografía para alumnos de cuarto semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59021,'Registro sonoro para audiovisuales',54,'Programa de Registro sonoro para audiovisuales para alumnos de cuarto semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59022,'Teorías y técnicas del Montaje',54,'Programa de Teorías y técnicas del Montaje para alumnos de cuarto semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59023,'Realización documental',54,'Programa de Realización documental para alumnos de cuarto semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59024,'Preproducción cinematográfica',54,'Programa de Preproducción cinematográfica para alumnos de cuarto semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59025,'Estética de Imagen y Sonido',47,'Programa de Estética de Imagen y Sonido para alumnos de cuarto semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),

(59026,'Taller de guion: Nuevas formas narrativas',54,'Programa de Taller de guion: Nuevas formas narrativas para alumnos de quinto semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59027,'MDiseño y puesta en cuadro con luz natural',54,'Programa de Diseño y puesta en cuadro con luz natural para alumnos de quinto semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59028,'Realización de ficción',54,'Programa de Realización de ficción para alumnos de quinto semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59029,'Taller de Dirección de arte',54,'Programa de Taller de Dirección de arte para alumnos de quinto semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59030,'Armado de carpetas para la producción audiovisual',54,'Programa de Armado de carpetas para la producción audiovisual para alumnos de quinto semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59031,'Montaje narrativo',54,'Programa de Montaje narrativo para alumnos de quinto semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59032,'Edición de sonido',54,'Programa de Edición de sonido para alumnos de quinto semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),

(59033,'Taller de Dirección a cuadro',54,'Programa de Taller de Dirección a cuadro para alumnos de sexto semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59034,'Seminario de Guion',54,'Programa de Seminario de Guion para alumnos de sexto semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59035,'Diseño y puesta en cuadro con luz artificial',54,'Programa de Diseño y puesta en cuadro con luz artificial para alumnos de sexto semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59036,'Diseño sonoro',54,'Programa de Diseño sonoro para alumnos de sexto semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59037,'Realización de Cine híbrido',54,'Programa de Realización de Cine híbrido para alumnos de sexto semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59038,'Montaje: nuevas estructuras',54,'Programa de Montaje: nuevas estructuras para alumnos de sexto semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59039,'Estrategias de e-commerce',41,'Programa de Estrategias de e-commerce para alumnos de sexto semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),

(59040,'Laboratorio de Realización audiovisual',54,'Programa de Laboratorio de Realización audiovisual para alumnos de séptimo semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59041,'Cinefotografía: experimentación y estilo de imagen',54,'Programa de Cinefotografía: experimentación y estilo de imagen para alumnos de séptimo semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59042,'Producción: desarrollo de proyectos audiovisuales',54,'Programa de Producción: desarrollo de proyectos audiovisuales para alumnos de séptimo semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59043,'Procesos de Postproducción',54,'Programa de Procesos de Postproducción para alumnos de séptimo semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59044,'Seminario de Musicalización para audiovisuales',54,'Programa de Seminario de Musicalización para audiovisuales para alumnos de séptimo semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59045,'Ética Profesional',47,'Programa de Ética Profesional para alumnos de séptimo semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
/*(59046,'Optativa Profesionalizante I',0,'Programa de Optativa Profesionalizante I para alumnos de séptimo semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),*/

(59047,'Seminario de Preproducción',54,'Programa de Seminario de Preproducción para alumnos de octavo semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59048,'Seminario de Realización',54,'Programa de Seminario de Realización para alumnos de octavo semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
/*(59049,'Optativa Profesionalizante II',0,'Programa de Optativa Profesionalizante II para alumnos de octavo semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),*/

(59050,'Seminario de Postproducción',54,'Programa de Seminario de Postproducción para alumnos de noveno semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1),
(59051,'Seminario de Distribución y Mercados',54,'Programa de Seminario de Distribución y Mercados para alumnos de noveno semestre de Lic. en Artes Cinematográficas y Audiovisuales, 2020.',1);


/*Lic. en Estudios del Arte y Gestión Cultural*/

/*Plan 2016, Carrera 78*/
/*id(60001,61000), nombre, departamento, descripcion, vigente*/
/*1-56*/

INSERT INTO Materia VALUES 
(60001,'Metodologías Aplicadas al Arte',53,'Programa de Metodologías Aplicadas al Arte para alumnos de primer semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60002,'Arte Clásico',53,'Programa de Arte Clásico para alumnos de primer semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60003,'Gestión de la Educación Artística',53,'Programa de Gestión de la Educación Artística para alumnos de primer semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60004,'Gestión Cultural I',53,'Programa de Gestión Cultural I para alumnos de primer semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60005,'Filosofía de la Cultura',47,'Programa de Filosofía de la Cultura para alumnos de primer semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60006,'Taller de Escritura Aplicado al Arte',55,'Programa de Taller de Escritura Aplicado al Arte para alumnos de primer semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),

(60007,'conología e Iconografía',53,'Programa de conología e Iconografía para alumnos de segundo semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60008,'Teoría del Arte',53,'Programa de Teoría del Arte para alumnos de segundo semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60009,'Arte de la Edad Media',53,'Programa de Arte de la Edad Media para alumnos de segundo semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60010,'Gestión Cultural II',53,'Programa de Gestión Cultural II para alumnos de segundo semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60011,'Mitologías',51,'Programa de Mitologías para alumnos de segundo semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60012,'Didáctica de la Educación Artística',46,'Programa de Didáctica de la Educación Artística para alumnos de segundo semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60013,'Historia de las Religiones',48,'Programa de Historia de las Religiones para alumnos de segundo semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),

(60014,'Arte del Renacimiento',53,'Programa de Arte del Renacimiento para alumnos de tercer semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60015,'Arte Prehispánico',53,'Programa de Arte Prehispánico para alumnos de tercer semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60016,'Tecnologías de la Información para la Educación Artística',13,'Programa de Tecnologías de la Información para la Educación Artística para alumnos de tercer semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60017,'Archivos y Catálogos',48,'Programa de Archivos y Catálogos para alumnos de tercer semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60018,'Mercadotecnia Básica',36,'Programa de Mercadotecnia Básica para alumnos de tercer semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60019,'Diseño de Programas Educativos',46,'Programa de Diseño de Programas Educativos para alumnos de tercer semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),

(60020,'Arte Barroco',53,'Programa de Arte Barroco para alumnos de cuarto semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60021,'Arte Virreina',53,'Programa de Arte Virreina para alumnos de cuarto semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60022,'Proyectos de Intervención de Educación Artística I',53,'Programa de Proyectos de Intervención de Educación Artística I para alumnos de cuarto semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60023,'Patrimonio Cultural',53,'Programa de Patrimonio Cultural para alumnos de cuarto semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60024,'Marco Jurídico del Arte y la Cultura',45,'Programa de Marco Jurídico del Arte y la Cultura para alumnos de cuarto semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60025,'Estética I',47,'Programa de Estética I para alumnos de cuarto semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),

(60026,'Taller de Análisis y Crítica de Arte I',53,'Programa de Taller de Análisis y Crítica de Arte I para alumnos de quinto semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60027,'Arte del Siglo XVIII y XIX',53,'Programa de Arte del Siglo XVIII y XIX para alumnos de quinto semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60028,'Arte Mexicano',53,'Programa de Arte Mexicano para alumnos de quinto semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60029,'Proyectos de Intervención en Educación Artística II',53,'Programa de Proyectos de Intervención en Educación Artística II para alumnos de quinto semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60030,'Desarrollo de Públicos y Procuración de Fondos',53,'Programa de Desarrollo de Públicos y Procuración de Fondos para alumnos de quinto semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60031,'Estética II',47,'Programa de Estética II para alumnos de quinto semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60032,'Derechos Humanos y Propiedad Intelectual',45,'Programa de Derechos Humanos y Propiedad Intelectual para alumnos de quinto semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),

(60033,'Taller de Análisis y Crítica de Arte II',53,'Programa de Taller de Análisis y Crítica de Arte II para alumnos de sexto semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60034,'Arte de la Primera Mitad del Siglo XX',53,'Programa de Arte de la Primera Mitad del Siglo XX para alumnos de sexto semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60035,'Industrias Culturales',53,'Programa de Industrias Culturales para alumnos de sexto semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60036,'Gestión de Galerías',53,'Programa de Gestión de Galerías para alumnos de sexto semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60037,'Historia Social, Política y Económica del Siglo XX, I',48,'Programa de Historia Social, Política y Económica del Siglo XX, I para alumnos de sexto semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60038,'Museología',53,'Programa de Museología para alumnos de sexto semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),

(60039,'Taller de Análisis y Crítica de Arte I',53,'Programa de Taller de Análisis y Crítica de Arte I para alumnos de séptimo semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60040,'Seminario de Investigación en Arte y Gestión I',53,'Programa de Seminario de Investigación en Arte y Gestión I para alumnos de séptimo semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60041,'Arte Contemporáneo',53,'Programa de Arte Contemporáneo para alumnos de séptimo semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60042,'Arte Latinoamericano',53,'Programa de Arte Latinoamericano para alumnos de séptimo semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
/*(60043,'Optativa Profesionalizante I',0,'Programa de Optativa Profesionalizante I para alumnos de séptimo semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),*/
(60044,'Historia Social, Política y Económica del Siglo XX, II',48,'Programa de Historia Social, Política y Económica del Siglo XX, II para alumnos de séptimo semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),

(60045,'Seminario de Investigación en Arte y Gestión II',53,'Programa de Seminario de Investigación en Arte y Gestión II para alumnos de octavo semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60046,'Arte Regional Centro-Occidente',53,'Programa de Arte Regional Centro-Occidente para alumnos de octavo semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60047,'Taller de Proyectos Culturales I',53,'Programa de Taller de Proyectos Culturales I para alumnos de octavo semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60048,'Curaduría',53,'Programa de Curaduría para alumnos de octavo semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60049,'Sociología del Arte',51,'Programa de Sociología del Arte para alumnos de octavo semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
/*(60050,'Optativa Profesionalizante II',0,'Programa de Optativa Profesionalizante II para alumnos de octavo semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),*/

(60051,'Seminario de Investigación en Arte y Gestión III',53,'Programa de Seminario de Investigación en Arte y Gestión III para alumnos de noveno semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60052,'Taller de Proyectos Culturales II',53,'Programa de Taller de Proyectos Culturales II para alumnos de noveno semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60053,'Producción Ejecutiva del Arte y la Cultura',53,'Programa de Producción Ejecutiva del Arte y la Cultura para alumnos de noveno semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60054,'Ética Profesional',47,'Programa de Ética Profesional para alumnos de noveno semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60055,'Economía de la Cultura',34,'Programa de Economía de la Cultura para alumnos de noveno semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1),
(60056,'Taller de Medios Digitales para la Difusión Cultural',44,'Programa de Taller de Medios Digitales para la Difusión Cultural para alumnos de noveno semestre de Lic. en Estudios del Arte y Gestión Cultural, 2016.',1);


/*Lic. en Letras Hispánicas*/

/*Plan 2016, Carrera 10*/
/*id(61001,62000), nombre, departamento, descripcion, vigente*/
/*1-53*/

INSERT INTO Materia VALUES 
(61001,'Redacción Básica',55,'Programa de Redacción Básica para alumnos de primer semestre de Lic. en Letras Hispánicas, 2016.',1),
(61002,'Introducción a la Lingüística',55,'Programa de Introducción a la Lingüística para alumnos de primer semestre de Lic. en Letras Hispánicas, 2016.',1),
(61003,'Literatura Clásica Grecolatina',55,'Programa de Literatura Clásica Grecolatina para alumnos de primer semestre de Lic. en Letras Hispánicas, 2016.',1),
(61004,'Literatura Prehispánica',55,'Programa de Literatura Prehispánica para alumnos de primer semestre de Lic. en Letras Hispánicas, 2016.',1),
(61005,'Historia del Arte',48,'Programa de Historia del Arte para alumnos de primer semestre de Lic. en Letras Hispánicas, 2016.',1),
(61006,'Intr. histórica al Pensamiento Filosófico',47,'Programa de Intr. histórica al Pensamiento Filosófico para alumnos de primer semestre de Lic. en Letras Hispánicas, 2016.',1),

(61007,'Redacción Académica',55,'Programa de Redacción Académica para alumnos de segundo semestre de Lic. en Letras Hispánicas, 2016.',1),
(61008,'Preceptiva de la Lírica',55,'Programa de Preceptiva de la Lírica para alumnos de segundo semestre de Lic. en Letras Hispánicas, 2016.',1),
(61009,'Morfología de las Palabras',55,'Programa de Morfología de las Palabras para alumnos de segundo semestre de Lic. en Letras Hispánicas, 2016.',1),
(61010,'Literatura Castellana Medieval',55,'Programa de Literatura Castellana Medieval para alumnos de segundo semestre de Lic. en Letras Hispánicas, 2016.',1),
(61011,'Pensamiento Crítico',47,'Programa de Pensamiento Crítico para alumnos de segundo semestre de Lic. en Letras Hispánicas, 2016.',1),
(61012,'Informática para Letras Hispánicas',13,'Programa de Informática para Letras Hispánicas para alumnos de segundo semestre de Lic. en Letras Hispánicas, 2016.',1),

(61013,'Teoría de la Literatura I',55,'Programa de Teoría de la Literatura I para alumnos de tercero semestre de Lic. en Letras Hispánicas, 2016.',1),
(61014,'Sintaxis I',55,'Programa de Sintaxis I para alumnos de tercero semestre de Lic. en Letras Hispánicas, 2016.',1),
(61015,'Latín I',55,'Programa de Latín I para alumnos de tercero semestre de Lic. en Letras Hispánicas, 2016.',1),
(61016,'Taller de creación literaria',55,'Programa de Taller de creación literaria para alumnos de tercero semestre de Lic. en Letras Hispánicas, 2016.',1),
(61017,'Literatura Renacentista',55,'Programa de Literatura Renacentista para alumnos de tercero semestre de Lic. en Letras Hispánicas, 2016.',1),
(61018,'Historia de México',48,'Programa de Historia de México para alumnos de tercero semestre de Lic. en Letras Hispánicas, 2016.',1),

(61019,'Teoría de la Literatura II',55,'Programa de Teoría de la Literatura II para alumnos de cuarto semestre de Lic. en Letras Hispánicas, 2016.',1),
(61020,'Sintaxis II',55,'Programa de Sintaxis II para alumnos de cuarto semestre de Lic. en Letras Hispánicas, 2016.',1),
(61021,'Latín II',55,'Programa de Latín II para alumnos de cuarto semestre de Lic. en Letras Hispánicas, 2016.',1),
(61022,'Literatura Barroca Española',55,'Programa de Literatura Barroca Española para alumnos de cuarto semestre de Lic. en Letras Hispánicas, 2016.',1),
(61023,'Literatura Novohispana',55,'Programa de Literatura Novohispana para alumnos de cuarto semestre de Lic. en Letras Hispánicas, 2016.',1),
(61024,'Literatura Hispanoamericana Colonial',55,'Programa de Literatura Hispanoamericana Colonial para alumnos de cuarto semestre de Lic. en Letras Hispánicas, 2016.',1),
(61025,'Apreciación del Arte Moderno Y Contemp.',53,'Programa de Apreciación del Arte Moderno Y Contemp. para alumnos de cuarto semestre de Lic. en Letras Hispánicas, 2016.',1),

(61026,'Met. de la Inv. Lingüística y Literaria',55,'Programa de Met. de la Inv. Lingüística y Literaria para alumnos de quinto semestre de Lic. en Letras Hispánicas, 2016.',1),
(61027,'Fonética y Fonología',55,'Programa de Fonética y Fonología para alumnos de quinto semestre de Lic. en Letras Hispánicas, 2016.',1),
(61028,'Latín III',55,'Programa de Latín III para alumnos de quinto semestre de Lic. en Letras Hispánicas, 2016.',1),
(61029,'Lexicología y Lexicografía',55,'Programa de Lexicología y Lexicografía para alumnos de quinto semestre de Lic. en Letras Hispánicas, 2016.',1),
(61030,'Literatura Española Moderna',55,'Programa de Literatura Española Moderna para alumnos de quinto semestre de Lic. en Letras Hispánicas, 2016.',1),
(61031,'Literatura Mexicana Moderna',55,'Programa de Literatura Mexicana Moderna para alumnos de quinto semestre de Lic. en Letras Hispánicas, 2016.',1),
(61032,'Literatura Hispanoamericana Moderna',55,'Programa de Literatura Hispanoamericana Moderna para alumnos de quinto semestre de Lic. en Letras Hispánicas, 2016.',1),

(61033,'Semántica',55,'Programa de Semántica para alumnos de sexto semestre de Lic. en Letras Hispánicas, 2016.',1),
(61034,'Sociolingüística y Dialectología',55,'Programa de Sociolingüística y Dialectología para alumnos de sexto semestre de Lic. en Letras Hispánicas, 2016.',1),
(61035,'Literatura Española Contemporánea',55,'Programa de Literatura Española Contemporánea para alumnos de sexto semestre de Lic. en Letras Hispánicas, 2016.',1),
(61036,'Literatura Mexicana Contemporánea',55,'Programa de Literatura Mexicana Contemporánea para alumnos de sexto semestre de Lic. en Letras Hispánicas, 2016.',1),
(61037,'Literatura Hispanoamericana Contemp.',55,'Programa de Literatura Hispanoamericana Contemp. para alumnos de sexto semestre de Lic. en Letras Hispánicas, 2016.',1),
(61038,'Taller de crítica literaria',55,'Programa de Taller de crítica literaria para alumnos de sexto semestre de Lic. en Letras Hispánicas, 2016.',1),

(61039,'Linguistica Histórica del Español I',55,'Programa de Linguistica Histórica del Español I para alumnos de séptimo semestre de Lic. en Letras Hispánicas, 2016.',1),
(61040,'Análisis de discurso',55,'Programa de Análisis de discurso para alumnos de séptimo semestre de Lic. en Letras Hispánicas, 2016.',1),
(61041,'Seminario de Lírica Contemporánea',55,'Programa de Seminario de Lírica Contemporánea para alumnos de séptimo semestre de Lic. en Letras Hispánicas, 2016.',1),
(61042,'Literatura Mundial Contemporánea',55,'Programa de Literatura Mundial Contemporánea para alumnos de séptimo semestre de Lic. en Letras Hispánicas, 2016.',1),
(61043,'Didáctica y Diseño Instruccional',46,'Programa de Didáctica y Diseño Instruccional para alumnos de séptimo semestre de Lic. en Letras Hispánicas, 2016.',1),
(61044,'Taller de producción de Medios Digitales',44,'Programa de Taller de producción de Medios Digitales para alumnos de séptimo semestre de Lic. en Letras Hispánicas, 2016.',1),

(61045,'Lingüística Histórica del Español II',55,'Programa de Lingüística Histórica del Español II para alumnos de octavo semestre de Lic. en Letras Hispánicas, 2016.',1),
(61046,'Español como 2da lengua',55,'Programa de Español como 2da lengua para alumnos de octavo semestre de Lic. en Letras Hispánicas, 2016.',1),
(61047,'Ética Profesional',47,'Programa de Ética Profesional para alumnos de octavo semestre de Lic. en Letras Hispánicas, 2016.',1),
(61048,'Diseño, Implem. y Eval. de programas',46,'Programa de Diseño, Implem. y Eval. de programas para alumnos de octavo semestre de Lic. en Letras Hispánicas, 2016.',1),
(61049,'Procesos Editoriales',55,'Programa de Procesos Editoriales para alumnos de octavo semestre de Lic. en Letras Hispánicas, 2016.',1),
/*(61050,'Optativa Profesionalizante I',0,'Programa de Optativa Profesionalizante I para alumnos de octavo semestre de Lic. en Letras Hispánicas, 2016.',1),*/

(61051,'Gestión de Proyectos Culturales',53,'Programa de Gestión de Proyectos Culturales para alumnos de noveno semestre de Lic. en Letras Hispánicas, 2016.',1),
(61052,'Seminario de Inv. Lingüística y Literaria',55,'Programa de Seminario de Inv. Lingüística y Literaria para alumnos de noveno semestre de Lic. en Letras Hispánicas, 2016.',1);
/*(61053,'Optativa Profesionalizante II',0,'Programa de Optativa Profesionalizante I para alumnos de noveno semestre de Lic. en Letras Hispánicas, 2016.',1);*/


/*Lic. en Música*/

/*Plan 2017, Carrera 79*/
/*id(62001,63000), nombre, departamento, descripcion, vigente*/
/*1-68*/

INSERT INTO Materia VALUES 
(62001,'Solfeo I',56,'Programa de Solfeo I para alumnos de primer semestre de Lic. en Música, 2017.',1),
(62002,'Piano Complementario I',56,'Programa de Piano Complementario I para alumnos de primer semestre de Lic. en Música, 2017.',1),
(62003,'Melodía y Contrapinto Modal',56,'Programa de Melodía y Contrapinto Modal para alumnos de primer semestre de Lic. en Música, 2017.',1),
(62004,'Instrumento Principal I',56,'Programa de Instrumento Principal I para alumnos de primer semestre de Lic. en Música, 2017.',1),
(62005,'Conjuntos Corales I',56,'Programa de Conjuntos Corales I para alumnos de primer semestre de Lic. en Música, 2017.',1),
(62006,'Historia de la Cultura',48,'Programa de Historia de la Cultura para alumnos de primer semestre de Lic. en Música, 2017.',1),

(62007,'Solfeo II',56,'Programa de Solfeo II para alumnos de segundo semestre de Lic. en Música, 2017.',1),
(62008,'Piano Complementario II',56,'Programa de Piano Complementario II para alumnos de segundo semestre de Lic. en Música, 2017.',1),
(62009,'Armonía Elemental',56,'Programa de Armonía Elemental para alumnos de segundo semestre de Lic. en Música, 2017.',1),
(62010,'Música y Sociedad Medieval y Renacentista ',56,'Programa de Música y Sociedad Medieval y Renacentista  para alumnos de segundo semestre de Lic. en Música, 2017.',1),
(62011,'Instrumento Principal II',56,'Programa de Instrumento Principal II para alumnos de segundo semestre de Lic. en Música, 2017.',1),
(62012,'Conjuntos Corales II',56,'Programa de Conjuntos Corales II para alumnos de segundo semestre de Lic. en Música, 2017.',1),
(62013,'Cultura Física para Músicos',22,'Programa de Cultura Física para Músicos para alumnos de segundo semestre de Lic. en Música, 2017.',1),

(62014,'Solfeo III',56,'Programa de Solfeo III para alumnos de tercer semestre de Lic. en Música, 2017.',1),
(62015,'Piano Complementario III',56,'Programa de Piano Complementario III para alumnos de tercer semestre de Lic. en Música, 2017.',1),
(62016,'Teoría Tonal y Análisis I',56,'Programa de Teoría Tonal y Análisis I para alumnos de tercer semestre de Lic. en Música, 2017.',1),
(62017,'Contrapunto Tonal',56,'Programa de Contrapunto Tonal para alumnos de tercer semestre de Lic. en Música, 2017.',1),
(62018,'Música y Sociedad en el Barroco',56,'Programa de Música y Sociedad en el Barroco para alumnos de tercer semestre de Lic. en Música, 2017.',1),
(62019,'Instrumento Principal III',56,'Programa de Instrumento Principal III para alumnos de tercer semestre de Lic. en Música, 2017.',1),
(62020,'Conjuntos Corales III',56,'Programa de Conjuntos Corales III para alumnos de tercer semestre de Lic. en Música, 2017.',1),
(62021,'Redacción Básica',55,'Programa de Redacción Básica para alumnos de tercer semestre de Lic. en Música, 2017.',1),

(62022,'Solfeo IV',56,'Programa de Solfeo IV para alumnos de cuarto semestre de Lic. en Música, 2017.',1),
(62023,'Piano Complementario IV',56,'Programa de Piano Complementario IV para alumnos de cuarto semestre de Lic. en Música, 2017.',1),
(62024,'Teoría Tonal y Análisis II',56,'Programa de Teoría Tonal y Análisis II para alumnos de cuarto semestre de Lic. en Música, 2017.',1),
(62025,'Música y Sociedad en el Siglo VIII',56,'Programa de Música y Sociedad en el Siglo VIII para alumnos de cuarto semestre de Lic. en Música, 2017.',1),
(62026,'Instrumento Principal IV',56,'Programa de Instrumento Principal IV para alumnos de cuarto semestre de Lic. en Música, 2017.',1),
(62027,'Conjuntos Corales IV',56,'Programa de Conjuntos Corales IV para alumnos de cuarto semestre de Lic. en Música, 2017.',1),
(62028,'Taller de Computación Aplicada a la Música',13,'Programa de Taller de Computación Aplicada a la Música para alumnos de cuarto semestre de Lic. en Música, 2017.',1),

(62029,'Solfeo V',56,'Programa de Solfeo V para alumnos de quinto semestre de Lic. en Música, 2017.',1),
(62030,'Piano Complementario V',56,'Programa de Piano Complementario V para alumnos de quinto semestre de Lic. en Música, 2017.',1),
(62031,'Armonía y Análisis del Siglo XIX',56,'Programa de Armonía y Análisis del Siglo XIX para alumnos de quinto semestre de Lic. en Música, 2017.',1),
(62032,'Música y Sociedad en el Siglo XIX',56,'Programa de Música y Sociedad en el Siglo XIX para alumnos de quinto semestre de Lic. en Música, 2017.',1),
(62033,'Instrumento Principal V',56,'Programa de Instrumento Principal V para alumnos de quinto semestre de Lic. en Música, 2017.',1),
(62034,'Prácticas de Ensamble I',56,'Programa de Prácticas de Ensamble I para alumnos de quinto semestre de Lic. en Música, 2017.',1),
(62035,'Conjuntos de Cámara I',56,'Programa de Conjuntos de Cámara I para alumnos de quinto semestre de Lic. en Música, 2017.',1),

(62036,'Solfeo VI',56,'Programa de Solfeo VI para alumnos de sexto semestre de Lic. en Música, 2017.',1),
(62037,'Piano Complementario VI',56,'Programa de Piano Complementario VI para alumnos de sexto semestre de Lic. en Música, 2017.',1),
(62038,'Modernismo: Técnicas, Análisis y Contexto ',56,'Programa de Modernismo: Técnicas, Análisis y Contexto  para alumnos de sexto semestre de Lic. en Música, 2017.',1),
(62039,'Instrumento Principal VI',56,'Programa de Instrumento Principal VI para alumnos de sexto semestre de Lic. en Música, 2017.',1),
(62040,'Prácticas de Ensamble II',56,'Programa de Prácticas de Ensamble II para alumnos de sexto semestre de Lic. en Música, 2017.',1),
(62041,'Conjuntos de Cámara II',56,'Programa de Conjuntos de Cámara II para alumnos de sexto semestre de Lic. en Música, 2017.',1),
(62042,'Enfoques de Educación Musical',56,'Programa de Enfoques de Educación Musical para alumnos de sexto semestre de Lic. en Música, 2017.',1),

(62043,'Posguerra: Técnicas, Análisis y Contexto ',56,'Programa de Posguerra: Técnicas, Análisis y Contexto  para alumnos de séptimo semestre de Lic. en Música, 2017.',1),
(62044,'Instrumento Principal VII',56,'Programa de Instrumento Principal VII para alumnos de séptimo semestre de Lic. en Música, 2017.',1),
(62045,'Prácticas de Ensamble III',56,'Programa de Prácticas de Ensamble III para alumnos de séptimo semestre de Lic. en Música, 2017.',1),
(62046,'Conjuntos de Cámara III',56,'Programa de Conjuntos de Cámara III para alumnos de séptimo semestre de Lic. en Música, 2017.',1),
(62047,'Dirección de Ensambles Escolares',56,'Programa de Dirección de Ensambles Escolares para alumnos de séptimo semestre de Lic. en Música, 2017.',1),
(62048,'Ética Profesional ',47,'Programa de Ética Profesional  para alumnos de séptimo semestre de Lic. en Música, 2017.',1),
/*(62049,'Optativa Profesionalizante I',56,'Programa de Optativa Profesionalizante I para alumnos de séptimo semestre de Lic. en Música, 2017.',1),*/

(62050,'Análisis Musical: Percepción e Interpretación ',56,'Programa de Análisis Musical: Percepción e Interpretación  para alumnos de octavo semestre de Lic. en Música, 2017.',1),
(62051,'Instrumento Principal VIII',56,'Programa de Instrumento Principal VIII para alumnos de octavo semestre de Lic. en Música, 2017.',1),
(62052,'Prácticas de Ensamble IV',56,'Programa de Prácticas de Ensamble IV para alumnos de octavo semestre de Lic. en Música, 2017.',1),
(62053,'Conjuntos de Cámara IV',56,'Programa de Conjuntos de Cámara IV para alumnos de octavo semestre de Lic. en Música, 2017.',1),
(62054,'Didáctica (62001,EDU-DA1)',46,'Programa de Didáctica (62001,EDU-DA1) para alumnos de octavo semestre de Lic. en Música, 2017.',1),
(62055,'Gestión de Proyectos Musicales',53,'Programa de Gestión de Proyectos Musicales para alumnos de octavo semestre de Lic. en Música, 2017.',1),
/*(62056,'Optativa Profesionalizante II',56,'Programa de Optativa Profesionalizante II para alumnos de octavo semestre de Lic. en Música, 2017.',1),*/

(62057,'Instrumento Principal IX',56,'Programa de Instrumento Principal IX para alumnos de noveno semestre de Lic. en Música, 2017.',1),
(62058,'Prácticas de Ensamble V',56,'Programa de Prácticas de Ensamble V para alumnos de noveno semestre de Lic. en Música, 2017.',1),
(62059,'Conjuntos de Cámara V',56,'Programa de Conjuntos de Cámara V para alumnos de noveno semestre de Lic. en Música, 2017.',1),
(62060,'Fundamentos de Diseño de Programas',46,'Programa de Fundamentos de Diseño de Programas para alumnos de noveno semestre de Lic. en Música, 2017.',1),
(62061,'Seminario de Investigación en Música I',56,'Programa de Seminario de Investigación en Música I para alumnos de noveno semestre de Lic. en Música, 2017.',1),
/*(62062,'Optativa Profesionalizante III',56,'Programa de Optativa Profesionalizante III para alumnos de noveno semestre de Lic. en Música, 2017.',1),*/

(62063,'Instrumento Principal X',56,'Programa de Instrumento Principal X para alumnos de décimo semestre de Lic. en Música, 2017.',1),
(62064,'Prácticas de Ensamble VI',56,'Programa de Prácticas de Ensamble VI para alumnos de décimo semestre de Lic. en Música, 2017.',1),
(62065,'Conjuntos de Cámara VI',56,'Programa de Conjuntos de Cámara VI para alumnos de décimo semestre de Lic. en Música, 2017.',1),
(62066,'Música en el Aula',56,'Programa de Música en el Aula para alumnos de décimo semestre de Lic. en Música, 2017.',1),
(62067,'Seminario de Investigación en Música II',56,'Programa de Seminario de Investigación en Música II para alumnos de décimo semestre de Lic. en Música, 2017.',1);
/*(62068,'Optativa Profesionalizante IV',56,'Programa de Optativa Profesionalizante IV para alumnos de décimo semestre de Lic. en Música, 2017.',1);*/


#---------------------------------------------------------------------------------------------------------------------------------------------------------------


DELIMITER $$

DROP TRIGGER IF EXISTS `cascada_actualizar_padre_centro`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `cascada_actualizar_padre_centro` AFTER UPDATE ON `Centro` 
FOR EACH ROW BEGIN
    UPDATE Carrera SET Carrera.centro_id = NEW.centro_id WHERE Carrera.centro_id = OLD.centro_id;
    UPDATE Departamento SET Departamento.centro_id = NEW.centro_id WHERE Departamento.centro_id = OLD.centro_id;
END$$

DROP TRIGGER IF EXISTS `restringir_eliminar_padre_centro`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `restringir_eliminar_padre_centro` AFTER DELETE ON `Centro` 
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Carrera WHERE Carrera.centro_id = OLD.centro_id) <> 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede eliminar el registro. La llave foránea existe en la tabla Carrera.';
    END IF;

    IF(SELECT COUNT(*) FROM Departamento WHERE Departamento.centro_id = OLD.centro_id) <> 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede eliminar el registro. La llave foránea existe en la tabla Departamento.';
    END IF;
END$$


#----------------------------------------------------------------


DROP TRIGGER IF EXISTS `cascada_actualizar_padre_carrera`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `cascada_actualizar_padre_carrera` AFTER UPDATE ON `Carrera` 
FOR EACH ROW BEGIN
    UPDATE Plan_Estudio SET Plan_Estudio.carrera_id = NEW.carrera_id WHERE Plan_Estudio.carrera_id = OLD.carrera_id;
END$$

DROP TRIGGER IF EXISTS `restringir_eliminar_padre_carrera`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `restringir_eliminar_padre_carrera` AFTER DELETE ON `Carrera` 
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Plan_Estudio WHERE Plan_Estudio.carrera_id = OLD.carrera_id) <> 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede eliminar el registro. La llave foránea existe en la tabla Plan_Estudio.';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` TRIGGER `prevenir_insertar_hijo_carrera` BEFORE INSERT ON `Carrera`
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Centro WHERE Centro.centro_id = NEW.centro_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Centro.';
    END IF;

    IF((SELECT COUNT(*) FROM Carrera WHERE Carrera.carrera_id = NEW.carrera_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (carrera_id) ya existe en la tabla Carrera.';
    END IF;
END$$

DROP TRIGGER IF EXISTS `prevenir_actualizar_hijo_carrera`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `prevenir_actualizar_hijo_carrera` BEFORE UPDATE ON `Carrera` 
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Centro WHERE Centro.centro_id = NEW.centro_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Centro.';
    END IF;

    IF(OLD.carrera_id <> NEW.carrera_id AND (SELECT COUNT(*) FROM Carrera WHERE Carrera.carrera_id = NEW.carrera_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (carrera_id) ya existe en la tabla Carrera.';
    END IF;
END$$


#----------------------------------------------------------------


DROP TRIGGER IF EXISTS `cascada_actualizar_padre_alumno`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `cascada_actualizar_padre_alumno` AFTER UPDATE ON `Alumno` 
FOR EACH ROW BEGIN
    UPDATE Tutor SET Tutor.alumno_id = NEW.alumno_id WHERE Tutor.alumno_id = OLD.alumno_id;
    UPDATE Alumno_Solicitud SET Alumno_Solicitud.alumno_id = NEW.alumno_id WHERE Alumno_Solicitud.alumno_id = OLD.alumno_id;
END$$

DROP TRIGGER IF EXISTS `cascada_eliminar_padre_alumno`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `cascada_eliminar_padre_alumno` AFTER DELETE ON `Alumno` 
FOR EACH ROW BEGIN
    DELETE FROM Tutor WHERE Tutor.alumno_id = OLD.alumno_id;
    DELETE FROM Alumno_Solicitud WHERE Alumno_Solicitud.alumno_id = OLD.alumno_id;
END$$

CREATE DEFINER=`root`@`localhost` TRIGGER `prevenir_insertar_hijo_alumno` BEFORE INSERT ON `Alumno`
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Plan_Estudio WHERE Plan_Estudio.plan_id = NEW.plan_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Plan_Estudio.';
    END IF;

    IF((SELECT COUNT(*) FROM Alumno WHERE Alumno.alumno_id = NEW.alumno_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (alumno_id) ya existe en la tabla Alumno.';
    END IF;

    SET NEW.alumno_grupo_numero = ORD(NEW.alumno_grupo) - 65;
END$$

DROP TRIGGER IF EXISTS `prevenir_actualizar_hijo_alumno`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `prevenir_actualizar_hijo_alumno` BEFORE UPDATE ON `Alumno`
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Plan_Estudio WHERE Plan_Estudio.plan_id = NEW.plan_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Plan_Estudio.';
    END IF;

    IF(OLD.alumno_id <> NEW.alumno_id AND (SELECT COUNT(*) FROM Alumno WHERE Alumno.alumno_id = NEW.alumno_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (alumno_id) ya existe en la tabla Alumno.';
    END IF;

    SET NEW.alumno_grupo_numero = ORD(NEW.alumno_grupo) - 65;
END$$


#----------------------------------------------------------------


DROP TRIGGER IF EXISTS `cascada_actualizar_padre_tutor`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `cascada_actualizar_padre_tutor` AFTER UPDATE ON `Tutor` 
FOR EACH ROW BEGIN
    UPDATE Materia_Tutor SET Materia_Tutor.tutor_id = NEW.tutor_id WHERE Materia_Tutor.tutor_id = OLD.tutor_id;
    UPDATE Solicitud SET Solicitud.tutor_id = NEW.tutor_id WHERE Solicitud.tutor_id = OLD.tutor_id;
END$$

DROP TRIGGER IF EXISTS `cascada_eliminar_padre_tutor`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `cascada_eliminar_padre_tutor` AFTER DELETE ON `Tutor` 
FOR EACH ROW BEGIN
    DELETE FROM Materia_Tutor WHERE Materia_Tutor.tutor_id = OLD.tutor_id;
    DELETE FROM Solicitud WHERE Solicitud.tutor_id = OLD.tutor_id;
END$$

CREATE DEFINER=`root`@`localhost` TRIGGER `prevenir_insertar_hijo_tutor` BEFORE INSERT ON `Tutor`
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Alumno WHERE Alumno.alumno_id = NEW.alumno_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Alumno.';
    END IF;

    IF((SELECT COUNT(*) FROM Tutor WHERE Tutor.tutor_id = NEW.tutor_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (tutor_id) ya existe en la tabla Tutor.';
    END IF;

    IF NEW.tutor_programa = "S" THEN
        SET NEW.tutor_programa_numero = 0;
    ELSE
        SET NEW.tutor_programa_numero = 1;
    END IF;
END$$

DROP TRIGGER IF EXISTS `prevenir_actualizar_hijo_tutor`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `prevenir_actualizar_hijo_tutor` BEFORE UPDATE ON `Tutor`
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Alumno WHERE Alumno.alumno_id = NEW.alumno_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Alumno.';
    END IF;

    IF(OLD.tutor_id <> NEW.tutor_id AND (SELECT COUNT(*) FROM Tutor WHERE Tutor.tutor_id = NEW.tutor_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (tutor_id) ya existe en la tabla Tutor.';
    END IF;

    IF NEW.tutor_programa = "S" THEN
        SET NEW.tutor_programa_numero = 0;
    ELSE
        SET NEW.tutor_programa_numero = 1;
    END IF;
END$$


#----------------------------------------------------------------


DROP TRIGGER IF EXISTS `cascada_actualizar_padre_departamento`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `cascada_actualizar_padre_departamento` AFTER UPDATE ON `Departamento` 
FOR EACH ROW BEGIN
    UPDATE Materia SET Materia.departamento_id = NEW.departamento_id WHERE Materia.departamento_id = OLD.departamento_id;
END$$

DROP TRIGGER IF EXISTS `restringir_eliminar_padre_departamento`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `restringir_eliminar_padre_departamento` AFTER DELETE ON `Departamento` 
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Materia WHERE Materia.departamento_id = OLD.departamento_id) <> 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede eliminar el registro. La llave foránea existe en la tabla Materia.';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` TRIGGER `prevenir_insertar_hijo_departamento` BEFORE INSERT ON `Departamento`
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Centro WHERE Centro.centro_id = NEW.centro_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Centro.';
    END IF;

    IF((SELECT COUNT(*) FROM Departamento WHERE Departamento.departamento_id = NEW.departamento_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (departamento_id) ya existe en la tabla Departamento.';
    END IF;
END$$

DROP TRIGGER IF EXISTS `prevenir_actualizar_hijo_departamento`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `prevenir_actualizar_hijo_departamento` BEFORE UPDATE ON `Departamento` 
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Centro WHERE Centro.centro_id = NEW.centro_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Centro.';
    END IF;

    IF(OLD.departamento_id <> NEW.departamento_id AND (SELECT COUNT(*) FROM Departamento WHERE Departamento.departamento_id = NEW.departamento_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (departamento_id) ya existe en la tabla Departamento.';
    END IF;
END$$


#----------------------------------------------------------------


DROP TRIGGER IF EXISTS `cascada_actualizar_padre_materia`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `cascada_actualizar_padre_materia` AFTER UPDATE ON `Materia` 
FOR EACH ROW BEGIN
    UPDATE Solicitud SET Solicitud.materia_id = NEW.materia_id WHERE Solicitud.materia_id = OLD.materia_id;
    UPDATE Materia_Tutor SET Materia_Tutor.materia_id = NEW.materia_id WHERE Materia_Tutor.materia_id = OLD.materia_id;
    UPDATE Materia_Plan SET Materia_Plan.materia_id = NEW.materia_id WHERE Materia_Plan.materia_id = OLD.materia_id;
END$$

DROP TRIGGER IF EXISTS `cascada_eliminar_padre_materia`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `cascada_eliminar_padre_materia` AFTER DELETE ON `Materia` 
FOR EACH ROW BEGIN
    DELETE FROM Solicitud WHERE Solicitud.materia_id = OLD.materia_id;
    DELETE FROM Materia_Tutor WHERE Materia_Tutor.materia_id = OLD.materia_id;  
    DELETE FROM Materia_Plan WHERE Materia_Plan.materia_id = OLD.materia_id;  
END$$

CREATE DEFINER=`root`@`localhost` TRIGGER `prevenir_insertar_hijo_materia` BEFORE INSERT ON `Materia`
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Departamento WHERE Departamento.departamento_id = NEW.departamento_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Departamento.';
    END IF;

    IF((SELECT COUNT(*) FROM Materia WHERE Materia.materia_id = NEW.materia_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (materia_id) ya existe en la tabla Materia.';
    END IF;
END$$

DROP TRIGGER IF EXISTS `prevenir_actualizar_hijo_materia`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `prevenir_actualizar_hijo_materia` BEFORE UPDATE ON `Materia` 
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Departamento WHERE Departamento.departamento_id = NEW.departamento_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Departamento.';
    END IF;

    IF(OLD.materia_id <> NEW.materia_id AND (SELECT COUNT(*) FROM Materia WHERE Materia.materia_id = NEW.materia_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (materia_id) ya existe en la tabla Materia.';
    END IF;
END$$


#----------------------------------------------------------------


DROP TRIGGER IF EXISTS `cascada_actualizar_padre_plan_estudio`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `cascada_actualizar_padre_plan_estudio` AFTER UPDATE ON `Plan_Estudio` 
FOR EACH ROW BEGIN
    UPDATE Alumno SET Alumno.plan_id = NEW.plan_id WHERE Alumno.plan_id = OLD.plan_id;
    UPDATE Materia_Plan SET Materia_Plan.plan_id = NEW.plan_id WHERE Materia_Plan.plan_id = OLD.plan_id;
END$$

DROP TRIGGER IF EXISTS `cascada_eliminar_padre_plan_estudio`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `cascada_eliminar_padre_plan_estudio` AFTER DELETE ON `Plan_Estudio` 
FOR EACH ROW BEGIN
    DELETE FROM Alumno WHERE Alumno.plan_id = OLD.plan_id;
    DELETE FROM Materia_Plan WHERE Materia_Plan.plan_id = OLD.plan_id;
END$$

CREATE DEFINER=`root`@`localhost` TRIGGER `prevenir_insertar_hijo_plan_estudio` BEFORE INSERT ON `Plan_Estudio`
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Carrera WHERE Carrera.carrera_id = NEW.carrera_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. La llave foránea no existe en la tabla Carrera.';
    END IF;

    IF((SELECT COUNT(*) FROM Plan_Estudio WHERE Plan_Estudio.plan_id = NEW.plan_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede agregar el registro. El identificador principal (plan_id) ya existe en la tabla Plan_Estudio.';
    END IF;
END$$

DROP TRIGGER IF EXISTS `prevenir_actualizar_hijo_plan_estudio`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `prevenir_actualizar_hijo_plan_estudio` BEFORE UPDATE ON `Plan_Estudio`
FOR EACH ROW BEGIN
    IF(SELECT COUNT(*) FROM Carrera WHERE Carrera.carrera_id = NEW.carrera_id) = 0 THEN
        SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. La llave foránea no existe en la tabla Carrera.';
    END IF;

    IF(OLD.plan_id <> NEW.plan_id AND (SELECT COUNT(*) FROM Plan_Estudio WHERE Plan_Estudio.plan_id = NEW.plan_id) <> 0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'No se puede actualizar el registro. El identificador principal (plan_id) ya existe en la tabla Plan_Estudio.';
    END IF;
END$$


#----------------------------------------------------------------


CREATE DEFINER=`root`@`localhost` TRIGGER `prevenir_insertar_hijo_materia_plan` BEFORE INSERT ON `Materia_Plan`
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

DROP TRIGGER IF EXISTS `prevenir_actualizar_hijo_materia_plan`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `prevenir_actualizar_hijo_materia_plan` BEFORE UPDATE ON `Materia_Plan`
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


CREATE DEFINER=`root`@`localhost` TRIGGER `prevenir_insertar_hijo_materia_tutor` BEFORE INSERT ON `Materia_Tutor`
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

DROP TRIGGER IF EXISTS `prevenir_actualizar_hijo_materia_tutor`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `prevenir_actualizar_hijo_materia_tutor` BEFORE UPDATE ON `Materia_Tutor`
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


DROP TRIGGER IF EXISTS `cascada_actualizar_padre_solicitud`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `cascada_actualizar_padre_solicitud` AFTER UPDATE ON `Solicitud` 
FOR EACH ROW BEGIN
    UPDATE Alumno_Solicitud SET Alumno_Solicitud.solicitud_id = NEW.solicitud_id WHERE Alumno_Solicitud.Solicitud_id = OLD.solicitud_id;
END$$

DROP TRIGGER IF EXISTS `cascada_eliminar_padre_solicitud`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `cascada_eliminar_padre_solicitud` AFTER DELETE ON `Solicitud` 
FOR EACH ROW BEGIN
    DELETE FROM Alumno_Solicitud WHERE Alumno_Solicitud.Solicitud_id = OLD.solicitud_id;
END$$

CREATE DEFINER=`root`@`localhost` TRIGGER `prevenir_insertar_hijo_solicitud` BEFORE INSERT ON `Solicitud`
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

DROP TRIGGER IF EXISTS `prevenir_actualizar_hijo_solicitud`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `prevenir_actualizar_hijo_solicitud` BEFORE UPDATE ON `Solicitud`
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


CREATE DEFINER=`root`@`localhost` TRIGGER `prevenir_insertar_hijo_alumno_solicitud` BEFORE INSERT ON `Alumno_Solicitud`
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

DROP TRIGGER IF EXISTS `prevenir_actualizar_hijo_alumno_solicitud`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `prevenir_actualizar_hijo_alumno_solicitud` BEFORE UPDATE ON `Alumno_Solicitud`
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
