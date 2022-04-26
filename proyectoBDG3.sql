CREATE DATABASE IF NOT EXISTS BDProyecto;
USE BDProyecto;

/*drop database BDProyecto;*/

CREATE TABLE IF NOT EXISTS tab_puestos(
	id_puesto int auto_increment primary key not null, 
	puesto_nombre varchar(50) not null,
	puesto_salario float not null);

CREATE TABLE IF NOT EXISTS tab_oficinas(
	id_oficina int auto_increment primary key not null,
	oficina_nombre varchar(50) not null,
	oficina_ubicacion varchar(50) not null,
	oficina_telefono int not null
);

CREATE TABLE IF NOT EXISTS tab_direcciones(    
	id_direccion int auto_increment primary key not null,
	direccion_provincia varchar(50) not null,
	direccion_canton varchar(50) not null,
	direccion_distrito varchar(50) not null,
	direccion_otras_senas varchar(500)
);


CREATE TABLE IF NOT EXISTS tab_empleados(
	empleado_identificacion int(50) primary key not null,
    id_empleado_puesto int not null,
    id_empleado_oficina_asignada int not null,
    id_empleado_direccion int not null,
    empleado_estado varchar(50) not null,
    empleado_fecha_registro date not null,
    empleado_nombre_usuario_registro varchar(50) not null,
    empleado_apellido_1 varchar(50) not null,
	empleado_apellido_2 varchar(50) not null,
    empleado_nombre varchar(50) not null,
    empleado_fecha_nac date not null,
    foreign key(id_empleado_puesto) references tab_puestos(id_puesto),
    foreign key(id_empleado_oficina_asignada) references tab_oficinas(id_oficina),
    foreign key(id_empleado_direccion) references tab_direcciones(id_direccion)
);

CREATE TABLE IF NOT EXISTS tab_correos(
	id_correo int auto_increment primary key not null,
	identificacion_usuario_correo int(50) not null,
	correo varchar(50) not null,
    foreign key (identificacion_usuario_correo) references tab_empleados(empleado_identificacion) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS tab_telefonos(
	id_telefono int auto_increment primary key not null,
	identificacion_usuario_telefono int(50) not null,
	telefono int not null,
    foreign key (identificacion_usuario_telefono) references tab_empleados(empleado_identificacion) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS tab_tipo_vehiculo(
	id_tipo_vehiculo int auto_increment primary key not null,
	vehiculo_tipo varchar(50) not null
);

CREATE TABLE IF NOT EXISTS tab_inventario_vehiculos(
	id_inventario_vehiculo int auto_increment primary key not null,
	id_tipo_vehiculo int not null,
	vehiculo_num_interno int not null,
	vehiculo_num_placa varchar(50) not null,
	vehiculo_marca varchar(50) not null,
	vehiculo_modelo varchar(50) not null,
	vehiculo_stock varchar(50) not null,
	vehiculo_estado varchar(50) not null,
	vehiculo_fecha_registro date not null,
    foreign key(id_tipo_vehiculo) references tab_tipo_vehiculo(id_tipo_vehiculo)
);

CREATE TABLE IF NOT EXISTS tab_tipo_mantenimiento_vehiculo(
	id_tipo_mantenimiento_vehiculo int auto_increment primary key not null,
	tipo_mantenimiento_vehiculo varchar(50) not null
    );



CREATE TABLE IF NOT EXISTS tab_revision_vehiculos(
	id_revision_vehiculo int auto_increment primary key not null,
	id_inventario_vehiculo int not null,
	id_tipo_mantenimiento_vehiculo int not null,
	revision_fecha_mantenimiento date not null,
	revision_descripcion_mantenimiento varchar(50) not null,
    foreign key (id_inventario_vehiculo) references tab_inventario_vehiculos(id_inventario_vehiculo),
    foreign key(id_tipo_mantenimiento_vehiculo) references tab_tipo_mantenimiento_vehiculo(id_tipo_mantenimiento_vehiculo)
);

CREATE TABLE IF NOT EXISTS tab_tipo_cliente_paqueteria(
	id_tipo_cliente_paqueteria int auto_increment primary key not null,
	tipo_cliente_paqueteria varchar(50) not null
);

CREATE TABLE IF NOT EXISTS tab_clientes(
	cliente_identificacion int(50) primary key not null,
	id_tipo_cliente_paqueteria int not null,
	cliente_apellido_1 varchar(50) not null,
	cliente_apellido_2 varchar(50) not null,
	cliente_nombre varchar(50) not null,
    foreign key (id_tipo_cliente_paqueteria) references tab_tipo_cliente_paqueteria(id_tipo_cliente_paqueteria)
);

CREATE TABLE IF NOT EXISTS tab_tipo_envio_paqueteria(
	id_tipo_envio_paqueteria int auto_increment primary key not null,
	tipo_envio_paqueteria varchar(50) not null
);

CREATE TABLE IF NOT EXISTS tab_estado_paquete_paqueteria(
	id_estado_paquete_paqueteria int auto_increment primary key not null, 
	estado_paquete_paqueteria varchar(50) not null
);

CREATE TABLE IF NOT EXISTS tab_facturacion_paqueteria(
	id_factura int auto_increment primary key not null,
	id_cliente_factura int not null,
	factura_numero int not null,
	factura_fecha datetime not null,
	factura_costo_impuestos float not null,
	factura_costo_flete float not null,
	factura_costo_iva float not null,
	factura_total_por_envio float not null,
	factura_total_antes_iva float not null,
	factura_total float not null,
	factura_estado varchar(50) not null,
	factura_usuario_registro varchar(50) not null,
    foreign key (id_cliente_factura) references tab_clientes(cliente_identificacion)
);

CREATE TABLE IF NOT EXISTS tab_paqueteria(
	id_paqueteria int auto_increment primary key not null,
	id_cliente int(50) not null,
	id_oficina int not null,
	id_empleado_proceso int not null,
	id_tipo_envio_paqueteria int not null,
	id_estado_paquete_paqueteria int not null,
    id_factura_paquete int not null,
	paqueteria_numero int not null,
	paqueteria_usuario_registro varchar(50) not null,
	paqueteria_descripcion varchar(500) not null,
	paqueteria_fecha_registro date not null,
    foreign key (id_cliente) references tab_clientes(cliente_identificacion),
    foreign key (id_oficina) references tab_oficinas(id_oficina),
    foreign key (id_empleado_proceso) references tab_empleados(empleado_identificacion),
    foreign key (id_tipo_envio_paqueteria) references tab_tipo_envio_paqueteria(id_tipo_envio_paqueteria),
    foreign key (id_estado_paquete_paqueteria) references tab_estado_paquete_paqueteria(id_estado_paquete_paqueteria),
    foreign key (id_factura_paquete) references tab_facturacion_paqueteria(id_factura)
);



/* Procedimiento almacenado para insertar, eliminar y actulizar mantenimientos de vehiculo */
DELIMITER $$
CREATE PROCEDURE sp_insertar_tipo_mantenimiento_vehiculo
(
in tipo_mantenimiento_vehiculo varchar(50)
)
BEGIN
insert into tab_tipo_mantenimiento_vehiculo(tipo_mantenimiento_vehiculo) 					
			values(tipo_mantenimiento_vehiculo);
END$$
Delimiter ;

DELIMITER $$
CREATE PROCEDURE sp_eliminar_tipo_mantenimiento_vehiculo
(
in id_tip int
)
BEGIN
DELETE FROM tab_tipo_mantenimiento_vehiculo WHERE id_tipo_mantenimiento_vehiculo=id_tip;
END$$
Delimiter ;

DELIMITER $$
CREATE PROCEDURE sp_actualizar_tipo_mantenimiento_vehiculo
(
in id_tipo int,
in tipo_mantenimiento varchar(50)
)
BEGIN
UPDATE tab_tipo_mantenimiento_vehiculo SET tipo_mantenimiento_vehiculo=tipo_mantenimiento
WHERE id_tipo_mantenimiento_vehiculo=id_tipo;
END$$
Delimiter ;

/* Insertar*/
CALL sp_insertar_tipo_mantenimiento_vehiculo('Revisión General');
CALL sp_insertar_tipo_mantenimiento_vehiculo('Cambio de aceite');
CALL sp_insertar_tipo_mantenimiento_vehiculo('Cambio de llantas');
CALL sp_insertar_tipo_mantenimiento_vehiculo('Modificar e eliminar');


/* Actulizar*/
CALL sp_actualizar_tipo_mantenimiento_vehiculo(4, 'Modificado');

/* Eliminar*/
CALL sp_eliminar_tipo_mantenimiento_vehiculo(4);



/* Procedimiento almacenados para insertar, eliminar y actulizar tipos de vehiculo */
DELIMITER $$
CREATE PROCEDURE sp_insertar_tipo_vehiculo
(
in vehiculo_tipo varchar(50)
)
BEGIN
insert into tab_tipo_vehiculo(vehiculo_tipo) 					
			values(vehiculo_tipo);
END$$
Delimiter ;

DELIMITER $$
CREATE PROCEDURE sp_eliminar_tipo_vehiculo
(
in id_tipo int
)
BEGIN
DELETE FROM tab_tipo_vehiculo WHERE id_tipo_vehiculo=id_tipo;
END$$
Delimiter ;

DELIMITER $$
CREATE PROCEDURE sp_actualizar_tipo_vehiculo
(
in id_tipo int,
in vehiculo varchar(50)
)
BEGIN
UPDATE tab_tipo_vehiculo SET vehiculo_tipo=vehiculo WHERE id_tipo_vehiculo=id_tipo;
END$$
Delimiter ;

/* Insertar*/
CALL sp_insertar_tipo_vehiculo('Moto');
CALL sp_insertar_tipo_vehiculo('Todo Terreno');
CALL sp_insertar_tipo_vehiculo('Sedan');
CALL sp_insertar_tipo_vehiculo('Modificar e eliminar');

/* Actulizar*/
CALL sp_actualizar_tipo_vehiculo(4, 'Modificado');

/* Eliminar*/
CALL sp_eliminar_tipo_vehiculo(4);




/* Procedimiento almacenado para insertar, eliminar y actulizar tipos de envio de paqueteria */
DELIMITER $$
CREATE PROCEDURE sp_insertar_tipo_envio_paqueteria
(
in tipo_envio_paqueteria varchar(50)
)
BEGIN
insert into tab_tipo_envio_paqueteria(tipo_envio_paqueteria) 					
			values(tipo_envio_paqueteria);
END$$
Delimiter ;

DELIMITER $$
CREATE PROCEDURE sp_eliminar_tipo_envio_paqueteria
(
in id_tipo_envio int
)
BEGIN
DELETE FROM tab_tipo_envio_paqueteria WHERE id_tipo_envio_paqueteria=id_tipo_envio;
END$$
Delimiter ;

DELIMITER $$
CREATE PROCEDURE sp_actualizar_tipo_envio_paqueteria
(
in id_tipo_envioa int,
in tipo_envio varchar(50)
)
BEGIN
UPDATE tab_tipo_envio_paqueteria SET tipo_envio_paqueteria=tipo_envio 
WHERE id_tipo_envio_paqueteria=id_tipo_envioa;
END$$
Delimiter ;

/* Insertar*/
CALL sp_insertar_tipo_envio_paqueteria('Prioritario');
CALL sp_insertar_tipo_envio_paqueteria('Normal');
CALL sp_insertar_tipo_envio_paqueteria('Económico');
CALL sp_insertar_tipo_envio_paqueteria('Modificar e eliminar');

/* Actualizar*/
CALL sp_actualizar_tipo_envio_paqueteria(4,'Modificado');

/* Eliminar*/
CALL sp_eliminar_tipo_envio_paqueteria(4);




/* Procedimiento almacenado para insertar, modificar y actulizar tipos de envio de paqueteria */
DELIMITER $$
CREATE PROCEDURE sp_insertar_tipo_cliente_paqueteria
(
in tipo_cliente_paqueteria varchar(50)
)
BEGIN
insert into tab_tipo_cliente_paqueteria(tipo_cliente_paqueteria) 					
			values(tipo_cliente_paqueteria);
END$$
Delimiter ;

DELIMITER $$
CREATE PROCEDURE sp_eliminar_tipo_cliente_paqueteria
(
in id_tipo_cliente int
)
BEGIN
DELETE FROM tab_tipo_cliente_paqueteria WHERE id_tipo_cliente_paqueteria=id_tipo_cliente;
END$$
Delimiter ;

DELIMITER $$
CREATE PROCEDURE sp_actualizar_tipo_cliente_paqueteria
(
in id_tipo_cliente int,
in tipo_cliente varchar(50)
)
BEGIN
UPDATE tab_tipo_cliente_paqueteria SET tipo_cliente_paqueteria=tipo_cliente 
WHERE id_tipo_cliente_paqueteria=id_tipo_cliente;
END$$
Delimiter ;

/* Insertar*/
CALL sp_insertar_tipo_cliente_paqueteria('VIP');
CALL sp_insertar_tipo_cliente_paqueteria('Normal');
CALL sp_insertar_tipo_cliente_paqueteria('Modificar e Eliminar');

/* Actulizar*/
CALL sp_actualizar_tipo_cliente_paqueteria(3,'Modificado');

/* Eliminar*/
CALL sp_eliminar_tipo_cliente_paqueteria(3);




/* Procedimiento almacenado para insertar, modificar y eliminar tipos de envio de paqueteria */
DELIMITER $$
CREATE PROCEDURE sp_insertar_estado_paquete_paqueteria
(
in estado_paquete_paqueteria varchar(50)
)
BEGIN
insert into tab_estado_paquete_paqueteria(estado_paquete_paqueteria) 					
			values(estado_paquete_paqueteria);
END$$
Delimiter ;

DELIMITER $$
CREATE PROCEDURE sp_eliminar_estado_paquete_paqueteria
(
in id_estado_paquete int
)
BEGIN
DELETE FROM tab_estado_paquete_paqueteria WHERE id_estado_paquete_paqueteria=id_estado_paquete;
END$$
Delimiter ;

DELIMITER $$
CREATE PROCEDURE sp_actualizar_estado_paquete_paqueteria
(
in id_estado_paquete int,
in estado_paquete varchar(50)
)
BEGIN
UPDATE tab_estado_paquete_paqueteria SET estado_paquete_paqueteria=estado_paquete 
WHERE id_estado_paquete_paqueteria=id_estado_paquete;
END$$
Delimiter ;

/* Insertar*/
CALL sp_insertar_estado_paquete_paqueteria('En Transito');
CALL sp_insertar_estado_paquete_paqueteria('En Oficina');
CALL sp_insertar_estado_paquete_paqueteria('Entregado al cliente');
CALL sp_insertar_estado_paquete_paqueteria('Modificar e eliminar');

/* Actulizar*/
CALL sp_actualizar_estado_paquete_paqueteria(4,'Modificado');

/* Eliminar*/
CALL sp_eliminar_estado_paquete_paqueteria(4);



/* Procedimiento almacenado para insertar, modificar y eliminar puestos */
DELIMITER $$
CREATE PROCEDURE sp_insertar_puestos
(
in puesto_nombre varchar(50),
in	puesto_salario float 
)
BEGIN
insert into tab_puestos(puesto_nombre, puesto_salario) 					
			values(puesto_nombre, puesto_salario);
END$$
Delimiter ;

DELIMITER $$
CREATE PROCEDURE sp_eliminar_puestos
(
in id int
)
BEGIN
DELETE FROM tab_puestos WHERE id_puesto=id;
END$$
Delimiter ;

DELIMITER $$
CREATE PROCEDURE sp_actualizar_puestos
(
in id int,
nombre varchar(50),
salario float
)
BEGIN
UPDATE tab_puestos SET puesto_nombre=nombre, puesto_salario=salario WHERE id_puesto=id;
END$$
Delimiter ;

/* Insertar*/
CALL sp_insertar_puestos('Desarrollador', 1500000);
CALL sp_insertar_puestos('Desarrollador Junior', 800000);
CALL sp_insertar_puestos('DBA', 2000000);
CALL sp_insertar_puestos('Modificar e eliminar', 2000000);

/* Actulizar*/
CALL sp_actualizar_puestos(4,'Modificar', 2100000);

/* Eliminar*/
CALL sp_eliminar_puestos(4);




/* Procedimientos almacenados para insertar, modificar y eliminar  oficinas */
DELIMITER $$
CREATE PROCEDURE sp_insertar_oficinas
(
in oficina_nombre varchar(50),
in	oficina_ubicacion varchar(50),
in	oficina_telefono int
)
BEGIN
insert into tab_oficinas(oficina_nombre, oficina_ubicacion, oficina_telefono) 					
			values(oficina_nombre, oficina_ubicacion, oficina_telefono);
END$$
Delimiter ;

DELIMITER $$
CREATE PROCEDURE sp_eliminar_oficinas
(
in id int
)
BEGIN
DELETE FROM tab_oficinas WHERE id_oficina=id;
END$$
Delimiter ;

DELIMITER $$
CREATE PROCEDURE sp_actualizar_oficinas
(
in id int,
nombre varchar(50),
ubicacion varchar(50), 
telefono int(11)
)
BEGIN
UPDATE tab_oficinas SET oficina_nombre=nombre, oficina_ubicacion=ubicacion, oficina_telefono=telefono  
WHERE id_oficina=id;
END$$
Delimiter ;

/* Insertar*/
CALL sp_insertar_oficinas('La Central', "Cartago", 22305656);
CALL sp_insertar_oficinas('Zapote', "San José", 22305658);
CALL sp_insertar_oficinas('San Pedro', "San José", 22305657);
CALL sp_insertar_oficinas('Modificar', "Eliminar", 22305657);

/* Modificar*/
CALL sp_actualizar_oficinas(4,'Modificado', "Modificado", 22305659);

/* Eliminar*/
CALL sp_eliminar_oficinas(4);



/* Procedimientos almacenados para insertar, modificar y eliminar direcciones */
DELIMITER $$
CREATE PROCEDURE sp_insertar_direcciones
(
in direccion_provincia varchar(50),
in	direccion_canton varchar(50),
in	direccion_distrito varchar(50),
in	direccion_otras_senas varchar(500)
)
BEGIN
insert into tab_direcciones(direccion_provincia, direccion_canton, direccion_distrito, direccion_otras_senas) 					
			values(direccion_provincia, direccion_canton, direccion_distrito, direccion_otras_senas);
END$$
Delimiter ;

DELIMITER $$
CREATE PROCEDURE sp_eliminar_direcciones
(
in id int
)
BEGIN
DELETE FROM tab_direcciones WHERE id_direccion=id;
END$$
Delimiter ;

DELIMITER $$
CREATE PROCEDURE sp_actualizar_direcciones
(
in id int,
provincia varchar(50), 
canton varchar(50), 
distrito varchar(50), 
otras_senas varchar(500)
)
BEGIN
UPDATE tab_direcciones SET direccion_provincia=provincia, direccion_canton=canton,
direccion_distrito=distrito, direccion_otras_senas=otras_senas WHERE id_direccion=id;
END$$
Delimiter ;

/* Insertar*/
CALL sp_insertar_direcciones('San José', "Aserrí", "Vuelta de Jorco" , "100 sur del centro educativo");
CALL sp_insertar_direcciones('Cartago', "Taras", "Taras" , "100 norte de la iglesia");
CALL sp_insertar_direcciones('San José', "San José Centro", "San José Centro" , "100 sur del HSJD");
CALL sp_insertar_direcciones('Modificado Eliminar', "Modificado Eliminar", "Modificado Eliminar" , "Modificado Eliminar");

/* Actulizar*/
CALL sp_actualizar_direcciones(4, 'Modificado', "Modificado", "Modificado" , "Modificado");

/* Eliminar*/
CALL sp_eliminar_direcciones(4);



/* Procedimientos almacenados para insertar, actualizar y eliminar empleados */
DELIMITER $$ 
CREATE PROCEDURE sp_insertar_empleados
(
in empleado_identificacion int(50),
in id_empleado_puesto int,
  in   id_empleado_oficina_asignada int ,
   in  id_empleado_direccion int ,
   in  empleado_estado varchar(50),
   in  empleado_fecha_registro date ,
   in  empleado_nombre_usuario_registro varchar(50),
   in  empleado_apellido_1 varchar(50) ,
	in empleado_apellido_2 varchar(50) ,
  in   empleado_nombre varchar(50) ,
   in  empleado_fecha_nac date
)
BEGIN
insert into tab_empleados(empleado_identificacion, id_empleado_puesto, id_empleado_oficina_asignada, id_empleado_direccion, empleado_estado,
						  empleado_fecha_registro, empleado_nombre_usuario_registro, empleado_apellido_1, empleado_apellido_2, empleado_nombre, empleado_fecha_nac) 
                          
			values(empleado_identificacion,id_empleado_puesto, id_empleado_oficina_asignada, id_empleado_direccion, empleado_estado,
						  empleado_fecha_registro, empleado_nombre_usuario_registro, empleado_apellido_1, empleado_apellido_2, empleado_nombre, empleado_fecha_nac);
END$$
Delimiter ;

DELIMITER $$
CREATE PROCEDURE sp_eliminar_empleados
(
in identificacion int
)
BEGIN
DELETE FROM tab_empleados WHERE empleado_identificacion=identificacion;
END$$
Delimiter ;

DELIMITER $$
CREATE PROCEDURE sp_actualizar_empleados
(
in identificacion int,
puesto int(11), 
oficina_asignada int(11), 
direccion int(11), 
estado varchar(50), 
fecha_registro date, 
usuario_registro varchar(50), 
apellido_1 varchar(50), 
apellido_2 varchar(50), 
nombre varchar(50), 
fecha_nac date
)
BEGIN
UPDATE tab_empleados SET id_empleado_puesto=puesto, id_empleado_oficina_asignada=oficina_asignada,
id_empleado_direccion=direccion, empleado_estado=estado, empleado_fecha_registro=fecha_registro,
empleado_nombre_usuario_registro=usuario_registro, empleado_apellido_1=apellido_1,
empleado_apellido_2=apellido_2, empleado_nombre=nombre, empleado_fecha_nac=fecha_nac 
WHERE empleado_identificacion=identificacion;
END$$
Delimiter ;

/* Insertar*/
CALL sp_insertar_empleados(123456787,1 , 1, 1, "activo",22/03/2022, "Bob", "Mora", "Lopez", "David", 20/03/2022);
CALL sp_insertar_empleados(987654321,2 , 2, 2, "activo",02/03/2001, "Modificar Eliminar", "Modificar Eliminar", "Modificar Eliminar", "Modificar Eliminar", 20/03/2001);

/* Actulizar*/
CALL sp_actualizar_empleados(987654321, 1 , 1, 1, "activo",02/03/2002, "Modificar", "Modificar", "Modificar", "Modificar", 20/03/2020);

/* Eliminar*/
CALL sp_eliminar_empleados(987654321);







