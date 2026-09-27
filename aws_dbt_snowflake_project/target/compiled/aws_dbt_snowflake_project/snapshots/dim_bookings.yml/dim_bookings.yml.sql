with __dbt__cte__bookings as (


WITH bookings as (
    select 
        BOOKING_ID,
        BOOKING_DATE,
        BOOKING_STATUS,
        CREATED_AT

    fromAIRBNB.gold.obt
)
SELECT * FROM bookings
) select * from __dbt__cte__bookings