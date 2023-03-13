
## ***************************************************************************
##  Clase extra: Loops, condicionales y vectorización      
##  Código de la presentación         
##  Escuela de Invierno en Métodos    
##  Martín Opertti - 2022             
## ***************************************************************************


##  2 Loops  ==============================================================

rm(list=ls())

## 2.1. Loops tradicionales ----

# Un loop sencillo: 
numeros_primos <- c(2, 3, 5, 7, 11, 13, 17, 19)

for (i in seq_along(numeros_primos)){
  
  print(paste(numeros_primos[i], "es un numero primo"))
  
}

# Para guardar todos los elementos
numeros_primos <- c(2, 3, 5, 7, 11, 13, 17, 19)

# Creo objeto vacío
obj_vacio <- vector("character", # definimos el tipo de los datos  
                    length(numeros_primos))  # definimos la extensión

for (i in seq_along(numeros_primos)){
  
  obj_vacio[i] <- paste(numeros_primos[i], "es un numero primo")
  
}

obj_vacio

# Para guardar cada elemento
numeros_primos <- c(2, 3, 5, 7, 11, 13, 17, 19)

# Creo un vector con el nombre de cada objeto
nom_np <- paste(numeros_primos, "obj", sep = "_")

for (i in seq_along(numeros_primos)){
  
  assign(nom_np[i], 
         paste(numeros_primos[i], "es un numero primo")
  )
}

# Abrir archivos dentro de una carpeta
library(gapminder)
d_gap <- (gapminder)
table(gapminder$continent)

# Divido el dataframe de gapminder según continente
lista_df <- d_gap %>%
  group_split(continent, named = TRUE) %>% 
  setNames(sort(unique(d_gap$continent)))

# El objeto resultante es una lista con dataframes adentro
lista_df # Chequear que nombres estén bien

# De esta forma, puedo hacer un loop para guardar cada uno de ellos 
for (i in seq_along(lista_df)) {
  
  filename <-  paste0("resultados/loops/", names(lista_df)[i], ".csv")
  write.csv(lista_df[[i]], filename)
  
}

# Ahora con un loop leo todos los .csv en la carpeta "resultados/loop"
rm(list=ls())

# Lista con dataframes
filenames <- list.files("resultados/loops", full.names=TRUE)

# Creo la lista con los nombres que va a tener cada base (sacar .csv)
namesfiles <- substr(filenames, 18, nchar(filenames)-4) 

# Ahora hago un loop para leer cada base
for (i in seq_along(filenames)) {
  
  assign(namesfiles[i], 
         read_csv(filenames[i])
  )
}


## 2.2. Loops con dataframes ----

# Por último, operaciones sobre todos los dataframes
lista_df_new <- list(Africa, Americas, Asia, Europe, Oceania)
names(lista_df_new) <- c("Africa", "Americas", "Asia", "Europe", "Oceania")


# Una versión menos manual
rm(lista_df_new, filenames, i, namesfiles)
# Une todos los objetos en el ambiente, es decir, si tenemos algo en el 
# ambiente que no queremos incluir debemos o borrarlo o establecer el argumento
# pattern dentro de ls() para indicar que elementos incluir
lista_df_new <- mget(ls())

names(lista_df_new)

list_df_final <- lapply(lista_df_new, function(base) {
  
  base <- base %>% 
    mutate(var_nueva = "Valor nuevo") %>% 
    select(-lifeExp)
  
})

# Unir todos los dataframes
df_gapminder <- bind_rows(list_df_final)
as_tibble(df_gapminder)

# Elimino todos los objetos del ambiente menos list_df_final
rm(list=setdiff(ls(), "list_df_final"))

# Exportar todos los dataframes al ambiente
list2env(list_df_final, .GlobalEnv)

# Podríamos haber hecho todo con lapply 
filenames <- list.files("resultados/loops", full.names=TRUE)

lista_df_2 <- lapply(filenames, read.csv)

# Agrego nombres
names(lista_df_2) <- c("Africa", "Americas", "Asia", "Europe", "Oceania")

# Unimos nuevamente
df_gapminder_2 <- bind_rows(lista_df_2)
as_tibble(df_gapminder_2)

# Exporto nuevamente al ambiente
rm(list=setdiff(ls(), "lista_df_2"))

list2env(lista_df_2, .GlobalEnv)
