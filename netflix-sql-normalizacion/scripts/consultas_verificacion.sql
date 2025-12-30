USE netflix_bd;
-- ------------------------------------------------------------------------
-- **Responder las siguientes consultas de verificación de consistencia:**
-- ------------------------------------------------------------------------

---------------------------------------------------------------------------
--/* Cantidad de directores con mas de 10 películas o series dirigidas */--
---------------------------------------------------------------------------
SELECT COUNT(*) AS "Cantidad directores"
FROM (SELECT id_director
	 FROM Show_director
	 GROUP BY id_director
	HAVING COUNT(*) > 10 
	) AS "Dic con más de 10 shows";
GO
--Salida: 11 

---------------------------------------------------------------
--/* El actor con mayor participación en películas o series */--
---------------------------------------------------------------
SELECT TOP 1 r.id_actor, a.nombre_actor AS "Actor", COUNT(*) AS "Cantidad de Shows" 
FROM Reparto r 
INNER JOIN Actor a ON r.id_actor = a.id_actor --Unimos la tabla Reparto con la tabla Actor usando el id_actor
GROUP BY r.id_actor, a.nombre_actor
ORDER BY COUNT(*) DESC;
GO
--Salida: id_actor 2552, Anupam Kher, 43 participaciones 

---------------------------------------------------------------
--/* Cantidad de series añadidas en los últimos cinco años */--
---------------------------------------------------------------

SELECT COUNT(*) AS cantidad_series
FROM netflix_titles
WHERE YEAR(fecha_agregacion) BETWEEN
YEAR(GETDATE()) - 5 AND YEAR(GETDATE())
AND id_tipo = 2; --Tv show (no se tienen en cuenta las películas)
--Salida :1692