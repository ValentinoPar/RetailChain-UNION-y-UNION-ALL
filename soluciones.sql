-- ══════════════════════════════════════════
-- RetailChain — UNION y UNION ALL
-- Autor: Valentino Parmigiani
-- Fecha: 9/10/2026
-- ══════════════════════════════════════════

-- ── CONSULTA 1: UNION ────────────────────
-- Reporte de Catálogo Unificado
-- Pregunta de negocio: ¿Qué productos únicos comercializa
-- la empresa en toda su red de sucursales?
-- Operador: UNION (elimina filas completamente duplicadas)
select id_producto,nombre_producto,categoria
from inventario_sucursal_norte as isn
union
select id_producto,nombre_producto,categoria
from inventario_sucursal_sur as iss
order by id_producto;

-- ── CONSULTA 2: UNION ALL ────────────────
-- Auditoría de Stock Total
-- Pregunta de negocio: ¿Cuántos registros físicos de stock
-- existen en total entre ambas sucursales?
-- Operador: UNION ALL (mantiene todos los registros incluyendo duplicados)
select 'norte' as sucursal, id_producto,nombre_producto,categoria,stock
from inventario_sucursal_norte as isn
union all
select 'sur'as sucursal, id_producto,nombre_producto,categoria,stock
from inventario_sucursal_sur as iss
order by id_producto;


-- ── CONSULTA 3: COMPARACIÓN DE RESULTADOS ─
-- Ejecutá estas dos consultas para comparar cuántas filas
-- devuelve cada operador y explicá la diferencia en tu README

SELECT COUNT(*) AS filas_union     
FROM
(select id_producto,nombre_producto,categoria
from inventario_sucursal_norte as isn
union
select id_producto,nombre_producto,categoria
from inventario_sucursal_sur as iss)
AS resultado_union;

SELECT COUNT(*) AS filas_union_all 
FROM (select id_producto,nombre_producto,categoria
from inventario_sucursal_norte as isn
union all
select id_producto,nombre_producto,categoria
from inventario_sucursal_sur as iss) 
AS resultado_union_all;
