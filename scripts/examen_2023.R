
## ***************************************************************************
##   Examen de Introducción a la programación en R
##   Escuela de Invierno en Métodos - 2023
##   Martín Opertti
## ***************************************************************************

## El examen consiste en explorar, anlizar y visualizar datos de una base de 
# datos con información sobre países. La data fue extraída y recortada del
# siguiente repositorio (https://www.kaggle.com/fernandol/countries-of-the-world)  
# y la pueden encontrar en la carpeta data: "countries_world.csv". 
# Utilizar el .csv situado en la Webasignatura y no desde el enlace.

# Los distintos puntos pueden tener diferentes soluciones. Pueden usar tanto
# las funciones utilizadas en el curso como otras no vistas, mientras se llegue
# al resultado deseado


## 1. Importar la base y nombrarla "cw_df" y aplicar la función clean_names()
# del paquete Janitor para limpiar el nombre de las variables


## 2. Explorar el nombre y tipo de las variables, chequeando si hay alguna 
# variable en formato incorrecto. En caso de que sí, transformar a formato 
# correcto (ej. character a numeric o vice-versa).


## 3. Calcular estadísticos descriptivos de las variables que te parezcan más
# interesantes


## 4. Averiguar cuántos países no tienen datos en la variable literacy_percent,
# y luego eliminarlos del dataframe (sobreeescribir cw_df)


## 5. Crear una nueva variable llamada "dens_pob" con la densidad poblacional
# de cada país (se calcula como población divido área)


## 6. Crear una nueva variable "continente" con 5 categorías: Africa, Asia,
# Europa, America y Oceanía, a partir de los valores de la variable region
# Chequear con una tabla cruzada que la codificación sea correcta
# (incluir la región C.W. OF IND. STATES como parte de Asia)


## 7. Crear una nueva base llamada df_euro que contenga solamente países
# europeos y las variables country, region, continente, birthrate y deathrate


## 8. Utilizando el dataframe df_euro crear una tabla que contenga la media de
# birthrate y deathrate según región. No tener en cuenta casos perdidos al 
# calcular las medias


## 9. Crear un gráfico de barras a partir de la tabla debajo con los
# indicadores (media de birthrate y deathrate) en el eje de las x, el valor
# en el eje de las y, según región (denotada por el color de la barra, usar
# la paleta "Dark2" para seleccionar los colores del gráfico)

# (Partiendo de df_euro del punto anterior)
tabla_long <- df_euro %>% 
  group_by(region) %>% 
  summarize(mean_birth = mean(birthrate, na.rm = TRUE),
            mean_death = mean(deathrate, na.rm = TRUE)) %>% 
  pivot_longer(mean_birth:mean_death,
               names_to = "indicador",
               values_to = "valor")


## 10. Por último, retomar el dataframe cw_df y crear una visualización
# que no sea de barras, de cualquier variable que te parezca interesante, 
# utilizando al menos un aesthetics además de la posición (ej, color, tamaño,
# línea según alguna variable relevante)

