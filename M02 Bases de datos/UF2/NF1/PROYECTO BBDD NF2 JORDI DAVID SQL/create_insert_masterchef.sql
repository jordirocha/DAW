DROP TABLE RECEPTAS CASCADE CONSTRAINTS;
DROP TABLE ALERGENS CASCADE CONSTRAINTS;
DROP TABLE PRESENTEN CASCADE CONSTRAINTS;
DROP TABLE INGREDIENTS CASCADE CONSTRAINTS;
DROP TABLE CONSTAN CASCADE CONSTRAINTS;
DROP TABLE VALORACIONS CASCADE CONSTRAINTS;
DROP TABLE USUARIS CASCADE CONSTRAINTS;
DROP TABLE ESDEVENIMENTS CASCADE CONSTRAINTS;
DROP TABLE INSCRITS CASCADE CONSTRAINTS;
DROP TABLE SESSIONS CASCADE CONSTRAINTS;
DROP TABLE XEFS CASCADE CONSTRAINTS;
DROP TABLE CONCURSAN CASCADE CONSTRAINTS;
DROP TABLE PARTICIPAN CASCADE CONSTRAINTS;
DROP SEQUENCE ID_ALERGEN_SEQ;
DROP SEQUENCE ID_INGREDIENTS_SEQ;
DROP SEQUENCE ID_XEF_SEQ;

/*SEQUENCIAS DE ALERGENS INGREDIENTS XEFS TABLAS*/
CREATE SEQUENCE ID_ALERGEN_SEQ 
INCREMENT BY 1
START WITH 1
MAXVALUE 50
NOCACHE
NOCYCLE;

CREATE SEQUENCE ID_INGREDIENTS_SEQ 
INCREMENT BY 1
START WITH 1
MAXVALUE 20
NOCACHE
NOCYCLE;

CREATE SEQUENCE ID_XEF_SEQ
INCREMENT BY 1
START WITH 1
MAXVALUE 25
NOCACHE
NOCYCLE;

/*LAS TABLAS SIN LAS CLAVES FORANEAS*/
CREATE TABLE RECEPTAS
(ID_RECEPTA NUMBER(2) NOT NULL PRIMARY KEY,
NOMBRE_RECETA VARCHAR2(35) NOT NULL,
CALORIES_PERS NUMBER(4) NOT NULL,
COMENSALS NUMBER(2),
CATEGORIA VARCHAR2(20),
TEMPS_PREPARACIO NUMBER(3),
DIFICULTAT VARCHAR2(25) CHECK (DIFICULTAT IN ('facil','intermig','dificil')),
RECEPTA_XEF number(2),
RECEPTA_USUARI number(2));

CREATE TABLE ALERGENS 
(ID_ALERGEN NUMBER(2) NOT NULL PRIMARY KEY,
NOM_ALERGEN VARCHAR2(25) NOT NULL UNIQUE);

CREATE TABLE PRESENTEN
(ID_RECEPTA NUMBER(2),
ID_ALERGEN NUMBER(2),
CONSTRAINT PRESENTEN_REC_ALE_PK PRIMARY KEY (ID_RECEPTA, ID_ALERGEN));

CREATE TABLE INGREDIENTS 
(ID_INGREDIENT NUMBER(2) NOT NULL PRIMARY KEY,
NOM_INGREDIENT VARCHAR2(25) NOT NULL UNIQUE,
TIPUS VARCHAR2(25) NOT NULL);

CREATE TABLE CONSTAN
(ID_RECEPTA NUMBER(2),
ID_INGREDIENT NUMBER(2),
QUANTITAT NUMBER(4) NOT NULL,
UNITAT_MESURA VARCHAR2(20) CHECK (UNITAT_MESURA IN ('gr', 'ml', 'unidad')) NOT NULL,
CONSTRAINT CONS_REC_ING_PK PRIMARY KEY (ID_RECEPTA, ID_INGREDIENT));

CREATE TABLE VALORACIONS
(ID_USUARI NUMBER(2),
ID_RECEPTA NUMBER(2),
ESTRELLAS NUMBER(2) CHECK (ESTRELLAS IN (1,2,3,4,5)) NOT NULL,
COMENTARIS VARCHAR2(50),
CONSTRAINT VAL_REC_USU_PK PRIMARY KEY (ID_USUARI, ID_RECEPTA));

CREATE TABLE USUARIS
(ID_USUARI NUMBER(2) NOT NULL PRIMARY KEY,
NOM_USUARI VARCHAR2(25) NOT NULL UNIQUE,
CORREO VARCHAR2(25) NOT NULL UNIQUE,
PASSWORD VARCHAR2(20) NOT NULL);

CREATE TABLE ESDEVENIMENTS 
(ID_ESDEVENIMENT NUMBER(2) NOT NULL PRIMARY KEY,
NOM_ESDEVENIMENT VARCHAR2(35) NOT NULL,
UBICACIO VARCHAR2(30),
FECHA DATE DEFAULT SYSDATE, 
MAX_PARTICIPANTS NUMBER(3) CHECK (MAX_PARTICIPANTS < 150),
TIPUS_EVENT VARCHAR2(25) CHECK (TIPUS_EVENT IN ('show cooking', 'concurs')) NOT NULL,
TIPUS_BUFFET VARCHAR2(20) CHECK (TIPUS_BUFFET IN ('si', 'no')),
NIVELL VARCHAR2(25) CHECK (NIVELL IN ('principiant','intermig','professional')));

CREATE TABLE INSCRITS
(ID_USUARI NUMBER(2),
ID_ESDEVENIMENT NUMBER(2),
DATA_INSCRIPCIO DATE DEFAULT SYSDATE,
CONSTRAINT INS_ESDE_USU_PK PRIMARY KEY (ID_USUARI, ID_ESDEVENIMENT));

CREATE TABLE SESSIONS
(CODI_SESSIO NUMBER(2) NOT NULL PRIMARY KEY,
ZONA_HORARIA VARCHAR2(5) CHECK (ZONA_HORARIA IN ('mati', 'tarda')) NOT NULL,
DURADA NUMBER(5),
ID_ESDEVENIMENT NUMBER(2));

CREATE TABLE XEFS
(ID_XEF NUMBER(2) NOT NULL PRIMARY KEY,
NOM_XEF VARCHAR2(30) NOT NULL,
NUM_ESTRELLAS NUMBER(1) CHECK (NUM_ESTRELLAS IN (1,2,3,4,5)) NOT NULL);

CREATE TABLE CONCURSAN
(ID_XEF NUMBER(2),
ID_USUARI NUMBER(2),
ID_ESDEVENIMENT NUMBER(2),
NOTA NUMBER(2) CHECK (NOTA BETWEEN 0 AND 10) NOT NULL,
CONSTRAINT CONCUR_XEF_ESDE_USU_PK PRIMARY KEY (ID_XEF, ID_USUARI, ID_ESDEVENIMENT));

CREATE TABLE PARTICIPAN
(ID_XEF NUMBER(2),
ID_ESDEVENIMENT NUMBER(2),
TARIFA NUMBER(7) CHECK (TARIFA > 0) NOT NULL,
CONSTRAINT PARTI_XEF_ESDE_PK PRIMARY KEY (ID_XEF, ID_ESDEVENIMENT));

/*ANYADIDO DE RESTRICCIONES A LAS TABLAS*/
ALTER TABLE RECEPTAS
ADD CONSTRAINT REC_XEF_FK FOREIGN KEY (RECEPTA_XEF)
REFERENCES XEFS (ID_XEF);

ALTER TABLE RECEPTAS
ADD CONSTRAINT REC_USU_FK FOREIGN KEY (RECEPTA_USUARI)
REFERENCES USUARIS (ID_USUARI);

ALTER TABLE PRESENTEN
ADD CONSTRAINT PRE_ALER_FK FOREIGN KEY (ID_ALERGEN)
REFERENCES ALERGENS (ID_ALERGEN);

ALTER TABLE PRESENTEN
ADD CONSTRAINT PRE_REC_FK FOREIGN KEY (ID_RECEPTA)
REFERENCES RECEPTAS (ID_RECEPTA);

ALTER TABLE CONSTAN
ADD CONSTRAINT CON_REC_FK FOREIGN KEY (ID_RECEPTA)
REFERENCES RECEPTAS (ID_RECEPTA);

ALTER TABLE CONSTAN
ADD CONSTRAINT CON_INGRE_FK FOREIGN KEY (ID_INGREDIENT)
REFERENCES INGREDIENTS (ID_INGREDIENT);

ALTER TABLE VALORACIONS
ADD CONSTRAINT VAL_REC_FK FOREIGN KEY (ID_RECEPTA)
REFERENCES RECEPTAS (ID_RECEPTA);

ALTER TABLE VALORACIONS
ADD CONSTRAINT VAL_USU_FK FOREIGN KEY (ID_USUARI)
REFERENCES USUARIS (ID_USUARI);

ALTER TABLE INSCRITS
ADD CONSTRAINT INS_USU_FK FOREIGN KEY (ID_USUARI)
REFERENCES USUARIS (ID_USUARI);

ALTER TABLE INSCRITS
ADD CONSTRAINT INS_ESDE_FK FOREIGN KEY (ID_ESDEVENIMENT)
REFERENCES ESDEVENIMENTS (ID_ESDEVENIMENT);

ALTER TABLE SESSIONS
ADD CONSTRAINT SES_ESDE_FK FOREIGN KEY (ID_ESDEVENIMENT)
REFERENCES ESDEVENIMENTS (ID_ESDEVENIMENT);

ALTER TABLE PARTICIPAN
ADD CONSTRAINT PART_XEF_FK FOREIGN KEY (ID_XEF)
REFERENCES XEFS (ID_XEF);

ALTER TABLE PARTICIPAN 
ADD CONSTRAINT PART_ESDE_FK FOREIGN KEY (ID_ESDEVENIMENT)
REFERENCES ESDEVENIMENTS (ID_ESDEVENIMENT);

ALTER TABLE CONCURSAN
ADD CONSTRAINT CON_XEF_FK FOREIGN KEY (ID_XEF)
REFERENCES XEFS (ID_XEF);

ALTER TABLE CONCURSAN
ADD CONSTRAINT CON_USU_FK FOREIGN KEY (ID_USUARI)
REFERENCES USUARIS (ID_USUARI);

ALTER TABLE CONCURSAN
ADD CONSTRAINT CON_ESDEVE_FK FOREIGN KEY (ID_ESDEVENIMENT)
REFERENCES ESDEVENIMENTS (ID_ESDEVENIMENT);

/*INSERTS A ALERGIAS CON SEQUENCE*/
INSERT INTO ALERGENS VALUES (ID_ALERGEN_SEQ.NEXTVAL, 'lactics');
INSERT INTO ALERGENS VALUES (ID_ALERGEN_SEQ.NEXTVAL, 'gluten');
INSERT INTO ALERGENS VALUES (ID_ALERGEN_SEQ.NEXTVAL, 'ovids');
INSERT INTO ALERGENS VALUES (ID_ALERGEN_SEQ.NEXTVAL, 'polen');
INSERT INTO ALERGENS VALUES (ID_ALERGEN_SEQ.NEXTVAL, 'sulfits');
INSERT INTO ALERGENS VALUES (ID_ALERGEN_SEQ.NEXTVAL, 'fruits secs');
INSERT INTO ALERGENS VALUES (ID_ALERGEN_SEQ.NEXTVAL, 'sesamo');
INSERT INTO ALERGENS VALUES (ID_ALERGEN_SEQ.NEXTVAL, 'mostaza');
INSERT INTO ALERGENS VALUES (ID_ALERGEN_SEQ.NEXTVAL, 'granos de sesamo');
INSERT INTO ALERGENS VALUES (ID_ALERGEN_SEQ.NEXTVAL, 'pescado');

/*INSERTANDO A INGREDIENTES CON SEQUENCE**/
INSERT INTO INGREDIENTS VALUES (ID_INGREDIENTS_SEQ.NEXTVAL,'tomate', 'vegetal');
INSERT INTO INGREDIENTS VALUES (ID_INGREDIENTS_SEQ.NEXTVAL,'huevo', 'huevo');
INSERT INTO INGREDIENTS VALUES (ID_INGREDIENTS_SEQ.NEXTVAL,'leche', 'lacteo');
INSERT INTO INGREDIENTS VALUES (ID_INGREDIENTS_SEQ.NEXTVAL,'carne vacuna', 'vacuno');
INSERT INTO INGREDIENTS VALUES (ID_INGREDIENTS_SEQ.NEXTVAL,'queso', 'lacteo');
INSERT INTO INGREDIENTS VALUES (ID_INGREDIENTS_SEQ.NEXTVAL,'pollo', 'ave');
INSERT INTO INGREDIENTS VALUES (ID_INGREDIENTS_SEQ.NEXTVAL,'carne porcina', 'porcino');
INSERT INTO INGREDIENTS VALUES (ID_INGREDIENTS_SEQ.NEXTVAL,'arroz', 'arroz');
INSERT INTO INGREDIENTS VALUES (ID_INGREDIENTS_SEQ.NEXTVAL,'fetuccini', 'pasta');
INSERT INTO INGREDIENTS VALUES (ID_INGREDIENTS_SEQ.NEXTVAL,'nata liquida', 'lacteo');
INSERT INTO INGREDIENTS VALUES (ID_INGREDIENTS_SEQ.NEXTVAL,'nata p/montar', 'lacteo');
INSERT INTO INGREDIENTS VALUES (ID_INGREDIENTS_SEQ.NEXTVAL,'azucar blanco', 'azucar');
INSERT INTO INGREDIENTS VALUES (ID_INGREDIENTS_SEQ.NEXTVAL,'azucar moreno', 'azucar');
INSERT INTO INGREDIENTS VALUES (ID_INGREDIENTS_SEQ.NEXTVAL,'vainilla', 'vegetal');
INSERT INTO INGREDIENTS VALUES (ID_INGREDIENTS_SEQ.NEXTVAL,'bolet', 'vegetal');
INSERT INTO INGREDIENTS VALUES (ID_INGREDIENTS_SEQ.NEXTVAL,'aceite de oliva', 'materias grasas');
INSERT INTO INGREDIENTS VALUES (ID_INGREDIENTS_SEQ.NEXTVAL,'yogur', 'lacteo');

/*INSERTS A XEF CON SEQUENCE*/
INSERT INTO XEFS VALUES (ID_XEF_SEQ.NEXTVAL, 'Antone', 3); 
INSERT INTO XEFS VALUES (ID_XEF_SEQ.NEXTVAL, 'Maria', 4); 
INSERT INTO XEFS VALUES (ID_XEF_SEQ.NEXTVAL, 'Juan', 5); 
INSERT INTO XEFS VALUES (ID_XEF_SEQ.NEXTVAL, 'Pedro', 2);
INSERT INTO XEFS VALUES (ID_XEF_SEQ.NEXTVAL, 'Jordi', 5);
INSERT INTO XEFS VALUES (ID_XEF_SEQ.NEXTVAL, 'David', 2);
INSERT INTO XEFS VALUES (ID_XEF_SEQ.NEXTVAL, 'Marc', 3);

/*INICIO INSERTS DE USUARIO*/
INSERT INTO USUARIS VALUES (1, 'Pere', 'PERE@HOTMAIL.COM','12345678');
INSERT INTO USUARIS VALUES (2, 'Marcela', 'MARCELA@HOTMAIL.COM', '23456789');
INSERT INTO USUARIS VALUES (3, 'Franca','FRANCA@HOTMAIL.COM', '34567890');
INSERT INTO USUARIS VALUES (4, 'Ali', 'ALI@HOTMAIL.COM', '45678901');
INSERT INTO USUARIS VALUES (5, 'John','JOHN@HOTMAIL.COM', '5678901');
INSERT INTO USUARIS VALUES (6, 'Alan', 'ALAN@HOTMAIL.COM','332678');
INSERT INTO USUARIS VALUES (7, 'Davex', 'DAVEX@HOTMAIL.COM', '32424678');
INSERT INTO USUARIS VALUES (8, 'Carlos', 'CARLOS@HOTMAIL.COM', '234252');

/*INICIO RECEPTAS DE USUARIO*/
INSERT INTO RECEPTAS VALUES (1, 'Omelet', 100, 4, 'huevos', 2, 'dificil', 1, NULL);
INSERT INTO RECEPTAS VALUES (2, 'Guisado', 400, 2, 'Carnes', 3, 'dificil', 1, NULL);
INSERT INTO RECEPTAS VALUES (3, 'Paella', 500, 4, 'Arroces', 45, 'intermig', 2, NULL);
INSERT INTO RECEPTAS VALUES (4, 'Carne Tierna', 400, 3, 'Carnes', 24, 'facil', 3, NULL);
INSERT INTO RECEPTAS VALUES (5, 'Sopa Tomate', 150, 4, 'Sopas', 6, 'intermig', 4, NULL);
INSERT INTO RECEPTAS VALUES (6, 'Crepes', 270, 4, 'Postres', 6, 'intermig', 4, NULL);
INSERT INTO RECEPTAS VALUES (7, 'Carne Porcina Especial', 300, 4, 'Carnes', 5, 'facil', 1, NULL);
INSERT INTO RECEPTAS VALUES (8, 'Asado', 400, 3, 'Carnes', 6, 'dificil', 1, NULL);
INSERT INTO RECEPTAS VALUES (9, 'Helado', 330, 4, 'Postres', 123, 'dificil', 2, NULL);
INSERT INTO RECEPTAS VALUES (10, 'Croquetas de pollo', 330, 4, 'Carnes', 15, 'facil', 6, NULL);
INSERT INTO RECEPTAS VALUES (11, 'pollo al curry', 250, 4, 'Carnes', 10, 'intermig', 4, NULL);
INSERT INTO RECEPTAS VALUES (12, 'Lasaña de berenjena', 150, 2, 'Carnes', 30, 'intermig', 3, NULL);
INSERT INTO RECEPTAS VALUES (13, 'Trufas de cava y frambuesa', 110, 1, 'Postres', 5, 'facil', 5, NULL);
INSERT INTO RECEPTAS VALUES (14, 'Cakes expres', 250, 1, 'Postres', 3, 'facil', 7, NULL);
INSERT INTO RECEPTAS VALUES (15, 'Flan de turrón', 50, 1, 'Postres', 1, 'intermig', 5, NULL);
INSERT INTO RECEPTAS VALUES (16, 'sandwich porc', 400, 4, 'Carnes', 18, 'intermig', 6, NULL);
INSERT INTO RECEPTAS VALUES (17, 'arroz tres carnes', 600, 6,'Carnes', 25, 'dificil',2, NULL);
INSERT INTO RECEPTAS VALUES (18,'ternera al curry', 800, 3,'Carnes', 25, 'facil', 3, NULL);

/*INICIO VALORACIONES DE USUARIOS*/
INSERT INTO VALORACIONS VALUES (1, 1, 4, 'Me parece aceptable.');
INSERT INTO VALORACIONS VALUES (1, 2, 2, 'No es muy buena.');
INSERT INTO VALORACIONS VALUES (2, 1, 4, 'Delicioso.');
INSERT INTO VALORACIONS VALUES (2, 3, 5, null);
INSERT INTO VALORACIONS VALUES (4, 4, 5, 'Muy delicioso.');
INSERT INTO VALORACIONS VALUES (5, 4, 5, 'Muy buena.');
INSERT INTO VALORACIONS VALUES (3, 8, 3, null);

/*INICIO TABLA ENTRE RECEPTA INGREDIENT*/
INSERT INTO CONSTAN VALUES (1, 2, 200, 'gr');
INSERT INTO CONSTAN VALUES (1, 3, 100, 'ml');
INSERT INTO CONSTAN VALUES (2, 4, 50, 'gr');
INSERT INTO CONSTAN VALUES (2, 1, 70, 'gr');
INSERT INTO CONSTAN VALUES (3, 6, 100, 'ml');
INSERT INTO CONSTAN VALUES (3, 1, 150, 'ml');
INSERT INTO CONSTAN VALUES (5, 1, 200, 'gr');
INSERT INTO CONSTAN VALUES (5, 3, 100, 'gr');
INSERT INTO CONSTAN VALUES (6, 3, 50, 'ml');
INSERT INTO CONSTAN VALUES (6, 2, 100, 'gr');
INSERT INTO CONSTAN VALUES (4, 4, 10, 'gr');
INSERT INTO CONSTAN VALUES (4, 3, 100, 'gr');
INSERT INTO CONSTAN VALUES (7, 7, 200, 'gr');
INSERT INTO CONSTAN VALUES (8, 4, 400, 'gr');
INSERT INTO CONSTAN VALUES (8, 1, 100, 'gr');
INSERT INTO CONSTAN VALUES (7, 1, 50, 'gr');
INSERT INTO CONSTAN VALUES (9, 14, 1, 'unidad');
INSERT INTO CONSTAN VALUES (9, 11, 500, 'ml');
INSERT INTO CONSTAN VALUES (9, 12, 200, 'gr');
INSERT INTO CONSTAN VALUES (3, 8, 500, 'gr');
INSERT INTO CONSTAN VALUES (16, 7, 400, 'gr');
INSERT INTO CONSTAN VALUES (17, 7,	650, 'gr');
INSERT INTO CONSTAN VALUES (18, 1, 5, 'unidad');
INSERT INTO CONSTAN VALUES (18, 16, 1, 'unidad');
INSERT INTO CONSTAN VALUES (18, 4, 600, 'gr');

/*INICIO TABLAS ENTRE PRESENTEN I ALERGENS*/
INSERT INTO PRESENTEN VALUES (9, 1);
INSERT INTO PRESENTEN VALUES (6, 6);
INSERT INTO PRESENTEN VALUES (1, 2);
INSERT INTO PRESENTEN VALUES (4, 1);
INSERT INTO PRESENTEN VALUES (2, 5);

/*EVENTOS DE LA BASE MASTERCHEF*/
INSERT INTO ESDEVENIMENTS VALUES (1,'MasterChef Espanya 2020', 'Barcelona', '12-MAY-2020', 25, 'concurs', null, 'intermig');
INSERT INTO ESDEVENIMENTS VALUES (2,'MasterChef Espanya 2021', 'Madrid', '01-JAN-2021', 55, 'concurs', null, 'professional');
INSERT INTO ESDEVENIMENTS VALUES (3,'MasterChef Espanya 2018', 'Valencia', '05-JUN-2018', 50, 'concurs', null, 'principiant');
INSERT INTO ESDEVENIMENTS VALUES (4,'Les Grands Buffets', 'Francia', '08-OCT-2019', 5, 'show cooking', 'si', null);
INSERT INTO ESDEVENIMENTS VALUES (5,'MasterChef Show cooking 2020', 'Barceloneta', '12-DEC-2020', 10, 'show cooking', 'no', null);
INSERT INTO ESDEVENIMENTS VALUES (6,'MasterChef Show cooking Especial', 'Murcia', '30-NOV-2020', 20, 'show cooking', 'si', null);

/*INICIO INSCRITS A EVENTOS*/
INSERT INTO INSCRITS VALUES (6, 1, '25-MAY-2020');
INSERT INTO INSCRITS VALUES (7, 3, '12-FEB-2018');
INSERT INTO INSCRITS VALUES (5, 4, '03-AUG-2019'); 
INSERT INTO INSCRITS VALUES (8, 5, '19-JUL-2020'); 
INSERT INTO INSCRITS VALUES (2, 2, '22-SEP-2020');
INSERT INTO INSCRITS VALUES (8, 6, '22-JUN-2019'); 
INSERT INTO INSCRITS VALUES (1, 6, '16-OCT-2019'); 
INSERT INTO INSCRITS VALUES (3, 6, '03-AUG-2020'); 
INSERT INTO INSCRITS VALUES (4, 4, '22-SEP-2019'); 

/*SESIONES SHOW COOKING*/
INSERT INTO SESSIONS VALUES (1, 'mati', 25, 4);
INSERT INTO SESSIONS VALUES (2, 'tarda', 240, 5);
INSERT INTO SESSIONS VALUES (3, 'mati', 60, 6);

/*INSERTS XEFS PARTICIPAN EVENTOS*/
INSERT INTO PARTICIPAN VALUES (7, 1, 2500);
INSERT INTO PARTICIPAN VALUES (4, 3, 4500);
INSERT INTO PARTICIPAN VALUES (3, 2, 6000);
INSERT INTO PARTICIPAN VALUES (1, 4, 1240);
INSERT INTO PARTICIPAN VALUES (2, 5, 4240);
INSERT INTO PARTICIPAN VALUES (5, 6, 5500);

/*INSERTS XEFS USUARIOS QUE CONCURAN EN EVENTOS*/
INSERT INTO CONCURSAN VALUES (7, 6, 1, 5);
INSERT INTO CONCURSAN VALUES (4, 7, 3, 10);
INSERT INTO CONCURSAN VALUES (3, 2, 2, 7);