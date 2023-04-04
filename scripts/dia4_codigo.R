
## ***************************************************************************
##   Día 4: Visualización de datos y estadística inferencial
##   Código de la presentación         
##   Escuela de Invierno en Métodos    
##   Martín Opertti - 2022             
## ***************************************************************************


## 0. Paquetes  ==============================================================

library(tidyverse)
library(gapminder)
library(RColorBrewer)
library(viridis)


##  1. Gráficos con ggplot2   ===============================================

d_gap_7 <- gapminder %>% 
  filter(year == 2007)

# Especifico la data a usar
ggplot(data = d_gap_7)
ggsave("resultados/plots/plot1.png", width = 30, height = 20, units = "cm")


# Asigno las primeras aesthetics (posición: x e y)
ggplot(data = d_gap_7, aes(x = gdpPercap, y = lifeExp))
ggsave("resultados/plots/plot2.png", width = 30, height = 20, units = "cm")


# Agrego con + una segunda capa: geom_point para dispersión
ggplot(data = d_gap_7, aes(x = gdpPercap, y = lifeExp)) +
  geom_point()
ggsave("resultados/plots/plot3.png", width = 30, height = 20, units = "cm")


# Asigno atributos de geom_point: color, size, shape
ggplot(data = d_gap_7, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(color = "black", fill = "skyblue3", size = 3, shape = 21)
ggsave("resultados/plots/plot4.png", width = 30, height = 20, units = "cm")


# Asigno color según una variable que agrupa (siempre dentro de aes()!)
ggplot(data = d_gap_7, aes(x = gdpPercap, y = lifeExp, fill = continent)) +
  geom_point(size = 3, shape = 21, alpha = .7) 
ggsave("resultados/plots/plot5.png", width = 30, height = 20, units = "cm")


# También puedo crear la línea de tendencia por grupo!
ggplot(data = d_gap_7, 
               aes(x = gdpPercap, y = lifeExp, fill = continent, color = continent)) +
  geom_point(size = 3, shape = 21,  alpha = .7) +
  geom_smooth(method = "lm", se = FALSE)
ggsave("resultados/plots/plot6.png", width = 30, height = 20, units = "cm")


# Cambiamos la escala de las x. Probar también xlim() e ylim()
ggplot(data = d_gap_7, 
       aes(x = gdpPercap, y = lifeExp, fill = continent, color = continent)) +
  geom_point(size = 3, shape = 21,  alpha = .7) +
  geom_smooth(method = "lm", se = FALSE) +
  scale_x_log10() 
ggsave("resultados/plots/plot7.png", width = 30, height = 20, units = "cm")


# Agregamos facetas
ggplot(data = d_gap_7 %>% 
         filter(continent != "Oceania"), 
       aes(x = gdpPercap, y = lifeExp, fill = continent, color = continent)) +
  geom_point(size = 3, shape = 21,  alpha = .7) +
  geom_smooth(method = "lm", se = FALSE) +
  scale_x_log10() +
  facet_wrap(~ continent) 
ggsave("resultados/plots/plot8.png", width = 30, height = 20, units = "cm")


# Quitamos etiqueta duplicada
ggplot(data = d_gap_7 %>% 
         filter(continent != "Oceania"), 
       aes(x = gdpPercap, y = lifeExp, fill = continent, color = continent)) +
  geom_point(size = 3, shape = 21,  alpha = .7) +
  geom_smooth(method = "lm", se = FALSE) +
  scale_x_log10() +
  facet_wrap(~ continent) +
  theme(legend.position = "none")
ggsave("resultados/plots/plot9.png", width = 30, height = 20, units = "cm")


# Quitamos colores innecesarios
ggplot(data = d_gap_7 %>% 
         filter(continent != "Oceania"), 
       aes(x = gdpPercap, y = lifeExp)) +
  geom_point(size = 3, shape = 21,  alpha = .7, fill = "skyblue") +
  geom_smooth(method = "lm", se = FALSE, color = "navyblue") +
  scale_x_log10() +
  facet_wrap(~ continent) 

ggsave("resultados/plots/plot10.png", width = 30, height = 20, units = "cm")


# Agregamos tamaño de población 
ggplot(data = d_gap_7 %>% 
         filter(continent != "Oceania"), 
       aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(size = pop), shape = 21,  alpha = .7, fill = "skyblue") +
  geom_smooth(method = "lm", se = FALSE, color = "navyblue") +
  scale_x_log10() +
  facet_wrap(~ continent) 

ggsave("test.png", width = 30, height = 20, units = "cm")


# Población en millones
ggplot(data = d_gap_7 %>% 
         filter(continent != "Oceania") %>% 
         mutate(pop_mil = pop / 1000000), 
       aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(size = pop_mil), shape = 21,  alpha = .7) +
  geom_smooth(method = "lm", se = FALSE) +
  scale_x_log10() +
  facet_wrap(~ continent) +
  theme(legend.position = "bottom") +
  scale_size_continuous(name = "esto es una prueba") 

ggsave("resultados/plots/plot12.png", width = 30, height = 20, units = "cm")


# Agregamos tema y etiquetas
ggplot(data = d_gap_7 %>% 
         filter(continent != "Oceania") %>% 
         mutate(pop_mil = pop / 1000000),
       aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(size = pop_mil), shape = 21,  alpha = .7, fill = "skyblue") +
  geom_smooth(method = "lm", se = FALSE, color = "navyblue") +
  scale_x_log10() +
  facet_wrap(~ continent) +
  scale_size_continuous(name = "Población (en millones)") +
  labs(title = "PBI per cápita y expectativa de vida",
       subtitle = "Data de 2017",
       caption = "Fuente: Gapminder",
       x = "PBI per cápita",
       y = "Expectativa de vida") +
  theme_bw() +
  theme(legend.position = "bottom") # Movemos hacia abajo porque theme_bw() la soobreescribe

ggsave("resultados/plots/plot13.png", width = 30, height = 20, units = "cm")


## Con theme_set() podemos fijar el tema para todos los gráficos sin necesidad de volver a 
# especificar
theme_set(theme_bw(base_size = 15))



##  2. Aesthetics  ===========================================================

##  2.1. Formas  ----

# Sirve pirncipalmente para geom_point()

rm(list = ls())

d_gap_7 <- gapminder %>% 
  filter(year == 2007)

# Definir forma específica
ggplot(d_gap_7, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(shape = 9, size = 3)

ggsave("resultados/plots/plot14.png", width = 30, height = 20, units = "cm")


# Asignar forma según continente (ggplot elige por defecto formas)
ggplot(d_gap_7, 
       aes(x = gdpPercap, y = lifeExp, shape = continent)) +
  geom_point(size = 3) +
  theme(legend.position = "bottom")

ggsave("resultados/plots/plot15.png", width = 30, height = 20, units = "cm")


# Definir manualmente la forma para cada continente
ggplot(d_gap_7, 
       aes(x = gdpPercap, y = lifeExp, shape = continent)) +
  geom_point(size = 3) +
  theme(legend.position = "bottom") +
  scale_shape_manual(name = "Continente",
                     values = c(15, 16, 17, 18, 19))

ggsave("resultados/plots/plot16.png", width = 30, height = 20, units = "cm")


# Definir manualmente la forma para cada continente (otra forma)
ggplot(d_gap_7, 
       aes(x = gdpPercap, y = lifeExp, shape = continent)) +
  geom_point(size = 3) +
  theme(legend.position = "bottom") +
  scale_shape_manual(name = "Continente",
                     values = c("Europe" = 3,
                                "Oceania" = 8, 
                                "Africa" = 12, 
                                "Asia" = 18, 
                                "Americas" = 22))

ggsave("resultados/plots/plot17.png", width = 30, height = 20, units = "cm")


##  2.2. Líneas  ----

pais_conosur <- c("Argentina", "Chile", "Uruguay")

conosur <- gapminder %>% 
  filter(country %in% pais_conosur)

# Lineas por variable
ggplot(conosur, aes(x = year, y = lifeExp)) +
  geom_line(aes(linetype = country)) +
  theme(legend.position = "bottom")

ggsave("resultados/plots/plot18.png", width = 30, height = 20, units = "cm")


# Definir tipo de linea por país
ggplot(conosur, aes(x = year, y = lifeExp)) +
  geom_line(aes(linetype = country)) +
  theme(legend.position = "bottom") +
  scale_linetype_manual(name = "País",
                        values = c("Argentina" = "dotted",
                                   "Chile" = "dashed",
                                   "Uruguay" = "solid"))

ggsave("resultados/plots/plot19.png", width = 30, height = 20, units = "cm")


# Definir tipo de linea por país
ggplot(conosur, aes(x = year, y = lifeExp)) +
  geom_line(aes(linetype = country)) +
  geom_point(aes(shape = country)) +
  theme(legend.position = "bottom") +
  scale_linetype_manual(name = "País",
                        values = c("Argentina" = "dotted",
                                   "Chile" = "dashed",
                                   "Uruguay" = "solid")) +
  labs(linetype = "País", shape = "País")  # Une las etiquetas (sino se duplican)

ggsave("resultados/plots/plot20.png", width = 30, height = 20, units = "cm")


##  2.3. Colores  ----

# Lista de colores
colours()

# Paletas de colores de RColorBrewer
par(mar=c(3,4,2,2))
display.brewer.all()

america07 <- gapminder %>% 
  filter(continent == "Americas" & year == 2007)


# Color por país (ggplot elige automático)
ggplot(conosur, aes(x = year, y = lifeExp, color = country)) +
  geom_line() +
  geom_point() +
  theme(legend.position = "bottom")

ggsave("resultados/plots/plot21.png", width = 30, height = 20, units = "cm")


# Color por país (asigno colores manualmente)
ggplot(conosur, aes(x = year, y = lifeExp, color = country)) +
  geom_line() +
  geom_point() +
  theme(legend.position = "bottom") +
  scale_color_manual(name = "País",
                     values = c("midnightblue", "red3", "lightskyblue"))

ggsave("resultados/plots/plot22.png", width = 30, height = 20, units = "cm")


# Color por país (otros detalles estéticos)
ggplot(conosur, aes(x = year, y = lifeExp, color = country)) +
  geom_line(size = 1.5, alpha = 0.4) +
  geom_point(size = 3) +
  theme(legend.position = "bottom") +
  scale_color_manual(name = "País",
                     values = c("midnightblue", "red3", "lightskyblue"))

ggsave("resultados/plots/plot23.png", width = 30, height = 20, units = "cm")


# Color por país (usando paletas de RColorBrewer: elegir una discreta para este caso)
ggplot(conosur, aes(x = year, y = lifeExp, color = country)) +
  geom_line(size = 1.5, alpha = 0.4) +
  geom_point(size = 3) +
  theme(legend.position = "bottom") +
  scale_color_brewer(palette = "Dark2")

ggsave("resultados/plots/plot24.png", width = 30, height = 20, units = "cm")


# Color con paleta continua con paquete viridis 
ggplot(d_gap_7, aes(x = pop, y = gdpPercap, color = lifeExp)) +
  geom_point(size = 3) +
  scale_x_log10() +
  scale_color_viridis(name = "Expectativa de vida") +
  theme(legend.position = "bottom") 

ggsave("resultados/plots/plot25.png", width = 30, height = 20, units = "cm")


# Color con paleta continua especificando valores
ggplot(d_gap_7, aes(x = pop, y = gdpPercap, color = lifeExp)) +
  geom_point(size = 3) +
  scale_x_log10() +
  scale_color_gradient(name = "Expectativa de vida", low = "red", high = "Blue") +
  theme(legend.position = "bottom") 

ggsave("resultados/plots/plot26.png", width = 30, height = 20, units = "cm")



##  3. Otros geoms  =========================================================

##  3.1. geom_bar() ----
table(d_gap_7$continent)

# Graficar cuántos países hay por continente en nuestra base
ggplot(data = d_gap_7, aes(x = continent)) +
  geom_bar()

ggsave("resultados/plots/plot27.png", width = 30, height = 20, units = "cm")


# Con datos resumidos (no funciona)
data_resumen <- d_gap_7 %>% 
  group_by(continent) %>% 
  summarize(n = n())

ggplot(data_resumen, aes(x = continent)) +
  geom_bar()

ggsave("resultados/plots/plot28.png", width = 30, height = 20, units = "cm")


# Para eso podemos usar geom_col(), especificando cuál es la columna con el valor
data_resumen <- d_gap_7 %>% 
  group_by(continent) %>% 
  summarize(n = n())

ggplot(data_resumen, aes(x = continent, y = n)) +
  geom_col()

ggsave("resultados/plots/plot28_b.png", width = 30, height = 20, units = "cm")


# Supongamos que queremos ver cuántos países con esperanza de vida mayor a 75
# hay por continente
data75 <- d_gap_7 %>% 
  mutate(esp = case_when(lifeExp > 75 ~ 1,
                         TRUE ~ 0)) %>% 
  group_by(continent, esp) %>% 
  summarize(n = n())

ggplot(data75, aes(x = continent, y = n, fill = as.factor(esp))) +
  geom_col(position = "stack")

ggsave("resultados/plots/plot31.png", width = 30, height = 20, units = "cm")


## Posición
# Barras agrupadas
ggplot(data75, aes(x = continent, y = n, fill = as.factor(esp))) +
  geom_col(position = "dodge")

ggsave("resultados/plots/plot32.png", width = 30, height = 20, units = "cm")


# Barras proporción
ggplot(data75, aes(x = continent, y = n, fill = as.factor(esp))) +
  geom_col(position = "fill")

ggsave("resultados/plots/plot33.png", width = 30, height = 20, units = "cm")


## Estética 
# Volvamos a nuestro gráfico de barras original 
ggplot(data = data_resumen, aes(x = continent, y = n)) +
  geom_col(color = "black", fill = "skyblue3", alpha = .8) +
  labs(title = "Cantidad de países por continente",
       subtitle = "Data de Gapminder para el año 2007",
       caption = "Fuente: Gapminder",
       x = "",
       y = "")

ggsave("resultados/plots/plot34.png", width = 30, height = 20, units = "cm")


# Podemos girar el gráfico 
ggplot(data = data_resumen, aes(x = continent, y = n)) +
  geom_col(color = "black", fill = "skyblue3", alpha = .8) +
  labs(title = "Cantidad de países por continente",
       subtitle = "Data de Gapminder para el año 2007",
       caption = "Fuente: Gapminder",
       x = "",
       y = "") +
  coord_flip()

ggsave("resultados/plots/plot35.png", width = 30, height = 20, units = "cm")


# Podemos ordenar categorías como queramos 
positions <- c("Americas", "Europe", "Africa", "Oceania", "Asia")

ggplot(data = data_resumen, aes(x = continent, y = n)) +
  geom_col(color = "black", fill = "skyblue3", alpha = .8) +
  labs(title = "Cantidad de países por continente",
       subtitle = "Data de Gapminder para el año 2007",
       caption = "Fuente: Gapminder",
       x = "",
       y = "") +
  scale_x_discrete(limits = positions)

ggsave("resultados/plots/plot36.png", width = 30, height = 20, units = "cm")


# Podemos ordenar por la frecuencia de la variable
ggplot(data = data_resumen, aes(x = continent, y = n)) +
  geom_col(color = "black", fill = "skyblue3", alpha = .8) +
  labs(title = "Cantidad de países por continente",
       subtitle = "Data de Gapminder para el año 2007",
       caption = "Fuente: Gapminder",
       x = "",
       y = "") 

ggsave("resultados/plots/plot37.png", width = 30, height = 20, units = "cm")


##  3.2. geom_text() ----

lista_a_sur <- c("Argentina", "Brazil", "Bolivia", "Chile", "Colombia", 
                 "Ecuador", "Paraguay", "Peru", "Uruguay", "Venezuela")
a_sur <- gapminder %>% 
  filter(year == 2007 & country %in% lista_a_sur)

## Gráfico de dispersión expectativa de vida y pbi per cápita
ggplot(a_sur, aes(x = gdpPercap, y = lifeExp)) +
  geom_point()

ggsave("resultados/plots/plot38.png", width = 30, height = 20, units = "cm")


# No es muy informativo, tenemos pocos puntos, podemos agregar etiquetas
ggplot(a_sur, aes(x = gdpPercap, y = lifeExp)) +
  geom_point() +
  geom_text(aes(label = country))

ggsave("resultados/plots/plot39.png", width = 30, height = 20, units = "cm")


# Podemos ajustar la posición de las etiquetas
ggplot(a_sur, aes(x = gdpPercap, y = lifeExp)) +
  geom_point() +
  geom_text(aes(label = country), hjust = 0.5, vjust = -1)

ggsave("resultados/plots/plot40.png", width = 30, height = 20, units = "cm")


# Podemos también dejar solo el texto
ggplot(a_sur, aes(x = gdpPercap, y = lifeExp)) +
  geom_text(aes(label = country))

ggsave("resultados/plots/plot41.png", width = 30, height = 20, units = "cm")


# También podemos usar geom_text() combinados con otros geoms
ggplot(data = d_gap_7, aes(x = fct_infreq(continent))) +
  geom_bar(color = "black", fill = "skyblue3", alpha = .8) +
  geom_text(aes(label = ..count..), stat = "count", vjust = -.5, fontface = "bold") +
  labs(title = "Cantidad de países por continente",
       subtitle = "Data de Gapminder para el año 2007",
       caption = "Fuente: Gapminder",
       x = "",
       y = "") 

ggsave("resultados/plots/plot42.png", width = 30, height = 20, units = "cm")


# Para anotaciones podemos usar annotate()
ggplot(data = d_gap_7, aes(x = fct_infreq(continent))) +
  geom_bar(color = "black", fill = "skyblue3", alpha = .8) +
  geom_text(aes(label = ..count..), stat = "count", vjust = -.5, fontface = "bold") +
  labs(title = "Cantidad de países por continente",
       subtitle = "Data de Gapminder para el año 2007",
       caption = "Fuente: Gapminder",
       x = "",
       y = "") +
  annotate("text", x = "Oceania", y = 10, label = "Que pocos países \n hay en Oceanía")

ggsave("resultados/plots/plot43.png", width = 30, height = 20, units = "cm")


## 4.3. geom_boxplot() ----

## Boxplot tradicional
d_gap_7 %>%
  filter(continent != "Oceania") %>% 
  ggplot(aes(x = continent, y = gdpPercap)) +
  geom_boxplot() 

ggsave("resultados/plots/plot44.png", width = 30, height = 20, units = "cm")


# Boxplot con todos los puntos con geom_jitter()
d_gap_7 %>%
  filter(continent != "Oceania") %>% 
  ggplot(aes(x = continent, y = gdpPercap)) +
  geom_boxplot(aes(fill = continent), outlier.shape = NA, lwd=1, alpha=0.4) +
  geom_jitter(aes(color = continent), size = 4, alpha = 0.9) +
  scale_color_brewer(palette = "Dark2") +
  scale_fill_brewer(palette = "Dark2") +
  theme(legend.position = "none")

ggsave("resultados/plots/plot45.png", width = 30, height = 20, units = "cm")


## 5.4. geom_density() ----

## Distribución del PBI per cápita en 2007
ggplot(d_gap_7, aes(x = gdpPercap)) +
  geom_density() 

ggsave("resultados/plots/plot46.png", width = 30, height = 20, units = "cm")


# Agregamos colores
ggplot(d_gap_7, aes(x = gdpPercap)) +
  geom_density(fill = "seagreen3", alpha = .7) 

ggsave("resultados/plots/plot47.png", width = 30, height = 20, units = "cm")


# Desagregar por continente
d_gap_7 %>%
  filter(continent != "Oceania") %>%
  ggplot(aes(x = gdpPercap, fill = continent)) +
  geom_density( alpha = .7, adjust = 1.5) +
  scale_fill_brewer(palette = "Accent") +
  facet_wrap(~ continent)

ggsave("resultados/plots/plot48.png", width = 30, height = 20, units = "cm")


