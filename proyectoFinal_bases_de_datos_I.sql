CREATE TABLE Hospital(
	idHospital int not null,
    nombreH varchar(30),
    direccH varchar(30),
    telH varchar(30),
    presupH float,
    PRIMARY KEY(idHospital)
);

CREATE TABLE Departamento(
	id_Dep int not null,
    nombreDep varchar(30),
    presup_dep float,
    tipo_dep varchar(30),
    id_hospital int not null,
    PRIMARY KEY(id_Dep),
    FOREIGN KEY (id_hospital) REFERENCES hospital(idHospital)
);

CREATE TABLE Paciente(
	ced_pac int not null,
    nombre_pac varchar(30),
    fecha_nac varchar(30),
    email_pac varchar(30),
    tipo_pac varchar(15),
    celular_pac varchar(15),
    PRIMARY KEY(ced_pac)
);

--ALTER TABLE Paciente
--MODIFY COLUMN fecha_nac DATE;

CREATE TABLE Medico(
	ced_med int not null,
    nombre_med varchar(30),
    email_med varchar(30),
    cel_med varchar(15),
    fec_contra varchar(15),
    salario_base float,
    id_Dep int not null,
    PRIMARY KEY(ced_med),
    FOREIGN KEY (id_Dep) REFERENCES departamento(id_Dep)
);

--ALTER TABLE Medico
--MODIFY COLUMN fec_contra DATE;

CREATE TABLE Cirujano(
	ced_med int not null,
    especialidad_quirur varchar(30),
    cant_ciru_mes int,
    bono_quirur varchar(30),
    PRIMARY KEY(ced_med),
    FOREIGN KEY (ced_med) REFERENCES medico(ced_med)
);

CREATE TABLE Pediatra(
	ced_med int not null,
    cant_pacientes_men int,
    num_vac_apli int,
    PRIMARY KEY(ced_med),
    FOREIGN KEY (ced_med) REFERENCES medico(ced_med)
);

CREATE TABLE Cama(
	id_cama int not null,
    num_cama int not null,
    tipo_cama varchar(30),
    estado_cama varchar(20),
    id_Dep int not null,
    PRIMARY KEY(id_cama),
    UNIQUE(num_cama, id_Dep),
    CHECK (estado_cama IN ("DISPONIBLE", "OCUPADA", "MANTENIMIENTO")),
    FOREIGN KEY (id_Dep) REFERENCES departamento(id_Dep)
);

CREATE TABLE Consulta(
	id_consulta int not null,
    diagnostico TEXT not null,
    result varchar(30),
    fecha_soli DATE,
	fecha_consul DATE,
    duracion_min int,
    ced_pac int not null,
    ced_med int not null,
    PRIMARY KEY(id_consulta),
	CHECK (result IN ('ALTA', 'REFERIDO', 'HOSPITALIZACION', 'SEGUIMIENTO')),
    FOREIGN KEY (ced_pac) REFERENCES paciente(ced_pac),
	FOREIGN KEY (ced_med) REFERENCES medico(ced_med)
);

CREATE TABLE Hospitalizacion(
    id_hospitalizacion INT NOT NULL,
    fecha_ingreso DATE NOT NULL,
    fecha_alta DATE,
    diagnost_ingreso VARCHAR(200) NOT NULL,
    diagnost_egreso VARCHAR(200),
    id_cama INT NOT NULL,
    ced_med INT NOT NULL,
    ced_pac INT NOT NULL,
    PRIMARY KEY(id_hospitalizacion),
    CHECK (fecha_alta IS NULL OR fecha_alta >= fecha_ingreso),
    FOREIGN KEY (id_cama) REFERENCES Cama(id_cama),
    FOREIGN KEY (ced_med) REFERENCES Medico(ced_med),
    FOREIGN KEY (ced_pac) REFERENCES Paciente(ced_pac)
);

CREATE TABLE Medicamento(
    medicamento_id INT NOT NULL,
    nombre_medica VARCHAR(60) NOT NULL,
    costo_unitario float NOT NULL,
    stock_total INT NOT NULL 
    CHECK (stock_total >= 0),
    PRIMARY KEY(medicamento_id)
);

CREATE TABLE Tipo_Procedimiento(
    tipo_proced_id INT NOT NULL,
    tipo_proced_nom VARCHAR(60) NOT NULL,
    costo_estandar float NOT NULL,
    CHECK (costo_estandar >= 0),
    duracion_min INT NOT NULL
    CHECK (duracion_min > 0),
    descri VARCHAR(200),
    PRIMARY KEY(tipo_proced_id)
);

CREATE TABLE Procedimiento(
    proced_id INT NOT NULL,
    tipo_proced_id INT NOT NULL,
    fecha_proced DATE NOT NULL,
    duracion_min INT NOT NULL
    CHECK (duracion_min > 0),
    complicaciones VARCHAR(200),
    Ced_Pac INT NOT NULL,
    Ced_Med INT NOT NULL,
    PRIMARY KEY(proced_id),
    FOREIGN KEY (tipo_proced_id) REFERENCES Tipo_Procedimiento(tipo_proced_id),
    FOREIGN KEY (Ced_Pac) REFERENCES Paciente(ced_pac),
    FOREIGN KEY (Ced_Med) REFERENCES Medico(ced_med)
);


CREATE TABLE Origen(
    id_Origen INT NOT NULL,
    id_Consulta INT NULL,
    Proced_Id INT NULL,
    Id_Hospitalizacion INT NULL,
    PRIMARY KEY(id_Origen),
    
    CHECK (
        (CASE WHEN id_Consulta IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN Proced_Id IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN Id_Hospitalizacion IS NOT NULL THEN 1 ELSE 0 END) = 1
    ),

    FOREIGN KEY (id_Consulta) REFERENCES Consulta(id_consulta),
    FOREIGN KEY (Proced_Id) REFERENCES Procedimiento(proced_id),
    FOREIGN KEY (Id_Hospitalizacion) REFERENCES Hospitalizacion(id_hospitalizacion)
);

CREATE TABLE Orden_Medicamento(
    orden_id INT NOT NULL,
    cant INT NOT NULL,
    CHECK (cant > 0),
    fecha_orden DATE NOT NULL,
    medicamento_id INT NOT NULL,
    id_Origen INT NOT NULL,
    PRIMARY KEY(orden_id),
    FOREIGN KEY (medicamento_id) REFERENCES Medicamento(medicamento_id),
    FOREIGN KEY (id_Origen) REFERENCES Origen(id_Origen)
);

CREATE TABLE Factura(
    factura_id INT NOT NULL,
    fecha_fac DATE NOT NULL,
    montoTotal float NOT NULL,
    CHECK (montoTotal >= 0),
    estado VARCHAR(20),
    CHECK (estado IN ('PENDIENTE', 'PAGADA')),
    id_Origen INT NOT NULL,
    PRIMARY KEY(factura_id),
    FOREIGN KEY (id_Origen) REFERENCES Origen(id_Origen)
);









