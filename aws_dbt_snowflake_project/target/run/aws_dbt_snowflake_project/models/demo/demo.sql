
  create or replace   view AIRBNB.dbt_schema.demo
  
  
  
  
  as (
    select * from airbnb.staging.listings
  );

