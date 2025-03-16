--Facultad de Informática Culiacán
--Base de Datos Facturaciones de ventas
--Instructor: Gerardo Gálvez Gámez
--Lenguaje de Consulta de Datos 
--Lic. en Ing. en Ciencias de Datos FIC-UAS 2025

--script tabla estados
CREATE TABLE estados (
    id_estado CHARACTER(2) PRIMARY KEY,  
    nombre CHARACTER VARYING (30) NOT NULL
);
--script tabla municipios
CREATE TABLE municipios (
    id_estado CHARACTER(2) NOT NULL,
	id_municipio CHARACTER(3) NOT NULL,  
    nombre CHARACTER VARYING(100) NOT NULL,
    PRIMARY KEY (id_estado, id_municipio),
    FOREIGN KEY (id_estado) REFERENCES estados(id_estado) 
	ON UPDATE CASCADE
	ON DELETE CASCADE
);
--script tabla localidades
CREATE TABLE localidades (
    id_estado CHARACTER(2) NOT NULL,
	id_municipio CHARACTER(3) NOT NULL,
	id_localidad CHARACTER(4) NOT NULL,  
    nombre CHARACTER VARYING(100) NOT NULL,
	codigo_postal CHARACTER(5) NOT NULL,
    PRIMARY KEY (id_estado,id_municipio,id_localidad),
    FOREIGN KEY (id_estado,id_municipio) 
	REFERENCES municipios(id_estado, id_municipio)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

--script clientes
CREATE TABLE clientes(
	rfc_cliente CHARACTER(13) PRIMARY KEY,
	nombre CHARACTER VARYING(30) NOT NULL,
	apellido_paterno CHARACTER VARYING(20) NOT NULL,
	apellido_materno CHARACTER VARYING(20),
	calle_numero CHARACTER VARYING(20) NOT NULL,
	id_estado CHARACTER(2) NOT NULL,
	id_municipio CHARACTER(3) NOT NULL,
	id_localidad CHARACTER(4) NOT NULL,
    FOREIGN KEY (id_localidad, id_municipio, id_estado) 
	REFERENCES localidades(id_localidad, id_municipio, id_estado)
	ON UPDATE CASCADE
	ON DELETE RESTRICT
);
--Script para la tabla articulos
CREATE TABLE articulos(
	codigo CHARACTER(13) PRIMARY KEY NOT NULL,
	nombre CHARACTER VARYING(50) NOT NULL,
	precio DECIMAL(10,2) NOT NULL DEFAULT '0.0'
);

--Script para la tabla facturas
CREATE TABLE facturas(
	rfc_cliente CHARACTER(13) NOT NULL,
	folio SERIAL PRIMARY KEY NOT NULL,
	fecha TIMESTAMP NOT NULL,
	FOREIGN KEY(rfc_cliente) REFERENCES clientes(rfc_cliente)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

--Script para la tabla detalles de facturas
CREATE TABLE detalles_facturas(
	folio_factura INTEGER NOT NULL,
	codigo_articulo CHARACTER(13) NOT NULL,
	cantidad INTEGER NOT NULL CHECK (cantidad > 0),
	precio_venta DECIMAL(10,2) NOT NULL,
	PRIMARY KEY(folio_factura,codigo_articulo),
	FOREIGN KEY(folio_factura) REFERENCES facturas(folio)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	FOREIGN KEY(codigo_articulo) REFERENCES articulos(codigo)
	ON UPDATE CASCADE
	ON DELETE RESTRICT
);
--script insert estados
INSERT INTO estados (id_estado, nombre) VALUES 
('01', 'Aguascalientes'),
('02', 'Baja California'),
('03', 'Baja California Sur'),
('04', 'Campeche'),
('05', 'Coahuila'),
('06', 'Colima'),
('07', 'Chiapas'),
('08', 'Chihuahua'),
('09', 'Ciudad de México'),
('10', 'Durango'),
('11', 'Guanajuato'),
('12', 'Guerrero'),
('13', 'Hidalgo'),
('14', 'Jalisco'),
('15', 'México'),
('16', 'Michoacán'),
('17', 'Morelos'),
('18', 'Nayarit'),
('19', 'Nuevo León'),
('20', 'Oaxaca'),
('21', 'Puebla'),
('22', 'Querétaro'),
('23', 'Quintana Roo'),
('24', 'San Luis Potosí'),
('25', 'Sinaloa'),
('26', 'Sonora'),
('27', 'Tabasco'),
('28', 'Tamaulipas'),
('29', 'Tlaxcala'),
('30', 'Veracruz'),
('31', 'Yucatán'),
('32', 'Zacatecas');

--script insert municipios
-- SINALOA
INSERT INTO municipios (id_estado, id_municipio, nombre) VALUES 
 ('25', '001', 'AHOME'),
 ('25', '002', 'ANGOSTURA'),
 ('25', '003', 'BADIRAGUATO'),
 ('25', '004', 'CONCORDIA'),
 ('25', '005', 'COSALA'),
 ('25', '006', 'CULIACAN'),
 ('25', '007', 'CHOIX'),
 ('25', '008', 'ELOTA'),
 ('25', '009', 'ESCUINAPA'),
 ('25', '010', 'EL FUERTE'),
 ('25', '011', 'GUASAVE'),
 ('25', '012', 'MAZATLAN'),
 ('25', '013', 'MOCORITO'),
 ('25', '014', 'ROSARIO'),
 ('25', '015', 'SALVADOR ALVARADO'),
 ('25', '016', 'SAN IGNACIO'),
 ('25', '017', 'SINALOA'),
 ('25', '018', 'NAVOLATO'),
 ('25', '019', 'ELDORADO'),
 ('25', '020', 'JUAN JOSE RIOS');

--SONORA
INSERT INTO municipios (id_estado, id_municipio, nombre) VALUES
('26', '001', 'Aconchi'),
('26', '002', 'Agua Prieta'),
('26', '003', 'Álamos'),
('26', '004', 'Altar'),
('26', '005', 'Arivechi'),
('26', '006', 'Arizpe'),
('26', '007', 'Atil'),
('26', '008', 'Bacadéhuachi'),
('26', '009', 'Bacanora'),
('26', '010', 'Bacerac'),
('26', '011', 'Bacoachi'),
('26', '012', 'Bácum'),
('26', '013', 'Banámichi'),
('26', '014', 'Baviácora'),
('26', '015', 'Bavispe'),
('26', '016', 'Benjamín Hill'),
('26', '017', 'Caborca'),
('26', '018', 'Cajeme'),
('26', '019', 'Cananea'),
('26', '020', 'Carbó'),
('26', '021', 'La Colorada'),
('26', '022', 'Cucurpe'),
('26', '023', 'Cumpas'),
('26', '024', 'Divisaderos'),
('26', '025', 'Empalme'),
('26', '026', 'Etchojoa'),
('26', '027', 'Fronteras'),
('26', '028', 'Granados'),
('26', '029', 'Guaymas'),
('26', '030', 'Hermosillo'),
('26', '031', 'Huachinera'),
('26', '032', 'Huásabas'),
('26', '033', 'Huatabampo'),
('26', '034', 'Huépac'),
('26', '035', 'Imuris'),
('26', '036', 'Magdalena'),
('26', '037', 'Mazatán'),
('26', '038', 'Moctezuma'),
('26', '039', 'Naco'),
('26', '040', 'Nácori Chico'),
('26', '041', 'Nacozari de García'),
('26', '042', 'Navojoa'),
('26', '043', 'Nogales'),
('26', '044', 'Onavas'),
('26', '045', 'Opodepe'),
('26', '046', 'Oquitoa'),
('26', '047', 'Pitiquito'),
('26', '048', 'Puerto Peñasco'),
('26', '049', 'Quiriego'),
('26', '050', 'Rayón'),
('26', '051', 'Rosario'),
('26', '052', 'Sahuaripa'),
('26', '053', 'San Felipe de Jesús'),
('26', '054', 'San Javier'),
('26', '055', 'San Luis Río Colorado'),
('26', '056', 'San Miguel de Horcasitas'),
('26', '057', 'San Pedro de la Cueva'),
('26', '058', 'Santa Ana'),
('26', '059', 'Santa Cruz'),
('26', '060', 'Sáric'),
('26', '061', 'Soyopa'),
('26', '062', 'Suaqui Grande'),
('26', '063', 'Tepache'),
('26', '064', 'Trincheras'),
('26', '065', 'Tubutama'),
('26', '066', 'Ures'),
('26', '067', 'Villa Hidalgo'),
('26', '068', 'Villa Pesqueira'),
('26', '069', 'Yécora'),
('26', '070', 'General Plutarco Elías Calles'),
('26', '071', 'Benito Juárez'),
('26', '072', 'San Ignacio Río Muerto');

--script INSERT de Localidades
-- culiacan 
INSERT INTO localidades (id_estado, id_municipio, id_localidad, nombre, codigo_postal) VALUES
('25', '006', '0001', 'CULIACAN DE ROSALES', '80000'),
('25', '006', '0002', 'VILLA ADOLFO LOPEZ MATEOS', '80300'),
('25', '006', '0003', 'AGUACALIENTE DE LOS MONZON', '80430'),
('25', '006', '0004', 'AGUARUTO', '80380'),
('25', '006', '0005', 'BELLAVISTA', '80190'),
('25', '006', '0006', 'COSTA RICA', '80400'),
('25', '006', '0007', 'CULIACANCITO', '80700'),
('25', '006', '0008', 'EL DIEZ', '80150'),
('25', '006', '0010', 'ESTACION ROSALES', '80390'),
('25', '006', '0011', 'LA HIGUERITA', '80370'),
('25', '006', '0012', 'JESUS MARIA', '80460'),
('25', '006', '0013', 'EL LIMONCITO', '80450'),
('25', '006', '0014', 'LIMON DE LOS RAMOS', '80360'),
('25', '006', '0016', 'PUEBLOS UNIDOS', '80340'),
('25', '006', '0017', 'QUILA', '80470'),
('25', '006', '0018', 'TEPUCHE', '80200'),
('25', '006', '0019', 'ABELARDO', '80320'),
('25', '006', '0020', 'ABUYA Y CEUTA II', '80510'),
('25', '006', '0021', 'BACHIMETO', '80520'),
('25', '006', '0022', 'EL SALADO', '80230'),
('25', '006', '0023', 'SAN LORENZO', '80530'),
('25', '006', '0024', 'TAMAZULA', '80480'),
('25', '006', '0025', 'IMALA', '80260'),
('25', '006', '0026', 'SANALONA', '80350'),
('25', '006', '0027', 'EL DORADO', '80380'),
('25', '006', '0028', 'EL POZO', '80180'),
('25', '006', '0029', 'EL RANCHITO', '80420'),
('25', '006', '0030', 'LAS TAPIAS', '80440'),
('25', '006', '0031', 'JULIAN', '80240'),
('25', '006', '0032', 'BACURIMI', '80290'),
('25', '006', '0033', 'LA CAMPANA', '80330'),
('25', '006', '0034', 'SAN RAFAEL', '80540'),
('25', '006', '0035', 'TACHICHILPA', '80220'),
('25', '006', '0036', 'LA PALMA', '80410'),
('25', '006', '0037', 'SAN MIGUEL', '80310'),
('25', '006', '0038', 'EL VENADILLO', '80170');

--Guasave
INSERT INTO localidades (id_estado, id_municipio, id_localidad, nombre, codigo_postal) VALUES
('25', '011', '0001', 'Guasave', '81000'),
('25', '011', '0002', 'Gabriel Leyva Solano', '81110'),
('25', '011', '0003', 'Estación Bamoa', '81120'),
('25', '011', '0004', 'San Rafael', '81130'),
('25', '011', '0005', 'Bamoa', '81140'),
('25', '011', '0006', 'El Burrión', '81150'),
('25', '011', '0007', 'Juan José Ríos', '81160'),
('25', '011', '0008', 'Adolfo Ruiz Cortines', '81170'),
('25', '011', '0009', 'Nío', '81180'),
('25', '011', '0010', 'El Tajito', '81190'),
('25', '011', '0011', 'Caimanero', '81200'),
('25', '011', '0012', 'San Blas', '81210'),
('25', '011', '0013', 'El Varal', '81220'),
('25', '011', '0014', 'Leyva Solano', '81230'),
('25', '011', '0015', 'Tamazula', '81240'),
('25', '011', '0016', 'Las Glorias', '81250'),
('25', '011', '0017', 'El Cubilete', '81260'),
('25', '011', '0018', 'La Trinidad', '81270'),
('25', '011', '0019', 'Orba', '81280'),
('25', '011', '0020', 'Las Parritas', '81290');

--Mazatlan
INSERT INTO localidades (id_estado, id_municipio, id_localidad, nombre, codigo_postal) VALUES
('25', '012', '0001', 'MAZATLAN', '82000'),
('25', '012', '0002', 'EL BAJIO', '82100'),
('25', '012', '0003', 'BARRON', '82110'),
('25', '012', '0004', 'EL CASTILLO', '82120'),
('25', '012', '0005', 'ESCAMILLAS', '82130'),
('25', '012', '0006', 'MARMOL', '82140'),
('25', '012', '0007', 'LA NORIA', '82150'),
('25', '012', '0008', 'EL QUELITE', '82160'),
('25', '012', '0009', 'EL ROBLE', '82170'),
('25', '012', '0010', 'SIQUEROS', '82180'),
('25', '012', '0011', 'VILLA UNION', '82190'),
('25', '012', '0012', 'EL WALAMO', '82200'),
('25', '012', '0013', 'EL AGARRE', '82210'),
('25', '012', '0015', 'AGUAJE DE COSTILLA', '82220'),
('25', '012', '0016', 'AGUAJE DEL PERRO', '82230'),
('25', '012', '0017', 'EL AGUAJE', '82240'),
('25', '012', '0018', 'EL AGUAJE', '82250'),
('25', '012', '0020', 'EL ALAZAN DE LA ESTANZUELA', '82260'),
('25', '012', '0022', 'LA AMAPA', '82270'),
('25', '012', '0023', 'EL AMAPAL', '82280'),
('25', '012', '0024', 'LAS AMAPAS', '82290'),
('25', '012', '0025', 'EL AMOLE', '82300'),
('25', '012', '0026', 'EL AMOLITO', '82310'),
('25', '012', '0027', 'ANDRES IBARRA', '82320'),
('25', '012', '0028', 'LOS ANGELES', '82330'),
('25', '012', '0030', 'LA ANGOSTURA', '82340'),
('25', '012', '0032', 'LOS AÑILES', '82350'),
('25', '012', '0033', 'EL ARENAL', '82360'),
('25', '012', '0034', 'EL ARENAL', '82370'),
('25', '012', '0035', 'EL ARENAL', '82380'),
('25', '012', '0036', 'EL ARENOSO', '82390'),
('25', '012', '0037', 'EL ARMADILLO', '82400'),
('25', '012', '0038', 'ARRAYANAL', '82410'),
('25', '012', '0039', 'LOS ARRAYANES', '82420'),
('25', '012', '0040', 'EL ARROYITO', '82430'),
('25', '012', '0041', 'ARROYO VERDE', '82440'),
('25', '012', '0042', 'EL ARROYO VERDE', '82450'),
('25', '012', '0043', 'EL ARTESIANO', '82460'),
('25', '012', '0044', 'EL ATASCADERO', '82470'),
('25', '012', '0045', 'EL AUSTRACAL', '82480'),
('25', '012', '0046', 'EL AYALITO 1', '82490'),
('25', '012', '0047', 'LAS AZULITAS', '82500'),
('25', '012', '0048', 'LA BAJADA', '82510'),
('25', '012', '0049', 'BALAMO', '82520'),
('25', '012', '0050', 'LA BARRIGONA', '82530'),
('25', '012', '0052', 'EL BEBEDOR', '82540'),
('25', '012', '0053', 'LOS BECERROS DE LA NORIA', '82550'),
('25', '012', '0056', 'BOCA ARROYO', '82560'),
('25', '012', '0057', 'EL BOLICHE', '82570');

--script INSERT articulos
INSERT INTO articulos (codigo, nombre, precio) VALUES
('0000000000001', 'Laptop Dell Inspiron 15', 12500.00),
('0000000000002', 'Mouse Inalámbrico Logitech', 450.00),
('0000000000003', 'Teclado Mecánico Redragon', 1200.00),
('0000000000004', 'Monitor LED 24" Samsung', 3800.00),
('0000000000005', 'Disco Duro Externo 1TB Seagate', 1500.00),
('0000000000006', 'Memoria RAM 16GB DDR4 Kingston', 2000.00),
('0000000000007', 'Tarjeta de Video RTX 3060', 7500.00),
('0000000000008', 'SSD NVMe 1TB Kingston', 2200.00),
('0000000000009', 'Fuente de Poder 650W EVGA', 1800.00),
('0000000000010', 'Gabinete Gamer Corsair', 2500.00),
('0000000000011', 'Router WiFi 6 TP-Link', 1600.00),
('0000000000012', 'Impresora Multifuncional HP', 3200.00),
('0000000000013', 'Silla Gamer Cougar', 4500.00),
('0000000000014', 'Procesador AMD Ryzen 7 5800X', 6200.00),
('0000000000015', 'Tarjeta Madre ASUS B550', 3500.00),
('0000000000016', 'Enfriamiento Líquido Corsair', 2800.00),
('0000000000017', 'Webcam Logitech HD', 900.00),
('0000000000018', 'Audífonos HyperX Cloud II', 2300.00),
('0000000000019', 'Tablet Samsung Galaxy Tab A7', 5400.00),
('0000000000020', 'Adaptador USB a HDMI UGREEN', 700.00),
('0000000000021', 'Docking Station USB-C Lenovo', 3200.00),
('0000000000022', 'Tarjeta de Captura Elgato HD60', 4500.00),
('0000000000023', 'Kit Teclado y Mouse Inalámbrico Logitech', 900.00),
('0000000000024', 'UPS 1500VA APC', 3800.00),
('0000000000025', 'Monitor Curvo 27" LG', 6800.00),
('0000000000026', 'Memoria USB 128GB SanDisk', 400.00),
('0000000000027', 'Hub USB 3.0 de 7 Puertos UGREEN', 850.00),
('0000000000028', 'Disco Duro Interno 4TB WD', 4500.00),
('0000000000029', 'Cámara de Seguridad Xiaomi 1080p', 1200.00),
('0000000000030', 'Micrófono Profesional Blue Yeti', 3500.00),
('0000000000031', 'Mousepad RGB XXL Razer', 900.00),
('0000000000032', 'SSD SATA 2TB Crucial', 3800.00),
('0000000000033', 'Procesador Intel Core i7-12700K', 7900.00),
('0000000000034', 'Base Refrigerante para Laptop Cooler Master', 1200.00),
('0000000000035', 'Switch de Red Gigabit 8 Puertos TP-Link', 1100.00),
('0000000000036', 'Cargador Universal para Laptop 90W', 1300.00),
('0000000000037', 'Extensor de WiFi TP-Link AC750', 950.00),
('0000000000038', 'Tarjeta WiFi PCIe AX3000', 1400.00),
('0000000000039', 'Soporte para Monitor de Escritorio', 1600.00),
('0000000000040', 'Batería Externa para Laptop 20000mAh', 2500.00);

--script INSERT clientes
INSERT INTO clientes (rfc_cliente, nombre, apellido_paterno, apellido_materno, calle_numero, id_estado, id_municipio, id_localidad) VALUES
('GVE123456ABC', 'Juan', 'Perez', 'Gomez', 'Calle 10 #123', '25', '011', '0001'),
('GVE654321XYZ', 'Maria', 'Lopez', 'Hernandez', 'Calle 8 #456', '25', '011', '0001'),
('GVE789654JKL', 'Carlos', 'Martinez', 'Diaz', 'Av. Reforma #789', '25', '011', '0001'),
('GVE456789QWE', 'Ana', 'Rodriguez', 'Sanchez', 'Calle 6 #321', '25', '011', '0001'),
('GVE852963MNB', 'Ricardo', 'Sosa', 'Mendoza', 'Blvd. Principal #555', '25', '011', '0001'),
('CUL951753VBA', 'Fernando', 'Gonzalez', 'Lopez', 'Av. Central #789', '25', '006', '0001'),
('CUL753951NMO', 'Elena', 'Ruiz', 'Paredes', 'Calle 4 #852', '25', '006', '0001'),
('CUL369852LKI', 'Sergio', 'Navarro', 'Jimenez', 'Blvd. del Valle #741', '25', '006', '0001'),
('CUL147258OIP', 'Laura', 'Gutierrez', 'Fernandez', 'Calle 7 #963', '25', '006', '0001'),
('CUL258147MKI', 'Hugo', 'Torres', 'Aguilar', 'Av. Sur #147', '25', '006', '0001'),
('MZT123789ASD', 'Isabel', 'Mendoza', 'Castro', 'Blvd. Pacífico #753', '25', '012', '0001'),
('MZT987321DFG', 'Gabriel', 'Rios', 'Ortega', 'Calle Mar #369', '25', '012', '0001'),
('MZT654987ZXC', 'Diana', 'Campos', 'Delgado', 'Calle Luna #456', '25', '012', '0001'),
('MZT321654QAZ', 'Javier', 'Cervantes', 'Noriega', 'Blvd. Sol #951', '25', '012', '0001'),
('MZT741852WSX', 'Patricia', 'Hernandez', 'Bravo', 'Calle Estrella #852', '25', '012', '0001');

--script INSERT Facturas
INSERT INTO facturas (rfc_cliente, fecha) VALUES
('GVE123456ABC', '2024-01-01 10:30:00'),
('GVE654321XYZ', '2024-01-02 12:45:00'),
('GVE789654JKL', '2024-01-03 14:00:00'),
('GVE456789QWE', '2024-01-04 09:15:00'),
('GVE852963MNB', '2024-01-05 17:20:00'),
('CUL951753VBA', '2024-02-06 11:30:00'),
('CUL753951NMO', '2024-02-07 13:10:00'),
('CUL369852LKI', '2024-02-08 16:45:00'),
('CUL147258OIP', '2024-02-09 18:30:00'),
('CUL258147MKI', '2024-02-10 15:20:00'),
('MZT123789ASD', '2024-02-11 08:50:00'),
('MZT987321DFG', '2024-02-12 14:15:00'),
('MZT654987ZXC', '2024-03-13 17:10:00'),
('MZT321654QAZ', '2024-03-14 09:35:00'),
('MZT741852WSX', '2024-03-15 10:40:00'),
('GVE123456ABC', '2024-03-16 12:00:00'),
('CUL951753VBA', '2024-03-17 15:50:00'),
('MZT654987ZXC', '2024-04-18 18:15:00'),
('GVE789654JKL', '2024-04-19 09:05:00'),
('CUL369852LKI', '2024-04-20 14:25:00');

--script Detalles de Facturas
INSERT INTO detalles_facturas (folio_factura, codigo_articulo, cantidad, precio_venta) VALUES
(1, '0000000000001', 2, 1100.00),
(1, '0000000000005', 1, 950.00),
(2, '0000000000003', 1, 2500.00),
(2, '0000000000008', 2, 1800.00),
(3, '0000000000002', 1, 3200.00),
(3, '0000000000010', 3, 1500.00),
(3, '0000000000004', 1, 2200.00),
(4, '0000000000007', 2, 3500.00),
(5, '0000000000012', 4, 4200.00),
(6, '0000000000015', 2, 3800.00),
(6, '0000000000019', 1, 2400.00),
(7, '0000000000017', 3, 1100.00),
(8, '0000000000020', 5, 2500.00),
(9, '0000000000006', 2, 900.00),
(9, '0000000000011', 1, 3500.00),
(10, '0000000000025', 2, 6800.00),
(10, '0000000000027', 1, 800.00),
(11, '0000000000022', 3, 4500.00),
(12, '0000000000029', 2, 1200.00),
(13, '0000000000033', 1, 7900.00),
(13, '0000000000037', 3, 900.00),
(14, '0000000000036', 2, 1300.00),
(15, '0000000000031', 1, 900.00),
(16, '0000000000024', 2, 3800.00),
(17, '0000000000028', 3, 4400.00),
(18, '0000000000034', 1, 1200.00),
(19, '0000000000039', 2, 1600.00),
(19, '0000000000040', 1, 2400.00),
(20, '0000000000035', 2, 1100.00);
--FIN