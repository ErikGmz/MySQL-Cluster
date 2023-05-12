# Clúster de MySQL construido con Docker Compose.

_**Descripción general:**
Clúster de MySQL estructurado con un nodo de administración, dos de datos y otro de cliente._

## Ejecución del entorno
>_**1.** Abrir una terminal en el directorio del proyecto y ejecutar Docker Compose:_
>```
>$ docker-compose up
>```
>
>_**2.** Verificar que los cuatro contenedores generados se encuentren corriendo:_
>```
>$ docker ps
>```
>
>_**3.** Probar las conexiones con el cliente de MySQL y establecer una conexión como usuario root:_
>```
>$ docker exec -it mysql1 mysql -u root -p
>```

## Verificación del entorno
>_**1.** Verificar el estado de la base de datos:_
>```
>mysql> USE bd_tutorias;
>mysql> SHOW TABLES;
>+-----------------------+
>| Tables_in_bd_tutorias |
>+-----------------------+
>| Alumno                |
>| Alumno_Solicitud      |
>| Carrera               |
>| Centro                |
>| Departamento          |
>| Materia               |
>| Materia_Plan          |
>| Materia_Tutor         |
>| Plan_Estudio          |
>| Solicitud             |
>| Tutor                 |
>+-----------------------+
>11 rows in set (0.01 sec)
>```
>
>_**2.** Revisar si las tablas Centro, Carrera y Departamento tienen registros:_
>```
>mysql> SELECT * FROM Centro;
>mysql> SELECT * FROM Carrera;
>mysql> SELECT * FROM Departamento;
>```

## Detención del entorno
>_**1.** Ejecutar el siguiente comando dentro del directorio del proyecto:_
>```
>$ docker-compose down
>```
>
>_**2.** Verificar si los cuatro contenedores ya no existen:_
>```
>$ docker ps
>$ docker ps -a
>```
