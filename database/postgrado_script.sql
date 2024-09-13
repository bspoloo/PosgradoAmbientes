-- -------------------------------------------------------------------------------------------
-- ------- BASE DE DATOS ACADEMICO (c) DERECHOS RESERVADOS POR SEGURIDAD ---------------------
-- -------------------------------------------------------------------------------------------

-- ------------- Nombre de la Base de Datos: dbpostgradovirtual --------------------------------------

-- --Falta modelar calendario academico postgrado

-- -------------------------------------------------------------------------------------------
-- ------------------------- TABLAS COMUNES A VARIOS MODULOS ---------------------------------
-- -------------------------------------------------------------------------------------------
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
	id_menu_principal INT NOT NULL,
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_roles_menus_principales PRIMARY KEY(id_rol_menu_principal),
	CONSTRAINT fk_roles_roles_menus_principales FOREIGN KEY(id_rol) REFERENCES roles(id_rol),
	CONSTRAINT fk_menus_principales_roles_menus_principales FOREIGN KEY(id_menu_principal) REFERENCES menus_principales(id_menu_principal)
);

-- -------------------------------- GESTION DE AMBIENTES -----------------------------
CREATE TABLE campus (
    id_campu SERIAL NOT NULL,
    nombre VARCHAR(70),
	direccion VARCHAR(255),
	poligono VARCHAR(5000), -- -- puntos que dibujan el campus sobre el mapa como un area con un poligono relleno de un color
    latitud VARCHAR(30),
	longitud VARCHAR(30),
    imagen VARCHAR(255),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_campus PRIMARY KEY(id_campu)
);

CREATE TABLE edificios (
    id_edificio SERIAL NOT NULL,
    id_campu INT,
    nombre VARCHAR(70),
    direccion VARCHAR(90),
    latitud VARCHAR(30),
    longitud VARCHAR(30),
    imagen VARCHAR(255),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_edificios PRIMARY KEY(id_edificio),
	CONSTRAINT fk_campus_edificios FOREIGN KEY(id_campu) REFERENCES campus(id_campu)
);

CREATE TABLE facultades_edificios (
    id_facultad_edificio SERIAL NOT NULL,
    id_facultad INT,
	id_edificio INT,
	fecha_asignacion DATE,
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_facultades_edificios PRIMARY KEY(id_facultad_edificio),
	CONSTRAINT fk_facultades_facultades_edificios FOREIGN KEY(id_facultad) REFERENCES facultades(id_facultad),
	CONSTRAINT fk_edificios_facultades_edificios FOREIGN KEY(id_edificio) REFERENCES edificios(id_edificio)
);

CREATE TABLE bloques (
    id_bloque SERIAL NOT NULL,
    id_edificio INT,
    nombre VARCHAR(70),
    imagen VARCHAR(255),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_bloques PRIMARY KEY(id_bloque),
	CONSTRAINT fk_edificios_bloques FOREIGN KEY(id_edificio) REFERENCES edificios(id_edificio)
);

CREATE TABLE pisos (
    id_piso SERIAL NOT NULL,
    numero INT, -- ---------------- Piso -2, -1, 0, 1,2,3,4,5,6,7,8,9,10
    nombre VARCHAR(30), -- -------- -2=subsuelo,-1=planta baja, 0=piso 0, 1=primer piso, etc
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_pisos PRIMARY KEY(id_piso)
);

CREATE TABLE pisos_bloques (
    id_piso_bloque SERIAL NOT NULL,
    id_bloque INT,
    id_piso INT,
    nombre VARCHAR(30),
    cantidad_ambientes INT,
    imagen VARCHAR(200),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_pisos_bloques PRIMARY KEY(id_piso_bloque),
	CONSTRAINT fk_bloques_pisos_bloques FOREIGN KEY(id_bloque) REFERENCES bloques(id_bloque),
	CONSTRAINT fk_pisos_pisos_bloques FOREIGN KEY(id_piso) REFERENCES pisos(id_piso)
);

CREATE TABLE tipos_ambientes (
    id_tipo_ambiente SERIAL NOT NULL,
    nombre VARCHAR(30),	-- ------ Ambiente, Laboratorio Computacion, 
    icono VARCHAR(200),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_tipos_ambientes PRIMARY KEY(id_tipo_ambiente)
);

CREATE TABLE ambientes (
    id_ambiente SERIAL NOT NULL,
    id_piso_bloque INT,
    id_tipo_ambiente INT,
    nombre VARCHAR(30),
    codigo VARCHAR(30),
    capacidad INT, -- --aqui indica la capacidad del ambiente y si el lab. de computacion indica la capacidad del lab.
	metro_cuadrado FLOAT, -- --metro cuadrado del ambiente
    imagen_exterior VARCHAR(255),
    imagen_interior VARCHAR(255),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_ambientes PRIMARY KEY(id_ambiente),
	CONSTRAINT fk_pisos_bloques_ambientes FOREIGN KEY(id_piso_bloque) REFERENCES pisos_bloques(id_piso_bloque),
	CONSTRAINT fk_tipos_ambientes_ambientes FOREIGN KEY(id_tipo_ambiente) REFERENCES tipos_ambientes(id_tipo_ambiente)
);
-- ------------------------------------------------------------------------------paises
CREATE TABLE paises (
    id_pais SERIAL NOT NULL,
    nombre VARCHAR(30) NOT NULL,
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_paises PRIMARY KEY(id_pais)
);

CREATE TABLE departamentos (
    id_departamento SERIAL NOT NULL,
    id_pais INT NOT NULL,
	nombre VARCHAR(30),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_departamentos PRIMARY KEY(id_departamento),
	CONSTRAINT fk_paises_departamentos FOREIGN KEY(id_pais) REFERENCES paises(id_pais)
);

CREATE TABLE provincias (
    id_provincia SERIAL NOT NULL,
	id_departamento INT NOT NULL,
    nombre VARCHAR(40),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_provincias PRIMARY KEY(id_provincia),
	CONSTRAINT fk_departamentos_provincias FOREIGN KEY(id_departamento) REFERENCES departamentos(id_departamento)
);

CREATE TABLE localidades (
    id_localidad SERIAL NOT NULL,
    id_provincia INT NOT NULL,
    nombre VARCHAR(40) NOT NULL,
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_localidades PRIMARY KEY(id_localidad),
	CONSTRAINT fk_provincias_localidades FOREIGN KEY(id_provincia) REFERENCES provincias(id_provincia)
);

CREATE TABLE grupos_sanguineos(
	id_grupo_sanguineo SERIAL NOT NULL,
	nombre VARCHAR(15) NOT NULL,
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_grupos_sanguineos PRIMARY KEY(id_grupo_sanguineo)
);

CREATE TABLE sexos(
	id_sexo SERIAL NOT NULL,
	nombre VARCHAR(15) NOT NULL,
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_sexos PRIMARY KEY(id_sexo)
);

CREATE TABLE estados_civiles(
	id_estado_civil SERIAL NOT NULL,
	nombre VARCHAR(15) NOT NULL, -- -- soltero, casado, divorciado, viudo
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_estados_civiles PRIMARY KEY(id_estado_civil)
);

CREATE TABLE emision_cedulas(
	id_emision_cedula SERIAL NOT NULL,
	nombre VARCHAR(15) NOT NULL, -- -- PT,CH,.. EX = extranjero
	descripcion VARCHAR(45),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_emision_cedulas PRIMARY KEY(id_emision_cedula)
);

CREATE TABLE personas (
	id_persona SERIAL NOT NULL,
    id_localidad INT NOT NULL,
    numero_identificacion_personal VARCHAR(15), -- --Numero de C.I. o R.U.N. o Pasaporte
	id_emision_cedula INT NOT NULL,
    paterno VARCHAR(20) NOT NULL,
    materno VARCHAR(20),
    nombres VARCHAR(65) NOT NULL,
    id_sexo INT NOT NULL,
	id_grupo_sanguineo INT NOT NULL,
    fecha_nacimiento DATE,
    direccion VARCHAR(60),
	latitud VARCHAR(30),
    longitud VARCHAR(30),
    telefono_celular VARCHAR(12),
    telefono_fijo VARCHAR(12),
    zona VARCHAR(50),
    id_estado_civil INT NOT NULL,
    email VARCHAR(50),
    fotografia VARCHAR(255) DEFAULT 'default.jpg',
    usuario VARCHAR(255),
    password VARCHAR(255),
    abreviacion_titulo VARCHAR(10),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_personas PRIMARY KEY(id_persona),
	CONSTRAINT fk_localidades_personas FOREIGN KEY(id_localidad) REFERENCES localidades(id_localidad),
	CONSTRAINT fk_sexos_personas FOREIGN KEY(id_sexo) REFERENCES sexos(id_sexo),
	CONSTRAINT fk_grupos_sanguineos_personas FOREIGN KEY(id_grupo_sanguineo) REFERENCES grupos_sanguineos(id_grupo_sanguineo),
	CONSTRAINT fk_estados_civiles_personas FOREIGN KEY(id_estado_civil) REFERENCES estados_civiles(id_estado_civil),
	CONSTRAINT fk_emision_cedulas_personas FOREIGN KEY(id_emision_cedula) REFERENCES emision_cedulas(id_emision_cedula)
);

-- --------------------------------------------------------------------
-- --------------------- MODULO PREGRADO ------------------------------
-- --------------------------------------------------------------------
CREATE TABLE carreras_niveles_academicos(
	id_carrera_nivel_academico SERIAL NOT NULL,
	nombre VARCHAR(35),
	descripcion VARCHAR(350),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_carreras_niveles_academicos PRIMARY KEY(id_carrera_nivel_academico)
);

CREATE TABLE niveles_academicos(
	id_nivel_academico SERIAL NOT NULL,
	nombre VARCHAR(35) NOT NULL,
	descripcion VARCHAR(350),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_niveles_academicos PRIMARY KEY(id_nivel_academico)
);

CREATE TABLE sedes( -- -- 1=Local Potosi, 2=Uyuni, 3=Villazon,4=Uncia
	id_sede SERIAL NOT NULL,
	nombre VARCHAR(35) NOT NULL,
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_sedes PRIMARY KEY(id_sede)
);

CREATE TABLE modalidades( -- -- Presencial, Virtual Semi Presencial
	id_modalidad SERIAL NOT NULL,
	nombre VARCHAR(100) NOT NULL,
	descripcion VARCHAR(100),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_modalidades PRIMARY KEY(id_modalidad)
);

CREATE TABLE carreras (
    id_carrera SERIAL NOT NULL,
    id_facultad INT NOT NULL,
	id_modalidad INT NOT NULL,
	id_carrera_nivel_academico INT NOT NULL,
	id_sede INT NOT NULL, -- -- Local, Provincia
	nombre VARCHAR(50) NOT NULL,
	nombre_abreviado VARCHAR(50),
    fecha_aprobacion_curriculo DATE,
    fecha_creacion DATE,
	resolucion VARCHAR(255), -- -- Un documento pdf que contiene todas las resoluciones, por ejem. HCU, DSA, HCF, certificado CEUB
    direccion VARCHAR(150),
	latitud VARCHAR(50),
	longitud VARCHAR(50),
    fax VARCHAR(20),
    telefono VARCHAR(20),
	telefono_interno VARCHAR(100),
    casilla VARCHAR(12),
    email VARCHAR(30),
    sitio_web VARCHAR(50),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_carreras PRIMARY KEY(id_carrera),
	CONSTRAINT fk_facultades_carreras FOREIGN KEY(id_facultad) REFERENCES facultades(id_facultad),
	CONSTRAINT fk_carreras_niveles_academicos_carreras FOREIGN KEY(id_carrera_nivel_academico) REFERENCES carreras_niveles_academicos(id_carrera_nivel_academico),
	CONSTRAINT fk_sedes_carreras FOREIGN KEY(id_sede) REFERENCES sedes(id_sede),
	CONSTRAINT fk_modalidades_carreras FOREIGN KEY(id_modalidad) REFERENCES modalidades(id_modalidad)
);

-- -----------------------------------------------------------------------------
-- --- tabla para usuarios del sistema (admin, administrativos(secretario),docentes,director,decano) Manejar en el Sistema -------------------
CREATE TABLE tipos_personas(  -- -- una persona puede tener mas de un rol
	id_tipo_persona SERIAL NOT NULL,
	id_persona INT NOT NULL,
	id_rol INT NOT NULL,
	tipo VARCHAR(1),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_tipos_personas PRIMARY KEY(id_tipo_persona),
	CONSTRAINT fk_personas_tipos_personas FOREIGN KEY(id_persona) REFERENCES personas(id_persona),
	CONSTRAINT fk_roles_tipos_personas FOREIGN KEY(id_rol) REFERENCES roles(id_rol)
);

CREATE TABLE personas_alumnos (
    id_persona_alumno SERIAL NOT NULL,
    id_persona INT NOT NULL,
	id_carrera INT NOT NULL,
    fecha DATE DEFAULT now(),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_alumnos PRIMARY KEY(id_persona_alumno),
	CONSTRAINT fk_personas_personas_alumnos FOREIGN KEY(id_persona) REFERENCES personas(id_persona),
	CONSTRAINT fk_carreras_personas_alumnos FOREIGN KEY(id_carrera) REFERENCES carreras(id_carrera)
);

CREATE TABLE personas_docentes (
    id_persona_docente SERIAL NOT NULL,
    id_persona INT NOT NULL,
	fecha_ingreso DATE,
    fecha DATE DEFAULT now(),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_personas_docentes PRIMARY KEY(id_persona_docente),
	CONSTRAINT fk_personas_personas_docentes FOREIGN KEY(id_persona) REFERENCES personas(id_persona)
);

CREATE TABLE personas_administrativos (
    id_persona_administrativo SERIAL NOT NULL,
    id_persona INT NOT NULL,
	cargo VARCHAR(150) , -- -- en el futuro id_cargo que hara referencia a una estructura de cargos
    fecha DATE DEFAULT now(),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_personas_administrativos PRIMARY KEY(id_persona_administrativo),
	CONSTRAINT fk_personas_personas_administrativos FOREIGN KEY(id_persona) REFERENCES personas(id_persona)
);

CREATE TABLE personas_directores_carreras (
    id_persona_director_carrera SERIAL NOT NULL,
    id_carrera INT NOT NULL,
    id_persona INT NOT NULL,
    fecha_inicio DATE,
    fecha_fin DATE,
	resolucion VARCHAR(255), -- -----imagen de la resolucion de asignacion
	firma_digital VARCHAR(255), -- -- imagen
	observacion VARCHAR(255),
    estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_personas_directores_carreras PRIMARY KEY(id_persona_director_carrera),
	CONSTRAINT fk_carreras_personas_directores_carreras FOREIGN KEY(id_carrera) REFERENCES carreras(id_carrera),
	CONSTRAINT fk_personas_personas_directores_carreras FOREIGN KEY(id_persona) REFERENCES personas(id_persona)
);

CREATE TABLE personas_decanos (
    id_persona_decano SERIAL NOT NULL,
    id_facultad INT NOT NULL,
    id_persona INT NOT NULL,
    fecha_inicio DATE,
    fecha_fin DATE,
	resolucion VARCHAR(255), -- -----imagen de la resolucion de asignacion
	firma_digital VARCHAR(255), -- -- imagen
	observacion VARCHAR(255),
    estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_personas_decanos PRIMARY KEY(id_persona_decano),
	CONSTRAINT fk_facultades_id_persona_decano FOREIGN KEY(id_facultad) REFERENCES facultades(id_facultad),
	CONSTRAINT fk_personas_id_persona_decano FOREIGN KEY(id_persona) REFERENCES personas(id_persona)
);

-- --------------------------------------------------------------------------------------------------------------
CREATE TABLE gestiones_periodos (
	id_gestion_periodo SERIAL NOT NULL,
    gestion INT NOT NULL,
    periodo INT NOT NULL,
    tipo VARCHAR(1) NOT NULL,   -- -- A=Anual, S=Semestral
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_gestiones_periodos PRIMARY KEY(id_gestion_periodo)
);

-- -------------------------------------------------------------------------------------------------------------------
CREATE TABLE tipos_evaluaciones_notas (
	id_tipo_evaluacion_nota SERIAL NOT NULL,
	nombre VARCHAR(3) NOT NULL,
	-- -- agregar labels de las dimensiones
    parcial INT DEFAULT 0,
    practica INT DEFAULT 0,
    laboratorio INT DEFAULT 0,
    examen_final INT DEFAULT 0,
	nota_minima_aprobacion INT, -- -- 51 o en otros casos 56
	-- -- Nota minima de standar colegio 
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_tipos_evaluaciones_notas PRIMARY KEY(id_tipo_evaluacion_nota)
);

-- ---------------------------------------------- HORARIOS DOCENTES ----------------------------------------------------------
CREATE TABLE dias (
    id_dia SERIAL NOT NULL,
    numero INT,
    nombre VARCHAR(30),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_dias PRIMARY KEY(id_dia)
);

CREATE TABLE horas_clases (
    id_hora_clase SERIAL NOT NULL,
    numero INT,
    hora_inicio TIME,
    hora_fin TIME,
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_horas_clases PRIMARY KEY(id_hora_clase)
);

-- ------------------------------------------ GESTION DE VENTA DE MATRICULAS --------------------------------------------------------------
CREATE TABLE cuentas_conceptos (
    id_cuenta_concepto SERIAL NOT NULL,
	nombre VARCHAR(150),
	descripcion VARCHAR(350),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_cuentas_conceptos PRIMARY KEY(id_cuenta_concepto)
);
-- --------------------------------------------------------------------------------------------------------------
-- -------------------------------- POSTGRADO ADMINISTRATIVO ----------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
CREATE TABLE personas_directores_posgrados(
	id_persona_director_posgrado SERIAL NOT NULL,
	id_persona INT NOT NULL,
	fecha_inicio DATE,
	fecha_fin DATE,
	firma_digital VARCHAR(255),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_personas_directores_posgrados PRIMARY KEY(id_persona_director_posgrado),
	CONSTRAINT fk_personas_personas_roles FOREIGN KEY(id_persona) REFERENCES personas(id_persona)
);

CREATE TABLE personas_facultades_administradores(
	id_persona_facultad_administrador SERIAL NOT NULL,
	id_persona INT NOT NULL,
	fecha_inicio DATE,
	fecha_fin DATE,
	firma_digital VARCHAR(255),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_personas_facultades_administradores PRIMARY KEY(id_persona_facultad_administrador),
	CONSTRAINT fk_personas_personas_roles FOREIGN KEY(id_persona) REFERENCES personas(id_persona)
);

CREATE TABLE personas_roles(
	id_persona_rol SERIAL NOT NULL,
	id_persona INT NOT NULL,
	id_rol INT NOT NULL,
	fecha_asignacion DATE,
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_personas_roles PRIMARY KEY(id_persona_rol),
	CONSTRAINT fk_personas_personas_roles FOREIGN KEY(id_persona) REFERENCES personas(id_persona),
	CONSTRAINT fk_roles_personas_roles FOREIGN KEY(id_rol) REFERENCES roles(id_rol)
); 

CREATE TABLE posgrados_programas(
	id_posgrado_programa SERIAL NOT NULL,
	id_nivel_academico INT NOT NULL,
	id_carrera INT NOT NULL,
	gestion INT,
	nombre VARCHAR(100),
	id_modalidad INT NOT NULL,
	fecha_inicio DATE,
	fecha_fin DATE,
	fecha_inicio_inscrito DATE,
	fecha_fin_inscrito DATE,
	numero_max_cuotas INT,
	documento VARCHAR(500),
	costo_total FLOAT,
    formato_contrato TEXT,
	formato_contrato_docente TEXT,
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_posgrados_programas PRIMARY KEY(id_posgrado_programa),
	CONSTRAINT fk_nivel_academico_programa_posgrado FOREIGN KEY(id_nivel_academico) REFERENCES niveles_academicos(id_nivel_academico),
	CONSTRAINT fk_carreras_programa_posgrado FOREIGN KEY(id_carrera) REFERENCES carreras(id_carrera),
	CONSTRAINT fk_modalidades_programa_posgrado FOREIGN KEY(id_modalidad) REFERENCES modalidades(id_modalidad)
);

CREATE TABLE personas_alumnos_posgrados(
	id_persona_alumno_posgrado SERIAL NOT NULL,
    id_persona  INT NOT NULL,
    id_posgrado_programa INT NOT NULL, 
	fecha  DATE,
    inscrito  VARCHAR(1) DEFAULT '0', -- -- se define "0" cuando es alumno y "1" cuando ya pago la matricula del programa
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_personas_alumnos_posgrados PRIMARY KEY(id_persona_alumno_posgrado),
	CONSTRAINT fk_personas_personas_alumnos_posgrados FOREIGN KEY(id_persona) REFERENCES personas(id_persona),
	CONSTRAINT fk_posgrados_programas_personas_alumnos_posgrados FOREIGN KEY(id_posgrado_programa) REFERENCES posgrados_programas(id_posgrado_programa)
);

CREATE TABLE cuentas_cargos_posgrados( -- -- Se define el tipo de pago Gral. Ejm.: SIN DESCUENTO, CON DESCUENTO DEL 10%, CON DESCUENTO DEL 5, ETC.
	id_cuenta_cargo_posgrado SERIAL NOT NULL,
	id_posgrado_programa INT NOT NULL,
	nombre VARCHAR(250),
	numero_formulario VARCHAR(250),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_cuentas_cargos_posgrados PRIMARY KEY(id_cuenta_cargo_posgrado),
	CONSTRAINT fk_posgrados_programas_cuentas_cargos_posgrados FOREIGN KEY(id_posgrado_programa) REFERENCES posgrados_programas(id_posgrado_programa)
);

CREATE TABLE cuentas_cargos_posgrados_conceptos( -- -- Permite guardar que concepto tiene descuento
	id_cuenta_cargo_posgrado_concepto SERIAL NOT NULL,
	id_cuenta_cargo_posgrado INT NOT NULL,
	id_cuenta_concepto INT NOT NULL,
	tiene_descuento VARCHAR(1),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_cuentas_cargos_posgrados_conceptos PRIMARY KEY(id_cuenta_cargo_posgrado_concepto),
	CONSTRAINT fk_cuentas_cargos_posgrados_cargos_conceptos FOREIGN KEY(id_cuenta_cargo_posgrado) REFERENCES cuentas_cargos_posgrados(id_cuenta_cargo_posgrado),
	CONSTRAINT fk_cuentas_cargos_posgrados_cuentas_cargos_conceptos FOREIGN KEY(id_cuenta_concepto) REFERENCES cuentas_conceptos(id_cuenta_concepto)
);

CREATE TABLE cuentas_cargos_conceptos_posgrados( 
	id_cuenta_cargo_concepto_posgrado SERIAL NOT NULL,
	id_cuenta_cargo_posgrado_concepto INT NOT NULL,
	costo FLOAT,
	porcentaje INT,
	descuento FLOAT,
	monto_pagar FLOAT,
	fecha DATE,
	desglose BOOLEAN,
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_cuentas_cargos_conceptos_posgrados PRIMARY KEY(id_cuenta_cargo_concepto_posgrado),
	CONSTRAINT fk_cuentas_conceptos_posgrados_conceptos_cargos FOREIGN KEY(id_cuenta_cargo_posgrado_concepto) REFERENCES cuentas_cargos_posgrados_conceptos(id_cuenta_cargo_posgrado_concepto)
);

CREATE TABLE posgrados_contratos( 
	id_posgrado_contrato SERIAL NOT NULL,
	id_cuenta_cargo_posgrado INT NOT NULL,
	id_persona_alumno_posgrado INT NOT NULL,
	numero_cuotas INT,
	id_persona_director_posgrado INT NOT NULL,
	id_persona_facultad_administrador INT NOT NULL,
	id_persona_decano INT NOT NULL,
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_posgrados_contratos PRIMARY KEY(id_posgrado_contrato),
	CONSTRAINT fk_conceptos_cargos_contratos FOREIGN KEY(id_cuenta_cargo_posgrado) REFERENCES cuentas_cargos_posgrados(id_cuenta_cargo_posgrado),
	CONSTRAINT fk_personas_alumnos_posgrados_contratos FOREIGN KEY(id_persona_alumno_posgrado) REFERENCES personas_alumnos_posgrados(id_persona_alumno_posgrado),
	CONSTRAINT fk_personas_diectores_posgrado_posgrados_contratos FOREIGN KEY(id_persona_director_posgrado) REFERENCES personas_directores_posgrados(id_persona_director_posgrado),
	CONSTRAINT fk_personas_facultades_adminitradores_posgrados_contratos FOREIGN KEY(id_persona_facultad_administrador) REFERENCES personas_facultades_administradores(id_persona_facultad_administrador),
	CONSTRAINT fk_personas_decanos_posgrados_contratos FOREIGN KEY(id_persona_decano) REFERENCES personas_decanos(id_persona_decano)
);

CREATE TABLE posgrados_contratos_detalles(
	id_posgrado_contrato_detalle SERIAL NOT NULL,
	id_posgrado_contrato INT NOT NULL,
	id_cuenta_cargo_concepto_posgrado INT NOT NULL,
	pagado BOOLEAN,
	monto_pagado FLOAT,		-- -- Monto de pago control interno
	monto_adeudado FLOAT,	-- -- Monto de pago para cotrol interno 
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_posgrados_contratos_detalles PRIMARY KEY(id_posgrado_contrato_detalle),
	CONSTRAINT fk_contratos_posgrados_contratos_detalles FOREIGN KEY(id_posgrado_contrato) REFERENCES posgrados_contratos(id_posgrado_contrato),
	CONSTRAINT fk_cuentas_cargos_posgrados_contratos_detalles FOREIGN KEY(id_cuenta_cargo_concepto_posgrado) REFERENCES cuentas_cargos_conceptos_posgrados(id_cuenta_cargo_concepto_posgrado)
);

-- -- Falta dos tablas de ccontrato para el Docente

CREATE TABLE posgrados_contratos_detalles_desglose(
	id_posgrado_desglose SERIAL NOT NULL,
	id_posgrado_contrato_detalle INT NOT NULL,
	monto FLOAT,
	descripcion VARCHAR(30), -- -- Mes o numero de Pago
	pagado BOOLEAN,
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_posgrados_contratos_detalles_desglose PRIMARY KEY(id_posgrado_desglose),
	CONSTRAINT fk_contratos_posgrados_contratos_detalles_desglose FOREIGN KEY(id_posgrado_contrato_detalle) REFERENCES posgrados_contratos_detalles(id_posgrado_contrato_detalle)
);

CREATE TABLE posgrados_transacciones(
	id_posgrado_transaccion SERIAL NOT NULL,
	id_posgrado_contrato INT NOT NULL,
	id_persona_alumno_posgrado INT NOT NULL,
	fecha_transaccion DATE,
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_posgrados_transacciones PRIMARY KEY(id_posgrado_transaccion),
	CONSTRAINT fk_posgrado_contrato_posgrados_transacciones FOREIGN KEY(id_posgrado_contrato) REFERENCES posgrados_contratos(id_posgrado_contrato),
	CONSTRAINT fk_personas_alumnos_posgrados_transacciones FOREIGN KEY(id_persona_alumno_posgrado) REFERENCES personas_alumnos_posgrados(id_persona_alumno_posgrado)
);

CREATE TABLE posgrados_transacciones_detalles(
	id_posgrado_transaccion_detalle SERIAL NOT NULL,
	id_posgrado_transaccion INT NOT NULL,
	id_posgrado_contrato_detalle INT NOT NULL,
	fecha_deposito DATE,
	numero_deposito VARCHAR(100),
	monto_deposito FLOAT,
	fotografia_deposito VARCHAR(255),
    usado_transaccion VARCHAR(1) DEFAULT '0', -- -- Para ver si utilizamos o no la transaccion
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_posgrados_transacciones_detalles PRIMARY KEY(id_posgrado_transaccion_detalle),
	CONSTRAINT fk_transacciones_posgrados_transacciones_detalles FOREIGN KEY(id_posgrado_transaccion) REFERENCES posgrados_transacciones(id_posgrado_transaccion),
	CONSTRAINT fk_contrato_detalle_transacciones_detalles FOREIGN KEY(id_posgrado_contrato_detalle) REFERENCES posgrados_contratos_detalles(id_posgrado_contrato_detalle)
);

CREATE TABLE posgrados_transacciones_detalles_desglose(
	id_transaccion_desglose SERIAL NOT NULL,
	id_posgrado_contrato_detalle INT NOT NULL,
    id_posgrado_transaccion_detalle INT NOT NULL,
	monto_desglosado FLOAT,
	descripcion VARCHAR(100), -- -- Una Descripcion del mes de transaccion o las Observaciones de Que tranacaciones de esta realizando
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_posgrados_transaccion_detalles_desglose PRIMARY KEY(id_transaccion_desglose),
	CONSTRAINT fk_transaccion_posgrados_contratos_detalles_desglose FOREIGN KEY(id_posgrado_contrato_detalle) REFERENCES posgrados_contratos_detalles(id_posgrado_contrato_detalle),
    CONSTRAINT fk_transaccion_posgrados_transaccion_detalles_desglose FOREIGN KEY(id_posgrado_transaccion_detalle) REFERENCES posgrados_transacciones_detalles(id_posgrado_transaccion_detalle)
);

CREATE TABLE montos_excedentes(
	id_monto_exedente SERIAL NOT NULL,
	id_posgrado_transaccion_detalle INT NOT NULL,
	monto_excedente FLOAT,
	procesando VARCHAR(1) DEFAULT '0',
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_montos_excedentes PRIMARY KEY(id_monto_exedente),
	CONSTRAINT fk_montos_excedentes_posgrados_transacciones FOREIGN KEY(id_posgrado_transaccion_detalle) REFERENCES posgrados_transacciones_detalles(id_posgrado_transaccion_detalle)
);

CREATE TABLE tramites_documentos(
	id_tramite_documento SERIAL NOT NULL,
	nombre VARCHAR(80),
	descripcion VARCHAR(250),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_tramites_documentos PRIMARY KEY(id_tramite_documento)
);

CREATE TABLE niveles_academicos_tramites_documentos(
	id_nivel_academico_tramite_documento SERIAL NOT NULL,
	id_nivel_academico INT NOT NULL,
	id_tramite_documento INT NOT NULL,
	fecha TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_niveles_academicos_tramites_documentos PRIMARY KEY(id_nivel_academico_tramite_documento),
	CONSTRAINT fk_niveles_academicos_niveles_academicos_tramites_documentos FOREIGN KEY(id_nivel_academico) REFERENCES niveles_academicos(id_nivel_academico),
	CONSTRAINT fk_tramites_documentos_niveles_academicos_tramites_documentos FOREIGN KEY(id_tramite_documento) REFERENCES tramites_documentos(id_tramite_documento)
);

CREATE TABLE posgrado_alumnos_documentos(
	id_posgrado_alumno_documento SERIAL NOT NULL,
	id_persona_alumno_posgrado INT NOT NULL,
	id_nivel_academico_tramite_documento INT NOT NULL,
	fecha_subida TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
	archivo VARCHAR(100),
	verificado VARCHAR(1) DEFAULT 'N',
	fecha_verificacion TIMESTAMP,
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_posgrado_alumnos_documentos PRIMARY KEY(id_posgrado_alumno_documento),
	CONSTRAINT fk_personas_alumnos_posgrado_documentos FOREIGN KEY(id_persona_alumno_posgrado) REFERENCES personas_alumnos_posgrados(id_persona_alumno_posgrado),
	CONSTRAINT fk_niveles_academicos_tramites_documentos_documentos FOREIGN KEY(id_nivel_academico_tramite_documento) REFERENCES niveles_academicos_tramites_documentos(id_nivel_academico_tramite_documento)
);
-- -- Tabla suelta remitido a un email y luego importado al sistema
CREATE TABLE extractos_bancarios(
	id_extracto_bancario SERIAL NOT NULL,
	nombre_completo VARCHAR(200),
	carnet_identidad VARCHAR(20),
	numero_codigo VARCHAR(50),
	monto FLOAT,
	fecha DATE,
    hora TIME,
    procesando VARCHAR(1) DEFAULT '0',
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_extractos_bancarios PRIMARY KEY(id_extracto_bancario)
);
-- --------------------------------------------------------------------------------------------------------------
-- ------------------------------------- POSTGRADO ACADEMICO ----------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------

CREATE TABLE posgrado_niveles( -- -- Basicas - Intermedio - Avanzada
    id_posgrado_nivel SERIAL NOT NULL,
    nombre VARCHAR(100) NOT NULL,
	descripcion VARCHAR(100) NULL,
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_posgrado_niveles PRIMARY KEY(id_posgrado_nivel)
);

CREATE TABLE posgrado_materias (
    id_posgrado_materia SERIAL NOT NULL,
    id_posgrado_programa INT NOT NULL,
	id_posgrado_nivel INT NOT NULL,
	sigla VARCHAR(6) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    nivel_curso INT,
	cantidad_hora_teorica INT DEFAULT 0,
    cantidad_hora_practica INT DEFAULT 0,
    cantidad_hora_laboratorio INT DEFAULT 0,
	cantidad_hora_plataforma INT DEFAULT 0,
	cantidad_hora_virtual INT DEFAULT 0,
	cantidad_credito INT DEFAULT 0,
    color VARCHAR(7) DEFAULT '#000000',
	icono  VARCHAR(35) DEFAULT '',
	imagen VARCHAR(250) DEFAULT '',
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_postgrado_materias PRIMARY KEY(id_posgrado_materia),
	CONSTRAINT fk_posgrados_programas_postgrado_materias FOREIGN KEY(id_posgrado_programa) REFERENCES posgrados_programas(id_posgrado_programa),
	CONSTRAINT fk_posgrado_niveles_postgrado_materias FOREIGN KEY(id_posgrado_nivel) REFERENCES posgrado_niveles(id_posgrado_nivel)
);

CREATE TABLE posgrado_tipos_evaluaciones_notas (
	id_posgrado_tipo_evaluacion_nota SERIAL NOT NULL,
	nombre VARCHAR(3) NOT NULL,
	configuracion JSON NOt NULL,
	nota_minima_aprobacion INT, -- -- 51 o en otros casos 56 o 70 depende del postgrado
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_posgrado_tipos_evaluaciones_notas PRIMARY KEY(id_posgrado_tipo_evaluacion_nota)
);

CREATE TABLE posgrado_asignaciones_docentes ( -- -- Fecha de inicio de clases y fin de clases
	id_posgrado_asignacion_docente SERIAL NOT NULL,
    id_persona_docente INT NOT NULL,
    id_posgrado_materia INT NOT NULL,
    id_posgrado_tipo_evaluacion_nota INT DEFAULT 0,
	id_gestion_periodo INT NOT NULL,
	tipo_calificacion VARCHAR(3) DEFAULT 'N', -- -- sobre 100 o directamente ponderado de acuerdo a sistema de evaluacion
	grupo VARCHAR(3),
	cupo_maximo_estudiante INT DEFAULT 0,
    finaliza_planilla_calificacion VARCHAR(1) DEFAULT 'N', 
	fecha_limite_examen_final TIMESTAMP WITHOUT TIME ZONE,
    fecha_limite_nota_2da_instancia TIMESTAMP WITHOUT TIME ZONE,
    fecha_limite_nota_examen_mesa TIMESTAMP WITHOUT TIME ZONE,
	fecha_finalizacion_planilla TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
    hash VARCHAR(500),
	codigo_barras VARCHAR(500),
	codigo_qr VARCHAR(500),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_posgrado_asignaciones_docentes PRIMARY KEY(id_posgrado_asignacion_docente),
	CONSTRAINT fk_personas_docentes_posgrado_asignaciones_docentes FOREIGN KEY(id_persona_docente) REFERENCES personas_docentes(id_persona_docente),
	CONSTRAINT fk_posgrado_materias_posgrado_asignaciones_docentes FOREIGN KEY(id_posgrado_materia) REFERENCES posgrado_materias(id_posgrado_materia),
	CONSTRAINT fk_posgrado_tipos_evaluaciones_notas_posg_asig_doc FOREIGN KEY(id_posgrado_tipo_evaluacion_nota) REFERENCES posgrado_tipos_evaluaciones_notas(id_posgrado_tipo_evaluacion_nota),
	CONSTRAINT fk_gestiones_periodos_posgrado_asignaciones_docentes FOREIGN KEY(id_gestion_periodo) REFERENCES gestiones_periodos(id_gestion_periodo)
);

CREATE TABLE posgrado_calificaciones (
	id_postgrado_calificacion SERIAL NOT NULL,
    id_persona_alumno_posgrado INT NOT NULL,
    id_posgrado_asignacion_docente INT NOT NULL,
	tipo_programacion INT DEFAULT 0, -- -- 0 = Nuevo, 1 = Repitente, este dato se lo debe poner en el momento de la programacion automatica
	control_asistencia JSONB,
	configuracion JSONB, -- -- La configuracion de la calificacion, Ejm.: [{"campo:"calificacion1","descripcion":"Practica de...."},{"campo":"calicacion2","descripcion":"examen de..."},{"campo":"calificacion9","descripcion":"Foro de .."},{"campo":"calificacion15","descripcion":"Nota Final"}]
	calificacion1 FLOAT DEFAULT 0, -- -- Esta se tranfiere de la plataforma o directo
	calificacion2 FLOAT DEFAULT 0, -- -- Esta se tranfiere de la plataforma o directo
	calificacion3 FLOAT DEFAULT 0, -- -- Esta se tranfiere de la plataforma o directo
	calificacion4 FLOAT DEFAULT 0, -- -- Esta se tranfiere de la plataforma o directo
	calificacion5 FLOAT DEFAULT 0, -- -- Esta se tranfiere de la plataforma o directo
	calificacion6 FLOAT DEFAULT 0, -- -- Esta se tranfiere de la plataforma o directo
	calificacion7 FLOAT DEFAULT 0, -- -- Esta se tranfiere de la plataforma o directo
	calificacion8 FLOAT DEFAULT 0, -- -- Esta se tranfiere de la plataforma o directo
	calificacion9 FLOAT DEFAULT 0, -- -- Esta se tranfiere de la plataforma o directo
	calificacion10 FLOAT DEFAULT 0, -- -- Esta se tranfiere de la plataforma o directo
	calificacion11 FLOAT DEFAULT 0, -- -- Esta se tranfiere de la plataforma o directo
	calificacion12 FLOAT DEFAULT 0, -- -- Esta se tranfiere de la plataforma o directo
	calificacion13 FLOAT DEFAULT 0, -- -- Esta se tranfiere de la plataforma o directo
	calificacion14 FLOAT DEFAULT 0, -- -- Esta se tranfiere de la plataforma o directo
	calificacion15 FLOAT DEFAULT 0, -- -- Esta se tranfiere de la plataforma o directo
	calificacion16 FLOAT DEFAULT 0, -- -- Esta se tranfiere de la plataforma o directo
	calificacion17 FLOAT DEFAULT 0, -- -- Esta se tranfiere de la plataforma o directo
	calificacion18 FLOAT DEFAULT 0, -- -- Esta se tranfiere de la plataforma o directo
	calificacion19 FLOAT DEFAULT 0, -- -- Esta se tranfiere de la plataforma o directo
	calificacion20 FLOAT DEFAULT 0, -- -- Esta se tranfiere de la plataforma o directo
	nota_final FLOAT DEFAULT 0, -- --Aqui se copia la nota final de las calificaciones
    nota_2da_instancia FLOAT DEFAULT 0,
    nota_examen_mesa FLOAT DEFAULT 0,
    observacion VARCHAR(1) DEFAULT 'R', -- -- A=Aprobado, R=Reprobado, X=Abandono
	tipo VARCHAR(1) DEFAULT 'N', -- N=normal, C=convalidado, H=homologado, S=Compensado
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_posgrado_calificaciones PRIMARY KEY(id_postgrado_calificacion),
	CONSTRAINT fk_posgrado_personas_alumnos_posgrado_calificaciones FOREIGN KEY(id_persona_alumno_posgrado) REFERENCES personas_alumnos_posgrados(id_persona_alumno_posgrado),
	CONSTRAINT fk_posgrado_asignaciones_docentes_posgrado_calificaciones FOREIGN KEY(id_posgrado_asignacion_docente) REFERENCES posgrado_asignaciones_docentes(id_posgrado_asignacion_docente)
);

CREATE TABLE posgrado_asignaciones_horarios ( 
    id_posgrado_asignacion_horario SERIAL NOT NULL,
    id_posgrado_asignacion_docente INT NOT NULL,
    id_ambiente INT NOT NULL, -- -- Es un ambiente virtual
    id_dia INT NOT NULL,
    id_hora_clase INT NOT NULL,
	clase_link VARCHAR(255), -- -- El link Google Classroom o ZOOM
	clase_descripcion VARCHAR(500), -- -- Detalles del enlace
	fecha_registro DATE DEFAULT now(),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_posgrado_asignaciones_horarios PRIMARY KEY(id_posgrado_asignacion_horario),
	CONSTRAINT fk_posg_asig_doc_posgrado_asig_horarios FOREIGN KEY(id_posgrado_asignacion_docente) REFERENCES posgrado_asignaciones_docentes(id_posgrado_asignacion_docente),
	CONSTRAINT fk_ambientes_posgrado_asignaciones_horarios FOREIGN KEY(id_ambiente) REFERENCES ambientes(id_ambiente),
	CONSTRAINT fk_dias_posgrado_asignaciones_horarios FOREIGN KEY(id_dia) REFERENCES dias(id_dia),
	CONSTRAINT fk_horas_clases_posgrado_asignaciones_horarios FOREIGN KEY(id_hora_clase) REFERENCES horas_clases(id_hora_clase)
);

CREATE TABLE posgrado_clases_videos (
    id_posgrado_clase_video SERIAL NOT NULL,
    id_posgrado_asignacion_horario INT NOT NULL,
	clase_link VARCHAR(255), -- -- El link de la clase particular
	clase_fecha DATE,
	clase_hora_inicio TIMESTAMP,
	clase_hora_fin TIMESTAMP,
	clase_duracion TIMESTAMP,
	fecha_registro DATE DEFAULT now(),
	estado VARCHAR(1) DEFAULT 'S',
	CONSTRAINT pk_posgrado_clases_videos PRIMARY KEY(id_posgrado_clase_video),
	CONSTRAINT fk_posgrado_asignaciones_horarios_posgrado_clases_videos FOREIGN KEY(id_posgrado_asignacion_horario) REFERENCES posgrado_asignaciones_horarios(id_posgrado_asignacion_horario)
);

-- -------------------------------------------------------------------------------------------------------------
-- ------------------------------------------- FUNCTIONS -------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------
CREATE FUNCTION iff(boolean, double precision, double precision) RETURNS double precision
    LANGUAGE sql
    AS $_$
select CASE when $1 then $2 else $3 end
$_$;

CREATE FUNCTION numeraltoliteral(ptotal double precision) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
declare
   total numeric;
   total1 numeric;
   cent2  numeric;
   cent   numeric;
   cent1  char(2);
   mil    numeric;
   millon numeric;
   millones numeric;
   sav    numeric;
   unit   numeric;
   deci   numeric;
   centi  numeric;
   factor numeric;
   sav1   numeric;
   depesos numeric;
   lletra  varchar;
   letras varchar;

begin

   total := ptotal;
   total1:= total;
   total := trunc(total);
   cent2 := total1 - total;
   cent  := cent2*100;
   cent1 := '00';

   if total=0 then
      return 'CERO';
   end if;

   mil:=0;
   millon:=0;
   millones:=0;
   depesos:=0;
   sav:=1;
   unit:=1;
   deci:=1;
   centi:=1;
   factor:=1;
   sav1:=1;
   letras:=' ';

   while total > 0 loop
      if total > 1999999 then
         depesos  := 1;
         factor   := 1000000;
         millones := 1;
         millon   := 0;
      else
         if total > 999999 then
            depesos := 1;
            factor  := 1000000;
            millon  := 1;
         else
            if total > 999 then
               factor := 1000;
               mil    := 1;
            else
               factor := 1;
               mil := 0;
            end if;
         end if;
      end if;

      sav := total;
      total := trunc(total/factor);
      sav  := sav-(total*factor);

      if sav<>0 then
         depesos := 0;
      end if;

      centi:=TRUNC(total/100);

      if centi = 0 then
         letras := rtrim(letras)||'   ';
      end if;
      if centi = 1 then
         if total = 100 then
            letras := rtrim(letras)||' CIEN';
         else
            letras := rtrim(letras)||' CIENTO';
         end if;
      end if;
      if centi = 2 then
         letras := rtrim(letras)||' DOSCIENTOS';
      end if;
      if centi = 3 then
         letras := rtrim(letras)||' TRESCIENTOS';
      end if;
      if centi = 4 then
         letras := rtrim(letras)||' CUATROCIENTOS';
      end if;
      if centi = 5 then
         letras := rtrim(letras)||' QUINIENTOS';
      end if;
      if centi = 6 then
         letras := rtrim(letras)||' SEISCIENTOS';
      end if;
      if centi = 7 then
         letras := rtrim(letras)||' SETECIENTOS';
      end if;
      if centi = 8 then
         letras := rtrim(letras)||' OCHOCIENTOS';
      end if;
      if centi = 9 then
         letras := rtrim(letras)||' NOVECIENTOS';
      end if;

      total:=total - (centi*100);
      deci :=trunc(total/10);
      unit :=total-(deci*10);

      if total >= 30 then
         if deci = 3 then
            letras := rtrim(letras)||' TREINTA';
         end if;
         if deci = 4 then
            letras := rtrim(letras)||' CUARENTA';
         end if;
         if deci = 5 then
            letras := rtrim(letras)||' CINCUENTA';
         end if;
         if deci = 6 then
            letras := rtrim(letras)||' SESENTA';
         end if;
         if deci = 7 then
            letras := rtrim(letras)||' SETENTA';
         end if;
         if deci = 8 then
            letras := rtrim(letras)||' OCHENTA';
         end if;
         if deci = 9 then
            letras := rtrim(letras)||' NOVENTA';
         end if;
         if unit > 0 then
            letras := rtrim(letras)||' Y';
         end if;
      else
         unit := total;
      end if;

      if unit = 0 then
         letras := rtrim(letras)||' ';
      end if;
      if unit = 1 then
         letras := rtrim(letras)||' UNO';
      end if;
      if unit = 2 then
         letras := rtrim(letras)||' DOS';
      end if;
      if unit = 3 then
         letras := rtrim(letras)||' TRES';
      end if;
      if unit = 4 then
         letras := rtrim(letras)||' CUATRO';
      end if;
      if unit = 5 then
         letras := rtrim(letras)||' CINCO';
      end if;
      if unit = 6 then
         letras := rtrim(letras)||' SEIS';
      end if;
      if unit = 7 then
         letras := rtrim(letras)||' SIETE';
      end if;
      if unit = 8 then
         letras := rtrim(letras)||' OCHO';
      end if;
      if unit = 9 then
         letras := rtrim(letras)||' NUEVE';
      end if;
      if unit = 10 then
         letras := rtrim(letras)||' DIEZ';
      end if;
      if unit = 11 then
         letras := rtrim(letras)||' ONCE';
      end if;
      if unit = 12 then
         letras := rtrim(letras)||' DOCE';
      end if;
      if unit = 13 then
         letras := rtrim(letras)||' TRECE';
      end if;
      if unit = 14 then
         letras := rtrim(letras)||' CATORCE';
      end if;
      if unit = 15 then
         letras := rtrim(letras)||' QUINCE';
      end if;
      if unit = 16 then
         letras := rtrim(letras)||' DIECISEIS';
      end if;
      if unit = 17 then
         letras := rtrim(letras)||' DIECISIETE';
      end if;
      if unit = 18 then
         letras := rtrim(letras)||' DIECIOCHO';
      end if;
      if unit = 19 then
         letras := rtrim(letras)||' DIECINUEVE';
      end if;
      if unit = 20 then
         letras := rtrim(letras)||' VEINTE';
      end if;
      if unit = 21 then
         letras := rtrim(letras)||' VEINTIUNO';
      end if;
      if unit = 22 then
         letras := rtrim(letras)||' VEINTIDOS';
      end if;
      if unit = 23 then
         letras := rtrim(letras)||' VEINTITRES';
      end if;
      if unit = 24 then
         letras := rtrim(letras)||' VEINTICUATRO';
      end if;
      if unit = 25 then
         letras := rtrim(letras)||' VEINTICINCO';
      end if;
      if unit = 26 then
         letras := rtrim(letras)||' VEINTISEIS';
      end if;
      if unit = 27 then
         letras := rtrim(letras)||' VEINTISIETE';
      end if;
      if unit = 28 then
         letras := rtrim(letras)||' VEINTIOCHO';
      end if;
      if unit = 29 then
         letras := rtrim(letras)||' VEINTINUEVE';
      end if;
      if millones=1 then
         letras := rtrim(letras)||' MILLONES';
         millones := 0;
      else
         if millon=1 then
            letras := rtrim(letras)||' MILLON';
            millon := 0;
         else
            if mil=1 then
               letras := rtrim(letras)||' MIL';
               mil := 0;
            end if;
         end if;
      end if;
      total:=sav;
   end loop;

   if cent=0 then
      cent1:='00';
   else
      cent1:=cast(cent as char(2));
   end if;
   if depesos=1 then
      --letras := rtrim(letras)||' DE PESOS '||cent1||'/100';
      --letras := rtrim(letras);
   else
      --letras := rtrim(letras)||' PESOS '||cent1||'/100';
      --letras := rtrim(letras)||' '||cent1||'/100';
   end if;

   --lletra := '('||ltrim(letras)||')';
   lletra := ltrim(letras);

return lletra;
end
$_$;
-- -------------------------------------------------------------------------------------------------------------
-- ------------------------------------------- VIEWS -----------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------
CREATE VIEW v_personas_menus_principales
AS
SELECT 
  public.personas.id_persona,
  public.personas.numero_identificacion_personal,
  public.personas.paterno,
  public.personas.materno,
  public.personas.nombres,
  public.personas.fotografia,
  public.personas.email,
  public.personas.usuario,
  public.personas.password,
  public.personas.abreviacion_titulo,
  public.tipos_personas.id_tipo_persona,
  public.tipos_personas.tipo,
  public.modulos.id_modulo,
  public.modulos.nombre AS nombre_modulo,
  public.menus_principales.id_menu_principal,
  public.menus_principales.nombre AS nombre_menu_principal,
  public.menus_principales.icono,
  public.menus_principales.orden,
  public.roles_menus_principales.id_rol_menu_principal,
  public.roles.id_rol,
  public.roles.nombre AS nombre_rol
FROM
  public.personas
  INNER JOIN public.tipos_personas ON (public.personas.id_persona = public.tipos_personas.id_persona)
  INNER JOIN public.roles ON (public.tipos_personas.id_rol = public.roles.id_rol)
  INNER JOIN public.roles_menus_principales ON (public.roles.id_rol = public.roles_menus_principales.id_rol)
  INNER JOIN public.menus_principales ON (public.menus_principales.id_menu_principal = public.roles_menus_principales.id_menu_principal)
  INNER JOIN public.modulos ON (public.menus_principales.id_modulo = public.modulos.id_modulo)
ORDER BY public.menus_principales.orden;

CREATE VIEW v_localidades -- -- View que permite mostrar: Pais, Departamento, Provincia y Localidad
AS
SELECT 
  public.localidades.id_localidad,
  public.localidades.id_provincia,
  public.localidades.nombre AS nombre_localidad,
  public.localidades.estado AS estado_localidad,
  public.provincias.id_departamento,
  public.provincias.nombre AS nombre_provincia,
  public.provincias.estado AS estado_provincia,
  public.departamentos.id_pais,
  public.departamentos.nombre AS nombre_departamento,
  public.departamentos.estado AS estado_departamento,
  public.paises.nombre AS nombre_pais,
  public.paises.estado AS estado_pais
FROM
  public.localidades
  INNER JOIN public.provincias ON (public.localidades.id_provincia = public.provincias.id_provincia)
  INNER JOIN public.departamentos ON (public.provincias.id_departamento = public.departamentos.id_departamento)
  INNER JOIN public.paises ON (public.departamentos.id_pais = public.paises.id_pais)
WHERE
  public.localidades.estado = 'S' AND 
  public.provincias.estado = 'S' AND 
  public.departamentos.estado = 'S' AND 
  public.paises.estado = 'S';

CREATE VIEW v_programas_posgrados
AS
SELECT 
  public.posgrados_programas.id_posgrado_programa,
  public.posgrados_programas.id_nivel_academico,
  public.posgrados_programas.id_carrera,
  public.posgrados_programas.gestion,
  public.posgrados_programas.nombre AS nombre_programa,
  public.posgrados_programas.id_modalidad,
  public.posgrados_programas.fecha_inicio,
  public.posgrados_programas.fecha_fin,
  public.posgrados_programas.numero_max_cuotas,
  public.posgrados_programas.documento,
  public.posgrados_programas.costo_total,
  public.posgrados_programas.formato_contrato,
  public.niveles_academicos.nombre AS nombre_nivel_academico,
  public.niveles_academicos.descripcion AS descripcion_nivel_academico,
  public.carreras.nombre AS nombre_carrera,
  public.carreras.nombre_abreviado AS nombre_abreviado_carrera,
  public.modalidades.nombre AS nombre_modalidad,
  public.modalidades.descripcion AS descripcion_modalidad
FROM
  public.posgrados_programas
  INNER JOIN public.niveles_academicos ON (public.niveles_academicos.id_nivel_academico = public.posgrados_programas.id_nivel_academico)
  INNER JOIN public.carreras ON (public.carreras.id_carrera = public.posgrados_programas.id_carrera)
  INNER JOIN public.modalidades ON (public.modalidades.id_modalidad = public.posgrados_programas.id_modalidad)
WHERE
  public.posgrados_programas.estado = 'S';


CREATE VIEW v_conceptos_cuentas_detalle
AS
SELECT 
  public.cuentas_cargos_posgrados_conceptos.id_cuenta_cargo_posgrado_concepto,
  public.cuentas_cargos_posgrados_conceptos.id_cuenta_cargo_posgrado,
  public.cuentas_cargos_posgrados_conceptos.id_cuenta_concepto,
  public.cuentas_cargos_posgrados_conceptos.tiene_descuento,
  public.cuentas_cargos_posgrados.id_posgrado_programa,
  public.cuentas_cargos_posgrados.nombre AS nombre_cuenta_cargo,
  public.cuentas_cargos_posgrados.numero_formulario,
  public.cuentas_conceptos.nombre AS nombre_concepto,
  public.cuentas_conceptos.descripcion
FROM
  public.cuentas_cargos_posgrados_conceptos
  INNER JOIN public.cuentas_cargos_posgrados ON (public.cuentas_cargos_posgrados.id_cuenta_cargo_posgrado = public.cuentas_cargos_posgrados_conceptos.id_cuenta_cargo_posgrado)
  INNER JOIN public.cuentas_conceptos ON (public.cuentas_conceptos.id_cuenta_concepto = public.cuentas_cargos_posgrados_conceptos.id_cuenta_concepto)
WHERE
  public.cuentas_cargos_posgrados_conceptos.estado = 'S' AND
  public.cuentas_cargos_posgrados.estado = 'S' AND 
  public.cuentas_conceptos.estado = 'S';

  CREATE VIEW v_tramites_documentos
AS
SELECT 
  public.niveles_academicos_tramites_documentos.id_nivel_academico_tramite_documento,
  public.niveles_academicos_tramites_documentos.id_nivel_academico,
  public.niveles_academicos_tramites_documentos.id_tramite_documento,
  public.niveles_academicos_tramites_documentos.fecha,
  public.tramites_documentos.nombre AS nombre_documentos,
  public.tramites_documentos.descripcion AS descripcion_documentos,
  public.niveles_academicos.nombre AS nombre_nivel_academico,
  public.niveles_academicos.descripcion AS descripcion_nivel_academico
FROM
  public.niveles_academicos_tramites_documentos
  INNER JOIN public.tramites_documentos ON (public.tramites_documentos.id_tramite_documento = public.niveles_academicos_tramites_documentos.id_tramite_documento)
  INNER JOIN public.niveles_academicos ON (public.niveles_academicos.id_nivel_academico = public.niveles_academicos_tramites_documentos.id_nivel_academico)
WHERE
  public.niveles_academicos_tramites_documentos.estado = 'S';

CREATE VIEW v_cuentas_cargos_conceptos_posgrados
AS
SELECT 
  public.cuentas_cargos_conceptos_posgrados.id_cuenta_cargo_concepto_posgrado,
  public.cuentas_cargos_conceptos_posgrados.costo,
  public.cuentas_cargos_conceptos_posgrados.porcentaje,
  public.cuentas_cargos_conceptos_posgrados.descuento,
  public.cuentas_cargos_conceptos_posgrados.monto_pagar,
  public.cuentas_cargos_conceptos_posgrados.fecha,
  public.cuentas_cargos_conceptos_posgrados.desglose,
  public.cuentas_cargos_posgrados_conceptos.id_cuenta_cargo_posgrado_concepto,
  public.cuentas_cargos_posgrados_conceptos.id_cuenta_cargo_posgrado,
  public.cuentas_cargos_posgrados_conceptos.id_cuenta_concepto,
  public.cuentas_cargos_posgrados_conceptos.tiene_descuento,
  public.cuentas_cargos_posgrados.id_posgrado_programa,
  public.cuentas_cargos_posgrados.nombre AS nombre_cuenta_cargo,
  public.cuentas_cargos_posgrados.numero_formulario,
  public.cuentas_conceptos.nombre AS nombre_concepto

FROM
  public.cuentas_cargos_conceptos_posgrados
  INNER JOIN public.cuentas_cargos_posgrados_conceptos ON (public.cuentas_cargos_posgrados_conceptos.id_cuenta_cargo_posgrado_concepto = public.cuentas_cargos_conceptos_posgrados.id_cuenta_cargo_posgrado_concepto)
  INNER JOIN public.cuentas_cargos_posgrados ON (public.cuentas_cargos_posgrados.id_cuenta_cargo_posgrado = public.cuentas_cargos_posgrados_conceptos.id_cuenta_cargo_posgrado)
  INNER JOIN public.cuentas_conceptos ON (public.cuentas_conceptos.id_cuenta_concepto = public.cuentas_cargos_posgrados_conceptos.id_cuenta_concepto)
WHERE
  public.cuentas_cargos_posgrados_conceptos.estado = 'S';

CREATE VIEW v_personas_directores_posgrados
AS
SELECT 
  public.personas_directores_posgrados.id_persona_director_posgrado,
  public.personas_directores_posgrados.id_persona,
  public.personas_directores_posgrados.fecha_inicio,
  public.personas_directores_posgrados.fecha_fin,
  public.personas_directores_posgrados.firma_digital,
  public.personas.numero_identificacion_personal,
  public.personas.id_emision_cedula,
  public.personas.paterno,
  public.personas.materno,
  public.personas.nombres,
  public.personas.fecha_nacimiento,
  public.personas.direccion,
  public.personas.telefono_celular,
  public.personas.telefono_fijo,
  public.personas.email,
  public.personas.fotografia
FROM
  public.personas_directores_posgrados
  INNER JOIN public.personas ON (public.personas.id_persona = public.personas_directores_posgrados.id_persona)
WHERE
  public.personas.estado = 'S';

CREATE VIEW v_personas_facultades_administrativas
AS
SELECT 
  public.personas_facultades_administradores.id_persona_facultad_administrador,
  public.personas_facultades_administradores.id_persona,
  public.personas_facultades_administradores.fecha_inicio,
  public.personas_facultades_administradores.fecha_fin,
  public.personas_facultades_administradores.firma_digital,
  public.personas.numero_identificacion_personal,
  public.personas.id_emision_cedula,
  public.personas.paterno,
  public.personas.materno,
  public.personas.nombres,
  public.personas.fecha_nacimiento,
  public.personas.direccion,
  public.personas.telefono_celular,
  public.personas.telefono_fijo,
  public.personas.email,
  public.personas.fotografia
FROM
  public.personas_facultades_administradores
  INNER JOIN public.personas ON (public.personas.id_persona = public.personas_facultades_administradores.id_persona)

WHERE
  public.personas.estado = 'S';

CREATE VIEW v_personas_decanos
AS
SELECT 
  public.personas_decanos.id_persona_decano,
  public.personas_decanos.id_facultad,
  public.personas_decanos.id_persona,
  public.personas_decanos.fecha_inicio,
  public.personas_decanos.fecha_fin,
  public.personas_decanos.firma_digital,
  public.personas.numero_identificacion_personal,
  public.personas.id_emision_cedula,
  public.personas.paterno,
  public.personas.materno,
  public.personas.nombres,
  public.personas.fecha_nacimiento,
  public.personas.direccion,
  public.personas.telefono_celular,
  public.personas.telefono_fijo,
  public.personas.email,
  public.personas.fotografia,
  public.facultades.id_area,
  public.facultades.nombre AS nombre_facultad,
  public.facultades.nombre_abreviado,
  public.facultades.direccion AS direccion_facultad,
  public.facultades.telefono AS telefono_facultad,
  public.facultades.telefono_interno,
  public.facultades.email AS email_facultad,
  public.facultades.fecha_creacion,
  public.facultades.escudo,
  public.facultades.imagen
FROM
  public.personas_decanos
    INNER JOIN public.personas ON (public.personas.id_persona = public.personas_decanos.id_persona)
    INNER JOIN public.facultades ON (public.facultades.id_facultad = public.personas_decanos.id_facultad)
WHERE
    public.personas.estado = 'S';

CREATE VIEW v_personas_alumnos_posgrados
AS
SELECT 
  public.personas_alumnos_posgrados.id_persona_alumno_posgrado,
  public.personas_alumnos_posgrados.id_persona,
  public.personas_alumnos_posgrados.id_posgrado_programa,
  public.personas_alumnos_posgrados.fecha,
  public.personas_alumnos_posgrados.inscrito,
  public.personas.numero_identificacion_personal,
  public.personas.id_emision_cedula,
  public.personas.paterno,
  public.personas.materno,
  public.personas.nombres,
  public.personas.fecha_nacimiento,
  public.personas.direccion,
  public.personas.telefono_celular,
  public.personas.telefono_fijo,
  public.personas.email,
  public.personas.fotografia,
  public.personas.estado,
  public.emision_cedulas.nombre AS nombre_emision_cedula,
  public.emision_cedulas.descripcion AS descripcion_cedula
FROM
  public.personas_alumnos_posgrados
  INNER JOIN public.personas ON (public.personas.id_persona = public.personas_alumnos_posgrados.id_persona)
  INNER JOIN public.emision_cedulas ON (public.emision_cedulas.id_emision_cedula = public.personas.id_emision_cedula)
WHERE
  public.personas.estado = 'S';

CREATE VIEW v_posgrados_contratos_detalle
AS
SELECT 
  public.posgrados_contratos.id_posgrado_contrato,
  public.posgrados_contratos.id_cuenta_cargo_posgrado,
  public.posgrados_contratos.id_persona_alumno_posgrado,
  public.posgrados_contratos.numero_cuotas,
  public.posgrados_contratos.id_persona_director_posgrado,
  public.posgrados_contratos.id_persona_facultad_administrador,
  public.posgrados_contratos.id_persona_decano,
  public.posgrados_contratos_detalles.id_posgrado_contrato_detalle,
  public.posgrados_contratos_detalles.id_cuenta_cargo_concepto_posgrado,
  public.posgrados_contratos_detalles.pagado,
  public.posgrados_contratos_detalles.monto_pagado,
  public.posgrados_contratos_detalles.monto_adeudado,

  public.cuentas_cargos_conceptos_posgrados.costo,
  public.cuentas_cargos_conceptos_posgrados.porcentaje,
  public.cuentas_cargos_conceptos_posgrados.descuento,
  public.cuentas_cargos_conceptos_posgrados.monto_pagar,
  public.cuentas_cargos_conceptos_posgrados.fecha,
  public.cuentas_cargos_conceptos_posgrados.desglose,
  public.cuentas_cargos_posgrados_conceptos.id_cuenta_cargo_posgrado_concepto,
  public.cuentas_cargos_posgrados_conceptos.id_cuenta_concepto,
  public.cuentas_cargos_posgrados_conceptos.tiene_descuento,
  public.cuentas_cargos_posgrados.id_posgrado_programa,
  public.cuentas_cargos_posgrados.nombre AS nombre_cuenta_cargo,
  public.cuentas_cargos_posgrados.numero_formulario,
  public.cuentas_conceptos.nombre AS nombre_concepto

FROM
  public.posgrados_contratos
  INNER JOIN public.posgrados_contratos_detalles ON (public.posgrados_contratos_detalles.id_posgrado_contrato = public.posgrados_contratos.id_posgrado_contrato)
  INNER JOIN public.cuentas_cargos_conceptos_posgrados ON (public.cuentas_cargos_conceptos_posgrados.id_cuenta_cargo_concepto_posgrado = public.posgrados_contratos_detalles.id_cuenta_cargo_concepto_posgrado)
  INNER JOIN public.cuentas_cargos_posgrados_conceptos ON (public.cuentas_cargos_posgrados_conceptos.id_cuenta_cargo_posgrado_concepto = public.cuentas_cargos_conceptos_posgrados.id_cuenta_cargo_posgrado_concepto)
  INNER JOIN public.cuentas_cargos_posgrados ON (public.cuentas_cargos_posgrados.id_cuenta_cargo_posgrado = public.cuentas_cargos_posgrados_conceptos.id_cuenta_cargo_posgrado)
  INNER JOIN public.cuentas_conceptos ON (public.cuentas_conceptos.id_cuenta_concepto = public.cuentas_cargos_posgrados_conceptos.id_cuenta_concepto)
WHERE
  public.posgrados_contratos.estado = 'S';

CREATE VIEW v_posgrados_contratos_desglose
AS
SELECT 
  public.posgrados_contratos.id_posgrado_contrato,
  public.posgrados_contratos.id_cuenta_cargo_posgrado,
  public.posgrados_contratos.id_persona_alumno_posgrado,
  public.posgrados_contratos.numero_cuotas,
  public.posgrados_contratos.id_persona_director_posgrado,
  public.posgrados_contratos.id_persona_facultad_administrador,
  public.posgrados_contratos.id_persona_decano,
  public.posgrados_contratos_detalles.id_posgrado_contrato_detalle,
  public.posgrados_contratos_detalles.id_cuenta_cargo_concepto_posgrado,
  public.posgrados_contratos_detalles.pagado,
  public.posgrados_contratos_detalles.monto_pagado,
  public.posgrados_contratos_detalles.monto_adeudado,
  public.posgrados_contratos_detalles_desglose.id_posgrado_desglose,
  public.posgrados_contratos_detalles_desglose.monto,
  public.posgrados_contratos_detalles_desglose.descripcion,
  public.posgrados_contratos_detalles_desglose.pagado AS pagado_desglose,

  public.cuentas_cargos_conceptos_posgrados.costo,
  public.cuentas_cargos_conceptos_posgrados.porcentaje,
  public.cuentas_cargos_conceptos_posgrados.descuento,
  public.cuentas_cargos_conceptos_posgrados.monto_pagar,
  public.cuentas_cargos_conceptos_posgrados.fecha,
  public.cuentas_cargos_conceptos_posgrados.desglose,
  public.cuentas_cargos_posgrados_conceptos.id_cuenta_cargo_posgrado_concepto,

  public.cuentas_cargos_posgrados_conceptos.id_cuenta_concepto,
  public.cuentas_cargos_posgrados_conceptos.tiene_descuento,
  public.cuentas_cargos_posgrados.id_posgrado_programa,
  public.cuentas_cargos_posgrados.nombre AS nombre_cuenta_cargos,
  public.cuentas_cargos_posgrados.numero_formulario,
  public.cuentas_conceptos.nombre AS nombre_concepto
FROM
  public.posgrados_contratos
  INNER JOIN public.posgrados_contratos_detalles ON (public.posgrados_contratos_detalles.id_posgrado_contrato = public.posgrados_contratos.id_posgrado_contrato)
  INNER JOIN public.cuentas_cargos_conceptos_posgrados ON (public.cuentas_cargos_conceptos_posgrados.id_cuenta_cargo_concepto_posgrado = public.posgrados_contratos_detalles.id_cuenta_cargo_concepto_posgrado)
  INNER JOIN public.cuentas_cargos_posgrados_conceptos ON (public.cuentas_cargos_posgrados_conceptos.id_cuenta_cargo_posgrado_concepto = public.cuentas_cargos_conceptos_posgrados.id_cuenta_cargo_posgrado_concepto)
  INNER JOIN public.cuentas_cargos_posgrados ON (public.cuentas_cargos_posgrados.id_cuenta_cargo_posgrado = public.cuentas_cargos_posgrados_conceptos.id_cuenta_cargo_posgrado)
  INNER JOIN public.cuentas_conceptos ON (public.cuentas_conceptos.id_cuenta_concepto = public.cuentas_cargos_posgrados_conceptos.id_cuenta_concepto)
  
  INNER JOIN public.posgrados_contratos_detalles_desglose ON (public.posgrados_contratos_detalles_desglose.id_posgrado_contrato_detalle = public.posgrados_contratos_detalles.id_posgrado_contrato_detalle)
WHERE
  public.posgrados_contratos.estado = 'S';

CREATE VIEW v_posgrados_contratos
AS
SELECT 
  public.posgrados_contratos.id_posgrado_contrato,
  public.posgrados_contratos.id_cuenta_cargo_posgrado,
  public.posgrados_contratos.id_persona_alumno_posgrado,
  public.posgrados_contratos.numero_cuotas,
  public.posgrados_contratos.id_persona_director_posgrado,
  public.posgrados_contratos.id_persona_facultad_administrador,
  public.posgrados_contratos.id_persona_decano,
  public.cuentas_cargos_posgrados.id_posgrado_programa,
  public.cuentas_cargos_posgrados.nombre,
  public.cuentas_cargos_posgrados.numero_formulario,
  public.posgrados_programas.nombre AS nombre_programa,
  public.posgrados_programas.fecha_inicio,
  public.posgrados_programas.fecha_fin,
  public.personas_alumnos_posgrados.id_persona,
  public.personas_alumnos_posgrados.fecha,
  public.personas_alumnos_posgrados.inscrito
FROM
  public.posgrados_contratos 
  INNER JOIN public.cuentas_cargos_posgrados ON (public.cuentas_cargos_posgrados.id_cuenta_cargo_posgrado = public.posgrados_contratos.id_cuenta_cargo_posgrado)
  INNER JOIN public.posgrados_programas ON (public.posgrados_programas.id_posgrado_programa = public.cuentas_cargos_posgrados.id_posgrado_programa)
INNER JOIN public.personas_alumnos_posgrados ON (public.personas_alumnos_posgrados.id_persona_alumno_posgrado = public.posgrados_contratos.id_persona_alumno_posgrado)
WHERE
  public.posgrados_contratos.estado = 'S';

  CREATE VIEW v_contratos_programas_personas
AS
SELECT 
  public.posgrados_contratos.id_posgrado_contrato,
  public.posgrados_contratos.id_cuenta_cargo_posgrado,
  public.posgrados_contratos.id_persona_alumno_posgrado,
  public.posgrados_contratos.numero_cuotas,
  public.cuentas_cargos_posgrados.id_posgrado_programa,
  public.cuentas_cargos_posgrados.nombre,
  public.posgrados_programas.nombre AS nombre_programa,
  public.posgrados_programas.fecha_inicio,
  public.posgrados_programas.fecha_fin,
  public.personas_alumnos_posgrados.id_persona,
  public.personas_alumnos_posgrados.fecha,
  public.personas_alumnos_posgrados.inscrito,

  public.personas.numero_identificacion_personal,
  public.personas.id_emision_cedula,
  public.emision_cedulas.nombre AS nombre_cedula,
  public.emision_cedulas.descripcion AS descripcion_cedula,
  public.personas.paterno,
  public.personas.materno,
  public.personas.nombres,
  public.personas.telefono_celular,
  public.personas.email
FROM
  public.posgrados_contratos 
  INNER JOIN public.cuentas_cargos_posgrados ON (public.cuentas_cargos_posgrados.id_cuenta_cargo_posgrado = public.posgrados_contratos.id_cuenta_cargo_posgrado)
  INNER JOIN public.posgrados_programas ON (public.posgrados_programas.id_posgrado_programa = public.cuentas_cargos_posgrados.id_posgrado_programa)
INNER JOIN public.personas_alumnos_posgrados ON (public.personas_alumnos_posgrados.id_persona_alumno_posgrado = public.posgrados_contratos.id_persona_alumno_posgrado)
INNER JOIN public.personas ON (public.personas.id_persona = public.personas_alumnos_posgrados.id_persona)
INNER JOIN public.emision_cedulas ON (public.emision_cedulas.id_emision_cedula = public.personas.id_emision_cedula)
WHERE
  public.posgrados_contratos.estado = 'S';

--  -- -- -- -- -- ---------------transacciones vistas 
CREATE VIEW v_transacciones_detalles_excedentes
AS
SELECT 
  public.posgrados_transacciones.id_posgrado_transaccion,
  public.posgrados_transacciones.id_posgrado_contrato,
  public.posgrados_transacciones.id_persona_alumno_posgrado,
  public.posgrados_transacciones.fecha_transaccion,
  public.posgrados_transacciones_detalles.id_posgrado_transaccion_detalle,
  public.posgrados_transacciones_detalles.id_posgrado_contrato_detalle,
  public.posgrados_transacciones_detalles.fecha_deposito,
  public.posgrados_transacciones_detalles.numero_deposito,
  public.posgrados_transacciones_detalles.monto_deposito,
  public.posgrados_transacciones_detalles.fotografia_deposito,
  public.posgrados_transacciones_detalles.usado_transaccion,
  public.montos_excedentes.id_monto_exedente,
  public.montos_excedentes.monto_excedente,
  public.montos_excedentes.procesando
FROM
  public.posgrados_transacciones 
  INNER JOIN public.posgrados_transacciones_detalles ON (public.posgrados_transacciones_detalles.id_posgrado_transaccion = public.posgrados_transacciones.id_posgrado_transaccion)
  INNER JOIN public.montos_excedentes ON (public.montos_excedentes.id_posgrado_transaccion_detalle = public.posgrados_transacciones_detalles.id_posgrado_transaccion_detalle)
WHERE
  public.posgrados_transacciones.estado = 'S';

  CREATE VIEW v_posgrado_transaccion_detalle
AS
SELECT 
  public.posgrados_transacciones.id_posgrado_transaccion,
  public.posgrados_transacciones.id_posgrado_contrato,
  public.posgrados_transacciones.id_persona_alumno_posgrado,
  public.posgrados_transacciones.fecha_transaccion,
  public.posgrados_transacciones_detalles.id_posgrado_transaccion_detalle,
  public.posgrados_transacciones_detalles.id_posgrado_contrato_detalle,
  public.posgrados_transacciones_detalles.fecha_deposito,
  public.posgrados_transacciones_detalles.numero_deposito,
  public.posgrados_transacciones_detalles.monto_deposito,
  public.posgrados_transacciones_detalles.fotografia_deposito,
  public.posgrados_transacciones_detalles.usado_transaccion
FROM
  public.posgrados_transacciones 
  INNER JOIN public.posgrados_transacciones_detalles ON (public.posgrados_transacciones_detalles.id_posgrado_transaccion = public.posgrados_transacciones.id_posgrado_transaccion)
  
WHERE
  public.posgrados_transacciones.estado = 'S';

  CREATE VIEW v_posgrado_transaccion_desglose
AS
SELECT 
  public.posgrados_transacciones.id_posgrado_transaccion,
  public.posgrados_transacciones.id_posgrado_contrato,
  public.posgrados_transacciones.id_persona_alumno_posgrado,
  public.posgrados_transacciones.fecha_transaccion,
  public.posgrados_transacciones_detalles.id_posgrado_transaccion_detalle,
  public.posgrados_transacciones_detalles.id_posgrado_contrato_detalle,
  public.posgrados_transacciones_detalles.fecha_deposito,
  public.posgrados_transacciones_detalles.numero_deposito,
  public.posgrados_transacciones_detalles.monto_deposito,
  public.posgrados_transacciones_detalles.fotografia_deposito,
  public.posgrados_transacciones_detalles.usado_transaccion,

  public.posgrados_transacciones_detalles_desglose.id_transaccion_desglose,
  public.posgrados_transacciones_detalles_desglose.monto_desglosado,
  public.posgrados_transacciones_detalles_desglose.descripcion
FROM
  public.posgrados_transacciones 
  INNER JOIN public.posgrados_transacciones_detalles ON (public.posgrados_transacciones_detalles.id_posgrado_transaccion = public.posgrados_transacciones.id_posgrado_transaccion)
  INNER JOIN public.posgrados_transacciones_detalles_desglose ON (public.posgrados_transacciones_detalles_desglose.id_posgrado_transaccion_detalle = public.posgrados_transacciones_detalles.id_posgrado_transaccion_detalle)
  
WHERE
  public.posgrados_transacciones.estado = 'S';

-- -- -- -- ----------------- Prueba para el pdf 
  CREATE VIEW v_transaccion_contrato_detalle
AS
SELECT 
  public.posgrados_transacciones.id_posgrado_transaccion,
  public.posgrados_transacciones.id_posgrado_contrato,
  public.posgrados_transacciones.id_persona_alumno_posgrado,
  public.posgrados_transacciones.fecha_transaccion,
  public.posgrados_transacciones_detalles.id_posgrado_transaccion_detalle,
  public.posgrados_transacciones_detalles.id_posgrado_contrato_detalle,
  public.posgrados_transacciones_detalles.fecha_deposito,
  public.posgrados_transacciones_detalles.numero_deposito,
  public.posgrados_transacciones_detalles.monto_deposito,
  public.posgrados_transacciones_detalles.fotografia_deposito,
  public.posgrados_transacciones_detalles.usado_transaccion,

  public.posgrados_contratos_detalles.id_cuenta_cargo_concepto_posgrado,
  public.posgrados_contratos_detalles.pagado,
  public.posgrados_contratos_detalles.monto_pagado,
  public.posgrados_contratos_detalles.monto_adeudado,

  public.cuentas_cargos_conceptos_posgrados.costo,
  public.cuentas_cargos_conceptos_posgrados.porcentaje,
  public.cuentas_cargos_conceptos_posgrados.descuento,
  public.cuentas_cargos_conceptos_posgrados.monto_pagar,
  public.cuentas_cargos_conceptos_posgrados.fecha,
  public.cuentas_cargos_conceptos_posgrados.desglose,
  public.cuentas_cargos_posgrados_conceptos.id_cuenta_cargo_posgrado_concepto,
  public.cuentas_cargos_posgrados_conceptos.id_cuenta_concepto,
  public.cuentas_cargos_posgrados_conceptos.tiene_descuento,
  public.cuentas_cargos_posgrados.id_posgrado_programa,
  public.cuentas_cargos_posgrados.nombre AS nombre_cuenta_cargo,
  public.cuentas_cargos_posgrados.numero_formulario,
  public.cuentas_conceptos.nombre AS nombre_concepto
FROM
  public.posgrados_transacciones 
  INNER JOIN public.posgrados_transacciones_detalles ON (public.posgrados_transacciones_detalles.id_posgrado_transaccion = public.posgrados_transacciones.id_posgrado_transaccion)
  
  INNER JOIN public.posgrados_contratos_detalles ON (public.posgrados_contratos_detalles.id_posgrado_contrato_detalle = public.posgrados_transacciones_detalles.id_posgrado_contrato_detalle)

  INNER JOIN public.cuentas_cargos_conceptos_posgrados ON (public.cuentas_cargos_conceptos_posgrados.id_cuenta_cargo_concepto_posgrado = public.posgrados_contratos_detalles.id_cuenta_cargo_concepto_posgrado)
  INNER JOIN public.cuentas_cargos_posgrados_conceptos ON (public.cuentas_cargos_posgrados_conceptos.id_cuenta_cargo_posgrado_concepto = public.cuentas_cargos_conceptos_posgrados.id_cuenta_cargo_posgrado_concepto)
  INNER JOIN public.cuentas_cargos_posgrados ON (public.cuentas_cargos_posgrados.id_cuenta_cargo_posgrado = public.cuentas_cargos_posgrados_conceptos.id_cuenta_cargo_posgrado)
  INNER JOIN public.cuentas_conceptos ON (public.cuentas_conceptos.id_cuenta_concepto = public.cuentas_cargos_posgrados_conceptos.id_cuenta_concepto)
WHERE
  public.posgrados_transacciones.estado = 'S';


  CREATE VIEW v_transaccion_contrato_desglose
AS
SELECT 
  public.posgrados_transacciones.id_posgrado_transaccion,
  public.posgrados_transacciones.id_posgrado_contrato,
  public.posgrados_transacciones.id_persona_alumno_posgrado,
  public.posgrados_transacciones.fecha_transaccion,
  public.posgrados_transacciones_detalles.id_posgrado_transaccion_detalle,
  public.posgrados_transacciones_detalles.id_posgrado_contrato_detalle,
  public.posgrados_transacciones_detalles.fecha_deposito,
  public.posgrados_transacciones_detalles.numero_deposito,
  public.posgrados_transacciones_detalles.monto_deposito,
  public.posgrados_transacciones_detalles.fotografia_deposito,
  public.posgrados_transacciones_detalles.usado_transaccion,

  public.posgrados_transacciones_detalles_desglose.id_transaccion_desglose,
  public.posgrados_transacciones_detalles_desglose.monto_desglosado,
  public.posgrados_transacciones_detalles_desglose.descripcion AS descripcion_transaccion,

  public.posgrados_contratos_detalles.id_cuenta_cargo_concepto_posgrado,
  public.posgrados_contratos_detalles.pagado,
  public.posgrados_contratos_detalles.monto_pagado,
  public.posgrados_contratos_detalles.monto_adeudado,

  public.cuentas_cargos_conceptos_posgrados.costo,
  public.cuentas_cargos_conceptos_posgrados.porcentaje,
  public.cuentas_cargos_conceptos_posgrados.descuento,
  public.cuentas_cargos_conceptos_posgrados.monto_pagar,
  public.cuentas_cargos_conceptos_posgrados.fecha,
  public.cuentas_cargos_conceptos_posgrados.desglose,
  public.cuentas_cargos_posgrados_conceptos.id_cuenta_cargo_posgrado_concepto,

  public.cuentas_cargos_posgrados_conceptos.id_cuenta_concepto,
  public.cuentas_cargos_posgrados_conceptos.tiene_descuento,
  public.cuentas_cargos_posgrados.id_posgrado_programa,
  public.cuentas_cargos_posgrados.nombre AS nombre_cuenta_cargos,
  public.cuentas_cargos_posgrados.numero_formulario,
  public.cuentas_conceptos.nombre AS nombre_concepto
FROM
  public.posgrados_transacciones 
  INNER JOIN public.posgrados_transacciones_detalles ON (public.posgrados_transacciones_detalles.id_posgrado_transaccion = public.posgrados_transacciones.id_posgrado_transaccion)
  INNER JOIN public.posgrados_transacciones_detalles_desglose ON (public.posgrados_transacciones_detalles_desglose.id_posgrado_transaccion_detalle = public.posgrados_transacciones_detalles.id_posgrado_transaccion_detalle)
  
  INNER JOIN public.posgrados_contratos_detalles ON (public.posgrados_contratos_detalles.id_posgrado_contrato_detalle = public.posgrados_transacciones_detalles.id_posgrado_contrato_detalle)
  INNER JOIN public.cuentas_cargos_conceptos_posgrados ON (public.cuentas_cargos_conceptos_posgrados.id_cuenta_cargo_concepto_posgrado = public.posgrados_contratos_detalles.id_cuenta_cargo_concepto_posgrado)
  INNER JOIN public.cuentas_cargos_posgrados_conceptos ON (public.cuentas_cargos_posgrados_conceptos.id_cuenta_cargo_posgrado_concepto = public.cuentas_cargos_conceptos_posgrados.id_cuenta_cargo_posgrado_concepto)
  INNER JOIN public.cuentas_cargos_posgrados ON (public.cuentas_cargos_posgrados.id_cuenta_cargo_posgrado = public.cuentas_cargos_posgrados_conceptos.id_cuenta_cargo_posgrado)
  INNER JOIN public.cuentas_conceptos ON (public.cuentas_conceptos.id_cuenta_concepto = public.cuentas_cargos_posgrados_conceptos.id_cuenta_concepto)

WHERE
  public.posgrados_transacciones.estado = 'S';

-- -- -- -----------------------------------------------------------------------------------------------------

CREATE VIEW v_transacciones_detalles_informe
AS
SELECT 
  public.posgrados_transacciones.id_posgrado_transaccion,
  public.posgrados_transacciones.id_posgrado_contrato,
  public.posgrados_transacciones.id_persona_alumno_posgrado,
  public.posgrados_transacciones.fecha_transaccion,
  public.posgrados_transacciones_detalles.id_posgrado_transaccion_detalle,
  public.posgrados_transacciones_detalles.id_posgrado_contrato_detalle,
  public.posgrados_transacciones_detalles.fecha_deposito,
  public.posgrados_transacciones_detalles.numero_deposito,
  public.posgrados_transacciones_detalles.monto_deposito,
  public.posgrados_transacciones_detalles.fotografia_deposito,
  public.posgrados_transacciones_detalles.usado_transaccion,
  public.montos_excedentes.id_monto_exedente,
  public.montos_excedentes.monto_excedente,
  public.montos_excedentes.procesando,

  public.personas_alumnos_posgrados.id_posgrado_programa,
  public.personas_alumnos_posgrados.id_persona
FROM
  public.posgrados_transacciones 
  INNER JOIN public.posgrados_transacciones_detalles ON (public.posgrados_transacciones_detalles.id_posgrado_transaccion = public.posgrados_transacciones.id_posgrado_transaccion)
  INNER JOIN public.montos_excedentes ON (public.montos_excedentes.id_posgrado_transaccion_detalle = public.posgrados_transacciones_detalles.id_posgrado_transaccion_detalle)

  INNER JOIN public.personas_alumnos_posgrados ON (public.personas_alumnos_posgrados.id_persona_alumno_posgrado = public.posgrados_transacciones.id_persona_alumno_posgrado)
WHERE
  public.posgrados_transacciones.estado = 'S';

-- ---------------------------------------------------------------------------------
-- -------------------------------- Views academic ---------------------------------
-- ---------------------------------------------------------------------------------
CREATE VIEW v_posgrado_asignaciones_docentes AS
SELECT 
  public.posgrado_asignaciones_docentes.id_posgrado_asignacion_docente,
  public.posgrado_asignaciones_docentes.id_persona_docente,
  public.posgrado_asignaciones_docentes.id_posgrado_materia,
  public.posgrado_asignaciones_docentes.id_posgrado_tipo_evaluacion_nota,
  public.posgrado_asignaciones_docentes.id_gestion_periodo,
  public.posgrado_asignaciones_docentes.tipo_calificacion,
  public.posgrado_asignaciones_docentes.grupo,
  public.posgrado_asignaciones_docentes.cupo_maximo_estudiante,
  public.posgrado_asignaciones_docentes.finaliza_planilla_calificacion,
  public.posgrado_asignaciones_docentes.fecha_limite_examen_final,
  public.posgrado_asignaciones_docentes.fecha_limite_nota_2da_instancia,
  public.posgrado_asignaciones_docentes.fecha_limite_nota_examen_mesa,
  public.posgrado_asignaciones_docentes.fecha_finalizacion_planilla,
  public.posgrado_asignaciones_docentes.hash,
  public.posgrado_asignaciones_docentes.codigo_barras,
  public.posgrado_asignaciones_docentes.codigo_qr,
  public.posgrado_asignaciones_docentes.estado,
  public.gestiones_periodos.gestion,
  public.gestiones_periodos.periodo,
  public.personas.id_persona,
  public.personas.numero_identificacion_personal,
  public.personas.paterno,
  public.personas.materno,
  public.personas.nombres,
  public.personas.telefono_celular,
  public.personas.email,
  public.posgrado_materias.id_posgrado_programa,
  public.posgrado_materias.id_posgrado_nivel,
  public.posgrado_materias.sigla,
  public.posgrado_materias.nombre AS nombre_materia,
  public.posgrado_materias.nivel_curso,
  public.posgrado_materias.cantidad_hora_teorica,
  public.posgrado_materias.cantidad_hora_practica,
  public.posgrado_materias.cantidad_hora_laboratorio,
  public.posgrado_materias.cantidad_hora_plataforma,
  public.posgrado_materias.cantidad_hora_virtual,
  public.posgrado_materias.cantidad_credito,
  public.posgrado_materias.color,
  public.posgrado_materias.icono,
  public.posgrado_materias.imagen,
  public.posgrado_tipos_evaluaciones_notas.nombre AS nombre_tipo_evaluacion_nota,
  public.posgrado_tipos_evaluaciones_notas.configuracion,
  public.posgrado_tipos_evaluaciones_notas.nota_minima_aprobacion,
  public.posgrados_programas.id_nivel_academico,
  public.posgrados_programas.id_carrera,
  public.posgrados_programas.gestion AS gestion_programa,
  public.posgrados_programas.nombre AS nombre_programa,
  public.posgrados_programas.id_modalidad,
  public.posgrados_programas.fecha_inicio,
  public.posgrados_programas.fecha_fin,
  public.modalidades.nombre AS nombre_modalidad,
  public.niveles_academicos.nombre AS nombre_nivel_academico
FROM
  public.posgrado_asignaciones_docentes
  INNER JOIN public.personas_docentes ON (public.posgrado_asignaciones_docentes.id_persona_docente = public.personas_docentes.id_persona_docente)
  INNER JOIN public.personas ON (public.personas_docentes.id_persona = public.personas.id_persona)
  INNER JOIN public.posgrado_materias ON (public.posgrado_asignaciones_docentes.id_posgrado_materia = public.posgrado_materias.id_posgrado_materia)
  INNER JOIN public.posgrado_tipos_evaluaciones_notas ON (public.posgrado_asignaciones_docentes.id_posgrado_tipo_evaluacion_nota = public.posgrado_tipos_evaluaciones_notas.id_posgrado_tipo_evaluacion_nota)
  INNER JOIN public.posgrados_programas ON (public.posgrado_materias.id_posgrado_programa = public.posgrados_programas.id_posgrado_programa)
  INNER JOIN public.gestiones_periodos ON (public.posgrado_asignaciones_docentes.id_gestion_periodo = public.gestiones_periodos.id_gestion_periodo)
  INNER JOIN public.modalidades ON (public.posgrados_programas.id_modalidad = public.modalidades.id_modalidad)
  INNER JOIN public.niveles_academicos ON (public.posgrados_programas.id_nivel_academico = public.niveles_academicos.id_nivel_academico);

CREATE VIEW v_posgrado_calificaciones
AS
SELECT 
  public.posgrado_calificaciones.id_postgrado_calificacion,
  public.posgrado_calificaciones.id_persona_alumno_posgrado,
  public.posgrado_calificaciones.id_posgrado_asignacion_docente,
  public.posgrado_calificaciones.tipo_programacion,
  public.posgrado_calificaciones.control_asistencia,
  public.posgrado_calificaciones.configuracion,
  public.posgrado_calificaciones.calificacion1,
  public.posgrado_calificaciones.calificacion2,
  public.posgrado_calificaciones.calificacion3,
  public.posgrado_calificaciones.calificacion4,
  public.posgrado_calificaciones.calificacion5,
  public.posgrado_calificaciones.calificacion6,
  public.posgrado_calificaciones.calificacion7,
  public.posgrado_calificaciones.calificacion8,
  public.posgrado_calificaciones.calificacion9,
  public.posgrado_calificaciones.calificacion10,
  public.posgrado_calificaciones.calificacion11,
  public.posgrado_calificaciones.calificacion12,
  public.posgrado_calificaciones.calificacion13,
  public.posgrado_calificaciones.calificacion14,
  public.posgrado_calificaciones.calificacion15,
  public.posgrado_calificaciones.calificacion16,
  public.posgrado_calificaciones.calificacion17,
  public.posgrado_calificaciones.calificacion18,
  public.posgrado_calificaciones.calificacion19,
  public.posgrado_calificaciones.calificacion20,
  public.posgrado_calificaciones.nota_final,
  public.posgrado_calificaciones.nota_2da_instancia,
  public.posgrado_calificaciones.nota_examen_mesa,
  public.posgrado_calificaciones.observacion,
  public.posgrado_calificaciones.tipo,
  public.posgrado_calificaciones.estado,
  public.personas_alumnos_posgrados.id_persona,
  public.personas_alumnos_posgrados.id_posgrado_programa,
  public.personas.numero_identificacion_personal,
  public.personas.paterno,
  public.personas.materno,
  public.personas.nombres,
  public.personas.id_sexo,
  public.sexos.nombre AS nombre_sexo,
  iff(public.posgrado_calificaciones.nota_2da_instancia > 0, public.posgrado_calificaciones.nota_2da_instancia, public.posgrado_calificaciones.nota_final) AS nota_final_todo,
  numeraltoliteral(iff(public.posgrado_calificaciones.nota_2da_instancia > 0, public.posgrado_calificaciones.nota_2da_instancia, public.posgrado_calificaciones.nota_final)) AS literal_nota_final_todo
FROM
  public.posgrado_calificaciones
  INNER JOIN public.personas_alumnos_posgrados ON (public.posgrado_calificaciones.id_persona_alumno_posgrado = public.personas_alumnos_posgrados.id_persona_alumno_posgrado)
  INNER JOIN public.personas ON (public.personas_alumnos_posgrados.id_persona = public.personas.id_persona)
  INNER JOIN public.sexos ON (public.personas.id_sexo = public.sexos.id_sexo)
ORDER BY
  public.personas.paterno,
  public.personas.materno,
  public.personas.nombres;

-- --------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------ DATA --------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
INSERT INTO modulos (nombre)
VALUES
('SUBSISTEMA DE ADMINISTRACION'),
('SUBSISTEMA DE GESTION ACADEMICA'),
('SUBSISTEMA DE PLANIFICACION'), -- -- Calendario y horarios
('SUBSISTEMA DE DOCENTES'),
('SUBSISTEMA DE ESTUDIANTES'),
('SUBSISTEMA DE TRAMITES');

INSERT INTO roles (nombre, descripcion)
VALUES
('Admin','Responsable de gestionar y supervisar los programas de posgrado'),
('Financiero','Responsable de la parte Financiera, verificar transacciones y genera reportes'),
('Estudiante Postgrado','Estudiante que está cursando un programa de posgrado'),
('Director Academico','Responsable de la Parte Academica'),
('Docente','Docente de materias de posgrado');

INSERT INTO menus_principales(id_modulo,nombre,icono,orden) 
VALUES
(1,'Roles y Permisos','ri-group-line',1),   
(1,'Usuarios','ri-user-3-line',2),
(1,'Carreras','ri-folder-open-fill',3),           
(1,'Programas','ri-folder-chart-line',4),
(1,'Valores','ri-folder-open-fill',5),
(6,'Requisitos Inscripción','ri-folder-2-line',6),         
(1,'Inscripcion','ri-ball-pen-fill',7),       
(1,'Caja','ri-bank-card-fill',8),                
(1,'Informes','ri-printer-cloud-fill',9),  
(1,'Base Datos','ri-database-2-fill',10),  
(5,'Administrativo','ri-folder-user-line',11), 
(1,'Extracto Bancario','ri-currency-fill',12),
(4,'eDocente','ri-currency-fill',13),
(5,'Academico','ri-folder-user-line',14),
(3,'Academico Docente','ri-folder-user-line',15),
(3,'Planificacion','ri-folder-user-line',16);

INSERT INTO roles_menus_principales (id_rol,id_menu_principal,estado) 
VALUES
(1,1,'S'),-- Rol Admin
(1,2,'S'),
(1,3,'S'),
(1,10,'S'),
(2,4,'S'), -- Rol Financiero
(2,5,'S'),
(2,6,'S'),
(2,7,'S'),
(2,8,'S'),
(2,9,'S'),
(2,12,'S'),
(3,11,'S'), -- Rol estudiante administrativo
(3,14,'S'), -- Rol estudiante academico
(5,13,'S'), -- Rol de docente
(4,15,'S'),	-- Rol Director Academico Academico Docente
(4,16,'S'),	-- Rol Director Academico Planificacion
(4,9,'S');	-- Rol Director Academico Informes 

INSERT INTO menus (id_menu_principal,nombre,directorio,orden)
VALUES
(1,'Rol','rolCrud',3),
(1,'Tipos Personas','personas_tiposCrud',4),
(1,'Config Menus - Roles Menu Principales','config_menu_roles',5),

(2,'Personas','personaCrud',1),
(2,'Roles Tipos Personas','roles_personas',2),
(2,'Configuracines Adicionales','config_adicionales',6),

(3,'Area','areaCrud',1),
(3,'facultad','facultadCrud',2),
(3,'Carrera','carreraCrud',3),

(4,'Modalidad','modalidadCrud',1),
(4,'Nivel Academico','nivel_academicoCrud',2),
(4,'Programas','posgrado_programaCrud',3),

(5,'Cuentas Conceptos','cuenta_conceptoCrud',1),
(5,'Cuentas Cargo Posgrado','cuenta_cargo_posgradoCrud',2),
(5,'Cuentas Cargo Conceptos','cuenta_car_pos_concepCrud',3),
(5,'Cuentas Cargo Conceptos Posgrado','cuenta_cargo_conceptoCrud',4),

(6,'Tramite Documento','tramite_docCrud',1),
(6,'Nivel Academico Documento','nivel_acad_docCrud',2),
(6,'Posgrado Alumno Documento','posgrado_alum_docCrud',3),

(7,'Alumnos','persona_alumno_posgradoCrud',1),
(7,'Contrato ','posgrado_contratoCrud',2),
(7,'Contrato Detalle','posgrado_contrato_detalleCrud',3),
(7,'Contrato Desglose','posgrado_contrato_desgloseCrud',4),

(8,'Transaccion','posgrado_transaccionCrud',5),
(8,'Transaccion Detalle','posgrado_transaccion_detalleCrud',5),
(8,'Transaccion Desglose','posgrado_trans_desgloseCrud',5),

-- -- -- -- -- -- -- ----------------------------------------------
(9,'Informe por Personas','informePersona',1),
(9,'Informe por Programas','informePrograma',2),

(10,'Copia de Seguridad','copiaSeguridad',1),
(10,'Restaurar Base Datos','restaurarBDatos',2),

(11,'Inscripcion','estPostgradoInscripcion',1),
(11,'Contratos','estPostgradoContrato',2),
(11,'Transacciones','estPostgradoTransaccion',3),
(11,'Informe Transacciones','informeTransacciones',4),

(12,'Extracto Bancario','extractoBancario',1),

-- ------- Academico docente ------------------------------
(13,'Perfil','docentes',1),
(13,'Horarios','horarios',2),
(13,'Calificaciones','calificaciones',3),

-- ------- Academico Estudiante ------------------------------
(14,'Calificaciones','calificacionesest',1),
(14,'Horarios','horariosest',2),
(14,'Kardex','kardex',3),
(14,'Planes de Estudio','docPostgradoPlan',4),

-- -------- Academico Docente -------------------------------------
(15,'Docentes','calificacionesest',1),
(15,'Programación Docente Materia','calificacionesest',2),
(15,'Alumnos Programación Materia','horariosest',3), 

-- -------- Planificacion -------------------------------------
(16,'Calendario','calificacionesest',1),
(16,'Asignacion Horarios','horariosest',2); -- -- Asignacion horarios---

INSERT INTO grupos_sanguineos (nombre, estado)
VALUES 
  ('No Sabe', 'S'),
  ('0 RN(-)', 'S'),
  ('0 RH(-)', 'S'),
  ('0 RH(+)', 'S'),
  ('A RN(-)', 'S'),
  ('A RH(-)', 'S'),
  ('A RH(+)', 'S'),
  ('B RN(-)', 'S'),
  ('B RH(-)', 'S'),
  ('B RH(+)', 'S'),
  ('AB RN(-)', 'S'),
  ('AB RH(-)', 'S'),
  ('AB RH(+)', 'S');

INSERT INTO sexos (nombre, estado)
VALUES
  ('SIN DESIGNAR', 'S'),
  ('FEMENINO', 'S'),
  ('MASCULINO', 'S');

INSERT INTO estados_civiles (nombre, estado)
VALUES
  ('SIN DESIGNAR', 'S'),
  ('SOLTERO', 'S'),
  ('CASADO', 'S'),
  ('DIVORCIADO', 'S'),
  ('VIUDO', 'S');

INSERT INTO emision_cedulas (nombre,descripcion,estado)
VALUES 
  ('SIN','SIN DESIGNAR', 'S'),
  ('CH','CHUQUISACA', 'S'),
  ('PT','POTOSI', 'S'),
  ('OR','ORURO', 'S'),
  ('TJ','TARIJA', 'S'),
  ('LP','LA PAZ', 'S'),
  ('CB','COCHABAMBA', 'S'),
  ('SC','SANTA CRUZ', 'S'),
  ('BN','BENI', 'S'),
  ('PN','PANDO', 'S'),
  ('OT','OTRO', 'S');

INSERT INTO paises (nombre,estado) 
VALUES 
('SIN PAIS', 'S'),
('BOLIVIA', 'S');

INSERT INTO departamentos (id_pais,nombre,estado) 
VALUES 
(1,'SIN DEPARTAMEN', 'S'),
(2,'CHUQUISACA', 'S'),
(2,'POTOSÍ', 'S');

INSERT INTO provincias (id_departamento,nombre,estado) 
VALUES 
(1, 'SIN PROVINCIA', 'S'),
(2, 'OROPEZA', 'S'),
(2, 'TOMINA', 'S'),
(3, 'CHAYANTA', 'S'),
(3, 'CHARCAS', 'S');

INSERT INTO localidades (id_provincia,nombre,estado) 
VALUES 
(1, 'SIN LOCALIDAD', 'S'),
(2, 'SUCRE', 'S'),
(2, 'YOTALA', 'S'),
(3, 'TOMINA', 'S'),
(3, 'PADILA', 'S'),
(4, 'COLQUECHACA', 'S'),
(4, 'MACHA', 'S'),
(5, 'SAN PEDRO BUENA VISTA', 'S'),
(5, 'TORO TORO', 'S');

-- -- admin> user: adminadmin password: osooso

INSERT INTO personas(id_localidad,numero_identificacion_personal,id_emision_cedula,paterno,materno,nombres,id_sexo,id_grupo_sanguineo,
    fecha_nacimiento,direccion,latitud,longitud,telefono_celular,telefono_fijo,zona,id_estado_civil,email,fotografia,usuario,password,abreviacion_titulo,estado)
VALUES 
(1,'1234567',1,'Perez','Lozano','Juan',1,1,'10/1/2019','direccion 0','1.3434','1.1212','69666703','26227300','central',1,'admin@gmail.com','default.webp','adminadmin','b6fca55d990cc29c8947c03d2217e0893edfc0bb','...','S'),
(1,'1111111',1,'Michel','Hinojoza','Noelia',1,1,'10/1/2019','direccion 1','1.3434','1.1212','69666702','26227301','central',1,'hinojoza@gmail.com','default.webp','financiero1','b6fca55d990cc29c8947c03d2217e0893edfc0bb','Lic.','S'),
(1,'2222222',1,'Chirveches','Azurduy','Rosa',1,1,'10/1/2019','direccion 2','1.3434','1.1212','69666704','26227302','central',1,'azurduy@gmail.com','default.webp','financiero2','b6fca55d990cc29c8947c03d2217e0893edfc0bb','Dr.','S'),
(1,'1222222',1,'Perez','Lopez','Mario',1,1,'10/1/2019','direccion 2','1.3434','1.1212','69666705','26227303','central',1,'lopez@gmail.com','default.webp','docente','b6fca55d990cc29c8947c03d2217e0893edfc0bb','Dr.','S'),
(1,'3222222',1,'Quispe','Mamani','Gabriela',1,1,'10/1/2019','direccion 2','1.3434','1.1212','69666706','26227304','central',1,'mamani@gmail.com','default.webp','director','b6fca55d990cc29c8947c03d2217e0893edfc0bb','Dr.','S'),
(1,'4222222',1,'Soria','Rodrigues','Franco',1,1,'10/1/2019','direccion 2','1.3434','1.1212','69666707','26227305','central',1,'rodrigues@gmail.com','default.webp','estudiante2','b6fca55d990cc29c8947c03d2217e0893edfc0bb','Univ.','S'),
(1,'5222222',1,'Lozano','Mamani','Maria',1,1,'10/1/2019','direccion 2','1.3434','1.1212','69666708','26227306','central',1,'lozano@gmail.com','default.webp','estudiante3','b6fca55d990cc29c8947c03d2217e0893edfc0bb','Univ.','S'),
(1,'6222222',1,'Flores','Lopez','Emily',1,1,'10/1/2019','direccion 2','1.3434','1.1212','69666709','26227307','central',1,'flores@gmail.com','default.webp','estudiante4','b6fca55d990cc29c8947c03d2217e0893edfc0bb','Univ.','S'),
(1,'7222222',1,'Morales','Lugones','Abran',1,1,'10/1/2019','direccion 2','1.3434','1.1212','69666711','26227308','central',1,'morales@gmail.com','default.webp','estudiante5','b6fca55d990cc29c8947c03d2217e0893edfc0bb','Univ.','S'),
(1,'8222222',1,'Mamani','Flores','Juan Carlos',1,1,'10/1/2019','direccion 2','1.3434','1.1212','69666713','26227309','central',1,'flores@gmail.com','default.webp','estudiante6','b6fca55d990cc29c8947c03d2217e0893edfc0bb','Univ.','S'),
(1,'9222222',1,'Puma','Hinijoza','Maria Elena',1,1,'10/1/2019','direccion 2','1.3434','1.1212','69666714','26227310','central',1,'puma@gmail.com','default.webp','estudiante7','b6fca55d990cc29c8947c03d2217e0893edfc0bb','Univ.','S'),
(1,'1022222',1,'Azurduy','Cruz','Juan Jose',1,1,'10/1/2019','direccion 2','1.3434','1.1212','69666715','26227311','central',1,'cruz@gmail.com','default.webp','estudiante8','b6fca55d990cc29c8947c03d2217e0893edfc0bb','Univ.','S'),
(1,'1122222',1,'Corrales','Flores','Maria Jose',1,1,'10/1/2019','direccion 2','1.3434','1.1212','69666716','2622711','central',1,'corrales@gmail.com','default.webp','estudiante9','b6fca55d990cc29c8947c03d2217e0893edfc0bb','Univ.','S'),
(1,'12365424',1,'Rojas','Vidovic','Juan Carlos',1,1,'10/1/2019','direccion sin designar','1.3434','1.1212','79666797','26227312','central',1,'rojas@gmail.com','default.webp','Diretor Ejecutivo','b6fca55d990cc29c8947c03d2217e0893edfc0bb','Dr Eje.','S'),
(1,'2564383',1,'Ramos','Ruilova','Juan Carlos',1,1,'10/1/2019','direccion sin designar','1.3434','1.1212','79666708','26227313','central',1,'ramos2@gmail.com','default.webp','Decano Facultad','b6fca55d990cc29c8947c03d2217e0893edfc0bb','Decano.','S'),
(1,'69684524',1,'Ortiz','Limón','Miguel',1,1,'10/1/2019','direccion sin designar','1.3434','1.1212','79666773','26227314','central',1,'ortiz2@gmail.com','default.webp','Administrador Facultad','b6fca55d990cc29c8947c03d2217e0893edfc0bb','AdminFac.','S');

INSERT INTO tipos_personas (id_persona,id_rol,tipo,estado)
VALUES 
  (1,1,'A','S'),
  (2,2,'S','S'),
  (3,2,'S','S'),
  (4,5,'D','S'),
  (5,4,'P','S'),
  (6,3,'E','S'),
  (7,3,'E','S'),
  (9,3,'E','S'),
  (10,3,'E','S'),
  (11,3,'E','S'),
  (12,3,'E','S'),
  (13,3,'E','S');

INSERT INTO personas_directores_posgrados (id_persona,fecha_inicio, fecha_fin, estado)
VALUES 
  (14,'1/1/2023','1/1/2025','S');

INSERT INTO personas_facultades_administradores (id_persona, fecha_inicio, fecha_fin, estado)
VALUES 
  (15,'1/1/2023','10/1/2025','S');

INSERT INTO carreras_niveles_academicos (nombre, descripcion, estado)
VALUES 
  ('Técnico Medio', 'La formación técnica y práctica en un área específica.','S'),
  ('Técnico Superior', 'Similar al técnico medio, pero con un enfoque más avanzado', 'S'),
  ('Licenciatura', 'Nivel de educación más común y se refiere a la carrera universitaria de pregrado', 'S');
  
INSERT INTO niveles_academicos (nombre, descripcion, estado)
VALUES 
  ('Diplomado', 'Es un programa de especialización que se enfoca en la adquisición de habilidades específicas', 'S'),
  ('Especialidad', 'Similar al diplomado, pero con un enfoque más avanzado y especializado en un área específica', 'S'),
  ('Maestría', 'Nivel de educación se enfoca en la formación avanzada en un área específica.', 'S'),
  ('Doctorado', 'Este es el nivel de educación más avanzado y se enfoca en la investigación original en un área específica', 'S');

INSERT INTO modalidades (nombre, descripcion, estado)
VALUES 
  ('Presencial','La educación tradicional en persona','S'),
  ('Semi Presencial','La educación a distancia que incluye cierta instrucción en persona','S'),
  ('Virtual','La educación completamente en línea o a distancia','S');

INSERT INTO universidades(nombre,nombre_abreviado,inicial,estado)
VALUES ('UNIVERSIDAD MAYOR REAL Y PONTIFICIA DE SAN FRANCISCO XAVIER DE CHUQUISACA','SAN FRANCISCO XAVIER','U.S.F.X.','S');

INSERT INTO areas(id_universidad,nombre,nombre_abreviado,estado)
VALUES 
  (1,'Ciencias Sociales','Sociales','S'),
  (1,'Ciencias de la Salud','Salud','S'),
  (1,'Ciencias Economicas','Economicas','S'),
  (1,'Ciencias Tecnologicas','Tecnologicas','S');

INSERT INTO facultades(id_area,nombre,nombre_abreviado)
VALUES 
  (2, 'FACULTAD DE MEDICINA','FAC. MEDICINA'),
  (4, 'FACULTAD DE CIENCIAS Y TECNOLOGIA','FAC. CIENCIAS Y TEC.');

INSERT INTO sedes(nombre,estado)
VALUES 
  ('CIUDAD','S'),
  ('PROVINCIA','S');  

INSERT INTO carreras(id_facultad,id_modalidad,id_carrera_nivel_academico,id_sede,nombre,nombre_abreviado)
VALUES
	(1,1,3,1,'MEDICINA','MEDICINA'),
	(2,1,3,1,'INGENIERIA DE SISTEMAS','ING. DE SISTEMAS');

INSERT INTO personas_decanos (id_persona, id_facultad, fecha_inicio, fecha_fin, estado)
VALUES 
  (16,2,'1/1/2023','10/1/2025','S');

INSERT INTO posgrados_programas (id_nivel_academico,id_carrera,gestion,nombre,id_modalidad,fecha_inicio,fecha_fin,costo_total,numero_max_cuotas)
VALUES
	(1,2,2023,'Diplomado en Nanotecnología Aplicada, version II',1,'10/1/2023','10/1/2024',4800.00,5),
	(1,2,2023,'Diplomado en Seguridad Informatica, versión II',2,'10/1/2023','10/1/2024',4800.00,5),
	(2,2,2023,'Especialidad Superior en Redes de Datos, versión I',1,'10/1/2023','10/1/2024',10000.00,7),
	(2,2,2023,'Especialidad Superior en Redes, version II',1,'10/1/2023','10/1/2024',10000.00,7),
	(3,2,2023,'Maestría en Derecho Informatico, version I',1,'10/1/2023','10/1/2024',14975.00,10);

INSERT INTO tramites_documentos (nombre,descripcion,estado)
VALUES
	('Certificado Nacimiento','','S'),
	('Cedula de Identidad','Carnet de Identidad o Pasaporte (Extranjeros)','S'),
	('Titulo de Bachiller','Titulo de Bachiller homologado por ceduca','S'),
	('Diploma Académico ','Diploma Académico a nivel Técnico Superior o Licenciatura','S'),
	('Título en Provisión Nacional a nivel Licenciatura','Diploma Académico Título en Provisión Nacional a nivel Licenciatura','S'),
	('Título de Maestría','','S');

INSERT INTO niveles_academicos_tramites_documentos (id_nivel_academico,id_tramite_documento,estado)
VALUES
	(1,2,'S'),
	(1,3,'S'),
	(1,4,'S'),
	(2,2,'S'),
	(2,3,'S'),	
	(2,4,'S'),
	(3,2,'S'),
	(3,3,'S'),
	(3,4,'S'),
	(3,5,'S');

INSERT INTO cuentas_conceptos (nombre, descripcion, estado)
VALUES 
  ('Matricula Postgrado', 'Concepto de matricula postgrado', 'S'),
  ('Colegiatura Postgrado', 'Concepto de colegiatura postgrado', 'S'),
  ('Defensa Postgrado', 'Conceptos de defensa postgrado', 'S'),
  ('Matricula', 'Concepto matricula', 'S'),
  ('Colegiatura', 'Concepto colegiatura', 'S'),
  ('Defensa', 'Concepto defensa', 'S');

INSERT INTO cuentas_cargos_posgrados (id_posgrado_programa, nombre, numero_formulario, estado)
VALUES 
	(1,'Costo del Diplomado en Nanotecnología Aplicada, version II (Sin Descuento)','1','S'),
	(1,'Costo del Diplomado en Nanotecnología Aplicada, version II (5% Descuento SIB)','2','S'),
	(1,'Costo del Diplomado en Nanotecnología Aplicada, version II (10% Estudiantes USFXCh)','3','S'),
	(1,'Costo del Diplomado en Nanotecnología Aplicada, version II (20% Descuento docentes)','4','S'),
	(2,'Costo del Diplomado en Seguridad Informatica, version II (Sin Descuento)','1','S'),
	(2,'Costo del Diplomado en Seguridad Informatica, version II (5% Descuento SIB)','2','S'),
	(2,'Costo del Diplomado en Seguridad Informatica, version II (10% Estudiantes USFXCh)','3','S'),
	(2,'Costo del Diplomado en Seguridad Informatica, version II (20% Descuento docentes)','4','S'),  
	(3,'Costo de la Especialidad Superior en Redes de Datos, version I (Sin Descuento)','1','S'),
	(3,'Costo de la Especialidad Superior en Redes de Datos, version I (5% Descuento SIB)','2','S'),
	(3,'Costo de la Especialidad Superior en Redes de Datos, version I (10% Estudiantes USFXCh)','3','S'),
	(3,'Costo de la Especialidad Superior en Redes de Datos, version I (20% Descuento docentes)','4','S'),
	(4,'Costo de la Especialidad Superior en Redes, version II (Sin Descuento)','1','S'),
	(4,'Costo de la Especialidad Superior en Redes, version II (5% Descuento SIB)','2','S'),
	(4,'Costo de la Especialidad Superior en Redes, version II (10% Estudiantes USFXCh)','3','S'),
	(4,'Costo de la Especialidad Superior en Redes, version II (20% Descuento docentes)','4','S'),
	(5,'Costo de Maestría en Derecho Informatico, version I (Sin Descuento)','1','S'),
	(5,'Costo de Maestría en Derecho Informatico, version I (5% Descuento SIB)','2','S'),
	(5,'Costo de Maestría en Derecho Informatico, version I (10% Estudiantes USFXCh)','3','S'),
	(5,'Costo de Maestría en Derecho Informatico, version I (20% Descuento docentes)','4','S');

INSERT INTO cuentas_cargos_posgrados_conceptos (id_cuenta_cargo_posgrado, id_cuenta_concepto, tiene_descuento, estado)
VALUES 
	(1,1,'N','S'),
	(1,2,'N','S'),
	(2,1,'N','S'),
	(2,2,'S','S'),
	(3,1,'N','S'),
	(3,2,'S','S'),
	(4,1,'N','S'),
	(4,2,'S','S'), -- -- diplomado Diplomado en Nanotecnología Aplicada	
	(5,1,'N','S'),
	(5,2,'N','S'),
	(6,1,'N','S'),
	(6,2,'S','S'),
	(7,1,'N','S'),
	(7,2,'S','S'),
	(8,1,'N','S'),
	(8,2,'S','S'), -- -- Diplomado en Seguridad Informatica
	(9,1,'N','S'),
	(9,2,'N','S'),
	(9,3,'N','S'),
	(10,1,'N','S'),
	(10,2,'S','S'),
	(10,3,'N','S'),
	(11,1,'N','S'),
	(11,2,'S','S'),
	(11,3,'N','S'),
	(12,1,'N','S'),
	(12,2,'S','S'),
	(12,3,'N','S'), -- -- Especialidad Superior en Redes de Datos, versión I

    (13,1,'N','S'),
	(13,2,'N','S'),
	(13,3,'N','S'),
    (14,1,'N','S'),
	(14,2,'S','S'),
	(14,3,'N','S'),
    (15,1,'N','S'),
	(15,2,'S','S'),
	(15,3,'N','S'),
    (16,1,'N','S'),
	(16,2,'S','S'),
	(16,3,'N','S'),   -- -- Especialidad Superior en Redes, version II
    (17,1,'N','S'),
	(17,2,'N','S'),
	(17,3,'N','S'),
    (18,1,'N','S'),
	(18,2,'S','S'),
	(18,3,'N','S'),
    (19,1,'N','S'),
	(19,2,'S','S'),
	(19,3,'N','S'),
    (20,1,'N','S'),
	(20,2,'S','S'),
	(20,3,'N','S');  -- -- Maestría en Derecho Informatico, version I
    

INSERT INTO cuentas_cargos_conceptos_posgrados (id_cuenta_cargo_posgrado_concepto, costo, porcentaje, descuento, monto_pagar, desglose)
VALUES 
	(1, 480.00, 0, 0, 480.00, 'false'),
    (2, 4320.00, 0, 0, 4320.00, 'true'),
    (3, 480.00, 0, 0, 480.00, 'false'),
    (4, 4320.00, 5, 216, 4104.00, 'true'),
    (5, 480.00, 0, 0, 480.00, 'false'),
    (6, 4320.00, 10, 432, 3888.00, 'true'),
    (7, 480.00, 0, 0, 480.00, 'false'),
    (8, 4320.00, 20, 864, 3456.00, 'true'), -- -- diplomado Diplomado en Nanotecnología Aplicada
    (9, 480.00, 0, 0, 480.00, 'false'),
    (10, 4320.00, 0, 0, 4320.00, 'true'),
    (11, 480.00, 0, 0, 480.00, 'false'),
    (12, 4320.00, 5, 216, 4104.00, 'true'),
    (13, 480.00, 0, 0, 480.00, 'false'),
    (14, 4320.00, 10, 432, 3888.00, 'true'),
    (15, 480.00, 0, 0, 480.00, 'false'),
    (16, 4320.00, 20, 864, 3456.00, 'true'), -- -- Diplomado en Seguridad Informatica
    (17, 752.50, 0, 0, 752.50, 'false'),
    (18, 6772.50, 0, 0, 6772.50, 'true'),
    (19, 2475.00, 0, 0, 2475.00, 'false'),
    (20, 752.50, 0, 0, 752.50, 'false'),
    (21, 6772.50, 5, 338.62, 6433.88, 'true'),
    (22, 2475.00, 0, 0, 2475.00, 'false'),
    (23, 752.50, 0, 0, 752.50, 'false'),
    (24, 6772.50, 10, 677.25, 6095.25, 'true'),
    (25, 2475.00, 0, 0, 2475.00, 'false'),
    (26, 752.50, 0, 0, 752.50, 'false'),
    (27, 6772.50, 20, 1354.50, 5418.00, 'true'),
    (28, 2475.00, 0, 0, 2475.00, 'false'), -- -- Especialidad Superior en Redes de Datos, versión I

    (29, 752.50, 0, 0, 752.50, 'false'),
    (30, 6772.50, 0, 0, 6772.50, 'true'),
    (31, 2475.00, 0, 0, 2475.00, 'false'),
    (32, 752.50, 0, 0, 752.50, 'false'),
    (33, 6772.50, 5, 338.62, 6433.88, 'true'),
    (34, 2475.00, 0, 0, 2475.00, 'false'),
    (35, 752.50, 0, 0, 752.50, 'false'),
    (36, 6772.50, 10, 677.25, 6095.25, 'true'),
    (37, 2475.00, 0, 0, 2475.00, 'false'),
    (38, 752.50, 0, 0, 752.50, 'false'),
    (39, 6772.50, 20, 1354.50, 5418.00, 'true'),
    (40, 2475.00, 0, 0, 2475.00, 'false'), -- -- Especialidad Superior en Redes de Datos, versión I

    (41, 1250.00, 0, 0, 1250.00, 'false'),
    (42, 11250.00, 0, 0, 11250.00, 'true'),
    (43, 2475.00, 0, 0, 2475.00, 'false'),
    (44, 1250.00, 0, 0, 1250.00, 'false'),
    (45, 11250.00, 5, 562.50, 10687.50, 'true'),
    (46, 2475.00, 0, 0, 2475.00, 'false'),
    (47, 1250.00, 0, 0, 1250.00, 'false'),
    (48, 11250.00, 10, 1125.00, 10125.00, 'true'),
    (49, 2475.00, 0, 0, 2475.00, 'false'),
    (50, 1250.00, 0, 0, 1250.00, 'false'),
    (51, 11250.00, 20, 2250.00, 9000.00, 'true'),
    (52, 2475.00, 0, 0, 2475.00, 'false'); -- -- Especialidad Superior en Redes de Datos, versión I

-- -- -- -- --------------- INSERT INTO FOR POST GRADO ACADEMIC ---------------------
INSERT INTO personas_docentes(id_persona) VALUES (4);
INSERT INTO gestiones_periodos(gestion,periodo,tipo) VALUES(2022,1,'A');

INSERT INTO posgrado_niveles(nombre)
VALUES
	('Basica'),
	('Avanzada'),
	('Especializada'),
	('Investigacion');
	
INSERT INTO posgrado_materias(id_posgrado_programa,id_posgrado_nivel,sigla,nombre)
VALUES
	(3,1,'RED001','INTRODUCCIÓN A REDES'),
	(3,1,'RED002','PRINCIPIOS BÁSICOS DE ROUTING Y SWITCHING'),
	(3,2,'RED003','ESCALAMIENTO DE REDES'),
	(3,2,'RED004','CONEXIÓN DE REDES'),
	(3,2,'RED005','SEGURIDAD DE REDES'),
	(3,3,'RED006','PROGRAMACIÓN EN REDES'),
	(3,3,'RED007','REDES IoT'),
	(3,4,'RED008','METODOLOGÍA DE LA INVESTIGACIÓN'),
	(3,4,'RED009','TALLER DE TRABAJO DE GRADO I'),
	(3,4,'RED010','TALLER DE TRABAJO DE GRADO II');

INSERT INTO posgrado_tipos_evaluaciones_notas(nombre,configuracion,nota_minima_aprobacion)
VALUES
	('A','[{"parcial":40,"campo":"calificacion1"},{"final":60,"campo":"nota_final"}]',65);

INSERT INTO posgrado_asignaciones_docentes(id_persona_docente,id_posgrado_materia,id_posgrado_tipo_evaluacion_nota,id_gestion_periodo,grupo)
VALUES
	(1,1,1,1,'G1'),
	(1,2,1,1,'G1');

INSERT INTO personas_alumnos_posgrados(id_persona,id_posgrado_programa)
VALUES
	(6,3),
	(7,3),
	(8,3),
 	(9,3),
	(10,3),
	(11,3),
	(12,3),
	(13,3);

INSERT INTO posgrado_calificaciones(id_persona_alumno_posgrado,id_posgrado_asignacion_docente)
VALUES
	(1,1),
	(2,1),
	(3,1),
	(4,1),
	(5,1),
	(6,1),
	(7,1),
	(8,1),
	(1,2),
	(2,2),
	(3,2),
	(4,2),
	(5,2),
	(6,2),
	(7,2),
	(8,2);
-- ----------------------------- Data ambientes ------------------------------------
INSERT INTO dias (id_dia, numero, nombre, estado) VALUES
  (1, 0, 'Domingo', 'S'),
  (2, 1, 'Lunes', 'S'),
  (3, 2, 'Martes', 'S'),
  (4, 3, 'Miercoles', 'S'),
  (5, 4, 'Jueves', 'S'),
  (6, 5, 'Viernes', 'S'),
  (7, 6, 'Sabado', 'S');

INSERT INTO horas_clases (id_hora_clase, numero, hora_inicio, hora_fin, estado) VALUES
  (1, 1, '07:00:00', '07:45:00', 'S'),
  (2, 2, '07:45:00', '08:30:00', 'S'),
  (3, 3, '08:30:00', '09:15:00', 'S'),
  (4, 4, '09:15:00', '10:00:00', 'S'),
  (5, 5, '10:00:00', '10:45:00', 'S'),
  (6, 6, '10:45:00', '11:30:00', 'S'),
  (7, 7, '11:30:00', '12:15:00', 'S'),
  (8, 8, '12:15:00', '13:00:00', 'S'),
  (9, 9, '14:00:00', '14:45:00', 'S'),
  (10, 10, '14:45:00', '15:30:00', 'S'),
  (11, 11, '15:30:00', '16:15:00', 'S'),
  (12, 12, '16:15:00', '17:00:00', 'S'),
  (13, 13, '17:00:00', '17:45:00', 'S'),
  (14, 14, '17:45:00', '18:30:00', 'S'),
  (15, 15, '18:30:00', '19:15:00', 'S'),
  (16, 16, '19:15:00', '20:00:00', 'S'),
  (17, 17, '20:00:00', '20:45:00', 'S'),
  (18, 18, '20:45:00', '21:30:00', 'S');

INSERT INTO campus (id_campu, nombre, direccion, poligono, latitud, longitud, imagen, estado) VALUES
  (1, 'HOSPITAL', NULL, '-19.040516,-65.257506,-19.041316,-65.257506,-19.041316,-65.256406,-19.040516,-65.256406', NULL, NULL, NULL, 'S'),
  (2, 'CIUDADELA UNIVERSITARIA', NULL, '-19.039714,-65.257185,-19.039414,-65.256885,-19.039714,-65.256585,-19.040014,-65.256585,-19.040314,-65.256885', NULL, NULL, NULL, 'S'),
  (3, 'NOGALES MEDICINA', NULL, '-19.038000,-65.255000,-19.040500,-65.258500,-19.037000,-65.260000', NULL, NULL, NULL, 'S');
  
 -- -- Desde aqui

INSERT INTO edificios (id_edificio, id_campu, nombre, direccion, latitud, longitud, imagen, estado) VALUES
  (1, 1, 'EDIF.HOSPITAL', NULL, '-19.039713523661863', '-65.25688455916337', 'facultad tecnologia.jpg', 'S'),
  (2, 2, 'EDIF.UNIV.', NULL, '-19.04051619686859', '-65.25720587474858', 'hospital universitario.jpeg', 'S');

INSERT INTO facultades_edificios (id_facultad_edificio, id_facultad, id_edificio, fecha_asignacion, estado) VALUES
  (1, 1, 1, '2019-04-20', 'S'),
  (2, 1, 2, '2019-04-20', 'S');

INSERT INTO bloques (id_bloque, id_edificio, nombre, imagen, estado) VALUES
  (1, 1, 'BLOQUE A', NULL, 'S'),
  (2, 1, 'BLOQUE B', NULL, 'S'),
  (3, 2, 'BLOQUE 1', NULL, 'S');

INSERT INTO pisos (id_piso, numero, nombre, estado) VALUES
  (1, -2, 'SUBSUELO', 'S'),
  (2, -1, 'ZOTANO', 'S'),
  (3, 0, 'PLANTA BAJA', 'S'),
  (4, 1, 'PRIMER PISO', 'S'),
  (5, 2, 'SEGUNDO PISO', 'S'),
  (6, 3, 'TERCER PISO', 'S'),
  (7, 4, 'CUARTO PISO', 'S'),
  (8, 5, 'QUINTO PISO', 'S'),
  (9, 6, 'SEXTO PISO', 'S'),
  (10, 7, 'SEPTIMO PISO', 'S'),
  (11, 8, 'OCTAVO PISO', 'S'),
  (12, 9, 'NOVENO PISO', 'S'),
  (13, 10, 'DECIMO PISO', 'S');

INSERT INTO pisos_bloques (id_piso_bloque, id_bloque, id_piso, nombre, cantidad_ambientes, imagen, estado) VALUES
  (1, 1, 3, 'HOSP1', 2, NULL, 'S'),
  (2, 1, 4, 'HOSP2', 3, NULL, 'S'),
  (3, 1, 5, 'HOSP3', 3, NULL, 'S'),
  (4, 3, 6, 'PISO4', 6, NULL, 'S'),
  (5, 3, 7, 'PISO5', 6, NULL, 'S'),
  (6, 2, 3, 'SALUD1', 10, NULL, 'S'),
  (7, 2, 4, 'SALUD2', 16, NULL, 'S'),
  (8, 2, 5, 'SALUD3', 7, NULL, 'S'),
  (9, 3, 3, 'PISO0', 6, NULL, 'S'),
  (10, 3, 4, 'PISO1', 8, NULL, 'S'),
  (11, 3, 5, 'PISO2', 8, NULL, 'S'),
  (12, 3, 6, 'PISO3', 8, NULL, 'S');

INSERT INTO tipos_ambientes (id_tipo_ambiente, nombre,icono , estado) VALUES
  (1, 'NORMAL', 'normal.png','S'),
  (2, 'HOSPITAL','lab_fisica.png', 'S'),
  (3, 'LAB.COMPUTACION','lab_computacion.png', 'S'),
  (4, 'LAB.FISICA','hospital.png', 'S'),
  (5, 'ANFITEATRO','anfiteatro.png', 'S');

INSERT INTO ambientes (id_piso_bloque, id_tipo_ambiente, nombre, codigo, capacidad, imagen_exterior, imagen_interior, estado, metro_cuadrado) VALUES
  (1, 1, 'CPRIV-1', NULL, NULL, NULL, NULL, 'S', NULL),
  (1, 1, 'FISC/PRIV', NULL, NULL, NULL, NULL, 'S', NULL),
  (2, 1, 'ANF-1', NULL, NULL, NULL, NULL, 'S', NULL),
  (2, 1, 'ANF-2', NULL, NULL, NULL, NULL, 'S', NULL),
  (2, 1, 'ANF-3', NULL, NULL, NULL, NULL, 'S', NULL),
  (3, 1, 'SSU-1', NULL, NULL, NULL, NULL, 'S', NULL),
  (3, 1, 'SSU-2', NULL, NULL, NULL, NULL, 'S', NULL),
  (3, 1, 'SSU-3', NULL, NULL, NULL, NULL, 'S', NULL),
  ( 4, 1, 'CS-1/LAB', NULL, NULL, NULL, NULL, 'S', NULL),
  (4, 1, 'CS-2/LAB', NULL, NULL, NULL, NULL, 'S', NULL),
  (4, 1, 'CS-3/LAB', NULL, NULL, NULL, NULL, 'S', NULL),
  (4, 1, 'CS-4/LAB', NULL, NULL, NULL, NULL, 'S', NULL),
  (4, 1, 'CS-5/LAB', NULL, NULL, NULL, NULL, 'S', NULL),
  (4, 1, 'CS-6/LAB', NULL, NULL, NULL, NULL, 'S', NULL),
  (5, 1, 'CS-1/GAB', NULL, NULL, NULL, NULL, 'S', NULL),
  (5, 1, 'CS-2/GAB', NULL, NULL, NULL, NULL, 'S', NULL),
  (5, 1, 'CS-3/GAB', NULL, NULL, NULL, NULL, 'S', NULL),
  (5, 1, 'CS-4/GAB', NULL, NULL, NULL, NULL, 'S', NULL),
  (5, 1, 'CS-5/GAB', NULL, NULL, NULL, NULL, 'S', NULL),
  (5, 1, 'CS-6/GAB', NULL, NULL, NULL, NULL, 'S', NULL),
  (6, 1, 'CNS/SS-1', NULL, NULL, NULL, NULL, 'S', NULL),
  (6, 1, 'CNS/SS-2', NULL, NULL, NULL, NULL, 'S', NULL),
  (6, 1, 'CNS/SS-3', NULL, NULL, NULL, NULL, 'S', NULL),
  (6, 1, 'CNS/SS-4', NULL, NULL, NULL, NULL, 'S', NULL),
  (6, 1, 'CNS/SS-5', NULL, NULL, NULL, NULL, 'S', NULL),
  (6, 1, 'CNS/SS-6', NULL, NULL, NULL, NULL, 'S', NULL),
  (6, 1, 'CNS/SS-7', NULL, NULL, NULL, NULL, 'S', NULL),
  (6, 1, 'CNS/SS-8', NULL, NULL, NULL, NULL, 'S', NULL),
  (6, 1, 'CNS/SS-9', NULL, NULL, NULL, NULL, 'S', NULL),
  (6, 1, 'CNS/SS-10', NULL, NULL, NULL, NULL, 'S', NULL),
  (7, 1, 'HDB-1', NULL, NULL, NULL, NULL, 'S', NULL),
  (7, 1, 'HDB-2', NULL, NULL, NULL, NULL, 'S', NULL),
  (7, 1, 'HDB-3', NULL, NULL, NULL, NULL, 'S', NULL),
  (7, 1, 'HDB-4', NULL, NULL, NULL, NULL, 'S', NULL),
  (7, 1, 'HDB-5', NULL, NULL, NULL, NULL, 'S', NULL),
  (7, 1, 'HDB-6', NULL, NULL, NULL, NULL, 'S', NULL),
  (7, 1, 'HDB-7', NULL, NULL, NULL, NULL, 'S', NULL),
  (7, 1, 'HDB-8', NULL, NULL, NULL, NULL, 'S', NULL),
  (7, 1, 'HDB-9', NULL, NULL, NULL, NULL, 'S', NULL),
  (7, 1, 'HDB-10', NULL, NULL, NULL, NULL, 'S', NULL),
  (7, 1, 'HDB-11', NULL, NULL, NULL, NULL, 'S', NULL),
  (7, 1, 'HDB-12', NULL, NULL, NULL, NULL, 'S', NULL),
  (7, 1, 'HDB-13', NULL, NULL, NULL, NULL, 'S', NULL),
  (7, 1, 'HDB-14', NULL, NULL, NULL, NULL, 'S', NULL),
  (7, 1, 'HDB-15', NULL, NULL, NULL, NULL, 'S', NULL),
  (7, 1, 'HDB-16', NULL, NULL, NULL, NULL, 'S', NULL),
  (8, 1, 'HOSP/LAB-EMBRIO', NULL, NULL, NULL, NULL, 'S', NULL),
  (8, 1, 'HOSP/LAB-HISTO', NULL, NULL, NULL, NULL, 'S', NULL),
  (8, 1, 'HOSP/LAB-FISIO', NULL, NULL, NULL, NULL, 'S', NULL),
  (8, 1, 'HOSP/LAB-BIOQ', NULL, NULL, NULL, NULL, 'S', NULL),
  (8, 1, 'HOSP/LAB-PAR', NULL, NULL, NULL, NULL, 'S', NULL),
  (8, 1, 'HOSP/LAB-PATCLI', NULL, NULL, NULL, NULL, 'S', NULL),
  (8, 1, 'HOSP/LAB-BAC', NULL, NULL, NULL, NULL, 'S', NULL),
  (9, 1, 'PB-AMB01', NULL, NULL, NULL, NULL, 'S', NULL),
  (9, 1, 'PB-AMB02', NULL, NULL, NULL, NULL, 'S', NULL),
  (9, 1, 'PB-AMB03', NULL, NULL, NULL, NULL, 'S', NULL),
  (9, 1, 'PB-AMB04', NULL, NULL, NULL, NULL, 'S', NULL),
  (9, 1, 'PB-AMB05', NULL, NULL, NULL, NULL, 'S', NULL),
  (9, 1, 'PB-AMB06', NULL, NULL, NULL, NULL, 'S', NULL),
  (10, 1, 'P1-AMB01', NULL, NULL, NULL, NULL, 'S', NULL),
  (10, 1, 'P1-AMB02', NULL, NULL, NULL, NULL, 'S', NULL),
  (10, 1, 'P1-AMB03', NULL, NULL, NULL, NULL, 'S', NULL),
  (10, 1, 'P1-AMB04', NULL, NULL, NULL, NULL, 'S', NULL),
  (10, 1, 'P1-AMB05', NULL, NULL, NULL, NULL, 'S', NULL),
  (10, 1, 'P1-AMB06', NULL, NULL, NULL, NULL, 'S', NULL),
  (10, 1, 'P1-AMB07', NULL, NULL, NULL, NULL, 'S', NULL),
  (10, 1, 'P1-AMB08', NULL, NULL, NULL, NULL, 'S', NULL),
  (11, 1, 'P2-AMB01', NULL, NULL, NULL, NULL, 'S', NULL),
  (11, 1, 'P2-AMB02', NULL, NULL, NULL, NULL, 'S', NULL),
  (11, 1, 'P2-AMB03', NULL, NULL, NULL, NULL, 'S', NULL),
  (11, 1, 'P2-AMB04', NULL, NULL, NULL, NULL, 'S', NULL),
  (11, 1, 'P2-AMB05', NULL, NULL, NULL, NULL, 'S', NULL),
  (11, 1, 'P2-AMB06', NULL, NULL, NULL, NULL, 'S', NULL),
  (11, 1, 'P2-AMB07', NULL, NULL, NULL, NULL, 'S', NULL),
  (11, 1, 'P2-AMB08', NULL, NULL, NULL, NULL, 'S', NULL),
  (12, 1, 'P3-AMB01', NULL, NULL, NULL, NULL, 'S', NULL),
  (12, 1, 'P3-AMB02', NULL, NULL, NULL, NULL, 'S', NULL),
  (12, 1, 'P3-AMB03', NULL, NULL, NULL, NULL, 'S', NULL),
  (12, 1, 'P3-AMB04', NULL, NULL, NULL, NULL, 'S', NULL),
  (12, 1, 'P3-AMB05', NULL, NULL, NULL, NULL, 'S', NULL),
  (12, 1, 'P3-AMB06', NULL, NULL, NULL, NULL, 'S', NULL),
  (12, 1, 'P3-AMB07', NULL, NULL, NULL, NULL, 'S', NULL),
  (12, 1, 'P3-AMB08', NULL, NULL, NULL, NULL, 'S', NULL);



---------views-------------
create view edicio_campus as
select e.* , c.nombre as campus, c.poligono
from edificios e 
inner join campus c
on e.id_campu = c.id_campu;

create view piso_view as
select  p.id_piso,p.numero,p.nombre,p.estado, pb.nombre as piso_bloque, b.nombre as bloque
from pisos p 
inner join pisos_bloques pb 
on p.id_piso = pb.id_piso
inner join bloques b 
on b.id_bloque = pb.id_bloque;

create view edificio_piso as
select  e.id_edificio ,e.nombre, 
p.id_piso, p.nombre as piso,p.numero as numero_piso, p.estado as piso_estado,
b.nombre as bloque ,pb.nombre as piso_bloque
from edificios e
inner join bloques b 
on e.id_edificio = b.id_edificio
inner join pisos_bloques pb 
on  pb.id_bloque = b.id_bloque
inner join pisos p  
on  p.id_piso = pb.id_piso;

 create view ambiente_piso_bloque as
 select a.id_ambiente,a.nombre, e.id_edificio, e.nombre as edificio ,p.numero as numero_piso ,pb.nombre as piso_bloque, ta.icono as icono, 
 ta.nombre as tipo_ambiente,
 a.codigo, a.capacidad, a.metro_cuadrado, a.imagen_exterior, a.imagen_interior, a.estado
 from ambientes a 
 inner join pisos_bloques pb 
 on a.id_piso_bloque = pb.id_piso_bloque
 inner join bloques b  
 on b.id_bloque = pb.id_bloque
 inner join edificios e 
 on e.id_edificio = b.id_edificio
 inner join pisos p  
 on p.id_piso = pb.id_piso
 inner join tipos_ambientes ta
 on ta.id_tipo_ambiente = a.id_tipo_ambiente;

select * from piso_view;

select * from edicio_campus;
drop view edicio_campus;

select * from edificio_piso;
drop view edificio_piso;

select * from ambiente_piso_bloque;
drop view ambiente_piso_bloque;

select * from tipos_ambientes;
select * from edificios e ;

select * from bloques b ;
select * from pisos p ;
select * from pisos_bloques;
select * from tipos_ambientes;
select * from ambientes;
select * from campus c;
select * from edificios ;