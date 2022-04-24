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

/* Procedimiento almacenado para insertar mantenimientos de vehiculo */
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


CALL sp_insertar_tipo_mantenimiento_vehiculo('Revisión General');
CALL sp_insertar_tipo_mantenimiento_vehiculo('Cambio de aceite');
CALL sp_insertar_tipo_mantenimiento_vehiculo('Cambio de llantas');

/* Procedimiento almacenado para insertar tipos de vehiculo */
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

CALL sp_insertar_tipo_vehiculo('Moto');
CALL sp_insertar_tipo_vehiculo('Todo Terreno');
CALL sp_insertar_tipo_vehiculo('Sedan');

/* Procedimiento almacenado para insertar tipos de envio de paqueteria */
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

CALL sp_insertar_tipo_envio_paqueteria('Prioritario');
CALL sp_insertar_tipo_envio_paqueteria('Normal');
CALL sp_insertar_tipo_envio_paqueteria('Económico');

/* Procedimiento almacenado para insertar tipos de envio de paqueteria */
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

CALL sp_insertar_tipo_cliente_paqueteria('VIP');
CALL sp_insertar_tipo_cliente_paqueteria('Normal');

/* Procedimiento almacenado para insertar tipos de envio de paqueteria */
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

CALL sp_insertar_estado_paquete_paqueteria('En Transito');
CALL sp_insertar_estado_paquete_paqueteria('En Oficina');
CALL sp_insertar_estado_paquete_paqueteria('Entregado al cliente');

/* Procedimiento almacenado para insertar puestos */
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

CALL sp_insertar_puestos('Desarrollador', 1500000);
CALL sp_insertar_puestos('Desarrollador Junior', 800000);
CALL sp_insertar_puestos('DBA', 2000000);

/* Procedimiento almacenado para insertar oficinas */
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

CALL sp_insertar_oficinas('La Central', "Cartago", 22305656);
CALL sp_insertar_oficinas('Zapote', "San José", 22305658);
CALL sp_insertar_oficinas('San Pedro', "San José", 22305657);

/* Procedimiento almacenado para insertar direcciones */
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

CALL sp_insertar_direcciones('San José', "Aserrí", "Vuelta de Jorco" , "100 sur del centro educativo");
CALL sp_insertar_direcciones('Cartago', "Taras", "Taras" , "100 norte de la iglesia");
CALL sp_insertar_direcciones('San José', "San José Centro", "San José Centro" , "100 sur del HSJD");


/* Procedimiento almacenado para insertar empleados */
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

CALL sp_insertar_empleados(123456787,1 , 1, 1, "activo",22/03/2022, "Bob", "Mora", "Lopez", "David", 20/03/2022);








