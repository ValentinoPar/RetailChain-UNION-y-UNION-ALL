# UNION y UNION ALL – RetailChain

Consolidación del inventario de las sucursales Norte y Sur de RetailChain usando los
operadores UNION y UNION ALL de SQL.

## Archivos
- `schema.sql`: crea las tablas `inventario_sucursal_norte` e `inventario_sucursal_sur`
  y carga los datos de prueba.
- `soluciones.sql`: consulta de catálogo (UNION), consulta de auditoría (UNION ALL) y
  la comparación de conteos de filas.

## 1. ¿Cuántas filas devuelve cada consulta y por qué son distintas?

| Consulta | Operador | Filas |
|---|---|---|
| Catálogo unificado | UNION | 11 |
| Auditoría de stock | UNION ALL | 14 |

Cada sucursal tiene 7 registros, así que UNION ALL devuelve 7 + 7 = 14 filas, porque
simplemente apila ambas tablas. UNION devuelve 3 filas menos porque elimina las que son
exactamente iguales en las dos sucursales. Esas tres filas son:

- 103, Monitor 4K 27", Computación
- 104, Teclado Mecánico, Accesorios
- 106, SSD Externo 1TB, Almacenamiento

Los tres productos están en Norte y en Sur con el mismo id, el mismo nombre y la misma
categoría, por eso UNION los deja una sola vez.

La Webcam HD 1080p es un caso aparte: en Norte tiene el id 107 y en Sur el 111. Como el id
es distinto, las filas no son idénticas y UNION no las elimina, aunque el nombre sea igual.
Esto muestra que UNION compara la fila completa, no el "producto" como lo entendería una
persona.

Un detalle importante: el catálogo se arma sin la columna `stock`. Si se incluyera, el
monitor 103 tendría 5 unidades en Norte y 3 en Sur, las filas dejarían de ser idénticas y
UNION devolvería 14 filas igual que UNION ALL.

## 2. ¿Por qué UNION ALL es más eficiente que UNION?

UNION ALL solo une los resultados de los dos SELECT, uno a continuación del otro. UNION
hace ese mismo trabajo y además una operación extra: eliminar duplicados. Para eso el motor
tiene que comparar las filas entre sí, ya sea ordenando todo el resultado o armando una
estructura de agrupación (hash), y recién después descarta las repetidas. Ese paso consume
más CPU y memoria, y el costo crece a medida que aumenta la cantidad de filas. Con 14
registros no se nota, pero con millones sí.

## 3. ¿En qué casos usaría cada uno?

**UNION** (cuando no quiero repetidos):
- Armar una lista de clientes para una campaña de email a partir de dos bases (ecommerce y
  tienda física), para no enviarle dos correos a la misma persona.
- Obtener la lista de proveedores que aparecen en las tablas de compras y de contabilidad,
  sin repetir ninguno.

**UNION ALL** (cuando necesito todos los registros):
- Juntar las ventas de cada mes, guardadas en tablas separadas, para calcular el total
  anual. Cada venta cuenta, aunque dos tengan los mismos datos.
- Unir los logs de dos servidores para contar cuántos eventos hubo en total: un mismo error
  registrado dos veces son dos eventos y no deben colapsarse en uno.

## 4. ¿Qué pasa si las columnas de ambas consultas no coinciden?

- **Distinto número de columnas:** SQL Server da un error indicando que todas las consultas
  combinadas con UNION deben tener el mismo número de expresiones en su lista de selección.
- **Tipos incompatibles** (por ejemplo, una columna INT contra una VARCHAR con texto): el
  motor intenta convertir los tipos y, si no puede, falla con un error de conversión
  (`Conversion failed...`) o con un choque de tipos (`Operand type clash`).

Además, los nombres de las columnas del resultado final se toman de la primera consulta, y
las columnas se emparejan por posición y no por nombre. Por eso hay que mantener el mismo
orden en ambos SELECT.
