create database netflix_bd;

use netflix_bd;

select * from netflix_titles;

/* Cambiamos los nombres de las columnas al español */
EXEC sp_rename 'netflix_titles.type', 'tipo', 'COLUMN';
EXEC sp_rename 'netflix_titles.cast', 'reparto', 'COLUMN';
EXEC sp_rename 'netflix_titles.country', 'pais', 'COLUMN';
EXEC sp_rename 'netflix_titles.title', 'titulo', 'COLUMN';
EXEC sp_rename 'netflix_titles.date_added', 'fecha_agregacion', 'COLUMN';
EXEC sp_rename 'netflix_titles.release_year', 'anio_lanzamiento', 'COLUMN';
EXEC sp_rename 'netflix_titles.rating', 'clasificacion', 'COLUMN';
EXEC sp_rename 'netflix_titles.duration', 'duracion', 'COLUMN';
EXEC sp_rename 'netflix_titles.listed_in', 'categoria', 'COLUMN';
EXEC sp_rename 'netflix_titles.description', 'descripcion', 'COLUMN';

CREATE TABLE Tipo
(
  id_tipo INT IDENTITY(1,1) NOT NULL,
  tipo VARCHAR(250) NOT NULL,
  CONSTRAINT PK_Tipo PRIMARY KEY (id_tipo)
);

CREATE TABLE Director
(
  id_director INT IDENTITY(1,1) NOT NULL,
  nombre_director VARCHAR(250) NOT NULL,
  CONSTRAINT PK_Director PRIMARY KEY (id_director)
);

CREATE TABLE Pais
(
  id_pais INT IDENTITY(1,1) NOT NULL,
  nombre_pais VARCHAR(250) NOT NULL,
  CONSTRAINT PK_Pais PRIMARY KEY (id_pais)
);

CREATE TABLE Clasificacion
(
  id_clasificacion INT IDENTITY(1,1) NOT NULL,
  descripcion_clasificacion VARCHAR(250) NOT NULL,
  CONSTRAINT PK_Clasificacion PRIMARY KEY (id_clasificacion)
);

CREATE TABLE Categoria
(
  id_categoria INT IDENTITY(1,1) NOT NULL,
  descripcion_categoria VARCHAR(250) NOT NULL,
  CONSTRAINT PK_Categoria PRIMARY KEY (id_categoria)
);

CREATE TABLE Actor
(
  id_actor INT IDENTITY(1,1) NOT NULL,
  nombre_actor VARCHAR(250) NOT NULL,
  CONSTRAINT PK_Actor PRIMARY KEY (id_actor)
);

/*
CREATE TABLE Show
(
  show_id INT IDENTITY(1,1) NOT NULL,
  titulo VARCHAR(100) NOT NULL,
  fecha_agregacion DATE NOT NULL,
  anio_lanzamiento INT NOT NULL,
  duracion VARCHAR(50) NOT NULL,
  descripcion VARCHAR(255) NOT NULL,
  id_tipo INT NOT NULL,
  id_clasificacion INT NOT NULL,
  CONSTRAINT PK_Show PRIMARY KEY (show_id),
  CONSTRAINT FK_Show_Tipo FOREIGN KEY (id_tipo) REFERENCES Tipo(id_tipo),
  CONSTRAINT FK_Show_Clasificacion FOREIGN KEY (id_clasificacion) REFERENCES Clasificacion(id_clasificacion)
);
*/

CREATE TABLE Show_director
(
  id_director INT NOT NULL,
  show_id NVARCHAR(250) NOT NULL,
  CONSTRAINT PK_ShowDirector PRIMARY KEY (id_director, show_id),
  CONSTRAINT FK_ShowDirector_Direc FOREIGN KEY (id_director) REFERENCES Director(id_director),
  CONSTRAINT FK_ShowDirector_Nt FOREIGN KEY (show_id) REFERENCES netflix_titles(show_id)
);

CREATE TABLE Show_pais
(
  id_pais INT NOT NULL,
  show_id NVARCHAR(250) NOT NULL,
  CONSTRAINT PK_ShowPais PRIMARY KEY (id_pais, show_id),
  CONSTRAINT FK_ShowPais_Pais FOREIGN KEY (id_pais) REFERENCES Pais(id_pais),
  CONSTRAINT FK_ShowPais_Nt FOREIGN KEY (show_id) REFERENCES netflix_titles(show_id)
);

CREATE TABLE Show_categoria
(
  id_categoria INT NOT NULL,
  show_id NVARCHAR(250) NOT NULL,
  CONSTRAINT PK_ShowCategoria PRIMARY KEY (id_categoria, show_id),
  CONSTRAINT FK_ShowCategoria_Cat FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria),
  CONSTRAINT FK_ShowCategoria_Nt FOREIGN KEY (show_id) REFERENCES netflix_titles(show_id)
);

CREATE TABLE Reparto
(
  show_id NVARCHAR(250) NOT NULL,
  id_actor INT NOT NULL,
  CONSTRAINT PK_Reparto PRIMARY KEY (show_id, id_actor),
  CONSTRAINT FK_Reparto_Nt FOREIGN KEY (show_id) REFERENCES netflix_titles(show_id),
  CONSTRAINT FK_Reparto_Actor FOREIGN KEY (id_actor) REFERENCES Actor(id_actor)
);
