
## °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
## Ejercicio de análisis de datos de encuestas en R
## SICCS 2024 - FCS UDELAR
## Martín Opertti
## Objetivo: en este ejercicio vamos a analizar la autoidentifiación ideológica
#  de los votantes uruguayos por partido y cómo se condice con la forma
# en que los uruguayos percibenla distancia ideológica entre estos partidos 
## °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°

library(tidyverse)
library(srvyr)
library(anesrake)
library(haven)
library(labelled)


## 1. Descargar datos de CSES del módulo 5 (descargar en formato .dta)


## 2. Filtrar base de datos para quedar solamente con las observaciones 
# de Uruguay

## 3. Transformar las variables categóricas a factores con as_factor()


## 4. Seleccionar el ponderador demográfico, las variables de ubicación de los
# partidos en el espectro ideológico (E3019_A, E3019_B, E3019_C, E3019_D), la 
# autoidentifación ideológica (E3020) y las de identificación partidaria
# (E3024_1, E3024_3, E3024_4)


## 5. Crear variable de identificación partidaria como en el código de la clase


## 6. Transformar variables de ideología a numéricas


## 7. Crear objeto de encuesta 


## 8. Estimar media e intervalo de confianza de auto identificación ideológica
# según identifcación partidaria


## 9. Graficar los resultados


## 10. Ahora calcular la percepción ideológica de cada partido según 
# identificación partidaria


## 11. Graficar resultados


## 12. Agregar valor real (autoidentifiación ideológica) al gráfico




