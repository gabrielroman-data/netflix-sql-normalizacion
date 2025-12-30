USE netflix_bd;
-- ----------------------------------------------------------
--       Normalización de la tabla 'netflix_titles'
-- ----------------------------------------------------------

/*  Insertamos en la tabla 'director' los valores de la columna director de la tabla 'netflix_titles' */
INSERT INTO director (nombre_director)
SELECT DISTINCT TRIM(value) AS nombre_director
FROM netflix_titles
CROSS APPLY STRING_SPLIT(director, ',')
WHERE TRIM(value) IS NOT NULL;
GO

SELECT * FROM Director; --Verificamos que se hayan cargado correctamente los datos; 
GO

/* Insertamos en la tabla 'actor' los valores de la columna reparto de la tabla 'netflix_titles' */
INSERT INTO Actor (nombre_actor)
SELECT DISTINCT TRIM(value) AS nombre_actor
FROM netflix_titles
CROSS APPLY STRING_SPLIT(reparto, ',')
WHERE TRIM(value) IS NOT NULL;
GO

SELECT * FROM actor; --Verificamos que se hayan cargado correctamente los datos;
GO

/* Insertamos en la tabla 'pais' los valores de la columna pais de la tabla 'netflix_titles' */
INSERT INTO Pais (nombre_pais)
SELECT DISTINCT TRIM(value) AS nombre_pais
FROM netflix_titles
CROSS APPLY STRING_SPLIT(pais, ',')
WHERE TRIM(value) IS NOT NULL;
GO

SELECT * FROM Pais; --Verificamos que se hayan cargado correctamente los datos;
GO

/* Insertamos en la tabla 'categoria' los valores de la columna categoria de la tabla 'netflix_titles' */
INSERT INTO Categoria (descripcion_categoria)
SELECT DISTINCT TRIM(value) AS descripcion_categoria
FROM netflix_titles
CROSS APPLY STRING_SPLIT(categoria, ',')
WHERE TRIM(value) IS NOT NULL;
GO

SELECT * FROM Categoria; --Verificamos que se hayan cargado correctamente los datos;
GO

-- ----------------------------------------------------------
--                   Insert tabla 'Tipo'
-- ----------------------------------------------------------

/* Insertamos en la tabla 'Tipo' los valores de la columna tipo (Movie-Tv Show) de la tabla 'netflix_titles' */
INSERT INTO Tipo (Tipo)
SELECT DISTINCT tipo 
FROM netflix_titles
WHERE tipo IS NOT NULL;
GO

select * from tipo; --ok
GO

/* Añadimos la columna id_tipo a la tabla 'netflix_titles' para establecer la relación entre ambas tablas. */
ALTER TABLE netflix_titles ADD id_tipo INT;
GO

/* Actualizamos la tabla 'netflix_titles' cargando los id de la tabla 'tipo' */
UPDATE netflix_titles SET id_tipo = (SELECT id_tipo 
									 FROM Tipo 
									 WHERE tipo = netflix_titles.tipo);
GO

select * from netflix_titles; -- Verificamos que se hayan cargado correctamente los valores;
GO

/* Verificamos si alguna fila quedó sin asignar id_tipo antes de añadir la restricción */
SELECT * FROM netflix_titles WHERE id_tipo IS NULL;
GO

/* Añadimos las restricción de clave foránea a la columna id_tipo de la tabla 'netflix_titles' */
ALTER TABLE netflix_titles ADD CONSTRAINT FK_Nt_Tipo FOREIGN KEY (id_tipo) REFERENCES Tipo(id_tipo);
GO

-- ----------------------------------------------------------
--                Insert tabla 'Clasificación'
-- ----------------------------------------------------------

/*  Inserción de los valores de la columna clasificacion en la tabla 'clasificacion' */
INSERT INTO Clasificacion (descripcion_clasificacion) 
SELECT DISTINCT clasificacion
FROM netflix_titles
WHERE clasificacion IS NOT NULL;
GO

SELECT * FROM Clasificacion; --ok
GO

/* Añadimos la columna id_clasificación a la tabla netflix_titles para establecer la relación entre ambas tablas */
ALTER TABLE netflix_titles ADD id_clasificacion INT;
GO

/* Actualizamos la tabla netflix_titles copiando cargando los valores de la columna id que coincidan con los de la tabla clasificación  */
UPDATE netflix_titles SET id_clasificacion = (SELECT id_clasificacion 
                                              FROM Clasificacion 
											  WHERE descripcion_clasificacion = netflix_titles.clasificacion);
GO

SELECT * FROM netflix_titles; --ok
GO

/* Añadios la restricción de clave foránea a la columna id_clasificacion de la tabla netflix_titles */
ALTER TABLE netflix_titles ADD CONSTRAINT FK_Nt_Clasificacion FOREIGN KEY (id_clasificacion) REFERENCES Clasificacion(id_clasificacion)
GO

-- ----------------------------------------------------------
--               Insert tabla 'Show_pais'
-- ----------------------------------------------------------

INSERT INTO Show_pais (show_id, id_pais)
SELECT nt.show_id, p.id_pais
FROM netflix_titles nt
CROSS APPLY STRING_SPLIT(nt.pais, ',') AS pais_split --recordar que la columna pais de nt tiene valores multivaluados.
INNER JOIN Pais p ON p.nombre_pais = TRIM(pais_split.value) --se compara con p.nombre_pais = pais_split en la tabla Pais para encontrar el id_pais correspondiente.
WHERE nt.pais IS NOT NULL;
GO

/* Pruebas: */
select * from Show_pais where show_id = 's2661'; --id pais 1, 36, 111
go
select pais from netflix_titles where show_id = 's2661' --(Puerto rico, US, Colombia) 
go
select * from pais; --1 puerto rico, 36 US, 111 Colombia
go
-- ----------------------------------------------------------
--                Insert tabla 'Show_categoria'
-- ----------------------------------------------------------

INSERT INTO Show_categoria(show_id, id_categoria)
SELECT nt.show_id, c.id_categoria
FROM netflix_titles nt
CROSS APPLY STRING_SPLIT(nt.categoria, ',') AS categoria_split 
INNER JOIN Categoria c ON c.descripcion_categoria = TRIM(categoria_split.value)
WHERE nt.categoria IS NOT NULL;
GO
SELECT * FROM Show_categoria;
GO

/* Pruebas: */
/*show_id s1 id_cat 40 | show_id s10 id_cat 9,13*/

select * from netflix_titles where show_id = 's1'; --categoria Documentaries 
go
select * from Categoria where id_categoria = 40;-- Documentaries 
go
select * from netflix_titles where show_id = 's10';--Comedies, Dramas
go
select * from Categoria;--9,13
go
select * from netflix_titles where show_id = 's1006'; --s1007
go
-- ----------------------------------------------------------
--                Insert tabla 'Show_Director'
-- ----------------------------------------------------------

INSERT INTO Show_Director(show_id, id_director)
SELECT DISTINCT nt.show_id, d.id_director --En este caso utilizamos DISTINCT para eliminar las filas duplicadas ya que existe un mismo director que aparece en el mismo show dos veces
FROM netflix_titles nt
CROSS APPLY STRING_SPLIT(nt.director, ',') AS director_split 
INNER JOIN Director d ON d.nombre_director = TRIM(director_split.value)
WHERE nt.director IS NOT NULL;
GO
/*
Infracción de la restricción PRIMARY KEY 'PK_ShowDirector'. No se puede insertar una clave duplicada en el objeto 'dbo.Show_director'. El valor de la clave duplicada es (1259, s5852).
Se terminó la instrucción.
*/ --SOLUCIONADO CON EL DISTINCT

-- ----------------------------------------------------------
--                Insert tabla 'Reparto'                    
-- ----------------------------------------------------------

INSERT INTO Reparto(show_id, id_actor)
SELECT DISTINCT nt.show_id, a.id_actor --DISTINCT 
FROM netflix_titles nt
CROSS APPLY STRING_SPLIT(nt.reparto, ',') AS reparto_split 
INNER JOIN Actor a ON a.nombre_actor = TRIM(reparto_split.value)
WHERE nt.reparto IS NOT NULL;
GO

SELECT * FROM Reparto;
GO

/* Pruebas: 
Prueba para ver si la combinación de claves es correcta y obtenemos la misma cantidad de actores 
*/
select reparto from netflix_titles where show_id = 's10'; -- 11 actores: Melissa McCarthy, Chris O'Dowd, Kevin Kline, Timothy Olyphant, Daveed Diggs, Skyler Gisondo, Laura Harrier, Rosalind Chao, Kimberly Quinn, Loretta Devine, Ravi Kapoor
go

/* Prueba parte 2 */
SELECT nt.show_id, a.id_actor
FROM netflix_titles nt
CROSS APPLY STRING_SPLIT(nt.reparto, ',') AS reparto_split 
INNER JOIN Actor a ON a.nombre_actor = TRIM(reparto_split.value)
WHERE nt.show_id = 's10'; ----show_id s10 11 actores
GO

-- ----------------------------------------------------
--     Eliminamos las columnas que fueron normalizadas 
-- ----------------------------------------------------
ALTER TABLE netflix_titles DROP COLUMN tipo;
ALTER TABLE netflix_titles DROP COLUMN director;
ALTER TABLE netflix_titles DROP COLUMN reparto;
ALTER TABLE netflix_titles DROP COLUMN pais;
ALTER TABLE netflix_titles DROP COLUMN clasificacion;
ALTER TABLE netflix_titles DROP COLUMN categoria;

SELECT * FROM netflix_titles;