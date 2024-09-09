CREATE TABLE universidades (
    id_universidad SERIAL NOT NULL,
    nombre VARCHAR(150),
    nombre_abreviado VARCHAR(100),
    inicial VARCHAR(50),
    estado VARCHAR(1) DEFAULT 'S',
    CONSTRAINT pk_universidades PRIMARY KEY(id_universidad)
);

CREATE TABLE configuraciones ( -- -- Las configuraciones de imagenes, cabeza, pie, Telefonos, APIKEY, etc.
    id_configuracion SERIAL NOT NULL,
	id_universidad INT NOT NULL,
    tipo VARCHAR(200),
	descripcion VARCHAR(500),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_configuraciones PRIMARY KEY(id_configuracion),
	CONSTRAINT fk_universidades_configuraciones FOREIGN KEY(id_universidad) REFERENCES universidades(id_universidad)
);

CREATE TABLE areas (
    id_area SERIAL NOT NULL,
 	id_universidad INT NOT NULL,
    nombre VARCHAR(150),
	nombre_abreviado VARCHAR(100),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_areas PRIMARY KEY(id_area),
 	CONSTRAINT fk_universidades_areas FOREIGN KEY(id_universidad) REFERENCES universidades(id_universidad)
);

CREATE TABLE facultades (
    id_facultad SERIAL NOT NULL,
	id_area INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    nombre_abreviado VARCHAR(50),
	direccion VARCHAR(100),
    telefono VARCHAR(100),
	telefono_interno VARCHAR(100),
	fax VARCHAR(20),
	email VARCHAR(30),
	latitud VARCHAR(25),
	longitud VARCHAR(25),
    fecha_creacion DATE,
    escudo VARCHAR(60),
    imagen VARCHAR(60),
    estado_virtual VARCHAR(1),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_facultades PRIMARY KEY(id_facultad),
	CONSTRAINT fk_areas_facultades FOREIGN KEY(id_area) REFERENCES areas(id_area)
);

-- --------------ROLES Y USUARIOS ----------------------------
CREATE TABLE modulos(
	id_modulo SERIAL  NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_modulos PRIMARY KEY(id_modulo)
);

CREATE TABLE menus_principales(
	id_menu_principal SERIAL NOT NULL,
	id_modulo INT NOT NULL,
	nombre VARCHAR(250) NOT NULL,
	icono VARCHAR(70),
	orden INT,
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_menus_principales PRIMARY KEY (id_menu_principal),
	CONSTRAINT fk_modulos_menus_principales FOREIGN KEY(id_modulo) REFERENCES modulos(id_modulo)
);

CREATE TABLE menus(
	id_menu	SERIAL NOT NULL,
	id_menu_principal INT NOT NULL,
	nombre VARCHAR(250) NOT NULL,
	directorio VARCHAR(350) NOT NULL,
	icono VARCHAR(70),
	imagen VARCHAR(150),
	color VARCHAR(25),
	orden INT,
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_menus PRIMARY KEY (id_menu),
	CONSTRAINT fk_menus_principales_menus FOREIGN KEY(id_menu_principal) REFERENCES menus_principales(id_menu_principal)
);

CREATE TABLE roles(
	id_rol SERIAL NOT NULL,
	nombre VARCHAR(150) NOT NULL,
	descripcion VARCHAR(200),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_roles PRIMARY KEY (id_rol)
);

CREATE TABLE roles_menus_principales(
	id_rol_menu_principal SERIAL NOT NULL,
	id_rol INT NOT NULL,
	id_menu_principal INT NOT NULL,-- -- cambiar a menus
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_roles_menus_principales PRIMARY KEY(id_rol_menu_principal),
	CONSTRAINT fk_roles_roles_menus_principales FOREIGN KEY(id_rol) REFERENCES roles(id_rol),
	CONSTRAINT fk_menus_principales_roles_menus_principales FOREIGN KEY(id_menu_principal) REFERENCES menus_principales(id_menu_principal)
);