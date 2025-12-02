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

ALTER TABLE Paciente
ADD CONSTRAINT chk_tipo_pac
CHECK (tipo_pac IN ('UCI', 'AMBULATORIO','HOSPITALIZADO','URGENCIA','CRONICO'));

ALTER TABLE Paciente 
DROP CONSTRAINT chk_tipo_pac;

ALTER TABLE Paciente
ADD CONSTRAINT chk_tipo_pac
CHECK (tipo_pac IN ('AMBULATORIO','HOSPITALIZADO','URGENCIA','CRONICO'));

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


INSERT INTO Hospital VALUES
(1, 'SES', 'Cra 10 #20-30', '3001112222', 950000000),
(2, 'Santa Sofía', 'Av 4 #15-22', '3002223333', 680000000),
(3, 'Avidanti', 'Calle 50 #10-12', '3004445555', 720000000);


INSERT INTO Departamento (id_Dep, nombreDep, presup_dep, tipo_dep, id_hospital) VALUES
-- Hospital 1
(101, 'Urgencias',        120000000, 'Asistencial', 1),
(102, 'Pediatría',        90000000,  'Asistencial', 1),
(103, 'Cirugía',          150000000, 'Asistencial', 1),
(104, 'Hospitalización',  100000000, 'Asistencial', 1),

-- Hospital 2
(201, 'Urgencias',        110000000, 'Asistencial', 2),
(202, 'Pediatría',        85000000,  'Asistencial', 2),
(203, 'Cirugía',          140000000, 'Asistencial', 2),
(204, 'Hospitalización',  95000000,  'Asistencial', 2),

-- Hospital 3
(301, 'Urgencias',        100000000, 'Asistencial', 3),
(302, 'Pediatría',        78000000,  'Asistencial', 3),
(303, 'Cirugía',          130000000, 'Asistencial', 3),
(304, 'Hospitalización',  90000000,  'Asistencial', 3);

INSERT INTO Paciente VALUES
(1, 'Juan Pérez',       '1990-05-12', 'juanp@gmail.com',    'AMBULATORIO',  '3101234567'),
(2, 'María López',      '1985-09-21', 'marial@gmail.com',   'AMBULATORIO',  '3109876543'),
(3, 'Carlos Ríos',      '2002-03-15', 'carlosr@gmail.com',  'URGENCIA',     '3125558888'),
(4, 'Ana Torres',       '1999-11-30', 'anat@gmail.com',     'AMBULATORIO',  '3112223344'),
(5, 'Pedro Gómez',      '1975-01-10', 'pedrog@gmail.com',   'CRONICO',      '3106667777'),
(6, 'Sofía Herrera',    '2010-08-05', 'sofia@gmail.com',    'HOSPITALIZADO','3142233445'),
(7, 'Luis Vargas',      '1994-04-18', 'luisv@gmail.com',    'AMBULATORIO',  '3188899001'),
(8, 'Valeria Castaño',  '2005-07-27', 'valec@gmail.com',    'URGENCIA',     '3151112233'),
(9, 'Miguel Soto',      '1980-12-22', 'miguels@gmail.com',  'CRONICO',      '3118899776'),
(10,'Laura Ruiz',       '1997-02-14', 'laurar@gmail.com',   'HOSPITALIZADO','3175522991');

INSERT INTO Medico VALUES
(1001, 'Dra. Laura Arango ',   'laurasarango@ses.com', '3101112233', '2020-05-10', 4500000, 103), 
(1002, 'Dra. Paula Rivera',   'paulaRivera@ses.com', '3112223344', '2019-03-21', 4200000, 101), 
(1003, 'Dr. Esteban Torres',  'etorres@ses.com', '3123334455', '2018-09-15', 4800000, 103), 
(1004, 'Dra. Diana Suárez',   'dsuarez@ses.com', '3134445566', '2021-11-05', 4700000, 104),

(1005, 'Dr. Mauricio Valencia', 'maheva@ssof.com',    '3156667788', '2017-06-14', 5200000, 201),
(1006, 'Dra. Beatriz Cortes',   'betty@ssof.com',     '3145556677', '2022-01-18', 4800000, 202),
(1007, 'Dr. Mateo Roldán',    'mroldan@ssof.com',     '3178889900', '2016-08-12', 5500000, 203),
(1008, 'Dra. Karen Muñoz',    'kmunoz@ssof.com',      '3167778899', '2017-02-25', 5000000, 204),

(1009, 'Dr. Samuel Prieto',   'sprieto@avid.com',     '3108899221', '2018-12-05', 4600000, 301),
(1010, 'Dra. Laura Castaño',  'lcastano@avid.com',    '3187788990', '2015-03-12', 5300000, 302),
(1011, 'Dr. Julián Correa',   'jcorrea@avid.com',     '3135566778', '2019-10-20', 4900000, 303),
(1012, 'Dra. Paula Salazar',  'psalazar@avid.com',    '3176677889', '2020-07-09', 4750000, 304);

UPDATE Medico
set id_Dep = 102
where ced_med = 1003;

INSERT INTO Cirujano VALUES
(1005, 'Cardiovascular', 12, '1500000'),
(1001, 'Neurocirugía', 8,  '1200000'),
(1006, 'Ortopedia', 15, '1800000');

INSERT INTO Pediatra VALUES
(1002, 120, 350),
(1008, 150, 380),
(1010, 140, 400);

INSERT INTO Cama VALUES
(1, 101, 'General',     'DISPONIBLE', 104),
(2, 102, 'General',     'DISPONIBLE', 104),
(3, 201, 'Pediatrica',  'DISPONIBLE', 102),
(4, 202, 'Pediatrica',  'DISPONIBLE', 102),
(5, 301, 'Cirugia',     'DISPONIBLE', 103),
(6, 302, 'Cirugia',     'DISPONIBLE', 103),
(7, 401, 'UCI',         'DISPONIBLE', 101),
(8, 402, 'UCI',         'DISPONIBLE', 201),
(9, 403, 'UCI',         'DISPONIBLE', 301),
(10, 501, 'General',    'DISPONIBLE', 204),
(11, 502, 'General',    'DISPONIBLE', 204),
(12, 601, 'General',    'DISPONIBLE', 304);

INSERT INTO Consulta VALUES
(1, 'Dolor abdominal',       'ALTA',             '2024-01-02','2024-01-03', 20, 1, 1001),
(2, 'Fiebre alta',           'SEGUIMIENTO',      '2024-01-05','2024-01-06', 30, 2, 1002),
(3, 'Trauma leve',           'REFERIDO',         '2024-01-10','2024-01-10', 25, 3, 1007),
(4, 'Gripe fuerte',          'ALTA',             '2024-01-14','2024-01-14', 15, 4, 1006),
(5, 'Control crónico',       'SEGUIMIENTO',      '2024-01-20','2024-01-20', 35, 5, 1010),
(6, 'Dolor torácico',        'HOSPITALIZACION',  '2024-01-22','2024-01-22', 40, 6, 1003),
(7, 'Migraña',               'ALTA',             '2024-01-25','2024-01-25', 18, 7, 1011),
(8, 'Caída',                 'SEGUIMIENTO',      '2024-01-29','2024-01-29', 22, 8, 1009),
(9, 'Chequeo general',       'ALTA',             '2024-02-01','2024-02-01', 12, 9, 1005),
(10,'Dificultad respiratoria','HOSPITALIZACION', '2024-02-05','2024-02-05', 45, 10, 1002);

INSERT INTO Hospitalizacion VALUES
(1,'2024-01-22',NULL,'Dolor torácico','En observación',7,1003,6),
(2,'2024-02-05',NULL,'Dificultad respiratoria','En ventilación',8,1002,10),
(3,'2024-01-15','2024-01-20','Neumonía','Recuperado',1,1001,3),
(4,'2024-01-18','2024-01-23','Fractura brazo','Alta',5,1007,8),
(5,'2024-01-28','2024-02-03','Infección renal','Estable',10,1006,5),
(6,'2024-02-04',NULL,'Sepsis','Crítico',9,1003,9),
(7,'2024-02-06','2024-02-10','Apendicitis','Alta',6,1003,7),
(8,'2024-02-09','2024-02-14','Cesárea','Alta',12,1002,2),
(9,'2024-02-11','2024-02-13','Bronquiolitis','Alta',3,1010,4),
(10,'2024-02-14',NULL,'COVID grave','Aislamiento',8,1007,1);

INSERT INTO Medicamento VALUES
(1,'Paracetamol 500mg', 1200, 500),
(2,'Ibuprofeno 400mg', 1500, 400),
(3,'Amoxicilina 500mg', 2500, 350),
(4,'Omeprazol 20mg', 1800, 600),
(5,'Dexametasona', 2000, 300),
(6,'Salbutamol', 5200, 200),
(7,'Metformina 850mg', 900, 450),
(8,'Losartán 50mg', 1400, 420),
(9,'Clorfenamina', 800, 550),
(10,'Acetaminofén pediátrico', 1000, 380);

INSERT INTO Tipo_Procedimiento VALUES
(1,'Radiografía de tórax', 35000, 20,'Imagen diagnóstica'),
(2,'Ecografía abdominal', 50000, 30,'Ultrasonido'),
(3,'Cirugía menor', 150000, 60,'Intervención ambulatoria'),
(4,'Cirugía mayor', 850000, 120,'Intervención compleja'),
(5,'Curación', 20000, 10,'Atención básica'),
(6,'Sutura', 45000, 25,'Heridas'),
(7,'Endoscopia', 300000, 40,'Procedimiento interno'),
(8,'TAC craneal', 450000, 35,'Imagen avanzada'),
(9,'Resonancia magnética', 900000, 45,'Imagen avanzada'),
(10,'Electrocardiograma', 25000, 15,'Corazón');

INSERT INTO Procedimiento VALUES
(1,1,'2024-01-03',20,'Sin complicaciones',1,1001),
(2,2,'2024-01-06',30,'Sin hallazgos',2,1002),
(3,3,'2024-01-10',50,'Controlado',3,1007),
(4,5,'2024-01-14',10,'OK',4,1006),
(5,6,'2024-01-20',25,'Limpieza exitosa',5,1010),
(6,8,'2024-01-22',40,'Normal',6,1005),
(7,7,'2024-01-25',45,'Leve irritación',7,1011),
(8,1,'2024-01-29',20,'Normal',8,1009),
(9,10,'2024-02-01',15,'Normal',9,1005),
(10,3,'2024-02-05',55,'Sin incidencias',10,1002);

INSERT INTO Origen VALUES
(1, 1, NULL, NULL),
(2, 2, NULL, NULL),
(3, 3, NULL, NULL),
(4, 4, NULL, NULL),
(5, 5, NULL, NULL),
(6, 6, NULL, NULL),
(7, 7, NULL, NULL),
(8, 8, NULL, NULL),
(9, 9, NULL, NULL),
(10, 10, NULL, NULL),
(11, NULL, 1, NULL),
(12, NULL, 2, NULL),
(13, NULL, 3, NULL),
(14, NULL, 4, NULL),
(15, NULL, 5, NULL),
(16, NULL, 6, NULL),
(17, NULL, 7, NULL),
(18, NULL, 8, NULL),
(19, NULL, 9, NULL),
(20, NULL, 10, NULL),
(21, NULL, NULL, 1),
(22, NULL, NULL, 2),
(23, NULL, NULL, 3),
(24, NULL, NULL, 4),
(25, NULL, NULL, 5),
(26, NULL, NULL, 6),
(27, NULL, NULL, 7),
(28, NULL, NULL, 8),
(29, NULL, NULL, 9),
(30, NULL, NULL, 10);

INSERT INTO Orden_Medicamento VALUES
(1,2,'2024-01-03',1,1),
(2,1,'2024-01-06',2,2),
(3,3,'2024-01-10',3,3),
(4,1,'2024-01-14',4,4),
(5,2,'2024-01-20',5,5),
(6,1,'2024-01-22',6,6),
(7,2,'2024-01-25',7,7),
(8,1,'2024-01-29',8,8),
(9,3,'2024-02-01',9,9),
(10,1,'2024-02-05',10,10);

INSERT INTO Factura VALUES
(1,'2024-01-03',35000,'PAGADA',1),
(2,'2024-01-06',50000,'PAGADA',2),
(3,'2024-01-10',150000,'PENDIENTE',3),
(4,'2024-01-14',20000,'PAGADA',4),
(5,'2024-01-20',45000,'PAGADA',5),
(6,'2024-01-22',300000,'PENDIENTE',6),
(7,'2024-01-25',25000,'PAGADA',7),
(8,'2024-01-29',35000,'PENDIENTE',8),
(9,'2024-02-01',25000,'PAGADA',9),
(10,'2024-02-05',850000,'PENDIENTE',10);

DELIMITER $$
CREATE TRIGGER trg_no_hosp_activa
BEFORE INSERT ON Hospitalizacion
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM Hospitalizacion
        WHERE ced_pac = NEW.ced_pac
          AND fecha_alta IS NULL
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El paciente ya tiene una hospitalización activa.';
    END IF;
END$$

DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_no_consulta_solapada
BEFORE INSERT ON Consulta
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM Consulta
        WHERE ced_med = NEW.ced_med
          AND fecha_consul = NEW.fecha_consul
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El médico ya tiene una consulta en esa fecha.';
    END IF;
END$$

DELIMITER ;

CREATE VIEW consulta_1 AS
SELECT 
    DATE_FORMAT(fecha_ingreso, '%Y-%m') AS mes,
    COUNT(DISTINCT id_cama) AS camas_ocupadas,
    (COUNT(DISTINCT id_cama) / 12) * 100 AS tasa_ocupacion
FROM hospitalizacion
GROUP BY mes;








