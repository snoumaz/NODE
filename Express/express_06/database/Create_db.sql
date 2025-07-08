CREATE DATABASE db_pelis;

USE db_pelis;

DROP TABLE pelis;

CREATE TABLE pelis (
    id_peli INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    titulo_peli VARCHAR(255) NOT NULL,
    fecha INT NOT NULL,
    id_director INT NOT NULL,
    img_peli TEXT,
    valoracion DECIMAL(3,1) UNSIGNED NOT NULL
);

CREATE TABLE directores(
    id_director INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre_director VARCHAR(255) NOT NULL
);

CREATE TABLE generos(
    id_genero INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre_genero VARCHAR(50) NOT NULL
);

CREATE TABLE pelis_generos (
    id_peli_genero INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_peli INT NOT NULL,
    id_genero INT NOT NULL
);

INSERT INTO generos(nombre_genero) VALUES ("Dramas"), ("Comedia"), ("Aventuras"), ("Fantastica"), ("Ciencia Ficcion"), ("Terror"), ("Romantica"), ("Suspense"),("Historica");
INSERT INTO pelis(titulo_peli,fecha,img_peli, valoracion, id_director) VALUES ("La guerra de las galaxias. Episodio IV: Una nueva esperanza",1977,"https://pics.filmaffinity.com/star_wars-166209019-large.jpg",7.9,1),
("Origen",2010,"https://pics.filmaffinity.com/inception-652954101-large.jpg",8.0,2),("Interstellar",2014,"https://pics.filmaffinity.com/interstellar-366875261-large.jpg",7.9,2),
("Infiltrados",2006,"https://pics.filmaffinity.com/the_departed-749477966-large.jpg",7.9,3), ("El padrino",1972,"https://pics.filmaffinity.com/the_godfather-488102675-large.jpg",9.0,4);

INSERT INTO directores(nombre_director) VALUES ("George Lucas"),("Christopher Nolan"),("Martin Scorsese"),("Francis Ford Coppola");

INSERT INTO pelis_generos(id_peli,id_genero) VALUES (1,(SELECT id_genero FROM generos WHERE nombre_genero = "Aventuras")), (1,(SELECT id_genero FROM generos WHERE nombre_genero = "Fantastica")), (1,(SELECT id_genero FROM generos WHERE nombre_genero = "Ciencia Ficcion")),
(2,(SELECT id_genero FROM generos WHERE nombre_genero = "Suspense")), (2,(SELECT id_genero FROM generos WHERE nombre_genero = "Fantastica")), (2,(SELECT id_genero FROM generos WHERE nombre_genero = "Ciencia Ficcion")),
(3,(SELECT id_genero FROM generos WHERE nombre_genero = "Aventuras")), (3,(SELECT id_genero FROM generos WHERE nombre_genero = "Dramas")), (3,(SELECT id_genero FROM generos WHERE nombre_genero = "Ciencia Ficcion")),
(4,(SELECT id_genero FROM generos WHERE nombre_genero = "Dramas")), (4,(SELECT id_genero FROM generos WHERE nombre_genero = "Suspense")), 
(5,(SELECT id_genero FROM generos WHERE nombre_genero = "Dramas")), (5,(SELECT id_genero FROM generos WHERE nombre_genero = "Suspense"));