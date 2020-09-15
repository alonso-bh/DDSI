CREATE TABLE Edicion(
    Numero integer PRIMARY KEY);

--Tablas subsistema 1:

CREATE TABLE Entidad(
email varchar2(50) CONSTRAINT Correo_no_tiene_Arroba CHECK (email like '%@%') PRIMARY KEY,
nombre varchar2(40),
telefono varchar2(12) CONSTRAINT Telefono_no_valido CHECK (regexp_like(telefono, '["+"[0-9]*[0-9]*]?[0-9]{9}')),
contacto varchar2(100));

CREATE TABLE Patrocina(
email REFERENCES Entidad(email) NOT NULL,
numero_edicion references Edicion(numero) NOT NULL, 
dinero_aportado float,
PRIMARY KEY(email, numero_edicion)
);

CREATE TABLE Colabora(
email REFERENCES Entidad(email) NOT NULL,
numero_edicion REFERENCES Edicion(numero) NOT NULL,
dinero_aportado float,
PRIMARY KEY (email, numero_edicion)
);

--Tablas subsistema 2:

create table partidos ( 
	id_partido integer primary key,
	fecha date 
);


create table jugadores (
	e_mail varchar2(50) not null, 	
	direccion_postal varchar2(70),
	nombre varchar2(40) , 
	dni varchar2(10) primary key 	
);

create table arbitro (
	dni varchar2(10) primary key,
	nombre varchar2(40),
	direccion_postal varchar2(70), 
	e_mail varchar2(50) not null constraint email_ok check (e_mail like '%@%') );

create table se_juega_en (
	id_partido references partidos(id_partido) ,
	numero_edicion references Edicion(Numero) ,
	primary key (id_partido, numero_edicion) 
); 

create table arbitrados_por (
	dni references arbitro(dni) primary key,
	id_partido references partidos(id_partido)  );

create table juegan_en (
	id_partido references partidos(id_partido) ,
	dni references jugadores(dni) ,
	primary key (id_partido, dni)
);

CREATE TABLE Pista(
	numeropista NUMBER(4) CONSTRAINT valores_mayor_a_0 CHECK (numeropista > 0 )  PRIMARY KEY,
	nombre VARCHAR2(40) NOT NULL, 
	capacidad NUMBER(4) NOT NULL
);


create table ocupa (
	id_partido references partidos (id_partido) primary key,
	id_pista REFERENCES pista(numeropista) 
);

-- Tablas subsistema 3 (y parte del 4):

CREATE TABLE Material(
	idmaterial VARCHAR2(10) PRIMARY KEY,
	cantidad NUMBER(4) NOT NULL,
	nombrematerial VARCHAR2(40) NOT NULL
);

CREATE TABLE Pedido(
	numerodepedido NUMBER(4) CONSTRAINT valores_mayor_que_0 CHECK (numerodepedido > 0 ) PRIMARY KEY
);

CREATE TABLE Trabajador(
	dni VARCHAR2(9) CONSTRAINT DNI_no_valido CHECK (REGEXP_LIKE (dni, '[0-9]{8}[A-Z]')) PRIMARY KEY, 
	nombre VARCHAR2(40) NOT NULL, 
	telefono NUMBER(9), 
	email VARCHAR2(50) CONSTRAINT email_no_valido CHECK (email like '%@%')
);

CREATE TABLE Suministra(
	email not null,
	numeros not null, 
	idmaterial REFERENCES Material(idmaterial),
	FOREIGN KEY (email, numeros) REFERENCES Patrocina (email, numero_edicion),
	PRIMARY KEY (email, numeros, idmaterial)
);

CREATE TABLE CompuestoPor(
	idmaterial REFERENCES Material(idmaterial),
	numerodepedido REFERENCES Pedido(numerodepedido),
	PRIMARY KEY (idmaterial, numerodepedido)
);

CREATE TABLE TrabajaEn(
	numero REFERENCES Edicion (numero), 
	dni REFERENCES Trabajador(dni),
	PRIMARY KEY (numero, dni)
);

CREATE TABLE Entrega(
	numerodepedido REFERENCES Pedido(numerodepedido),
	fechaentrega DATE,
	numero NOT NULL,
	dni NOT NULL,
	FOREIGN KEY (numero, dni) REFERENCES TrabajaEn (numero, dni),
	PRIMARY KEY (numerodepedido, fechaentrega)
);

CREATE TABLE PedidoAsignadoA(
	numerodepedido REFERENCES Pedido (numerodepedido), 
	numeropista REFERENCES Pista (numeropista),
	PRIMARY KEY (numerodepedido, numeropista)
);

-- Tablas subsistema 4:

CREATE TABLE TrabajadorAsignadoA(
	numeropista REFERENCES Pista (numeropista),
	numero NOT NULL,
	dni NOT NULL,
	horainicio DATE NOT NULL,
	horafin DATE NOT NULL,
	fecha DATE NOT NULL,
	FOREIGN KEY (numero, dni) REFERENCES TrabajaEn (numero, dni),
	PRIMARY KEY (numeropista, numero, dni)
);
/*
-- describe subsistema 1:

describe edicion;
describe entidad;
describe patrocina;
describe colabora;

-- describe subsistema 2:

describe partidos;
describe jugadores;
describe arbitro;
describe se_juega_en;
describe arbitrados_por;
describe juegan_en; 
describe ocupa;

-- describe subsistema 3 (y parte del 4):

describe Material;
describe Pedido;
describe Trabajador;
describe Pista;
describe CompuestoPor;
describe Suministra;
describe Entrega;

-- describe subsistema 4:

describe TrabajaEn;
describe PedidoAsignadoA;
describe trabajadorAsignadoA;
*/


-- triggers subsistema 1:

CREATE OR REPLACE TRIGGER patrocinador_ya_es_colaborador
BEFORE INSERT ON Patrocina
FOR EACH ROW
declare
  cont number(20);
BEGIN
    SELECT count(*)
    into cont
    FROM Colabora
    where email=:new.email
    and  numero_edicion=:new.numero_edicion;

  if cont>0 then
     raise_application_error(-20000, 'El patrocinador a insertar ya esta registrado como colaborador para esta edicion.
    Insercion de tupla abortada'); 
  end if;
END;
/

CREATE OR REPLACE TRIGGER colaborador_ya_es_patrocinador
BEFORE INSERT ON Colabora
FOR EACH ROW
declare
  cont number(20);
BEGIN
    SELECT count(*)
    into cont
    FROM Patrocina
    where email=:new.email
    and  numero_edicion=:new.numero_edicion;

  if cont>0 then
     raise_application_error(-20000, 'El colaborador a insertar ya esta registrado como patrociandor para esta edicion.
    Insercion de tupla abortada'); 
  end if;
END;
/



-- triggers S2 (Alonso)

CREATE OR REPLACE TRIGGER disparador_s2
BEFORE INSERT ON ocupa
FOR EACH ROW
declare
  cont integer; fecha_aux date;
BEGIN
    SELECT partidos.fecha 
    into fecha_aux 
    FROM partidos 
    WHERE partidos.id_partido=:new.id_partido;  
    -- ya tengo la fecha asociada al partido dado 

    SELECT count(*)
    into cont
    FROM ocupa NATURAL JOIN partidos 
    where id_pista=:new.id_pista AND 
          partidos.fecha=fecha_aux ;
    
    if cont>2 then
      raise_application_error(-20000, 'Esta pista ya tiene asociados tres partidos. Insercion de tupla abortada'); 
    end if;
END;
/



-- trigger subsistema 4:

CREATE OR REPLACE TRIGGER disparador_S4
BEFORE INSERT ON TrabajadorAsignadoA
FOR EACH ROW
declare
  cont number(20);
BEGIN
    SELECT count(*) 
    into cont
    FROM TrabajadorAsignadoA
    where numeropista=:new.numeropista
    and  numero=:new.numero
    and dni=:new.dni 
    and fecha=:new.fecha;

  if cont>0 then
     raise_application_error(-20000, 'La asignacion de esa pista a ese trabajador ha fallado ya que ese trabajador ya habia sido asignado a esa pista ese dia.
Insercion de tupla abortada'); 
  end if;
END;
/



-- disparador subsistema 3:

CREATE OR REPLACE TRIGGER nuevo_pedido
	BEFORE INSERT ON CompuestoPor
	FOR EACH ROW
	DECLARE 
		email1	VARCHAR2(50);
		email2	VARCHAR2(50);
		idMaterial1 VARCHAR2(10);
BEGIN

	SELECT idmaterial
	INTO idMaterial1
	FROM CompuestoPor 
	WHERE numerodepedido=:new.numerodepedido AND idmaterial!=:new.idmaterial;	

	SELECT EMAIL
	INTO email2 
	FROM Suministra
	WHERE idmaterial=idMaterial1;

	SELECT EMAIL
	INTO email1
	FROM Suministra
	WHERE idmaterial=:new.idmaterial;

	IF email1!=email2 then
		raise_application_error (-20600, 'Los materiales de un pedido deben de ser de un mismo patrocinador. Accion abortada');
	END IF;
END;
/




-- inserts subsistema 1:

INSERT INTO Edicion (numero) VALUES (1);
INSERT INTO Edicion (numero) VALUES (2);
INSERT INTO Edicion (numero) VALUES (3);
INSERT INTO Edicion (numero) VALUES (4);
INSERT INTO Edicion (numero) VALUES (5);
INSERT INTO Edicion (numero) VALUES (6);
INSERT INTO Edicion (numero) VALUES (7);
INSERT INTO Edicion (numero) VALUES (8);
INSERT INTO Edicion (numero) VALUES (9);
INSERT INTO Edicion (numero) VALUES (10);

INSERT INTO Entidad (email, nombre, telefono, contacto) VALUES ('constructoresmanolo@gmail.com', 'Constructora Manolo', '32619786543', 'Manolo');
INSERT INTO Entidad (email, nombre, telefono, contacto) VALUES ('peluqueriaantonio@gmail.com', 'Peluqueria Antonio', '958345678', 'Antonio');
INSERT INTO Entidad (email, nombre, telefono, contacto) VALUES ('comercialesmaria_7877@gmail.com', 'Veinte Duros', '+32722435678', 'Josefa');
INSERT INTO Patrocina (email, numero_edicion, dinero_aportado) VALUES ('comercialesmaria_7877@gmail.com', 1, 545.67);
INSERT INTO Patrocina (email, numero_edicion, dinero_aportado) VALUES ('peluqueriaantonio@gmail.com', 1, 545.67);
INSERT INTO Patrocina (email, numero_edicion, dinero_aportado) VALUES ('comercialesmaria_7877@gmail.com', 2, 180.56);
INSERT INTO Patrocina (email, numero_edicion, dinero_aportado) VALUES ('comercialesmaria_7877@gmail.com', 3, 234.78);
INSERT INTO Colabora (email, numero_edicion, dinero_aportado) VALUES ('constructoresmanolo@gmail.com', 1, 90.86);
INSERT INTO Patrocina (email, numero_edicion, dinero_aportado) VALUES ('constructoresmanolo@gmail.com', 4, 326.58);
INSERT INTO Colabora (email, numero_edicion, dinero_aportado) VALUES ('comercialesmaria_7877@gmail.com', 4, 326.58);
INSERT INTO Colabora (email, numero_edicion, dinero_aportado) VALUES ('peluqueriaantonio@gmail.com', 4, 487.20);

--Las tres inserciones siguientes debajo deberian de hacer saltar los disparadores:
/*
INSERT INTO Colabora (email, numero_edicion, dinero_aportado) VALUES ('constructoresmanolo@gmail.com', 4, 326.58);
INSERT INTO Patrocina (email, numero_edicion, dinero_aportado) VALUES ('comercialesmaria_7877@gmail.com', 4, 326.58);
INSERT INTO Patrocina (email, numero_edicion, dinero_aportado) VALUES ('peluqueriaantonio@gmail.com', 4, 487.20);
*/

-- INSERT subsistema 2:

INSERT INTO Pista (numeropista, nombre, capacidad) VALUES (1, 'PistaFelicianoLopez', 500);
INSERT INTO Pista (numeropista, nombre, capacidad) VALUES (2, 'PistaGrande', 800);
INSERT INTO Pista (numeropista, nombre, capacidad) VALUES (3, 'Pista3', 250);

insert into partidos (id_partido, fecha) VALUES (1, TO_DATE('12-01-2012','dd-mm-yyyy'));
insert into partidos (id_partido, fecha) VALUES (2, TO_DATE('03-09-2018','dd-mm-yyyy'));
insert into partidos (id_partido, fecha) VALUES (3, TO_DATE('23-12-2020','dd-mm-yyyy'));
insert into partidos (id_partido, fecha) VALUES (4, TO_DATE('23-12-2020','dd-mm-yyyy'));
insert into partidos (id_partido, fecha) VALUES (5, TO_DATE('23-12-2020','dd-mm-yyyy'));
insert into partidos (id_partido, fecha) VALUES (6, TO_DATE('23-12-2020','dd-mm-yyyy'));



insert into jugadores (nombre, dni, direccion_postal, e_mail) values ('Federico Martin Bahamontes', '12233412A', 'Plaza de Don Pardo 12', 'federbm@gmail.com');
insert into jugadores (nombre, dni, direccion_postal, e_mail) values ('Antonio Martin Garcia', '12998844A', 'Avenida de las Acacias 12 1Izda', 'antoniomg@gmail.com');
insert into jugadores (nombre, dni, direccion_postal, e_mail) values ('Luis Garcia Garcia', '24231212A', 'Calle General Redondo 12', 'luisitogarci@gmail.com');


insert into arbitro (dni, nombre, direccion_postal, e_mail) values ('33443322E', 'Maria Jose Merino Gutierrez', 'Paseo de San Rafael 5 2ï¿½ B', 'marimegu@yahoo.es');
insert into arbitro (dni, nombre, direccion_postal, e_mail) values ('33449922E', 'Antonio Garcia Martin', 'Calle de Mendez Alvaro 5', 'antoningm@yahoo.es');
insert into arbitro (dni, nombre, direccion_postal, e_mail) values ('12123498J', 'Luis Gutierrez Aragon', 'Carretera de Extremadura 12 1ï¿½D', 'luisga@yahoo.es');


insert into se_juega_en (id_partido, numero_edicion) values (1, 1);


insert into arbitrados_por (dni, id_partido) values ('33443322E', 1);
insert into arbitrados_por (dni, id_partido) values ('33449922E', 2);

insert into juegan_en (id_partido, dni) values (2, '12233412A');

insert into ocupa (id_partido, id_pista) values (3,1) ; 
insert into ocupa (id_partido, id_pista) values (4,1) ;
insert into ocupa (id_partido, id_pista) values (5,1) ;
insert into ocupa (id_partido, id_pista) values (6,1) ;  /* esto hace saltar el disparador (no más de tres partidos a una pista en un día */

-- INSERT subsistema 3 y 4:

INSERT INTO Material (idmaterial, cantidad, nombrematerial) VALUES ('124387cds', 12, 'pelotas');
INSERT INTO Material (idmaterial, cantidad, nombrematerial) VALUES ('65879dfg', 7, 'redes');
INSERT INTO Material (idmaterial, cantidad, nombrematerial) VALUES ('239dfrgg', 4, 'raquetas');

INSERT INTO Pedido (numerodepedido) VALUES (1);
INSERT INTO Pedido (numerodepedido) VALUES (2);
INSERT INTO Pedido (numerodepedido) VALUES (3);
INSERT INTO Pedido (numerodepedido) VALUES (4);

INSERT INTO Trabajador (dni, nombre, telefono, email) VALUES ('12345678K', 'Pepito', 611345672, 'pepito@cgmail.com');
INSERT INTO Trabajador (dni, nombre, telefono, email) VALUES ('11342678F', 'Antonio', 621326572, 'antonio23@cgmail.com');
INSERT INTO Trabajador (dni, nombre, telefono, email) VALUES ('11223344F', 'Pepe', 632126212, 'pepe123@cgmail.com');


-- ---------------------------------------------------------------------
-- NOTA: LOS INSERT asociados a PISTA estÃ¡n en la zona del S2 (necesarios)
-- ---------------------------------------------------------------------

INSERT INTO Suministra (email, numeros, idmaterial) VALUES ('comercialesmaria_7877@gmail.com', 2, '124387cds');
INSERT INTO Suministra (email, numeros, idmaterial) VALUES ('peluqueriaantonio@gmail.com', 1, '65879dfg');
INSERT INTO Suministra (email, numeros, idmaterial) VALUES ('peluqueriaantonio@gmail.com', 1, '239dfrgg');

INSERT INTO CompuestoPor (idmaterial, numerodepedido) VALUES ('124387cds', 1);
INSERT INTO CompuestoPor (idmaterial, numerodepedido) VALUES ('65879dfg', 2);

INSERT INTO TrabajaEn (numero, dni) VALUES (3, '12345678K');
INSERT INTO TrabajaEn (numero, dni) VALUES (2, '11342678F');
INSERT INTO TrabajaEn (numero, dni) VALUES (2, '11223344F');

INSERT INTO Entrega (numerodepedido, fechaentrega, numero, dni) VALUES (1, TO_DATE('12/03/2019','dd/mm/yyyy'), 3, '12345678K');
INSERT INTO Entrega (numerodepedido, fechaentrega, numero, dni) VALUES (2, TO_DATE('25/05/2020','dd/mm/yyyy'), 2, '11342678F');

INSERT INTO PedidoAsignadoA (numerodepedido, numeropista) VALUES (1, 1);
INSERT INTO PedidoAsignadoA (numerodepedido, numeropista) VALUES (4, 3);

INSERT INTO TrabajadorAsignadoA (numeropista, numero, dni, horainicio, horafin, fecha) VALUES (1, 3, '12345678K', TO_DATE('12/03/2019 11:30:00','dd/mm/yyyy hh:mi:ss'), TO_DATE('12/03/2019 12:00:00','dd/mm/yyyy hh:mi:ss'), TO_DATE('12/03/2019','dd/mm/yyyy'));
INSERT INTO TrabajadorAsignadoA (numeropista, numero, dni, horainicio, horafin, fecha) VALUES (2, 2, '11342678F', TO_DATE('10/01/2020 07:30:00','dd/mm/yyyy hh:mi:ss'), TO_DATE('10/01/2020 08:45:00','dd/mm/yyyy hh:mi:ss'), TO_DATE('10/01/2020','dd/mm/yyyy'));

--Insert que hace saltar el disparador 3
INSERT INTO CompuestoPor (idmaterial, numerodepedido) VALUES ('239dfrgg', 1);

--Insert que hace saltar el disparador 4

INSERT INTO TrabajadorAsignadoA (numeropista, numero, dni, horainicio, horafin, fecha) VALUES (2, 2, '11342678F', TO_DATE('10/01/2020 11:30:00','dd/mm/yyyy hh:mi:ss'), TO_DATE('10/01/2020 12:45:00','dd/mm/yyyy hh:mi:ss'), TO_DATE('10/01/2020','dd/mm/yyyy'));

--Este insert da error
INSERT INTO CompuestoPor (idmaterial, numerodepedido) VALUES ('239dfrgg', 1);

/*
-- select subsistema 1:

select * from edicion;
select * from entidad;
select * from patrocina;
select * from colabora;

-- select subsistema 2:

select * from partidos;
select * from jugadores;
select * from arbitro;
select * from se_juega_en;
select * from arbitrados_por;
select * from juegan_en; 
SELECT * from ocupa;

-- select subsistema 3 (y parte del 4):

select * from Material;
select * from Pedido;
select * from Trabajador;
select * from Pista;
select * from CompuestoPor;
select * from Suministra;
select * from Entrega;

-- select subsistema 4:

select * from TrabajaEn;
select * from PedidoAsignadoA;
select * from trabajadorAsignadoA;
*/


/*
-- drop subsistema 2:

drop table juegan_en;
drop table arbitrados_por;
drop table se_juega_en;
drop table arbitro;
drop table jugadores;
drop table ocupa;
drop table partidos; 


-- drop subsistemas 3 y 4:

drop trigger nuevo_pedido;
drop tigger disparador_s4;

drop table TrabajadorAsignadoA;
drop table PedidoAsignadoA;
drop table TrabajaEn;
drop table Entrega;
drop table Suministra;
drop table CompuestoPor;
drop table Pista;
drop table Trabajador;
drop table Pedido;
drop table Material;

-- drop subsistema 1:

DROP TRIGGER patrocinador_ya_es_colaborador;
DROP TRIGGER colaborador_ya_es_patrocinador;

DROP TABLE Patrocina;
DROP TABLE Colabora;
DROP TABLE Partido;
DROP TABLE Pista;
DROP TABLE Entidad;
DROP TABLE Edicion;

*/

