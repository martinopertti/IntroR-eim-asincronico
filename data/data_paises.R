

## Data de países
library(tidyverse)

rm(list=ls())

# Leer data original
dat <- readxl::read_excel("data/wb_paises_original.xlsx") %>% 
  janitor::clean_names() %>% 
  select(-series_code)
  
glimpse(dat)

# Pasar a formato long
dat_long <- dat %>% 
  pivot_longer(cols = x1978_yr1978:x2018_yr2018,
               names_to = "fecha",
               values_to = "valor") %>% 
  mutate(fecha = case_when(
    fecha == "x1978_yr1978" ~ 1978,
    fecha == "x1988_yr1988" ~ 1988,
    fecha == "x1998_yr1998" ~ 1998,
    fecha == "x2008_yr2008" ~ 2008,
    fecha == "x2018_yr2018" ~ 2018
  ))

glimpse(dat_long)

# Pasar a formato wide solo 2018
dat_wide <- dat_long %>% 
  # filter(fecha == 2018) %>% 
  mutate(valor = as.numeric(valor)) %>% 
  pivot_wider(names_from = "series_name",
              values_from = "valor") %>% 
  janitor::clean_names() %>% 
  select(-emisiones_de_co2_kt) %>% 
  rename(acceso_electricidad = acceso_a_la_electricidad_percent_de_poblacion,
         tasa_desempleo = desempleo_total_percent_de_la_poblacion_activa_total_estimacion_modelado_oit,
         gasto_militar = gasto_militar_percent_del_pib,
         gasto_id = gasto_en_investigacion_y_desarrollo_percent_del_pib,
         gasto_salud = current_health_expenditure_percent_of_gdp,
         poblacion_crecimiento = crecimiento_de_la_poblacion_percent_anual,
         area_selvatica = area_selvatica_kilometros_cuadrados,
         area_total = area_de_tierra_kilometros_cuadrados,
         co2_pc = emisiones_de_co2_toneladas_metricas_per_capita,
         poblacion_ciudad = poblacion_de_la_ciudad_con_mas_habitantes,
         gasto_educacion = gasto_publico_en_educacion_total_percent_del_pib,
         pib = pib_us_a_precios_constantes_de_2010, 
         pib_pc = pib_per_capita_us_a_precios_constantes_de_2010
         )

glimpse(dat_wide)

# .csv
write_csv(dat_wide, "data/wb_paises_completa.csv")



# Filtrar 2018
dat_wide <- dat_wide %>% 
  filter(fecha == 2018)

# Countries metadata
meta <- readxl::read_excel("data/wb_paises_metadata.xlsx",
                           sheet = 2) %>% 
  janitor::clean_names() %>% 
  select(code, income_group, region)

glimpse(meta)


# Left join metadata
dat_wide <- dat_wide %>% 
  left_join(meta, by = c("country_code" = "code")) %>% 
  relocate(country_name, country_code, income_group, region)

glimpse(dat_wide)


## Guardar data en todos los fromatos

# .csv
write_csv(dat_wide, "data/wb_paises.csv")

# Stata
haven::write_dta(dat_wide, "data/wb_paises.dta")

# R
write_rds(dat_wide, "data/wb_paises.rds")

