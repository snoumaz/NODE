-- CREACIÓN DE LA BASE DE DATOS
-- Eliminamos base de datos 'Facultad' si existe
DROP DATABASE IF EXISTS Facultad;
-- Creamos base de datos 'Facultad'
CREATE DATABASE Facultad;
-- Designamos 'Facultad' como base de datos actual, a la que se hará referencia en el resto del código
USE Facultad;

-- CREACIÓN DE LAS TABLAS
/* Borramos las tablas si existen.
Esto no es totalmente necesario ya que anteriormente se eliminó y creó de nuevo la base de datos.
Por lo tanto, las tablas también quedaron eliminadas*/
DROP TABLE IF EXISTS curso;

DROP TABLE IF EXISTS profesor;

DROP TABLE IF EXISTS tlfContactoProf;

DROP TABLE IF EXISTS asignatura;

DROP TABLE IF EXISTS alumno;

DROP TABLE IF EXISTS matricula;

DROP TABLE IF EXISTS impartir;
-- Creación de tablas
CREATE TABLE curso (
    idCurso numeric(2),
    nombreDescriptivo text(10) NOT NULL,
    nAsignaturas numeric(3) NOT NULL,
    PRIMARY KEY (idCurso)
);

CREATE TABLE profesor (
    idProfesor char(5),
    NIF char(9) UNIQUE,
    nombre varchar(50) NOT NULL,
    apellido1 varchar(50) NOT NULL,
    apellido2 varchar(50),
    email varchar(50) UNIQUE,
    direccion varchar(100) NOT NULL,
    codigoPostal numeric(5) NOT NULL,
    municipio text(50) NOT NULL,
    provincia text(50) NOT NULL,
    categoria enum(
        'Catedráticos de Universidad',
        'Titulares Universidad',
        'Catedráticos de Escuela Universitaria',
        'Titulares de Escuela Universitaria',
        'Eméritos',
        'Contratados Doctores',
        'Contratados Doctores Interinos',
        'Asociados',
        'Asociado Interino',
        'Ayudantes Doctores',
        'Otros Investigadores Doctores',
        'PDI predoctoral'
    ),
    PRIMARY KEY (idProfesor)
);

CREATE TABLE tlfContactoProf (
    idProfesor char(5) NOT NULL,
    telefono numeric(9) NOT NULL,
    FOREIGN KEY (idProfesor) REFERENCES profesor (idProfesor) ON DELETE CASCADE -- Eliminando un profesor se eliminarán automáticamente sus teléfonos de contacto
);

CREATE TABLE asignatura (
    curso numeric(2) NOT NULL,
    idAsignatura char(5) NOT NULL,
    nombre varchar(150) UNIQUE,
    cuatrimestre enum('1', '2'),
    creditos real NOT NULL,
    caracter enum('obligatoria', 'optativa') NOT NULL,
    coordinador char(5) NOT NULL,
    PRIMARY KEY (idAsignatura),
    FOREIGN KEY (curso) REFERENCES curso (idCurso),
    FOREIGN KEY (coordinador) REFERENCES profesor (idProfesor)
);

CREATE TABLE alumno (
    idAlumno char(5) NOT NULL,
    NIF char(9) UNIQUE, -- NIF es una cadena de caracteres de longitud fija de 9 y un valor único
    nombre text(50) NOT NULL,
    apellido1 text(50) NOT NULL,
    apellido2 text(50),
    email varchar(50) UNIQUE,
    direccion varchar(100) NOT NULL,
    codigoPostal numeric(5) NOT NULL,
    municipio text(50) NOT NULL,
    provincia text(50) NOT NULL,
    PRIMARY KEY (idAlumno)
);

CREATE TABLE matricula (
    idAlumno char(5) NOT NULL,
    idAsignatura char(5) NOT NULL,
    nota real NOT NULL,
    FOREIGN KEY (idAlumno) REFERENCES alumno (idAlumno),
    FOREIGN KEY (idAsignatura) REFERENCES asignatura (idAsignatura),
    CHECK (nota > 0)
);

CREATE TABLE impartir (
    idProfesor char(5) NOT NULL,
    idAsignatura char(5) NOT NULL,
    FOREIGN KEY (idProfesor) REFERENCES profesor (idProfesor),
    FOREIGN KEY (idAsignatura) REFERENCES asignatura (idAsignatura)
);

-- Olvidé incluir el campo beca en alumno. Lo incluiremos con alter table
ALTER TABLE alumno ADD beca char(2) NOT NULL;

-- CARGA DE DATOS
/*Carga con inserción manual datos curso. Únicamente introduciremos los datos de idCurso y nombreDescriptivo
ya que  nASignaturas depende del sumatorio de las asignaturas pertenecientes a otra tabla */
INSERT INTO curso VALUES (1, 'Primero', 10);

INSERT INTO curso VALUES (2, 'Segundo', 10);

INSERT INTO curso VALUES (3, 'Terceo', 10);

INSERT INTO curso VALUES (4, 'Cuarto', 53);

INSERT INTO curso VALUES (5, 'Master', 11);

INSERT INTO curso VALUES (6, 'Doctorado', 6);

-- Solicitamos el directorio donde donde alojar los archivos que querramos importar
SELECT @@GLOBAL.secure_file_priv;

/*Importamos el archivo alumnos.txt en la tabla alumno estableciendo ";" como separador
entre campos y "\n", significa salto de linea, para definir que cada
registro acaba al haber salto de linea*/
LOAD DATA INFILE '/usr/src/app/sql/alumnos.txt' INTO
TABLE alumno FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- Carga con inserción manual de datos profesor
INSERT INTO
    profesor
VALUES (
        'PR001',
        '34417139B',
        'Juan',
        'Infante',
        'Fraidias',
        'juan.infante.fraidias@ucm.com',
        'Calle de los Almendros , 86',
        28070,
        'Las Rozas',
        'Madrid',
        'Asociados'
    );

INSERT INTO
    profesor
VALUES (
        'PR002',
        '52479077P',
        'David',
        'Serna',
        'Balmori',
        'david.serna.balmori@ucm.com',
        'Calle Abarejo , 44',
        28017,
        'Brea de Tajo',
        'Madrid',
        'Titulares Universidad'
    );

INSERT INTO
    profesor
VALUES (
        'PR003',
        '84277383X',
        'Josefa',
        'Pedraza',
        'Travez',
        'josefa.pedraza.travez@ucm.com',
        'Calle Abogados de Atocha , 145',
        28035,
        'El Molar',
        'Madrid',
        'Contratados Doctores'
    );

INSERT INTO
    profesor
VALUES (
        'PR004',
        '72702217A',
        'Jose Antonio',
        'Belda',
        'Leno',
        'jose.antonio.belda.leno@ucm.com',
        'Calle de Ayamonte , 186',
        28080,
        'Pezuela de las Torres',
        'Madrid',
        'Titulares Universidad'
    );

INSERT INTO
    profesor
VALUES (
        'PR005',
        '75239553F',
        'Jose Luis',
        'Barragan',
        'Usategui',
        'jose.luis.barragan.usategui@ucm.com',
        'Travesia del Almendro , 97',
        28038,
        'Robledillo de la Jara',
        'Madrid',
        'Catedráticos de Escuela Universitaria'
    );

INSERT INTO
    profesor
VALUES (
        'PR006',
        '81953461Y',
        'Francisco Javier',
        'Reig',
        'Amills',
        'francisco.javier.reig.amills@ucm.com',
        'Calle de la Albericia , 134',
        28071,
        'Colmenarejo',
        'Madrid',
        'Contratados Doctores Interinos'
    );

INSERT INTO
    profesor
VALUES (
        'PR007',
        '18598553N',
        'Ana Maria',
        'De Diego',
        'Bocigas',
        'ana.maria.de.diego.bocigas@ucm.com',
        'Avenida de los Andes , 188',
        28030,
        'Prádena del Rincón',
        'Madrid',
        'PDI predoctoral'
    );

INSERT INTO
    profesor
VALUES (
        'PR008',
        '72252271H',
        'Carlos',
        'Fuertes',
        'Carulla',
        'carlos.fuertes.carulla@ucm.com',
        'Calle Águeda , 26',
        28046,
        'Velilla de San Antonio',
        'Madrid',
        'Catedráticos de Escuela Universitaria'
    );

INSERT INTO
    profesor
VALUES (
        'PR009',
        '70631063C',
        'Daniel',
        'Aguado',
        'Pastrana',
        'daniel.aguado.pastrana@ucm.com',
        'Calle de Antoñita Jiménez , 122',
        28041,
        'Talamanca de Jarama',
        'Madrid',
        'Catedráticos de Universidad'
    );

INSERT INTO
    profesor
VALUES (
        'PR010',
        '15794042W',
        'Maria Dolores',
        'Espino',
        'Zamudio',
        'maria.dolores.espino.zamudio@ucm.com',
        'Calle del Arroyo de la Elipa , 189',
        28034,
        'San Martín de la Vega',
        'Madrid',
        'Titulares Universidad'
    );

INSERT INTO
    profesor
VALUES (
        'PR011',
        '86245635W',
        'Maria Pilar',
        'Valderrama',
        'Urquiaga',
        'maria.pilar.valderrama.urquiaga@ucm.com',
        'Calle Alisios , 150',
        28006,
        'Chapinería',
        'Madrid',
        'Catedráticos de Escuela Universitaria'
    );

INSERT INTO
    profesor
VALUES (
        'PR012',
        '83153833C',
        'Miguel',
        'Fuentes',
        'Andreu',
        'miguel.fuentes.andreu@ucm.com',
        'Calle de la Alcoholera , 12',
        28080,
        'Pozuelo del Rey',
        'Madrid',
        'Contratados Doctores Interinos'
    );

INSERT INTO
    profesor
VALUES (
        'PR013',
        '55710808P',
        'Maria Teresa',
        'Pico',
        'Zoyo',
        'maria.teresa.pico.zoyo@ucm.com',
        'Calle de Arenas de Iguña , 17',
        28080,
        'Algete',
        'Madrid',
        'Ayudantes Doctores'
    );

INSERT INTO
    profesor
VALUES (
        'PR014',
        '52041463T',
        'Ana',
        'Andujar',
        'Popovici',
        'ana.andujar.popovici@ucm.com',
        'Calle de las Aguas , 61',
        28035,
        'Cabanillas de la Sierra',
        'Madrid',
        'Otros Investigadores Doctores'
    );

INSERT INTO
    profesor
VALUES (
        'PR015',
        '81703794T',
        'Rafael',
        'Murcia',
        'Petrov',
        'rafael.murcia.petrov@ucm.com',
        'Calle Almendro , 53',
        28012,
        'Tielmes',
        'Madrid',
        'PDI predoctoral'
    );

INSERT INTO
    profesor
VALUES (
        'PR016',
        '36742399V',
        'Jose Manuel',
        'Antolin',
        'Diranzo',
        'jose.manuel.antolin.diranzo@ucm.com',
        'Calle Azabache , 190',
        28012,
        'Piñuécar-Gandullas',
        'Madrid',
        'Catedráticos de Universidad'
    );

INSERT INTO
    profesor
VALUES (
        'PR017',
        '33150418J',
        'Pedro',
        'Calderon',
        'Domenech',
        'pedro.calderon.domenech@ucm.com',
        'Carretera de Alpedrete , 104',
        28008,
        'Ciempozuelos',
        'Madrid',
        'Contratados Doctores'
    );

INSERT INTO
    profesor
VALUES (
        'PR018',
        '82285639Q',
        'Laura',
        'Bueno',
        'Sobreira',
        'laura.bueno.sobreira@ucm.com',
        'Calle de los Árboles , 198',
        28039,
        'Cabanillas de la Sierra',
        'Madrid',
        'Catedráticos de Escuela Universitaria'
    );

INSERT INTO
    profesor
VALUES (
        'PR019',
        '37497894I',
        'Francisca',
        'Smith',
        'Mafla',
        'francisca.smith.mafla@ucm.com',
        'Calle del Arco , 149',
        28029,
        'Moralzarzal',
        'Madrid',
        'Otros Investigadores Doctores'
    );

INSERT INTO
    profesor
VALUES (
        'PR020',
        '34744580Y',
        'Antonia',
        'Vara',
        'Esarte',
        'antonia.vara.esarte@ucm.com',
        'Calle de Alba de Tormes , 123',
        28030,
        'Valdemoro',
        'Madrid',
        'Contratados Doctores'
    );

INSERT INTO
    profesor
VALUES (
        'PR021',
        '25542059S',
        'Alejandro',
        'Piã‘A',
        'Ivars',
        'alejandro.piã‘a.ivars@ucm.com',
        'Calle Alfonso X El Sabio , 199',
        28008,
        'Colmenar de Oreja',
        'Madrid',
        'Catedráticos de Escuela Universitaria'
    );

INSERT INTO
    profesor
VALUES (
        'PR022',
        '71976482V',
        'Dolores',
        'Amoros',
        'Cases',
        'dolores.amoros.cases@ucm.com',
        'Calle de las Acacias , 109',
        28048,
        'Manzanares el Real',
        'Madrid',
        'Catedráticos de Universidad'
    );

INSERT INTO
    profesor
VALUES (
        'PR023',
        '76471428I',
        'Antonio',
        'Quero',
        'Atienza',
        'antonio.quero.atienza@ucm.com',
        'Vereda de las Arboledas , 89',
        28015,
        'Sevilla la Nueva',
        'Madrid',
        'Catedráticos de Universidad'
    );

INSERT INTO
    profesor
VALUES (
        'PR024',
        '57354131X',
        'Jose',
        'Valera',
        'Bardal',
        'jose.valera.bardal@ucm.com',
        'Calle de la Alegría , 82',
        28034,
        'Villa del Prado',
        'Madrid',
        'Titulares Universidad'
    );

INSERT INTO
    profesor
VALUES (
        'PR025',
        '21841380T',
        'Maria Carmen',
        'Palacios',
        'Cholvi',
        'maria.carmen.palacios.cholvi@ucm.com',
        'Calle Apolo , 32',
        28083,
        'Meco',
        'Madrid',
        'Otros Investigadores Doctores'
    );

INSERT INTO
    profesor
VALUES (
        'PR026',
        '86751787V',
        'Maria',
        'Lucena',
        'Nebra',
        'maria.lucena.nebra@ucm.com',
        'Calle Arroyo de los Berros , 31',
        28046,
        'Moraleja de Enmedio',
        'Madrid',
        'Catedráticos de Escuela Universitaria'
    );

INSERT INTO
    profesor
VALUES (
        'PR027',
        '35634129C',
        'Manuel',
        'Falcon',
        'Zendoia',
        'manuel.falcon.zendoia@ucm.com',
        'Calle de Aguileñas , 65',
        28041,
        'Mejorada del Campo',
        'Madrid',
        'Titulares de Escuela Universitaria'
    );

INSERT INTO
    profesor
VALUES (
        'PR028',
        '67157773L',
        'Francisco',
        'Cid',
        'Lubiano',
        'francisco.cid.lubiano@ucm.com',
        'Travesia Antón , 55',
        28045,
        'Madrid',
        'Madrid',
        'Asociado Interino'
    );

INSERT INTO
    profesor
VALUES (
        'PR029',
        '34163047Q',
        'Carmen',
        'Pino',
        'Holgueras',
        'carmen.pino.holgueras@ucm.com',
        'Calle de Alcalá de Guadaira , 170',
        28048,
        'Rozas de Puerto Real',
        'Madrid',
        'Titulares de Escuela Universitaria'
    );

INSERT INTO
    profesor
VALUES (
        'PR030',
        '78969666B',
        'Juan',
        'Perera',
        'Chao',
        'juan.perera.chao@ucm.com',
        'Calle del Arroyo , 34',
        28009,
        'Pinilla del Valle',
        'Madrid',
        'Asociados'
    );

INSERT INTO
    profesor
VALUES (
        'PR031',
        '15480959Q',
        'David',
        'Galindo',
        'Chirila',
        'david.galindo.chirila@ucm.com',
        'Calle de Asunción Cuestablanca , 40',
        28040,
        'La Cabrera',
        'Madrid',
        'Asociado Interino'
    );

INSERT INTO
    profesor
VALUES (
        'PR032',
        '76367475V',
        'Josefa',
        'Villena',
        'Hombrados',
        'josefa.villena.hombrados@ucm.com',
        'Calle de Alonso de Mendoza , 161',
        28043,
        'Boadilla del Monte',
        'Madrid',
        'PDI predoctoral'
    );

INSERT INTO
    profesor
VALUES (
        'PR033',
        '64389449W',
        'Jose Antonio',
        'Bonilla',
        'Abello',
        'jose.antonio.bonilla.abello@ucm.com',
        'Calle de Albalate del Arzobispo , 51',
        28016,
        'Navalafuente',
        'Madrid',
        'Ayudantes Doctores'
    );

INSERT INTO
    profesor
VALUES (
        'PR034',
        '47783567D',
        'Jose Luis',
        'Yague',
        'Liern',
        'jose.luis.yague.liern@ucm.com',
        'Calle Atocha , 133',
        28023,
        'Puebla de la Sierra',
        'Madrid',
        'Ayudantes Doctores'
    );

INSERT INTO
    profesor
VALUES (
        'PR035',
        '13616538V',
        'Javier',
        'Exposito',
        'Orejuela',
        'javier.exposito.orejuela@ucm.com',
        'Calle los Acebos , 138',
        28086,
        'Valdemaqueda',
        'Madrid',
        'Titulares Universidad'
    );

INSERT INTO
    profesor
VALUES (
        'PR036',
        '78722469N',
        'Isabel',
        'Chaves',
        'Cantisano',
        'isabel.chaves.cantisano@ucm.com',
        'Calle de Alcudia , 14',
        28006,
        'San Fernando de Henares',
        'Madrid',
        'Catedráticos de Escuela Universitaria'
    );

INSERT INTO
    profesor
VALUES (
        'PR037',
        '45405804R',
        'Jesus',
        'Cerezo',
        'Esquer',
        'jesus.cerezo.esquer@ucm.com',
        'Calle Armonía , 61',
        28087,
        'Robledo de Chavela',
        'Madrid',
        'Contratados Doctores'
    );

INSERT INTO
    profesor
VALUES (
        'PR038',
        '25187565W',
        'Francisco Javier',
        'Aguilera',
        'Pavlova',
        'francisco.javier.aguilera.pavlova@ucm.com',
        'Calle Acacia , 53',
        28014,
        'Boadilla del Monte',
        'Madrid',
        'Catedráticos de Universidad'
    );

INSERT INTO
    profesor
VALUES (
        'PR039',
        '19655057F',
        'Ana Maria',
        'Guillen',
        'Bembibre',
        'ana.maria.guillen.bembibre@ucm.com',
        'Pasaje Almendro del Paular , 167',
        28071,
        'Puentes Viejas',
        'Madrid',
        'Catedráticos de Universidad'
    );

INSERT INTO
    profesor
VALUES (
        'PR040',
        '29987297T',
        'Carlos',
        'De Las Heras',
        'Orrego',
        'carlos.de.las.heras.orrego@ucm.com',
        'Calle del Alcalde Ramón del Yerro Ordóñez , 135',
        28011,
        'El Molar',
        'Madrid',
        'Eméritos'
    );

INSERT INTO
    profesor
VALUES (
        'PR041',
        '22835810F',
        'Daniel',
        'De La Rosa',
        'Gaudes',
        'daniel.de.la.rosa.gaudes@ucm.com',
        'Calle del Alcalde Pablo Durán y Pérez de Castro , 2',
        28050,
        'Fuentidueña de Tajo',
        'Madrid',
        'Ayudantes Doctores'
    );

INSERT INTO
    profesor
VALUES (
        'PR042',
        '63215069W',
        'Maria Dolores',
        'Casanova',
        'Ocasar',
        'maria.dolores.casanova.ocasar@ucm.com',
        'Calle de las Arenas , 161',
        28083,
        'Braojos de la Sierra',
        'Madrid',
        'Contratados Doctores Interinos'
    );

INSERT INTO
    profesor
VALUES (
        'PR043',
        '83480230A',
        'Maria Pilar',
        'Bejarano',
        'De La Piedad',
        'maria.pilar.bejarano.de.la.piedad@ucm.com',
        'Calle Aldea del Fresno , 105',
        28071,
        'Coslada',
        'Madrid',
        'Contratados Doctores Interinos'
    );

INSERT INTO
    profesor
VALUES (
        'PR044',
        '19206079I',
        'Miguel',
        'Silva',
        'Rose',
        'miguel.silva.rose@ucm.com',
        'Calle de Asunción , 173',
        28049,
        'Bustarviejo',
        'Madrid',
        'Asociado Interino'
    );

INSERT INTO
    profesor
VALUES (
        'PR045',
        '66989687K',
        'Maria Teresa',
        'Valderrama',
        'Ruperez',
        'maria.teresa.valderrama.ruperez@ucm.com',
        'Plaza de Antonio Chenel Antoñete , 152',
        28014,
        'Lozoyuela-Navas-Sieteiglesias',
        'Madrid',
        'Titulares Universidad'
    );

INSERT INTO
    profesor
VALUES (
        'PR046',
        '47970524A',
        'Ana',
        'Padron',
        'Balada',
        'ana.padron.balada@ucm.com',
        'Calle de Argentona , 179',
        28002,
        'Boadilla del Monte',
        'Madrid',
        'Titulares Universidad'
    );

INSERT INTO
    profesor
VALUES (
        'PR047',
        '76965754O',
        'Rafael',
        'Figueroa',
        'Casal',
        'rafael.figueroa.casal@ucm.com',
        'Calle de la Aeronave , 37',
        28004,
        'Colmenarejo',
        'Madrid',
        'PDI predoctoral'
    );

INSERT INTO
    profesor
VALUES (
        'PR048',
        '48034341Q',
        'Jose Manuel',
        'Nevado',
        'Veras',
        'jose.manuel.nevado.veras@ucm.com',
        'Calle Arlanza , 170',
        28001,
        'Ajalvir',
        'Madrid',
        'Catedráticos de Universidad'
    );

-- Importamos los teléfonos de contacto de profesores como archivo .CSV
LOAD DATA INFILE '/usr/src/app/sql/telefonosContacto.csv' INTO
TABLE tlfContactoProf FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- Carga con inserción manual de datos asignatura
INSERT INTO
    asignatura
VALUES (
        1,
        'AS001',
        'Algebra lineal',
        '2',
        6,
        'obligatoria',
        'PR001'
    );

INSERT INTO
    asignatura
VALUES (
        1,
        'AS002',
        'Análisis exploratorio de datos',
        '1',
        6,
        'obligatoria',
        'PR002'
    );

INSERT INTO
    asignatura
VALUES (
        1,
        'AS003',
        'Análisis matemático',
        '1',
        6,
        'obligatoria',
        'PR003'
    );

INSERT INTO
    asignatura
VALUES (
        1,
        'AS004',
        'Fundamentos de computadores y sistemas operativos',
        '2',
        6,
        'obligatoria',
        'PR004'
    );

INSERT INTO
    asignatura
VALUES (
        1,
        'AS005',
        'Fundamentos de organización de empresas',
        '1',
        6,
        'obligatoria',
        'PR005'
    );

INSERT INTO
    asignatura
VALUES (
        1,
        'AS006',
        'Fundamentos de programación',
        '1',
        6,
        'obligatoria',
        'PR004'
    );

INSERT INTO
    asignatura
VALUES (
        1,
        'AS007',
        'Matemáticas discretas',
        '1',
        6,
        'obligatoria',
        'PR003'
    );

INSERT INTO
    asignatura
VALUES (
        1,
        'AS008',
        'Modelos estadísticos para la toma de decisiones I',
        '2',
        6,
        'obligatoria',
        'PR008'
    );

INSERT INTO
    asignatura
VALUES (
        1,
        'AS009',
        'Programación',
        '2',
        6,
        'obligatoria',
        'PR004'
    );

INSERT INTO
    asignatura
VALUES (
        1,
        'AS010',
        'Proyecto I. Comprensión de datos',
        '2',
        6,
        'obligatoria',
        'PR002'
    );

INSERT INTO
    asignatura
VALUES (
        2,
        'AS011',
        'Adquisición y transmisión de datos',
        '1',
        6,
        'obligatoria',
        'PR004'
    );

INSERT INTO
    asignatura
VALUES (
        2,
        'AS012',
        'Bases de datos',
        '1',
        6,
        'obligatoria',
        'PR002'
    );

INSERT INTO
    asignatura
VALUES (
        2,
        'AS013',
        'Comportamiento económico y social',
        '1',
        6,
        'obligatoria',
        'PR006'
    );

INSERT INTO
    asignatura
VALUES (
        2,
        'AS014',
        'Estructuras de datos',
        '1',
        6,
        'obligatoria',
        'PR002'
    );

INSERT INTO
    asignatura
VALUES (
        2,
        'AS015',
        'Gestión de datos',
        '2',
        6,
        'obligatoria',
        'PR002'
    );

INSERT INTO
    asignatura
VALUES (
        2,
        'AS016',
        'Modelado discreto y teoría de la información',
        '2',
        6,
        'obligatoria',
        'PR007'
    );

INSERT INTO
    asignatura
VALUES (
        2,
        'AS017',
        'Modelos descriptivos y predictivos I',
        '2',
        6,
        'obligatoria',
        'PR008'
    );

INSERT INTO
    asignatura
VALUES (
        2,
        'AS018',
        'Modelos estadísticos para la toma de decisiones II',
        '1',
        6,
        'obligatoria',
        'PR008'
    );

INSERT INTO
    asignatura
VALUES (
        2,
        'AS019',
        'Proyecto II. Integración y preparación de datos',
        '2',
        6,
        'obligatoria',
        'PR009'
    );

INSERT INTO
    asignatura
VALUES (
        2,
        'AS020',
        'Seguridad de los datos',
        '2',
        6,
        'obligatoria',
        'PR004'
    );

INSERT INTO
    asignatura
VALUES (
        3,
        'AS021',
        'Algorítmica',
        '2',
        6,
        'obligatoria',
        'PR001'
    );

INSERT INTO
    asignatura
VALUES (
        3,
        'AS022',
        'Economía digital',
        '1',
        6,
        'obligatoria',
        'PR006'
    );

INSERT INTO
    asignatura
VALUES (
        3,
        'AS023',
        'Evaluación',
        '2',
        6,
        'obligatoria',
        'PR007'
    );

INSERT INTO
    asignatura
VALUES (
        3,
        'AS024',
        'Infraestrutura para el procesamiento de datos',
        '1',
        6,
        'obligatoria',
        'PR009'
    );

INSERT INTO
    asignatura
VALUES (
        3,
        'AS025',
        'Lenguaje natural y recuperación de la información',
        '2',
        6,
        'obligatoria',
        'PR009'
    );

INSERT INTO
    asignatura
VALUES (
        3,
        'AS026',
        'Modelado y simulación continuos',
        '2',
        6,
        'obligatoria',
        'PR010'
    );

INSERT INTO
    asignatura
VALUES (
        3,
        'AS027',
        'Modelos descriptivos y predictivos II',
        '1',
        6,
        'obligatoria',
        'PR008'
    );

INSERT INTO
    asignatura
VALUES (
        3,
        'AS028',
        'Proyecto III. Analisis de datos',
        '2',
        6,
        'obligatoria',
        'PR010'
    );

INSERT INTO
    asignatura
VALUES (
        3,
        'AS029',
        'Representación del conocimiento y razonamiento',
        '1',
        6,
        'obligatoria',
        'PR011'
    );

INSERT INTO
    asignatura
VALUES (
        3,
        'AS030',
        'Visualización',
        '1',
        6,
        'obligatoria',
        'PR010'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS031',
        'Gestión de proyectos',
        '1',
        5,
        'obligatoria',
        'PR005'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS032',
        'Marco profesional',
        '1',
        5,
        'obligatoria',
        'PR006'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS033',
        'Optimización',
        '1',
        6,
        'obligatoria',
        'PR015'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS034',
        'Técnicas escalables en aprendizaje automático',
        '1',
        6,
        'obligatoria',
        'PR024'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS035',
        'Trabajo Fin de Grado',
        '2',
        12,
        'obligatoria',
        'PR036'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS036',
        'Alemán académico y profesional A1',
        '1',
        5,
        'optativa',
        'PR020'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS037',
        'Alemán académico y profesional A2',
        '2',
        5,
        'optativa',
        'PR020'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS038',
        'Alemán académico y profesional B1',
        '1',
        5,
        'optativa',
        'PR020'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS039',
        'Alemán académico y profesional B2',
        '2',
        5,
        'optativa',
        'PR020'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS040',
        'Análisis de datos en entornos industriales',
        '1',
        5,
        'optativa',
        'PR002'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS041',
        'Análisis de imágenes y vídeos',
        '1',
        5,
        'optativa',
        'PR021'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS042',
        'Análisis de mercados y aplicaciones financieras',
        '1',
        5,
        'optativa',
        'PR005'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS043',
        'Análisis de redes sociales',
        '1',
        5,
        'optativa',
        'PR002'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS044',
        'Analítica de datos en educació',
        '1',
        5,
        'optativa',
        'PR002'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS045',
        'Analítica de datos en seguridad',
        '1',
        5,
        'optativa',
        'PR002'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS046',
        'Bases de datos avanzadas y distribuidas',
        '1',
        5,
        'optativa',
        'PR016'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS047',
        'Biomedical data science',
        '1',
        5,
        'optativa',
        'PR026'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS048',
        'Business Analytics',
        '2',
        5,
        'optativa',
        'PR005'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS049',
        'Cibermetría',
        '2',
        5,
        'optativa',
        'PR004'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS050',
        'Estructuas de datos y algoritmos escalables',
        '2',
        5,
        'optativa',
        'PR002'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS051',
        'Français scientifique et technique - B1',
        '1',
        5,
        'optativa',
        'PR027'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS052',
        'Francés académico y profesional A1',
        '1',
        5,
        'optativa',
        'PR027'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS053',
        'Francés académico y profesional A2',
        '2',
        5,
        'optativa',
        'PR027'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS054',
        'Frances académico y profesional B1',
        '1',
        5,
        'optativa',
        'PR027'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS055',
        'Frances académico y profesional B2',
        '2',
        5,
        'optativa',
        'PR027'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS056',
        'Gestion clínica y de servicios de salud',
        '2',
        5,
        'optativa',
        'PR011'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS057',
        'Gestión de datos científicos en salud',
        '2',
        5,
        'optativa',
        'PR015'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS058',
        'Gestión de datos en logística y cadenas de suministro',
        '2',
        5,
        'optativa',
        'PR002'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS059',
        'Inglés B2',
        '1',
        5,
        'optativa',
        'PR030'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS060',
        'Intercambio Académico I',
        '1',
        3,
        'optativa',
        'PR031'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS061',
        'Intercambio Académico II',
        '1',
        3,
        'optativa',
        'PR031'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS062',
        'Intercambio Académico III',
        '2',
        3,
        'optativa',
        'PR031'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS063',
        'Intercambio Académico IV',
        '2',
        3,
        'optativa',
        'PR031'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS064',
        'Intercambio Académico V',
        '2',
        3,
        'optativa',
        'PR031'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS065',
        'Intercambio Académico VI',
        '1',
        5,
        'optativa',
        'PR031'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS066',
        'Intercambio Académico VII',
        '1',
        5,
        'optativa',
        'PR031'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS067',
        'Intercambio Académico VIII',
        '2',
        5,
        'optativa',
        'PR031'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS068',
        'Intercambio Académico IX',
        '2',
        5,
        'optativa',
        'PR031'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS069',
        'Intercambio Académico X',
        '1',
        6,
        'optativa',
        'PR031'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS070',
        'Intercambio Académico XI',
        '2',
        6,
        'optativa',
        'PR031'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS071',
        'Italiano académico y profesional A1',
        '1',
        5,
        'optativa',
        'PR029'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS072',
        'Marketing',
        '2',
        5,
        'optativa',
        'PR005'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS073',
        'Modelos de programación para computación de datos',
        '2',
        5,
        'optativa',
        'PR004'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS074',
        'Procesamiento y análisis de biosecuencias',
        '2',
        5,
        'optativa',
        'PR025'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS075',
        'Programación para Internet de las Cosas (IoT)',
        '2',
        5,
        'optativa',
        'PR004'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS076',
        'Sistemas de información empresarial',
        '2',
        5,
        'optativa',
        'PR005'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS077',
        'Sistemas inteligentes de transporte',
        '2',
        5,
        'optativa',
        'PR006'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS078',
        'Técnicas de previsión',
        '2',
        5,
        'optativa',
        'PR006'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS079',
        'Tratamiento de datos geoespaciales',
        '2',
        5,
        'optativa',
        'PR002'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS080',
        'Tratamiento de la infromación en IoT',
        '2',
        5,
        'optativa',
        'PR033'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS081',
        'Visualización interactiva',
        '2',
        5,
        'optativa',
        'PR015'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS082',
        'Inglés C1',
        '1',
        5,
        'optativa',
        'PR034'
    );

INSERT INTO
    asignatura
VALUES (
        4,
        'AS083',
        'Inglés C2',
        '2',
        5,
        'optativa',
        'PR034'
    );

INSERT INTO
    asignatura
VALUES (
        5,
        'AS084',
        'Fundamentos de tratamiento de datos para Data Science',
        '1',
        6,
        'obligatoria',
        'PR002'
    );

INSERT INTO
    asignatura
VALUES (
        5,
        'AS085',
        'Modelos y aprendizaje estadístico',
        '1',
        6,
        'obligatoria',
        'PR008'
    );

INSERT INTO
    asignatura
VALUES (
        5,
        'AS086',
        'Aprendizaje automático aplicado (Machine Learning)',
        '1',
        6,
        'obligatoria',
        'PR036'
    );

INSERT INTO
    asignatura
VALUES (
        5,
        'AS087',
        'Minería de texto y procesamiento del lenguaje natural (PNL)',
        '1',
        6,
        'obligatoria',
        'PR036'
    );

INSERT INTO
    asignatura
VALUES (
        5,
        'AS088',
        'Inteligencia de negocio y visualización',
        '1',
        6,
        'obligatoria',
        'PR036'
    );

INSERT INTO
    asignatura
VALUES (
        5,
        'AS089',
        'Infraestructura Big Data',
        '2',
        6,
        'obligatoria',
        'PR036'
    );

INSERT INTO
    asignatura
VALUES (
        5,
        'AS090',
        'Almacenamiento e integración de datos',
        '2',
        6,
        'obligatoria',
        'PR022'
    );

INSERT INTO
    asignatura
VALUES (
        5,
        'AS091',
        'Valor y contexto de la analítica big data',
        '2',
        6,
        'obligatoria',
        'PR022'
    );

INSERT INTO
    asignatura
VALUES (
        5,
        'AS092',
        'Aplicaciones analíticas. Casos Practicos',
        '2',
        6,
        'obligatoria',
        'PR022'
    );

INSERT INTO
    asignatura
VALUES (
        5,
        'AS093',
        'Trabajo Fin de Master',
        '2',
        6,
        'obligatoria',
        'PR010'
    );

INSERT INTO
    asignatura
VALUES (
        5,
        'AS094',
        'Curso de metodologías ágiles',
        '2',
        6,
        'optativa',
        'PR010'
    );

INSERT INTO
    asignatura
VALUES (
        6,
        'AS095',
        'Técnicas y metodología de la minería de datos (SEMMA)',
        '1',
        0,
        'optativa',
        'PR002'
    );

INSERT INTO
    asignatura
VALUES (
        6,
        'AS096',
        'Gestión y explotación de almacenes de datos',
        '1',
        0,
        'optativa',
        'PR002'
    );

INSERT INTO
    asignatura
VALUES (
        6,
        'AS097',
        'Redes neuronales y algoritmos genéticos',
        '1',
        0,
        'optativa',
        'PR037'
    );

INSERT INTO
    asignatura
VALUES (
        6,
        'AS098',
        'Gestión de relaciones con el cliente CRM',
        '2',
        0,
        'optativa',
        'PR005'
    );

INSERT INTO
    asignatura
VALUES (
        6,
        'AS099',
        'Inteligencia de negocio y cuadro de mando integral',
        '2',
        0,
        'optativa',
        'PR005'
    );

INSERT INTO
    asignatura
VALUES (
        6,
        'AS100',
        'Modelos de decisión en marketing',
        '2',
        0,
        'optativa',
        'PR005'
    );

/* Importamos impartir.csv en la tabla 'impartir'. En este caso los campos del csv está separado por tabulaciones.
Por eso, usaremos la secuencia de escape '\t' para indicar a SQL como separar los datos*/
LOAD DATA INFILE '/usr/src/app/sql/impartir.txt' INTO
TABLE impartir FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- Carga con inserción manual de datos matricula (idAlumno, idAsignatura, Nota).
INSERT INTO matricula VALUES ('AL003', 'AS001', 6.99);

INSERT INTO matricula VALUES ('AL003', 'AS002', 9.71);

INSERT INTO matricula VALUES ('AL003', 'AS003', 10);

INSERT INTO matricula VALUES ('AL003', 'AS004', 8.89);

INSERT INTO matricula VALUES ('AL003', 'AS005', 8.49);

INSERT INTO matricula VALUES ('AL003', 'AS006', 8.74);

INSERT INTO matricula VALUES ('AL003', 'AS007', 5.69);

INSERT INTO matricula VALUES ('AL003', 'AS008', 6.91);

INSERT INTO matricula VALUES ('AL003', 'AS009', 2.31);

INSERT INTO matricula VALUES ('AL003', 'AS010', 9.47);

INSERT INTO matricula VALUES ('AL017', 'AS001', 2.97);

INSERT INTO matricula VALUES ('AL017', 'AS002', 4.28);

INSERT INTO matricula VALUES ('AL017', 'AS003', 7.69);

INSERT INTO matricula VALUES ('AL017', 'AS004', 7.23);

INSERT INTO matricula VALUES ('AL017', 'AS005', 5.07);

INSERT INTO matricula VALUES ('AL017', 'AS006', 6.82);

INSERT INTO matricula VALUES ('AL017', 'AS007', 1.22);

INSERT INTO matricula VALUES ('AL017', 'AS008', 2.32);

INSERT INTO matricula VALUES ('AL017', 'AS009', 5.82);

INSERT INTO matricula VALUES ('AL017', 'AS010', 3.39);

INSERT INTO matricula VALUES ('AL019', 'AS001', 2.93);

INSERT INTO matricula VALUES ('AL019', 'AS002', 9.49);

INSERT INTO matricula VALUES ('AL019', 'AS003', 8.77);

INSERT INTO matricula VALUES ('AL019', 'AS004', 5.11);

INSERT INTO matricula VALUES ('AL019', 'AS005', 4.97);

INSERT INTO matricula VALUES ('AL019', 'AS006', 9.82);

INSERT INTO matricula VALUES ('AL019', 'AS007', 1.14);

INSERT INTO matricula VALUES ('AL019', 'AS008', 1.12);

INSERT INTO matricula VALUES ('AL019', 'AS009', 4.73);

INSERT INTO matricula VALUES ('AL019', 'AS010', 1.48);

INSERT INTO matricula VALUES ('AL045', 'AS001', 5.84);

INSERT INTO matricula VALUES ('AL045', 'AS002', 2.24);

INSERT INTO matricula VALUES ('AL045', 'AS003', 7.42);

INSERT INTO matricula VALUES ('AL045', 'AS004', 3.76);

INSERT INTO matricula VALUES ('AL045', 'AS005', 6.41);

INSERT INTO matricula VALUES ('AL045', 'AS006', 8.43);

INSERT INTO matricula VALUES ('AL045', 'AS007', 10);

INSERT INTO matricula VALUES ('AL045', 'AS008', 10);

INSERT INTO matricula VALUES ('AL045', 'AS009', 1.22);

INSERT INTO matricula VALUES ('AL045', 'AS010', 7.47);

INSERT INTO matricula VALUES ('AL052', 'AS001', 3.56);

INSERT INTO matricula VALUES ('AL052', 'AS002', 7.23);

INSERT INTO matricula VALUES ('AL052', 'AS003', 3.83);

INSERT INTO matricula VALUES ('AL052', 'AS004', 2.43);

INSERT INTO matricula VALUES ('AL052', 'AS005', 7.68);

INSERT INTO matricula VALUES ('AL052', 'AS006', 1.01);

INSERT INTO matricula VALUES ('AL052', 'AS007', 3.63);

INSERT INTO matricula VALUES ('AL052', 'AS008', 6.26);

INSERT INTO matricula VALUES ('AL052', 'AS009', 10);

INSERT INTO matricula VALUES ('AL052', 'AS010', 7.67);

INSERT INTO matricula VALUES ('AL058', 'AS001', 8.84);

INSERT INTO matricula VALUES ('AL058', 'AS002', 1.66);

INSERT INTO matricula VALUES ('AL058', 'AS003', 7.07);

INSERT INTO matricula VALUES ('AL058', 'AS004', 10);

INSERT INTO matricula VALUES ('AL058', 'AS005', 8.71);

INSERT INTO matricula VALUES ('AL058', 'AS006', 5.32);

INSERT INTO matricula VALUES ('AL058', 'AS007', 1.46);

INSERT INTO matricula VALUES ('AL058', 'AS008', 7.02);

INSERT INTO matricula VALUES ('AL058', 'AS009', 3.75);

INSERT INTO matricula VALUES ('AL058', 'AS010', 5.83);

INSERT INTO matricula VALUES ('AL069', 'AS001', 10);

INSERT INTO matricula VALUES ('AL069', 'AS002', 6.95);

INSERT INTO matricula VALUES ('AL069', 'AS003', 9.83);

INSERT INTO matricula VALUES ('AL069', 'AS004', 9.35);

INSERT INTO matricula VALUES ('AL069', 'AS005', 8.93);

INSERT INTO matricula VALUES ('AL069', 'AS006', 1.59);

INSERT INTO matricula VALUES ('AL069', 'AS007', 7.99);

INSERT INTO matricula VALUES ('AL069', 'AS008', 6.51);

INSERT INTO matricula VALUES ('AL069', 'AS009', 2.58);

INSERT INTO matricula VALUES ('AL069', 'AS010', 2.78);

INSERT INTO matricula VALUES ('AL076', 'AS001', 7.56);

INSERT INTO matricula VALUES ('AL076', 'AS002', 7.51);

INSERT INTO matricula VALUES ('AL076', 'AS003', 8.63);

INSERT INTO matricula VALUES ('AL076', 'AS004', 8.88);

INSERT INTO matricula VALUES ('AL076', 'AS005', 6.78);

INSERT INTO matricula VALUES ('AL076', 'AS006', 5.01);

INSERT INTO matricula VALUES ('AL076', 'AS007', 9.19);

INSERT INTO matricula VALUES ('AL076', 'AS008', 3.53);

INSERT INTO matricula VALUES ('AL076', 'AS009', 10);

INSERT INTO matricula VALUES ('AL076', 'AS010', 8.99);

INSERT INTO matricula VALUES ('AL081', 'AS001', 7.21);

INSERT INTO matricula VALUES ('AL081', 'AS002', 3.09);

INSERT INTO matricula VALUES ('AL081', 'AS003', 9.84);

INSERT INTO matricula VALUES ('AL081', 'AS004', 5.52);

INSERT INTO matricula VALUES ('AL081', 'AS005', 1.46);

INSERT INTO matricula VALUES ('AL081', 'AS006', 4.09);

INSERT INTO matricula VALUES ('AL081', 'AS007', 9.87);

INSERT INTO matricula VALUES ('AL081', 'AS008', 10);

INSERT INTO matricula VALUES ('AL081', 'AS009', 6.24);

INSERT INTO matricula VALUES ('AL081', 'AS010', 8.89);

INSERT INTO matricula VALUES ('AL090', 'AS001', 8.12);

INSERT INTO matricula VALUES ('AL090', 'AS002', 6.86);

INSERT INTO matricula VALUES ('AL090', 'AS003', 1.85);

INSERT INTO matricula VALUES ('AL090', 'AS004', 4.43);

INSERT INTO matricula VALUES ('AL090', 'AS005', 1.44);

INSERT INTO matricula VALUES ('AL090', 'AS006', 1.49);

INSERT INTO matricula VALUES ('AL090', 'AS007', 6.58);

INSERT INTO matricula VALUES ('AL090', 'AS008', 3.36);

INSERT INTO matricula VALUES ('AL090', 'AS009', 7.52);

INSERT INTO matricula VALUES ('AL090', 'AS010', 2.32);

INSERT INTO matricula VALUES ('AL092', 'AS001', 7.99);

INSERT INTO matricula VALUES ('AL092', 'AS002', 2.12);

INSERT INTO matricula VALUES ('AL092', 'AS003', 6.15);

INSERT INTO matricula VALUES ('AL092', 'AS004', 9.99);

INSERT INTO matricula VALUES ('AL092', 'AS005', 3.54);

INSERT INTO matricula VALUES ('AL092', 'AS006', 4.83);

INSERT INTO matricula VALUES ('AL092', 'AS007', 1.46);

INSERT INTO matricula VALUES ('AL092', 'AS008', 6.88);

INSERT INTO matricula VALUES ('AL092', 'AS009', 6.22);

INSERT INTO matricula VALUES ('AL092', 'AS010', 2.29);

INSERT INTO matricula VALUES ('AL103', 'AS001', 7.88);

INSERT INTO matricula VALUES ('AL103', 'AS002', 5.39);

INSERT INTO matricula VALUES ('AL103', 'AS003', 7.17);

INSERT INTO matricula VALUES ('AL103', 'AS004', 7.62);

INSERT INTO matricula VALUES ('AL103', 'AS005', 3.25);

INSERT INTO matricula VALUES ('AL103', 'AS006', 7.91);

INSERT INTO matricula VALUES ('AL103', 'AS007', 3.72);

INSERT INTO matricula VALUES ('AL103', 'AS008', 2.22);

INSERT INTO matricula VALUES ('AL103', 'AS009', 6.77);

INSERT INTO matricula VALUES ('AL103', 'AS010', 8.06);

INSERT INTO matricula VALUES ('AL104', 'AS001', 7.28);

INSERT INTO matricula VALUES ('AL104', 'AS002', 1.76);

INSERT INTO matricula VALUES ('AL104', 'AS003', 8.54);

INSERT INTO matricula VALUES ('AL104', 'AS004', 6.74);

INSERT INTO matricula VALUES ('AL104', 'AS005', 6.76);

INSERT INTO matricula VALUES ('AL104', 'AS006', 4.18);

INSERT INTO matricula VALUES ('AL104', 'AS007', 1.46);

INSERT INTO matricula VALUES ('AL104', 'AS008', 4.13);

INSERT INTO matricula VALUES ('AL104', 'AS009', 2.95);

INSERT INTO matricula VALUES ('AL104', 'AS010', 10);

INSERT INTO matricula VALUES ('AL108', 'AS001', 1.02);

INSERT INTO matricula VALUES ('AL108', 'AS002', 3.47);

INSERT INTO matricula VALUES ('AL108', 'AS003', 2.83);

INSERT INTO matricula VALUES ('AL108', 'AS004', 5.09);

INSERT INTO matricula VALUES ('AL108', 'AS005', 1.94);

INSERT INTO matricula VALUES ('AL108', 'AS006', 2.28);

INSERT INTO matricula VALUES ('AL108', 'AS007', 7.63);

INSERT INTO matricula VALUES ('AL108', 'AS008', 6.25);

INSERT INTO matricula VALUES ('AL108', 'AS009', 1.47);

INSERT INTO matricula VALUES ('AL108', 'AS010', 10);

INSERT INTO matricula VALUES ('AL118', 'AS001', 5.45);

INSERT INTO matricula VALUES ('AL118', 'AS002', 5.91);

INSERT INTO matricula VALUES ('AL118', 'AS003', 3.29);

INSERT INTO matricula VALUES ('AL118', 'AS004', 8.89);

INSERT INTO matricula VALUES ('AL118', 'AS005', 8.03);

INSERT INTO matricula VALUES ('AL118', 'AS006', 2.45);

INSERT INTO matricula VALUES ('AL118', 'AS007', 10);

INSERT INTO matricula VALUES ('AL118', 'AS008', 9.37);

INSERT INTO matricula VALUES ('AL118', 'AS009', 7.63);

INSERT INTO matricula VALUES ('AL118', 'AS010', 7.08);

INSERT INTO matricula VALUES ('AL132', 'AS001', 6.93);

INSERT INTO matricula VALUES ('AL132', 'AS002', 8.83);

INSERT INTO matricula VALUES ('AL132', 'AS003', 6.51);

INSERT INTO matricula VALUES ('AL132', 'AS004', 8.31);

INSERT INTO matricula VALUES ('AL132', 'AS005', 3.37);

INSERT INTO matricula VALUES ('AL132', 'AS006', 6.65);

INSERT INTO matricula VALUES ('AL132', 'AS007', 6.25);

INSERT INTO matricula VALUES ('AL132', 'AS008', 4.54);

INSERT INTO matricula VALUES ('AL132', 'AS009', 8.88);

INSERT INTO matricula VALUES ('AL132', 'AS010', 2.29);

INSERT INTO matricula VALUES ('AL138', 'AS001', 1.78);

INSERT INTO matricula VALUES ('AL138', 'AS002', 6.12);

INSERT INTO matricula VALUES ('AL138', 'AS003', 6.95);

INSERT INTO matricula VALUES ('AL138', 'AS004', 8.63);

INSERT INTO matricula VALUES ('AL138', 'AS005', 1.38);

INSERT INTO matricula VALUES ('AL138', 'AS006', 4.67);

INSERT INTO matricula VALUES ('AL138', 'AS007', 10);

INSERT INTO matricula VALUES ('AL138', 'AS008', 7.01);

INSERT INTO matricula VALUES ('AL138', 'AS009', 8.86);

INSERT INTO matricula VALUES ('AL138', 'AS010', 5.75);

INSERT INTO matricula VALUES ('AL142', 'AS001', 3.65);

INSERT INTO matricula VALUES ('AL142', 'AS002', 9.84);

INSERT INTO matricula VALUES ('AL142', 'AS003', 10);

INSERT INTO matricula VALUES ('AL142', 'AS004', 1.46);

INSERT INTO matricula VALUES ('AL142', 'AS005', 7.31);

INSERT INTO matricula VALUES ('AL142', 'AS006', 3.72);

INSERT INTO matricula VALUES ('AL142', 'AS007', 1.71);

INSERT INTO matricula VALUES ('AL142', 'AS008', 2.96);

INSERT INTO matricula VALUES ('AL142', 'AS009', 2.01);

INSERT INTO matricula VALUES ('AL142', 'AS010', 5.49);

INSERT INTO matricula VALUES ('AL147', 'AS001', 1.28);

INSERT INTO matricula VALUES ('AL147', 'AS002', 3.81);

INSERT INTO matricula VALUES ('AL147', 'AS003', 7.32);

INSERT INTO matricula VALUES ('AL147', 'AS004', 10);

INSERT INTO matricula VALUES ('AL147', 'AS005', 2.56);

INSERT INTO matricula VALUES ('AL147', 'AS006', 4.52);

INSERT INTO matricula VALUES ('AL147', 'AS007', 9.48);

INSERT INTO matricula VALUES ('AL147', 'AS008', 2.87);

INSERT INTO matricula VALUES ('AL147', 'AS009', 3.47);

INSERT INTO matricula VALUES ('AL147', 'AS010', 5.99);

INSERT INTO matricula VALUES ('AL165', 'AS001', 3.89);

INSERT INTO matricula VALUES ('AL165', 'AS002', 2.14);

INSERT INTO matricula VALUES ('AL165', 'AS003', 1.76);

INSERT INTO matricula VALUES ('AL165', 'AS004', 1.79);

INSERT INTO matricula VALUES ('AL165', 'AS005', 10);

INSERT INTO matricula VALUES ('AL165', 'AS006', 4.95);

INSERT INTO matricula VALUES ('AL165', 'AS007', 4.81);

INSERT INTO matricula VALUES ('AL165', 'AS008', 8.36);

INSERT INTO matricula VALUES ('AL165', 'AS009', 3.62);

INSERT INTO matricula VALUES ('AL165', 'AS010', 3.24);

INSERT INTO matricula VALUES ('AL187', 'AS001', 8.49);

INSERT INTO matricula VALUES ('AL187', 'AS002', 5.53);

INSERT INTO matricula VALUES ('AL187', 'AS003', 2.32);

INSERT INTO matricula VALUES ('AL187', 'AS004', 6.19);

INSERT INTO matricula VALUES ('AL187', 'AS005', 7.19);

INSERT INTO matricula VALUES ('AL187', 'AS006', 8.71);

INSERT INTO matricula VALUES ('AL187', 'AS007', 1.18);

INSERT INTO matricula VALUES ('AL187', 'AS008', 5.37);

INSERT INTO matricula VALUES ('AL187', 'AS009', 3.33);

INSERT INTO matricula VALUES ('AL187', 'AS010', 3.51);

INSERT INTO matricula VALUES ('AL189', 'AS001', 6.54);

INSERT INTO matricula VALUES ('AL189', 'AS002', 7.06);

INSERT INTO matricula VALUES ('AL189', 'AS003', 7.67);

INSERT INTO matricula VALUES ('AL189', 'AS004', 4.41);

INSERT INTO matricula VALUES ('AL189', 'AS005', 1.27);

INSERT INTO matricula VALUES ('AL189', 'AS006', 9.19);

INSERT INTO matricula VALUES ('AL189', 'AS007', 2.88);

INSERT INTO matricula VALUES ('AL189', 'AS008', 3.07);

INSERT INTO matricula VALUES ('AL189', 'AS009', 2.99);

INSERT INTO matricula VALUES ('AL189', 'AS010', 6.38);

INSERT INTO matricula VALUES ('AL194', 'AS001', 3.27);

INSERT INTO matricula VALUES ('AL194', 'AS002', 4.34);

INSERT INTO matricula VALUES ('AL194', 'AS003', 1.26);

INSERT INTO matricula VALUES ('AL194', 'AS004', 3.42);

INSERT INTO matricula VALUES ('AL194', 'AS005', 1.72);

INSERT INTO matricula VALUES ('AL194', 'AS006', 1.46);

INSERT INTO matricula VALUES ('AL194', 'AS007', 2.94);

INSERT INTO matricula VALUES ('AL194', 'AS008', 9.34);

INSERT INTO matricula VALUES ('AL194', 'AS009', 8.87);

INSERT INTO matricula VALUES ('AL194', 'AS010', 5.98);

INSERT INTO matricula VALUES ('AL007', 'AS011', 2.16);

INSERT INTO matricula VALUES ('AL007', 'AS012', 4.21);

INSERT INTO matricula VALUES ('AL007', 'AS013', 9.42);

INSERT INTO matricula VALUES ('AL007', 'AS014', 10);

INSERT INTO matricula VALUES ('AL007', 'AS015', 9.11);

INSERT INTO matricula VALUES ('AL007', 'AS016', 9.83);

INSERT INTO matricula VALUES ('AL007', 'AS017', 6.95);

INSERT INTO matricula VALUES ('AL007', 'AS018', 9.67);

INSERT INTO matricula VALUES ('AL007', 'AS019', 8.42);

INSERT INTO matricula VALUES ('AL007', 'AS020', 9.15);

INSERT INTO matricula VALUES ('AL010', 'AS011', 9.68);

INSERT INTO matricula VALUES ('AL010', 'AS012', 5.57);

INSERT INTO matricula VALUES ('AL010', 'AS013', 3.31);

INSERT INTO matricula VALUES ('AL010', 'AS014', 1.86);

INSERT INTO matricula VALUES ('AL010', 'AS015', 3.47);

INSERT INTO matricula VALUES ('AL010', 'AS016', 8.38);

INSERT INTO matricula VALUES ('AL010', 'AS017', 10);

INSERT INTO matricula VALUES ('AL010', 'AS018', 5.67);

INSERT INTO matricula VALUES ('AL010', 'AS019', 6.02);

INSERT INTO matricula VALUES ('AL010', 'AS020', 2.07);

INSERT INTO matricula VALUES ('AL011', 'AS011', 9.81);

INSERT INTO matricula VALUES ('AL011', 'AS012', 1.54);

INSERT INTO matricula VALUES ('AL011', 'AS013', 9.76);

INSERT INTO matricula VALUES ('AL011', 'AS014', 6.32);

INSERT INTO matricula VALUES ('AL011', 'AS015', 5.64);

INSERT INTO matricula VALUES ('AL011', 'AS016', 1.07);

INSERT INTO matricula VALUES ('AL011', 'AS017', 3.63);

INSERT INTO matricula VALUES ('AL011', 'AS018', 9.08);

INSERT INTO matricula VALUES ('AL011', 'AS019', 5.45);

INSERT INTO matricula VALUES ('AL011', 'AS020', 8.06);

INSERT INTO matricula VALUES ('AL025', 'AS011', 2.26);

INSERT INTO matricula VALUES ('AL025', 'AS012', 3.69);

INSERT INTO matricula VALUES ('AL025', 'AS013', 7.39);

INSERT INTO matricula VALUES ('AL025', 'AS014', 2.45);

INSERT INTO matricula VALUES ('AL025', 'AS015', 2.34);

INSERT INTO matricula VALUES ('AL025', 'AS016', 8.68);

INSERT INTO matricula VALUES ('AL025', 'AS017', 1.81);

INSERT INTO matricula VALUES ('AL025', 'AS018', 5.31);

INSERT INTO matricula VALUES ('AL025', 'AS019', 7.62);

INSERT INTO matricula VALUES ('AL025', 'AS020', 6.67);

INSERT INTO matricula VALUES ('AL027', 'AS011', 1.39);

INSERT INTO matricula VALUES ('AL027', 'AS012', 4.26);

INSERT INTO matricula VALUES ('AL027', 'AS013', 8.43);

INSERT INTO matricula VALUES ('AL027', 'AS014', 9.12);

INSERT INTO matricula VALUES ('AL027', 'AS015', 2.07);

INSERT INTO matricula VALUES ('AL027', 'AS016', 6.57);

INSERT INTO matricula VALUES ('AL027', 'AS017', 3.02);

INSERT INTO matricula VALUES ('AL027', 'AS018', 7.38);

INSERT INTO matricula VALUES ('AL027', 'AS019', 10);

INSERT INTO matricula VALUES ('AL027', 'AS020', 10);

INSERT INTO matricula VALUES ('AL030', 'AS011', 7.97);

INSERT INTO matricula VALUES ('AL030', 'AS012', 7.51);

INSERT INTO matricula VALUES ('AL030', 'AS013', 3.49);

INSERT INTO matricula VALUES ('AL030', 'AS014', 1.52);

INSERT INTO matricula VALUES ('AL030', 'AS015', 6.47);

INSERT INTO matricula VALUES ('AL030', 'AS016', 2.18);

INSERT INTO matricula VALUES ('AL030', 'AS017', 8.23);

INSERT INTO matricula VALUES ('AL030', 'AS018', 5.86);

INSERT INTO matricula VALUES ('AL030', 'AS019', 9.22);

INSERT INTO matricula VALUES ('AL030', 'AS020', 3.74);

INSERT INTO matricula VALUES ('AL051', 'AS011', 10);

INSERT INTO matricula VALUES ('AL051', 'AS012', 3.24);

INSERT INTO matricula VALUES ('AL051', 'AS013', 6.96);

INSERT INTO matricula VALUES ('AL051', 'AS014', 3.23);

INSERT INTO matricula VALUES ('AL051', 'AS015', 10);

INSERT INTO matricula VALUES ('AL051', 'AS016', 10);

INSERT INTO matricula VALUES ('AL051', 'AS017', 6.01);

INSERT INTO matricula VALUES ('AL051', 'AS018', 10);

INSERT INTO matricula VALUES ('AL051', 'AS019', 8.18);

INSERT INTO matricula VALUES ('AL051', 'AS020', 9.65);

INSERT INTO matricula VALUES ('AL054', 'AS011', 5.43);

INSERT INTO matricula VALUES ('AL054', 'AS012', 5.59);

INSERT INTO matricula VALUES ('AL054', 'AS013', 10);

INSERT INTO matricula VALUES ('AL054', 'AS014', 7.57);

INSERT INTO matricula VALUES ('AL054', 'AS015', 5.07);

INSERT INTO matricula VALUES ('AL054', 'AS016', 8.32);

INSERT INTO matricula VALUES ('AL054', 'AS017', 3.55);

INSERT INTO matricula VALUES ('AL054', 'AS018', 5.06);

INSERT INTO matricula VALUES ('AL054', 'AS019', 1.58);

INSERT INTO matricula VALUES ('AL054', 'AS020', 2.21);

INSERT INTO matricula VALUES ('AL064', 'AS011', 10);

INSERT INTO matricula VALUES ('AL064', 'AS012', 6.72);

INSERT INTO matricula VALUES ('AL064', 'AS013', 1.19);

INSERT INTO matricula VALUES ('AL064', 'AS014', 3.06);

INSERT INTO matricula VALUES ('AL064', 'AS015', 6.52);

INSERT INTO matricula VALUES ('AL064', 'AS016', 1.72);

INSERT INTO matricula VALUES ('AL064', 'AS017', 8.14);

INSERT INTO matricula VALUES ('AL064', 'AS018', 10);

INSERT INTO matricula VALUES ('AL064', 'AS019', 10);

INSERT INTO matricula VALUES ('AL064', 'AS020', 8.66);

INSERT INTO matricula VALUES ('AL079', 'AS011', 9.64);

INSERT INTO matricula VALUES ('AL079', 'AS012', 4.03);

INSERT INTO matricula VALUES ('AL079', 'AS013', 9.06);

INSERT INTO matricula VALUES ('AL079', 'AS014', 9.83);

INSERT INTO matricula VALUES ('AL079', 'AS015', 9.51);

INSERT INTO matricula VALUES ('AL079', 'AS016', 1.39);

INSERT INTO matricula VALUES ('AL079', 'AS017', 2.87);

INSERT INTO matricula VALUES ('AL079', 'AS018', 4.88);

INSERT INTO matricula VALUES ('AL079', 'AS019', 5.31);

INSERT INTO matricula VALUES ('AL079', 'AS020', 6.57);

INSERT INTO matricula VALUES ('AL099', 'AS011', 6.12);

INSERT INTO matricula VALUES ('AL099', 'AS012', 10);

INSERT INTO matricula VALUES ('AL099', 'AS013', 6.07);

INSERT INTO matricula VALUES ('AL099', 'AS014', 10);

INSERT INTO matricula VALUES ('AL099', 'AS015', 8.53);

INSERT INTO matricula VALUES ('AL099', 'AS016', 2.46);

INSERT INTO matricula VALUES ('AL099', 'AS017', 6.84);

INSERT INTO matricula VALUES ('AL099', 'AS018', 5.31);

INSERT INTO matricula VALUES ('AL099', 'AS019', 4.35);

INSERT INTO matricula VALUES ('AL099', 'AS020', 7.77);

INSERT INTO matricula VALUES ('AL100', 'AS011', 1.48);

INSERT INTO matricula VALUES ('AL100', 'AS012', 7.41);

INSERT INTO matricula VALUES ('AL100', 'AS013', 3.16);

INSERT INTO matricula VALUES ('AL100', 'AS014', 7.65);

INSERT INTO matricula VALUES ('AL100', 'AS015', 2.15);

INSERT INTO matricula VALUES ('AL100', 'AS016', 1.91);

INSERT INTO matricula VALUES ('AL100', 'AS017', 7.05);

INSERT INTO matricula VALUES ('AL100', 'AS018', 2.05);

INSERT INTO matricula VALUES ('AL100', 'AS019', 1.11);

INSERT INTO matricula VALUES ('AL100', 'AS020', 4.76);

INSERT INTO matricula VALUES ('AL101', 'AS011', 7.21);

INSERT INTO matricula VALUES ('AL101', 'AS012', 6.14);

INSERT INTO matricula VALUES ('AL101', 'AS013', 4.09);

INSERT INTO matricula VALUES ('AL101', 'AS014', 8.85);

INSERT INTO matricula VALUES ('AL101', 'AS015', 9.82);

INSERT INTO matricula VALUES ('AL101', 'AS016', 5.87);

INSERT INTO matricula VALUES ('AL101', 'AS017', 3.63);

INSERT INTO matricula VALUES ('AL101', 'AS018', 1.67);

INSERT INTO matricula VALUES ('AL101', 'AS019', 4.99);

INSERT INTO matricula VALUES ('AL101', 'AS020', 5.89);

INSERT INTO matricula VALUES ('AL102', 'AS011', 8.75);

INSERT INTO matricula VALUES ('AL102', 'AS012', 4.32);

INSERT INTO matricula VALUES ('AL102', 'AS013', 5.44);

INSERT INTO matricula VALUES ('AL102', 'AS014', 9.06);

INSERT INTO matricula VALUES ('AL102', 'AS015', 4.32);

INSERT INTO matricula VALUES ('AL102', 'AS016', 5.58);

INSERT INTO matricula VALUES ('AL102', 'AS017', 3.38);

INSERT INTO matricula VALUES ('AL102', 'AS018', 4.67);

INSERT INTO matricula VALUES ('AL102', 'AS019', 3.54);

INSERT INTO matricula VALUES ('AL102', 'AS020', 4.32);

INSERT INTO matricula VALUES ('AL106', 'AS011', 5.09);

INSERT INTO matricula VALUES ('AL106', 'AS012', 2.13);

INSERT INTO matricula VALUES ('AL106', 'AS013', 9.86);

INSERT INTO matricula VALUES ('AL106', 'AS014', 4.73);

INSERT INTO matricula VALUES ('AL106', 'AS015', 1.25);

INSERT INTO matricula VALUES ('AL106', 'AS016', 3.05);

INSERT INTO matricula VALUES ('AL106', 'AS017', 4.85);

INSERT INTO matricula VALUES ('AL106', 'AS018', 9.61);

INSERT INTO matricula VALUES ('AL106', 'AS019', 4.95);

INSERT INTO matricula VALUES ('AL106', 'AS020', 8.53);

INSERT INTO matricula VALUES ('AL112', 'AS011', 4.22);

INSERT INTO matricula VALUES ('AL112', 'AS012', 2.26);

INSERT INTO matricula VALUES ('AL112', 'AS013', 4.75);

INSERT INTO matricula VALUES ('AL112', 'AS014', 9.89);

INSERT INTO matricula VALUES ('AL112', 'AS015', 5.25);

INSERT INTO matricula VALUES ('AL112', 'AS016', 1.39);

INSERT INTO matricula VALUES ('AL112', 'AS017', 8.07);

INSERT INTO matricula VALUES ('AL112', 'AS018', 10);

INSERT INTO matricula VALUES ('AL112', 'AS019', 5.37);

INSERT INTO matricula VALUES ('AL112', 'AS020', 6.74);

INSERT INTO matricula VALUES ('AL113', 'AS011', 6.93);

INSERT INTO matricula VALUES ('AL113', 'AS012', 4.81);

INSERT INTO matricula VALUES ('AL113', 'AS013', 2.25);

INSERT INTO matricula VALUES ('AL113', 'AS014', 1.65);

INSERT INTO matricula VALUES ('AL113', 'AS015', 4.42);

INSERT INTO matricula VALUES ('AL113', 'AS016', 1.81);

INSERT INTO matricula VALUES ('AL113', 'AS017', 8.76);

INSERT INTO matricula VALUES ('AL113', 'AS018', 2.08);

INSERT INTO matricula VALUES ('AL113', 'AS019', 3.95);

INSERT INTO matricula VALUES ('AL113', 'AS020', 6.14);

INSERT INTO matricula VALUES ('AL119', 'AS011', 10);

INSERT INTO matricula VALUES ('AL119', 'AS012', 4.85);

INSERT INTO matricula VALUES ('AL119', 'AS013', 10);

INSERT INTO matricula VALUES ('AL119', 'AS014', 1.84);

INSERT INTO matricula VALUES ('AL119', 'AS015', 4.11);

INSERT INTO matricula VALUES ('AL119', 'AS016', 5.68);

INSERT INTO matricula VALUES ('AL119', 'AS017', 3.53);

INSERT INTO matricula VALUES ('AL119', 'AS018', 2.17);

INSERT INTO matricula VALUES ('AL119', 'AS019', 8.75);

INSERT INTO matricula VALUES ('AL119', 'AS020', 9.61);

INSERT INTO matricula VALUES ('AL123', 'AS011', 5.16);

INSERT INTO matricula VALUES ('AL123', 'AS012', 6.29);

INSERT INTO matricula VALUES ('AL123', 'AS013', 2.92);

INSERT INTO matricula VALUES ('AL123', 'AS014', 9.07);

INSERT INTO matricula VALUES ('AL123', 'AS015', 1.81);

INSERT INTO matricula VALUES ('AL123', 'AS016', 1.09);

INSERT INTO matricula VALUES ('AL123', 'AS017', 4.82);

INSERT INTO matricula VALUES ('AL123', 'AS018', 3.92);

INSERT INTO matricula VALUES ('AL123', 'AS019', 9.38);

INSERT INTO matricula VALUES ('AL123', 'AS020', 8.21);

INSERT INTO matricula VALUES ('AL131', 'AS011', 3.77);

INSERT INTO matricula VALUES ('AL131', 'AS012', 1.82);

INSERT INTO matricula VALUES ('AL131', 'AS013', 2.38);

INSERT INTO matricula VALUES ('AL131', 'AS014', 9.03);

INSERT INTO matricula VALUES ('AL131', 'AS015', 2.03);

INSERT INTO matricula VALUES ('AL131', 'AS016', 10);

INSERT INTO matricula VALUES ('AL131', 'AS017', 1.85);

INSERT INTO matricula VALUES ('AL131', 'AS018', 8.86);

INSERT INTO matricula VALUES ('AL131', 'AS019', 6.82);

INSERT INTO matricula VALUES ('AL131', 'AS020', 4.23);

INSERT INTO matricula VALUES ('AL152', 'AS011', 3.27);

INSERT INTO matricula VALUES ('AL152', 'AS012', 7.17);

INSERT INTO matricula VALUES ('AL152', 'AS013', 6.17);

INSERT INTO matricula VALUES ('AL152', 'AS014', 9.97);

INSERT INTO matricula VALUES ('AL152', 'AS015', 1.35);

INSERT INTO matricula VALUES ('AL152', 'AS016', 6.46);

INSERT INTO matricula VALUES ('AL152', 'AS017', 10);

INSERT INTO matricula VALUES ('AL152', 'AS018', 4.05);

INSERT INTO matricula VALUES ('AL152', 'AS019', 2.79);

INSERT INTO matricula VALUES ('AL152', 'AS020', 7.02);

INSERT INTO matricula VALUES ('AL154', 'AS011', 8.41);

INSERT INTO matricula VALUES ('AL154', 'AS012', 7.78);

INSERT INTO matricula VALUES ('AL154', 'AS013', 4.25);

INSERT INTO matricula VALUES ('AL154', 'AS014', 4.36);

INSERT INTO matricula VALUES ('AL154', 'AS015', 9.79);

INSERT INTO matricula VALUES ('AL154', 'AS016', 3.08);

INSERT INTO matricula VALUES ('AL154', 'AS017', 9.52);

INSERT INTO matricula VALUES ('AL154', 'AS018', 5.38);

INSERT INTO matricula VALUES ('AL154', 'AS019', 4.14);

INSERT INTO matricula VALUES ('AL154', 'AS020', 9.21);

INSERT INTO matricula VALUES ('AL160', 'AS011', 10);

INSERT INTO matricula VALUES ('AL160', 'AS012', 7.93);

INSERT INTO matricula VALUES ('AL160', 'AS013', 1.89);

INSERT INTO matricula VALUES ('AL160', 'AS014', 2.23);

INSERT INTO matricula VALUES ('AL160', 'AS015', 8.32);

INSERT INTO matricula VALUES ('AL160', 'AS016', 3.01);

INSERT INTO matricula VALUES ('AL160', 'AS017', 4.59);

INSERT INTO matricula VALUES ('AL160', 'AS018', 10);

INSERT INTO matricula VALUES ('AL160', 'AS019', 2.82);

INSERT INTO matricula VALUES ('AL160', 'AS020', 4.21);

INSERT INTO matricula VALUES ('AL161', 'AS011', 4.85);

INSERT INTO matricula VALUES ('AL161', 'AS012', 7.11);

INSERT INTO matricula VALUES ('AL161', 'AS013', 3.37);

INSERT INTO matricula VALUES ('AL161', 'AS014', 2.26);

INSERT INTO matricula VALUES ('AL161', 'AS015', 4.99);

INSERT INTO matricula VALUES ('AL161', 'AS016', 10);

INSERT INTO matricula VALUES ('AL161', 'AS017', 9.13);

INSERT INTO matricula VALUES ('AL161', 'AS018', 4.58);

INSERT INTO matricula VALUES ('AL161', 'AS019', 7.57);

INSERT INTO matricula VALUES ('AL161', 'AS020', 6.87);

INSERT INTO matricula VALUES ('AL166', 'AS011', 5.17);

INSERT INTO matricula VALUES ('AL166', 'AS012', 1.27);

INSERT INTO matricula VALUES ('AL166', 'AS013', 6.77);

INSERT INTO matricula VALUES ('AL166', 'AS014', 7.22);

INSERT INTO matricula VALUES ('AL166', 'AS015', 1.18);

INSERT INTO matricula VALUES ('AL166', 'AS016', 10);

INSERT INTO matricula VALUES ('AL166', 'AS017', 7.94);

INSERT INTO matricula VALUES ('AL166', 'AS018', 9.51);

INSERT INTO matricula VALUES ('AL166', 'AS019', 7.45);

INSERT INTO matricula VALUES ('AL166', 'AS020', 7.21);

INSERT INTO matricula VALUES ('AL167', 'AS011', 3.92);

INSERT INTO matricula VALUES ('AL167', 'AS012', 3.25);

INSERT INTO matricula VALUES ('AL167', 'AS013', 2.12);

INSERT INTO matricula VALUES ('AL167', 'AS014', 2.96);

INSERT INTO matricula VALUES ('AL167', 'AS015', 7.06);

INSERT INTO matricula VALUES ('AL167', 'AS016', 8.39);

INSERT INTO matricula VALUES ('AL167', 'AS017', 9.39);

INSERT INTO matricula VALUES ('AL167', 'AS018', 8.02);

INSERT INTO matricula VALUES ('AL167', 'AS019', 7.84);

INSERT INTO matricula VALUES ('AL167', 'AS020', 6.27);

INSERT INTO matricula VALUES ('AL170', 'AS011', 3.69);

INSERT INTO matricula VALUES ('AL170', 'AS012', 2.15);

INSERT INTO matricula VALUES ('AL170', 'AS013', 8.15);

INSERT INTO matricula VALUES ('AL170', 'AS014', 5.69);

INSERT INTO matricula VALUES ('AL170', 'AS015', 6.31);

INSERT INTO matricula VALUES ('AL170', 'AS016', 5.18);

INSERT INTO matricula VALUES ('AL170', 'AS017', 9.61);

INSERT INTO matricula VALUES ('AL170', 'AS018', 2.79);

INSERT INTO matricula VALUES ('AL170', 'AS019', 7.01);

INSERT INTO matricula VALUES ('AL170', 'AS020', 4.44);

INSERT INTO matricula VALUES ('AL177', 'AS011', 6.03);

INSERT INTO matricula VALUES ('AL177', 'AS012', 1.88);

INSERT INTO matricula VALUES ('AL177', 'AS013', 3.38);

INSERT INTO matricula VALUES ('AL177', 'AS014', 6.22);

INSERT INTO matricula VALUES ('AL177', 'AS015', 8.16);

INSERT INTO matricula VALUES ('AL177', 'AS016', 5.16);

INSERT INTO matricula VALUES ('AL177', 'AS017', 2.45);

INSERT INTO matricula VALUES ('AL177', 'AS018', 3.63);

INSERT INTO matricula VALUES ('AL177', 'AS019', 2.37);

INSERT INTO matricula VALUES ('AL177', 'AS020', 4.59);

INSERT INTO matricula VALUES ('AL185', 'AS011', 1.02);

INSERT INTO matricula VALUES ('AL185', 'AS012', 1.48);

INSERT INTO matricula VALUES ('AL185', 'AS013', 10);

INSERT INTO matricula VALUES ('AL185', 'AS014', 9.73);

INSERT INTO matricula VALUES ('AL185', 'AS015', 10);

INSERT INTO matricula VALUES ('AL185', 'AS016', 6.73);

INSERT INTO matricula VALUES ('AL185', 'AS017', 9.31);

INSERT INTO matricula VALUES ('AL185', 'AS018', 8.77);

INSERT INTO matricula VALUES ('AL185', 'AS019', 1.26);

INSERT INTO matricula VALUES ('AL185', 'AS020', 10);

INSERT INTO matricula VALUES ('AL193', 'AS011', 4.96);

INSERT INTO matricula VALUES ('AL193', 'AS012', 7.22);

INSERT INTO matricula VALUES ('AL193', 'AS013', 2.35);

INSERT INTO matricula VALUES ('AL193', 'AS014', 10);

INSERT INTO matricula VALUES ('AL193', 'AS015', 6.79);

INSERT INTO matricula VALUES ('AL193', 'AS016', 10);

INSERT INTO matricula VALUES ('AL193', 'AS017', 10);

INSERT INTO matricula VALUES ('AL193', 'AS018', 3.95);

INSERT INTO matricula VALUES ('AL193', 'AS019', 9.58);

INSERT INTO matricula VALUES ('AL193', 'AS020', 8.64);

INSERT INTO matricula VALUES ('AL197', 'AS011', 7.59);

INSERT INTO matricula VALUES ('AL197', 'AS012', 3.07);

INSERT INTO matricula VALUES ('AL197', 'AS013', 10);

INSERT INTO matricula VALUES ('AL197', 'AS014', 6.75);

INSERT INTO matricula VALUES ('AL197', 'AS015', 8.77);

INSERT INTO matricula VALUES ('AL197', 'AS016', 5.16);

INSERT INTO matricula VALUES ('AL197', 'AS017', 1.06);

INSERT INTO matricula VALUES ('AL197', 'AS018', 6.88);

INSERT INTO matricula VALUES ('AL197', 'AS019', 7.92);

INSERT INTO matricula VALUES ('AL197', 'AS020', 1.88);

INSERT INTO matricula VALUES ('AL004', 'AS021', 4.23);

INSERT INTO matricula VALUES ('AL004', 'AS022', 9.65);

INSERT INTO matricula VALUES ('AL004', 'AS023', 7.75);

INSERT INTO matricula VALUES ('AL004', 'AS024', 5.76);

INSERT INTO matricula VALUES ('AL004', 'AS025', 3.43);

INSERT INTO matricula VALUES ('AL004', 'AS026', 6.95);

INSERT INTO matricula VALUES ('AL004', 'AS027', 6.91);

INSERT INTO matricula VALUES ('AL004', 'AS028', 9.76);

INSERT INTO matricula VALUES ('AL004', 'AS029', 10);

INSERT INTO matricula VALUES ('AL004', 'AS030', 4.44);

INSERT INTO matricula VALUES ('AL008', 'AS021', 8.29);

INSERT INTO matricula VALUES ('AL008', 'AS022', 4.43);

INSERT INTO matricula VALUES ('AL008', 'AS023', 4.37);

INSERT INTO matricula VALUES ('AL008', 'AS024', 5.02);

INSERT INTO matricula VALUES ('AL008', 'AS025', 8.84);

INSERT INTO matricula VALUES ('AL008', 'AS026', 4.24);

INSERT INTO matricula VALUES ('AL008', 'AS027', 8.02);

INSERT INTO matricula VALUES ('AL008', 'AS028', 4.22);

INSERT INTO matricula VALUES ('AL008', 'AS029', 9.28);

INSERT INTO matricula VALUES ('AL008', 'AS030', 6.18);

INSERT INTO matricula VALUES ('AL028', 'AS021', 6.86);

INSERT INTO matricula VALUES ('AL028', 'AS022', 8.27);

INSERT INTO matricula VALUES ('AL028', 'AS023', 8.17);

INSERT INTO matricula VALUES ('AL028', 'AS024', 6.23);

INSERT INTO matricula VALUES ('AL028', 'AS025', 3.09);

INSERT INTO matricula VALUES ('AL028', 'AS026', 7.93);

INSERT INTO matricula VALUES ('AL028', 'AS027', 3.48);

INSERT INTO matricula VALUES ('AL028', 'AS028', 2.78);

INSERT INTO matricula VALUES ('AL028', 'AS029', 4.48);

INSERT INTO matricula VALUES ('AL028', 'AS030', 8.44);

INSERT INTO matricula VALUES ('AL031', 'AS021', 8.81);

INSERT INTO matricula VALUES ('AL031', 'AS022', 10);

INSERT INTO matricula VALUES ('AL031', 'AS023', 9.58);

INSERT INTO matricula VALUES ('AL031', 'AS024', 9.96);

INSERT INTO matricula VALUES ('AL031', 'AS025', 8.89);

INSERT INTO matricula VALUES ('AL031', 'AS026', 3.94);

INSERT INTO matricula VALUES ('AL031', 'AS027', 5.14);

INSERT INTO matricula VALUES ('AL031', 'AS028', 7.58);

INSERT INTO matricula VALUES ('AL031', 'AS029', 9.94);

INSERT INTO matricula VALUES ('AL031', 'AS030', 5.68);

INSERT INTO matricula VALUES ('AL034', 'AS021', 2.41);

INSERT INTO matricula VALUES ('AL034', 'AS022', 4.49);

INSERT INTO matricula VALUES ('AL034', 'AS023', 4.23);

INSERT INTO matricula VALUES ('AL034', 'AS024', 4.02);

INSERT INTO matricula VALUES ('AL034', 'AS025', 4.34);

INSERT INTO matricula VALUES ('AL034', 'AS026', 4.95);

INSERT INTO matricula VALUES ('AL034', 'AS027', 4.18);

INSERT INTO matricula VALUES ('AL034', 'AS028', 7.49);

INSERT INTO matricula VALUES ('AL034', 'AS029', 1.48);

INSERT INTO matricula VALUES ('AL034', 'AS030', 4.84);

INSERT INTO matricula VALUES ('AL043', 'AS021', 7.19);

INSERT INTO matricula VALUES ('AL043', 'AS022', 3.09);

INSERT INTO matricula VALUES ('AL043', 'AS023', 4.62);

INSERT INTO matricula VALUES ('AL043', 'AS024', 2.35);

INSERT INTO matricula VALUES ('AL043', 'AS025', 10);

INSERT INTO matricula VALUES ('AL043', 'AS026', 2.28);

INSERT INTO matricula VALUES ('AL043', 'AS027', 9.61);

INSERT INTO matricula VALUES ('AL043', 'AS028', 7.61);

INSERT INTO matricula VALUES ('AL043', 'AS029', 4.15);

INSERT INTO matricula VALUES ('AL043', 'AS030', 8.44);

INSERT INTO matricula VALUES ('AL044', 'AS021', 1.54);

INSERT INTO matricula VALUES ('AL044', 'AS022', 4.24);

INSERT INTO matricula VALUES ('AL044', 'AS023', 7.81);

INSERT INTO matricula VALUES ('AL044', 'AS024', 4.46);

INSERT INTO matricula VALUES ('AL044', 'AS025', 2.63);

INSERT INTO matricula VALUES ('AL044', 'AS026', 8.25);

INSERT INTO matricula VALUES ('AL044', 'AS027', 9.17);

INSERT INTO matricula VALUES ('AL044', 'AS028', 2.28);

INSERT INTO matricula VALUES ('AL044', 'AS029', 3.54);

INSERT INTO matricula VALUES ('AL044', 'AS030', 8.23);

INSERT INTO matricula VALUES ('AL047', 'AS021', 9.52);

INSERT INTO matricula VALUES ('AL047', 'AS022', 6.64);

INSERT INTO matricula VALUES ('AL047', 'AS023', 5.29);

INSERT INTO matricula VALUES ('AL047', 'AS024', 2.38);

INSERT INTO matricula VALUES ('AL047', 'AS025', 2.89);

INSERT INTO matricula VALUES ('AL047', 'AS026', 10);

INSERT INTO matricula VALUES ('AL047', 'AS027', 7.09);

INSERT INTO matricula VALUES ('AL047', 'AS028', 6.49);

INSERT INTO matricula VALUES ('AL047', 'AS029', 10);

INSERT INTO matricula VALUES ('AL047', 'AS030', 3.77);

INSERT INTO matricula VALUES ('AL050', 'AS021', 7.38);

INSERT INTO matricula VALUES ('AL050', 'AS022', 3.84);

INSERT INTO matricula VALUES ('AL050', 'AS023', 3.52);

INSERT INTO matricula VALUES ('AL050', 'AS024', 8.51);

INSERT INTO matricula VALUES ('AL050', 'AS025', 8.61);

INSERT INTO matricula VALUES ('AL050', 'AS026', 3.29);

INSERT INTO matricula VALUES ('AL050', 'AS027', 8.92);

INSERT INTO matricula VALUES ('AL050', 'AS028', 4.82);

INSERT INTO matricula VALUES ('AL050', 'AS029', 6.23);

INSERT INTO matricula VALUES ('AL050', 'AS030', 8.41);

INSERT INTO matricula VALUES ('AL055', 'AS021', 7.06);

INSERT INTO matricula VALUES ('AL055', 'AS022', 5.11);

INSERT INTO matricula VALUES ('AL055', 'AS023', 6.52);

INSERT INTO matricula VALUES ('AL055', 'AS024', 1.57);

INSERT INTO matricula VALUES ('AL055', 'AS025', 5.11);

INSERT INTO matricula VALUES ('AL055', 'AS026', 6.01);

INSERT INTO matricula VALUES ('AL055', 'AS027', 8.09);

INSERT INTO matricula VALUES ('AL055', 'AS028', 6.87);

INSERT INTO matricula VALUES ('AL055', 'AS029', 6.58);

INSERT INTO matricula VALUES ('AL055', 'AS030', 8.19);

INSERT INTO matricula VALUES ('AL059', 'AS021', 5.32);

INSERT INTO matricula VALUES ('AL059', 'AS022', 8.42);

INSERT INTO matricula VALUES ('AL059', 'AS023', 2.42);

INSERT INTO matricula VALUES ('AL059', 'AS024', 6.73);

INSERT INTO matricula VALUES ('AL059', 'AS025', 7.85);

INSERT INTO matricula VALUES ('AL059', 'AS026', 6.41);

INSERT INTO matricula VALUES ('AL059', 'AS027', 4.38);

INSERT INTO matricula VALUES ('AL059', 'AS028', 1.55);

INSERT INTO matricula VALUES ('AL059', 'AS029', 5.98);

INSERT INTO matricula VALUES ('AL059', 'AS030', 7.12);

INSERT INTO matricula VALUES ('AL071', 'AS021', 1.09);

INSERT INTO matricula VALUES ('AL071', 'AS022', 7.36);

INSERT INTO matricula VALUES ('AL071', 'AS023', 8.77);

INSERT INTO matricula VALUES ('AL071', 'AS024', 1.16);

INSERT INTO matricula VALUES ('AL071', 'AS025', 6.57);

INSERT INTO matricula VALUES ('AL071', 'AS026', 6.69);

INSERT INTO matricula VALUES ('AL071', 'AS027', 10);

INSERT INTO matricula VALUES ('AL071', 'AS028', 5.97);

INSERT INTO matricula VALUES ('AL071', 'AS029', 8.96);

INSERT INTO matricula VALUES ('AL071', 'AS030', 10);

INSERT INTO matricula VALUES ('AL072', 'AS021', 8.73);

INSERT INTO matricula VALUES ('AL072', 'AS022', 2.77);

INSERT INTO matricula VALUES ('AL072', 'AS023', 9.48);

INSERT INTO matricula VALUES ('AL072', 'AS024', 3.73);

INSERT INTO matricula VALUES ('AL072', 'AS025', 2.78);

INSERT INTO matricula VALUES ('AL072', 'AS026', 9.39);

INSERT INTO matricula VALUES ('AL072', 'AS027', 3.79);

INSERT INTO matricula VALUES ('AL072', 'AS028', 3.91);

INSERT INTO matricula VALUES ('AL072', 'AS029', 10);

INSERT INTO matricula VALUES ('AL072', 'AS030', 7.68);

INSERT INTO matricula VALUES ('AL073', 'AS021', 6.16);

INSERT INTO matricula VALUES ('AL073', 'AS022', 1.07);

INSERT INTO matricula VALUES ('AL073', 'AS023', 6.88);

INSERT INTO matricula VALUES ('AL073', 'AS024', 6.71);

INSERT INTO matricula VALUES ('AL073', 'AS025', 5.65);

INSERT INTO matricula VALUES ('AL073', 'AS026', 1.56);

INSERT INTO matricula VALUES ('AL073', 'AS027', 7.25);

INSERT INTO matricula VALUES ('AL073', 'AS028', 6.49);

INSERT INTO matricula VALUES ('AL073', 'AS029', 10);

INSERT INTO matricula VALUES ('AL073', 'AS030', 9.96);

INSERT INTO matricula VALUES ('AL078', 'AS021', 2.55);

INSERT INTO matricula VALUES ('AL078', 'AS022', 5.26);

INSERT INTO matricula VALUES ('AL078', 'AS023', 10);

INSERT INTO matricula VALUES ('AL078', 'AS024', 8.54);

INSERT INTO matricula VALUES ('AL078', 'AS025', 10);

INSERT INTO matricula VALUES ('AL078', 'AS026', 7.33);

INSERT INTO matricula VALUES ('AL078', 'AS027', 10);

INSERT INTO matricula VALUES ('AL078', 'AS028', 8.33);

INSERT INTO matricula VALUES ('AL078', 'AS029', 9.67);

INSERT INTO matricula VALUES ('AL078', 'AS030', 9.41);

INSERT INTO matricula VALUES ('AL080', 'AS021', 10);

INSERT INTO matricula VALUES ('AL080', 'AS022', 9.79);

INSERT INTO matricula VALUES ('AL080', 'AS023', 2.66);

INSERT INTO matricula VALUES ('AL080', 'AS024', 4.31);

INSERT INTO matricula VALUES ('AL080', 'AS025', 2.06);

INSERT INTO matricula VALUES ('AL080', 'AS026', 10);

INSERT INTO matricula VALUES ('AL080', 'AS027', 9.78);

INSERT INTO matricula VALUES ('AL080', 'AS028', 1.11);

INSERT INTO matricula VALUES ('AL080', 'AS029', 9.78);

INSERT INTO matricula VALUES ('AL080', 'AS030', 6.94);

INSERT INTO matricula VALUES ('AL083', 'AS021', 7.58);

INSERT INTO matricula VALUES ('AL083', 'AS022', 8.97);

INSERT INTO matricula VALUES ('AL083', 'AS023', 4.07);

INSERT INTO matricula VALUES ('AL083', 'AS024', 10);

INSERT INTO matricula VALUES ('AL083', 'AS025', 6.61);

INSERT INTO matricula VALUES ('AL083', 'AS026', 7.43);

INSERT INTO matricula VALUES ('AL083', 'AS027', 6.51);

INSERT INTO matricula VALUES ('AL083', 'AS028', 7.78);

INSERT INTO matricula VALUES ('AL083', 'AS029', 1.68);

INSERT INTO matricula VALUES ('AL083', 'AS030', 9.43);

INSERT INTO matricula VALUES ('AL095', 'AS021', 1.11);

INSERT INTO matricula VALUES ('AL095', 'AS022', 3.49);

INSERT INTO matricula VALUES ('AL095', 'AS023', 4.17);

INSERT INTO matricula VALUES ('AL095', 'AS024', 9.43);

INSERT INTO matricula VALUES ('AL095', 'AS025', 2.64);

INSERT INTO matricula VALUES ('AL095', 'AS026', 7.05);

INSERT INTO matricula VALUES ('AL095', 'AS027', 1.21);

INSERT INTO matricula VALUES ('AL095', 'AS028', 6.49);

INSERT INTO matricula VALUES ('AL095', 'AS029', 10);

INSERT INTO matricula VALUES ('AL095', 'AS030', 8.91);

INSERT INTO matricula VALUES ('AL096', 'AS021', 9.15);

INSERT INTO matricula VALUES ('AL096', 'AS022', 4.63);

INSERT INTO matricula VALUES ('AL096', 'AS023', 2.51);

INSERT INTO matricula VALUES ('AL096', 'AS024', 2.53);

INSERT INTO matricula VALUES ('AL096', 'AS025', 3.02);

INSERT INTO matricula VALUES ('AL096', 'AS026', 3.13);

INSERT INTO matricula VALUES ('AL096', 'AS027', 5.75);

INSERT INTO matricula VALUES ('AL096', 'AS028', 1.35);

INSERT INTO matricula VALUES ('AL096', 'AS029', 8.63);

INSERT INTO matricula VALUES ('AL096', 'AS030', 9.47);

INSERT INTO matricula VALUES ('AL098', 'AS021', 9.84);

INSERT INTO matricula VALUES ('AL098', 'AS022', 4.29);

INSERT INTO matricula VALUES ('AL098', 'AS023', 9.96);

INSERT INTO matricula VALUES ('AL098', 'AS024', 10);

INSERT INTO matricula VALUES ('AL098', 'AS025', 6.98);

INSERT INTO matricula VALUES ('AL098', 'AS026', 10);

INSERT INTO matricula VALUES ('AL098', 'AS027', 4.95);

INSERT INTO matricula VALUES ('AL098', 'AS028', 2.91);

INSERT INTO matricula VALUES ('AL098', 'AS029', 7.88);

INSERT INTO matricula VALUES ('AL098', 'AS030', 7.41);

INSERT INTO matricula VALUES ('AL105', 'AS021', 7.86);

INSERT INTO matricula VALUES ('AL105', 'AS022', 7.38);

INSERT INTO matricula VALUES ('AL105', 'AS023', 4.55);

INSERT INTO matricula VALUES ('AL105', 'AS024', 10);

INSERT INTO matricula VALUES ('AL105', 'AS025', 1.49);

INSERT INTO matricula VALUES ('AL105', 'AS026', 7.14);

INSERT INTO matricula VALUES ('AL105', 'AS027', 5.21);

INSERT INTO matricula VALUES ('AL105', 'AS028', 1.09);

INSERT INTO matricula VALUES ('AL105', 'AS029', 4.38);

INSERT INTO matricula VALUES ('AL105', 'AS030', 1.49);

INSERT INTO matricula VALUES ('AL110', 'AS021', 5.84);

INSERT INTO matricula VALUES ('AL110', 'AS022', 4.59);

INSERT INTO matricula VALUES ('AL110', 'AS023', 1.15);

INSERT INTO matricula VALUES ('AL110', 'AS024', 6.59);

INSERT INTO matricula VALUES ('AL110', 'AS025', 6.18);

INSERT INTO matricula VALUES ('AL110', 'AS026', 8.56);

INSERT INTO matricula VALUES ('AL110', 'AS027', 10);

INSERT INTO matricula VALUES ('AL110', 'AS028', 5.91);

INSERT INTO matricula VALUES ('AL110', 'AS029', 1.76);

INSERT INTO matricula VALUES ('AL110', 'AS030', 9.63);

INSERT INTO matricula VALUES ('AL122', 'AS021', 4.36);

INSERT INTO matricula VALUES ('AL122', 'AS022', 10);

INSERT INTO matricula VALUES ('AL122', 'AS023', 1.58);

INSERT INTO matricula VALUES ('AL122', 'AS024', 1.32);

INSERT INTO matricula VALUES ('AL122', 'AS025', 7.77);

INSERT INTO matricula VALUES ('AL122', 'AS026', 10);

INSERT INTO matricula VALUES ('AL122', 'AS027', 1.19);

INSERT INTO matricula VALUES ('AL122', 'AS028', 10);

INSERT INTO matricula VALUES ('AL122', 'AS029', 2.53);

INSERT INTO matricula VALUES ('AL122', 'AS030', 3.28);

INSERT INTO matricula VALUES ('AL124', 'AS021', 6.77);

INSERT INTO matricula VALUES ('AL124', 'AS022', 9.94);

INSERT INTO matricula VALUES ('AL124', 'AS023', 8.61);

INSERT INTO matricula VALUES ('AL124', 'AS024', 10);

INSERT INTO matricula VALUES ('AL124', 'AS025', 9.95);

INSERT INTO matricula VALUES ('AL124', 'AS026', 7.88);

INSERT INTO matricula VALUES ('AL124', 'AS027', 8.42);

INSERT INTO matricula VALUES ('AL124', 'AS028', 7.24);

INSERT INTO matricula VALUES ('AL124', 'AS029', 8.95);

INSERT INTO matricula VALUES ('AL124', 'AS030', 4.54);

INSERT INTO matricula VALUES ('AL127', 'AS021', 6.65);

INSERT INTO matricula VALUES ('AL127', 'AS022', 9.93);

INSERT INTO matricula VALUES ('AL127', 'AS023', 9.18);

INSERT INTO matricula VALUES ('AL127', 'AS024', 9.99);

INSERT INTO matricula VALUES ('AL127', 'AS025', 6.19);

INSERT INTO matricula VALUES ('AL127', 'AS026', 4.93);

INSERT INTO matricula VALUES ('AL127', 'AS027', 4.37);

INSERT INTO matricula VALUES ('AL127', 'AS028', 2.36);

INSERT INTO matricula VALUES ('AL127', 'AS029', 7.57);

INSERT INTO matricula VALUES ('AL127', 'AS030', 3.96);

INSERT INTO matricula VALUES ('AL134', 'AS021', 10);

INSERT INTO matricula VALUES ('AL134', 'AS022', 6.29);

INSERT INTO matricula VALUES ('AL134', 'AS023', 2.51);

INSERT INTO matricula VALUES ('AL134', 'AS024', 5.71);

INSERT INTO matricula VALUES ('AL134', 'AS025', 9.99);

INSERT INTO matricula VALUES ('AL134', 'AS026', 5.24);

INSERT INTO matricula VALUES ('AL134', 'AS027', 6.06);

INSERT INTO matricula VALUES ('AL134', 'AS028', 6.67);

INSERT INTO matricula VALUES ('AL134', 'AS029', 4.34);

INSERT INTO matricula VALUES ('AL134', 'AS030', 5.72);

INSERT INTO matricula VALUES ('AL139', 'AS021', 2.85);

INSERT INTO matricula VALUES ('AL139', 'AS022', 9.68);

INSERT INTO matricula VALUES ('AL139', 'AS023', 4.12);

INSERT INTO matricula VALUES ('AL139', 'AS024', 9.82);

INSERT INTO matricula VALUES ('AL139', 'AS025', 1.74);

INSERT INTO matricula VALUES ('AL139', 'AS026', 8.16);

INSERT INTO matricula VALUES ('AL139', 'AS027', 2.65);

INSERT INTO matricula VALUES ('AL139', 'AS028', 3.22);

INSERT INTO matricula VALUES ('AL139', 'AS029', 5.36);

INSERT INTO matricula VALUES ('AL139', 'AS030', 6.46);

INSERT INTO matricula VALUES ('AL145', 'AS021', 7.93);

INSERT INTO matricula VALUES ('AL145', 'AS022', 7.73);

INSERT INTO matricula VALUES ('AL145', 'AS023', 9.09);

INSERT INTO matricula VALUES ('AL145', 'AS024', 3.45);

INSERT INTO matricula VALUES ('AL145', 'AS025', 5.14);

INSERT INTO matricula VALUES ('AL145', 'AS026', 3.51);

INSERT INTO matricula VALUES ('AL145', 'AS027', 2.27);

INSERT INTO matricula VALUES ('AL145', 'AS028', 8.77);

INSERT INTO matricula VALUES ('AL145', 'AS029', 10);

INSERT INTO matricula VALUES ('AL145', 'AS030', 9.48);

INSERT INTO matricula VALUES ('AL146', 'AS021', 1.12);

INSERT INTO matricula VALUES ('AL146', 'AS022', 8.63);

INSERT INTO matricula VALUES ('AL146', 'AS023', 9.93);

INSERT INTO matricula VALUES ('AL146', 'AS024', 3.02);

INSERT INTO matricula VALUES ('AL146', 'AS025', 7.41);

INSERT INTO matricula VALUES ('AL146', 'AS026', 4.95);

INSERT INTO matricula VALUES ('AL146', 'AS027', 7.57);

INSERT INTO matricula VALUES ('AL146', 'AS028', 1.37);

INSERT INTO matricula VALUES ('AL146', 'AS029', 3.94);

INSERT INTO matricula VALUES ('AL146', 'AS030', 5.42);

INSERT INTO matricula VALUES ('AL149', 'AS021', 3.05);

INSERT INTO matricula VALUES ('AL149', 'AS022', 4.22);

INSERT INTO matricula VALUES ('AL149', 'AS023', 6.94);

INSERT INTO matricula VALUES ('AL149', 'AS024', 9.53);

INSERT INTO matricula VALUES ('AL149', 'AS025', 5.59);

INSERT INTO matricula VALUES ('AL149', 'AS026', 1.57);

INSERT INTO matricula VALUES ('AL149', 'AS027', 5.06);

INSERT INTO matricula VALUES ('AL149', 'AS028', 5.22);

INSERT INTO matricula VALUES ('AL149', 'AS029', 6.79);

INSERT INTO matricula VALUES ('AL149', 'AS030', 5.65);

INSERT INTO matricula VALUES ('AL150', 'AS021', 7.13);

INSERT INTO matricula VALUES ('AL150', 'AS022', 2.77);

INSERT INTO matricula VALUES ('AL150', 'AS023', 2.18);

INSERT INTO matricula VALUES ('AL150', 'AS024', 9.09);

INSERT INTO matricula VALUES ('AL150', 'AS025', 5.36);

INSERT INTO matricula VALUES ('AL150', 'AS026', 1.98);

INSERT INTO matricula VALUES ('AL150', 'AS027', 4.18);

INSERT INTO matricula VALUES ('AL150', 'AS028', 5.43);

INSERT INTO matricula VALUES ('AL150', 'AS029', 6.72);

INSERT INTO matricula VALUES ('AL150', 'AS030', 2.83);

INSERT INTO matricula VALUES ('AL153', 'AS021', 9.35);

INSERT INTO matricula VALUES ('AL153', 'AS022', 9.31);

INSERT INTO matricula VALUES ('AL153', 'AS023', 6.82);

INSERT INTO matricula VALUES ('AL153', 'AS024', 1.73);

INSERT INTO matricula VALUES ('AL153', 'AS025', 7.51);

INSERT INTO matricula VALUES ('AL153', 'AS026', 7.36);

INSERT INTO matricula VALUES ('AL153', 'AS027', 5.64);

INSERT INTO matricula VALUES ('AL153', 'AS028', 5.53);

INSERT INTO matricula VALUES ('AL153', 'AS029', 2.77);

INSERT INTO matricula VALUES ('AL153', 'AS030', 6.84);

INSERT INTO matricula VALUES ('AL155', 'AS021', 9.63);

INSERT INTO matricula VALUES ('AL155', 'AS022', 3.13);

INSERT INTO matricula VALUES ('AL155', 'AS023', 6.86);

INSERT INTO matricula VALUES ('AL155', 'AS024', 10);

INSERT INTO matricula VALUES ('AL155', 'AS025', 9.21);

INSERT INTO matricula VALUES ('AL155', 'AS026', 2.79);

INSERT INTO matricula VALUES ('AL155', 'AS027', 3.74);

INSERT INTO matricula VALUES ('AL155', 'AS028', 9.17);

INSERT INTO matricula VALUES ('AL155', 'AS029', 4.21);

INSERT INTO matricula VALUES ('AL155', 'AS030', 2.85);

INSERT INTO matricula VALUES ('AL157', 'AS021', 7.77);

INSERT INTO matricula VALUES ('AL157', 'AS022', 5.23);

INSERT INTO matricula VALUES ('AL157', 'AS023', 8.04);

INSERT INTO matricula VALUES ('AL157', 'AS024', 8.22);

INSERT INTO matricula VALUES ('AL157', 'AS025', 9.41);

INSERT INTO matricula VALUES ('AL157', 'AS026', 10);

INSERT INTO matricula VALUES ('AL157', 'AS027', 2.73);

INSERT INTO matricula VALUES ('AL157', 'AS028', 5.97);

INSERT INTO matricula VALUES ('AL157', 'AS029', 6.61);

INSERT INTO matricula VALUES ('AL157', 'AS030', 5.17);

INSERT INTO matricula VALUES ('AL162', 'AS021', 2.79);

INSERT INTO matricula VALUES ('AL162', 'AS022', 5.98);

INSERT INTO matricula VALUES ('AL162', 'AS023', 7.96);

INSERT INTO matricula VALUES ('AL162', 'AS024', 4.94);

INSERT INTO matricula VALUES ('AL162', 'AS025', 3.23);

INSERT INTO matricula VALUES ('AL162', 'AS026', 10);

INSERT INTO matricula VALUES ('AL162', 'AS027', 1.82);

INSERT INTO matricula VALUES ('AL162', 'AS028', 7.51);

INSERT INTO matricula VALUES ('AL162', 'AS029', 7.68);

INSERT INTO matricula VALUES ('AL162', 'AS030', 5.39);

INSERT INTO matricula VALUES ('AL175', 'AS021', 1.72);

INSERT INTO matricula VALUES ('AL175', 'AS022', 10);

INSERT INTO matricula VALUES ('AL175', 'AS023', 8.96);

INSERT INTO matricula VALUES ('AL175', 'AS024', 5.91);

INSERT INTO matricula VALUES ('AL175', 'AS025', 5.61);

INSERT INTO matricula VALUES ('AL175', 'AS026', 10);

INSERT INTO matricula VALUES ('AL175', 'AS027', 4.84);

INSERT INTO matricula VALUES ('AL175', 'AS028', 9.16);

INSERT INTO matricula VALUES ('AL175', 'AS029', 2.25);

INSERT INTO matricula VALUES ('AL175', 'AS030', 4.65);

INSERT INTO matricula VALUES ('AL180', 'AS021', 6.47);

INSERT INTO matricula VALUES ('AL180', 'AS022', 10);

INSERT INTO matricula VALUES ('AL180', 'AS023', 5.44);

INSERT INTO matricula VALUES ('AL180', 'AS024', 4.55);

INSERT INTO matricula VALUES ('AL180', 'AS025', 3.55);

INSERT INTO matricula VALUES ('AL180', 'AS026', 8.63);

INSERT INTO matricula VALUES ('AL180', 'AS027', 5.83);

INSERT INTO matricula VALUES ('AL180', 'AS028', 9.46);

INSERT INTO matricula VALUES ('AL180', 'AS029', 8.87);

INSERT INTO matricula VALUES ('AL180', 'AS030', 2.12);

INSERT INTO matricula VALUES ('AL186', 'AS021', 10);

INSERT INTO matricula VALUES ('AL186', 'AS022', 5.45);

INSERT INTO matricula VALUES ('AL186', 'AS023', 8.57);

INSERT INTO matricula VALUES ('AL186', 'AS024', 2.89);

INSERT INTO matricula VALUES ('AL186', 'AS025', 1.53);

INSERT INTO matricula VALUES ('AL186', 'AS026', 4.22);

INSERT INTO matricula VALUES ('AL186', 'AS027', 4.29);

INSERT INTO matricula VALUES ('AL186', 'AS028', 1.09);

INSERT INTO matricula VALUES ('AL186', 'AS029', 7.07);

INSERT INTO matricula VALUES ('AL186', 'AS030', 7.07);

INSERT INTO matricula VALUES ('AL192', 'AS021', 6.03);

INSERT INTO matricula VALUES ('AL192', 'AS022', 8.51);

INSERT INTO matricula VALUES ('AL192', 'AS023', 6.85);

INSERT INTO matricula VALUES ('AL192', 'AS024', 4.54);

INSERT INTO matricula VALUES ('AL192', 'AS025', 10);

INSERT INTO matricula VALUES ('AL192', 'AS026', 9.55);

INSERT INTO matricula VALUES ('AL192', 'AS027', 5.32);

INSERT INTO matricula VALUES ('AL192', 'AS028', 4.35);

INSERT INTO matricula VALUES ('AL192', 'AS029', 9.28);

INSERT INTO matricula VALUES ('AL192', 'AS030', 9.09);

INSERT INTO matricula VALUES ('AL196', 'AS021', 1.97);

INSERT INTO matricula VALUES ('AL196', 'AS022', 8.52);

INSERT INTO matricula VALUES ('AL196', 'AS023', 4.95);

INSERT INTO matricula VALUES ('AL196', 'AS024', 7.35);

INSERT INTO matricula VALUES ('AL196', 'AS025', 10);

INSERT INTO matricula VALUES ('AL196', 'AS026', 10);

INSERT INTO matricula VALUES ('AL196', 'AS027', 8.17);

INSERT INTO matricula VALUES ('AL196', 'AS028', 1.93);

INSERT INTO matricula VALUES ('AL196', 'AS029', 9.81);

INSERT INTO matricula VALUES ('AL196', 'AS030', 1.07);

INSERT INTO matricula VALUES ('AL002', 'AS031', 8.69);

INSERT INTO matricula VALUES ('AL002', 'AS032', 6.57);

INSERT INTO matricula VALUES ('AL002', 'AS033', 10);

INSERT INTO matricula VALUES ('AL002', 'AS034', 6.58);

INSERT INTO matricula VALUES ('AL002', 'AS035', 8.51);

INSERT INTO matricula VALUES ('AL002', 'AS080', 7.17);

INSERT INTO matricula VALUES ('AL002', 'AS067', 5.62);

INSERT INTO matricula VALUES ('AL002', 'AS070', 10);

INSERT INTO matricula VALUES ('AL002', 'AS053', 6.99);

INSERT INTO matricula VALUES ('AL002', 'AS078', 1.38);

INSERT INTO matricula VALUES ('AL005', 'AS031', 7.92);

INSERT INTO matricula VALUES ('AL005', 'AS032', 1.06);

INSERT INTO matricula VALUES ('AL005', 'AS033', 8.27);

INSERT INTO matricula VALUES ('AL005', 'AS034', 3.08);

INSERT INTO matricula VALUES ('AL005', 'AS035', 1.35);

INSERT INTO matricula VALUES ('AL005', 'AS048', 10);

INSERT INTO matricula VALUES ('AL005', 'AS051', 7.39);

INSERT INTO matricula VALUES ('AL005', 'AS038', 3.16);

INSERT INTO matricula VALUES ('AL005', 'AS083', 6.77);

INSERT INTO matricula VALUES ('AL005', 'AS058', 6.64);

INSERT INTO matricula VALUES ('AL012', 'AS031', 3.52);

INSERT INTO matricula VALUES ('AL012', 'AS032', 5.69);

INSERT INTO matricula VALUES ('AL012', 'AS033', 8.33);

INSERT INTO matricula VALUES ('AL012', 'AS034', 6.85);

INSERT INTO matricula VALUES ('AL012', 'AS035', 6.03);

INSERT INTO matricula VALUES ('AL012', 'AS071', 1.16);

INSERT INTO matricula VALUES ('AL012', 'AS081', 3.91);

INSERT INTO matricula VALUES ('AL012', 'AS053', 3.53);

INSERT INTO matricula VALUES ('AL012', 'AS048', 1.31);

INSERT INTO matricula VALUES ('AL012', 'AS041', 5.59);

INSERT INTO matricula VALUES ('AL013', 'AS031', 6.43);

INSERT INTO matricula VALUES ('AL013', 'AS032', 7.02);

INSERT INTO matricula VALUES ('AL013', 'AS033', 5.61);

INSERT INTO matricula VALUES ('AL013', 'AS034', 1.89);

INSERT INTO matricula VALUES ('AL013', 'AS035', 6.83);

INSERT INTO matricula VALUES ('AL013', 'AS044', 2.84);

INSERT INTO matricula VALUES ('AL013', 'AS071', 2.06);

INSERT INTO matricula VALUES ('AL013', 'AS066', 1.47);

INSERT INTO matricula VALUES ('AL013', 'AS070', 7.07);

INSERT INTO matricula VALUES ('AL013', 'AS039', 10);

INSERT INTO matricula VALUES ('AL014', 'AS031', 8.42);

INSERT INTO matricula VALUES ('AL014', 'AS032', 8.57);

INSERT INTO matricula VALUES ('AL014', 'AS033', 7.06);

INSERT INTO matricula VALUES ('AL014', 'AS034', 4.76);

INSERT INTO matricula VALUES ('AL014', 'AS035', 5.67);

INSERT INTO matricula VALUES ('AL014', 'AS058', 4.65);

INSERT INTO matricula VALUES ('AL014', 'AS044', 8.52);

INSERT INTO matricula VALUES ('AL014', 'AS046', 7.62);

INSERT INTO matricula VALUES ('AL014', 'AS037', 4.42);

INSERT INTO matricula VALUES ('AL014', 'AS046', 1.63);

INSERT INTO matricula VALUES ('AL016', 'AS031', 3.45);

INSERT INTO matricula VALUES ('AL016', 'AS032', 4.33);

INSERT INTO matricula VALUES ('AL016', 'AS033', 1.89);

INSERT INTO matricula VALUES ('AL016', 'AS034', 10);

INSERT INTO matricula VALUES ('AL016', 'AS035', 1.02);

INSERT INTO matricula VALUES ('AL016', 'AS046', 1.52);

INSERT INTO matricula VALUES ('AL016', 'AS070', 4.79);

INSERT INTO matricula VALUES ('AL016', 'AS039', 4.37);

INSERT INTO matricula VALUES ('AL016', 'AS061', 4.49);

INSERT INTO matricula VALUES ('AL016', 'AS059', 6.75);

INSERT INTO matricula VALUES ('AL018', 'AS031', 9.39);

INSERT INTO matricula VALUES ('AL018', 'AS032', 10);

INSERT INTO matricula VALUES ('AL018', 'AS033', 1.45);

INSERT INTO matricula VALUES ('AL018', 'AS034', 4.16);

INSERT INTO matricula VALUES ('AL018', 'AS035', 10);

INSERT INTO matricula VALUES ('AL018', 'AS068', 2.75);

INSERT INTO matricula VALUES ('AL018', 'AS043', 3.75);

INSERT INTO matricula VALUES ('AL018', 'AS083', 4.73);

INSERT INTO matricula VALUES ('AL018', 'AS071', 3.36);

INSERT INTO matricula VALUES ('AL018', 'AS067', 4.55);

INSERT INTO matricula VALUES ('AL021', 'AS031', 9.38);

INSERT INTO matricula VALUES ('AL021', 'AS032', 5.32);

INSERT INTO matricula VALUES ('AL021', 'AS033', 6.82);

INSERT INTO matricula VALUES ('AL021', 'AS034', 5.69);

INSERT INTO matricula VALUES ('AL021', 'AS035', 6.99);

INSERT INTO matricula VALUES ('AL021', 'AS083', 2.32);

INSERT INTO matricula VALUES ('AL021', 'AS041', 5.79);

INSERT INTO matricula VALUES ('AL021', 'AS069', 5.85);

INSERT INTO matricula VALUES ('AL021', 'AS062', 2.69);

INSERT INTO matricula VALUES ('AL021', 'AS067', 9.45);

INSERT INTO matricula VALUES ('AL022', 'AS031', 7.15);

INSERT INTO matricula VALUES ('AL022', 'AS032', 5.75);

INSERT INTO matricula VALUES ('AL022', 'AS033', 10);

INSERT INTO matricula VALUES ('AL022', 'AS034', 9.02);

INSERT INTO matricula VALUES ('AL022', 'AS035', 1.17);

INSERT INTO matricula VALUES ('AL022', 'AS070', 3.36);

INSERT INTO matricula VALUES ('AL022', 'AS051', 10);

INSERT INTO matricula VALUES ('AL022', 'AS067', 5.51);

INSERT INTO matricula VALUES ('AL022', 'AS038', 10);

INSERT INTO matricula VALUES ('AL022', 'AS077', 3.62);

INSERT INTO matricula VALUES ('AL033', 'AS031', 3.73);

INSERT INTO matricula VALUES ('AL033', 'AS032', 10);

INSERT INTO matricula VALUES ('AL033', 'AS033', 6.45);

INSERT INTO matricula VALUES ('AL033', 'AS034', 8.51);

INSERT INTO matricula VALUES ('AL033', 'AS035', 1.23);

INSERT INTO matricula VALUES ('AL033', 'AS080', 10);

INSERT INTO matricula VALUES ('AL033', 'AS042', 10);

INSERT INTO matricula VALUES ('AL033', 'AS043', 7.16);

INSERT INTO matricula VALUES ('AL033', 'AS071', 1.84);

INSERT INTO matricula VALUES ('AL033', 'AS064', 7.88);

INSERT INTO matricula VALUES ('AL036', 'AS031', 1.43);

INSERT INTO matricula VALUES ('AL036', 'AS032', 9.69);

INSERT INTO matricula VALUES ('AL036', 'AS033', 6.67);

INSERT INTO matricula VALUES ('AL036', 'AS034', 4.39);

INSERT INTO matricula VALUES ('AL036', 'AS035', 8.95);

INSERT INTO matricula VALUES ('AL036', 'AS046', 10);

INSERT INTO matricula VALUES ('AL036', 'AS044', 7.88);

INSERT INTO matricula VALUES ('AL036', 'AS047', 6.43);

INSERT INTO matricula VALUES ('AL036', 'AS047', 9.43);

INSERT INTO matricula VALUES ('AL036', 'AS061', 8.32);

INSERT INTO matricula VALUES ('AL039', 'AS031', 5.79);

INSERT INTO matricula VALUES ('AL039', 'AS032', 1.97);

INSERT INTO matricula VALUES ('AL039', 'AS033', 9.78);

INSERT INTO matricula VALUES ('AL039', 'AS034', 7.33);

INSERT INTO matricula VALUES ('AL039', 'AS035', 5.11);

INSERT INTO matricula VALUES ('AL039', 'AS037', 6.51);

INSERT INTO matricula VALUES ('AL039', 'AS046', 5.22);

INSERT INTO matricula VALUES ('AL039', 'AS075', 2.11);

INSERT INTO matricula VALUES ('AL039', 'AS043', 7.88);

INSERT INTO matricula VALUES ('AL039', 'AS078', 2.48);

INSERT INTO matricula VALUES ('AL041', 'AS031', 9.42);

INSERT INTO matricula VALUES ('AL041', 'AS032', 3.82);

INSERT INTO matricula VALUES ('AL041', 'AS033', 9.26);

INSERT INTO matricula VALUES ('AL041', 'AS034', 9.57);

INSERT INTO matricula VALUES ('AL041', 'AS035', 1.76);

INSERT INTO matricula VALUES ('AL041', 'AS047', 3.96);

INSERT INTO matricula VALUES ('AL041', 'AS043', 8.76);

INSERT INTO matricula VALUES ('AL041', 'AS078', 10);

INSERT INTO matricula VALUES ('AL041', 'AS051', 7.25);

INSERT INTO matricula VALUES ('AL041', 'AS040', 3.67);

INSERT INTO matricula VALUES ('AL042', 'AS031', 5.11);

INSERT INTO matricula VALUES ('AL042', 'AS032', 7.08);

INSERT INTO matricula VALUES ('AL042', 'AS033', 3.67);

INSERT INTO matricula VALUES ('AL042', 'AS034', 10);

INSERT INTO matricula VALUES ('AL042', 'AS035', 2.72);

INSERT INTO matricula VALUES ('AL042', 'AS053', 10);

INSERT INTO matricula VALUES ('AL042', 'AS074', 1.17);

INSERT INTO matricula VALUES ('AL042', 'AS044', 8.14);

INSERT INTO matricula VALUES ('AL042', 'AS068', 9.86);

INSERT INTO matricula VALUES ('AL042', 'AS067', 10);

INSERT INTO matricula VALUES ('AL046', 'AS031', 2.59);

INSERT INTO matricula VALUES ('AL046', 'AS032', 8.45);

INSERT INTO matricula VALUES ('AL046', 'AS033', 7.81);

INSERT INTO matricula VALUES ('AL046', 'AS034', 1.81);

INSERT INTO matricula VALUES ('AL046', 'AS035', 4.55);

INSERT INTO matricula VALUES ('AL046', 'AS069', 8.78);

INSERT INTO matricula VALUES ('AL046', 'AS066', 10);

INSERT INTO matricula VALUES ('AL046', 'AS048', 1.88);

INSERT INTO matricula VALUES ('AL046', 'AS076', 5.88);

INSERT INTO matricula VALUES ('AL046', 'AS047', 7.64);

INSERT INTO matricula VALUES ('AL049', 'AS031', 4.78);

INSERT INTO matricula VALUES ('AL049', 'AS032', 10);

INSERT INTO matricula VALUES ('AL049', 'AS033', 1.61);

INSERT INTO matricula VALUES ('AL049', 'AS034', 6.94);

INSERT INTO matricula VALUES ('AL049', 'AS035', 2.09);

INSERT INTO matricula VALUES ('AL049', 'AS080', 9.15);

INSERT INTO matricula VALUES ('AL049', 'AS047', 9.55);

INSERT INTO matricula VALUES ('AL049', 'AS069', 6.48);

INSERT INTO matricula VALUES ('AL049', 'AS078', 1.38);

INSERT INTO matricula VALUES ('AL049', 'AS044', 9.23);

INSERT INTO matricula VALUES ('AL060', 'AS031', 9.95);

INSERT INTO matricula VALUES ('AL060', 'AS032', 6.28);

INSERT INTO matricula VALUES ('AL060', 'AS033', 5.35);

INSERT INTO matricula VALUES ('AL060', 'AS034', 4.44);

INSERT INTO matricula VALUES ('AL060', 'AS035', 1.15);

INSERT INTO matricula VALUES ('AL060', 'AS039', 7.36);

INSERT INTO matricula VALUES ('AL060', 'AS045', 8.04);

INSERT INTO matricula VALUES ('AL060', 'AS074', 10);

INSERT INTO matricula VALUES ('AL060', 'AS051', 10);

INSERT INTO matricula VALUES ('AL060', 'AS081', 2.65);

INSERT INTO matricula VALUES ('AL065', 'AS031', 6.74);

INSERT INTO matricula VALUES ('AL065', 'AS032', 6.24);

INSERT INTO matricula VALUES ('AL065', 'AS033', 7.25);

INSERT INTO matricula VALUES ('AL065', 'AS034', 1.91);

INSERT INTO matricula VALUES ('AL065', 'AS035', 7.11);

INSERT INTO matricula VALUES ('AL065', 'AS044', 7.12);

INSERT INTO matricula VALUES ('AL065', 'AS064', 6.15);

INSERT INTO matricula VALUES ('AL065', 'AS053', 5.91);

INSERT INTO matricula VALUES ('AL065', 'AS037', 9.08);

INSERT INTO matricula VALUES ('AL065', 'AS047', 6.47);

INSERT INTO matricula VALUES ('AL067', 'AS031', 8.41);

INSERT INTO matricula VALUES ('AL067', 'AS032', 9.86);

INSERT INTO matricula VALUES ('AL067', 'AS033', 4.55);

INSERT INTO matricula VALUES ('AL067', 'AS034', 6.92);

INSERT INTO matricula VALUES ('AL067', 'AS035', 6.41);

INSERT INTO matricula VALUES ('AL067', 'AS074', 4.28);

INSERT INTO matricula VALUES ('AL067', 'AS064', 2.07);

INSERT INTO matricula VALUES ('AL067', 'AS080', 8.14);

INSERT INTO matricula VALUES ('AL067', 'AS047', 4.98);

INSERT INTO matricula VALUES ('AL067', 'AS083', 4.52);

INSERT INTO matricula VALUES ('AL068', 'AS031', 5.89);

INSERT INTO matricula VALUES ('AL068', 'AS032', 5.28);

INSERT INTO matricula VALUES ('AL068', 'AS033', 3.21);

INSERT INTO matricula VALUES ('AL068', 'AS034', 7.04);

INSERT INTO matricula VALUES ('AL068', 'AS035', 7.68);

INSERT INTO matricula VALUES ('AL068', 'AS065', 8.38);

INSERT INTO matricula VALUES ('AL068', 'AS067', 1.03);

INSERT INTO matricula VALUES ('AL068', 'AS057', 5.91);

INSERT INTO matricula VALUES ('AL068', 'AS068', 9.01);

INSERT INTO matricula VALUES ('AL068', 'AS044', 4.11);

INSERT INTO matricula VALUES ('AL074', 'AS031', 9.17);

INSERT INTO matricula VALUES ('AL074', 'AS032', 1.68);

INSERT INTO matricula VALUES ('AL074', 'AS033', 1.15);

INSERT INTO matricula VALUES ('AL074', 'AS034', 7.66);

INSERT INTO matricula VALUES ('AL074', 'AS035', 7.36);

INSERT INTO matricula VALUES ('AL074', 'AS051', 1.23);

INSERT INTO matricula VALUES ('AL074', 'AS077', 3.58);

INSERT INTO matricula VALUES ('AL074', 'AS042', 10);

INSERT INTO matricula VALUES ('AL074', 'AS042', 7.99);

INSERT INTO matricula VALUES ('AL074', 'AS043', 8.11);

INSERT INTO matricula VALUES ('AL077', 'AS031', 6.21);

INSERT INTO matricula VALUES ('AL077', 'AS032', 4.17);

INSERT INTO matricula VALUES ('AL077', 'AS033', 3.51);

INSERT INTO matricula VALUES ('AL077', 'AS034', 8.15);

INSERT INTO matricula VALUES ('AL077', 'AS035', 7.46);

INSERT INTO matricula VALUES ('AL077', 'AS075', 5.56);

INSERT INTO matricula VALUES ('AL077', 'AS058', 4.89);

INSERT INTO matricula VALUES ('AL077', 'AS062', 10);

INSERT INTO matricula VALUES ('AL077', 'AS037', 4.78);

INSERT INTO matricula VALUES ('AL077', 'AS038', 8.61);

INSERT INTO matricula VALUES ('AL086', 'AS031', 1.39);

INSERT INTO matricula VALUES ('AL086', 'AS032', 9.88);

INSERT INTO matricula VALUES ('AL086', 'AS033', 2.14);

INSERT INTO matricula VALUES ('AL086', 'AS034', 1.52);

INSERT INTO matricula VALUES ('AL086', 'AS035', 7.44);

INSERT INTO matricula VALUES ('AL086', 'AS043', 10);

INSERT INTO matricula VALUES ('AL086', 'AS070', 10);

INSERT INTO matricula VALUES ('AL086', 'AS064', 6.31);

INSERT INTO matricula VALUES ('AL086', 'AS068', 7.21);

INSERT INTO matricula VALUES ('AL086', 'AS071', 7.57);

INSERT INTO matricula VALUES ('AL087', 'AS083', 4.46);

INSERT INTO matricula VALUES ('AL087', 'AS070', 4.41);

INSERT INTO matricula VALUES ('AL087', 'AS066', 4.76);

INSERT INTO matricula VALUES ('AL087', 'AS051', 1.82);

INSERT INTO matricula VALUES ('AL087', 'AS057', 8.36);

INSERT INTO matricula VALUES ('AL087', 'AS064', 1.11);

INSERT INTO matricula VALUES ('AL087', 'AS059', 2.52);

INSERT INTO matricula VALUES ('AL087', 'AS077', 2.55);

INSERT INTO matricula VALUES ('AL087', 'AS064', 2.92);

INSERT INTO matricula VALUES ('AL087', 'AS071', 10);

INSERT INTO matricula VALUES ('AL088', 'AS031', 9.98);

INSERT INTO matricula VALUES ('AL088', 'AS032', 9.25);

INSERT INTO matricula VALUES ('AL088', 'AS033', 1.23);

INSERT INTO matricula VALUES ('AL088', 'AS034', 6.87);

INSERT INTO matricula VALUES ('AL088', 'AS035', 9.88);

INSERT INTO matricula VALUES ('AL088', 'AS061', 4.39);

INSERT INTO matricula VALUES ('AL088', 'AS064', 6.87);

INSERT INTO matricula VALUES ('AL088', 'AS078', 2.02);

INSERT INTO matricula VALUES ('AL088', 'AS048', 6.36);

INSERT INTO matricula VALUES ('AL088', 'AS067', 2.64);

INSERT INTO matricula VALUES ('AL089', 'AS031', 10);

INSERT INTO matricula VALUES ('AL089', 'AS032', 7.42);

INSERT INTO matricula VALUES ('AL089', 'AS033', 9.22);

INSERT INTO matricula VALUES ('AL089', 'AS034', 9.13);

INSERT INTO matricula VALUES ('AL089', 'AS035', 9.06);

INSERT INTO matricula VALUES ('AL089', 'AS083', 3.17);

INSERT INTO matricula VALUES ('AL089', 'AS083', 5.54);

INSERT INTO matricula VALUES ('AL089', 'AS039', 7.02);

INSERT INTO matricula VALUES ('AL089', 'AS039', 8.31);

INSERT INTO matricula VALUES ('AL089', 'AS076', 7.06);

INSERT INTO matricula VALUES ('AL094', 'AS031', 4.39);

INSERT INTO matricula VALUES ('AL094', 'AS032', 2.29);

INSERT INTO matricula VALUES ('AL094', 'AS033', 3.95);

INSERT INTO matricula VALUES ('AL094', 'AS034', 3.81);

INSERT INTO matricula VALUES ('AL094', 'AS035', 7.45);

INSERT INTO matricula VALUES ('AL094', 'AS069', 10);

INSERT INTO matricula VALUES ('AL094', 'AS040', 6.52);

INSERT INTO matricula VALUES ('AL094', 'AS059', 2.41);

INSERT INTO matricula VALUES ('AL094', 'AS061', 6.23);

INSERT INTO matricula VALUES ('AL094', 'AS080', 8.63);

INSERT INTO matricula VALUES ('AL107', 'AS031', 10);

INSERT INTO matricula VALUES ('AL107', 'AS032', 6.42);

INSERT INTO matricula VALUES ('AL107', 'AS033', 10);

INSERT INTO matricula VALUES ('AL107', 'AS034', 1.27);

INSERT INTO matricula VALUES ('AL107', 'AS035', 5.47);

INSERT INTO matricula VALUES ('AL107', 'AS051', 5.13);

INSERT INTO matricula VALUES ('AL107', 'AS076', 3.16);

INSERT INTO matricula VALUES ('AL107', 'AS067', 10);

INSERT INTO matricula VALUES ('AL107', 'AS057', 3.79);

INSERT INTO matricula VALUES ('AL107', 'AS058', 10);

INSERT INTO matricula VALUES ('AL114', 'AS031', 9.19);

INSERT INTO matricula VALUES ('AL114', 'AS032', 5.54);

INSERT INTO matricula VALUES ('AL114', 'AS033', 1.81);

INSERT INTO matricula VALUES ('AL114', 'AS034', 4.24);

INSERT INTO matricula VALUES ('AL114', 'AS035', 3.61);

INSERT INTO matricula VALUES ('AL114', 'AS066', 4.88);

INSERT INTO matricula VALUES ('AL114', 'AS065', 8.47);

INSERT INTO matricula VALUES ('AL114', 'AS042', 2.46);

INSERT INTO matricula VALUES ('AL114', 'AS062', 4.65);

INSERT INTO matricula VALUES ('AL114', 'AS037', 4.96);

INSERT INTO matricula VALUES ('AL115', 'AS031', 8.22);

INSERT INTO matricula VALUES ('AL115', 'AS032', 4.57);

INSERT INTO matricula VALUES ('AL115', 'AS033', 9.92);

INSERT INTO matricula VALUES ('AL115', 'AS034', 2.17);

INSERT INTO matricula VALUES ('AL115', 'AS035', 10);

INSERT INTO matricula VALUES ('AL115', 'AS042', 3.69);

INSERT INTO matricula VALUES ('AL115', 'AS065', 9.09);

INSERT INTO matricula VALUES ('AL115', 'AS074', 5.13);

INSERT INTO matricula VALUES ('AL115', 'AS080', 6.54);

INSERT INTO matricula VALUES ('AL115', 'AS039', 3.61);

INSERT INTO matricula VALUES ('AL117', 'AS031', 4.98);

INSERT INTO matricula VALUES ('AL117', 'AS032', 1.39);

INSERT INTO matricula VALUES ('AL117', 'AS033', 8.32);

INSERT INTO matricula VALUES ('AL117', 'AS034', 1.95);

INSERT INTO matricula VALUES ('AL117', 'AS035', 1.14);

INSERT INTO matricula VALUES ('AL117', 'AS044', 4.07);

INSERT INTO matricula VALUES ('AL117', 'AS041', 5.23);

INSERT INTO matricula VALUES ('AL117', 'AS075', 9.85);

INSERT INTO matricula VALUES ('AL117', 'AS077', 1.24);

INSERT INTO matricula VALUES ('AL117', 'AS065', 9.21);

INSERT INTO matricula VALUES ('AL121', 'AS031', 1.48);

INSERT INTO matricula VALUES ('AL121', 'AS032', 6.07);

INSERT INTO matricula VALUES ('AL121', 'AS033', 8.86);

INSERT INTO matricula VALUES ('AL121', 'AS034', 2.62);

INSERT INTO matricula VALUES ('AL121', 'AS035', 10);

INSERT INTO matricula VALUES ('AL121', 'AS045', 8.27);

INSERT INTO matricula VALUES ('AL121', 'AS071', 7.11);

INSERT INTO matricula VALUES ('AL121', 'AS061', 8.64);

INSERT INTO matricula VALUES ('AL121', 'AS041', 5.82);

INSERT INTO matricula VALUES ('AL121', 'AS075', 2.25);

INSERT INTO matricula VALUES ('AL128', 'AS031', 10);

INSERT INTO matricula VALUES ('AL128', 'AS032', 3.42);

INSERT INTO matricula VALUES ('AL128', 'AS033', 7.31);

INSERT INTO matricula VALUES ('AL128', 'AS034', 2.34);

INSERT INTO matricula VALUES ('AL128', 'AS035', 7.14);

INSERT INTO matricula VALUES ('AL128', 'AS039', 4.82);

INSERT INTO matricula VALUES ('AL128', 'AS074', 3.91);

INSERT INTO matricula VALUES ('AL128', 'AS078', 5.64);

INSERT INTO matricula VALUES ('AL128', 'AS048', 5.13);

INSERT INTO matricula VALUES ('AL128', 'AS077', 2.44);

INSERT INTO matricula VALUES ('AL136', 'AS031', 10);

INSERT INTO matricula VALUES ('AL136', 'AS032', 9.63);

INSERT INTO matricula VALUES ('AL136', 'AS033', 7.54);

INSERT INTO matricula VALUES ('AL136', 'AS034', 4.33);

INSERT INTO matricula VALUES ('AL136', 'AS035', 8.34);

INSERT INTO matricula VALUES ('AL136', 'AS059', 4.19);

INSERT INTO matricula VALUES ('AL136', 'AS051', 6.17);

INSERT INTO matricula VALUES ('AL136', 'AS045', 9.35);

INSERT INTO matricula VALUES ('AL136', 'AS081', 7.92);

INSERT INTO matricula VALUES ('AL136', 'AS057', 4.59);

INSERT INTO matricula VALUES ('AL141', 'AS031', 9.93);

INSERT INTO matricula VALUES ('AL141', 'AS032', 2.69);

INSERT INTO matricula VALUES ('AL141', 'AS033', 5.39);

INSERT INTO matricula VALUES ('AL141', 'AS034', 4.34);

INSERT INTO matricula VALUES ('AL141', 'AS035', 1.23);

INSERT INTO matricula VALUES ('AL141', 'AS065', 7.54);

INSERT INTO matricula VALUES ('AL141', 'AS051', 9.49);

INSERT INTO matricula VALUES ('AL141', 'AS068', 10);

INSERT INTO matricula VALUES ('AL141', 'AS042', 5.85);

INSERT INTO matricula VALUES ('AL141', 'AS048', 4.12);

INSERT INTO matricula VALUES ('AL156', 'AS031', 3.74);

INSERT INTO matricula VALUES ('AL156', 'AS032', 10);

INSERT INTO matricula VALUES ('AL156', 'AS033', 5.03);

INSERT INTO matricula VALUES ('AL156', 'AS034', 9.78);

INSERT INTO matricula VALUES ('AL156', 'AS035', 4.72);

INSERT INTO matricula VALUES ('AL156', 'AS042', 4.75);

INSERT INTO matricula VALUES ('AL156', 'AS065', 9.21);

INSERT INTO matricula VALUES ('AL156', 'AS039', 5.82);

INSERT INTO matricula VALUES ('AL156', 'AS078', 5.66);

INSERT INTO matricula VALUES ('AL156', 'AS053', 1.05);

INSERT INTO matricula VALUES ('AL163', 'AS031', 3.65);

INSERT INTO matricula VALUES ('AL163', 'AS032', 3.87);

INSERT INTO matricula VALUES ('AL163', 'AS033', 8.65);

INSERT INTO matricula VALUES ('AL163', 'AS034', 2.63);

INSERT INTO matricula VALUES ('AL163', 'AS035', 1.41);

INSERT INTO matricula VALUES ('AL163', 'AS048', 9.49);

INSERT INTO matricula VALUES ('AL163', 'AS071', 8.22);

INSERT INTO matricula VALUES ('AL163', 'AS047', 3.39);

INSERT INTO matricula VALUES ('AL163', 'AS066', 1.59);

INSERT INTO matricula VALUES ('AL163', 'AS064', 7.25);

INSERT INTO matricula VALUES ('AL168', 'AS031', 7.27);

INSERT INTO matricula VALUES ('AL168', 'AS032', 10);

INSERT INTO matricula VALUES ('AL168', 'AS033', 9.34);

INSERT INTO matricula VALUES ('AL168', 'AS034', 10);

INSERT INTO matricula VALUES ('AL168', 'AS035', 4.62);

INSERT INTO matricula VALUES ('AL168', 'AS044', 3.11);

INSERT INTO matricula VALUES ('AL168', 'AS039', 8.75);

INSERT INTO matricula VALUES ('AL168', 'AS083', 10);

INSERT INTO matricula VALUES ('AL168', 'AS044', 4.99);

INSERT INTO matricula VALUES ('AL168', 'AS076', 7.87);

INSERT INTO matricula VALUES ('AL171', 'AS031', 1.96);

INSERT INTO matricula VALUES ('AL171', 'AS032', 2.68);

INSERT INTO matricula VALUES ('AL171', 'AS033', 2.72);

INSERT INTO matricula VALUES ('AL171', 'AS034', 6.07);

INSERT INTO matricula VALUES ('AL171', 'AS035', 8.69);

INSERT INTO matricula VALUES ('AL171', 'AS078', 5.24);

INSERT INTO matricula VALUES ('AL171', 'AS059', 10);

INSERT INTO matricula VALUES ('AL171', 'AS061', 10);

INSERT INTO matricula VALUES ('AL171', 'AS037', 2.91);

INSERT INTO matricula VALUES ('AL171', 'AS062', 9.35);

INSERT INTO matricula VALUES ('AL172', 'AS031', 9.46);

INSERT INTO matricula VALUES ('AL172', 'AS032', 3.88);

INSERT INTO matricula VALUES ('AL172', 'AS033', 9.47);

INSERT INTO matricula VALUES ('AL172', 'AS034', 10);

INSERT INTO matricula VALUES ('AL172', 'AS035', 1.91);

INSERT INTO matricula VALUES ('AL172', 'AS062', 1.88);

INSERT INTO matricula VALUES ('AL172', 'AS046', 2.27);

INSERT INTO matricula VALUES ('AL172', 'AS066', 2.86);

INSERT INTO matricula VALUES ('AL172', 'AS081', 9.07);

INSERT INTO matricula VALUES ('AL172', 'AS058', 7.32);

INSERT INTO matricula VALUES ('AL179', 'AS031', 2.37);

INSERT INTO matricula VALUES ('AL179', 'AS032', 1.22);

INSERT INTO matricula VALUES ('AL179', 'AS033', 4.85);

INSERT INTO matricula VALUES ('AL179', 'AS034', 2.85);

INSERT INTO matricula VALUES ('AL179', 'AS035', 3.39);

INSERT INTO matricula VALUES ('AL179', 'AS067', 5.33);

INSERT INTO matricula VALUES ('AL179', 'AS046', 4.01);

INSERT INTO matricula VALUES ('AL179', 'AS045', 6.64);

INSERT INTO matricula VALUES ('AL179', 'AS042', 8.58);

INSERT INTO matricula VALUES ('AL179', 'AS042', 6.85);

INSERT INTO matricula VALUES ('AL183', 'AS031', 3.84);

INSERT INTO matricula VALUES ('AL183', 'AS032', 1.07);

INSERT INTO matricula VALUES ('AL183', 'AS033', 1.22);

INSERT INTO matricula VALUES ('AL183', 'AS034', 4.87);

INSERT INTO matricula VALUES ('AL183', 'AS035', 8.87);

INSERT INTO matricula VALUES ('AL183', 'AS074', 4.11);

INSERT INTO matricula VALUES ('AL183', 'AS074', 10);

INSERT INTO matricula VALUES ('AL183', 'AS071', 7.35);

INSERT INTO matricula VALUES ('AL183', 'AS042', 1.91);

INSERT INTO matricula VALUES ('AL183', 'AS047', 4.55);

INSERT INTO matricula VALUES ('AL190', 'AS031', 7.35);

INSERT INTO matricula VALUES ('AL190', 'AS032', 1.85);

INSERT INTO matricula VALUES ('AL190', 'AS033', 4.62);

INSERT INTO matricula VALUES ('AL190', 'AS034', 1.75);

INSERT INTO matricula VALUES ('AL190', 'AS035', 9.06);

INSERT INTO matricula VALUES ('AL190', 'AS068', 10);

INSERT INTO matricula VALUES ('AL190', 'AS046', 7.52);

INSERT INTO matricula VALUES ('AL190', 'AS081', 7.08);

INSERT INTO matricula VALUES ('AL190', 'AS037', 9.73);

INSERT INTO matricula VALUES ('AL190', 'AS062', 4.43);

INSERT INTO matricula VALUES ('AL001', 'AS084', 2.54);

INSERT INTO matricula VALUES ('AL001', 'AS085', 7.37);

INSERT INTO matricula VALUES ('AL001', 'AS086', 10);

INSERT INTO matricula VALUES ('AL001', 'AS087', 4.96);

INSERT INTO matricula VALUES ('AL001', 'AS088', 5.96);

INSERT INTO matricula VALUES ('AL001', 'AS089', 5.85);

INSERT INTO matricula VALUES ('AL001', 'AS090', 4.15);

INSERT INTO matricula VALUES ('AL001', 'AS091', 8.77);

INSERT INTO matricula VALUES ('AL001', 'AS092', 4.15);

INSERT INTO matricula VALUES ('AL001', 'AS093', 10);

INSERT INTO matricula VALUES ('AL006', 'AS084', 10);

INSERT INTO matricula VALUES ('AL006', 'AS085', 10);

INSERT INTO matricula VALUES ('AL006', 'AS086', 2.65);

INSERT INTO matricula VALUES ('AL006', 'AS087', 7.51);

INSERT INTO matricula VALUES ('AL006', 'AS088', 2.37);

INSERT INTO matricula VALUES ('AL006', 'AS089', 10);

INSERT INTO matricula VALUES ('AL006', 'AS090', 4.42);

INSERT INTO matricula VALUES ('AL006', 'AS091', 8.61);

INSERT INTO matricula VALUES ('AL006', 'AS092', 6.96);

INSERT INTO matricula VALUES ('AL006', 'AS093', 10);

INSERT INTO matricula VALUES ('AL015', 'AS084', 2.09);

INSERT INTO matricula VALUES ('AL015', 'AS085', 9.78);

INSERT INTO matricula VALUES ('AL015', 'AS086', 1.87);

INSERT INTO matricula VALUES ('AL015', 'AS087', 7.72);

INSERT INTO matricula VALUES ('AL015', 'AS088', 6.52);

INSERT INTO matricula VALUES ('AL015', 'AS089', 6.71);

INSERT INTO matricula VALUES ('AL015', 'AS090', 6.17);

INSERT INTO matricula VALUES ('AL015', 'AS091', 8.43);

INSERT INTO matricula VALUES ('AL015', 'AS092', 5.67);

INSERT INTO matricula VALUES ('AL015', 'AS093', 9.81);

INSERT INTO matricula VALUES ('AL023', 'AS084', 3.56);

INSERT INTO matricula VALUES ('AL023', 'AS085', 6.19);

INSERT INTO matricula VALUES ('AL023', 'AS086', 2.86);

INSERT INTO matricula VALUES ('AL023', 'AS087', 6.81);

INSERT INTO matricula VALUES ('AL023', 'AS088', 9.98);

INSERT INTO matricula VALUES ('AL023', 'AS089', 1.54);

INSERT INTO matricula VALUES ('AL023', 'AS090', 6.43);

INSERT INTO matricula VALUES ('AL023', 'AS091', 6.27);

INSERT INTO matricula VALUES ('AL023', 'AS092', 6.01);

INSERT INTO matricula VALUES ('AL023', 'AS093', 1.06);

INSERT INTO matricula VALUES ('AL024', 'AS084', 6.81);

INSERT INTO matricula VALUES ('AL024', 'AS085', 7.59);

INSERT INTO matricula VALUES ('AL024', 'AS086', 1.12);

INSERT INTO matricula VALUES ('AL024', 'AS087', 5.08);

INSERT INTO matricula VALUES ('AL024', 'AS088', 9.31);

INSERT INTO matricula VALUES ('AL024', 'AS089', 3.11);

INSERT INTO matricula VALUES ('AL024', 'AS090', 2.69);

INSERT INTO matricula VALUES ('AL024', 'AS091', 5.81);

INSERT INTO matricula VALUES ('AL024', 'AS092', 3.67);

INSERT INTO matricula VALUES ('AL024', 'AS093', 5.23);

INSERT INTO matricula VALUES ('AL035', 'AS084', 1.94);

INSERT INTO matricula VALUES ('AL035', 'AS085', 6.64);

INSERT INTO matricula VALUES ('AL035', 'AS086', 5.37);

INSERT INTO matricula VALUES ('AL035', 'AS087', 4.96);

INSERT INTO matricula VALUES ('AL035', 'AS088', 6.95);

INSERT INTO matricula VALUES ('AL035', 'AS089', 6.91);

INSERT INTO matricula VALUES ('AL035', 'AS090', 1.41);

INSERT INTO matricula VALUES ('AL035', 'AS091', 5.42);

INSERT INTO matricula VALUES ('AL035', 'AS092', 3.35);

INSERT INTO matricula VALUES ('AL035', 'AS093', 1.46);

INSERT INTO matricula VALUES ('AL037', 'AS084', 10);

INSERT INTO matricula VALUES ('AL037', 'AS085', 1.81);

INSERT INTO matricula VALUES ('AL037', 'AS086', 7.91);

INSERT INTO matricula VALUES ('AL037', 'AS087', 2.56);

INSERT INTO matricula VALUES ('AL037', 'AS088', 2.88);

INSERT INTO matricula VALUES ('AL037', 'AS089', 3.58);

INSERT INTO matricula VALUES ('AL037', 'AS090', 4.38);

INSERT INTO matricula VALUES ('AL037', 'AS091', 4.05);

INSERT INTO matricula VALUES ('AL037', 'AS092', 5.43);

INSERT INTO matricula VALUES ('AL037', 'AS093', 5.16);

INSERT INTO matricula VALUES ('AL040', 'AS084', 8.68);

INSERT INTO matricula VALUES ('AL040', 'AS085', 6.38);

INSERT INTO matricula VALUES ('AL040', 'AS086', 10);

INSERT INTO matricula VALUES ('AL040', 'AS087', 9.23);

INSERT INTO matricula VALUES ('AL040', 'AS088', 3.63);

INSERT INTO matricula VALUES ('AL040', 'AS089', 3.75);

INSERT INTO matricula VALUES ('AL040', 'AS090', 8.03);

INSERT INTO matricula VALUES ('AL040', 'AS091', 7.01);

INSERT INTO matricula VALUES ('AL040', 'AS092', 8.99);

INSERT INTO matricula VALUES ('AL040', 'AS093', 9.55);

INSERT INTO matricula VALUES ('AL063', 'AS084', 5.47);

INSERT INTO matricula VALUES ('AL063', 'AS085', 4.97);

INSERT INTO matricula VALUES ('AL063', 'AS086', 7.36);

INSERT INTO matricula VALUES ('AL063', 'AS087', 8.06);

INSERT INTO matricula VALUES ('AL063', 'AS088', 4.22);

INSERT INTO matricula VALUES ('AL063', 'AS089', 1.94);

INSERT INTO matricula VALUES ('AL063', 'AS090', 3.57);

INSERT INTO matricula VALUES ('AL063', 'AS091', 1.56);

INSERT INTO matricula VALUES ('AL063', 'AS092', 10);

INSERT INTO matricula VALUES ('AL063', 'AS093', 9.33);

INSERT INTO matricula VALUES ('AL075', 'AS084', 1.64);

INSERT INTO matricula VALUES ('AL075', 'AS085', 8.84);

INSERT INTO matricula VALUES ('AL075', 'AS086', 2.21);

INSERT INTO matricula VALUES ('AL075', 'AS087', 5.73);

INSERT INTO matricula VALUES ('AL075', 'AS088', 5.73);

INSERT INTO matricula VALUES ('AL075', 'AS089', 7.97);

INSERT INTO matricula VALUES ('AL075', 'AS090', 7.86);

INSERT INTO matricula VALUES ('AL075', 'AS091', 1.11);

INSERT INTO matricula VALUES ('AL075', 'AS092', 9.31);

INSERT INTO matricula VALUES ('AL075', 'AS093', 9.33);

INSERT INTO matricula VALUES ('AL084', 'AS084', 2.97);

INSERT INTO matricula VALUES ('AL084', 'AS085', 4.36);

INSERT INTO matricula VALUES ('AL084', 'AS086', 1.45);

INSERT INTO matricula VALUES ('AL084', 'AS087', 10);

INSERT INTO matricula VALUES ('AL084', 'AS088', 1.99);

INSERT INTO matricula VALUES ('AL084', 'AS089', 4.71);

INSERT INTO matricula VALUES ('AL084', 'AS090', 6.37);

INSERT INTO matricula VALUES ('AL084', 'AS091', 2.41);

INSERT INTO matricula VALUES ('AL084', 'AS092', 5.75);

INSERT INTO matricula VALUES ('AL084', 'AS093', 5.13);

INSERT INTO matricula VALUES ('AL091', 'AS084', 1.72);

INSERT INTO matricula VALUES ('AL091', 'AS085', 6.21);

INSERT INTO matricula VALUES ('AL091', 'AS086', 10);

INSERT INTO matricula VALUES ('AL091', 'AS087', 5.62);

INSERT INTO matricula VALUES ('AL091', 'AS088', 10);

INSERT INTO matricula VALUES ('AL091', 'AS089', 3.43);

INSERT INTO matricula VALUES ('AL091', 'AS090', 2.76);

INSERT INTO matricula VALUES ('AL091', 'AS091', 9.99);

INSERT INTO matricula VALUES ('AL091', 'AS092', 7.12);

INSERT INTO matricula VALUES ('AL091', 'AS093', 5.22);

INSERT INTO matricula VALUES ('AL093', 'AS084', 5.93);

INSERT INTO matricula VALUES ('AL093', 'AS085', 5.09);

INSERT INTO matricula VALUES ('AL093', 'AS086', 7.09);

INSERT INTO matricula VALUES ('AL093', 'AS087', 8.96);

INSERT INTO matricula VALUES ('AL093', 'AS088', 9.48);

INSERT INTO matricula VALUES ('AL093', 'AS089', 10);

INSERT INTO matricula VALUES ('AL093', 'AS090', 9.42);

INSERT INTO matricula VALUES ('AL093', 'AS091', 5.67);

INSERT INTO matricula VALUES ('AL093', 'AS092', 4.99);

INSERT INTO matricula VALUES ('AL093', 'AS093', 4.71);

INSERT INTO matricula VALUES ('AL109', 'AS084', 10);

INSERT INTO matricula VALUES ('AL109', 'AS085', 1.62);

INSERT INTO matricula VALUES ('AL109', 'AS086', 6.61);

INSERT INTO matricula VALUES ('AL109', 'AS087', 5.41);

INSERT INTO matricula VALUES ('AL109', 'AS088', 2.51);

INSERT INTO matricula VALUES ('AL109', 'AS089', 10);

INSERT INTO matricula VALUES ('AL109', 'AS090', 4.32);

INSERT INTO matricula VALUES ('AL109', 'AS091', 8.47);

INSERT INTO matricula VALUES ('AL109', 'AS092', 10);

INSERT INTO matricula VALUES ('AL109', 'AS093', 3.78);

INSERT INTO matricula VALUES ('AL116', 'AS084', 2.93);

INSERT INTO matricula VALUES ('AL116', 'AS085', 5.66);

INSERT INTO matricula VALUES ('AL116', 'AS086', 2.97);

INSERT INTO matricula VALUES ('AL116', 'AS087', 2.59);

INSERT INTO matricula VALUES ('AL116', 'AS088', 4.24);

INSERT INTO matricula VALUES ('AL116', 'AS089', 2.67);

INSERT INTO matricula VALUES ('AL116', 'AS090', 1.42);

INSERT INTO matricula VALUES ('AL116', 'AS091', 6.65);

INSERT INTO matricula VALUES ('AL116', 'AS092', 9.42);

INSERT INTO matricula VALUES ('AL116', 'AS093', 9.61);

INSERT INTO matricula VALUES ('AL120', 'AS084', 8.31);

INSERT INTO matricula VALUES ('AL120', 'AS085', 1.94);

INSERT INTO matricula VALUES ('AL120', 'AS086', 4.57);

INSERT INTO matricula VALUES ('AL120', 'AS087', 9.83);

INSERT INTO matricula VALUES ('AL120', 'AS088', 1.09);

INSERT INTO matricula VALUES ('AL120', 'AS089', 5.89);

INSERT INTO matricula VALUES ('AL120', 'AS090', 10);

INSERT INTO matricula VALUES ('AL120', 'AS091', 9.79);

INSERT INTO matricula VALUES ('AL120', 'AS092', 6.34);

INSERT INTO matricula VALUES ('AL120', 'AS093', 9.05);

INSERT INTO matricula VALUES ('AL129', 'AS084', 2.14);

INSERT INTO matricula VALUES ('AL129', 'AS085', 1.04);

INSERT INTO matricula VALUES ('AL129', 'AS086', 7.04);

INSERT INTO matricula VALUES ('AL129', 'AS087', 9.71);

INSERT INTO matricula VALUES ('AL129', 'AS088', 3.33);

INSERT INTO matricula VALUES ('AL129', 'AS089', 4.02);

INSERT INTO matricula VALUES ('AL129', 'AS090', 9.71);

INSERT INTO matricula VALUES ('AL129', 'AS091', 7.89);

INSERT INTO matricula VALUES ('AL129', 'AS092', 8.35);

INSERT INTO matricula VALUES ('AL129', 'AS093', 3.53);

INSERT INTO matricula VALUES ('AL130', 'AS084', 6.78);

INSERT INTO matricula VALUES ('AL130', 'AS085', 8.36);

INSERT INTO matricula VALUES ('AL130', 'AS086', 3.34);

INSERT INTO matricula VALUES ('AL130', 'AS087', 4.25);

INSERT INTO matricula VALUES ('AL130', 'AS088', 8.54);

INSERT INTO matricula VALUES ('AL130', 'AS089', 7.63);

INSERT INTO matricula VALUES ('AL130', 'AS090', 1.34);

INSERT INTO matricula VALUES ('AL130', 'AS091', 9.34);

INSERT INTO matricula VALUES ('AL130', 'AS092', 6.06);

INSERT INTO matricula VALUES ('AL130', 'AS093', 1.74);

INSERT INTO matricula VALUES ('AL133', 'AS084', 6.55);

INSERT INTO matricula VALUES ('AL133', 'AS085', 6.17);

INSERT INTO matricula VALUES ('AL133', 'AS086', 6.63);

INSERT INTO matricula VALUES ('AL133', 'AS087', 10);

INSERT INTO matricula VALUES ('AL133', 'AS088', 7.37);

INSERT INTO matricula VALUES ('AL133', 'AS089', 1.51);

INSERT INTO matricula VALUES ('AL133', 'AS090', 6.43);

INSERT INTO matricula VALUES ('AL133', 'AS091', 8.64);

INSERT INTO matricula VALUES ('AL133', 'AS092', 7.18);

INSERT INTO matricula VALUES ('AL133', 'AS093', 3.63);

INSERT INTO matricula VALUES ('AL137', 'AS084', 9.47);

INSERT INTO matricula VALUES ('AL137', 'AS085', 5.62);

INSERT INTO matricula VALUES ('AL137', 'AS086', 8.75);

INSERT INTO matricula VALUES ('AL137', 'AS087', 5.92);

INSERT INTO matricula VALUES ('AL137', 'AS088', 7.96);

INSERT INTO matricula VALUES ('AL137', 'AS089', 3.69);

INSERT INTO matricula VALUES ('AL137', 'AS090', 5.37);

INSERT INTO matricula VALUES ('AL137', 'AS091', 4.19);

INSERT INTO matricula VALUES ('AL137', 'AS092', 1.95);

INSERT INTO matricula VALUES ('AL137', 'AS093', 7.42);

INSERT INTO matricula VALUES ('AL140', 'AS084', 10);

INSERT INTO matricula VALUES ('AL140', 'AS085', 8.45);

INSERT INTO matricula VALUES ('AL140', 'AS086', 4.26);

INSERT INTO matricula VALUES ('AL140', 'AS087', 7.45);

INSERT INTO matricula VALUES ('AL140', 'AS088', 9.98);

INSERT INTO matricula VALUES ('AL140', 'AS089', 6.22);

INSERT INTO matricula VALUES ('AL140', 'AS090', 3.34);

INSERT INTO matricula VALUES ('AL140', 'AS091', 10);

INSERT INTO matricula VALUES ('AL140', 'AS092', 10);

INSERT INTO matricula VALUES ('AL140', 'AS093', 1.15);

INSERT INTO matricula VALUES ('AL144', 'AS084', 7.58);

INSERT INTO matricula VALUES ('AL144', 'AS085', 10);

INSERT INTO matricula VALUES ('AL144', 'AS086', 1.79);

INSERT INTO matricula VALUES ('AL144', 'AS087', 7.25);

INSERT INTO matricula VALUES ('AL144', 'AS088', 1.57);

INSERT INTO matricula VALUES ('AL144', 'AS089', 10);

INSERT INTO matricula VALUES ('AL144', 'AS090', 1.12);

INSERT INTO matricula VALUES ('AL144', 'AS091', 1.81);

INSERT INTO matricula VALUES ('AL144', 'AS092', 4.26);

INSERT INTO matricula VALUES ('AL144', 'AS093', 3.27);

INSERT INTO matricula VALUES ('AL148', 'AS084', 3.76);

INSERT INTO matricula VALUES ('AL148', 'AS085', 5.94);

INSERT INTO matricula VALUES ('AL148', 'AS086', 3.16);

INSERT INTO matricula VALUES ('AL148', 'AS087', 8.46);

INSERT INTO matricula VALUES ('AL148', 'AS088', 1.19);

INSERT INTO matricula VALUES ('AL148', 'AS089', 6.96);

INSERT INTO matricula VALUES ('AL148', 'AS090', 7.79);

INSERT INTO matricula VALUES ('AL148', 'AS091', 7.85);

INSERT INTO matricula VALUES ('AL148', 'AS092', 5.85);

INSERT INTO matricula VALUES ('AL148', 'AS093', 8.07);

INSERT INTO matricula VALUES ('AL151', 'AS084', 2.32);

INSERT INTO matricula VALUES ('AL151', 'AS085', 5.45);

INSERT INTO matricula VALUES ('AL151', 'AS086', 4.66);

INSERT INTO matricula VALUES ('AL151', 'AS087', 3.96);

INSERT INTO matricula VALUES ('AL151', 'AS088', 4.02);

INSERT INTO matricula VALUES ('AL151', 'AS089', 9.98);

INSERT INTO matricula VALUES ('AL151', 'AS090', 1.27);

INSERT INTO matricula VALUES ('AL151', 'AS091', 10);

INSERT INTO matricula VALUES ('AL151', 'AS092', 2.06);

INSERT INTO matricula VALUES ('AL151', 'AS093', 4.33);

INSERT INTO matricula VALUES ('AL159', 'AS084', 9.56);

INSERT INTO matricula VALUES ('AL159', 'AS085', 7.59);

INSERT INTO matricula VALUES ('AL159', 'AS086', 8.41);

INSERT INTO matricula VALUES ('AL159', 'AS087', 1.33);

INSERT INTO matricula VALUES ('AL159', 'AS088', 4.84);

INSERT INTO matricula VALUES ('AL159', 'AS089', 2.63);

INSERT INTO matricula VALUES ('AL159', 'AS090', 7.38);

INSERT INTO matricula VALUES ('AL159', 'AS091', 8.54);

INSERT INTO matricula VALUES ('AL159', 'AS092', 2.76);

INSERT INTO matricula VALUES ('AL159', 'AS093', 3.13);

INSERT INTO matricula VALUES ('AL164', 'AS084', 7.67);

INSERT INTO matricula VALUES ('AL164', 'AS085', 1.36);

INSERT INTO matricula VALUES ('AL164', 'AS086', 6.13);

INSERT INTO matricula VALUES ('AL164', 'AS087', 4.72);

INSERT INTO matricula VALUES ('AL164', 'AS088', 2.34);

INSERT INTO matricula VALUES ('AL164', 'AS089', 3.55);

INSERT INTO matricula VALUES ('AL164', 'AS090', 1.81);

INSERT INTO matricula VALUES ('AL164', 'AS091', 6.44);

INSERT INTO matricula VALUES ('AL164', 'AS092', 4.72);

INSERT INTO matricula VALUES ('AL164', 'AS093', 1.33);

INSERT INTO matricula VALUES ('AL169', 'AS084', 7.24);

INSERT INTO matricula VALUES ('AL169', 'AS085', 5.15);

INSERT INTO matricula VALUES ('AL169', 'AS086', 4.35);

INSERT INTO matricula VALUES ('AL169', 'AS087', 7.27);

INSERT INTO matricula VALUES ('AL169', 'AS088', 6.59);

INSERT INTO matricula VALUES ('AL169', 'AS089', 10);

INSERT INTO matricula VALUES ('AL169', 'AS090', 6.67);

INSERT INTO matricula VALUES ('AL169', 'AS091', 2.88);

INSERT INTO matricula VALUES ('AL169', 'AS092', 9.06);

INSERT INTO matricula VALUES ('AL169', 'AS093', 8.69);

INSERT INTO matricula VALUES ('AL176', 'AS084', 6.15);

INSERT INTO matricula VALUES ('AL176', 'AS085', 1.16);

INSERT INTO matricula VALUES ('AL176', 'AS086', 9.08);

INSERT INTO matricula VALUES ('AL176', 'AS087', 9.83);

INSERT INTO matricula VALUES ('AL176', 'AS088', 2.74);

INSERT INTO matricula VALUES ('AL176', 'AS089', 6.64);

INSERT INTO matricula VALUES ('AL176', 'AS090', 8.75);

INSERT INTO matricula VALUES ('AL176', 'AS091', 8.85);

INSERT INTO matricula VALUES ('AL176', 'AS092', 3.38);

INSERT INTO matricula VALUES ('AL176', 'AS093', 3.96);

INSERT INTO matricula VALUES ('AL182', 'AS084', 2.47);

INSERT INTO matricula VALUES ('AL182', 'AS085', 10);

INSERT INTO matricula VALUES ('AL182', 'AS086', 9.19);

INSERT INTO matricula VALUES ('AL182', 'AS087', 2.31);

INSERT INTO matricula VALUES ('AL182', 'AS088', 5.28);

INSERT INTO matricula VALUES ('AL182', 'AS089', 3.91);

INSERT INTO matricula VALUES ('AL182', 'AS090', 8.95);

INSERT INTO matricula VALUES ('AL182', 'AS091', 5.07);

INSERT INTO matricula VALUES ('AL182', 'AS092', 2.11);

INSERT INTO matricula VALUES ('AL182', 'AS093', 5.66);

INSERT INTO matricula VALUES ('AL184', 'AS084', 8.85);

INSERT INTO matricula VALUES ('AL184', 'AS085', 4.53);

INSERT INTO matricula VALUES ('AL184', 'AS086', 7.65);

INSERT INTO matricula VALUES ('AL184', 'AS087', 7.75);

INSERT INTO matricula VALUES ('AL184', 'AS088', 5.64);

INSERT INTO matricula VALUES ('AL184', 'AS089', 10);

INSERT INTO matricula VALUES ('AL184', 'AS090', 3.29);

INSERT INTO matricula VALUES ('AL184', 'AS091', 5.55);

INSERT INTO matricula VALUES ('AL184', 'AS092', 4.05);

INSERT INTO matricula VALUES ('AL184', 'AS093', 6.97);

INSERT INTO matricula VALUES ('AL188', 'AS084', 7.66);

INSERT INTO matricula VALUES ('AL188', 'AS085', 6.11);

INSERT INTO matricula VALUES ('AL188', 'AS086', 2.64);

INSERT INTO matricula VALUES ('AL188', 'AS087', 3.22);

INSERT INTO matricula VALUES ('AL188', 'AS088', 6.73);

INSERT INTO matricula VALUES ('AL188', 'AS089', 5.29);

INSERT INTO matricula VALUES ('AL188', 'AS090', 3.35);

INSERT INTO matricula VALUES ('AL188', 'AS091', 1.26);

INSERT INTO matricula VALUES ('AL188', 'AS092', 6.55);

INSERT INTO matricula VALUES ('AL188', 'AS093', 6.27);

INSERT INTO matricula VALUES ('AL195', 'AS084', 10);

INSERT INTO matricula VALUES ('AL195', 'AS085', 7.21);

INSERT INTO matricula VALUES ('AL195', 'AS086', 9.58);

INSERT INTO matricula VALUES ('AL195', 'AS087', 5.48);

INSERT INTO matricula VALUES ('AL195', 'AS088', 2.89);

INSERT INTO matricula VALUES ('AL195', 'AS089', 4.94);

INSERT INTO matricula VALUES ('AL195', 'AS090', 7.56);

INSERT INTO matricula VALUES ('AL195', 'AS091', 3.32);

INSERT INTO matricula VALUES ('AL195', 'AS092', 5.47);

INSERT INTO matricula VALUES ('AL195', 'AS093', 7.05);

INSERT INTO matricula VALUES ('AL199', 'AS084', 2.04);

INSERT INTO matricula VALUES ('AL199', 'AS085', 3.13);

INSERT INTO matricula VALUES ('AL199', 'AS086', 9.01);

INSERT INTO matricula VALUES ('AL199', 'AS087', 7.87);

INSERT INTO matricula VALUES ('AL199', 'AS088', 4.52);

INSERT INTO matricula VALUES ('AL199', 'AS089', 8.35);

INSERT INTO matricula VALUES ('AL199', 'AS090', 9.12);

INSERT INTO matricula VALUES ('AL199', 'AS091', 7.32);

INSERT INTO matricula VALUES ('AL199', 'AS092', 7.71);

INSERT INTO matricula VALUES ('AL199', 'AS093', 3.42);

INSERT INTO matricula VALUES ('AL009', 'AS100', 2.85);

INSERT INTO matricula VALUES ('AL020', 'AS099', 3.18);

INSERT INTO matricula VALUES ('AL026', 'AS100', 8.07);

INSERT INTO matricula VALUES ('AL029', 'AS097', 9.45);

INSERT INTO matricula VALUES ('AL032', 'AS097', 5.86);

INSERT INTO matricula VALUES ('AL038', 'AS100', 7.88);

INSERT INTO matricula VALUES ('AL048', 'AS099', 2.15);

INSERT INTO matricula VALUES ('AL053', 'AS097', 6.77);

INSERT INTO matricula VALUES ('AL056', 'AS097', 5.94);

INSERT INTO matricula VALUES ('AL057', 'AS099', 10);

INSERT INTO matricula VALUES ('AL061', 'AS095', 7.56);

INSERT INTO matricula VALUES ('AL062', 'AS095', 6.24);

INSERT INTO matricula VALUES ('AL066', 'AS097', 7.91);

INSERT INTO matricula VALUES ('AL070', 'AS099', 1.48);

INSERT INTO matricula VALUES ('AL082', 'AS100', 2.94);

INSERT INTO matricula VALUES ('AL085', 'AS099', 3.47);

INSERT INTO matricula VALUES ('AL097', 'AS100', 1.74);

INSERT INTO matricula VALUES ('AL111', 'AS097', 10);

INSERT INTO matricula VALUES ('AL125', 'AS095', 10);

INSERT INTO matricula VALUES ('AL126', 'AS097', 2.96);

INSERT INTO matricula VALUES ('AL135', 'AS099', 2.44);

INSERT INTO matricula VALUES ('AL143', 'AS099', 7.78);

INSERT INTO matricula VALUES ('AL158', 'AS100', 3.51);

INSERT INTO matricula VALUES ('AL173', 'AS095', 6.71);

INSERT INTO matricula VALUES ('AL174', 'AS095', 10);

INSERT INTO matricula VALUES ('AL178', 'AS099', 1.17);

INSERT INTO matricula VALUES ('AL181', 'AS095', 3.01);

INSERT INTO matricula VALUES ('AL191', 'AS095', 7.55);

INSERT INTO matricula VALUES ('AL198', 'AS100', 4.45);
