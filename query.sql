## 1) Realizar média ponderada por SQL

select 
  date,
  country_name,
  sum(new_confirmed)
from `bigquery-public-data.covid19_open_data_eu.covid19_open_data`
  where 
    country_name in ('Brazil') and new_confirmed != 0
    and date between '2021-01-01' and '2021-03-01'
group by date, country_name
order by date;
  
## 2) Qual é o pais que teve mais casos confirmados no dia 18/08/2020.

select
  country_name,
  date,
  sum(new_confirmed) as confirmed
from `bigquery-public-data.covid19_open_data_eu.covid19_open_data`
  where 
    date = '2020-08-18' and new_confirmed != 0 
group by country_name, date
order by 3
desc limit 1;
  
## 3) Trazer uma coluna com relação dos paises e outra com os casos ordenado do maior pro menor

select
  country_name,
  sum(new_confirmed) as confirmed
from `bigquery-public-data.covid19_open_data_eu.covid19_open_data`
  where 
    new_confirmed != 0
group by country_name
order by 2 desc;
  
## 4) Por pais trazer o indice de mortos pela população, mortos por genero, casos por população e casos por genero.

select
  country_name,
  round(((max(population)/sum(new_deceased))), 3) as death_per_population,
  round(((max(population_male)/sum(new_deceased))), 2) as death_per_male,
  round(((max(population_female)/sum(new_deceased))), 2) as death_per_famale,
  round(((max(population)/max(cumulative_confirmed))), 3) as case_per_population,
  max(population) as population,
  max(cumulative_deceased) as death,
  max(cumulative_confirmed) as cumulative_confirmed
from `bigquery-public-data.covid19_open_data_eu.covid19_open_data`
  where 
    new_deceased != 0 and
    population != 0
group by 1 
order by country_name;
  
## 5) Temperatura mínima e a máxima por pais em fahrenheit

select
  country_name,
  round((max(maximum_temperature_celsius)*1.8+32), 2) as temperature_max,
  round((min(minimum_temperature_celsius)*1.8+32), 2) as temperature_min,
from `bigquery-public-data.covid19_open_data_eu.covid19_open_data`
group by 1
order by 1;

## 6) Trazer a quantidade de morte nos EUA no dia 25/12/2020

select
  country_name,
  date,
  sum(new_deceased) as new_death
from `bigquery-public-data.covid19_open_data_eu.covid19_open_data`
  where
    date = '2020-12-25' and
    country_name = 'United States of America'
group by 1, 2;
    
## 7) A quantidade de confirmados em países que tem temperatura mínima média de 30 graus no mês de dezembro
### com as duas formas usadas nenhuma retornou resultado quando a temperatura mínima em 30 graus, mas retorna resultados em temperaturas mais baixas. Lembrando que a segunda é apenas para testar a lógica de outra forma, não fazendo parte do exercício.

select
  country_name,
  round(sum(minimum_temperature_celsius)/count(country_name), 1) as celsius,
  sum(new_confirmed) as confirmed,
  date
from `bigquery-public-data.covid19_open_data_eu.covid19_open_data`
  where   
    date = '2020-12-31' and
    minimum_temperature_celsius between 15 and 21
    and new_confirmed != 0
group by 1, 4
order by 1;

### teste de lógica
select
  country_name,
  round(sum(minimum_temperature_celsius)/count(country_name), 2),
  date
from `bigquery-public-data.covid19_open_data_eu.covid19_open_data`
  where 
    minimum_temperature_celsius between 30 and 31
    and date = '2020-12-31'
group by 1, 3;
  
## 8) Quantos paises diferentes temos nesta planilha?

select 
  count(distinct country_name)
from `bigquery-public-data.covid19_open_data_eu.covid19_open_data`;
   
## 9) Quais são os paises?

select
  distinct country_name
from `bigquery-public-data.covid19_open_data_eu.covid19_open_data`
order by 1;
  
## 10) Relação dos paises, com uma classificação de expectativa de vida de menos de 50 anos, outro de 50 - 65 anos, 65 a 80 e acima de 80

select
  country_name,
  case when max(cast(life_expectancy as numeric)) < 50 then 'Até 50 anos'
       when max(cast(life_expectancy as numeric)) between 50 and 65 then 'Entre 50 e 65 anos' 
       when max(cast(life_expectancy as numeric)) between 65 and 80 then 'Entre 65 e 80' 
       when max(cast(life_expectancy as numeric)) > 80 then 'Acima de 80' end  
from `bigquery-public-data.covid19_open_data_eu.covid19_open_data`
group by 1
order by 2 desc;

## 11) Relação de mortes por renda per capita para cada pais
### considerei mortes por covid
### a muitas entradas de per capita dando imprecisão ao calculo per capita

select
  country_name,
  round(max(cumulative_deceased)/(avg(gdp_per_capita_usd)), 3) as death_per_capita,
  round(avg(gdp_per_capita_usd), 0) as per_capita,
from `bigquery-public-data.covid19_open_data_eu.covid19_open_data`
  where
    new_deceased != 0 and
    gdp_per_capita_usd != 0
group by 1
order by 3 desc;


## 12) Relação de mortes por quantidade de vacinados em cada pais
### considerei mortes por covid
### explicação do resultado: a cada xxx vacinados tem uma morte

select
  country_name,
  max(cumulative_persons_fully_vaccinated) as fully_vaccinated,
  round(((max(cumulative_persons_fully_vaccinated)/max(cumulative_deceased))), 0) as death_per_population_fully_vaccinated,
from `bigquery-public-data.covid19_open_data_eu.covid19_open_data`
group by 1
order by 3 desc;
