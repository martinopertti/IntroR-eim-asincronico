
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

rm(list=ls())


## 1. Descargar datos de CSES del módulo 5 (descargar en formato .dta)

df <- read_dta('CSES/cses5_stata/cses5.dta') 

## 2. Filtrar base de datos para quedar solamente con las observaciones 
# de Uruguay
df <- df %>% 
  filter(E1006_NAM == 'Uruguay')


## 3. Transformar las variables categóricas a factores con as_factor()

df <- df %>% 
  haven::as_factor() 

## 4. Seleccionar el ponderador demográfico, las variables de ubicación de los
# partidos en el espectro ideológico (E3019_A, E3019_B, E3019_C, E3019_D), la 
# autoidentifación ideológica (E3020) y las de identificación partidaria
# (E3024_1, E3024_3, E3024_4)


df <- df %>% 
  select(ponderador = E1010_2, # Ponderador sociodemográfico
         # Ubicación de los partidos en el espectro ideológico
         ideo_fa = E3019_A,
         ideo_pn = E3019_B,
         ideo_pc = E3019_C,
         ideo_ca = E3019_D,
         auto_ideo = E3020, # Autoidentificación ideológica
         # Identificación partidaria
         pid_1 = E3024_1, # Cercano a algún partido
         pid_2 = E3024_3, # Partido político + cercano
         pid_3 = E3024_4 # Cercanía
         )

## 5. Crear variable de identificación partidaria como en el código de la clase
df <- df %>% 
  mutate(pid_cerano = case_when(
    pid_3 %in% c('1. VERY CLOSE', '2. SOMEWHAT CLOSE', '3. NOT VERY CLOSE') ~ 'Cercano',
    TRUE ~ 'No'
  ))

table(df$pid_cerano)

df <- df %>% 
  mutate(pid_total = case_when(
    pid_cerano == 'Cercano' & pid_2 == '858001. URY - Broad Front' ~ 'Frente Amplio',
    pid_cerano == 'Cercano' & pid_2 == '858002. URY - National Party' ~ 'Partido Nacional',
    pid_cerano == 'Cercano' & pid_2 == '858003. URY - Colorado Party' ~ 'Partido Colorado',
    pid_cerano == 'Cercano' & pid_2 == '858004. URY - Open Cabildo' ~ 'Cabildo Abierto',
    TRUE ~ NA_character_
  ),
  pid_bloque = case_when(
    pid_total %in% c('Partido Nacional',
                     'Partido Colorado', 
                     'Cabildo Abierto') ~ 'Coalición Multicolor',
    pid_total == 'Frente Amplio' ~ 'Frente Amplio',
    TRUE ~ NA_character_
  )) 

table(df$pid_total)
table(df$pid_bloque)

## 6. Transformar variables de ideología a numéricas

df <- df %>% 
  mutate(ideo_fa_num = 
           case_when(
             ideo_fa %in% c('14', '15') ~ NA_real_,
             TRUE ~ as.numeric(ideo_fa) 
           ),
         ideo_pn_num = 
           case_when(
             ideo_pn %in% c('14', '15') ~ NA_real_,
             TRUE ~ as.numeric(ideo_pn)  
           ),
         ideo_pc_num = 
           case_when(
             ideo_pc %in% c('14', '15') ~ NA_real_,
             TRUE ~ as.numeric(ideo_pc)  
           ),
         ideo_ca_num = 
           case_when(
             ideo_ca %in% c('14', '15') ~ NA_real_,
             TRUE ~ as.numeric(ideo_ca)  
           ),
         auto_ideo_num = 
           case_when(
             auto_ideo %in% c('14', '15') ~ NA_real_,
             TRUE ~ as.numeric(auto_ideo)  
           )
  )

## 7. Crear objeto de encuesta 

svy <- df %>% 
  as_survey_design(weight = ponderador)


## 8. Estimar media e intervalo de confianza de auto identificación ideológica
# según identifcación partidaria

table_1 <- svy %>%
  group_by(pid_total) %>% 
  srvyr::summarize(media_id = survey_mean(auto_ideo_num, 
                                          vartype = c("se", "ci"),
                                          na.rm = T)) %>% 
  filter(!is.na(pid_total))


## 9. Graficar los resultados

ggplot(data = table_1, aes(x = fct_reorder(pid_total, -media_id), 
                           y = media_id)) +
  geom_point() +
  geom_errorbar(aes(ymin = media_id_low, ymax = media_id_upp), 
                width = .05, lwd = .5) +
  ylim(0, 10) +
  labs(title = "Autoidentificación ideológica según identificación partidaria en Uruguay \n en 2019.",
       subtitle = "Datos de CSES",
       y = "",
       x = "") +
  theme_bw() 


## 10. Ahora calcular la percepción ideológica de cada partido según 
# identificación partidaria

table_2 <- svy %>%
  group_by(pid_total) %>% 
  srvyr::summarize('Frente Amplio' = survey_mean(ideo_fa_num, vartype = c("ci"), 
                                       na.rm = T),
                   'Partido Nacional' = survey_mean(ideo_pn_num, vartype = c("ci"), 
                                       na.rm = T),
                   'Partido Colorado' = survey_mean(ideo_pc_num, vartype = c("ci"), 
                                       na.rm = T),
                   'Cabildo Abierto' = survey_mean(ideo_ca_num, vartype = c("ci"), 
                                       na.rm = T)
                   ) %>% 
  filter(!is.na(pid_total)) %>% 
  pivot_longer(-pid_total) %>% 
  separate(name, into = c("id", "value_type"), sep = "_") %>% 
  pivot_wider(names_from = value_type,
              values_from = value,
              names_prefix = "id_") %>% 
  mutate(pid_total = factor(pid_total,
                            levels = c('Frente Amplio',
                                       'Partido Nacional',
                                       'Partido Colorado',
                                       'Cabildo Abierto'))) 

## 11. Graficar resultados

ggplot(data = table_2, aes(x = fct_reorder(id, id_NA), 
                           y = id_NA, color = pid_total)) +
  geom_point(size = 2, position = position_dodge(width = 0.5)) +
  geom_errorbar(aes(ymin = id_low, ymax = id_upp), 
                width = .075, lwd = .75,
                position = position_dodge(width = 0.5)) +
  ylim(2, 11) +
  labs(title = "Percepción ideológica de principales partidos según identificación \n partidaria en Uruguay en 2019.",
       subtitle = "Datos de CSES",
       y = "",
       x = "") +
  theme_bw(base_size=16) +
  scale_color_manual(name = '', values = c('#117A65', '#3498DB',
                                           "#A93226", "#D4AC0D")) +
  theme(legend.position = 'bottom') +
  geom_hline(yintercept = 5, linetype = 'dashed')


## 12. Agregar valor real (autoidentifiación ideológica) al gráfico

table_1 <- table_1 %>%
  rename(id = pid_total) %>% 
  rename(id_NA = media_id,
         id_low = media_id_low,
         id_upp = media_id_upp
         ) %>% 
  mutate(pid_total = 'Autoidentificación de partidarios') %>% 
  select(-media_id_se)

table_3 <- bind_rows(table_1, table_2) %>% 
  mutate(pid_total = factor(pid_total, 
                             levels = c('Autoidentificación de partidarios',
                                        'Frente Amplio',
                                        'Partido Nacional',
                                        'Partido Colorado',
                                        'Cabildo Abierto')))
  

ggplot(data = table_3, aes(x = fct_reorder(id, id_NA), 
                           y = id_NA, color = pid_total)) +
  geom_point(size = 2, position = position_dodge(width = 0.5)) +
  geom_errorbar(aes(ymin = id_low, ymax = id_upp), 
                width = .075, lwd = .75,
                position = position_dodge(width = 0.5)) +
  ylim(2, 11) +
  labs(title = "Percepción ideológica de principales partidos según identificación \n partidaria en Uruguay en 2019.",
       subtitle = "Datos de CSES",
       y = "",
       x = "") +
  theme_bw(base_size=16) +
  scale_color_manual(name = '', values = c('#273746',
                                           '#117A65', '#3498DB',
                                           "#A93226", "#D4AC0D")) +
  theme(legend.position = 'bottom') +
  geom_hline(yintercept = 5, linetype = 'dashed')





